-- DCIM Ontology minimal demo schema.
-- PostgreSQL 15+ recommended.

create table datacenter (
  id text primary key,
  name text not null,
  code text not null unique,
  address text,
  area_sqm numeric(12, 2),
  lifecycle_status text not null check (lifecycle_status in ('active', 'maintenance', 'offline')),
  description text,
  contact text,
  phone text,
  source_system text not null default 'mock',
  created_at timestamptz not null,
  updated_at timestamptz not null
);

create table ontology_individual (
  id text primary key,
  ontology_class text not null,
  source_table text not null,
  source_id text not null,
  label text,
  source_system text not null default 'mock',
  created_at timestamptz not null default now(),
  unique (source_table, source_id, ontology_class)
);

create table ontology_relationship (
  id text primary key,
  relationship_type text not null,
  source_individual_id text not null references ontology_individual(id),
  target_individual_id text not null references ontology_individual(id),
  fact_table text,
  fact_id text,
  valid_from timestamptz not null default now(),
  valid_to timestamptz,
  source_system text not null default 'mock',
  confidence numeric(4, 3) not null default 1.0 check (confidence >= 0 and confidence <= 1),
  check (source_individual_id <> target_individual_id)
);

create table cabinet (
  id text primary key,
  datacenter_id text not null references datacenter(id),
  name text not null,
  code text not null,
  row_no integer not null check (row_no > 0),
  column_no integer not null check (column_no > 0),
  u_height integer not null check (u_height > 0),
  max_power_w numeric(12, 2) check (max_power_w >= 0),
  health_status text not null check (health_status in ('normal', 'warning', 'error', 'offline')),
  description text,
  source_system text not null default 'mock',
  created_at timestamptz not null,
  updated_at timestamptz not null,
  unique (datacenter_id, code),
  unique (datacenter_id, row_no, column_no)
);

create table device_template (
  id text primary key,
  name text not null,
  category text not null check (category in ('switch', 'router', 'server', 'storage', 'firewall', 'loadbalancer', 'pdu', 'other')),
  brand text not null,
  model text not null,
  u_height integer not null check (u_height > 0),
  front_color text,
  rear_color text,
  model3d_url text,
  image_url text,
  is_builtin boolean not null default false,
  max_power_w numeric(12, 2) check (max_power_w >= 0),
  spec_json jsonb not null default '{}'::jsonb,
  description text,
  source_system text not null default 'mock',
  created_at timestamptz not null,
  updated_at timestamptz not null
);

create table port_group_template (
  id text not null,
  template_id text not null references device_template(id),
  name text not null,
  port_type text not null check (port_type in ('RJ45', 'SFP', 'SFP+', 'QSFP+', 'QSFP28', 'FC', 'USB', 'Console', 'Power')),
  port_count integer not null check (port_count > 0),
  speed text not null check (speed in ('100M', '1G', '10G', '25G', '40G', '100G', 'N/A')),
  poe boolean not null default false,
  primary key (template_id, id)
);

create table device (
  id text primary key,
  template_id text not null references device_template(id),
  asset_code text not null unique,
  name text not null,
  serial_number text,
  management_ip inet,
  operational_status text not null check (operational_status in ('online', 'offline', 'warning', 'error', 'maintenance')),
  purchase_date date,
  warranty_expiry date,
  vendor text,
  owner text,
  department text,
  description text,
  source_system text not null default 'mock',
  created_at timestamptz not null,
  updated_at timestamptz not null
);

create table pdu (
  id text primary key,
  template_id text references device_template(id),
  cabinet_id text references cabinet(id),
  name text not null,
  asset_code text not null unique,
  management_ip inet,
  power_path text not null check (power_path in ('A', 'B', 'unknown')),
  input_voltage numeric(10, 2),
  output_ports integer check (output_ports >= 0),
  max_load_w numeric(12, 2) check (max_load_w >= 0),
  current_load_w numeric(12, 2) check (current_load_w >= 0),
  brand text,
  model text,
  operational_status text not null check (operational_status in ('online', 'offline', 'warning', 'error', 'maintenance')),
  source_system text not null default 'mock',
  created_at timestamptz not null,
  updated_at timestamptz not null
);

create table rack_installation (
  id bigserial primary key,
  asset_type text not null check (asset_type in ('device', 'pdu')),
  device_id text references device(id),
  pdu_id text references pdu(id),
  cabinet_id text not null references cabinet(id),
  start_u integer not null check (start_u > 0),
  end_u integer not null check (end_u >= start_u),
  valid_from timestamptz not null default now(),
  valid_to timestamptz,
  source_system text not null default 'mock',
  confidence numeric(4, 3) not null default 1.0 check (confidence >= 0 and confidence <= 1),
  check (
    (asset_type = 'device' and device_id is not null and pdu_id is null)
    or
    (asset_type = 'pdu' and pdu_id is not null and device_id is null)
  )
);

create table port (
  id text primary key,
  device_id text not null references device(id),
  port_group_id text not null,
  port_number text not null,
  port_alias text,
  port_type text not null check (port_type in ('RJ45', 'SFP', 'SFP+', 'QSFP+', 'QSFP28', 'FC', 'USB', 'Console', 'Power')),
  speed text not null check (speed in ('100M', '1G', '10G', '25G', '40G', '100G', 'N/A')),
  admin_status text not null check (admin_status in ('up', 'down', 'disabled', 'error')),
  link_status text not null check (link_status in ('connected', 'disconnected')),
  vlan_config jsonb,
  qos_config jsonb,
  mac_bindings text[],
  port_security boolean,
  max_mac_count integer,
  dot1x_enabled boolean,
  connection_purpose text,
  description text,
  last_updated timestamptz not null,
  unique (device_id, port_number)
);

create table cable_connection (
  id text primary key,
  cable_number text not null unique,
  connection_type text not null check (connection_type in ('network', 'power', 'management', 'storage', 'stack')),
  cable_type text not null check (cable_type in ('Cat5e', 'Cat6', 'Cat6a', 'Cat7', 'SingleModeFiber', 'MultiModeFiber', 'DAC', 'AOC', 'PowerCable')),
  cable_color text,
  cable_length_m numeric(10, 2) check (cable_length_m >= 0),
  source_device_id text not null references device(id),
  source_port_id text not null references port(id),
  target_device_id text not null references device(id),
  target_port_id text not null references port(id),
  status text not null check (status in ('active', 'inactive', 'faulty')),
  description text,
  source_system text not null default 'mock',
  created_at timestamptz not null,
  updated_at timestamptz not null,
  check (source_port_id <> target_port_id)
);
+

create or replace function enforce_cable_connection_port_occupancy()
returns trigger
language plpgsql
as $$
declare
  conflicting_connection_id text;
  conflicting_cable_number text;
  occupied_port_id text;
begin
  perform pg_advisory_xact_lock(
    hashtextextended(least(new.source_port_id, new.target_port_id), 0)
  );
  perform pg_advisory_xact_lock(
    hashtextextended(greatest(new.source_port_id, new.target_port_id), 0)
  );

  execute format(
    'select id, cable_number,
       case when source_port_id in ($2, $3) then source_port_id else target_port_id end
     from %I.cable_connection
     where id <> $1
       and (
         source_port_id in ($2, $3)
         or target_port_id in ($2, $3)
       )
     order by created_at, id
     limit 1',
    tg_table_schema
  )
  into conflicting_connection_id, conflicting_cable_number, occupied_port_id
  using new.id, new.source_port_id, new.target_port_id;

  if conflicting_connection_id is not null then
    raise exception using
      errcode = '23505',
      constraint = 'cable_connection_port_occupancy',
      message = format(
        '端口 %s 已被连线 %s（%s）占用',
        occupied_port_id,
        conflicting_cable_number,
        conflicting_connection_id
      );
  end if;

  return new;
end;
$$;

create trigger cable_connection_port_occupancy
before insert or update of source_port_id, target_port_id
on cable_connection
for each row
execute function enforce_cable_connection_port_occupancy();

create table power_node (
  id text primary key,
  datacenter_id text not null references datacenter(id),
  node_type text not null check (node_type in ('utility', 'ups', 'pdu', 'device')),
  name text not null,
  status text not null check (status in ('online', 'offline', 'warning', 'error', 'maintenance')),
  load_w numeric(12, 2),
  capacity_w numeric(12, 2),
  source_system text not null default 'mock'
);

create table power_connection (
  id text primary key,
  datacenter_id text not null references datacenter(id),
  source_node_id text not null references power_node(id),
  target_node_id text not null references power_node(id),
  target_node_type text not null check (target_node_type in ('utility', 'ups', 'pdu', 'device')),
  power_path text not null check (power_path in ('A', 'B', 'unknown')),
  status text not null check (status in ('active', 'inactive', 'faulty')),
  valid_from timestamptz not null default now(),
  valid_to timestamptz,
  source_system text not null default 'mock',
  confidence numeric(4, 3) not null default 1.0 check (confidence >= 0 and confidence <= 1),
  check (source_node_id <> target_node_id)
);

create table observation (
  id text primary key,
  target_type text not null check (target_type in ('datacenter', 'cabinet', 'device', 'pdu', 'port')),
  target_id text not null,
  sensor_id text,
  sensor_position text,
  metric text not null,
  value_num numeric(14, 4) not null,
  unit text not null,
  observed_at timestamptz not null,
  source_system text not null default 'mock',
  confidence numeric(4, 3) not null default 1.0 check (confidence >= 0 and confidence <= 1)
);

create table pue_daily (
  datacenter_id text not null references datacenter(id),
  metric_date date not null,
  pue numeric(6, 3) not null,
  it_power_kw numeric(12, 3) not null,
  total_power_kw numeric(12, 3) not null,
  cooling_power_kw numeric(12, 3) not null,
  source_system text not null default 'mock',
  primary key (datacenter_id, metric_date)
);

create table alert_rule (
  id text primary key,
  name text not null,
  rule_type text not null check (rule_type in ('temperature', 'humidity', 'power', 'device_status', 'port_status', 'capacity')),
  enabled boolean not null default true,
  condition_json jsonb not null,
  severity text not null check (severity in ('info', 'warning', 'error', 'critical')),
  notification_json jsonb not null default '{}'::jsonb,
  scope_json jsonb,
  source_system text not null default 'mock',
  created_at timestamptz not null,
  updated_at timestamptz not null
);

create table alert_event (
  id text primary key,
  level text not null check (level in ('info', 'warning', 'error', 'critical')),
  alert_type text not null,
  source text not null check (source in ('manual', 'system', 'rule')),
  rule_id text references alert_rule(id),
  device_id text references device(id),
  cabinet_id text references cabinet(id),
  datacenter_id text references datacenter(id),
  message text not null,
  value_num numeric(14, 4),
  threshold_num numeric(14, 4),
  acknowledged boolean not null default false,
  acknowledged_at timestamptz,
  acknowledged_by text,
  resolved_at timestamptz,
  resolved_by text,
  notes text,
  created_at timestamptz not null
);

create table layout_snapshot (
  datacenter_id text primary key references datacenter(id),
  version integer not null,
  canvas_width numeric(12, 2) not null,
  canvas_height numeric(12, 2) not null,
  px_per_meter numeric(12, 2) not null,
  raw_json jsonb not null,
  updated_at timestamptz not null
);

create table layout_cabinet_position (
  datacenter_id text not null references datacenter(id),
  cabinet_id text not null references cabinet(id),
  x numeric(12, 3) not null,
  y numeric(12, 3) not null,
  rotation numeric(12, 3),
  primary key (datacenter_id, cabinet_id)
);

create table layout_zone (
  id text primary key,
  datacenter_id text not null references datacenter(id),
  zone_type text not null,
  name text,
  x numeric(12, 3) not null,
  y numeric(12, 3) not null,
  width numeric(12, 3) not null,
  height numeric(12, 3) not null,
  rotation numeric(12, 3),
  color text
);

create table layout_facility (
  id text primary key,
  datacenter_id text not null references datacenter(id),
  facility_type text not null,
  name text,
  x numeric(12, 3) not null,
  y numeric(12, 3) not null,
  rotation numeric(12, 3)
);

create table dashboard_snapshot (
  id text primary key,
  snapshot_type text not null,
  scope_id text,
  payload jsonb not null,
  captured_at timestamptz not null default now()
);

create table operation_record (
  id text primary key,
  operation_type text not null,
  operator_name text not null,
  target text not null,
  description text,
  created_at timestamptz not null,
  source_system text not null default 'mock'
);

create table topology_snapshot (
  id text primary key,
  datacenter_id text not null references datacenter(id),
  payload jsonb not null,
  captured_at timestamptz not null default now()
);

create table mock_raw_payload (
  id text primary key,
  source_name text not null,
  payload jsonb not null,
  captured_at timestamptz not null default now()
);

create index idx_ontology_individual_class on ontology_individual(ontology_class);
create index idx_ontology_relationship_type on ontology_relationship(relationship_type);
create index idx_cabinet_datacenter on cabinet(datacenter_id);
create index idx_device_template on device(template_id);
create index idx_rack_installation_cabinet on rack_installation(cabinet_id);
create index idx_port_device on port(device_id);
create index idx_cable_connection_source_port on cable_connection(source_port_id);
create index idx_cable_connection_target_port on cable_connection(target_port_id);
create index idx_power_connection_source on power_connection(source_node_id);
create index idx_power_connection_target on power_connection(target_node_id);
create index idx_observation_target_metric_time on observation(target_type, target_id, metric, observed_at desc);
create index idx_alert_event_scope on alert_event(datacenter_id, cabinet_id, device_id, created_at desc);
