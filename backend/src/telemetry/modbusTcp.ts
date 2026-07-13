import net from 'node:net';

export interface ModbusTcpEndpoint {
  host: string;
  port: number;
  unitId: number;
  timeoutMs: number;
}

let nextTransactionId = 1;

const createReadRequest = (
  endpoint: ModbusTcpEndpoint,
  functionCode: 1 | 3,
  address: number,
  quantity: number,
) => {
  const transactionId = nextTransactionId;
  nextTransactionId = nextTransactionId >= 0xffff ? 1 : nextTransactionId + 1;

  const request = Buffer.alloc(12);
  request.writeUInt16BE(transactionId, 0);
  request.writeUInt16BE(0, 2);
  request.writeUInt16BE(6, 4);
  request.writeUInt8(endpoint.unitId, 6);
  request.writeUInt8(functionCode, 7);
  request.writeUInt16BE(address, 8);
  request.writeUInt16BE(quantity, 10);

  return { request, transactionId };
};

const readResponse = (
  endpoint: ModbusTcpEndpoint,
  functionCode: 1 | 3,
  address: number,
  quantity: number,
) =>
  new Promise<Buffer>((resolve, reject) => {
    const { request, transactionId } = createReadRequest(
      endpoint,
      functionCode,
      address,
      quantity,
    );
    const socket = net.createConnection({ host: endpoint.host, port: endpoint.port });
    let response = Buffer.alloc(0);
    let settled = false;

    const finish = (error?: Error, frame?: Buffer) => {
      if (settled) return;
      settled = true;
      socket.destroy();
      if (error) reject(error);
      else resolve(frame as Buffer);
    };

    socket.setTimeout(endpoint.timeoutMs);

    socket.once('connect', () => {
      socket.write(request);
    });

    socket.on('data', (chunk) => {
      response = Buffer.concat([response, chunk]);
      if (response.length < 6) return;

      const payloadLength = response.readUInt16BE(4);
      const frameLength = 6 + payloadLength;
      if (response.length < frameLength) return;

      const frame = response.subarray(0, frameLength);
      if (frame.readUInt16BE(0) !== transactionId) {
        finish(new Error('Modbus transaction ID mismatch'));
        return;
      }
      if (frame.readUInt16BE(2) !== 0) {
        finish(new Error('Unsupported Modbus protocol ID'));
        return;
      }
      if (frame.readUInt8(6) !== endpoint.unitId) {
        finish(new Error('Modbus unit ID mismatch'));
        return;
      }

      const responseFunctionCode = frame.readUInt8(7);
      if (responseFunctionCode === (functionCode | 0x80)) {
        finish(new Error(`Modbus exception code ${frame.readUInt8(8)}`));
        return;
      }
      if (responseFunctionCode !== functionCode) {
        finish(new Error(`Unexpected Modbus function code ${responseFunctionCode}`));
        return;
      }

      finish(undefined, frame);
    });

    socket.once('timeout', () => {
      finish(
        new Error(
          `Modbus request timed out after ${endpoint.timeoutMs}ms (${endpoint.host}:${endpoint.port})`,
        ),
      );
    });
    socket.once('error', (error) => finish(error));
    socket.once('close', () => {
      if (!settled) finish(new Error('Modbus connection closed before a complete response'));
    });
  });

export const readHoldingRegisters = async (
  endpoint: ModbusTcpEndpoint,
  address: number,
  quantity: number,
) => {
  const frame = await readResponse(endpoint, 3, address, quantity);
  const byteCount = frame.readUInt8(8);
  if (byteCount !== quantity * 2 || frame.length < 9 + byteCount) {
    throw new Error(
      `Invalid FC03 byte count: expected ${quantity * 2}, received ${byteCount}`,
    );
  }

  return Array.from({ length: quantity }, (_, index) => frame.readUInt16BE(9 + index * 2));
};

export const readCoils = async (
  endpoint: ModbusTcpEndpoint,
  address: number,
  quantity: number,
) => {
  const frame = await readResponse(endpoint, 1, address, quantity);
  const byteCount = frame.readUInt8(8);
  const expectedByteCount = Math.ceil(quantity / 8);
  if (byteCount !== expectedByteCount || frame.length < 9 + byteCount) {
    throw new Error(
      `Invalid FC01 byte count: expected ${expectedByteCount}, received ${byteCount}`,
    );
  }

  return Array.from({ length: quantity }, (_, index) => {
    const value = frame.readUInt8(9 + Math.floor(index / 8));
    return ((value >> (index % 8)) & 1) === 1;
  });
};
