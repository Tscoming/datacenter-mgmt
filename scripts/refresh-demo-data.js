const { spawnSync } = require('node:child_process');
const fs = require('node:fs');
const path = require('node:path');

const projectRoot = path.resolve(__dirname, '..');
const outputFile = path.join(
  projectRoot,
  'design',
  'data-model',
  'generated-mock-migration.sql',
);
const envFile = path.join(projectRoot, '.env');
const targetSchemaPlaceholder = '__DCIM_TARGET_SCHEMA__';

main();

function main() {
  let temporaryFile;
  let outputFd;

  try {
    const databaseEnv = loadDatabaseEnv();
    const sourceSchema = databaseEnv.PGSCHEMA;
    const dumpArgs = [
      '--host',
      databaseEnv.PGHOST,
      '--port',
      databaseEnv.PGPORT,
      '--username',
      databaseEnv.PGUSER,
      '--dbname',
      databaseEnv.PGDATABASE,
      '--schema',
      sourceSchema,
      '--clean',
      '--if-exists',
      '--no-owner',
      '--no-privileges',
    ];
    const dumpCommand = getDumpCommand(dumpArgs);
    temporaryFile = `${outputFile}.${process.pid}.tmp`;
    outputFd = fs.openSync(temporaryFile, 'wx');
    const result = spawnSync(
      dumpCommand.command,
      dumpCommand.args,
      {
        cwd: projectRoot,
        env: { ...process.env, ...databaseEnv },
        stdio: ['ignore', outputFd, 'inherit'],
        windowsHide: true,
      },
    );

    fs.closeSync(outputFd);
    outputFd = undefined;

    if (result.error) {
      if (result.error.code === 'ENOENT') {
        throw new Error(`${dumpCommand.command} was not found`);
      }
      throw result.error;
    }
    if (result.status !== 0) {
      throw new Error(`pg_dump exited with code ${result.status}`);
    }

    validateDump(temporaryFile, sourceSchema);
    rewriteDumpSchema(temporaryFile, sourceSchema, targetSchemaPlaceholder);
    validateDump(temporaryFile, targetSchemaPlaceholder);
    fs.renameSync(temporaryFile, outputFile);
    console.log(
      `Refreshed ${path.relative(projectRoot, outputFile)} from ${databaseEnv.PGDATABASE}.${sourceSchema}; the target schema will be selected during Docker Compose initialization`,
    );
  } catch (error) {
    console.error(`Failed to refresh demo data: ${error.message}`);
    process.exitCode = 1;
  } finally {
    if (outputFd !== undefined) {
      fs.closeSync(outputFd);
    }
    if (temporaryFile) {
      fs.rmSync(temporaryFile, { force: true });
    }
  }
}

function getDumpCommand(dumpArgs) {
  const localPgDump = spawnSync('pg_dump', ['--version'], {
    stdio: 'ignore',
    windowsHide: true,
  });

  if (!localPgDump.error && localPgDump.status === 0) {
    return { command: 'pg_dump', args: dumpArgs };
  }
  if (localPgDump.error && localPgDump.error.code !== 'ENOENT') {
    throw localPgDump.error;
  }

  console.log('Local pg_dump was not found; using postgres:18-alpine via Docker.');
  return {
    command: 'docker',
    args: [
      'run',
      '--rm',
      '-e',
      'PGHOST',
      '-e',
      'PGPORT',
      '-e',
      'PGDATABASE',
      '-e',
      'PGUSER',
      '-e',
      'PGPASSWORD',
      'postgres:18-alpine',
      'pg_dump',
      ...dumpArgs,
    ],
  };
}

function loadDatabaseEnv() {
  if (!fs.existsSync(envFile)) {
    throw new Error(`Environment file not found: ${envFile}`);
  }

  const values = {};
  for (const line of fs.readFileSync(envFile, 'utf8').split(/\r?\n/)) {
    const parsed = parseEnvLine(line);
    if (parsed) {
      values[parsed.key] = parsed.value;
    }
  }

  const requiredKeys = ['PGHOST', 'PGPORT', 'PGDATABASE', 'PGUSER', 'PGPASSWORD', 'PGSCHEMA'];
  for (const key of requiredKeys) {
    if (!values[key]) {
      throw new Error(`Missing ${key} in ${envFile}`);
    }
  }

  return values;
}

function parseEnvLine(line) {
  const trimmed = line.trim();
  if (!trimmed || trimmed.startsWith('#')) {
    return null;
  }

  const separator = trimmed.indexOf('=');
  if (separator < 0) {
    return null;
  }

  const key = trimmed.slice(0, separator).trim();
  let value = trimmed.slice(separator + 1).trim();
  if (
    (value.startsWith('"') && value.endsWith('"')) ||
    (value.startsWith("'") && value.endsWith("'"))
  ) {
    value = value.slice(1, -1);
  }

  return key ? { key, value } : null;
}

function rewriteDumpSchema(file, sourceSchema, targetSchema) {
  assertSchemaName(sourceSchema, 'PGSCHEMA');

  const sourceIdentifiers = [sourceSchema, quoteIdentifier(sourceSchema)];
  const targetIdentifier = quoteIdentifier(targetSchema);
  let inCopyData = false;
  const sql = fs
    .readFileSync(file, 'utf8')
    .split(/(?<=\n)/)
    .map((line) => {
      if (inCopyData) {
        if (line.trim() === '\\.') {
          inCopyData = false;
        }
        return line;
      }

      let rewrittenLine = line;
      for (const sourceIdentifier of sourceIdentifiers) {
        rewrittenLine = rewrittenLine.replaceAll(
          `${sourceIdentifier}.`,
          `${targetIdentifier}.`,
        );
        rewrittenLine = rewrittenLine.replaceAll(
          `SCHEMA ${sourceIdentifier};`,
          `SCHEMA ${targetIdentifier};`,
        );
        rewrittenLine = rewrittenLine.replaceAll(
          `SCHEMA IF EXISTS ${sourceIdentifier};`,
          `SCHEMA IF EXISTS ${targetIdentifier};`,
        );
      }
      if (/^COPY .+ FROM stdin;\r?\n?$/.test(rewrittenLine)) {
        inCopyData = true;
      }
      return rewrittenLine;
    })
    .join('');

  fs.writeFileSync(file, `${sql.trimEnd()}\n`);
}

function assertSchemaName(schema, envKey) {
  if (!/^[A-Za-z_][A-Za-z0-9_]*$/.test(schema)) {
    throw new Error(`Invalid ${envKey}: ${schema}`);
  }
}

function quoteIdentifier(identifier) {
  return `"${identifier.replaceAll('"', '""')}"`;
}

function validateDump(file, schema) {
  const sql = fs.readFileSync(file, 'utf8');
  const identifiers = [schema, quoteIdentifier(schema)];
  const hasSchema = identifiers.some((identifier) =>
    sql.includes(`CREATE SCHEMA ${identifier};`),
  );
  const hasCopy = identifiers.some((identifier) => sql.includes(`COPY ${identifier}.`));
  if (!hasSchema || !hasCopy) {
    throw new Error('pg_dump output is incomplete; the existing demo SQL was not changed');
  }
}
