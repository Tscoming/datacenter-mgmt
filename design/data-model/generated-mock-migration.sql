--
-- PostgreSQL database dump
--

\restrict NIBP2xPcOawd2e9wWzdstLSYU40lX6WzsItu8UdtKs29ZNAsnglKZMP2pBdekd1

-- Dumped from database version 18.4 (Debian 18.4-1.pgdg13+1)
-- Dumped by pg_dump version 18.4

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

ALTER TABLE IF EXISTS ONLY "__DCIM_TARGET_SCHEMA__".topology_snapshot DROP CONSTRAINT IF EXISTS topology_snapshot_datacenter_id_fkey;
ALTER TABLE IF EXISTS ONLY "__DCIM_TARGET_SCHEMA__".rack_installation DROP CONSTRAINT IF EXISTS rack_installation_pdu_id_fkey;
ALTER TABLE IF EXISTS ONLY "__DCIM_TARGET_SCHEMA__".rack_installation DROP CONSTRAINT IF EXISTS rack_installation_device_id_fkey;
ALTER TABLE IF EXISTS ONLY "__DCIM_TARGET_SCHEMA__".rack_installation DROP CONSTRAINT IF EXISTS rack_installation_cabinet_id_fkey;
ALTER TABLE IF EXISTS ONLY "__DCIM_TARGET_SCHEMA__".pue_daily DROP CONSTRAINT IF EXISTS pue_daily_datacenter_id_fkey;
ALTER TABLE IF EXISTS ONLY "__DCIM_TARGET_SCHEMA__".power_node DROP CONSTRAINT IF EXISTS power_node_datacenter_id_fkey;
ALTER TABLE IF EXISTS ONLY "__DCIM_TARGET_SCHEMA__".power_connection DROP CONSTRAINT IF EXISTS power_connection_target_node_id_fkey;
ALTER TABLE IF EXISTS ONLY "__DCIM_TARGET_SCHEMA__".power_connection DROP CONSTRAINT IF EXISTS power_connection_source_node_id_fkey;
ALTER TABLE IF EXISTS ONLY "__DCIM_TARGET_SCHEMA__".power_connection DROP CONSTRAINT IF EXISTS power_connection_datacenter_id_fkey;
ALTER TABLE IF EXISTS ONLY "__DCIM_TARGET_SCHEMA__".port_group_template DROP CONSTRAINT IF EXISTS port_group_template_template_id_fkey;
ALTER TABLE IF EXISTS ONLY "__DCIM_TARGET_SCHEMA__".port DROP CONSTRAINT IF EXISTS port_device_id_fkey;
ALTER TABLE IF EXISTS ONLY "__DCIM_TARGET_SCHEMA__".pdu DROP CONSTRAINT IF EXISTS pdu_template_id_fkey;
ALTER TABLE IF EXISTS ONLY "__DCIM_TARGET_SCHEMA__".pdu DROP CONSTRAINT IF EXISTS pdu_cabinet_id_fkey;
ALTER TABLE IF EXISTS ONLY "__DCIM_TARGET_SCHEMA__".ontology_relationship DROP CONSTRAINT IF EXISTS ontology_relationship_target_individual_id_fkey;
ALTER TABLE IF EXISTS ONLY "__DCIM_TARGET_SCHEMA__".ontology_relationship DROP CONSTRAINT IF EXISTS ontology_relationship_source_individual_id_fkey;
ALTER TABLE IF EXISTS ONLY "__DCIM_TARGET_SCHEMA__".layout_zone DROP CONSTRAINT IF EXISTS layout_zone_datacenter_id_fkey;
ALTER TABLE IF EXISTS ONLY "__DCIM_TARGET_SCHEMA__".layout_snapshot DROP CONSTRAINT IF EXISTS layout_snapshot_datacenter_id_fkey;
ALTER TABLE IF EXISTS ONLY "__DCIM_TARGET_SCHEMA__".layout_facility DROP CONSTRAINT IF EXISTS layout_facility_datacenter_id_fkey;
ALTER TABLE IF EXISTS ONLY "__DCIM_TARGET_SCHEMA__".layout_cabinet_position DROP CONSTRAINT IF EXISTS layout_cabinet_position_datacenter_id_fkey;
ALTER TABLE IF EXISTS ONLY "__DCIM_TARGET_SCHEMA__".layout_cabinet_position DROP CONSTRAINT IF EXISTS layout_cabinet_position_cabinet_id_fkey;
ALTER TABLE IF EXISTS ONLY "__DCIM_TARGET_SCHEMA__".device DROP CONSTRAINT IF EXISTS device_template_id_fkey;
ALTER TABLE IF EXISTS ONLY "__DCIM_TARGET_SCHEMA__".cable_connection DROP CONSTRAINT IF EXISTS cable_connection_target_port_id_fkey;
ALTER TABLE IF EXISTS ONLY "__DCIM_TARGET_SCHEMA__".cable_connection DROP CONSTRAINT IF EXISTS cable_connection_target_device_id_fkey;
ALTER TABLE IF EXISTS ONLY "__DCIM_TARGET_SCHEMA__".cable_connection DROP CONSTRAINT IF EXISTS cable_connection_source_port_id_fkey;
ALTER TABLE IF EXISTS ONLY "__DCIM_TARGET_SCHEMA__".cable_connection DROP CONSTRAINT IF EXISTS cable_connection_source_device_id_fkey;
ALTER TABLE IF EXISTS ONLY "__DCIM_TARGET_SCHEMA__".cabinet_telemetry_source DROP CONSTRAINT IF EXISTS cabinet_telemetry_source_cabinet_id_fkey;
ALTER TABLE IF EXISTS ONLY "__DCIM_TARGET_SCHEMA__".cabinet DROP CONSTRAINT IF EXISTS cabinet_datacenter_id_fkey;
ALTER TABLE IF EXISTS ONLY "__DCIM_TARGET_SCHEMA__".alert_event DROP CONSTRAINT IF EXISTS alert_event_rule_id_fkey;
ALTER TABLE IF EXISTS ONLY "__DCIM_TARGET_SCHEMA__".alert_event DROP CONSTRAINT IF EXISTS alert_event_device_id_fkey;
ALTER TABLE IF EXISTS ONLY "__DCIM_TARGET_SCHEMA__".alert_event DROP CONSTRAINT IF EXISTS alert_event_datacenter_id_fkey;
ALTER TABLE IF EXISTS ONLY "__DCIM_TARGET_SCHEMA__".alert_event DROP CONSTRAINT IF EXISTS alert_event_cabinet_id_fkey;
DROP TRIGGER IF EXISTS cable_connection_port_occupancy ON "__DCIM_TARGET_SCHEMA__".cable_connection;
DROP INDEX IF EXISTS "__DCIM_TARGET_SCHEMA__".idx_rack_installation_cabinet;
DROP INDEX IF EXISTS "__DCIM_TARGET_SCHEMA__".idx_power_connection_target;
DROP INDEX IF EXISTS "__DCIM_TARGET_SCHEMA__".idx_power_connection_source;
DROP INDEX IF EXISTS "__DCIM_TARGET_SCHEMA__".idx_port_device;
DROP INDEX IF EXISTS "__DCIM_TARGET_SCHEMA__".idx_ontology_relationship_type;
DROP INDEX IF EXISTS "__DCIM_TARGET_SCHEMA__".idx_ontology_individual_class;
DROP INDEX IF EXISTS "__DCIM_TARGET_SCHEMA__".idx_observation_target_metric_time;
DROP INDEX IF EXISTS "__DCIM_TARGET_SCHEMA__".idx_device_template;
DROP INDEX IF EXISTS "__DCIM_TARGET_SCHEMA__".idx_cable_connection_target_port;
DROP INDEX IF EXISTS "__DCIM_TARGET_SCHEMA__".idx_cable_connection_source_port;
DROP INDEX IF EXISTS "__DCIM_TARGET_SCHEMA__".idx_cabinet_datacenter;
DROP INDEX IF EXISTS "__DCIM_TARGET_SCHEMA__".idx_alert_event_scope;
ALTER TABLE IF EXISTS ONLY "__DCIM_TARGET_SCHEMA__".topology_snapshot DROP CONSTRAINT IF EXISTS topology_snapshot_pkey;
ALTER TABLE IF EXISTS ONLY "__DCIM_TARGET_SCHEMA__".rack_installation DROP CONSTRAINT IF EXISTS rack_installation_pkey;
ALTER TABLE IF EXISTS ONLY "__DCIM_TARGET_SCHEMA__".pue_daily DROP CONSTRAINT IF EXISTS pue_daily_pkey;
ALTER TABLE IF EXISTS ONLY "__DCIM_TARGET_SCHEMA__".power_node DROP CONSTRAINT IF EXISTS power_node_pkey;
ALTER TABLE IF EXISTS ONLY "__DCIM_TARGET_SCHEMA__".power_connection DROP CONSTRAINT IF EXISTS power_connection_pkey;
ALTER TABLE IF EXISTS ONLY "__DCIM_TARGET_SCHEMA__".port DROP CONSTRAINT IF EXISTS port_pkey;
ALTER TABLE IF EXISTS ONLY "__DCIM_TARGET_SCHEMA__".port_group_template DROP CONSTRAINT IF EXISTS port_group_template_pkey;
ALTER TABLE IF EXISTS ONLY "__DCIM_TARGET_SCHEMA__".port DROP CONSTRAINT IF EXISTS port_device_id_port_number_key;
ALTER TABLE IF EXISTS ONLY "__DCIM_TARGET_SCHEMA__".pdu DROP CONSTRAINT IF EXISTS pdu_pkey;
ALTER TABLE IF EXISTS ONLY "__DCIM_TARGET_SCHEMA__".pdu DROP CONSTRAINT IF EXISTS pdu_asset_code_key;
ALTER TABLE IF EXISTS ONLY "__DCIM_TARGET_SCHEMA__".operation_record DROP CONSTRAINT IF EXISTS operation_record_pkey;
ALTER TABLE IF EXISTS ONLY "__DCIM_TARGET_SCHEMA__".ontology_relationship DROP CONSTRAINT IF EXISTS ontology_relationship_pkey;
ALTER TABLE IF EXISTS ONLY "__DCIM_TARGET_SCHEMA__".ontology_individual DROP CONSTRAINT IF EXISTS ontology_individual_source_table_source_id_ontology_class_key;
ALTER TABLE IF EXISTS ONLY "__DCIM_TARGET_SCHEMA__".ontology_individual DROP CONSTRAINT IF EXISTS ontology_individual_pkey;
ALTER TABLE IF EXISTS ONLY "__DCIM_TARGET_SCHEMA__".observation DROP CONSTRAINT IF EXISTS observation_pkey;
ALTER TABLE IF EXISTS ONLY "__DCIM_TARGET_SCHEMA__".mock_raw_payload DROP CONSTRAINT IF EXISTS mock_raw_payload_pkey;
ALTER TABLE IF EXISTS ONLY "__DCIM_TARGET_SCHEMA__".managed_user DROP CONSTRAINT IF EXISTS managed_user_username_key;
ALTER TABLE IF EXISTS ONLY "__DCIM_TARGET_SCHEMA__".managed_user DROP CONSTRAINT IF EXISTS managed_user_pkey;
ALTER TABLE IF EXISTS ONLY "__DCIM_TARGET_SCHEMA__".managed_user DROP CONSTRAINT IF EXISTS managed_user_email_key;
ALTER TABLE IF EXISTS ONLY "__DCIM_TARGET_SCHEMA__".layout_zone DROP CONSTRAINT IF EXISTS layout_zone_pkey;
ALTER TABLE IF EXISTS ONLY "__DCIM_TARGET_SCHEMA__".layout_snapshot DROP CONSTRAINT IF EXISTS layout_snapshot_pkey;
ALTER TABLE IF EXISTS ONLY "__DCIM_TARGET_SCHEMA__".layout_facility DROP CONSTRAINT IF EXISTS layout_facility_pkey;
ALTER TABLE IF EXISTS ONLY "__DCIM_TARGET_SCHEMA__".layout_cabinet_position DROP CONSTRAINT IF EXISTS layout_cabinet_position_pkey;
ALTER TABLE IF EXISTS ONLY "__DCIM_TARGET_SCHEMA__".device_template DROP CONSTRAINT IF EXISTS device_template_pkey;
ALTER TABLE IF EXISTS ONLY "__DCIM_TARGET_SCHEMA__".device DROP CONSTRAINT IF EXISTS device_pkey;
ALTER TABLE IF EXISTS ONLY "__DCIM_TARGET_SCHEMA__".device DROP CONSTRAINT IF EXISTS device_asset_code_key;
ALTER TABLE IF EXISTS ONLY "__DCIM_TARGET_SCHEMA__".datacenter DROP CONSTRAINT IF EXISTS datacenter_pkey;
ALTER TABLE IF EXISTS ONLY "__DCIM_TARGET_SCHEMA__".datacenter DROP CONSTRAINT IF EXISTS datacenter_code_key;
ALTER TABLE IF EXISTS ONLY "__DCIM_TARGET_SCHEMA__".dashboard_snapshot DROP CONSTRAINT IF EXISTS dashboard_snapshot_pkey;
ALTER TABLE IF EXISTS ONLY "__DCIM_TARGET_SCHEMA__".cable_connection DROP CONSTRAINT IF EXISTS cable_connection_pkey;
ALTER TABLE IF EXISTS ONLY "__DCIM_TARGET_SCHEMA__".cable_connection DROP CONSTRAINT IF EXISTS cable_connection_cable_number_key;
ALTER TABLE IF EXISTS ONLY "__DCIM_TARGET_SCHEMA__".cabinet_telemetry_source DROP CONSTRAINT IF EXISTS cabinet_telemetry_source_source_id_key;
ALTER TABLE IF EXISTS ONLY "__DCIM_TARGET_SCHEMA__".cabinet_telemetry_source DROP CONSTRAINT IF EXISTS cabinet_telemetry_source_pkey;
ALTER TABLE IF EXISTS ONLY "__DCIM_TARGET_SCHEMA__".cabinet DROP CONSTRAINT IF EXISTS cabinet_pkey;
ALTER TABLE IF EXISTS ONLY "__DCIM_TARGET_SCHEMA__".cabinet DROP CONSTRAINT IF EXISTS cabinet_datacenter_id_row_no_column_no_key;
ALTER TABLE IF EXISTS ONLY "__DCIM_TARGET_SCHEMA__".cabinet DROP CONSTRAINT IF EXISTS cabinet_datacenter_id_code_key;
ALTER TABLE IF EXISTS ONLY "__DCIM_TARGET_SCHEMA__".api_mock_response DROP CONSTRAINT IF EXISTS api_mock_response_pkey;
ALTER TABLE IF EXISTS ONLY "__DCIM_TARGET_SCHEMA__".alert_rule DROP CONSTRAINT IF EXISTS alert_rule_pkey;
ALTER TABLE IF EXISTS ONLY "__DCIM_TARGET_SCHEMA__".alert_event DROP CONSTRAINT IF EXISTS alert_event_pkey;
ALTER TABLE IF EXISTS "__DCIM_TARGET_SCHEMA__".rack_installation ALTER COLUMN id DROP DEFAULT;
DROP TABLE IF EXISTS "__DCIM_TARGET_SCHEMA__".topology_snapshot;
DROP SEQUENCE IF EXISTS "__DCIM_TARGET_SCHEMA__".rack_installation_id_seq;
DROP TABLE IF EXISTS "__DCIM_TARGET_SCHEMA__".rack_installation;
DROP TABLE IF EXISTS "__DCIM_TARGET_SCHEMA__".pue_daily;
DROP TABLE IF EXISTS "__DCIM_TARGET_SCHEMA__".power_node;
DROP TABLE IF EXISTS "__DCIM_TARGET_SCHEMA__".power_connection;
DROP TABLE IF EXISTS "__DCIM_TARGET_SCHEMA__".port_group_template;
DROP TABLE IF EXISTS "__DCIM_TARGET_SCHEMA__".port;
DROP TABLE IF EXISTS "__DCIM_TARGET_SCHEMA__".pdu;
DROP TABLE IF EXISTS "__DCIM_TARGET_SCHEMA__".operation_record;
DROP TABLE IF EXISTS "__DCIM_TARGET_SCHEMA__".ontology_relationship;
DROP TABLE IF EXISTS "__DCIM_TARGET_SCHEMA__".ontology_individual;
DROP TABLE IF EXISTS "__DCIM_TARGET_SCHEMA__".observation;
DROP TABLE IF EXISTS "__DCIM_TARGET_SCHEMA__".mock_raw_payload;
DROP TABLE IF EXISTS "__DCIM_TARGET_SCHEMA__".managed_user;
DROP TABLE IF EXISTS "__DCIM_TARGET_SCHEMA__".layout_zone;
DROP TABLE IF EXISTS "__DCIM_TARGET_SCHEMA__".layout_snapshot;
DROP TABLE IF EXISTS "__DCIM_TARGET_SCHEMA__".layout_facility;
DROP TABLE IF EXISTS "__DCIM_TARGET_SCHEMA__".layout_cabinet_position;
DROP TABLE IF EXISTS "__DCIM_TARGET_SCHEMA__".device_template;
DROP TABLE IF EXISTS "__DCIM_TARGET_SCHEMA__".device;
DROP TABLE IF EXISTS "__DCIM_TARGET_SCHEMA__".datacenter;
DROP TABLE IF EXISTS "__DCIM_TARGET_SCHEMA__".dashboard_snapshot;
DROP TABLE IF EXISTS "__DCIM_TARGET_SCHEMA__".cable_connection;
DROP TABLE IF EXISTS "__DCIM_TARGET_SCHEMA__".cabinet_telemetry_source;
DROP TABLE IF EXISTS "__DCIM_TARGET_SCHEMA__".cabinet;
DROP TABLE IF EXISTS "__DCIM_TARGET_SCHEMA__".api_mock_response;
DROP TABLE IF EXISTS "__DCIM_TARGET_SCHEMA__".alert_rule;
DROP TABLE IF EXISTS "__DCIM_TARGET_SCHEMA__".alert_event;
DROP FUNCTION IF EXISTS "__DCIM_TARGET_SCHEMA__".enforce_cable_connection_port_occupancy();
DROP SCHEMA IF EXISTS "__DCIM_TARGET_SCHEMA__";
--
-- Name: dcim_ontology_demo_20260623083835; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA "__DCIM_TARGET_SCHEMA__";


--
-- Name: enforce_cable_connection_port_occupancy(); Type: FUNCTION; Schema: dcim_ontology_demo_20260623083835; Owner: -
--

CREATE FUNCTION "__DCIM_TARGET_SCHEMA__".enforce_cable_connection_port_occupancy() RETURNS trigger
    LANGUAGE plpgsql
    AS $_$
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
$_$;


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: alert_event; Type: TABLE; Schema: dcim_ontology_demo_20260623083835; Owner: -
--

CREATE TABLE "__DCIM_TARGET_SCHEMA__".alert_event (
    id text NOT NULL,
    level text NOT NULL,
    alert_type text NOT NULL,
    source text NOT NULL,
    rule_id text,
    device_id text,
    cabinet_id text,
    datacenter_id text,
    message text NOT NULL,
    value_num numeric(14,4),
    threshold_num numeric(14,4),
    acknowledged boolean DEFAULT false NOT NULL,
    acknowledged_at timestamp with time zone,
    acknowledged_by text,
    resolved_at timestamp with time zone,
    resolved_by text,
    notes text,
    created_at timestamp with time zone NOT NULL,
    CONSTRAINT alert_event_level_check CHECK ((level = ANY (ARRAY['info'::text, 'warning'::text, 'error'::text, 'critical'::text]))),
    CONSTRAINT alert_event_source_check CHECK ((source = ANY (ARRAY['manual'::text, 'system'::text, 'rule'::text])))
);


--
-- Name: alert_rule; Type: TABLE; Schema: dcim_ontology_demo_20260623083835; Owner: -
--

CREATE TABLE "__DCIM_TARGET_SCHEMA__".alert_rule (
    id text NOT NULL,
    name text NOT NULL,
    rule_type text NOT NULL,
    enabled boolean DEFAULT true NOT NULL,
    condition_json jsonb NOT NULL,
    severity text NOT NULL,
    notification_json jsonb DEFAULT '{}'::jsonb NOT NULL,
    scope_json jsonb,
    source_system text DEFAULT 'mock'::text NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    CONSTRAINT alert_rule_rule_type_check CHECK ((rule_type = ANY (ARRAY['temperature'::text, 'humidity'::text, 'power'::text, 'device_status'::text, 'port_status'::text, 'capacity'::text]))),
    CONSTRAINT alert_rule_severity_check CHECK ((severity = ANY (ARRAY['info'::text, 'warning'::text, 'error'::text, 'critical'::text])))
);


--
-- Name: api_mock_response; Type: TABLE; Schema: dcim_ontology_demo_20260623083835; Owner: -
--

CREATE TABLE "__DCIM_TARGET_SCHEMA__".api_mock_response (
    route_key text NOT NULL,
    payload jsonb NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: cabinet; Type: TABLE; Schema: dcim_ontology_demo_20260623083835; Owner: -
--

CREATE TABLE "__DCIM_TARGET_SCHEMA__".cabinet (
    id text NOT NULL,
    datacenter_id text NOT NULL,
    name text NOT NULL,
    code text NOT NULL,
    row_no integer NOT NULL,
    column_no integer NOT NULL,
    u_height integer NOT NULL,
    max_power_w numeric(12,2),
    health_status text NOT NULL,
    description text,
    source_system text DEFAULT 'mock'::text NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    CONSTRAINT cabinet_column_no_check CHECK ((column_no > 0)),
    CONSTRAINT cabinet_health_status_check CHECK ((health_status = ANY (ARRAY['normal'::text, 'warning'::text, 'error'::text, 'offline'::text]))),
    CONSTRAINT cabinet_max_power_w_check CHECK ((max_power_w >= (0)::numeric)),
    CONSTRAINT cabinet_row_no_check CHECK ((row_no > 0)),
    CONSTRAINT cabinet_u_height_check CHECK ((u_height > 0))
);


--
-- Name: cabinet_telemetry_source; Type: TABLE; Schema: dcim_ontology_demo_20260623083835; Owner: -
--

CREATE TABLE "__DCIM_TARGET_SCHEMA__".cabinet_telemetry_source (
    cabinet_id text NOT NULL,
    source_id text NOT NULL,
    host text NOT NULL,
    port integer NOT NULL,
    unit_id integer NOT NULL,
    timeout_ms integer NOT NULL,
    enabled boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT cabinet_telemetry_source_port_check CHECK (((port >= 1) AND (port <= 65535))),
    CONSTRAINT cabinet_telemetry_source_timeout_ms_check CHECK ((timeout_ms >= 100)),
    CONSTRAINT cabinet_telemetry_source_unit_id_check CHECK (((unit_id >= 0) AND (unit_id <= 255)))
);


--
-- Name: cable_connection; Type: TABLE; Schema: dcim_ontology_demo_20260623083835; Owner: -
--

CREATE TABLE "__DCIM_TARGET_SCHEMA__".cable_connection (
    id text NOT NULL,
    cable_number text NOT NULL,
    connection_type text NOT NULL,
    cable_type text NOT NULL,
    cable_color text,
    cable_length_m numeric(10,2),
    source_device_id text NOT NULL,
    source_port_id text NOT NULL,
    target_device_id text NOT NULL,
    target_port_id text NOT NULL,
    status text NOT NULL,
    description text,
    source_system text DEFAULT 'mock'::text NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    CONSTRAINT cable_connection_cable_length_m_check CHECK ((cable_length_m >= (0)::numeric)),
    CONSTRAINT cable_connection_cable_type_check CHECK ((cable_type = ANY (ARRAY['Cat5e'::text, 'Cat6'::text, 'Cat6a'::text, 'Cat7'::text, 'SingleModeFiber'::text, 'MultiModeFiber'::text, 'DAC'::text, 'AOC'::text, 'PowerCable'::text]))),
    CONSTRAINT cable_connection_check CHECK ((source_port_id <> target_port_id)),
    CONSTRAINT cable_connection_connection_type_check CHECK ((connection_type = ANY (ARRAY['network'::text, 'power'::text, 'management'::text, 'storage'::text, 'stack'::text]))),
    CONSTRAINT cable_connection_status_check CHECK ((status = ANY (ARRAY['active'::text, 'inactive'::text, 'faulty'::text])))
);


--
-- Name: dashboard_snapshot; Type: TABLE; Schema: dcim_ontology_demo_20260623083835; Owner: -
--

CREATE TABLE "__DCIM_TARGET_SCHEMA__".dashboard_snapshot (
    id text NOT NULL,
    snapshot_type text NOT NULL,
    scope_id text,
    payload jsonb NOT NULL,
    captured_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: datacenter; Type: TABLE; Schema: dcim_ontology_demo_20260623083835; Owner: -
--

CREATE TABLE "__DCIM_TARGET_SCHEMA__".datacenter (
    id text NOT NULL,
    name text NOT NULL,
    code text NOT NULL,
    address text,
    area_sqm numeric(12,2),
    lifecycle_status text NOT NULL,
    description text,
    contact text,
    phone text,
    source_system text DEFAULT 'mock'::text NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    CONSTRAINT datacenter_lifecycle_status_check CHECK ((lifecycle_status = ANY (ARRAY['active'::text, 'maintenance'::text, 'offline'::text])))
);


--
-- Name: device; Type: TABLE; Schema: dcim_ontology_demo_20260623083835; Owner: -
--

CREATE TABLE "__DCIM_TARGET_SCHEMA__".device (
    id text NOT NULL,
    template_id text CONSTRAINT device_template_id_not_null1 NOT NULL,
    asset_code text NOT NULL,
    name text NOT NULL,
    serial_number text,
    management_ip inet,
    operational_status text NOT NULL,
    purchase_date date,
    warranty_expiry date,
    vendor text,
    owner text,
    department text,
    description text,
    source_system text DEFAULT 'mock'::text NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    CONSTRAINT device_operational_status_check CHECK ((operational_status = ANY (ARRAY['online'::text, 'offline'::text, 'warning'::text, 'error'::text, 'maintenance'::text])))
);


--
-- Name: device_template; Type: TABLE; Schema: dcim_ontology_demo_20260623083835; Owner: -
--

CREATE TABLE "__DCIM_TARGET_SCHEMA__".device_template (
    id text NOT NULL,
    name text NOT NULL,
    category text NOT NULL,
    brand text NOT NULL,
    model text NOT NULL,
    u_height integer NOT NULL,
    front_color text,
    rear_color text,
    model3d_url text,
    image_url text,
    is_builtin boolean DEFAULT false NOT NULL,
    max_power_w numeric(12,2),
    spec_json jsonb DEFAULT '{}'::jsonb NOT NULL,
    description text,
    source_system text DEFAULT 'mock'::text NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    CONSTRAINT device_template_category_check CHECK ((category = ANY (ARRAY['switch'::text, 'router'::text, 'server'::text, 'storage'::text, 'firewall'::text, 'loadbalancer'::text, 'pdu'::text, 'other'::text]))),
    CONSTRAINT device_template_max_power_w_check CHECK ((max_power_w >= (0)::numeric)),
    CONSTRAINT device_template_u_height_check CHECK ((u_height > 0))
);


--
-- Name: layout_cabinet_position; Type: TABLE; Schema: dcim_ontology_demo_20260623083835; Owner: -
--

CREATE TABLE "__DCIM_TARGET_SCHEMA__".layout_cabinet_position (
    datacenter_id text NOT NULL,
    cabinet_id text NOT NULL,
    x numeric(12,3) NOT NULL,
    y numeric(12,3) NOT NULL,
    rotation numeric(12,3)
);


--
-- Name: layout_facility; Type: TABLE; Schema: dcim_ontology_demo_20260623083835; Owner: -
--

CREATE TABLE "__DCIM_TARGET_SCHEMA__".layout_facility (
    id text NOT NULL,
    datacenter_id text NOT NULL,
    facility_type text NOT NULL,
    name text,
    x numeric(12,3) NOT NULL,
    y numeric(12,3) NOT NULL,
    rotation numeric(12,3)
);


--
-- Name: layout_snapshot; Type: TABLE; Schema: dcim_ontology_demo_20260623083835; Owner: -
--

CREATE TABLE "__DCIM_TARGET_SCHEMA__".layout_snapshot (
    datacenter_id text NOT NULL,
    version integer NOT NULL,
    canvas_width numeric(12,2) NOT NULL,
    canvas_height numeric(12,2) NOT NULL,
    px_per_meter numeric(12,2) NOT NULL,
    raw_json jsonb NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


--
-- Name: layout_zone; Type: TABLE; Schema: dcim_ontology_demo_20260623083835; Owner: -
--

CREATE TABLE "__DCIM_TARGET_SCHEMA__".layout_zone (
    id text NOT NULL,
    datacenter_id text NOT NULL,
    zone_type text NOT NULL,
    name text,
    x numeric(12,3) NOT NULL,
    y numeric(12,3) NOT NULL,
    width numeric(12,3) NOT NULL,
    height numeric(12,3) NOT NULL,
    rotation numeric(12,3),
    color text
);


--
-- Name: managed_user; Type: TABLE; Schema: dcim_ontology_demo_20260623083835; Owner: -
--

CREATE TABLE "__DCIM_TARGET_SCHEMA__".managed_user (
    id text NOT NULL,
    username text NOT NULL,
    name text NOT NULL,
    email text NOT NULL,
    phone text,
    role text NOT NULL,
    status text NOT NULL,
    avatar text,
    title text,
    department text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    last_login_at timestamp with time zone,
    password_salt text NOT NULL,
    password_hash text NOT NULL,
    CONSTRAINT managed_user_role_check CHECK ((role = ANY (ARRAY['admin'::text, 'user'::text]))),
    CONSTRAINT managed_user_status_check CHECK ((status = ANY (ARRAY['active'::text, 'disabled'::text])))
);


--
-- Name: mock_raw_payload; Type: TABLE; Schema: dcim_ontology_demo_20260623083835; Owner: -
--

CREATE TABLE "__DCIM_TARGET_SCHEMA__".mock_raw_payload (
    id text NOT NULL,
    source_name text NOT NULL,
    payload jsonb NOT NULL,
    captured_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: observation; Type: TABLE; Schema: dcim_ontology_demo_20260623083835; Owner: -
--

CREATE TABLE "__DCIM_TARGET_SCHEMA__".observation (
    id text NOT NULL,
    target_type text NOT NULL,
    target_id text NOT NULL,
    sensor_id text,
    sensor_position text,
    metric text NOT NULL,
    value_num numeric(14,4) NOT NULL,
    unit text NOT NULL,
    observed_at timestamp with time zone NOT NULL,
    source_system text DEFAULT 'mock'::text NOT NULL,
    confidence numeric(4,3) DEFAULT 1.0 NOT NULL,
    CONSTRAINT observation_confidence_check CHECK (((confidence >= (0)::numeric) AND (confidence <= (1)::numeric))),
    CONSTRAINT observation_target_type_check CHECK ((target_type = ANY (ARRAY['datacenter'::text, 'cabinet'::text, 'device'::text, 'pdu'::text, 'port'::text])))
);


--
-- Name: ontology_individual; Type: TABLE; Schema: dcim_ontology_demo_20260623083835; Owner: -
--

CREATE TABLE "__DCIM_TARGET_SCHEMA__".ontology_individual (
    id text NOT NULL,
    ontology_class text NOT NULL,
    source_table text NOT NULL,
    source_id text NOT NULL,
    label text,
    source_system text DEFAULT 'mock'::text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: ontology_relationship; Type: TABLE; Schema: dcim_ontology_demo_20260623083835; Owner: -
--

CREATE TABLE "__DCIM_TARGET_SCHEMA__".ontology_relationship (
    id text NOT NULL,
    relationship_type text NOT NULL,
    source_individual_id text NOT NULL,
    target_individual_id text NOT NULL,
    fact_table text,
    fact_id text,
    valid_from timestamp with time zone DEFAULT now() NOT NULL,
    valid_to timestamp with time zone,
    source_system text DEFAULT 'mock'::text NOT NULL,
    confidence numeric(4,3) DEFAULT 1.0 NOT NULL,
    CONSTRAINT ontology_relationship_check CHECK ((source_individual_id <> target_individual_id)),
    CONSTRAINT ontology_relationship_confidence_check CHECK (((confidence >= (0)::numeric) AND (confidence <= (1)::numeric)))
);


--
-- Name: operation_record; Type: TABLE; Schema: dcim_ontology_demo_20260623083835; Owner: -
--

CREATE TABLE "__DCIM_TARGET_SCHEMA__".operation_record (
    id text NOT NULL,
    operation_type text NOT NULL,
    operator_name text NOT NULL,
    target text NOT NULL,
    description text,
    created_at timestamp with time zone NOT NULL,
    source_system text DEFAULT 'mock'::text NOT NULL
);


--
-- Name: pdu; Type: TABLE; Schema: dcim_ontology_demo_20260623083835; Owner: -
--

CREATE TABLE "__DCIM_TARGET_SCHEMA__".pdu (
    id text NOT NULL,
    template_id text,
    cabinet_id text,
    name text NOT NULL,
    asset_code text NOT NULL,
    management_ip inet,
    power_path text NOT NULL,
    input_voltage numeric(10,2),
    output_ports integer,
    max_load_w numeric(12,2),
    current_load_w numeric(12,2),
    brand text,
    model text,
    operational_status text NOT NULL,
    source_system text DEFAULT 'mock'::text NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    CONSTRAINT pdu_current_load_w_check CHECK ((current_load_w >= (0)::numeric)),
    CONSTRAINT pdu_max_load_w_check CHECK ((max_load_w >= (0)::numeric)),
    CONSTRAINT pdu_operational_status_check CHECK ((operational_status = ANY (ARRAY['online'::text, 'offline'::text, 'warning'::text, 'error'::text, 'maintenance'::text]))),
    CONSTRAINT pdu_output_ports_check CHECK ((output_ports >= 0)),
    CONSTRAINT pdu_power_path_check CHECK ((power_path = ANY (ARRAY['A'::text, 'B'::text, 'unknown'::text])))
);


--
-- Name: port; Type: TABLE; Schema: dcim_ontology_demo_20260623083835; Owner: -
--

CREATE TABLE "__DCIM_TARGET_SCHEMA__".port (
    id text NOT NULL,
    device_id text NOT NULL,
    port_group_id text NOT NULL,
    port_number text NOT NULL,
    port_alias text,
    port_type text NOT NULL,
    speed text NOT NULL,
    admin_status text NOT NULL,
    link_status text NOT NULL,
    vlan_config jsonb,
    qos_config jsonb,
    mac_bindings text[],
    port_security boolean,
    max_mac_count integer,
    dot1x_enabled boolean,
    connection_purpose text,
    description text,
    last_updated timestamp with time zone NOT NULL,
    CONSTRAINT port_admin_status_check CHECK ((admin_status = ANY (ARRAY['up'::text, 'down'::text, 'disabled'::text, 'error'::text]))),
    CONSTRAINT port_link_status_check CHECK ((link_status = ANY (ARRAY['connected'::text, 'disconnected'::text]))),
    CONSTRAINT port_port_type_check CHECK ((port_type = ANY (ARRAY['RJ45'::text, 'SFP'::text, 'SFP+'::text, 'QSFP+'::text, 'QSFP28'::text, 'FC'::text, 'USB'::text, 'Console'::text, 'Power'::text]))),
    CONSTRAINT port_speed_check CHECK ((speed = ANY (ARRAY['100M'::text, '1G'::text, '10G'::text, '25G'::text, '40G'::text, '100G'::text, 'N/A'::text])))
);


--
-- Name: port_group_template; Type: TABLE; Schema: dcim_ontology_demo_20260623083835; Owner: -
--

CREATE TABLE "__DCIM_TARGET_SCHEMA__".port_group_template (
    id text NOT NULL,
    template_id text NOT NULL,
    name text NOT NULL,
    port_type text NOT NULL,
    port_count integer NOT NULL,
    speed text NOT NULL,
    poe boolean DEFAULT false NOT NULL,
    CONSTRAINT port_group_template_port_count_check CHECK ((port_count > 0)),
    CONSTRAINT port_group_template_port_type_check CHECK ((port_type = ANY (ARRAY['RJ45'::text, 'SFP'::text, 'SFP+'::text, 'QSFP+'::text, 'QSFP28'::text, 'FC'::text, 'USB'::text, 'Console'::text, 'Power'::text]))),
    CONSTRAINT port_group_template_speed_check CHECK ((speed = ANY (ARRAY['100M'::text, '1G'::text, '10G'::text, '25G'::text, '40G'::text, '100G'::text, 'N/A'::text])))
);


--
-- Name: power_connection; Type: TABLE; Schema: dcim_ontology_demo_20260623083835; Owner: -
--

CREATE TABLE "__DCIM_TARGET_SCHEMA__".power_connection (
    id text NOT NULL,
    datacenter_id text NOT NULL,
    source_node_id text NOT NULL,
    target_node_id text NOT NULL,
    target_node_type text NOT NULL,
    power_path text NOT NULL,
    status text NOT NULL,
    valid_from timestamp with time zone DEFAULT now() NOT NULL,
    valid_to timestamp with time zone,
    source_system text DEFAULT 'mock'::text NOT NULL,
    confidence numeric(4,3) DEFAULT 1.0 NOT NULL,
    CONSTRAINT power_connection_check CHECK ((source_node_id <> target_node_id)),
    CONSTRAINT power_connection_confidence_check CHECK (((confidence >= (0)::numeric) AND (confidence <= (1)::numeric))),
    CONSTRAINT power_connection_power_path_check CHECK ((power_path = ANY (ARRAY['A'::text, 'B'::text, 'unknown'::text]))),
    CONSTRAINT power_connection_status_check CHECK ((status = ANY (ARRAY['active'::text, 'inactive'::text, 'faulty'::text]))),
    CONSTRAINT power_connection_target_node_type_check CHECK ((target_node_type = ANY (ARRAY['utility'::text, 'ups'::text, 'pdu'::text, 'device'::text])))
);


--
-- Name: power_node; Type: TABLE; Schema: dcim_ontology_demo_20260623083835; Owner: -
--

CREATE TABLE "__DCIM_TARGET_SCHEMA__".power_node (
    id text NOT NULL,
    datacenter_id text NOT NULL,
    node_type text NOT NULL,
    name text NOT NULL,
    status text NOT NULL,
    load_w numeric(12,2),
    capacity_w numeric(12,2),
    source_system text DEFAULT 'mock'::text NOT NULL,
    CONSTRAINT power_node_node_type_check CHECK ((node_type = ANY (ARRAY['utility'::text, 'ups'::text, 'pdu'::text, 'device'::text]))),
    CONSTRAINT power_node_status_check CHECK ((status = ANY (ARRAY['online'::text, 'offline'::text, 'warning'::text, 'error'::text, 'maintenance'::text])))
);


--
-- Name: pue_daily; Type: TABLE; Schema: dcim_ontology_demo_20260623083835; Owner: -
--

CREATE TABLE "__DCIM_TARGET_SCHEMA__".pue_daily (
    datacenter_id text NOT NULL,
    metric_date date NOT NULL,
    pue numeric(6,3) NOT NULL,
    it_power_kw numeric(12,3) NOT NULL,
    total_power_kw numeric(12,3) NOT NULL,
    cooling_power_kw numeric(12,3) NOT NULL,
    source_system text DEFAULT 'mock'::text NOT NULL
);


--
-- Name: rack_installation; Type: TABLE; Schema: dcim_ontology_demo_20260623083835; Owner: -
--

CREATE TABLE "__DCIM_TARGET_SCHEMA__".rack_installation (
    id bigint NOT NULL,
    asset_type text NOT NULL,
    device_id text,
    pdu_id text,
    cabinet_id text NOT NULL,
    start_u integer NOT NULL,
    end_u integer NOT NULL,
    valid_from timestamp with time zone DEFAULT now() NOT NULL,
    valid_to timestamp with time zone,
    source_system text DEFAULT 'mock'::text NOT NULL,
    confidence numeric(4,3) DEFAULT 1.0 NOT NULL,
    CONSTRAINT rack_installation_asset_type_check CHECK ((asset_type = ANY (ARRAY['device'::text, 'pdu'::text]))),
    CONSTRAINT rack_installation_check CHECK ((end_u >= start_u)),
    CONSTRAINT rack_installation_check1 CHECK ((((asset_type = 'device'::text) AND (device_id IS NOT NULL) AND (pdu_id IS NULL)) OR ((asset_type = 'pdu'::text) AND (pdu_id IS NOT NULL) AND (device_id IS NULL)))),
    CONSTRAINT rack_installation_confidence_check CHECK (((confidence >= (0)::numeric) AND (confidence <= (1)::numeric))),
    CONSTRAINT rack_installation_start_u_check CHECK ((start_u > 0))
);


--
-- Name: rack_installation_id_seq; Type: SEQUENCE; Schema: dcim_ontology_demo_20260623083835; Owner: -
--

CREATE SEQUENCE "__DCIM_TARGET_SCHEMA__".rack_installation_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: rack_installation_id_seq; Type: SEQUENCE OWNED BY; Schema: dcim_ontology_demo_20260623083835; Owner: -
--

ALTER SEQUENCE "__DCIM_TARGET_SCHEMA__".rack_installation_id_seq OWNED BY "__DCIM_TARGET_SCHEMA__".rack_installation.id;


--
-- Name: topology_snapshot; Type: TABLE; Schema: dcim_ontology_demo_20260623083835; Owner: -
--

CREATE TABLE "__DCIM_TARGET_SCHEMA__".topology_snapshot (
    id text NOT NULL,
    datacenter_id text NOT NULL,
    payload jsonb NOT NULL,
    captured_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: rack_installation id; Type: DEFAULT; Schema: dcim_ontology_demo_20260623083835; Owner: -
--

ALTER TABLE ONLY "__DCIM_TARGET_SCHEMA__".rack_installation ALTER COLUMN id SET DEFAULT nextval('"__DCIM_TARGET_SCHEMA__".rack_installation_id_seq'::regclass);


--
-- Data for Name: alert_event; Type: TABLE DATA; Schema: dcim_ontology_demo_20260623083835; Owner: -
--

COPY "__DCIM_TARGET_SCHEMA__".alert_event (id, level, alert_type, source, rule_id, device_id, cabinet_id, datacenter_id, message, value_num, threshold_num, acknowledged, acknowledged_at, acknowledged_by, resolved_at, resolved_by, notes, created_at) FROM stdin;
alert-001	critical	temperature	rule	rule-001	dev-003	cab-bj-003	dc-001	机柜温度超过28℃阈值，当前温度29.8℃	29.8000	28.0000	f	\N	\N	\N	\N	\N	2026-01-17 09:30:00+00
alert-002	warning	port_status	system	\N	dev-010	cab-bj-001	dc-001	端口利用率超过80%	85.0000	80.0000	f	\N	\N	\N	\N	\N	2026-01-17 09:00:00+00
alert-003	warning	power	rule	rule-003	\N	cab-sz-001	dc-003	机柜功率超过额定的85%	6.8000	6.5000	t	2026-01-17 09:10:00+00	张运维	\N	\N	已通知设备负责人，计划迁移部分负载	2026-01-17 08:45:00+00
alert-004	error	device_status	system	\N	dev-005	cab-bj-002	dc-001	设备心跳超时，疑似离线	\N	\N	t	2026-01-17 07:35:00+00	李运维	2026-01-17 08:00:00+00	李运维	网络闪断导致，已恢复	2026-01-17 07:30:00+00
alert-005	info	capacity	rule	rule-005	\N	cab-bj-001	dc-001	机柜U位使用率达到92%	92.0000	90.0000	t	2026-01-16 15:00:00+00	王运维	\N	\N	\N	2026-01-16 14:00:00+00
alert-006	warning	humidity	rule	rule-002	\N	cab-sh-001	dc-002	机柜湿度低于40%	35.0000	40.0000	f	\N	\N	\N	\N	\N	2026-01-16 10:00:00+00
\.


--
-- Data for Name: alert_rule; Type: TABLE DATA; Schema: dcim_ontology_demo_20260623083835; Owner: -
--

COPY "__DCIM_TARGET_SCHEMA__".alert_rule (id, name, rule_type, enabled, condition_json, severity, notification_json, scope_json, source_system, created_at, updated_at) FROM stdin;
rule-001	高温告警	temperature	t	{"metric": "temperature", "duration": 300, "operator": ">", "threshold": 28}	critical	{"sms": true, "email": true}	\N	mock	2025-01-01 00:00:00+00	2026-01-10 08:00:00+00
rule-002	湿度告警	humidity	t	{"metric": "humidity", "duration": 600, "operator": "<", "threshold": 40}	warning	{"email": true}	\N	mock	2025-01-01 00:00:00+00	2026-01-10 08:00:00+00
rule-003	功率告警	power	t	{"metric": "power_usage_percent", "operator": ">=", "threshold": 85}	warning	{"email": true}	\N	mock	2025-01-01 00:00:00+00	2026-01-10 08:00:00+00
rule-004	设备离线告警	device_status	t	{"metric": "device_status", "duration": 120, "operator": "==", "threshold": 0}	error	{"sms": true, "email": true}	\N	mock	2025-01-01 00:00:00+00	2026-01-10 08:00:00+00
rule-005	U位容量预警	capacity	t	{"metric": "u_usage_percent", "operator": ">=", "threshold": 90}	info	{"email": true}	\N	mock	2025-01-01 00:00:00+00	2026-01-10 08:00:00+00
rule-006	端口利用率告警	port_status	f	{"metric": "port_usage_percent", "operator": ">", "threshold": 80}	warning	{"email": true}	\N	mock	2025-06-01 00:00:00+00	2026-01-05 08:00:00+00
\.


--
-- Data for Name: api_mock_response; Type: TABLE DATA; Schema: dcim_ontology_demo_20260623083835; Owner: -
--

COPY "__DCIM_TARGET_SCHEMA__".api_mock_response (route_key, payload, updated_at) FROM stdin;
POST /api/login/account	{"type": "account", "status": "ok", "currentAuthority": "admin"}	2026-06-23 09:01:13.863555+00
GET /api/users	{"data": [], "total": 0, "success": true}	2026-06-23 09:01:13.88422+00
POST /api/login/refresh	{"success": true}	2026-06-23 09:08:48.04655+00
GET /api/currentUser	{"name": "Admin", "email": "admin@example.com", "access": "admin", "avatar": "", "userid": "00000001"}	2026-06-23 11:45:20.513983+00
\.


--
-- Data for Name: cabinet; Type: TABLE DATA; Schema: dcim_ontology_demo_20260623083835; Owner: -
--

COPY "__DCIM_TARGET_SCHEMA__".cabinet (id, datacenter_id, name, code, row_no, column_no, u_height, max_power_w, health_status, description, source_system, created_at, updated_at) FROM stdin;
cab-bj-001	dc-001	A区1排1号机柜	BJ-YZ-A1-01	1	1	42	10000.00	warning	A区标准机柜	mock	2023-01-20 08:00:00+00	2024-12-01 10:30:00+00
cab-bj-002	dc-001	A区1排2号机柜	BJ-YZ-A1-02	1	2	42	10000.00	normal	A区标准机柜	mock	2023-01-20 08:00:00+00	2024-12-01 10:30:00+00
cab-bj-003	dc-001	A区1排3号机柜	BJ-YZ-A1-03	1	3	42	10000.00	normal	A区标准机柜	mock	2023-01-20 08:00:00+00	2024-12-01 10:30:00+00
cab-bj-004	dc-001	A区1排4号机柜	BJ-YZ-A1-04	1	4	42	10000.00	normal	A区标准机柜	mock	2023-01-20 08:00:00+00	2024-12-01 10:30:00+00
cab-bj-005	dc-001	A区1排5号机柜	BJ-YZ-A1-05	1	5	42	10000.00	normal	A区标准机柜	mock	2023-01-20 08:00:00+00	2024-12-01 10:30:00+00
cab-bj-006	dc-001	A区2排1号机柜	BJ-YZ-A2-01	2	1	42	10000.00	normal	A区标准机柜	mock	2023-01-20 08:00:00+00	2024-12-01 10:30:00+00
cab-bj-007	dc-001	A区2排2号机柜	BJ-YZ-A2-02	2	2	42	10000.00	normal	A区标准机柜	mock	2023-01-20 08:00:00+00	2024-12-01 10:30:00+00
cab-bj-008	dc-001	A区2排3号机柜	BJ-YZ-A2-03	2	3	42	10000.00	normal	A区标准机柜	mock	2023-01-20 08:00:00+00	2024-12-01 10:30:00+00
cab-bj-009	dc-001	A区2排4号机柜	BJ-YZ-A2-04	2	4	42	10000.00	normal	A区标准机柜	mock	2023-01-20 08:00:00+00	2024-12-01 10:30:00+00
cab-bj-010	dc-001	A区2排5号机柜	BJ-YZ-A2-05	2	5	42	10000.00	normal	A区标准机柜	mock	2023-01-20 08:00:00+00	2024-12-01 10:30:00+00
cab-bj-011	dc-001	A区3排1号机柜	BJ-YZ-A3-01	3	1	42	10000.00	warning	A区标准机柜	mock	2023-01-20 08:00:00+00	2024-12-01 10:30:00+00
cab-bj-012	dc-001	A区3排2号机柜	BJ-YZ-A3-02	3	2	42	10000.00	normal	A区标准机柜	mock	2023-01-20 08:00:00+00	2024-12-01 10:30:00+00
cab-bj-013	dc-001	A区3排3号机柜	BJ-YZ-A3-03	3	3	42	10000.00	normal	A区标准机柜	mock	2023-01-20 08:00:00+00	2024-12-01 10:30:00+00
cab-bj-014	dc-001	A区3排4号机柜	BJ-YZ-A3-04	3	4	42	10000.00	normal	A区标准机柜	mock	2023-01-20 08:00:00+00	2024-12-01 10:30:00+00
cab-bj-015	dc-001	A区3排5号机柜	BJ-YZ-A3-05	3	5	42	10000.00	normal	A区标准机柜	mock	2023-01-20 08:00:00+00	2024-12-01 10:30:00+00
cab-bj-016	dc-001	A区4排1号机柜	BJ-YZ-A4-01	4	1	42	10000.00	normal	A区标准机柜	mock	2023-01-20 08:00:00+00	2024-12-01 10:30:00+00
cab-bj-017	dc-001	A区4排2号机柜	BJ-YZ-A4-02	4	2	42	10000.00	normal	A区标准机柜	mock	2023-01-20 08:00:00+00	2024-12-01 10:30:00+00
cab-bj-018	dc-001	A区4排3号机柜	BJ-YZ-A4-03	4	3	42	10000.00	normal	A区标准机柜	mock	2023-01-20 08:00:00+00	2024-12-01 10:30:00+00
cab-bj-019	dc-001	A区4排4号机柜	BJ-YZ-A4-04	4	4	42	10000.00	normal	A区标准机柜	mock	2023-01-20 08:00:00+00	2024-12-01 10:30:00+00
cab-bj-020	dc-001	A区4排5号机柜	BJ-YZ-A4-05	4	5	42	10000.00	normal	A区标准机柜	mock	2023-01-20 08:00:00+00	2024-12-01 10:30:00+00
cab-sh-001	dc-002	B区1排1号机柜	SH-JD-B1-01	1	1	42	10000.00	warning	B区标准机柜	mock	2023-06-25 09:00:00+00	2024-11-15 14:20:00+00
cab-sh-002	dc-002	B区1排2号机柜	SH-JD-B1-02	1	2	42	10000.00	normal	B区标准机柜	mock	2023-06-25 09:00:00+00	2024-11-15 14:20:00+00
cab-sh-003	dc-002	B区1排3号机柜	SH-JD-B1-03	1	3	42	10000.00	normal	B区标准机柜	mock	2023-06-25 09:00:00+00	2024-11-15 14:20:00+00
cab-sh-004	dc-002	B区1排4号机柜	SH-JD-B1-04	1	4	42	10000.00	normal	B区标准机柜	mock	2023-06-25 09:00:00+00	2024-11-15 14:20:00+00
cab-sh-005	dc-002	B区1排5号机柜	SH-JD-B1-05	1	5	42	10000.00	normal	B区标准机柜	mock	2023-06-25 09:00:00+00	2024-11-15 14:20:00+00
cab-sh-006	dc-002	B区2排1号机柜	SH-JD-B2-01	2	1	42	10000.00	normal	B区标准机柜	mock	2023-06-25 09:00:00+00	2024-11-15 14:20:00+00
cab-sh-007	dc-002	B区2排2号机柜	SH-JD-B2-02	2	2	42	10000.00	normal	B区标准机柜	mock	2023-06-25 09:00:00+00	2024-11-15 14:20:00+00
cab-sh-008	dc-002	B区2排3号机柜	SH-JD-B2-03	2	3	42	10000.00	normal	B区标准机柜	mock	2023-06-25 09:00:00+00	2024-11-15 14:20:00+00
cab-sh-009	dc-002	B区2排4号机柜	SH-JD-B2-04	2	4	42	10000.00	warning	B区标准机柜	mock	2023-06-25 09:00:00+00	2024-11-15 14:20:00+00
cab-sh-010	dc-002	B区2排5号机柜	SH-JD-B2-05	2	5	42	10000.00	normal	B区标准机柜	mock	2023-06-25 09:00:00+00	2024-11-15 14:20:00+00
cab-sh-011	dc-002	B区3排1号机柜	SH-JD-B3-01	3	1	42	10000.00	normal	B区标准机柜	mock	2023-06-25 09:00:00+00	2024-11-15 14:20:00+00
cab-sh-012	dc-002	B区3排2号机柜	SH-JD-B3-02	3	2	42	10000.00	normal	B区标准机柜	mock	2023-06-25 09:00:00+00	2024-11-15 14:20:00+00
cab-sh-013	dc-002	B区3排3号机柜	SH-JD-B3-03	3	3	42	10000.00	normal	B区标准机柜	mock	2023-06-25 09:00:00+00	2024-11-15 14:20:00+00
cab-sh-014	dc-002	B区3排4号机柜	SH-JD-B3-04	3	4	42	10000.00	normal	B区标准机柜	mock	2023-06-25 09:00:00+00	2024-11-15 14:20:00+00
cab-sh-015	dc-002	B区3排5号机柜	SH-JD-B3-05	3	5	42	10000.00	normal	B区标准机柜	mock	2023-06-25 09:00:00+00	2024-11-15 14:20:00+00
cab-sz-001	dc-003	C区1排1号机柜	SZ-PS-C1-01	1	1	47	12000.00	normal	C区高密度机柜	mock	2023-03-15 10:00:00+00	2024-10-20 16:45:00+00
cab-sz-002	dc-003	C区1排2号机柜	SZ-PS-C1-02	1	2	47	12000.00	normal	C区高密度机柜	mock	2023-03-15 10:00:00+00	2024-10-20 16:45:00+00
cab-sz-003	dc-003	C区1排3号机柜	SZ-PS-C1-03	1	3	47	12000.00	normal	C区高密度机柜	mock	2023-03-15 10:00:00+00	2024-10-20 16:45:00+00
cab-sz-004	dc-003	C区1排4号机柜	SZ-PS-C1-04	1	4	47	12000.00	normal	C区高密度机柜	mock	2023-03-15 10:00:00+00	2024-10-20 16:45:00+00
cab-sz-005	dc-003	C区1排5号机柜	SZ-PS-C1-05	1	5	47	12000.00	normal	C区高密度机柜	mock	2023-03-15 10:00:00+00	2024-10-20 16:45:00+00
cab-sz-006	dc-003	C区1排6号机柜	SZ-PS-C1-06	1	6	47	12000.00	normal	C区高密度机柜	mock	2023-03-15 10:00:00+00	2024-10-20 16:45:00+00
cab-sz-007	dc-003	C区2排1号机柜	SZ-PS-C2-01	2	1	47	12000.00	normal	C区高密度机柜	mock	2023-03-15 10:00:00+00	2024-10-20 16:45:00+00
cab-sz-008	dc-003	C区2排2号机柜	SZ-PS-C2-02	2	2	47	12000.00	normal	C区高密度机柜	mock	2023-03-15 10:00:00+00	2024-10-20 16:45:00+00
cab-sz-009	dc-003	C区2排3号机柜	SZ-PS-C2-03	2	3	47	12000.00	normal	C区高密度机柜	mock	2023-03-15 10:00:00+00	2024-10-20 16:45:00+00
cab-sz-010	dc-003	C区2排4号机柜	SZ-PS-C2-04	2	4	47	12000.00	normal	C区高密度机柜	mock	2023-03-15 10:00:00+00	2024-10-20 16:45:00+00
cab-sz-011	dc-003	C区2排5号机柜	SZ-PS-C2-05	2	5	47	12000.00	normal	C区高密度机柜	mock	2023-03-15 10:00:00+00	2024-10-20 16:45:00+00
cab-sz-012	dc-003	C区2排6号机柜	SZ-PS-C2-06	2	6	47	12000.00	normal	C区高密度机柜	mock	2023-03-15 10:00:00+00	2024-10-20 16:45:00+00
cab-sz-013	dc-003	C区3排1号机柜	SZ-PS-C3-01	3	1	47	12000.00	normal	C区高密度机柜	mock	2023-03-15 10:00:00+00	2024-10-20 16:45:00+00
cab-sz-014	dc-003	C区3排2号机柜	SZ-PS-C3-02	3	2	47	12000.00	normal	C区高密度机柜	mock	2023-03-15 10:00:00+00	2024-10-20 16:45:00+00
cab-sz-015	dc-003	C区3排3号机柜	SZ-PS-C3-03	3	3	47	12000.00	normal	C区高密度机柜	mock	2023-03-15 10:00:00+00	2024-10-20 16:45:00+00
cab-sz-016	dc-003	C区3排4号机柜	SZ-PS-C3-04	3	4	47	12000.00	normal	C区高密度机柜	mock	2023-03-15 10:00:00+00	2024-10-20 16:45:00+00
cab-sz-017	dc-003	C区3排5号机柜	SZ-PS-C3-05	3	5	47	12000.00	normal	C区高密度机柜	mock	2023-03-15 10:00:00+00	2024-10-20 16:45:00+00
cab-sz-018	dc-003	C区3排6号机柜	SZ-PS-C3-06	3	6	47	12000.00	normal	C区高密度机柜	mock	2023-03-15 10:00:00+00	2024-10-20 16:45:00+00
cab-cd-001	dc-004	D区1排1号机柜	CD-TF-D1-01	1	1	42	10000.00	warning	D区标准机柜	mock	2024-01-08 11:00:00+00	2024-12-05 09:15:00+00
cab-cd-002	dc-004	D区1排2号机柜	CD-TF-D1-02	1	2	42	10000.00	normal	D区标准机柜	mock	2024-01-08 11:00:00+00	2024-12-05 09:15:00+00
cab-cd-003	dc-004	D区1排3号机柜	CD-TF-D1-03	1	3	42	10000.00	normal	D区标准机柜	mock	2024-01-08 11:00:00+00	2024-12-05 09:15:00+00
cab-cd-004	dc-004	D区1排4号机柜	CD-TF-D1-04	1	4	42	10000.00	normal	D区标准机柜	mock	2024-01-08 11:00:00+00	2024-12-05 09:15:00+00
cab-cd-005	dc-004	D区2排1号机柜	CD-TF-D2-01	2	1	42	10000.00	normal	D区标准机柜	mock	2024-01-08 11:00:00+00	2024-12-05 09:15:00+00
cab-cd-006	dc-004	D区2排2号机柜	CD-TF-D2-02	2	2	42	10000.00	normal	D区标准机柜	mock	2024-01-08 11:00:00+00	2024-12-05 09:15:00+00
cab-cd-007	dc-004	D区2排3号机柜	CD-TF-D2-03	2	3	42	10000.00	warning	D区标准机柜	mock	2024-01-08 11:00:00+00	2024-12-05 09:15:00+00
cab-cd-008	dc-004	D区2排4号机柜	CD-TF-D2-04	2	4	42	10000.00	normal	D区标准机柜	mock	2024-01-08 11:00:00+00	2024-12-05 09:15:00+00
cab-cd-009	dc-004	D区3排1号机柜	CD-TF-D3-01	3	1	42	10000.00	normal	D区标准机柜	mock	2024-01-08 11:00:00+00	2024-12-05 09:15:00+00
cab-cd-010	dc-004	D区3排2号机柜	CD-TF-D3-02	3	2	42	10000.00	normal	D区标准机柜	mock	2024-01-08 11:00:00+00	2024-12-05 09:15:00+00
cab-cd-011	dc-004	D区3排3号机柜	CD-TF-D3-03	3	3	42	10000.00	normal	D区标准机柜	mock	2024-01-08 11:00:00+00	2024-12-05 09:15:00+00
cab-cd-012	dc-004	D区3排4号机柜	CD-TF-D3-04	3	4	42	10000.00	normal	D区标准机柜	mock	2024-01-08 11:00:00+00	2024-12-05 09:15:00+00
cab-b62e1eb2	dc-001	A区1排6号机柜	BJ-YZ-A1-06	1	6	42	10000.00	normal	\N	database	2026-06-24 04:05:01.401419+00	2026-06-24 04:05:01.401419+00
cab-b9ad0d40	dc-001	A区1排7号机柜	BJ-YZ-A1-07	1	7	42	10000.00	normal	\N	database	2026-06-30 04:26:33.37204+00	2026-06-30 04:26:33.37204+00
\.


--
-- Data for Name: cabinet_telemetry_source; Type: TABLE DATA; Schema: dcim_ontology_demo_20260623083835; Owner: -
--

COPY "__DCIM_TARGET_SCHEMA__".cabinet_telemetry_source (cabinet_id, source_id, host, port, unit_id, timeout_ms, enabled, created_at, updated_at) FROM stdin;
cab-bj-001	rack-simulator-1	ubuntu-server.tail430034.ts.net	1502	1	1800	t	2026-07-13 07:49:12.802868+00	2026-07-14 03:19:38.968753+00
cab-bj-002	BJ-YZ-A1-02-Telemery	ubuntu-server.tail430034.ts.net	1503	1	1800	t	2026-07-14 03:47:48.960293+00	2026-07-14 03:47:48.960293+00
\.


--
-- Data for Name: cable_connection; Type: TABLE DATA; Schema: dcim_ontology_demo_20260623083835; Owner: -
--

COPY "__DCIM_TARGET_SCHEMA__".cable_connection (id, cable_number, connection_type, cable_type, cable_color, cable_length_m, source_device_id, source_port_id, target_device_id, target_port_id, status, description, source_system, created_at, updated_at) FROM stdin;
conn-001	BJ-FIBER-001	network	SingleModeFiber	#3498db	3.00	dev-001	port-dev-001-sfp-1	dev-002	port-dev-002-sfp-1	active	核心到接入上联-1	mock	2023-02-25 08:00:00+00	2024-12-01 10:00:00+00
conn-002	BJ-FIBER-002	network	SingleModeFiber	#3498db	3.00	dev-001	port-dev-001-sfp-2	dev-002	port-dev-002-sfp-2	active	核心到接入上联-2	mock	2023-02-25 08:00:00+00	2024-12-01 10:00:00+00
conn-003	BJ-CAT6A-001	network	Cat6a	#2ecc71	2.00	dev-002	port-dev-002-rj45-1	dev-003	port-dev-003-eth-1	active	服务器A1-1业务网络	mock	2023-03-20 08:00:00+00	2024-11-20 14:00:00+00
conn-004	BJ-CAT6A-002	network	Cat6a	#2ecc71	2.00	dev-002	port-dev-002-rj45-2	dev-003	port-dev-003-eth-2	active	服务器A1-1管理网络	mock	2023-03-20 08:00:00+00	2024-11-20 14:00:00+00
conn-005	BJ-CAT6A-003	network	Cat6a	#2ecc71	2.00	dev-002	port-dev-002-rj45-3	dev-004	port-dev-004-eth-1	active	服务器A1-2业务网络	mock	2023-03-20 08:00:00+00	2024-11-20 14:00:00+00
conn-006	BJ-CAT6A-004	network	Cat6a	#2ecc71	2.00	dev-002	port-dev-002-rj45-4	dev-005	port-dev-005-eth-1	active	数据库服务器业务网络	mock	2023-04-10 08:00:00+00	2024-10-15 16:00:00+00
conn-007	BJ-FIBER-003	network	MultiModeFiber	#e67e22	5.00	dev-006	port-dev-006-sfp-1	dev-007	port-dev-007-sfp-1	active	防火墙到负载均衡	mock	2023-02-10 08:00:00+00	2024-11-28 11:00:00+00
conn-008	BJ-ISCSI-001	storage	Cat6a	#9b59b6	10.00	dev-005	port-dev-005-eth-2	dev-008	port-dev-008-iscsi-1	active	数据库到存储iSCSI连接	mock	2023-05-15 08:00:00+00	2024-09-20 09:00:00+00
conn-009	BJ-FIBER-004	network	SingleModeFiber	#3498db	15.00	dev-001	port-dev-001-sfp-3	dev-006	port-dev-006-sfp-2	active	核心交换机到防火墙	mock	2023-02-10 08:00:00+00	2024-12-01 10:00:00+00
conn-010	BJ-MGMT-001	management	Cat6	#27ae60	3.00	dev-002	port-dev-002-rj45-47	dev-003	port-dev-003-mgmt	active	服务器IPMI管理	mock	2023-03-20 08:00:00+00	2024-11-20 14:00:00+00
conn-ef46dae9	BJ-CAT6A-007	network	Cat6a	#3498db	11.00	dev-8d582d62	port-dev-8d582d62-pg-2-1	dev-002	port-dev-002-rj45-38	active	\N	database	2026-06-30 04:20:52.291077+00	2026-06-30 04:20:52.291077+00
\.


--
-- Data for Name: dashboard_snapshot; Type: TABLE DATA; Schema: dcim_ontology_demo_20260623083835; Owner: -
--

COPY "__DCIM_TARGET_SCHEMA__".dashboard_snapshot (id, snapshot_type, scope_id, payload, captured_at) FROM stdin;
snapshot-dashboard_stats	dashboard_stats	\N	{"uUsageRate": 0.65, "deviceCount": 12, "cabinetCount": 65, "errorDevices": 0, "recentAlerts": [{"id": "alert-001", "type": "port_usage", "level": "warning", "message": "端口利用率超过80%", "deviceId": "dev-010", "createdAt": "2024-12-05T09:00:00Z", "deviceName": "核心交换机-B1", "acknowledged": false}, {"id": "alert-002", "type": "maintenance", "level": "info", "message": "计划维护：存储系统固件升级", "deviceId": "dev-008", "createdAt": "2024-12-04T14:30:00Z", "deviceName": "核心存储-1", "acknowledged": true, "acknowledgedAt": "2024-12-04T15:00:00Z", "acknowledgedBy": "周存储"}, {"id": "alert-003", "type": "warranty", "level": "warning", "message": "设备质保将于90天后到期", "deviceId": "dev-001", "createdAt": "2024-12-03T08:00:00Z", "deviceName": "核心交换机-A1", "acknowledged": false}, {"id": "alert-004", "type": "device_online", "level": "info", "message": "设备上线", "deviceId": "dev-012", "createdAt": "2024-12-02T10:20:00Z", "deviceName": "GPU服务器-C1-1", "acknowledged": true, "acknowledgedAt": "2024-12-02T10:25:00Z", "acknowledgedBy": "钱AI"}], "onlineDevices": 11, "offlineDevices": 0, "warningDevices": 1, "connectionCount": 10, "datacenterCount": 4, "cabinetUsageRate": 1}	2026-06-23 08:38:42.107162+00
snapshot-device_trend	device_trend	\N	[{"date": "2026-06-17", "error": 0, "online": 11, "offline": 0, "warning": 0}, {"date": "2026-06-18", "error": 0, "online": 10, "offline": 1, "warning": 1}, {"date": "2026-06-19", "error": 0, "online": 11, "offline": 1, "warning": 0}, {"date": "2026-06-20", "error": 0, "online": 11, "offline": 1, "warning": 0}, {"date": "2026-06-21", "error": 0, "online": 11, "offline": 0, "warning": 1}, {"date": "2026-06-22", "error": 0, "online": 11, "offline": 0, "warning": 0}, {"date": "2026-06-23", "error": 0, "online": 10, "offline": 1, "warning": 1}]	2026-06-23 08:38:42.107162+00
snapshot-cabinet_usage_rank	cabinet_usage_rank	\N	[{"usage": 0.92, "cabinetId": "cab-bj-001", "cabinetName": "A区1排1号"}, {"usage": 0.88, "cabinetId": "cab-bj-003", "cabinetName": "A区1排3号"}, {"usage": 0.85, "cabinetId": "cab-sz-001", "cabinetName": "C区1排1号"}, {"usage": 0.82, "cabinetId": "cab-bj-002", "cabinetName": "A区1排2号"}, {"usage": 0.78, "cabinetId": "cab-sh-001", "cabinetName": "B区1排1号"}, {"usage": 0.75, "cabinetId": "cab-sz-002", "cabinetName": "C区1排2号"}, {"usage": 0.72, "cabinetId": "cab-bj-004", "cabinetName": "A区1排4号"}, {"usage": 0.68, "cabinetId": "cab-sh-002", "cabinetName": "B区1排2号"}, {"usage": 0.65, "cabinetId": "cab-bj-005", "cabinetName": "A区1排5号"}, {"usage": 0.6, "cabinetId": "cab-sz-003", "cabinetName": "C区1排3号"}]	2026-06-23 08:38:42.107162+00
snapshot-device_category	device_category	\N	[{"color": "#1890ff", "count": 5, "label": "交换机", "category": "switch"}, {"color": "#52c41a", "count": 4, "label": "服务器", "category": "server"}, {"color": "#faad14", "count": 1, "label": "存储", "category": "storage"}, {"color": "#f5222d", "count": 1, "label": "防火墙", "category": "firewall"}, {"color": "#722ed1", "count": 1, "label": "负载均衡", "category": "loadbalancer"}]	2026-06-23 08:38:42.107162+00
snapshot-datacenter_load	datacenter_load	\N	[{"name": "北京亦庄", "powerUsage": 0.65, "deviceCount": 8, "cabinetUsage": 1, "datacenterId": "dc-001"}, {"name": "上海嘉定", "powerUsage": 0.58, "deviceCount": 2, "cabinetUsage": 1, "datacenterId": "dc-002"}, {"name": "深圳坪山", "powerUsage": 0.62, "deviceCount": 2, "cabinetUsage": 1, "datacenterId": "dc-003"}, {"name": "成都天府", "powerUsage": 0.25, "deviceCount": 0, "cabinetUsage": 1, "datacenterId": "dc-004"}]	2026-06-23 08:38:42.107162+00
snapshot-power_redundancy	power_redundancy	\N	{"summary": {"totalDevices": 6, "dualPowerCount": 4, "redundancyRate": "66.67%", "singlePowerCount": 2}, "dualPower": [{"id": "dev-001", "load": 300, "name": "核心交换机-A1", "type": "device", "status": "online", "powerPaths": ["A", "B"], "datacenterId": "dc-001"}, {"id": "dev-002", "load": 350, "name": "接入交换机-A1-1", "type": "device", "status": "online", "powerPaths": ["A", "B"], "datacenterId": "dc-001"}, {"id": "dev-004", "load": 400, "name": "应用服务器-A1-2", "type": "device", "status": "online", "powerPaths": ["A", "B"], "datacenterId": "dc-001"}, {"id": "dev-009", "load": 280, "name": "接入交换机-B1-1", "type": "device", "status": "online", "powerPaths": ["A", "B"], "datacenterId": "dc-002"}], "singlePower": [{"id": "dev-003", "load": 150, "name": "应用服务器-A1-1", "risk": "single-point-failure", "type": "device", "status": "online", "powerPaths": ["A"], "datacenterId": "dc-001"}, {"id": "dev-010", "load": 320, "name": "核心交换机-B1", "risk": "single-point-failure", "type": "device", "status": "warning", "powerPaths": ["A"], "datacenterId": "dc-002"}]}	2026-06-23 08:38:42.107162+00
snapshot-power_load_balance	power_load_balance	\N	{"pathA": {"load": 38000, "percentage": "51.37%"}, "pathB": {"load": 35980, "percentage": "48.63%"}, "status": "balanced", "totalLoad": 73980, "balanceRate": "2.73%"}	2026-06-23 08:38:42.107162+00
snapshot-cabinet_environment	cabinet_environment	\N	[{"status": "normal", "cabinetId": "cab-bj-001", "avgHumidity": 37.8, "cabinetName": "A区1排1号", "datacenterId": "dc-001", "avgTemperature": 20.9, "datacenterName": "北京亦庄数据中心", "maxTemperature": 21.3, "minTemperature": 19.2}, {"status": "normal", "cabinetId": "cab-bj-002", "avgHumidity": 54.7, "cabinetName": "A区1排2号", "datacenterId": "dc-001", "avgTemperature": 22, "datacenterName": "北京亦庄数据中心", "maxTemperature": 23.9, "minTemperature": 21.9}, {"status": "normal", "cabinetId": "cab-bj-003", "avgHumidity": 51.6, "cabinetName": "A区1排3号", "datacenterId": "dc-001", "avgTemperature": 21.5, "datacenterName": "北京亦庄数据中心", "maxTemperature": 23.9, "minTemperature": 20.5}, {"status": "normal", "cabinetId": "cab-bj-004", "avgHumidity": 53.7, "cabinetName": "A区1排4号", "datacenterId": "dc-001", "avgTemperature": 22.7, "datacenterName": "北京亦庄数据中心", "maxTemperature": 23, "minTemperature": 22.3}, {"status": "warning", "cabinetId": "cab-bj-005", "avgHumidity": 38.3, "cabinetName": "A区1排5号", "datacenterId": "dc-001", "avgTemperature": 27.2, "datacenterName": "北京亦庄数据中心", "maxTemperature": 27.9, "minTemperature": 27.1}, {"status": "normal", "cabinetId": "cab-bj-006", "avgHumidity": 50.7, "cabinetName": "A区2排1号", "datacenterId": "dc-001", "avgTemperature": 23.8, "datacenterName": "北京亦庄数据中心", "maxTemperature": 25.6, "minTemperature": 23.1}, {"status": "warning", "cabinetId": "cab-bj-007", "avgHumidity": 37, "cabinetName": "A区2排2号", "datacenterId": "dc-001", "avgTemperature": 27.3, "datacenterName": "北京亦庄数据中心", "maxTemperature": 29.7, "minTemperature": 26.7}, {"status": "normal", "cabinetId": "cab-bj-008", "avgHumidity": 50.4, "cabinetName": "A区2排3号", "datacenterId": "dc-001", "avgTemperature": 25.1, "datacenterName": "北京亦庄数据中心", "maxTemperature": 25.3, "minTemperature": 24.5}, {"status": "normal", "cabinetId": "cab-bj-009", "avgHumidity": 35.1, "cabinetName": "A区2排4号", "datacenterId": "dc-001", "avgTemperature": 25.8, "datacenterName": "北京亦庄数据中心", "maxTemperature": 27.2, "minTemperature": 24.4}, {"status": "normal", "cabinetId": "cab-bj-010", "avgHumidity": 49.9, "cabinetName": "A区2排5号", "datacenterId": "dc-001", "avgTemperature": 22, "datacenterName": "北京亦庄数据中心", "maxTemperature": 22.3, "minTemperature": 21.5}, {"status": "warning", "cabinetId": "cab-bj-011", "avgHumidity": 37.1, "cabinetName": "A区3排1号", "datacenterId": "dc-001", "avgTemperature": 27.7, "datacenterName": "北京亦庄数据中心", "maxTemperature": 30.6, "minTemperature": 26.6}, {"status": "normal", "cabinetId": "cab-bj-012", "avgHumidity": 50.4, "cabinetName": "A区3排2号", "datacenterId": "dc-001", "avgTemperature": 21.1, "datacenterName": "北京亦庄数据中心", "maxTemperature": 23.1, "minTemperature": 19.2}, {"status": "normal", "cabinetId": "cab-bj-013", "avgHumidity": 51, "cabinetName": "A区3排3号", "datacenterId": "dc-001", "avgTemperature": 21, "datacenterName": "北京亦庄数据中心", "maxTemperature": 22.2, "minTemperature": 20.3}, {"status": "warning", "cabinetId": "cab-bj-014", "avgHumidity": 38.3, "cabinetName": "A区3排4号", "datacenterId": "dc-001", "avgTemperature": 26.4, "datacenterName": "北京亦庄数据中心", "maxTemperature": 28.3, "minTemperature": 24.5}, {"status": "normal", "cabinetId": "cab-bj-015", "avgHumidity": 42.3, "cabinetName": "A区3排5号", "datacenterId": "dc-001", "avgTemperature": 23.7, "datacenterName": "北京亦庄数据中心", "maxTemperature": 26.2, "minTemperature": 21.8}, {"status": "normal", "cabinetId": "cab-bj-016", "avgHumidity": 37.2, "cabinetName": "A区4排1号", "datacenterId": "dc-001", "avgTemperature": 26, "datacenterName": "北京亦庄数据中心", "maxTemperature": 27.5, "minTemperature": 25.8}, {"status": "normal", "cabinetId": "cab-bj-017", "avgHumidity": 37.5, "cabinetName": "A区4排2号", "datacenterId": "dc-001", "avgTemperature": 24.6, "datacenterName": "北京亦庄数据中心", "maxTemperature": 27.3, "minTemperature": 23.1}, {"status": "normal", "cabinetId": "cab-bj-018", "avgHumidity": 45.8, "cabinetName": "A区4排3号", "datacenterId": "dc-001", "avgTemperature": 22, "datacenterName": "北京亦庄数据中心", "maxTemperature": 24.7, "minTemperature": 21.4}, {"status": "normal", "cabinetId": "cab-bj-019", "avgHumidity": 42, "cabinetName": "A区4排4号", "datacenterId": "dc-001", "avgTemperature": 22.4, "datacenterName": "北京亦庄数据中心", "maxTemperature": 25.2, "minTemperature": 22.2}, {"status": "warning", "cabinetId": "cab-bj-020", "avgHumidity": 46.8, "cabinetName": "A区4排5号", "datacenterId": "dc-001", "avgTemperature": 27.1, "datacenterName": "北京亦庄数据中心", "maxTemperature": 28.3, "minTemperature": 26}, {"status": "normal", "cabinetId": "cab-sh-001", "avgHumidity": 37.6, "cabinetName": "B区1排1号", "datacenterId": "dc-002", "avgTemperature": 21.6, "datacenterName": "上海嘉定数据中心", "maxTemperature": 24, "minTemperature": 20.3}, {"status": "warning", "cabinetId": "cab-sh-002", "avgHumidity": 36.2, "cabinetName": "B区1排2号", "datacenterId": "dc-002", "avgTemperature": 27, "datacenterName": "上海嘉定数据中心", "maxTemperature": 27, "minTemperature": 26.8}, {"status": "warning", "cabinetId": "cab-sh-003", "avgHumidity": 48.1, "cabinetName": "B区1排3号", "datacenterId": "dc-002", "avgTemperature": 26.6, "datacenterName": "上海嘉定数据中心", "maxTemperature": 29.3, "minTemperature": 25.9}, {"status": "normal", "cabinetId": "cab-sh-004", "avgHumidity": 46.1, "cabinetName": "B区1排4号", "datacenterId": "dc-002", "avgTemperature": 22.4, "datacenterName": "上海嘉定数据中心", "maxTemperature": 23.5, "minTemperature": 22.1}, {"status": "normal", "cabinetId": "cab-sh-005", "avgHumidity": 43.7, "cabinetName": "B区1排5号", "datacenterId": "dc-002", "avgTemperature": 25.7, "datacenterName": "上海嘉定数据中心", "maxTemperature": 27.4, "minTemperature": 24.3}, {"status": "normal", "cabinetId": "cab-sh-006", "avgHumidity": 42.4, "cabinetName": "B区2排1号", "datacenterId": "dc-002", "avgTemperature": 20.2, "datacenterName": "上海嘉定数据中心", "maxTemperature": 21.6, "minTemperature": 19.2}, {"status": "normal", "cabinetId": "cab-sh-007", "avgHumidity": 45.8, "cabinetName": "B区2排2号", "datacenterId": "dc-002", "avgTemperature": 23.2, "datacenterName": "上海嘉定数据中心", "maxTemperature": 23.7, "minTemperature": 21.9}, {"status": "normal", "cabinetId": "cab-sh-008", "avgHumidity": 38.1, "cabinetName": "B区2排3号", "datacenterId": "dc-002", "avgTemperature": 20.3, "datacenterName": "上海嘉定数据中心", "maxTemperature": 21.3, "minTemperature": 18.5}, {"status": "normal", "cabinetId": "cab-sh-009", "avgHumidity": 37.3, "cabinetName": "B区2排4号", "datacenterId": "dc-002", "avgTemperature": 24.8, "datacenterName": "上海嘉定数据中心", "maxTemperature": 26.6, "minTemperature": 23.2}, {"status": "normal", "cabinetId": "cab-sh-010", "avgHumidity": 35.1, "cabinetName": "B区2排5号", "datacenterId": "dc-002", "avgTemperature": 22.4, "datacenterName": "上海嘉定数据中心", "maxTemperature": 23.9, "minTemperature": 20.5}, {"status": "normal", "cabinetId": "cab-sh-011", "avgHumidity": 36, "cabinetName": "B区3排1号", "datacenterId": "dc-002", "avgTemperature": 23, "datacenterName": "上海嘉定数据中心", "maxTemperature": 25.3, "minTemperature": 22.8}, {"status": "normal", "cabinetId": "cab-sh-012", "avgHumidity": 38.5, "cabinetName": "B区3排2号", "datacenterId": "dc-002", "avgTemperature": 22.6, "datacenterName": "上海嘉定数据中心", "maxTemperature": 24.6, "minTemperature": 20.7}, {"status": "normal", "cabinetId": "cab-sh-013", "avgHumidity": 50.6, "cabinetName": "B区3排3号", "datacenterId": "dc-002", "avgTemperature": 21.7, "datacenterName": "上海嘉定数据中心", "maxTemperature": 22.3, "minTemperature": 21.4}, {"status": "normal", "cabinetId": "cab-sh-014", "avgHumidity": 36.4, "cabinetName": "B区3排4号", "datacenterId": "dc-002", "avgTemperature": 25.9, "datacenterName": "上海嘉定数据中心", "maxTemperature": 28.5, "minTemperature": 24.9}, {"status": "normal", "cabinetId": "cab-sh-015", "avgHumidity": 37.7, "cabinetName": "B区3排5号", "datacenterId": "dc-002", "avgTemperature": 25.7, "datacenterName": "上海嘉定数据中心", "maxTemperature": 26.7, "minTemperature": 25.2}, {"status": "normal", "cabinetId": "cab-sz-001", "avgHumidity": 36.5, "cabinetName": "C区1排1号", "datacenterId": "dc-003", "avgTemperature": 24.8, "datacenterName": "深圳坪山数据中心", "maxTemperature": 25.4, "minTemperature": 24.5}, {"status": "warning", "cabinetId": "cab-sz-002", "avgHumidity": 49.2, "cabinetName": "C区1排2号", "datacenterId": "dc-003", "avgTemperature": 26.7, "datacenterName": "深圳坪山数据中心", "maxTemperature": 28.1, "minTemperature": 25.5}, {"status": "normal", "cabinetId": "cab-sz-003", "avgHumidity": 38.9, "cabinetName": "C区1排3号", "datacenterId": "dc-003", "avgTemperature": 26, "datacenterName": "深圳坪山数据中心", "maxTemperature": 26.1, "minTemperature": 25.1}, {"status": "normal", "cabinetId": "cab-sz-004", "avgHumidity": 49.9, "cabinetName": "C区1排4号", "datacenterId": "dc-003", "avgTemperature": 23.8, "datacenterName": "深圳坪山数据中心", "maxTemperature": 26.6, "minTemperature": 23.3}, {"status": "normal", "cabinetId": "cab-sz-005", "avgHumidity": 45.9, "cabinetName": "C区1排5号", "datacenterId": "dc-003", "avgTemperature": 25.3, "datacenterName": "深圳坪山数据中心", "maxTemperature": 28.2, "minTemperature": 24.4}, {"status": "warning", "cabinetId": "cab-sz-006", "avgHumidity": 47.6, "cabinetName": "C区1排6号", "datacenterId": "dc-003", "avgTemperature": 26.7, "datacenterName": "深圳坪山数据中心", "maxTemperature": 28.5, "minTemperature": 25}, {"status": "normal", "cabinetId": "cab-sz-007", "avgHumidity": 41.4, "cabinetName": "C区2排1号", "datacenterId": "dc-003", "avgTemperature": 25.3, "datacenterName": "深圳坪山数据中心", "maxTemperature": 27.2, "minTemperature": 25.2}, {"status": "normal", "cabinetId": "cab-sz-008", "avgHumidity": 49.2, "cabinetName": "C区2排2号", "datacenterId": "dc-003", "avgTemperature": 22.2, "datacenterName": "深圳坪山数据中心", "maxTemperature": 23.8, "minTemperature": 21.7}, {"status": "normal", "cabinetId": "cab-sz-009", "avgHumidity": 45, "cabinetName": "C区2排3号", "datacenterId": "dc-003", "avgTemperature": 20.9, "datacenterName": "深圳坪山数据中心", "maxTemperature": 21.4, "minTemperature": 19.6}, {"status": "normal", "cabinetId": "cab-sz-010", "avgHumidity": 50.1, "cabinetName": "C区2排4号", "datacenterId": "dc-003", "avgTemperature": 24.3, "datacenterName": "深圳坪山数据中心", "maxTemperature": 26, "minTemperature": 24.1}, {"status": "warning", "cabinetId": "cab-sz-011", "avgHumidity": 48, "cabinetName": "C区2排5号", "datacenterId": "dc-003", "avgTemperature": 26.4, "datacenterName": "深圳坪山数据中心", "maxTemperature": 26.8, "minTemperature": 24.6}, {"status": "normal", "cabinetId": "cab-sz-012", "avgHumidity": 35.3, "cabinetName": "C区2排6号", "datacenterId": "dc-003", "avgTemperature": 21.2, "datacenterName": "深圳坪山数据中心", "maxTemperature": 21.7, "minTemperature": 20.6}, {"status": "normal", "cabinetId": "cab-sz-013", "avgHumidity": 47.7, "cabinetName": "C区3排1号", "datacenterId": "dc-003", "avgTemperature": 24, "datacenterName": "深圳坪山数据中心", "maxTemperature": 24.8, "minTemperature": 22.2}, {"status": "normal", "cabinetId": "cab-sz-014", "avgHumidity": 43.6, "cabinetName": "C区3排2号", "datacenterId": "dc-003", "avgTemperature": 20.4, "datacenterName": "深圳坪山数据中心", "maxTemperature": 23.1, "minTemperature": 19}, {"status": "normal", "cabinetId": "cab-sz-015", "avgHumidity": 36.6, "cabinetName": "C区3排3号", "datacenterId": "dc-003", "avgTemperature": 24.9, "datacenterName": "深圳坪山数据中心", "maxTemperature": 25.7, "minTemperature": 23.1}, {"status": "normal", "cabinetId": "cab-sz-016", "avgHumidity": 54.9, "cabinetName": "C区3排4号", "datacenterId": "dc-003", "avgTemperature": 22.9, "datacenterName": "深圳坪山数据中心", "maxTemperature": 24.1, "minTemperature": 22.7}, {"status": "normal", "cabinetId": "cab-sz-017", "avgHumidity": 49.9, "cabinetName": "C区3排5号", "datacenterId": "dc-003", "avgTemperature": 24.5, "datacenterName": "深圳坪山数据中心", "maxTemperature": 26.1, "minTemperature": 24.2}, {"status": "normal", "cabinetId": "cab-sz-018", "avgHumidity": 35.9, "cabinetName": "C区3排6号", "datacenterId": "dc-003", "avgTemperature": 25.5, "datacenterName": "深圳坪山数据中心", "maxTemperature": 25.7, "minTemperature": 23.6}, {"status": "normal", "cabinetId": "cab-cd-001", "avgHumidity": 38.2, "cabinetName": "D区1排1号", "datacenterId": "dc-004", "avgTemperature": 25.1, "datacenterName": "成都天府数据中心", "maxTemperature": 26.2, "minTemperature": 23.3}, {"status": "normal", "cabinetId": "cab-cd-002", "avgHumidity": 42.5, "cabinetName": "D区1排2号", "datacenterId": "dc-004", "avgTemperature": 26, "datacenterName": "成都天府数据中心", "maxTemperature": 26.9, "minTemperature": 25.3}, {"status": "normal", "cabinetId": "cab-cd-003", "avgHumidity": 41.8, "cabinetName": "D区1排3号", "datacenterId": "dc-004", "avgTemperature": 22, "datacenterName": "成都天府数据中心", "maxTemperature": 23.9, "minTemperature": 21}, {"status": "normal", "cabinetId": "cab-cd-004", "avgHumidity": 35, "cabinetName": "D区1排4号", "datacenterId": "dc-004", "avgTemperature": 22.1, "datacenterName": "成都天府数据中心", "maxTemperature": 22.7, "minTemperature": 20.3}, {"status": "normal", "cabinetId": "cab-cd-005", "avgHumidity": 50, "cabinetName": "D区2排1号", "datacenterId": "dc-004", "avgTemperature": 24, "datacenterName": "成都天府数据中心", "maxTemperature": 26.2, "minTemperature": 22.5}, {"status": "normal", "cabinetId": "cab-cd-006", "avgHumidity": 35.1, "cabinetName": "D区2排2号", "datacenterId": "dc-004", "avgTemperature": 21.9, "datacenterName": "成都天府数据中心", "maxTemperature": 22.4, "minTemperature": 20.3}, {"status": "normal", "cabinetId": "cab-cd-007", "avgHumidity": 38.4, "cabinetName": "D区2排3号", "datacenterId": "dc-004", "avgTemperature": 23.5, "datacenterName": "成都天府数据中心", "maxTemperature": 25.1, "minTemperature": 21.7}, {"status": "normal", "cabinetId": "cab-cd-008", "avgHumidity": 46.8, "cabinetName": "D区2排4号", "datacenterId": "dc-004", "avgTemperature": 25.3, "datacenterName": "成都天府数据中心", "maxTemperature": 28, "minTemperature": 23.7}, {"status": "normal", "cabinetId": "cab-cd-009", "avgHumidity": 54.1, "cabinetName": "D区3排1号", "datacenterId": "dc-004", "avgTemperature": 20.6, "datacenterName": "成都天府数据中心", "maxTemperature": 22.9, "minTemperature": 20.2}, {"status": "normal", "cabinetId": "cab-cd-010", "avgHumidity": 51.6, "cabinetName": "D区3排2号", "datacenterId": "dc-004", "avgTemperature": 23.2, "datacenterName": "成都天府数据中心", "maxTemperature": 26.1, "minTemperature": 22.1}, {"status": "normal", "cabinetId": "cab-cd-011", "avgHumidity": 36.5, "cabinetName": "D区3排3号", "datacenterId": "dc-004", "avgTemperature": 22.9, "datacenterName": "成都天府数据中心", "maxTemperature": 24.9, "minTemperature": 21.1}, {"status": "warning", "cabinetId": "cab-cd-012", "avgHumidity": 42.7, "cabinetName": "D区3排4号", "datacenterId": "dc-004", "avgTemperature": 26.5, "datacenterName": "成都天府数据中心", "maxTemperature": 28.6, "minTemperature": 25.5}]	2026-06-23 08:38:42.107162+00
snapshot-temperature_trend	temperature_trend	\N	[{"timestamp": "2026-06-22T08:38:38.184Z", "avgTemperature": 25.6, "maxTemperature": 28.9, "minTemperature": 22.4}, {"timestamp": "2026-06-22T09:38:38.184Z", "avgTemperature": 24.3, "maxTemperature": 28.9, "minTemperature": 23.8}, {"timestamp": "2026-06-22T10:38:38.184Z", "avgTemperature": 25.4, "maxTemperature": 28.8, "minTemperature": 22.2}, {"timestamp": "2026-06-22T11:38:38.184Z", "avgTemperature": 24.5, "maxTemperature": 27.1, "minTemperature": 21.7}, {"timestamp": "2026-06-22T12:38:38.184Z", "avgTemperature": 22.3, "maxTemperature": 28, "minTemperature": 21}, {"timestamp": "2026-06-22T13:38:38.184Z", "avgTemperature": 21.4, "maxTemperature": 26.2, "minTemperature": 21.2}, {"timestamp": "2026-06-22T14:38:38.184Z", "avgTemperature": 23.1, "maxTemperature": 26.1, "minTemperature": 20.4}, {"timestamp": "2026-06-22T15:38:38.184Z", "avgTemperature": 21.4, "maxTemperature": 27.6, "minTemperature": 21.9}, {"timestamp": "2026-06-22T16:38:38.184Z", "avgTemperature": 23.5, "maxTemperature": 24.3, "minTemperature": 21.8}, {"timestamp": "2026-06-22T17:38:38.184Z", "avgTemperature": 24.2, "maxTemperature": 25.4, "minTemperature": 21.3}, {"timestamp": "2026-06-22T18:38:38.184Z", "avgTemperature": 24.2, "maxTemperature": 27.6, "minTemperature": 20.3}, {"timestamp": "2026-06-22T19:38:38.184Z", "avgTemperature": 22, "maxTemperature": 27, "minTemperature": 20.3}, {"timestamp": "2026-06-22T20:38:38.184Z", "avgTemperature": 23.9, "maxTemperature": 25.4, "minTemperature": 20.4}, {"timestamp": "2026-06-22T21:38:38.184Z", "avgTemperature": 22.3, "maxTemperature": 26.8, "minTemperature": 21.4}, {"timestamp": "2026-06-22T22:38:38.184Z", "avgTemperature": 22, "maxTemperature": 26.7, "minTemperature": 21.1}, {"timestamp": "2026-06-22T23:38:38.184Z", "avgTemperature": 21, "maxTemperature": 25.1, "minTemperature": 21.1}, {"timestamp": "2026-06-23T00:38:38.184Z", "avgTemperature": 23.4, "maxTemperature": 27.4, "minTemperature": 21.4}, {"timestamp": "2026-06-23T01:38:38.184Z", "avgTemperature": 24.2, "maxTemperature": 26.6, "minTemperature": 22.6}, {"timestamp": "2026-06-23T02:38:38.184Z", "avgTemperature": 23.3, "maxTemperature": 29.3, "minTemperature": 22.3}, {"timestamp": "2026-06-23T03:38:38.184Z", "avgTemperature": 23.2, "maxTemperature": 29.3, "minTemperature": 23.7}, {"timestamp": "2026-06-23T04:38:38.184Z", "avgTemperature": 26.9, "maxTemperature": 26.9, "minTemperature": 22.8}, {"timestamp": "2026-06-23T05:38:38.184Z", "avgTemperature": 24.3, "maxTemperature": 29, "minTemperature": 23.5}, {"timestamp": "2026-06-23T06:38:38.184Z", "avgTemperature": 24, "maxTemperature": 26.2, "minTemperature": 22.5}, {"timestamp": "2026-06-23T07:38:38.184Z", "avgTemperature": 23.5, "maxTemperature": 28.4, "minTemperature": 23.1}, {"timestamp": "2026-06-23T08:38:38.184Z", "avgTemperature": 24, "maxTemperature": 27.2, "minTemperature": 23.7}]	2026-06-23 08:38:42.107162+00
snapshot-energy_stats	energy_stats	\N	{"avgPue": 1.42, "totalCost": 87976, "totalEnergy": 125680, "carbonEmission": 62840, "comparedLastMonth": -3.2}	2026-06-23 08:38:42.107162+00
snapshot-environment_overview	environment_overview	\N	{"avgPue": 1.42, "totalPower": 186.5, "avgHumidity": 45.2, "totalCabinets": 65, "avgTemperature": 24.5, "maxTemperature": 29.8, "minTemperature": 21.2, "normalCabinets": 60, "warningCabinets": 4, "criticalCabinets": 1, "maxTemperatureCabinet": "A区1排3号"}	2026-06-23 08:38:42.107162+00
snapshot-alert_stats	alert_stats	\N	{"info": 1, "error": 1, "total": 6, "warning": 3, "critical": 1, "todayNew": 0, "avgResolveTime": 45, "unacknowledged": 3}	2026-06-23 08:38:42.107162+00
\.


--
-- Data for Name: datacenter; Type: TABLE DATA; Schema: dcim_ontology_demo_20260623083835; Owner: -
--

COPY "__DCIM_TARGET_SCHEMA__".datacenter (id, name, code, address, area_sqm, lifecycle_status, description, contact, phone, source_system, created_at, updated_at) FROM stdin;
dc-001	北京亦庄数据中心	BJ-YZ-DC01	北京市大兴区亦庄经济开发区科创十一街	5000.00	active	一级数据中心，承载核心业务系统	张运维	13800138001	mock	2023-01-15 08:00:00+00	2024-12-01 10:30:00+00
dc-002	上海嘉定数据中心	SH-JD-DC01	上海市嘉定区安亭镇墨玉南路888号	3500.00	active	二级数据中心，承载备份和测试环境	李运维	13900139002	mock	2023-06-20 09:00:00+00	2024-11-15 14:20:00+00
dc-003	深圳坪山数据中心	SZ-PS-DC01	深圳市坪山区坪山大道2007号	4200.00	active	华南区域核心数据中心	王运维	13700137003	mock	2023-03-10 10:00:00+00	2024-10-20 16:45:00+00
dc-004	成都天府数据中心	CD-TF-DC01	成都市天府新区华阳街道正南街	2800.00	maintenance	西南区域数据中心，扩容中	赵运维	13600136004	mock	2024-01-08 11:00:00+00	2024-12-05 09:15:00+00
\.


--
-- Data for Name: device; Type: TABLE DATA; Schema: dcim_ontology_demo_20260623083835; Owner: -
--

COPY "__DCIM_TARGET_SCHEMA__".device (id, template_id, asset_code, name, serial_number, management_ip, operational_status, purchase_date, warranty_expiry, vendor, owner, department, description, source_system, created_at, updated_at) FROM stdin;
dev-001	tpl-huawei-s6730-48x6c	BJ-NET-SW-001	核心交换机-A1	HW21035678901	10.0.1.1	online	2023-02-15	2026-02-15	华为技术服务商	张运维	网络运维部	A区核心交换机	mock	2023-02-20 08:00:00+00	2024-12-01 10:00:00+00
dev-002	tpl-huawei-s5735-48t4x	BJ-NET-SW-002	接入交换机-A1-1	HW21035678902	10.0.1.2	online	2023-02-15	2026-02-15	华为技术服务商	张运维	网络运维部	\N	mock	2023-02-20 08:00:00+00	2024-12-01 10:00:00+00
dev-003	tpl-huawei-2288h-v6	BJ-SRV-001	应用服务器-A1-1	HW2188SRV001	10.0.10.1	online	2023-03-10	2026-03-10	华为技术服务商	李开发	应用开发部	\N	mock	2023-03-15 08:00:00+00	2024-11-20 14:00:00+00
dev-004	tpl-huawei-2288h-v6	BJ-SRV-002	应用服务器-A1-2	HW2188SRV002	10.0.10.2	online	2023-03-10	2026-03-10	华为技术服务商	李开发	应用开发部	\N	mock	2023-03-15 08:00:00+00	2024-11-20 14:00:00+00
dev-005	tpl-dell-r750	BJ-SRV-003	数据库服务器-A1-1	DELL750DB001	10.0.20.1	online	2023-04-01	2026-04-01	Dell企业服务	王DBA	数据库运维部	\N	mock	2023-04-05 08:00:00+00	2024-10-15 16:00:00+00
dev-006	tpl-huawei-usg6680	BJ-SEC-FW-001	边界防火墙-1	HWUSG6680001	10.0.254.1	online	2023-01-20	2026-01-20	华为安全服务商	赵安全	安全运维部	\N	mock	2023-01-25 08:00:00+00	2024-12-01 10:00:00+00
dev-007	tpl-f5-big-ip-i5800	BJ-NET-LB-001	负载均衡器-1	F5BIGIP001	10.0.253.1	online	2023-02-01	2026-02-01	F5中国	张运维	网络运维部	\N	mock	2023-02-05 08:00:00+00	2024-11-28 11:00:00+00
dev-008	tpl-huawei-oceanstor-5500	BJ-STG-001	核心存储-1	HWOCEAN5500001	10.0.30.1	online	2023-05-01	2028-05-01	华为存储服务商	周存储	存储运维部	\N	mock	2023-05-10 08:00:00+00	2024-09-20 09:00:00+00
dev-009	tpl-cisco-c9300-48p	SH-NET-SW-001	接入交换机-B1-1	CISCO9300001	10.1.1.1	online	2023-07-01	2026-07-01	思科中国	李运维	网络运维部	\N	mock	2023-07-10 08:00:00+00	2024-11-15 14:00:00+00
dev-010	tpl-cisco-n9k-93180yc	SH-NET-SW-002	核心交换机-B1	CISCON9K001	10.1.1.2	warning	2023-07-01	2026-07-01	思科中国	李运维	网络运维部	端口利用率过高	mock	2023-07-10 08:00:00+00	2024-12-05 09:00:00+00
dev-011	tpl-h3c-s6850-56hf	SZ-NET-SW-001	汇聚交换机-C1	H3CS6850001	10.2.1.1	online	2023-04-01	2026-04-01	H3C华三	王运维	网络运维部	\N	mock	2023-04-10 08:00:00+00	2024-10-20 16:00:00+00
dev-012	tpl-inspur-nf5280m6	SZ-SRV-001	GPU服务器-C1-1	INSPURNF001	10.2.10.1	online	2024-01-15	2027-01-15	浪潮信息	钱AI	AI研发部	GPU计算节点	mock	2024-01-20 08:00:00+00	2024-11-10 10:00:00+00
dev-f9f15364	tpl-custom-83749738	ACCESS-003	应用服务器-A1-3	sabccc1234	10.1.1.4	online	2026-06-01	2026-06-30	Dell	张三	安全运维部	\N	database	2026-06-30 03:37:09.654782+00	2026-06-30 03:37:09.654782+00
dev-8d582d62	tpl-custom-83749738	APP-A1-4	应用服务器-A1-4	abc123	10.1.12.1	online	2026-06-01	2026-06-04	Dell	张三	存储运维部	\N	database	2026-06-30 04:10:53.863017+00	2026-06-30 04:41:26.611963+00
dev-9635142f	tpl-custom-83749738	ssss	ssss	sss	1.1.1.1	online	\N	\N	\N	\N	\N	\N	database	2026-07-03 03:18:59.888657+00	2026-07-03 03:18:59.888657+00
\.


--
-- Data for Name: device_template; Type: TABLE DATA; Schema: dcim_ontology_demo_20260623083835; Owner: -
--

COPY "__DCIM_TARGET_SCHEMA__".device_template (id, name, category, brand, model, u_height, front_color, rear_color, model3d_url, image_url, is_builtin, max_power_w, spec_json, description, source_system, created_at, updated_at) FROM stdin;
tpl-huawei-s5735-48t4x	华为S5735-L48T4X-A	switch	华为	S5735-L48T4X-A	1	#1a1a1a	\N	\N	\N	t	\N	{"MAC地址表": "16K", "交换容量": "176Gbps", "包转发率": "131Mpps"}	华为S5735系列企业级接入交换机，48个千兆电口+4个万兆上行口	mock	2023-01-01 00:00:00+00	2023-01-01 00:00:00+00
tpl-huawei-s6730-48x6c	华为S6730-H48X6C	switch	华为	S6730-H48X6C	1	#1a1a1a	\N	\N	\N	t	\N	{"MAC地址表": "196K", "交换容量": "2.56Tbps", "包转发率": "1080Mpps"}	华为S6730系列数据中心级交换机，48个万兆光口+6个100G上行口	mock	2023-01-01 00:00:00+00	2023-01-01 00:00:00+00
tpl-huawei-ce6881-48s6cq	华为CE6881-48S6CQ	switch	华为	CE6881-48S6CQ	1	#2d2d2d	\N	\N	\N	t	\N	{"交换容量": "3.6Tbps", "包转发率": "2160Mpps"}	华为CloudEngine 6800系列数据中心交换机	mock	2023-01-01 00:00:00+00	2023-01-01 00:00:00+00
tpl-cisco-c9300-48p	Cisco Catalyst 9300-48P	switch	思科	C9300-48P	1	#1e3a5f	\N	\N	\N	t	\N	{"PoE功率": "437W", "交换容量": "208Gbps", "堆叠带宽": "480Gbps"}	Cisco Catalyst 9300系列企业级交换机，支持PoE+	mock	2023-01-01 00:00:00+00	2023-01-01 00:00:00+00
tpl-cisco-n9k-93180yc	Cisco Nexus 93180YC-FX	switch	思科	N9K-C93180YC-FX	1	#1e3a5f	\N	\N	\N	t	\N	{"延迟": "<1μs", "交换容量": "3.6Tbps"}	Cisco Nexus 9000系列数据中心交换机	mock	2023-01-01 00:00:00+00	2023-01-01 00:00:00+00
tpl-h3c-s6850-56hf	H3C S6850-56HF	switch	H3C	S6850-56HF	1	#e63946	\N	\N	\N	t	\N	{"交换容量": "1.76Tbps", "包转发率": "1080Mpps"}	H3C S6850系列数据中心交换机	mock	2023-01-01 00:00:00+00	2023-01-01 00:00:00+00
tpl-ruijie-s6220-48xs6qxs	锐捷RG-S6220-48XS6QXS	switch	锐捷	RG-S6220-48XS6QXS	1	#0066cc	\N	\N	\N	t	\N	{}	锐捷S6220系列数据中心交换机	mock	2023-01-01 00:00:00+00	2023-01-01 00:00:00+00
tpl-huawei-2288h-v6	华为FusionServer 2288H V6	server	华为	2288H V6	2	#2d2d2d	\N	\N	\N	t	\N	{"CPU": "2×Intel Xeon Gold 6348", "内存": "最大6TB DDR4", "存储": "25×2.5寸硬盘"}	华为2U双路服务器，支持第三代Intel Xeon可扩展处理器	mock	2023-01-01 00:00:00+00	2023-01-01 00:00:00+00
tpl-dell-r750	Dell PowerEdge R750	server	Dell	PowerEdge R750	2	#1a1a1a	\N	\N	\N	t	\N	{"CPU": "2×Intel Xeon Gold", "内存": "最大4TB DDR4", "存储": "24×2.5寸或12×3.5寸"}	Dell 2U双路服务器	mock	2023-01-01 00:00:00+00	2023-01-01 00:00:00+00
tpl-hpe-dl380-gen10	HPE ProLiant DL380 Gen10	server	HPE	DL380 Gen10	2	#4a4a4a	\N	\N	\N	t	\N	{}	HPE 2U双路服务器	mock	2023-01-01 00:00:00+00	2023-01-01 00:00:00+00
tpl-inspur-nf5280m6	浪潮NF5280M6	server	浪潮	NF5280M6	2	#003366	\N	\N	\N	t	\N	{}	浪潮2U双路服务器	mock	2023-01-01 00:00:00+00	2023-01-01 00:00:00+00
tpl-huawei-ne40e-x8	华为NE40E-X8	router	华为	NE40E-X8	14	#2d2d2d	\N	\N	\N	t	\N	{}	华为NE40E系列高端路由器	mock	2023-01-01 00:00:00+00	2023-01-01 00:00:00+00
tpl-cisco-asr-9000	Cisco ASR 9006	router	思科	ASR 9006	13	#1e3a5f	\N	\N	\N	t	\N	{}	Cisco ASR 9000系列运营商级路由器	mock	2023-01-01 00:00:00+00	2023-01-01 00:00:00+00
tpl-huawei-oceanstor-5500	华为OceanStor 5500 V5	storage	华为	OceanStor 5500 V5	4	#1a1a1a	\N	\N	\N	t	\N	{}	华为OceanStor企业级全闪存存储	mock	2023-01-01 00:00:00+00	2023-01-01 00:00:00+00
tpl-huawei-usg6680	华为USG6680	firewall	华为	USG6680	2	#8b0000	\N	\N	\N	t	\N	{}	华为下一代防火墙	mock	2023-01-01 00:00:00+00	2023-01-01 00:00:00+00
tpl-f5-big-ip-i5800	F5 BIG-IP i5800	loadbalancer	F5	BIG-IP i5800	1	#cc0000	\N	\N	\N	t	\N	{}	F5 BIG-IP应用交付控制器	mock	2023-01-01 00:00:00+00	2023-01-01 00:00:00+00
tpl-pdu-001	APC AP7921	pdu	APC	AP7921	2	\N	\N	\N	\N	t	3000.00	{"maxLoad": "3000W", "outputPorts": 16, "inputVoltage": "220V", "ratedCurrent": "16A"}	\N	mock	2024-01-01 00:00:00+00	2024-01-01 00:00:00+00
tpl-pdu-002	Schneider AP8941	pdu	Schneider	AP8941	2	\N	\N	\N	\N	t	5000.00	{"maxLoad": "5000W", "outputPorts": 24, "inputVoltage": "220V", "ratedCurrent": "32A"}	\N	mock	2024-01-01 00:00:00+00	2024-01-01 00:00:00+00
tpl-custom-83749738	Dell-R650S	server	Dell	R650S	2	#3d3d3d	\N	\N	\N	f	1000.00	{}	\N	database	2026-06-23 16:18:49.819691+00	2026-06-23 16:18:49.819691+00
\.


--
-- Data for Name: layout_cabinet_position; Type: TABLE DATA; Schema: dcim_ontology_demo_20260623083835; Owner: -
--

COPY "__DCIM_TARGET_SCHEMA__".layout_cabinet_position (datacenter_id, cabinet_id, x, y, rotation) FROM stdin;
\.


--
-- Data for Name: layout_facility; Type: TABLE DATA; Schema: dcim_ontology_demo_20260623083835; Owner: -
--

COPY "__DCIM_TARGET_SCHEMA__".layout_facility (id, datacenter_id, facility_type, name, x, y, rotation) FROM stdin;
\.


--
-- Data for Name: layout_snapshot; Type: TABLE DATA; Schema: dcim_ontology_demo_20260623083835; Owner: -
--

COPY "__DCIM_TARGET_SCHEMA__".layout_snapshot (datacenter_id, version, canvas_width, canvas_height, px_per_meter, raw_json, updated_at) FROM stdin;
dc-002	1	60.00	40.00	50.00	{"zones": [], "version": 1, "cabinets": [], "updatedAt": "2026-06-23T08:38:42.001Z", "facilities": [], "pxPerMeter": 50, "canvasWidth": 60, "canvasHeight": 40, "datacenterId": "dc-002"}	2026-06-23 08:38:42.001+00
dc-003	1	60.00	40.00	50.00	{"zones": [], "version": 1, "cabinets": [], "updatedAt": "2026-06-23T08:38:42.001Z", "facilities": [], "pxPerMeter": 50, "canvasWidth": 60, "canvasHeight": 40, "datacenterId": "dc-003"}	2026-06-23 08:38:42.001+00
dc-004	1	60.00	40.00	50.00	{"zones": [], "version": 1, "cabinets": [], "updatedAt": "2026-06-23T08:38:42.001Z", "facilities": [], "pxPerMeter": 50, "canvasWidth": 60, "canvasHeight": 40, "datacenterId": "dc-004"}	2026-06-23 08:38:42.001+00
dc-001	53	15.00	10.00	50.00	{"zones": [{"x": 10.100000000000001, "y": 0.1, "id": "zone_0zjelthq3n6p_1782273549706", "name": "测试区", "type": "zone", "color": "rgba(82, 196, 26, 0.12)", "width": 4.800000000000001, "height": 4.800000000000001, "rotation": 0}, {"x": 2.2, "y": 2.7, "id": "zone_3xfsgzjdwkk_1782277007092", "name": "冷通道", "type": "cold_aisle", "color": "rgba(22, 119, 255, 0.10)", "width": 3.9000000000000004, "height": 0.2, "rotation": 0}, {"x": 2.2, "y": 5.300000000000001, "id": "zone_hjk6d5zycw_1782277095567", "name": "热通道", "type": "hot_aisle", "color": "rgba(245, 34, 45, 0.10)", "width": 3.8000000000000003, "height": 0.2, "rotation": 0}], "version": 53, "cabinets": [{"x": 2.2, "y": 8, "rotation": 0, "cabinetId": "cab-bj-001"}, {"x": 2.8000000000000003, "y": 8, "rotation": 0, "cabinetId": "cab-bj-002"}, {"x": 3.4000000000000004, "y": 8, "rotation": 0, "cabinetId": "cab-bj-003"}, {"x": 4, "y": 8, "rotation": 0, "cabinetId": "cab-bj-004"}, {"x": 4.6000000000000005, "y": 8, "rotation": 0, "cabinetId": "cab-bj-005"}, {"x": 2.2, "y": 3.7, "rotation": 0, "cabinetId": "cab-bj-006"}, {"x": 2.8000000000000003, "y": 3.7, "rotation": 0, "cabinetId": "cab-bj-007"}, {"x": 3.4000000000000004, "y": 3.7, "rotation": 0, "cabinetId": "cab-bj-008"}, {"x": 4, "y": 3.7, "rotation": 0, "cabinetId": "cab-bj-009"}, {"x": 4.6000000000000005, "y": 3.7, "rotation": 0, "cabinetId": "cab-bj-010"}, {"x": 2.2, "y": 6, "rotation": 0, "cabinetId": "cab-bj-011"}, {"x": 2.8000000000000003, "y": 6, "rotation": 0, "cabinetId": "cab-bj-012"}, {"x": 3.4000000000000004, "y": 6, "rotation": 0, "cabinetId": "cab-bj-013"}, {"x": 4, "y": 6, "rotation": 0, "cabinetId": "cab-bj-014"}, {"x": 4.6000000000000005, "y": 6, "rotation": 0, "cabinetId": "cab-bj-015"}, {"x": 4.6000000000000005, "y": 0.9, "rotation": 0, "cabinetId": "cab-bj-016"}, {"x": 2.2, "y": 0.9, "rotation": 0, "cabinetId": "cab-bj-017"}, {"x": 2.8000000000000003, "y": 0.9, "rotation": 0, "cabinetId": "cab-bj-018"}, {"x": 3.4000000000000004, "y": 0.9, "rotation": 0, "cabinetId": "cab-bj-019"}, {"x": 4, "y": 0.9, "rotation": 0, "cabinetId": "cab-bj-020"}, {"x": 5.2, "y": 8, "rotation": 0, "cabinetId": "cab-b62e1eb2"}, {"x": 6.9, "y": 6, "rotation": 0, "cabinetId": "cab-b9ad0d40"}], "updatedAt": "2026-07-03T03:15:02.230Z", "facilities": [{"x": 9.5, "y": 0.4, "id": "facility_v3o0jn9ub2p_1782277017528", "name": "fire_extinguisher", "type": "fire_extinguisher", "rotation": 0}, {"x": 11.600000000000001, "y": 0, "id": "facility_9k167oualb_1782281163706", "name": "door", "type": "door", "rotation": 0}, {"x": 10.600000000000001, "y": 5.5, "id": "facility_a28ua9gk7vc_1782281170093", "name": "sensor-01", "type": "sensor", "rotation": 0}, {"x": 10.600000000000001, "y": 9.4, "id": "facility_v85exkn0mo_1782281176992", "name": "ups", "type": "ups", "rotation": 0}, {"x": 0.30000000000000004, "y": 7.7, "id": "facility_cgbsbnv1udj_1782296131138", "name": "camera-01", "type": "camera", "pitch": -30, "height": 4, "rotation": 90}, {"x": 9.5, "y": 9.4, "id": "facility_58nusql05en_1782296337591", "name": "camera-02", "type": "camera", "pitch": -30, "height": 4, "rotation": -30}, {"x": 0.5, "y": 0.4, "id": "facility_607j2iqzs7v_1782296467260", "name": "空调-01", "type": "crac", "rotation": 0}], "pxPerMeter": 50, "canvasWidth": 15, "canvasHeight": 10, "datacenterId": "dc-001"}	2026-07-03 03:15:02.23+00
\.


--
-- Data for Name: layout_zone; Type: TABLE DATA; Schema: dcim_ontology_demo_20260623083835; Owner: -
--

COPY "__DCIM_TARGET_SCHEMA__".layout_zone (id, datacenter_id, zone_type, name, x, y, width, height, rotation, color) FROM stdin;
\.


--
-- Data for Name: managed_user; Type: TABLE DATA; Schema: dcim_ontology_demo_20260623083835; Owner: -
--

COPY "__DCIM_TARGET_SCHEMA__".managed_user (id, username, name, email, phone, role, status, avatar, title, department, created_at, updated_at, last_login_at, password_salt, password_hash) FROM stdin;
u_admin	admin	系统管理员	admin@datacenter.local	\N	admin	active	https://gw.alipayobjects.com/zos/antfincdn/XAosXuNZyF/BiazfanxmamNRoxxVxka.png	系统管理员	平台管理部	2026-06-23 16:03:49.154944+00	2026-07-21 09:03:44.174942+00	2026-07-21 09:03:44.174942+00	73acc52bc210f93b23227eb3	c763c452b7d92d89b131a542c5f9a550845442a26463e79a3a75be2877b0398a
u_user	user	普通用户	user@datacenter.local	\N	user	active	\N	运维工程师	数据中心运维部	2026-06-23 16:03:49.154944+00	2026-07-16 04:12:05.712654+00	2026-07-16 04:12:05.712654+00	0d6a3aa673b2035c144f3dac	2edee5a260fe2d379101614e77dd81842ab1e620e62adb0138b8fa5ba377c5c1
\.


--
-- Data for Name: mock_raw_payload; Type: TABLE DATA; Schema: dcim_ontology_demo_20260623083835; Owner: -
--

COPY "__DCIM_TARGET_SCHEMA__".mock_raw_payload (id, source_name, payload, captured_at) FROM stdin;
raw-datacenters	datacenters	[{"id": "dc-001", "area": 5000, "code": "BJ-YZ-DC01", "name": "北京亦庄数据中心", "phone": "13800138001", "status": "active", "address": "北京市大兴区亦庄经济开发区科创十一街", "contact": "张运维", "createdAt": "2023-01-15T08:00:00Z", "updatedAt": "2024-12-01T10:30:00Z", "description": "一级数据中心，承载核心业务系统", "usedCabinets": 20, "totalCabinets": 20}, {"id": "dc-002", "area": 3500, "code": "SH-JD-DC01", "name": "上海嘉定数据中心", "phone": "13900139002", "status": "active", "address": "上海市嘉定区安亭镇墨玉南路888号", "contact": "李运维", "createdAt": "2023-06-20T09:00:00Z", "updatedAt": "2024-11-15T14:20:00Z", "description": "二级数据中心，承载备份和测试环境", "usedCabinets": 15, "totalCabinets": 15}, {"id": "dc-003", "area": 4200, "code": "SZ-PS-DC01", "name": "深圳坪山数据中心", "phone": "13700137003", "status": "active", "address": "深圳市坪山区坪山大道2007号", "contact": "王运维", "createdAt": "2023-03-10T10:00:00Z", "updatedAt": "2024-10-20T16:45:00Z", "description": "华南区域核心数据中心", "usedCabinets": 18, "totalCabinets": 18}, {"id": "dc-004", "area": 2800, "code": "CD-TF-DC01", "name": "成都天府数据中心", "phone": "13600136004", "status": "maintenance", "address": "成都市天府新区华阳街道正南街", "contact": "赵运维", "createdAt": "2024-01-08T11:00:00Z", "updatedAt": "2024-12-05T09:15:00Z", "description": "西南区域数据中心，扩容中", "usedCabinets": 12, "totalCabinets": 12}]	2026-06-23 08:38:42.107162+00
raw-cabinets	cabinets	[{"id": "cab-bj-001", "row": 1, "code": "BJ-YZ-A1-01", "name": "A区1排1号机柜", "usedU": 6, "column": 1, "status": "warning", "uHeight": 42, "maxPower": 10000, "createdAt": "2023-01-20T08:00:00Z", "updatedAt": "2024-12-01T10:30:00Z", "description": "A区标准机柜", "currentPower": 2407, "datacenterId": "dc-001", "datacenterName": "北京亦庄数据中心"}, {"id": "cab-bj-002", "row": 1, "code": "BJ-YZ-A1-02", "name": "A区1排2号机柜", "usedU": 8, "column": 2, "status": "normal", "uHeight": 42, "maxPower": 10000, "createdAt": "2023-01-20T08:00:00Z", "updatedAt": "2024-12-01T10:30:00Z", "description": "A区标准机柜", "currentPower": 4068, "datacenterId": "dc-001", "datacenterName": "北京亦庄数据中心"}, {"id": "cab-bj-003", "row": 1, "code": "BJ-YZ-A1-03", "name": "A区1排3号机柜", "usedU": 13, "column": 3, "status": "normal", "uHeight": 42, "maxPower": 10000, "createdAt": "2023-01-20T08:00:00Z", "updatedAt": "2024-12-01T10:30:00Z", "description": "A区标准机柜", "currentPower": 5421, "datacenterId": "dc-001", "datacenterName": "北京亦庄数据中心"}, {"id": "cab-bj-004", "row": 1, "code": "BJ-YZ-A1-04", "name": "A区1排4号机柜", "usedU": 13, "column": 4, "status": "normal", "uHeight": 42, "maxPower": 10000, "createdAt": "2023-01-20T08:00:00Z", "updatedAt": "2024-12-01T10:30:00Z", "description": "A区标准机柜", "currentPower": 2470, "datacenterId": "dc-001", "datacenterName": "北京亦庄数据中心"}, {"id": "cab-bj-005", "row": 1, "code": "BJ-YZ-A1-05", "name": "A区1排5号机柜", "usedU": 35, "column": 5, "status": "normal", "uHeight": 42, "maxPower": 10000, "createdAt": "2023-01-20T08:00:00Z", "updatedAt": "2024-12-01T10:30:00Z", "description": "A区标准机柜", "currentPower": 7469, "datacenterId": "dc-001", "datacenterName": "北京亦庄数据中心"}, {"id": "cab-bj-006", "row": 2, "code": "BJ-YZ-A2-01", "name": "A区2排1号机柜", "usedU": 5, "column": 1, "status": "normal", "uHeight": 42, "maxPower": 10000, "createdAt": "2023-01-20T08:00:00Z", "updatedAt": "2024-12-01T10:30:00Z", "description": "A区标准机柜", "currentPower": 2190, "datacenterId": "dc-001", "datacenterName": "北京亦庄数据中心"}, {"id": "cab-bj-007", "row": 2, "code": "BJ-YZ-A2-02", "name": "A区2排2号机柜", "usedU": 5, "column": 2, "status": "normal", "uHeight": 42, "maxPower": 10000, "createdAt": "2023-01-20T08:00:00Z", "updatedAt": "2024-12-01T10:30:00Z", "description": "A区标准机柜", "currentPower": 6112, "datacenterId": "dc-001", "datacenterName": "北京亦庄数据中心"}, {"id": "cab-bj-008", "row": 2, "code": "BJ-YZ-A2-03", "name": "A区2排3号机柜", "usedU": 7, "column": 3, "status": "normal", "uHeight": 42, "maxPower": 10000, "createdAt": "2023-01-20T08:00:00Z", "updatedAt": "2024-12-01T10:30:00Z", "description": "A区标准机柜", "currentPower": 4048, "datacenterId": "dc-001", "datacenterName": "北京亦庄数据中心"}, {"id": "cab-bj-009", "row": 2, "code": "BJ-YZ-A2-04", "name": "A区2排4号机柜", "usedU": 35, "column": 4, "status": "normal", "uHeight": 42, "maxPower": 10000, "createdAt": "2023-01-20T08:00:00Z", "updatedAt": "2024-12-01T10:30:00Z", "description": "A区标准机柜", "currentPower": 3504, "datacenterId": "dc-001", "datacenterName": "北京亦庄数据中心"}, {"id": "cab-bj-010", "row": 2, "code": "BJ-YZ-A2-05", "name": "A区2排5号机柜", "usedU": 14, "column": 5, "status": "normal", "uHeight": 42, "maxPower": 10000, "createdAt": "2023-01-20T08:00:00Z", "updatedAt": "2024-12-01T10:30:00Z", "description": "A区标准机柜", "currentPower": 3996, "datacenterId": "dc-001", "datacenterName": "北京亦庄数据中心"}, {"id": "cab-bj-011", "row": 3, "code": "BJ-YZ-A3-01", "name": "A区3排1号机柜", "usedU": 20, "column": 1, "status": "warning", "uHeight": 42, "maxPower": 10000, "createdAt": "2023-01-20T08:00:00Z", "updatedAt": "2024-12-01T10:30:00Z", "description": "A区标准机柜", "currentPower": 2745, "datacenterId": "dc-001", "datacenterName": "北京亦庄数据中心"}, {"id": "cab-bj-012", "row": 3, "code": "BJ-YZ-A3-02", "name": "A区3排2号机柜", "usedU": 22, "column": 2, "status": "normal", "uHeight": 42, "maxPower": 10000, "createdAt": "2023-01-20T08:00:00Z", "updatedAt": "2024-12-01T10:30:00Z", "description": "A区标准机柜", "currentPower": 7410, "datacenterId": "dc-001", "datacenterName": "北京亦庄数据中心"}, {"id": "cab-bj-013", "row": 3, "code": "BJ-YZ-A3-03", "name": "A区3排3号机柜", "usedU": 25, "column": 3, "status": "normal", "uHeight": 42, "maxPower": 10000, "createdAt": "2023-01-20T08:00:00Z", "updatedAt": "2024-12-01T10:30:00Z", "description": "A区标准机柜", "currentPower": 3094, "datacenterId": "dc-001", "datacenterName": "北京亦庄数据中心"}, {"id": "cab-bj-014", "row": 3, "code": "BJ-YZ-A3-04", "name": "A区3排4号机柜", "usedU": 20, "column": 4, "status": "normal", "uHeight": 42, "maxPower": 10000, "createdAt": "2023-01-20T08:00:00Z", "updatedAt": "2024-12-01T10:30:00Z", "description": "A区标准机柜", "currentPower": 6434, "datacenterId": "dc-001", "datacenterName": "北京亦庄数据中心"}, {"id": "cab-bj-015", "row": 3, "code": "BJ-YZ-A3-05", "name": "A区3排5号机柜", "usedU": 21, "column": 5, "status": "normal", "uHeight": 42, "maxPower": 10000, "createdAt": "2023-01-20T08:00:00Z", "updatedAt": "2024-12-01T10:30:00Z", "description": "A区标准机柜", "currentPower": 4146, "datacenterId": "dc-001", "datacenterName": "北京亦庄数据中心"}, {"id": "cab-bj-016", "row": 4, "code": "BJ-YZ-A4-01", "name": "A区4排1号机柜", "usedU": 24, "column": 1, "status": "normal", "uHeight": 42, "maxPower": 10000, "createdAt": "2023-01-20T08:00:00Z", "updatedAt": "2024-12-01T10:30:00Z", "description": "A区标准机柜", "currentPower": 2049, "datacenterId": "dc-001", "datacenterName": "北京亦庄数据中心"}, {"id": "cab-bj-017", "row": 4, "code": "BJ-YZ-A4-02", "name": "A区4排2号机柜", "usedU": 35, "column": 2, "status": "normal", "uHeight": 42, "maxPower": 10000, "createdAt": "2023-01-20T08:00:00Z", "updatedAt": "2024-12-01T10:30:00Z", "description": "A区标准机柜", "currentPower": 6479, "datacenterId": "dc-001", "datacenterName": "北京亦庄数据中心"}, {"id": "cab-bj-018", "row": 4, "code": "BJ-YZ-A4-03", "name": "A区4排3号机柜", "usedU": 37, "column": 3, "status": "normal", "uHeight": 42, "maxPower": 10000, "createdAt": "2023-01-20T08:00:00Z", "updatedAt": "2024-12-01T10:30:00Z", "description": "A区标准机柜", "currentPower": 4605, "datacenterId": "dc-001", "datacenterName": "北京亦庄数据中心"}, {"id": "cab-bj-019", "row": 4, "code": "BJ-YZ-A4-04", "name": "A区4排4号机柜", "usedU": 18, "column": 4, "status": "normal", "uHeight": 42, "maxPower": 10000, "createdAt": "2023-01-20T08:00:00Z", "updatedAt": "2024-12-01T10:30:00Z", "description": "A区标准机柜", "currentPower": 5546, "datacenterId": "dc-001", "datacenterName": "北京亦庄数据中心"}, {"id": "cab-bj-020", "row": 4, "code": "BJ-YZ-A4-05", "name": "A区4排5号机柜", "usedU": 36, "column": 5, "status": "normal", "uHeight": 42, "maxPower": 10000, "createdAt": "2023-01-20T08:00:00Z", "updatedAt": "2024-12-01T10:30:00Z", "description": "A区标准机柜", "currentPower": 5325, "datacenterId": "dc-001", "datacenterName": "北京亦庄数据中心"}, {"id": "cab-sh-001", "row": 1, "code": "SH-JD-B1-01", "name": "B区1排1号机柜", "usedU": 16, "column": 1, "status": "warning", "uHeight": 42, "maxPower": 10000, "createdAt": "2023-06-25T09:00:00Z", "updatedAt": "2024-11-15T14:20:00Z", "description": "B区标准机柜", "currentPower": 5294, "datacenterId": "dc-002", "datacenterName": "上海嘉定数据中心"}, {"id": "cab-sh-002", "row": 1, "code": "SH-JD-B1-02", "name": "B区1排2号机柜", "usedU": 13, "column": 2, "status": "normal", "uHeight": 42, "maxPower": 10000, "createdAt": "2023-06-25T09:00:00Z", "updatedAt": "2024-11-15T14:20:00Z", "description": "B区标准机柜", "currentPower": 6540, "datacenterId": "dc-002", "datacenterName": "上海嘉定数据中心"}, {"id": "cab-sh-003", "row": 1, "code": "SH-JD-B1-03", "name": "B区1排3号机柜", "usedU": 35, "column": 3, "status": "normal", "uHeight": 42, "maxPower": 10000, "createdAt": "2023-06-25T09:00:00Z", "updatedAt": "2024-11-15T14:20:00Z", "description": "B区标准机柜", "currentPower": 5864, "datacenterId": "dc-002", "datacenterName": "上海嘉定数据中心"}, {"id": "cab-sh-004", "row": 1, "code": "SH-JD-B1-04", "name": "B区1排4号机柜", "usedU": 16, "column": 4, "status": "normal", "uHeight": 42, "maxPower": 10000, "createdAt": "2023-06-25T09:00:00Z", "updatedAt": "2024-11-15T14:20:00Z", "description": "B区标准机柜", "currentPower": 6056, "datacenterId": "dc-002", "datacenterName": "上海嘉定数据中心"}, {"id": "cab-sh-005", "row": 1, "code": "SH-JD-B1-05", "name": "B区1排5号机柜", "usedU": 18, "column": 5, "status": "normal", "uHeight": 42, "maxPower": 10000, "createdAt": "2023-06-25T09:00:00Z", "updatedAt": "2024-11-15T14:20:00Z", "description": "B区标准机柜", "currentPower": 5077, "datacenterId": "dc-002", "datacenterName": "上海嘉定数据中心"}, {"id": "cab-sh-006", "row": 2, "code": "SH-JD-B2-01", "name": "B区2排1号机柜", "usedU": 9, "column": 1, "status": "normal", "uHeight": 42, "maxPower": 10000, "createdAt": "2023-06-25T09:00:00Z", "updatedAt": "2024-11-15T14:20:00Z", "description": "B区标准机柜", "currentPower": 2922, "datacenterId": "dc-002", "datacenterName": "上海嘉定数据中心"}, {"id": "cab-sh-007", "row": 2, "code": "SH-JD-B2-02", "name": "B区2排2号机柜", "usedU": 15, "column": 2, "status": "normal", "uHeight": 42, "maxPower": 10000, "createdAt": "2023-06-25T09:00:00Z", "updatedAt": "2024-11-15T14:20:00Z", "description": "B区标准机柜", "currentPower": 4516, "datacenterId": "dc-002", "datacenterName": "上海嘉定数据中心"}, {"id": "cab-sh-008", "row": 2, "code": "SH-JD-B2-03", "name": "B区2排3号机柜", "usedU": 28, "column": 3, "status": "normal", "uHeight": 42, "maxPower": 10000, "createdAt": "2023-06-25T09:00:00Z", "updatedAt": "2024-11-15T14:20:00Z", "description": "B区标准机柜", "currentPower": 2675, "datacenterId": "dc-002", "datacenterName": "上海嘉定数据中心"}, {"id": "cab-sh-009", "row": 2, "code": "SH-JD-B2-04", "name": "B区2排4号机柜", "usedU": 35, "column": 4, "status": "warning", "uHeight": 42, "maxPower": 10000, "createdAt": "2023-06-25T09:00:00Z", "updatedAt": "2024-11-15T14:20:00Z", "description": "B区标准机柜", "currentPower": 6708, "datacenterId": "dc-002", "datacenterName": "上海嘉定数据中心"}, {"id": "cab-sh-010", "row": 2, "code": "SH-JD-B2-05", "name": "B区2排5号机柜", "usedU": 22, "column": 5, "status": "normal", "uHeight": 42, "maxPower": 10000, "createdAt": "2023-06-25T09:00:00Z", "updatedAt": "2024-11-15T14:20:00Z", "description": "B区标准机柜", "currentPower": 5016, "datacenterId": "dc-002", "datacenterName": "上海嘉定数据中心"}, {"id": "cab-sh-011", "row": 3, "code": "SH-JD-B3-01", "name": "B区3排1号机柜", "usedU": 13, "column": 1, "status": "normal", "uHeight": 42, "maxPower": 10000, "createdAt": "2023-06-25T09:00:00Z", "updatedAt": "2024-11-15T14:20:00Z", "description": "B区标准机柜", "currentPower": 1884, "datacenterId": "dc-002", "datacenterName": "上海嘉定数据中心"}, {"id": "cab-sh-012", "row": 3, "code": "SH-JD-B3-02", "name": "B区3排2号机柜", "usedU": 14, "column": 2, "status": "normal", "uHeight": 42, "maxPower": 10000, "createdAt": "2023-06-25T09:00:00Z", "updatedAt": "2024-11-15T14:20:00Z", "description": "B区标准机柜", "currentPower": 4960, "datacenterId": "dc-002", "datacenterName": "上海嘉定数据中心"}, {"id": "cab-sh-013", "row": 3, "code": "SH-JD-B3-03", "name": "B区3排3号机柜", "usedU": 32, "column": 3, "status": "normal", "uHeight": 42, "maxPower": 10000, "createdAt": "2023-06-25T09:00:00Z", "updatedAt": "2024-11-15T14:20:00Z", "description": "B区标准机柜", "currentPower": 4315, "datacenterId": "dc-002", "datacenterName": "上海嘉定数据中心"}, {"id": "cab-sh-014", "row": 3, "code": "SH-JD-B3-04", "name": "B区3排4号机柜", "usedU": 23, "column": 4, "status": "normal", "uHeight": 42, "maxPower": 10000, "createdAt": "2023-06-25T09:00:00Z", "updatedAt": "2024-11-15T14:20:00Z", "description": "B区标准机柜", "currentPower": 6171, "datacenterId": "dc-002", "datacenterName": "上海嘉定数据中心"}, {"id": "cab-sh-015", "row": 3, "code": "SH-JD-B3-05", "name": "B区3排5号机柜", "usedU": 26, "column": 5, "status": "normal", "uHeight": 42, "maxPower": 10000, "createdAt": "2023-06-25T09:00:00Z", "updatedAt": "2024-11-15T14:20:00Z", "description": "B区标准机柜", "currentPower": 2175, "datacenterId": "dc-002", "datacenterName": "上海嘉定数据中心"}, {"id": "cab-sz-001", "row": 1, "code": "SZ-PS-C1-01", "name": "C区1排1号机柜", "usedU": 20, "column": 1, "status": "normal", "uHeight": 47, "maxPower": 12000, "createdAt": "2023-03-15T10:00:00Z", "updatedAt": "2024-10-20T16:45:00Z", "description": "C区高密度机柜", "currentPower": 9366, "datacenterId": "dc-003", "datacenterName": "深圳坪山数据中心"}, {"id": "cab-sz-002", "row": 1, "code": "SZ-PS-C1-02", "name": "C区1排2号机柜", "usedU": 25, "column": 2, "status": "normal", "uHeight": 47, "maxPower": 12000, "createdAt": "2023-03-15T10:00:00Z", "updatedAt": "2024-10-20T16:45:00Z", "description": "C区高密度机柜", "currentPower": 4894, "datacenterId": "dc-003", "datacenterName": "深圳坪山数据中心"}, {"id": "cab-sz-003", "row": 1, "code": "SZ-PS-C1-03", "name": "C区1排3号机柜", "usedU": 15, "column": 3, "status": "normal", "uHeight": 47, "maxPower": 12000, "createdAt": "2023-03-15T10:00:00Z", "updatedAt": "2024-10-20T16:45:00Z", "description": "C区高密度机柜", "currentPower": 8451, "datacenterId": "dc-003", "datacenterName": "深圳坪山数据中心"}, {"id": "cab-sz-004", "row": 1, "code": "SZ-PS-C1-04", "name": "C区1排4号机柜", "usedU": 20, "column": 4, "status": "normal", "uHeight": 47, "maxPower": 12000, "createdAt": "2023-03-15T10:00:00Z", "updatedAt": "2024-10-20T16:45:00Z", "description": "C区高密度机柜", "currentPower": 5513, "datacenterId": "dc-003", "datacenterName": "深圳坪山数据中心"}, {"id": "cab-sz-005", "row": 1, "code": "SZ-PS-C1-05", "name": "C区1排5号机柜", "usedU": 38, "column": 5, "status": "normal", "uHeight": 47, "maxPower": 12000, "createdAt": "2023-03-15T10:00:00Z", "updatedAt": "2024-10-20T16:45:00Z", "description": "C区高密度机柜", "currentPower": 6667, "datacenterId": "dc-003", "datacenterName": "深圳坪山数据中心"}, {"id": "cab-sz-006", "row": 1, "code": "SZ-PS-C1-06", "name": "C区1排6号机柜", "usedU": 14, "column": 6, "status": "normal", "uHeight": 47, "maxPower": 12000, "createdAt": "2023-03-15T10:00:00Z", "updatedAt": "2024-10-20T16:45:00Z", "description": "C区高密度机柜", "currentPower": 2810, "datacenterId": "dc-003", "datacenterName": "深圳坪山数据中心"}, {"id": "cab-sz-007", "row": 2, "code": "SZ-PS-C2-01", "name": "C区2排1号机柜", "usedU": 18, "column": 1, "status": "normal", "uHeight": 47, "maxPower": 12000, "createdAt": "2023-03-15T10:00:00Z", "updatedAt": "2024-10-20T16:45:00Z", "description": "C区高密度机柜", "currentPower": 8960, "datacenterId": "dc-003", "datacenterName": "深圳坪山数据中心"}, {"id": "cab-sz-008", "row": 2, "code": "SZ-PS-C2-02", "name": "C区2排2号机柜", "usedU": 30, "column": 2, "status": "normal", "uHeight": 47, "maxPower": 12000, "createdAt": "2023-03-15T10:00:00Z", "updatedAt": "2024-10-20T16:45:00Z", "description": "C区高密度机柜", "currentPower": 6536, "datacenterId": "dc-003", "datacenterName": "深圳坪山数据中心"}, {"id": "cab-sz-009", "row": 2, "code": "SZ-PS-C2-03", "name": "C区2排3号机柜", "usedU": 32, "column": 3, "status": "normal", "uHeight": 47, "maxPower": 12000, "createdAt": "2023-03-15T10:00:00Z", "updatedAt": "2024-10-20T16:45:00Z", "description": "C区高密度机柜", "currentPower": 4411, "datacenterId": "dc-003", "datacenterName": "深圳坪山数据中心"}, {"id": "cab-sz-010", "row": 2, "code": "SZ-PS-C2-04", "name": "C区2排4号机柜", "usedU": 12, "column": 4, "status": "normal", "uHeight": 47, "maxPower": 12000, "createdAt": "2023-03-15T10:00:00Z", "updatedAt": "2024-10-20T16:45:00Z", "description": "C区高密度机柜", "currentPower": 8917, "datacenterId": "dc-003", "datacenterName": "深圳坪山数据中心"}, {"id": "cab-sz-011", "row": 2, "code": "SZ-PS-C2-05", "name": "C区2排5号机柜", "usedU": 24, "column": 5, "status": "normal", "uHeight": 47, "maxPower": 12000, "createdAt": "2023-03-15T10:00:00Z", "updatedAt": "2024-10-20T16:45:00Z", "description": "C区高密度机柜", "currentPower": 6645, "datacenterId": "dc-003", "datacenterName": "深圳坪山数据中心"}, {"id": "cab-sz-012", "row": 2, "code": "SZ-PS-C2-06", "name": "C区2排6号机柜", "usedU": 15, "column": 6, "status": "normal", "uHeight": 47, "maxPower": 12000, "createdAt": "2023-03-15T10:00:00Z", "updatedAt": "2024-10-20T16:45:00Z", "description": "C区高密度机柜", "currentPower": 9188, "datacenterId": "dc-003", "datacenterName": "深圳坪山数据中心"}, {"id": "cab-sz-013", "row": 3, "code": "SZ-PS-C3-01", "name": "C区3排1号机柜", "usedU": 30, "column": 1, "status": "normal", "uHeight": 47, "maxPower": 12000, "createdAt": "2023-03-15T10:00:00Z", "updatedAt": "2024-10-20T16:45:00Z", "description": "C区高密度机柜", "currentPower": 7708, "datacenterId": "dc-003", "datacenterName": "深圳坪山数据中心"}, {"id": "cab-sz-014", "row": 3, "code": "SZ-PS-C3-02", "name": "C区3排2号机柜", "usedU": 6, "column": 2, "status": "normal", "uHeight": 47, "maxPower": 12000, "createdAt": "2023-03-15T10:00:00Z", "updatedAt": "2024-10-20T16:45:00Z", "description": "C区高密度机柜", "currentPower": 7777, "datacenterId": "dc-003", "datacenterName": "深圳坪山数据中心"}, {"id": "cab-sz-015", "row": 3, "code": "SZ-PS-C3-03", "name": "C区3排3号机柜", "usedU": 30, "column": 3, "status": "normal", "uHeight": 47, "maxPower": 12000, "createdAt": "2023-03-15T10:00:00Z", "updatedAt": "2024-10-20T16:45:00Z", "description": "C区高密度机柜", "currentPower": 7597, "datacenterId": "dc-003", "datacenterName": "深圳坪山数据中心"}, {"id": "cab-sz-016", "row": 3, "code": "SZ-PS-C3-04", "name": "C区3排4号机柜", "usedU": 23, "column": 4, "status": "normal", "uHeight": 47, "maxPower": 12000, "createdAt": "2023-03-15T10:00:00Z", "updatedAt": "2024-10-20T16:45:00Z", "description": "C区高密度机柜", "currentPower": 7941, "datacenterId": "dc-003", "datacenterName": "深圳坪山数据中心"}, {"id": "cab-sz-017", "row": 3, "code": "SZ-PS-C3-05", "name": "C区3排5号机柜", "usedU": 17, "column": 5, "status": "normal", "uHeight": 47, "maxPower": 12000, "createdAt": "2023-03-15T10:00:00Z", "updatedAt": "2024-10-20T16:45:00Z", "description": "C区高密度机柜", "currentPower": 2637, "datacenterId": "dc-003", "datacenterName": "深圳坪山数据中心"}, {"id": "cab-sz-018", "row": 3, "code": "SZ-PS-C3-06", "name": "C区3排6号机柜", "usedU": 38, "column": 6, "status": "normal", "uHeight": 47, "maxPower": 12000, "createdAt": "2023-03-15T10:00:00Z", "updatedAt": "2024-10-20T16:45:00Z", "description": "C区高密度机柜", "currentPower": 7658, "datacenterId": "dc-003", "datacenterName": "深圳坪山数据中心"}, {"id": "cab-cd-001", "row": 1, "code": "CD-TF-D1-01", "name": "D区1排1号机柜", "usedU": 7, "column": 1, "status": "warning", "uHeight": 42, "maxPower": 10000, "createdAt": "2024-01-08T11:00:00Z", "updatedAt": "2024-12-05T09:15:00Z", "description": "D区标准机柜", "currentPower": 3328, "datacenterId": "dc-004", "datacenterName": "成都天府数据中心"}, {"id": "cab-cd-002", "row": 1, "code": "CD-TF-D1-02", "name": "D区1排2号机柜", "usedU": 20, "column": 2, "status": "normal", "uHeight": 42, "maxPower": 10000, "createdAt": "2024-01-08T11:00:00Z", "updatedAt": "2024-12-05T09:15:00Z", "description": "D区标准机柜", "currentPower": 2096, "datacenterId": "dc-004", "datacenterName": "成都天府数据中心"}, {"id": "cab-cd-003", "row": 1, "code": "CD-TF-D1-03", "name": "D区1排3号机柜", "usedU": 9, "column": 3, "status": "normal", "uHeight": 42, "maxPower": 10000, "createdAt": "2024-01-08T11:00:00Z", "updatedAt": "2024-12-05T09:15:00Z", "description": "D区标准机柜", "currentPower": 4740, "datacenterId": "dc-004", "datacenterName": "成都天府数据中心"}, {"id": "cab-cd-004", "row": 1, "code": "CD-TF-D1-04", "name": "D区1排4号机柜", "usedU": 5, "column": 4, "status": "normal", "uHeight": 42, "maxPower": 10000, "createdAt": "2024-01-08T11:00:00Z", "updatedAt": "2024-12-05T09:15:00Z", "description": "D区标准机柜", "currentPower": 4187, "datacenterId": "dc-004", "datacenterName": "成都天府数据中心"}, {"id": "cab-cd-005", "row": 2, "code": "CD-TF-D2-01", "name": "D区2排1号机柜", "usedU": 7, "column": 1, "status": "normal", "uHeight": 42, "maxPower": 10000, "createdAt": "2024-01-08T11:00:00Z", "updatedAt": "2024-12-05T09:15:00Z", "description": "D区标准机柜", "currentPower": 2578, "datacenterId": "dc-004", "datacenterName": "成都天府数据中心"}, {"id": "cab-cd-006", "row": 2, "code": "CD-TF-D2-02", "name": "D区2排2号机柜", "usedU": 17, "column": 2, "status": "normal", "uHeight": 42, "maxPower": 10000, "createdAt": "2024-01-08T11:00:00Z", "updatedAt": "2024-12-05T09:15:00Z", "description": "D区标准机柜", "currentPower": 4133, "datacenterId": "dc-004", "datacenterName": "成都天府数据中心"}, {"id": "cab-cd-007", "row": 2, "code": "CD-TF-D2-03", "name": "D区2排3号机柜", "usedU": 3, "column": 3, "status": "warning", "uHeight": 42, "maxPower": 10000, "createdAt": "2024-01-08T11:00:00Z", "updatedAt": "2024-12-05T09:15:00Z", "description": "D区标准机柜", "currentPower": 4187, "datacenterId": "dc-004", "datacenterName": "成都天府数据中心"}, {"id": "cab-cd-008", "row": 2, "code": "CD-TF-D2-04", "name": "D区2排4号机柜", "usedU": 12, "column": 4, "status": "normal", "uHeight": 42, "maxPower": 10000, "createdAt": "2024-01-08T11:00:00Z", "updatedAt": "2024-12-05T09:15:00Z", "description": "D区标准机柜", "currentPower": 3010, "datacenterId": "dc-004", "datacenterName": "成都天府数据中心"}, {"id": "cab-cd-009", "row": 3, "code": "CD-TF-D3-01", "name": "D区3排1号机柜", "usedU": 13, "column": 1, "status": "normal", "uHeight": 42, "maxPower": 10000, "createdAt": "2024-01-08T11:00:00Z", "updatedAt": "2024-12-05T09:15:00Z", "description": "D区标准机柜", "currentPower": 3770, "datacenterId": "dc-004", "datacenterName": "成都天府数据中心"}, {"id": "cab-cd-010", "row": 3, "code": "CD-TF-D3-02", "name": "D区3排2号机柜", "usedU": 7, "column": 2, "status": "normal", "uHeight": 42, "maxPower": 10000, "createdAt": "2024-01-08T11:00:00Z", "updatedAt": "2024-12-05T09:15:00Z", "description": "D区标准机柜", "currentPower": 1527, "datacenterId": "dc-004", "datacenterName": "成都天府数据中心"}, {"id": "cab-cd-011", "row": 3, "code": "CD-TF-D3-03", "name": "D区3排3号机柜", "usedU": 19, "column": 3, "status": "normal", "uHeight": 42, "maxPower": 10000, "createdAt": "2024-01-08T11:00:00Z", "updatedAt": "2024-12-05T09:15:00Z", "description": "D区标准机柜", "currentPower": 1627, "datacenterId": "dc-004", "datacenterName": "成都天府数据中心"}, {"id": "cab-cd-012", "row": 3, "code": "CD-TF-D3-04", "name": "D区3排4号机柜", "usedU": 4, "column": 4, "status": "normal", "uHeight": 42, "maxPower": 10000, "createdAt": "2024-01-08T11:00:00Z", "updatedAt": "2024-12-05T09:15:00Z", "description": "D区标准机柜", "currentPower": 1177, "datacenterId": "dc-004", "datacenterName": "成都天府数据中心"}]	2026-06-23 08:38:42.107162+00
raw-deviceTemplates	deviceTemplates	[{"id": "tpl-huawei-s5735-48t4x", "name": "华为S5735-L48T4X-A", "brand": "华为", "model": "S5735-L48T4X-A", "specs": {"MAC地址表": "16K", "交换容量": "176Gbps", "包转发率": "131Mpps"}, "uHeight": 1, "category": "switch", "createdAt": "2023-01-01T00:00:00Z", "isBuiltin": true, "updatedAt": "2023-01-01T00:00:00Z", "frontColor": "#1a1a1a", "portGroups": [{"id": "pg-1", "poe": false, "name": "千兆电口", "count": 48, "speed": "1G", "portType": "RJ45"}, {"id": "pg-2", "poe": false, "name": "万兆光口", "count": 4, "speed": "10G", "portType": "SFP+"}], "description": "华为S5735系列企业级接入交换机，48个千兆电口+4个万兆上行口"}, {"id": "tpl-huawei-s6730-48x6c", "name": "华为S6730-H48X6C", "brand": "华为", "model": "S6730-H48X6C", "specs": {"MAC地址表": "196K", "交换容量": "2.56Tbps", "包转发率": "1080Mpps"}, "uHeight": 1, "category": "switch", "createdAt": "2023-01-01T00:00:00Z", "isBuiltin": true, "updatedAt": "2023-01-01T00:00:00Z", "frontColor": "#1a1a1a", "portGroups": [{"id": "pg-1", "poe": false, "name": "万兆光口", "count": 48, "speed": "10G", "portType": "SFP+"}, {"id": "pg-2", "poe": false, "name": "100G光口", "count": 6, "speed": "100G", "portType": "QSFP28"}], "description": "华为S6730系列数据中心级交换机，48个万兆光口+6个100G上行口"}, {"id": "tpl-huawei-ce6881-48s6cq", "name": "华为CE6881-48S6CQ", "brand": "华为", "model": "CE6881-48S6CQ", "specs": {"交换容量": "3.6Tbps", "包转发率": "2160Mpps"}, "uHeight": 1, "category": "switch", "createdAt": "2023-01-01T00:00:00Z", "isBuiltin": true, "updatedAt": "2023-01-01T00:00:00Z", "frontColor": "#2d2d2d", "portGroups": [{"id": "pg-1", "poe": false, "name": "25G光口", "count": 48, "speed": "25G", "portType": "SFP+"}, {"id": "pg-2", "poe": false, "name": "100G光口", "count": 6, "speed": "100G", "portType": "QSFP28"}], "description": "华为CloudEngine 6800系列数据中心交换机"}, {"id": "tpl-cisco-c9300-48p", "name": "Cisco Catalyst 9300-48P", "brand": "思科", "model": "C9300-48P", "specs": {"PoE功率": "437W", "交换容量": "208Gbps", "堆叠带宽": "480Gbps"}, "uHeight": 1, "category": "switch", "createdAt": "2023-01-01T00:00:00Z", "isBuiltin": true, "updatedAt": "2023-01-01T00:00:00Z", "frontColor": "#1e3a5f", "portGroups": [{"id": "pg-1", "poe": true, "name": "千兆PoE+电口", "count": 48, "speed": "1G", "portType": "RJ45"}, {"id": "pg-2", "poe": false, "name": "上行模块槽", "count": 4, "speed": "10G", "portType": "SFP+"}], "description": "Cisco Catalyst 9300系列企业级交换机，支持PoE+"}, {"id": "tpl-cisco-n9k-93180yc", "name": "Cisco Nexus 93180YC-FX", "brand": "思科", "model": "N9K-C93180YC-FX", "specs": {"延迟": "<1μs", "交换容量": "3.6Tbps"}, "uHeight": 1, "category": "switch", "createdAt": "2023-01-01T00:00:00Z", "isBuiltin": true, "updatedAt": "2023-01-01T00:00:00Z", "frontColor": "#1e3a5f", "portGroups": [{"id": "pg-1", "poe": false, "name": "25G光口", "count": 48, "speed": "25G", "portType": "SFP+"}, {"id": "pg-2", "poe": false, "name": "100G光口", "count": 6, "speed": "100G", "portType": "QSFP28"}], "description": "Cisco Nexus 9000系列数据中心交换机"}, {"id": "tpl-h3c-s6850-56hf", "name": "H3C S6850-56HF", "brand": "H3C", "model": "S6850-56HF", "specs": {"交换容量": "1.76Tbps", "包转发率": "1080Mpps"}, "uHeight": 1, "category": "switch", "createdAt": "2023-01-01T00:00:00Z", "isBuiltin": true, "updatedAt": "2023-01-01T00:00:00Z", "frontColor": "#e63946", "portGroups": [{"id": "pg-1", "poe": false, "name": "万兆光口", "count": 48, "speed": "10G", "portType": "SFP+"}, {"id": "pg-2", "poe": false, "name": "40G光口", "count": 8, "speed": "40G", "portType": "QSFP+"}], "description": "H3C S6850系列数据中心交换机"}, {"id": "tpl-ruijie-s6220-48xs6qxs", "name": "锐捷RG-S6220-48XS6QXS", "brand": "锐捷", "model": "RG-S6220-48XS6QXS", "uHeight": 1, "category": "switch", "createdAt": "2023-01-01T00:00:00Z", "isBuiltin": true, "updatedAt": "2023-01-01T00:00:00Z", "frontColor": "#0066cc", "portGroups": [{"id": "pg-1", "poe": false, "name": "万兆光口", "count": 48, "speed": "10G", "portType": "SFP+"}, {"id": "pg-2", "poe": false, "name": "40G光口", "count": 6, "speed": "40G", "portType": "QSFP+"}], "description": "锐捷S6220系列数据中心交换机"}, {"id": "tpl-huawei-2288h-v6", "name": "华为FusionServer 2288H V6", "brand": "华为", "model": "2288H V6", "specs": {"CPU": "2×Intel Xeon Gold 6348", "内存": "最大6TB DDR4", "存储": "25×2.5寸硬盘"}, "uHeight": 2, "category": "server", "createdAt": "2023-01-01T00:00:00Z", "isBuiltin": true, "updatedAt": "2023-01-01T00:00:00Z", "frontColor": "#2d2d2d", "portGroups": [{"id": "pg-1", "poe": false, "name": "管理口", "count": 1, "speed": "1G", "portType": "RJ45"}, {"id": "pg-2", "poe": false, "name": "业务网口", "count": 4, "speed": "1G", "portType": "RJ45"}, {"id": "pg-3", "poe": false, "name": "电源接口", "count": 2, "speed": "N/A", "portType": "Power"}], "description": "华为2U双路服务器，支持第三代Intel Xeon可扩展处理器"}, {"id": "tpl-dell-r750", "name": "Dell PowerEdge R750", "brand": "Dell", "model": "PowerEdge R750", "specs": {"CPU": "2×Intel Xeon Gold", "内存": "最大4TB DDR4", "存储": "24×2.5寸或12×3.5寸"}, "uHeight": 2, "category": "server", "createdAt": "2023-01-01T00:00:00Z", "isBuiltin": true, "updatedAt": "2023-01-01T00:00:00Z", "frontColor": "#1a1a1a", "portGroups": [{"id": "pg-1", "poe": false, "name": "iDRAC管理口", "count": 1, "speed": "1G", "portType": "RJ45"}, {"id": "pg-2", "poe": false, "name": "业务网口", "count": 4, "speed": "1G", "portType": "RJ45"}, {"id": "pg-3", "poe": false, "name": "电源接口", "count": 2, "speed": "N/A", "portType": "Power"}], "description": "Dell 2U双路服务器"}, {"id": "tpl-hpe-dl380-gen10", "name": "HPE ProLiant DL380 Gen10", "brand": "HPE", "model": "DL380 Gen10", "uHeight": 2, "category": "server", "createdAt": "2023-01-01T00:00:00Z", "isBuiltin": true, "updatedAt": "2023-01-01T00:00:00Z", "frontColor": "#4a4a4a", "portGroups": [{"id": "pg-1", "poe": false, "name": "iLO管理口", "count": 1, "speed": "1G", "portType": "RJ45"}, {"id": "pg-2", "poe": false, "name": "业务网口", "count": 4, "speed": "1G", "portType": "RJ45"}, {"id": "pg-3", "poe": false, "name": "电源接口", "count": 2, "speed": "N/A", "portType": "Power"}], "description": "HPE 2U双路服务器"}, {"id": "tpl-inspur-nf5280m6", "name": "浪潮NF5280M6", "brand": "浪潮", "model": "NF5280M6", "uHeight": 2, "category": "server", "createdAt": "2023-01-01T00:00:00Z", "isBuiltin": true, "updatedAt": "2023-01-01T00:00:00Z", "frontColor": "#003366", "portGroups": [{"id": "pg-1", "poe": false, "name": "BMC管理口", "count": 1, "speed": "1G", "portType": "RJ45"}, {"id": "pg-2", "poe": false, "name": "业务网口", "count": 4, "speed": "1G", "portType": "RJ45"}, {"id": "pg-3", "poe": false, "name": "电源接口", "count": 2, "speed": "N/A", "portType": "Power"}], "description": "浪潮2U双路服务器"}, {"id": "tpl-huawei-ne40e-x8", "name": "华为NE40E-X8", "brand": "华为", "model": "NE40E-X8", "uHeight": 14, "category": "router", "createdAt": "2023-01-01T00:00:00Z", "isBuiltin": true, "updatedAt": "2023-01-01T00:00:00Z", "frontColor": "#2d2d2d", "portGroups": [{"id": "pg-1", "poe": false, "name": "业务板卡槽位", "count": 8, "speed": "10G", "portType": "SFP+"}], "description": "华为NE40E系列高端路由器"}, {"id": "tpl-cisco-asr-9000", "name": "Cisco ASR 9006", "brand": "思科", "model": "ASR 9006", "uHeight": 13, "category": "router", "createdAt": "2023-01-01T00:00:00Z", "isBuiltin": true, "updatedAt": "2023-01-01T00:00:00Z", "frontColor": "#1e3a5f", "portGroups": [{"id": "pg-1", "poe": false, "name": "线卡槽位", "count": 6, "speed": "10G", "portType": "SFP+"}], "description": "Cisco ASR 9000系列运营商级路由器"}, {"id": "tpl-huawei-oceanstor-5500", "name": "华为OceanStor 5500 V5", "brand": "华为", "model": "OceanStor 5500 V5", "uHeight": 4, "category": "storage", "createdAt": "2023-01-01T00:00:00Z", "isBuiltin": true, "updatedAt": "2023-01-01T00:00:00Z", "frontColor": "#1a1a1a", "portGroups": [{"id": "pg-1", "poe": false, "name": "管理口", "count": 2, "speed": "1G", "portType": "RJ45"}, {"id": "pg-2", "poe": false, "name": "FC存储口", "count": 8, "speed": "10G", "portType": "FC"}, {"id": "pg-3", "poe": false, "name": "iSCSI口", "count": 4, "speed": "10G", "portType": "RJ45"}], "description": "华为OceanStor企业级全闪存存储"}, {"id": "tpl-huawei-usg6680", "name": "华为USG6680", "brand": "华为", "model": "USG6680", "uHeight": 2, "category": "firewall", "createdAt": "2023-01-01T00:00:00Z", "isBuiltin": true, "updatedAt": "2023-01-01T00:00:00Z", "frontColor": "#8b0000", "portGroups": [{"id": "pg-1", "poe": false, "name": "管理口", "count": 1, "speed": "1G", "portType": "RJ45"}, {"id": "pg-2", "poe": false, "name": "业务电口", "count": 8, "speed": "1G", "portType": "RJ45"}, {"id": "pg-3", "poe": false, "name": "业务光口", "count": 4, "speed": "10G", "portType": "SFP+"}], "description": "华为下一代防火墙"}, {"id": "tpl-f5-big-ip-i5800", "name": "F5 BIG-IP i5800", "brand": "F5", "model": "BIG-IP i5800", "uHeight": 1, "category": "loadbalancer", "createdAt": "2023-01-01T00:00:00Z", "isBuiltin": true, "updatedAt": "2023-01-01T00:00:00Z", "frontColor": "#cc0000", "portGroups": [{"id": "pg-1", "poe": false, "name": "管理口", "count": 1, "speed": "1G", "portType": "RJ45"}, {"id": "pg-2", "poe": false, "name": "业务口", "count": 8, "speed": "10G", "portType": "SFP+"}], "description": "F5 BIG-IP应用交付控制器"}]	2026-06-23 08:38:42.107162+00
raw-devices	devices	[{"id": "dev-001", "endU": 40, "name": "核心交换机-A1", "owner": "张运维", "startU": 40, "status": "online", "vendor": "华为技术服务商", "assetCode": "BJ-NET-SW-001", "cabinetId": "cab-bj-001", "createdAt": "2023-02-20T08:00:00Z", "updatedAt": "2024-12-01T10:00:00Z", "department": "网络运维部", "templateId": "tpl-huawei-s6730-48x6c", "description": "A区核心交换机", "managementIp": "10.0.1.1", "purchaseDate": "2023-02-15", "serialNumber": "HW21035678901", "warrantyExpiry": "2026-02-15"}, {"id": "dev-002", "endU": 38, "name": "接入交换机-A1-1", "owner": "张运维", "startU": 38, "status": "online", "vendor": "华为技术服务商", "assetCode": "BJ-NET-SW-002", "cabinetId": "cab-bj-001", "createdAt": "2023-02-20T08:00:00Z", "updatedAt": "2024-12-01T10:00:00Z", "department": "网络运维部", "templateId": "tpl-huawei-s5735-48t4x", "managementIp": "10.0.1.2", "purchaseDate": "2023-02-15", "serialNumber": "HW21035678902", "warrantyExpiry": "2026-02-15"}, {"id": "dev-003", "endU": 36, "name": "应用服务器-A1-1", "owner": "李开发", "startU": 35, "status": "online", "vendor": "华为技术服务商", "assetCode": "BJ-SRV-001", "cabinetId": "cab-bj-001", "createdAt": "2023-03-15T08:00:00Z", "updatedAt": "2024-11-20T14:00:00Z", "department": "应用开发部", "templateId": "tpl-huawei-2288h-v6", "managementIp": "10.0.10.1", "purchaseDate": "2023-03-10", "serialNumber": "HW2188SRV001", "warrantyExpiry": "2026-03-10"}, {"id": "dev-004", "endU": 34, "name": "应用服务器-A1-2", "owner": "李开发", "startU": 33, "status": "online", "vendor": "华为技术服务商", "assetCode": "BJ-SRV-002", "cabinetId": "cab-bj-001", "createdAt": "2023-03-15T08:00:00Z", "updatedAt": "2024-11-20T14:00:00Z", "department": "应用开发部", "templateId": "tpl-huawei-2288h-v6", "managementIp": "10.0.10.2", "purchaseDate": "2023-03-10", "serialNumber": "HW2188SRV002", "warrantyExpiry": "2026-03-10"}, {"id": "dev-005", "endU": 31, "name": "数据库服务器-A1-1", "owner": "王DBA", "startU": 30, "status": "online", "vendor": "Dell企业服务", "assetCode": "BJ-SRV-003", "cabinetId": "cab-bj-001", "createdAt": "2023-04-05T08:00:00Z", "updatedAt": "2024-10-15T16:00:00Z", "department": "数据库运维部", "templateId": "tpl-dell-r750", "managementIp": "10.0.20.1", "purchaseDate": "2023-04-01", "serialNumber": "DELL750DB001", "warrantyExpiry": "2026-04-01"}, {"id": "dev-006", "endU": 41, "name": "边界防火墙-1", "owner": "赵安全", "startU": 40, "status": "online", "vendor": "华为安全服务商", "assetCode": "BJ-SEC-FW-001", "cabinetId": "cab-bj-002", "createdAt": "2023-01-25T08:00:00Z", "updatedAt": "2024-12-01T10:00:00Z", "department": "安全运维部", "templateId": "tpl-huawei-usg6680", "managementIp": "10.0.254.1", "purchaseDate": "2023-01-20", "serialNumber": "HWUSG6680001", "warrantyExpiry": "2026-01-20"}, {"id": "dev-007", "endU": 38, "name": "负载均衡器-1", "owner": "张运维", "startU": 38, "status": "online", "vendor": "F5中国", "assetCode": "BJ-NET-LB-001", "cabinetId": "cab-bj-002", "createdAt": "2023-02-05T08:00:00Z", "updatedAt": "2024-11-28T11:00:00Z", "department": "网络运维部", "templateId": "tpl-f5-big-ip-i5800", "managementIp": "10.0.253.1", "purchaseDate": "2023-02-01", "serialNumber": "F5BIGIP001", "warrantyExpiry": "2026-02-01"}, {"id": "dev-008", "endU": 38, "name": "核心存储-1", "owner": "周存储", "startU": 35, "status": "online", "vendor": "华为存储服务商", "assetCode": "BJ-STG-001", "cabinetId": "cab-bj-003", "createdAt": "2023-05-10T08:00:00Z", "updatedAt": "2024-09-20T09:00:00Z", "department": "存储运维部", "templateId": "tpl-huawei-oceanstor-5500", "managementIp": "10.0.30.1", "purchaseDate": "2023-05-01", "serialNumber": "HWOCEAN5500001", "warrantyExpiry": "2028-05-01"}, {"id": "dev-009", "endU": 40, "name": "接入交换机-B1-1", "owner": "李运维", "startU": 40, "status": "online", "vendor": "思科中国", "assetCode": "SH-NET-SW-001", "cabinetId": "cab-sh-001", "createdAt": "2023-07-10T08:00:00Z", "updatedAt": "2024-11-15T14:00:00Z", "department": "网络运维部", "templateId": "tpl-cisco-c9300-48p", "managementIp": "10.1.1.1", "purchaseDate": "2023-07-01", "serialNumber": "CISCO9300001", "warrantyExpiry": "2026-07-01"}, {"id": "dev-010", "endU": 38, "name": "核心交换机-B1", "owner": "李运维", "startU": 38, "status": "warning", "vendor": "思科中国", "assetCode": "SH-NET-SW-002", "cabinetId": "cab-sh-001", "createdAt": "2023-07-10T08:00:00Z", "updatedAt": "2024-12-05T09:00:00Z", "department": "网络运维部", "templateId": "tpl-cisco-n9k-93180yc", "description": "端口利用率过高", "managementIp": "10.1.1.2", "purchaseDate": "2023-07-01", "serialNumber": "CISCON9K001", "warrantyExpiry": "2026-07-01"}, {"id": "dev-011", "endU": 45, "name": "汇聚交换机-C1", "owner": "王运维", "startU": 45, "status": "online", "vendor": "H3C华三", "assetCode": "SZ-NET-SW-001", "cabinetId": "cab-sz-001", "createdAt": "2023-04-10T08:00:00Z", "updatedAt": "2024-10-20T16:00:00Z", "department": "网络运维部", "templateId": "tpl-h3c-s6850-56hf", "managementIp": "10.2.1.1", "purchaseDate": "2023-04-01", "serialNumber": "H3CS6850001", "warrantyExpiry": "2026-04-01"}, {"id": "dev-012", "endU": 43, "name": "GPU服务器-C1-1", "owner": "钱AI", "startU": 42, "status": "online", "vendor": "浪潮信息", "assetCode": "SZ-SRV-001", "cabinetId": "cab-sz-001", "createdAt": "2024-01-20T08:00:00Z", "updatedAt": "2024-11-10T10:00:00Z", "department": "AI研发部", "templateId": "tpl-inspur-nf5280m6", "description": "GPU计算节点", "managementIp": "10.2.10.1", "purchaseDate": "2024-01-15", "serialNumber": "INSPURNF001", "warrantyExpiry": "2027-01-15"}]	2026-06-23 08:38:42.107162+00
raw-ports	ports	[{"id": "port-dev-001-sfp-1", "speed": "10G", "status": "up", "deviceId": "dev-001", "portType": "SFP+", "linkStatus": "connected", "portNumber": "XGE1/0/1", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-001-sfp-2", "speed": "10G", "status": "up", "deviceId": "dev-001", "portType": "SFP+", "linkStatus": "connected", "portNumber": "XGE1/0/2", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-001-sfp-3", "speed": "10G", "status": "up", "deviceId": "dev-001", "portType": "SFP+", "linkStatus": "connected", "portNumber": "XGE1/0/3", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-001-sfp-4", "speed": "10G", "status": "up", "deviceId": "dev-001", "portType": "SFP+", "linkStatus": "connected", "portNumber": "XGE1/0/4", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-001-sfp-5", "speed": "10G", "status": "up", "deviceId": "dev-001", "portType": "SFP+", "linkStatus": "connected", "portNumber": "XGE1/0/5", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-001-sfp-6", "speed": "10G", "status": "up", "deviceId": "dev-001", "portType": "SFP+", "linkStatus": "connected", "portNumber": "XGE1/0/6", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-001-sfp-7", "speed": "10G", "status": "up", "deviceId": "dev-001", "portType": "SFP+", "linkStatus": "connected", "portNumber": "XGE1/0/7", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-001-sfp-8", "speed": "10G", "status": "up", "deviceId": "dev-001", "portType": "SFP+", "linkStatus": "connected", "portNumber": "XGE1/0/8", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-001-sfp-9", "speed": "10G", "status": "up", "deviceId": "dev-001", "portType": "SFP+", "linkStatus": "connected", "portNumber": "XGE1/0/9", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-001-sfp-10", "speed": "10G", "status": "up", "deviceId": "dev-001", "portType": "SFP+", "linkStatus": "connected", "portNumber": "XGE1/0/10", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-001-sfp-11", "speed": "10G", "status": "up", "deviceId": "dev-001", "portType": "SFP+", "linkStatus": "connected", "portNumber": "XGE1/0/11", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-001-sfp-12", "speed": "10G", "status": "up", "deviceId": "dev-001", "portType": "SFP+", "linkStatus": "connected", "portNumber": "XGE1/0/12", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-001-sfp-13", "speed": "10G", "status": "up", "deviceId": "dev-001", "portType": "SFP+", "linkStatus": "connected", "portNumber": "XGE1/0/13", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-001-sfp-14", "speed": "10G", "status": "up", "deviceId": "dev-001", "portType": "SFP+", "linkStatus": "connected", "portNumber": "XGE1/0/14", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-001-sfp-15", "speed": "10G", "status": "up", "deviceId": "dev-001", "portType": "SFP+", "linkStatus": "connected", "portNumber": "XGE1/0/15", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-001-sfp-16", "speed": "10G", "status": "up", "deviceId": "dev-001", "portType": "SFP+", "linkStatus": "connected", "portNumber": "XGE1/0/16", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-001-sfp-17", "speed": "10G", "status": "up", "deviceId": "dev-001", "portType": "SFP+", "linkStatus": "connected", "portNumber": "XGE1/0/17", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-001-sfp-18", "speed": "10G", "status": "up", "deviceId": "dev-001", "portType": "SFP+", "linkStatus": "connected", "portNumber": "XGE1/0/18", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-001-sfp-19", "speed": "10G", "status": "up", "deviceId": "dev-001", "portType": "SFP+", "linkStatus": "connected", "portNumber": "XGE1/0/19", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-001-sfp-20", "speed": "10G", "status": "up", "deviceId": "dev-001", "portType": "SFP+", "linkStatus": "connected", "portNumber": "XGE1/0/20", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-001-sfp-21", "speed": "10G", "status": "up", "deviceId": "dev-001", "portType": "SFP+", "linkStatus": "connected", "portNumber": "XGE1/0/21", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-001-sfp-22", "speed": "10G", "status": "up", "deviceId": "dev-001", "portType": "SFP+", "linkStatus": "connected", "portNumber": "XGE1/0/22", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-001-sfp-23", "speed": "10G", "status": "up", "deviceId": "dev-001", "portType": "SFP+", "linkStatus": "connected", "portNumber": "XGE1/0/23", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-001-sfp-24", "speed": "10G", "status": "up", "deviceId": "dev-001", "portType": "SFP+", "linkStatus": "connected", "portNumber": "XGE1/0/24", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-001-sfp-25", "speed": "10G", "status": "up", "deviceId": "dev-001", "portType": "SFP+", "linkStatus": "connected", "portNumber": "XGE1/0/25", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-001-sfp-26", "speed": "10G", "status": "up", "deviceId": "dev-001", "portType": "SFP+", "linkStatus": "connected", "portNumber": "XGE1/0/26", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-001-sfp-27", "speed": "10G", "status": "up", "deviceId": "dev-001", "portType": "SFP+", "linkStatus": "connected", "portNumber": "XGE1/0/27", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-001-sfp-28", "speed": "10G", "status": "up", "deviceId": "dev-001", "portType": "SFP+", "linkStatus": "connected", "portNumber": "XGE1/0/28", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-001-sfp-29", "speed": "10G", "status": "up", "deviceId": "dev-001", "portType": "SFP+", "linkStatus": "connected", "portNumber": "XGE1/0/29", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-001-sfp-30", "speed": "10G", "status": "up", "deviceId": "dev-001", "portType": "SFP+", "linkStatus": "connected", "portNumber": "XGE1/0/30", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-001-sfp-31", "speed": "10G", "status": "up", "deviceId": "dev-001", "portType": "SFP+", "linkStatus": "connected", "portNumber": "XGE1/0/31", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-001-sfp-32", "speed": "10G", "status": "up", "deviceId": "dev-001", "portType": "SFP+", "linkStatus": "connected", "portNumber": "XGE1/0/32", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-001-sfp-33", "speed": "10G", "status": "up", "deviceId": "dev-001", "portType": "SFP+", "linkStatus": "connected", "portNumber": "XGE1/0/33", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-001-sfp-34", "speed": "10G", "status": "up", "deviceId": "dev-001", "portType": "SFP+", "linkStatus": "connected", "portNumber": "XGE1/0/34", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-001-sfp-35", "speed": "10G", "status": "up", "deviceId": "dev-001", "portType": "SFP+", "linkStatus": "connected", "portNumber": "XGE1/0/35", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-001-sfp-36", "speed": "10G", "status": "up", "deviceId": "dev-001", "portType": "SFP+", "linkStatus": "connected", "portNumber": "XGE1/0/36", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-001-sfp-37", "speed": "10G", "status": "up", "deviceId": "dev-001", "portType": "SFP+", "linkStatus": "disconnected", "portNumber": "XGE1/0/37", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-001-sfp-38", "speed": "10G", "status": "up", "deviceId": "dev-001", "portType": "SFP+", "linkStatus": "disconnected", "portNumber": "XGE1/0/38", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-001-sfp-39", "speed": "10G", "status": "up", "deviceId": "dev-001", "portType": "SFP+", "linkStatus": "disconnected", "portNumber": "XGE1/0/39", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-001-sfp-40", "speed": "10G", "status": "up", "deviceId": "dev-001", "portType": "SFP+", "linkStatus": "disconnected", "portNumber": "XGE1/0/40", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-001-sfp-41", "speed": "10G", "status": "up", "deviceId": "dev-001", "portType": "SFP+", "linkStatus": "disconnected", "portNumber": "XGE1/0/41", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-001-sfp-42", "speed": "10G", "status": "up", "deviceId": "dev-001", "portType": "SFP+", "linkStatus": "disconnected", "portNumber": "XGE1/0/42", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-001-sfp-43", "speed": "10G", "status": "up", "deviceId": "dev-001", "portType": "SFP+", "linkStatus": "disconnected", "portNumber": "XGE1/0/43", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-001-sfp-44", "speed": "10G", "status": "up", "deviceId": "dev-001", "portType": "SFP+", "linkStatus": "disconnected", "portNumber": "XGE1/0/44", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-001-sfp-45", "speed": "10G", "status": "up", "deviceId": "dev-001", "portType": "SFP+", "linkStatus": "disconnected", "portNumber": "XGE1/0/45", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-001-sfp-46", "speed": "10G", "status": "up", "deviceId": "dev-001", "portType": "SFP+", "linkStatus": "disconnected", "portNumber": "XGE1/0/46", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-001-sfp-47", "speed": "10G", "status": "up", "deviceId": "dev-001", "portType": "SFP+", "linkStatus": "disconnected", "portNumber": "XGE1/0/47", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-001-sfp-48", "speed": "10G", "status": "up", "deviceId": "dev-001", "portType": "SFP+", "linkStatus": "disconnected", "portNumber": "XGE1/0/48", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-001-qsfp-1", "speed": "100G", "status": "up", "deviceId": "dev-001", "portType": "QSFP28", "linkStatus": "connected", "portNumber": "100GE1/0/1", "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-2"}, {"id": "port-dev-001-qsfp-2", "speed": "100G", "status": "up", "deviceId": "dev-001", "portType": "QSFP28", "linkStatus": "connected", "portNumber": "100GE1/0/2", "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-2"}, {"id": "port-dev-001-qsfp-3", "speed": "100G", "status": "up", "deviceId": "dev-001", "portType": "QSFP28", "linkStatus": "disconnected", "portNumber": "100GE1/0/3", "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-2"}, {"id": "port-dev-001-qsfp-4", "speed": "100G", "status": "up", "deviceId": "dev-001", "portType": "QSFP28", "linkStatus": "disconnected", "portNumber": "100GE1/0/4", "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-2"}, {"id": "port-dev-001-qsfp-5", "speed": "100G", "status": "up", "deviceId": "dev-001", "portType": "QSFP28", "linkStatus": "disconnected", "portNumber": "100GE1/0/5", "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-2"}, {"id": "port-dev-001-qsfp-6", "speed": "100G", "status": "up", "deviceId": "dev-001", "portType": "QSFP28", "linkStatus": "disconnected", "portNumber": "100GE1/0/6", "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-2"}, {"id": "port-dev-002-rj45-1", "speed": "1G", "status": "up", "deviceId": "dev-002", "portType": "RJ45", "portAlias": "Server-1", "qosConfig": {"trustMode": "dscp", "defaultPriority": 0, "ingressRateLimit": 1000}, "linkStatus": "connected", "portNumber": "GE1/0/1", "vlanConfig": {"mode": "access", "pvid": 100}, "description": "连接服务器1", "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-002-rj45-2", "speed": "1G", "status": "up", "deviceId": "dev-002", "portType": "RJ45", "portAlias": "Server-2", "qosConfig": {"trustMode": "dscp", "defaultPriority": 0, "ingressRateLimit": 1000}, "linkStatus": "connected", "portNumber": "GE1/0/2", "vlanConfig": {"mode": "access", "pvid": 100}, "description": "连接服务器2", "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-002-rj45-3", "speed": "1G", "status": "up", "deviceId": "dev-002", "portType": "RJ45", "portAlias": "Server-3", "qosConfig": {"trustMode": "dscp", "defaultPriority": 0, "ingressRateLimit": 1000}, "linkStatus": "connected", "portNumber": "GE1/0/3", "vlanConfig": {"mode": "access", "pvid": 100}, "description": "连接服务器3", "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-002-rj45-4", "speed": "1G", "status": "up", "deviceId": "dev-002", "portType": "RJ45", "portAlias": "Server-4", "qosConfig": {"trustMode": "dscp", "defaultPriority": 0, "ingressRateLimit": 1000}, "linkStatus": "connected", "portNumber": "GE1/0/4", "vlanConfig": {"mode": "access", "pvid": 100}, "description": "连接服务器4", "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-002-rj45-5", "speed": "1G", "status": "disabled", "deviceId": "dev-002", "portType": "RJ45", "portAlias": "Server-5", "qosConfig": {"trustMode": "dscp", "defaultPriority": 0, "ingressRateLimit": 1000}, "linkStatus": "connected", "portNumber": "GE1/0/5", "vlanConfig": {"mode": "access", "pvid": 100}, "description": "连接服务器5", "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-002-rj45-6", "speed": "1G", "status": "up", "deviceId": "dev-002", "portType": "RJ45", "portAlias": "Server-6", "qosConfig": {"trustMode": "dscp", "defaultPriority": 0, "ingressRateLimit": 1000}, "linkStatus": "connected", "portNumber": "GE1/0/6", "vlanConfig": {"mode": "access", "pvid": 101}, "description": "连接服务器6", "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-002-rj45-7", "speed": "1G", "status": "up", "deviceId": "dev-002", "portType": "RJ45", "portAlias": "Server-7", "qosConfig": {"trustMode": "dscp", "defaultPriority": 0, "ingressRateLimit": 1000}, "linkStatus": "connected", "portNumber": "GE1/0/7", "vlanConfig": {"mode": "access", "pvid": 101}, "description": "连接服务器7", "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-002-rj45-8", "speed": "1G", "status": "up", "deviceId": "dev-002", "portType": "RJ45", "portAlias": "Server-8", "qosConfig": {"trustMode": "dscp", "defaultPriority": 0, "ingressRateLimit": 1000}, "linkStatus": "connected", "portNumber": "GE1/0/8", "vlanConfig": {"mode": "access", "pvid": 101}, "description": "连接服务器8", "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-002-rj45-9", "speed": "1G", "status": "up", "deviceId": "dev-002", "portType": "RJ45", "portAlias": "Server-9", "qosConfig": {"trustMode": "dscp", "defaultPriority": 0, "ingressRateLimit": 1000}, "linkStatus": "connected", "portNumber": "GE1/0/9", "vlanConfig": {"mode": "access", "pvid": 101}, "description": "连接服务器9", "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-002-rj45-10", "speed": "1G", "status": "disabled", "deviceId": "dev-002", "portType": "RJ45", "portAlias": "Server-10", "qosConfig": {"trustMode": "dscp", "defaultPriority": 0, "ingressRateLimit": 1000}, "linkStatus": "connected", "portNumber": "GE1/0/10", "vlanConfig": {"mode": "access", "pvid": 101}, "description": "连接服务器10", "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-002-rj45-11", "speed": "1G", "status": "up", "deviceId": "dev-002", "portType": "RJ45", "portAlias": "Server-11", "qosConfig": {"trustMode": "dscp", "defaultPriority": 0, "ingressRateLimit": 1000}, "linkStatus": "connected", "portNumber": "GE1/0/11", "vlanConfig": {"mode": "access", "pvid": 101}, "description": "连接服务器11", "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-002-rj45-12", "speed": "1G", "status": "up", "deviceId": "dev-002", "portType": "RJ45", "portAlias": "Server-12", "qosConfig": {"trustMode": "dscp", "defaultPriority": 0, "ingressRateLimit": 1000}, "linkStatus": "connected", "portNumber": "GE1/0/12", "vlanConfig": {"mode": "access", "pvid": 102}, "description": "连接服务器12", "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-002-rj45-13", "speed": "1G", "status": "up", "deviceId": "dev-002", "portType": "RJ45", "portAlias": "Server-13", "qosConfig": {"trustMode": "dscp", "defaultPriority": 0, "ingressRateLimit": 1000}, "linkStatus": "connected", "portNumber": "GE1/0/13", "vlanConfig": {"mode": "access", "pvid": 102}, "description": "连接服务器13", "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-002-rj45-14", "speed": "1G", "status": "up", "deviceId": "dev-002", "portType": "RJ45", "portAlias": "Server-14", "qosConfig": {"trustMode": "dscp", "defaultPriority": 0, "ingressRateLimit": 1000}, "linkStatus": "connected", "portNumber": "GE1/0/14", "vlanConfig": {"mode": "access", "pvid": 102}, "description": "连接服务器14", "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-002-rj45-15", "speed": "1G", "status": "disabled", "deviceId": "dev-002", "portType": "RJ45", "portAlias": "Server-15", "qosConfig": {"trustMode": "dscp", "defaultPriority": 0, "ingressRateLimit": 1000}, "linkStatus": "connected", "portNumber": "GE1/0/15", "vlanConfig": {"mode": "access", "pvid": 102}, "description": "连接服务器15", "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-002-rj45-16", "speed": "1G", "status": "up", "deviceId": "dev-002", "portType": "RJ45", "portAlias": "Server-16", "qosConfig": {"trustMode": "dscp", "defaultPriority": 0, "ingressRateLimit": 1000}, "linkStatus": "connected", "portNumber": "GE1/0/16", "vlanConfig": {"mode": "access", "pvid": 102}, "description": "连接服务器16", "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-002-rj45-17", "speed": "1G", "status": "up", "deviceId": "dev-002", "portType": "RJ45", "portAlias": "Server-17", "qosConfig": {"trustMode": "dscp", "defaultPriority": 0, "ingressRateLimit": 1000}, "linkStatus": "connected", "portNumber": "GE1/0/17", "vlanConfig": {"mode": "access", "pvid": 102}, "description": "连接服务器17", "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-002-rj45-18", "speed": "1G", "status": "up", "deviceId": "dev-002", "portType": "RJ45", "portAlias": "Server-18", "qosConfig": {"trustMode": "dscp", "defaultPriority": 0, "ingressRateLimit": 1000}, "linkStatus": "connected", "portNumber": "GE1/0/18", "vlanConfig": {"mode": "access", "pvid": 103}, "description": "连接服务器18", "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-002-rj45-19", "speed": "1G", "status": "up", "deviceId": "dev-002", "portType": "RJ45", "portAlias": "Server-19", "qosConfig": {"trustMode": "dscp", "defaultPriority": 0, "ingressRateLimit": 1000}, "linkStatus": "connected", "portNumber": "GE1/0/19", "vlanConfig": {"mode": "access", "pvid": 103}, "description": "连接服务器19", "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-002-rj45-20", "speed": "1G", "status": "disabled", "deviceId": "dev-002", "portType": "RJ45", "portAlias": "Server-20", "qosConfig": {"trustMode": "dscp", "defaultPriority": 0, "ingressRateLimit": 1000}, "linkStatus": "connected", "portNumber": "GE1/0/20", "vlanConfig": {"mode": "access", "pvid": 103}, "description": "连接服务器20", "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-002-rj45-21", "speed": "1G", "status": "up", "deviceId": "dev-002", "portType": "RJ45", "portAlias": "Server-21", "qosConfig": {"trustMode": "dscp", "defaultPriority": 0, "ingressRateLimit": 1000}, "linkStatus": "connected", "portNumber": "GE1/0/21", "vlanConfig": {"mode": "access", "pvid": 103}, "description": "连接服务器21", "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-002-rj45-22", "speed": "1G", "status": "up", "deviceId": "dev-002", "portType": "RJ45", "portAlias": "Server-22", "qosConfig": {"trustMode": "dscp", "defaultPriority": 0, "ingressRateLimit": 1000}, "linkStatus": "connected", "portNumber": "GE1/0/22", "vlanConfig": {"mode": "access", "pvid": 103}, "description": "连接服务器22", "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-002-rj45-23", "speed": "1G", "status": "up", "deviceId": "dev-002", "portType": "RJ45", "portAlias": "Server-23", "qosConfig": {"trustMode": "dscp", "defaultPriority": 0, "ingressRateLimit": 1000}, "linkStatus": "connected", "portNumber": "GE1/0/23", "vlanConfig": {"mode": "access", "pvid": 103}, "description": "连接服务器23", "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-002-rj45-24", "speed": "1G", "status": "up", "deviceId": "dev-002", "portType": "RJ45", "portAlias": "Server-24", "qosConfig": {"trustMode": "dscp", "defaultPriority": 0, "ingressRateLimit": 1000}, "linkStatus": "connected", "portNumber": "GE1/0/24", "vlanConfig": {"mode": "access", "pvid": 104}, "description": "连接服务器24", "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-002-rj45-25", "speed": "1G", "status": "disabled", "deviceId": "dev-002", "portType": "RJ45", "qosConfig": {"trustMode": "dscp", "defaultPriority": 0}, "linkStatus": "connected", "portNumber": "GE1/0/25", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-002-rj45-26", "speed": "1G", "status": "up", "deviceId": "dev-002", "portType": "RJ45", "qosConfig": {"trustMode": "dscp", "defaultPriority": 0}, "linkStatus": "connected", "portNumber": "GE1/0/26", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-002-rj45-27", "speed": "1G", "status": "up", "deviceId": "dev-002", "portType": "RJ45", "qosConfig": {"trustMode": "dscp", "defaultPriority": 0}, "linkStatus": "connected", "portNumber": "GE1/0/27", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-002-rj45-28", "speed": "1G", "status": "up", "deviceId": "dev-002", "portType": "RJ45", "qosConfig": {"trustMode": "dscp", "defaultPriority": 0}, "linkStatus": "connected", "portNumber": "GE1/0/28", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-002-rj45-29", "speed": "1G", "status": "up", "deviceId": "dev-002", "portType": "RJ45", "qosConfig": {"trustMode": "dscp", "defaultPriority": 0}, "linkStatus": "connected", "portNumber": "GE1/0/29", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-002-rj45-30", "speed": "1G", "status": "disabled", "deviceId": "dev-002", "portType": "RJ45", "qosConfig": {"trustMode": "dscp", "defaultPriority": 0}, "linkStatus": "connected", "portNumber": "GE1/0/30", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-002-rj45-31", "speed": "1G", "status": "up", "deviceId": "dev-002", "portType": "RJ45", "qosConfig": {"trustMode": "dscp", "defaultPriority": 0}, "linkStatus": "disconnected", "portNumber": "GE1/0/31", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-002-rj45-32", "speed": "1G", "status": "up", "deviceId": "dev-002", "portType": "RJ45", "qosConfig": {"trustMode": "dscp", "defaultPriority": 0}, "linkStatus": "disconnected", "portNumber": "GE1/0/32", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-002-rj45-33", "speed": "1G", "status": "up", "deviceId": "dev-002", "portType": "RJ45", "qosConfig": {"trustMode": "dscp", "defaultPriority": 0}, "linkStatus": "disconnected", "portNumber": "GE1/0/33", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-002-rj45-34", "speed": "1G", "status": "up", "deviceId": "dev-002", "portType": "RJ45", "qosConfig": {"trustMode": "dscp", "defaultPriority": 0}, "linkStatus": "disconnected", "portNumber": "GE1/0/34", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-002-rj45-35", "speed": "1G", "status": "disabled", "deviceId": "dev-002", "portType": "RJ45", "qosConfig": {"trustMode": "dscp", "defaultPriority": 0}, "linkStatus": "disconnected", "portNumber": "GE1/0/35", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-002-rj45-36", "speed": "1G", "status": "up", "deviceId": "dev-002", "portType": "RJ45", "qosConfig": {"trustMode": "dscp", "defaultPriority": 0}, "linkStatus": "disconnected", "portNumber": "GE1/0/36", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-002-rj45-37", "speed": "1G", "status": "up", "deviceId": "dev-002", "portType": "RJ45", "qosConfig": {"trustMode": "dscp", "defaultPriority": 0}, "linkStatus": "disconnected", "portNumber": "GE1/0/37", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-002-rj45-38", "speed": "1G", "status": "up", "deviceId": "dev-002", "portType": "RJ45", "qosConfig": {"trustMode": "dscp", "defaultPriority": 0}, "linkStatus": "disconnected", "portNumber": "GE1/0/38", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-002-rj45-39", "speed": "1G", "status": "up", "deviceId": "dev-002", "portType": "RJ45", "qosConfig": {"trustMode": "dscp", "defaultPriority": 0}, "linkStatus": "disconnected", "portNumber": "GE1/0/39", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-002-rj45-40", "speed": "1G", "status": "disabled", "deviceId": "dev-002", "portType": "RJ45", "qosConfig": {"trustMode": "dscp", "defaultPriority": 0}, "linkStatus": "disconnected", "portNumber": "GE1/0/40", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-002-rj45-41", "speed": "1G", "status": "up", "deviceId": "dev-002", "portType": "RJ45", "qosConfig": {"trustMode": "dscp", "defaultPriority": 0}, "linkStatus": "disconnected", "portNumber": "GE1/0/41", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-002-rj45-42", "speed": "1G", "status": "up", "deviceId": "dev-002", "portType": "RJ45", "qosConfig": {"trustMode": "dscp", "defaultPriority": 0}, "linkStatus": "disconnected", "portNumber": "GE1/0/42", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-002-rj45-43", "speed": "1G", "status": "up", "deviceId": "dev-002", "portType": "RJ45", "qosConfig": {"trustMode": "dscp", "defaultPriority": 0}, "linkStatus": "disconnected", "portNumber": "GE1/0/43", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-002-rj45-44", "speed": "1G", "status": "up", "deviceId": "dev-002", "portType": "RJ45", "qosConfig": {"trustMode": "dscp", "defaultPriority": 0}, "linkStatus": "disconnected", "portNumber": "GE1/0/44", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-002-rj45-45", "speed": "1G", "status": "disabled", "deviceId": "dev-002", "portType": "RJ45", "qosConfig": {"trustMode": "dscp", "defaultPriority": 0}, "linkStatus": "disconnected", "portNumber": "GE1/0/45", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-002-rj45-46", "speed": "1G", "status": "up", "deviceId": "dev-002", "portType": "RJ45", "qosConfig": {"trustMode": "dscp", "defaultPriority": 0}, "linkStatus": "disconnected", "portNumber": "GE1/0/46", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-002-rj45-47", "speed": "1G", "status": "up", "deviceId": "dev-002", "portType": "RJ45", "qosConfig": {"trustMode": "dscp", "defaultPriority": 0}, "linkStatus": "disconnected", "portNumber": "GE1/0/47", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-002-rj45-48", "speed": "1G", "status": "up", "deviceId": "dev-002", "portType": "RJ45", "qosConfig": {"trustMode": "dscp", "defaultPriority": 0}, "linkStatus": "disconnected", "portNumber": "GE1/0/48", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-002-sfp-1", "speed": "10G", "status": "up", "deviceId": "dev-002", "portType": "SFP+", "portAlias": "Uplink-1", "linkStatus": "connected", "portNumber": "XGE1/0/1", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "description": "上联核心交换机-1", "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-2"}, {"id": "port-dev-002-sfp-2", "speed": "10G", "status": "up", "deviceId": "dev-002", "portType": "SFP+", "portAlias": "Uplink-2", "linkStatus": "connected", "portNumber": "XGE1/0/2", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "description": "上联核心交换机-2", "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-2"}, {"id": "port-dev-002-sfp-3", "speed": "10G", "status": "up", "deviceId": "dev-002", "portType": "SFP+", "linkStatus": "disconnected", "portNumber": "XGE1/0/3", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-2"}, {"id": "port-dev-002-sfp-4", "speed": "10G", "status": "up", "deviceId": "dev-002", "portType": "SFP+", "linkStatus": "disconnected", "portNumber": "XGE1/0/4", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-2"}, {"id": "port-dev-003-mgmt", "speed": "1G", "status": "up", "deviceId": "dev-003", "portType": "RJ45", "portAlias": "IPMI管理口", "linkStatus": "connected", "portNumber": "Mgmt", "description": "IPMI/iLO/iDRAC管理口", "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-003-eth-1", "speed": "1G", "status": "up", "deviceId": "dev-003", "portType": "RJ45", "linkStatus": "connected", "portNumber": "eth1", "vlanConfig": {"mode": "access", "pvid": 100}, "description": "业务网络", "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-2"}, {"id": "port-dev-003-eth-2", "speed": "1G", "status": "up", "deviceId": "dev-003", "portType": "RJ45", "linkStatus": "connected", "portNumber": "eth2", "vlanConfig": {"mode": "access", "pvid": 200}, "description": "管理网络", "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-2"}, {"id": "port-dev-003-eth-3", "speed": "1G", "status": "up", "deviceId": "dev-003", "portType": "RJ45", "linkStatus": "disconnected", "portNumber": "eth3", "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-2"}, {"id": "port-dev-003-eth-4", "speed": "1G", "status": "up", "deviceId": "dev-003", "portType": "RJ45", "linkStatus": "disconnected", "portNumber": "eth4", "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-2"}, {"id": "port-dev-003-pwr-1", "speed": "N/A", "status": "up", "deviceId": "dev-003", "portType": "Power", "linkStatus": "connected", "portNumber": "PWR1", "description": "电源模块1", "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-3"}, {"id": "port-dev-003-pwr-2", "speed": "N/A", "status": "up", "deviceId": "dev-003", "portType": "Power", "linkStatus": "connected", "portNumber": "PWR2", "description": "电源模块2", "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-3"}, {"id": "port-dev-004-mgmt", "speed": "1G", "status": "up", "deviceId": "dev-004", "portType": "RJ45", "portAlias": "IPMI管理口", "linkStatus": "connected", "portNumber": "Mgmt", "description": "IPMI/iLO/iDRAC管理口", "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-004-eth-1", "speed": "1G", "status": "up", "deviceId": "dev-004", "portType": "RJ45", "linkStatus": "connected", "portNumber": "eth1", "vlanConfig": {"mode": "access", "pvid": 100}, "description": "业务网络", "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-2"}, {"id": "port-dev-004-eth-2", "speed": "1G", "status": "up", "deviceId": "dev-004", "portType": "RJ45", "linkStatus": "connected", "portNumber": "eth2", "vlanConfig": {"mode": "access", "pvid": 200}, "description": "管理网络", "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-2"}, {"id": "port-dev-004-eth-3", "speed": "1G", "status": "up", "deviceId": "dev-004", "portType": "RJ45", "linkStatus": "disconnected", "portNumber": "eth3", "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-2"}, {"id": "port-dev-004-eth-4", "speed": "1G", "status": "up", "deviceId": "dev-004", "portType": "RJ45", "linkStatus": "disconnected", "portNumber": "eth4", "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-2"}, {"id": "port-dev-004-pwr-1", "speed": "N/A", "status": "up", "deviceId": "dev-004", "portType": "Power", "linkStatus": "connected", "portNumber": "PWR1", "description": "电源模块1", "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-3"}, {"id": "port-dev-004-pwr-2", "speed": "N/A", "status": "up", "deviceId": "dev-004", "portType": "Power", "linkStatus": "connected", "portNumber": "PWR2", "description": "电源模块2", "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-3"}, {"id": "port-dev-005-mgmt", "speed": "1G", "status": "up", "deviceId": "dev-005", "portType": "RJ45", "portAlias": "IPMI管理口", "linkStatus": "connected", "portNumber": "Mgmt", "description": "IPMI/iLO/iDRAC管理口", "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-005-eth-1", "speed": "1G", "status": "up", "deviceId": "dev-005", "portType": "RJ45", "linkStatus": "connected", "portNumber": "eth1", "vlanConfig": {"mode": "access", "pvid": 100}, "description": "业务网络", "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-2"}, {"id": "port-dev-005-eth-2", "speed": "1G", "status": "up", "deviceId": "dev-005", "portType": "RJ45", "linkStatus": "connected", "portNumber": "eth2", "vlanConfig": {"mode": "access", "pvid": 200}, "description": "管理网络", "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-2"}, {"id": "port-dev-005-eth-3", "speed": "1G", "status": "up", "deviceId": "dev-005", "portType": "RJ45", "linkStatus": "disconnected", "portNumber": "eth3", "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-2"}, {"id": "port-dev-005-eth-4", "speed": "1G", "status": "up", "deviceId": "dev-005", "portType": "RJ45", "linkStatus": "disconnected", "portNumber": "eth4", "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-2"}, {"id": "port-dev-005-pwr-1", "speed": "N/A", "status": "up", "deviceId": "dev-005", "portType": "Power", "linkStatus": "connected", "portNumber": "PWR1", "description": "电源模块1", "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-3"}, {"id": "port-dev-005-pwr-2", "speed": "N/A", "status": "up", "deviceId": "dev-005", "portType": "Power", "linkStatus": "connected", "portNumber": "PWR2", "description": "电源模块2", "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-3"}, {"id": "port-dev-006-mgmt", "speed": "1G", "status": "up", "deviceId": "dev-006", "portType": "RJ45", "linkStatus": "connected", "portNumber": "Mgmt", "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-006-rj45-1", "speed": "1G", "status": "up", "deviceId": "dev-006", "portType": "RJ45", "linkStatus": "connected", "portNumber": "GE0/0/1", "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-2"}, {"id": "port-dev-006-rj45-2", "speed": "1G", "status": "up", "deviceId": "dev-006", "portType": "RJ45", "linkStatus": "connected", "portNumber": "GE0/0/2", "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-2"}, {"id": "port-dev-006-rj45-3", "speed": "1G", "status": "up", "deviceId": "dev-006", "portType": "RJ45", "linkStatus": "connected", "portNumber": "GE0/0/3", "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-2"}, {"id": "port-dev-006-rj45-4", "speed": "1G", "status": "up", "deviceId": "dev-006", "portType": "RJ45", "linkStatus": "connected", "portNumber": "GE0/0/4", "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-2"}, {"id": "port-dev-006-rj45-5", "speed": "1G", "status": "up", "deviceId": "dev-006", "portType": "RJ45", "linkStatus": "disconnected", "portNumber": "GE0/0/5", "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-2"}, {"id": "port-dev-006-rj45-6", "speed": "1G", "status": "up", "deviceId": "dev-006", "portType": "RJ45", "linkStatus": "disconnected", "portNumber": "GE0/0/6", "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-2"}, {"id": "port-dev-006-rj45-7", "speed": "1G", "status": "up", "deviceId": "dev-006", "portType": "RJ45", "linkStatus": "disconnected", "portNumber": "GE0/0/7", "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-2"}, {"id": "port-dev-006-rj45-8", "speed": "1G", "status": "up", "deviceId": "dev-006", "portType": "RJ45", "linkStatus": "disconnected", "portNumber": "GE0/0/8", "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-2"}, {"id": "port-dev-006-sfp-1", "speed": "10G", "status": "up", "deviceId": "dev-006", "portType": "SFP+", "linkStatus": "connected", "portNumber": "XGE0/0/1", "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-3"}, {"id": "port-dev-006-sfp-2", "speed": "10G", "status": "up", "deviceId": "dev-006", "portType": "SFP+", "linkStatus": "connected", "portNumber": "XGE0/0/2", "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-3"}, {"id": "port-dev-006-sfp-3", "speed": "10G", "status": "up", "deviceId": "dev-006", "portType": "SFP+", "linkStatus": "disconnected", "portNumber": "XGE0/0/3", "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-3"}, {"id": "port-dev-006-sfp-4", "speed": "10G", "status": "up", "deviceId": "dev-006", "portType": "SFP+", "linkStatus": "disconnected", "portNumber": "XGE0/0/4", "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-3"}, {"id": "port-dev-007-mgmt", "speed": "1G", "status": "up", "deviceId": "dev-007", "portType": "RJ45", "linkStatus": "connected", "portNumber": "Mgmt", "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-007-sfp-1", "speed": "10G", "status": "up", "deviceId": "dev-007", "portType": "SFP+", "linkStatus": "connected", "portNumber": "XGE1/1", "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-2"}, {"id": "port-dev-007-sfp-2", "speed": "10G", "status": "up", "deviceId": "dev-007", "portType": "SFP+", "linkStatus": "connected", "portNumber": "XGE1/2", "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-2"}, {"id": "port-dev-007-sfp-3", "speed": "10G", "status": "up", "deviceId": "dev-007", "portType": "SFP+", "linkStatus": "disconnected", "portNumber": "XGE1/3", "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-2"}, {"id": "port-dev-007-sfp-4", "speed": "10G", "status": "up", "deviceId": "dev-007", "portType": "SFP+", "linkStatus": "disconnected", "portNumber": "XGE1/4", "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-2"}, {"id": "port-dev-007-sfp-5", "speed": "10G", "status": "up", "deviceId": "dev-007", "portType": "SFP+", "linkStatus": "disconnected", "portNumber": "XGE1/5", "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-2"}, {"id": "port-dev-007-sfp-6", "speed": "10G", "status": "up", "deviceId": "dev-007", "portType": "SFP+", "linkStatus": "disconnected", "portNumber": "XGE1/6", "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-2"}, {"id": "port-dev-007-sfp-7", "speed": "10G", "status": "up", "deviceId": "dev-007", "portType": "SFP+", "linkStatus": "disconnected", "portNumber": "XGE1/7", "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-2"}, {"id": "port-dev-007-sfp-8", "speed": "10G", "status": "up", "deviceId": "dev-007", "portType": "SFP+", "linkStatus": "disconnected", "portNumber": "XGE1/8", "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-2"}, {"id": "port-dev-008-mgmt-1", "speed": "1G", "status": "up", "deviceId": "dev-008", "portType": "RJ45", "linkStatus": "connected", "portNumber": "Mgmt1", "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-008-mgmt-2", "speed": "1G", "status": "up", "deviceId": "dev-008", "portType": "RJ45", "linkStatus": "disconnected", "portNumber": "Mgmt2", "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-008-fc-1", "speed": "10G", "status": "up", "deviceId": "dev-008", "portType": "FC", "linkStatus": "connected", "portNumber": "FC1", "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-2"}, {"id": "port-dev-008-fc-2", "speed": "10G", "status": "up", "deviceId": "dev-008", "portType": "FC", "linkStatus": "connected", "portNumber": "FC2", "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-2"}, {"id": "port-dev-008-fc-3", "speed": "10G", "status": "up", "deviceId": "dev-008", "portType": "FC", "linkStatus": "disconnected", "portNumber": "FC3", "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-2"}, {"id": "port-dev-008-fc-4", "speed": "10G", "status": "up", "deviceId": "dev-008", "portType": "FC", "linkStatus": "disconnected", "portNumber": "FC4", "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-2"}, {"id": "port-dev-008-fc-5", "speed": "10G", "status": "up", "deviceId": "dev-008", "portType": "FC", "linkStatus": "disconnected", "portNumber": "FC5", "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-2"}, {"id": "port-dev-008-fc-6", "speed": "10G", "status": "up", "deviceId": "dev-008", "portType": "FC", "linkStatus": "disconnected", "portNumber": "FC6", "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-2"}, {"id": "port-dev-008-fc-7", "speed": "10G", "status": "up", "deviceId": "dev-008", "portType": "FC", "linkStatus": "disconnected", "portNumber": "FC7", "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-2"}, {"id": "port-dev-008-fc-8", "speed": "10G", "status": "up", "deviceId": "dev-008", "portType": "FC", "linkStatus": "disconnected", "portNumber": "FC8", "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-2"}, {"id": "port-dev-008-iscsi-1", "speed": "10G", "status": "up", "deviceId": "dev-008", "portType": "RJ45", "linkStatus": "connected", "portNumber": "iSCSI1", "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-3"}, {"id": "port-dev-008-iscsi-2", "speed": "10G", "status": "up", "deviceId": "dev-008", "portType": "RJ45", "linkStatus": "connected", "portNumber": "iSCSI2", "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-3"}, {"id": "port-dev-008-iscsi-3", "speed": "10G", "status": "up", "deviceId": "dev-008", "portType": "RJ45", "linkStatus": "disconnected", "portNumber": "iSCSI3", "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-3"}, {"id": "port-dev-008-iscsi-4", "speed": "10G", "status": "up", "deviceId": "dev-008", "portType": "RJ45", "linkStatus": "disconnected", "portNumber": "iSCSI4", "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-3"}, {"id": "port-dev-009-rj45-1", "speed": "1G", "status": "up", "deviceId": "dev-009", "portType": "RJ45", "portAlias": "Server-1", "qosConfig": {"trustMode": "dscp", "defaultPriority": 0, "ingressRateLimit": 1000}, "linkStatus": "connected", "portNumber": "GE1/0/1", "vlanConfig": {"mode": "access", "pvid": 100}, "description": "连接服务器1", "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-009-rj45-2", "speed": "1G", "status": "up", "deviceId": "dev-009", "portType": "RJ45", "portAlias": "Server-2", "qosConfig": {"trustMode": "dscp", "defaultPriority": 0, "ingressRateLimit": 1000}, "linkStatus": "connected", "portNumber": "GE1/0/2", "vlanConfig": {"mode": "access", "pvid": 100}, "description": "连接服务器2", "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-009-rj45-3", "speed": "1G", "status": "up", "deviceId": "dev-009", "portType": "RJ45", "portAlias": "Server-3", "qosConfig": {"trustMode": "dscp", "defaultPriority": 0, "ingressRateLimit": 1000}, "linkStatus": "connected", "portNumber": "GE1/0/3", "vlanConfig": {"mode": "access", "pvid": 100}, "description": "连接服务器3", "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-009-rj45-4", "speed": "1G", "status": "up", "deviceId": "dev-009", "portType": "RJ45", "portAlias": "Server-4", "qosConfig": {"trustMode": "dscp", "defaultPriority": 0, "ingressRateLimit": 1000}, "linkStatus": "connected", "portNumber": "GE1/0/4", "vlanConfig": {"mode": "access", "pvid": 100}, "description": "连接服务器4", "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-009-rj45-5", "speed": "1G", "status": "disabled", "deviceId": "dev-009", "portType": "RJ45", "portAlias": "Server-5", "qosConfig": {"trustMode": "dscp", "defaultPriority": 0, "ingressRateLimit": 1000}, "linkStatus": "connected", "portNumber": "GE1/0/5", "vlanConfig": {"mode": "access", "pvid": 100}, "description": "连接服务器5", "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-009-rj45-6", "speed": "1G", "status": "up", "deviceId": "dev-009", "portType": "RJ45", "portAlias": "Server-6", "qosConfig": {"trustMode": "dscp", "defaultPriority": 0, "ingressRateLimit": 1000}, "linkStatus": "connected", "portNumber": "GE1/0/6", "vlanConfig": {"mode": "access", "pvid": 101}, "description": "连接服务器6", "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-009-rj45-7", "speed": "1G", "status": "up", "deviceId": "dev-009", "portType": "RJ45", "portAlias": "Server-7", "qosConfig": {"trustMode": "dscp", "defaultPriority": 0, "ingressRateLimit": 1000}, "linkStatus": "connected", "portNumber": "GE1/0/7", "vlanConfig": {"mode": "access", "pvid": 101}, "description": "连接服务器7", "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-009-rj45-8", "speed": "1G", "status": "up", "deviceId": "dev-009", "portType": "RJ45", "portAlias": "Server-8", "qosConfig": {"trustMode": "dscp", "defaultPriority": 0, "ingressRateLimit": 1000}, "linkStatus": "connected", "portNumber": "GE1/0/8", "vlanConfig": {"mode": "access", "pvid": 101}, "description": "连接服务器8", "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-009-rj45-9", "speed": "1G", "status": "up", "deviceId": "dev-009", "portType": "RJ45", "portAlias": "Server-9", "qosConfig": {"trustMode": "dscp", "defaultPriority": 0, "ingressRateLimit": 1000}, "linkStatus": "connected", "portNumber": "GE1/0/9", "vlanConfig": {"mode": "access", "pvid": 101}, "description": "连接服务器9", "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-009-rj45-10", "speed": "1G", "status": "disabled", "deviceId": "dev-009", "portType": "RJ45", "portAlias": "Server-10", "qosConfig": {"trustMode": "dscp", "defaultPriority": 0, "ingressRateLimit": 1000}, "linkStatus": "connected", "portNumber": "GE1/0/10", "vlanConfig": {"mode": "access", "pvid": 101}, "description": "连接服务器10", "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-009-rj45-11", "speed": "1G", "status": "up", "deviceId": "dev-009", "portType": "RJ45", "portAlias": "Server-11", "qosConfig": {"trustMode": "dscp", "defaultPriority": 0, "ingressRateLimit": 1000}, "linkStatus": "connected", "portNumber": "GE1/0/11", "vlanConfig": {"mode": "access", "pvid": 101}, "description": "连接服务器11", "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-009-rj45-12", "speed": "1G", "status": "up", "deviceId": "dev-009", "portType": "RJ45", "portAlias": "Server-12", "qosConfig": {"trustMode": "dscp", "defaultPriority": 0, "ingressRateLimit": 1000}, "linkStatus": "connected", "portNumber": "GE1/0/12", "vlanConfig": {"mode": "access", "pvid": 102}, "description": "连接服务器12", "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-009-rj45-13", "speed": "1G", "status": "up", "deviceId": "dev-009", "portType": "RJ45", "portAlias": "Server-13", "qosConfig": {"trustMode": "dscp", "defaultPriority": 0, "ingressRateLimit": 1000}, "linkStatus": "connected", "portNumber": "GE1/0/13", "vlanConfig": {"mode": "access", "pvid": 102}, "description": "连接服务器13", "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-009-rj45-14", "speed": "1G", "status": "up", "deviceId": "dev-009", "portType": "RJ45", "portAlias": "Server-14", "qosConfig": {"trustMode": "dscp", "defaultPriority": 0, "ingressRateLimit": 1000}, "linkStatus": "connected", "portNumber": "GE1/0/14", "vlanConfig": {"mode": "access", "pvid": 102}, "description": "连接服务器14", "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-009-rj45-15", "speed": "1G", "status": "disabled", "deviceId": "dev-009", "portType": "RJ45", "portAlias": "Server-15", "qosConfig": {"trustMode": "dscp", "defaultPriority": 0, "ingressRateLimit": 1000}, "linkStatus": "connected", "portNumber": "GE1/0/15", "vlanConfig": {"mode": "access", "pvid": 102}, "description": "连接服务器15", "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-009-rj45-16", "speed": "1G", "status": "up", "deviceId": "dev-009", "portType": "RJ45", "portAlias": "Server-16", "qosConfig": {"trustMode": "dscp", "defaultPriority": 0, "ingressRateLimit": 1000}, "linkStatus": "connected", "portNumber": "GE1/0/16", "vlanConfig": {"mode": "access", "pvid": 102}, "description": "连接服务器16", "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-009-rj45-17", "speed": "1G", "status": "up", "deviceId": "dev-009", "portType": "RJ45", "portAlias": "Server-17", "qosConfig": {"trustMode": "dscp", "defaultPriority": 0, "ingressRateLimit": 1000}, "linkStatus": "connected", "portNumber": "GE1/0/17", "vlanConfig": {"mode": "access", "pvid": 102}, "description": "连接服务器17", "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-009-rj45-18", "speed": "1G", "status": "up", "deviceId": "dev-009", "portType": "RJ45", "portAlias": "Server-18", "qosConfig": {"trustMode": "dscp", "defaultPriority": 0, "ingressRateLimit": 1000}, "linkStatus": "connected", "portNumber": "GE1/0/18", "vlanConfig": {"mode": "access", "pvid": 103}, "description": "连接服务器18", "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-009-rj45-19", "speed": "1G", "status": "up", "deviceId": "dev-009", "portType": "RJ45", "portAlias": "Server-19", "qosConfig": {"trustMode": "dscp", "defaultPriority": 0, "ingressRateLimit": 1000}, "linkStatus": "connected", "portNumber": "GE1/0/19", "vlanConfig": {"mode": "access", "pvid": 103}, "description": "连接服务器19", "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-009-rj45-20", "speed": "1G", "status": "disabled", "deviceId": "dev-009", "portType": "RJ45", "portAlias": "Server-20", "qosConfig": {"trustMode": "dscp", "defaultPriority": 0, "ingressRateLimit": 1000}, "linkStatus": "connected", "portNumber": "GE1/0/20", "vlanConfig": {"mode": "access", "pvid": 103}, "description": "连接服务器20", "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-009-rj45-21", "speed": "1G", "status": "up", "deviceId": "dev-009", "portType": "RJ45", "portAlias": "Server-21", "qosConfig": {"trustMode": "dscp", "defaultPriority": 0, "ingressRateLimit": 1000}, "linkStatus": "connected", "portNumber": "GE1/0/21", "vlanConfig": {"mode": "access", "pvid": 103}, "description": "连接服务器21", "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-009-rj45-22", "speed": "1G", "status": "up", "deviceId": "dev-009", "portType": "RJ45", "portAlias": "Server-22", "qosConfig": {"trustMode": "dscp", "defaultPriority": 0, "ingressRateLimit": 1000}, "linkStatus": "connected", "portNumber": "GE1/0/22", "vlanConfig": {"mode": "access", "pvid": 103}, "description": "连接服务器22", "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-009-rj45-23", "speed": "1G", "status": "up", "deviceId": "dev-009", "portType": "RJ45", "portAlias": "Server-23", "qosConfig": {"trustMode": "dscp", "defaultPriority": 0, "ingressRateLimit": 1000}, "linkStatus": "connected", "portNumber": "GE1/0/23", "vlanConfig": {"mode": "access", "pvid": 103}, "description": "连接服务器23", "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-009-rj45-24", "speed": "1G", "status": "up", "deviceId": "dev-009", "portType": "RJ45", "portAlias": "Server-24", "qosConfig": {"trustMode": "dscp", "defaultPriority": 0, "ingressRateLimit": 1000}, "linkStatus": "connected", "portNumber": "GE1/0/24", "vlanConfig": {"mode": "access", "pvid": 104}, "description": "连接服务器24", "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-009-rj45-25", "speed": "1G", "status": "disabled", "deviceId": "dev-009", "portType": "RJ45", "qosConfig": {"trustMode": "dscp", "defaultPriority": 0}, "linkStatus": "connected", "portNumber": "GE1/0/25", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-009-rj45-26", "speed": "1G", "status": "up", "deviceId": "dev-009", "portType": "RJ45", "qosConfig": {"trustMode": "dscp", "defaultPriority": 0}, "linkStatus": "connected", "portNumber": "GE1/0/26", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-009-rj45-27", "speed": "1G", "status": "up", "deviceId": "dev-009", "portType": "RJ45", "qosConfig": {"trustMode": "dscp", "defaultPriority": 0}, "linkStatus": "connected", "portNumber": "GE1/0/27", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-009-rj45-28", "speed": "1G", "status": "up", "deviceId": "dev-009", "portType": "RJ45", "qosConfig": {"trustMode": "dscp", "defaultPriority": 0}, "linkStatus": "connected", "portNumber": "GE1/0/28", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-009-rj45-29", "speed": "1G", "status": "up", "deviceId": "dev-009", "portType": "RJ45", "qosConfig": {"trustMode": "dscp", "defaultPriority": 0}, "linkStatus": "connected", "portNumber": "GE1/0/29", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-009-rj45-30", "speed": "1G", "status": "disabled", "deviceId": "dev-009", "portType": "RJ45", "qosConfig": {"trustMode": "dscp", "defaultPriority": 0}, "linkStatus": "connected", "portNumber": "GE1/0/30", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-009-rj45-31", "speed": "1G", "status": "up", "deviceId": "dev-009", "portType": "RJ45", "qosConfig": {"trustMode": "dscp", "defaultPriority": 0}, "linkStatus": "disconnected", "portNumber": "GE1/0/31", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-009-rj45-32", "speed": "1G", "status": "up", "deviceId": "dev-009", "portType": "RJ45", "qosConfig": {"trustMode": "dscp", "defaultPriority": 0}, "linkStatus": "disconnected", "portNumber": "GE1/0/32", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-009-rj45-33", "speed": "1G", "status": "up", "deviceId": "dev-009", "portType": "RJ45", "qosConfig": {"trustMode": "dscp", "defaultPriority": 0}, "linkStatus": "disconnected", "portNumber": "GE1/0/33", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-009-rj45-34", "speed": "1G", "status": "up", "deviceId": "dev-009", "portType": "RJ45", "qosConfig": {"trustMode": "dscp", "defaultPriority": 0}, "linkStatus": "disconnected", "portNumber": "GE1/0/34", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-009-rj45-35", "speed": "1G", "status": "disabled", "deviceId": "dev-009", "portType": "RJ45", "qosConfig": {"trustMode": "dscp", "defaultPriority": 0}, "linkStatus": "disconnected", "portNumber": "GE1/0/35", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-009-rj45-36", "speed": "1G", "status": "up", "deviceId": "dev-009", "portType": "RJ45", "qosConfig": {"trustMode": "dscp", "defaultPriority": 0}, "linkStatus": "disconnected", "portNumber": "GE1/0/36", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-009-rj45-37", "speed": "1G", "status": "up", "deviceId": "dev-009", "portType": "RJ45", "qosConfig": {"trustMode": "dscp", "defaultPriority": 0}, "linkStatus": "disconnected", "portNumber": "GE1/0/37", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-009-rj45-38", "speed": "1G", "status": "up", "deviceId": "dev-009", "portType": "RJ45", "qosConfig": {"trustMode": "dscp", "defaultPriority": 0}, "linkStatus": "disconnected", "portNumber": "GE1/0/38", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-009-rj45-39", "speed": "1G", "status": "up", "deviceId": "dev-009", "portType": "RJ45", "qosConfig": {"trustMode": "dscp", "defaultPriority": 0}, "linkStatus": "disconnected", "portNumber": "GE1/0/39", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-009-rj45-40", "speed": "1G", "status": "disabled", "deviceId": "dev-009", "portType": "RJ45", "qosConfig": {"trustMode": "dscp", "defaultPriority": 0}, "linkStatus": "disconnected", "portNumber": "GE1/0/40", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-009-rj45-41", "speed": "1G", "status": "up", "deviceId": "dev-009", "portType": "RJ45", "qosConfig": {"trustMode": "dscp", "defaultPriority": 0}, "linkStatus": "disconnected", "portNumber": "GE1/0/41", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-009-rj45-42", "speed": "1G", "status": "up", "deviceId": "dev-009", "portType": "RJ45", "qosConfig": {"trustMode": "dscp", "defaultPriority": 0}, "linkStatus": "disconnected", "portNumber": "GE1/0/42", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-009-rj45-43", "speed": "1G", "status": "up", "deviceId": "dev-009", "portType": "RJ45", "qosConfig": {"trustMode": "dscp", "defaultPriority": 0}, "linkStatus": "disconnected", "portNumber": "GE1/0/43", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-009-rj45-44", "speed": "1G", "status": "up", "deviceId": "dev-009", "portType": "RJ45", "qosConfig": {"trustMode": "dscp", "defaultPriority": 0}, "linkStatus": "disconnected", "portNumber": "GE1/0/44", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-009-rj45-45", "speed": "1G", "status": "disabled", "deviceId": "dev-009", "portType": "RJ45", "qosConfig": {"trustMode": "dscp", "defaultPriority": 0}, "linkStatus": "disconnected", "portNumber": "GE1/0/45", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-009-rj45-46", "speed": "1G", "status": "up", "deviceId": "dev-009", "portType": "RJ45", "qosConfig": {"trustMode": "dscp", "defaultPriority": 0}, "linkStatus": "disconnected", "portNumber": "GE1/0/46", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-009-rj45-47", "speed": "1G", "status": "up", "deviceId": "dev-009", "portType": "RJ45", "qosConfig": {"trustMode": "dscp", "defaultPriority": 0}, "linkStatus": "disconnected", "portNumber": "GE1/0/47", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-009-rj45-48", "speed": "1G", "status": "up", "deviceId": "dev-009", "portType": "RJ45", "qosConfig": {"trustMode": "dscp", "defaultPriority": 0}, "linkStatus": "disconnected", "portNumber": "GE1/0/48", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-009-sfp-1", "speed": "10G", "status": "up", "deviceId": "dev-009", "portType": "SFP+", "portAlias": "Uplink-1", "linkStatus": "connected", "portNumber": "XGE1/0/1", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "description": "上联核心交换机-1", "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-2"}, {"id": "port-dev-009-sfp-2", "speed": "10G", "status": "up", "deviceId": "dev-009", "portType": "SFP+", "portAlias": "Uplink-2", "linkStatus": "connected", "portNumber": "XGE1/0/2", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "description": "上联核心交换机-2", "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-2"}, {"id": "port-dev-009-sfp-3", "speed": "10G", "status": "up", "deviceId": "dev-009", "portType": "SFP+", "linkStatus": "disconnected", "portNumber": "XGE1/0/3", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-2"}, {"id": "port-dev-009-sfp-4", "speed": "10G", "status": "up", "deviceId": "dev-009", "portType": "SFP+", "linkStatus": "disconnected", "portNumber": "XGE1/0/4", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-2"}, {"id": "port-dev-010-sfp-1", "speed": "10G", "status": "up", "deviceId": "dev-010", "portType": "SFP+", "linkStatus": "connected", "portNumber": "XGE1/0/1", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-010-sfp-2", "speed": "10G", "status": "up", "deviceId": "dev-010", "portType": "SFP+", "linkStatus": "connected", "portNumber": "XGE1/0/2", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-010-sfp-3", "speed": "10G", "status": "up", "deviceId": "dev-010", "portType": "SFP+", "linkStatus": "connected", "portNumber": "XGE1/0/3", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-010-sfp-4", "speed": "10G", "status": "up", "deviceId": "dev-010", "portType": "SFP+", "linkStatus": "connected", "portNumber": "XGE1/0/4", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-010-sfp-5", "speed": "10G", "status": "up", "deviceId": "dev-010", "portType": "SFP+", "linkStatus": "connected", "portNumber": "XGE1/0/5", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-010-sfp-6", "speed": "10G", "status": "up", "deviceId": "dev-010", "portType": "SFP+", "linkStatus": "connected", "portNumber": "XGE1/0/6", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-010-sfp-7", "speed": "10G", "status": "up", "deviceId": "dev-010", "portType": "SFP+", "linkStatus": "connected", "portNumber": "XGE1/0/7", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-010-sfp-8", "speed": "10G", "status": "up", "deviceId": "dev-010", "portType": "SFP+", "linkStatus": "connected", "portNumber": "XGE1/0/8", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-010-sfp-9", "speed": "10G", "status": "up", "deviceId": "dev-010", "portType": "SFP+", "linkStatus": "connected", "portNumber": "XGE1/0/9", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-010-sfp-10", "speed": "10G", "status": "up", "deviceId": "dev-010", "portType": "SFP+", "linkStatus": "connected", "portNumber": "XGE1/0/10", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-010-sfp-11", "speed": "10G", "status": "up", "deviceId": "dev-010", "portType": "SFP+", "linkStatus": "connected", "portNumber": "XGE1/0/11", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-010-sfp-12", "speed": "10G", "status": "up", "deviceId": "dev-010", "portType": "SFP+", "linkStatus": "connected", "portNumber": "XGE1/0/12", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-010-sfp-13", "speed": "10G", "status": "up", "deviceId": "dev-010", "portType": "SFP+", "linkStatus": "connected", "portNumber": "XGE1/0/13", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-010-sfp-14", "speed": "10G", "status": "up", "deviceId": "dev-010", "portType": "SFP+", "linkStatus": "connected", "portNumber": "XGE1/0/14", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-010-sfp-15", "speed": "10G", "status": "up", "deviceId": "dev-010", "portType": "SFP+", "linkStatus": "connected", "portNumber": "XGE1/0/15", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-010-sfp-16", "speed": "10G", "status": "up", "deviceId": "dev-010", "portType": "SFP+", "linkStatus": "connected", "portNumber": "XGE1/0/16", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-010-sfp-17", "speed": "10G", "status": "up", "deviceId": "dev-010", "portType": "SFP+", "linkStatus": "connected", "portNumber": "XGE1/0/17", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-010-sfp-18", "speed": "10G", "status": "up", "deviceId": "dev-010", "portType": "SFP+", "linkStatus": "connected", "portNumber": "XGE1/0/18", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-010-sfp-19", "speed": "10G", "status": "up", "deviceId": "dev-010", "portType": "SFP+", "linkStatus": "connected", "portNumber": "XGE1/0/19", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-010-sfp-20", "speed": "10G", "status": "up", "deviceId": "dev-010", "portType": "SFP+", "linkStatus": "connected", "portNumber": "XGE1/0/20", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-010-sfp-21", "speed": "10G", "status": "up", "deviceId": "dev-010", "portType": "SFP+", "linkStatus": "connected", "portNumber": "XGE1/0/21", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-010-sfp-22", "speed": "10G", "status": "up", "deviceId": "dev-010", "portType": "SFP+", "linkStatus": "connected", "portNumber": "XGE1/0/22", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-010-sfp-23", "speed": "10G", "status": "up", "deviceId": "dev-010", "portType": "SFP+", "linkStatus": "connected", "portNumber": "XGE1/0/23", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-010-sfp-24", "speed": "10G", "status": "up", "deviceId": "dev-010", "portType": "SFP+", "linkStatus": "connected", "portNumber": "XGE1/0/24", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-010-sfp-25", "speed": "10G", "status": "up", "deviceId": "dev-010", "portType": "SFP+", "linkStatus": "connected", "portNumber": "XGE1/0/25", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-010-sfp-26", "speed": "10G", "status": "up", "deviceId": "dev-010", "portType": "SFP+", "linkStatus": "connected", "portNumber": "XGE1/0/26", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-010-sfp-27", "speed": "10G", "status": "up", "deviceId": "dev-010", "portType": "SFP+", "linkStatus": "connected", "portNumber": "XGE1/0/27", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-010-sfp-28", "speed": "10G", "status": "up", "deviceId": "dev-010", "portType": "SFP+", "linkStatus": "connected", "portNumber": "XGE1/0/28", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-010-sfp-29", "speed": "10G", "status": "up", "deviceId": "dev-010", "portType": "SFP+", "linkStatus": "connected", "portNumber": "XGE1/0/29", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-010-sfp-30", "speed": "10G", "status": "up", "deviceId": "dev-010", "portType": "SFP+", "linkStatus": "connected", "portNumber": "XGE1/0/30", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-010-sfp-31", "speed": "10G", "status": "up", "deviceId": "dev-010", "portType": "SFP+", "linkStatus": "connected", "portNumber": "XGE1/0/31", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-010-sfp-32", "speed": "10G", "status": "up", "deviceId": "dev-010", "portType": "SFP+", "linkStatus": "connected", "portNumber": "XGE1/0/32", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-010-sfp-33", "speed": "10G", "status": "up", "deviceId": "dev-010", "portType": "SFP+", "linkStatus": "connected", "portNumber": "XGE1/0/33", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-010-sfp-34", "speed": "10G", "status": "up", "deviceId": "dev-010", "portType": "SFP+", "linkStatus": "connected", "portNumber": "XGE1/0/34", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-010-sfp-35", "speed": "10G", "status": "up", "deviceId": "dev-010", "portType": "SFP+", "linkStatus": "connected", "portNumber": "XGE1/0/35", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-010-sfp-36", "speed": "10G", "status": "up", "deviceId": "dev-010", "portType": "SFP+", "linkStatus": "connected", "portNumber": "XGE1/0/36", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-010-sfp-37", "speed": "10G", "status": "up", "deviceId": "dev-010", "portType": "SFP+", "linkStatus": "disconnected", "portNumber": "XGE1/0/37", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-010-sfp-38", "speed": "10G", "status": "up", "deviceId": "dev-010", "portType": "SFP+", "linkStatus": "disconnected", "portNumber": "XGE1/0/38", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-010-sfp-39", "speed": "10G", "status": "up", "deviceId": "dev-010", "portType": "SFP+", "linkStatus": "disconnected", "portNumber": "XGE1/0/39", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-010-sfp-40", "speed": "10G", "status": "up", "deviceId": "dev-010", "portType": "SFP+", "linkStatus": "disconnected", "portNumber": "XGE1/0/40", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-010-sfp-41", "speed": "10G", "status": "up", "deviceId": "dev-010", "portType": "SFP+", "linkStatus": "disconnected", "portNumber": "XGE1/0/41", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-010-sfp-42", "speed": "10G", "status": "up", "deviceId": "dev-010", "portType": "SFP+", "linkStatus": "disconnected", "portNumber": "XGE1/0/42", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-010-sfp-43", "speed": "10G", "status": "up", "deviceId": "dev-010", "portType": "SFP+", "linkStatus": "disconnected", "portNumber": "XGE1/0/43", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-010-sfp-44", "speed": "10G", "status": "up", "deviceId": "dev-010", "portType": "SFP+", "linkStatus": "disconnected", "portNumber": "XGE1/0/44", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-010-sfp-45", "speed": "10G", "status": "up", "deviceId": "dev-010", "portType": "SFP+", "linkStatus": "disconnected", "portNumber": "XGE1/0/45", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-010-sfp-46", "speed": "10G", "status": "up", "deviceId": "dev-010", "portType": "SFP+", "linkStatus": "disconnected", "portNumber": "XGE1/0/46", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-010-sfp-47", "speed": "10G", "status": "up", "deviceId": "dev-010", "portType": "SFP+", "linkStatus": "disconnected", "portNumber": "XGE1/0/47", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-010-sfp-48", "speed": "10G", "status": "up", "deviceId": "dev-010", "portType": "SFP+", "linkStatus": "disconnected", "portNumber": "XGE1/0/48", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-010-qsfp-1", "speed": "100G", "status": "up", "deviceId": "dev-010", "portType": "QSFP28", "linkStatus": "connected", "portNumber": "100GE1/0/1", "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-2"}, {"id": "port-dev-010-qsfp-2", "speed": "100G", "status": "up", "deviceId": "dev-010", "portType": "QSFP28", "linkStatus": "connected", "portNumber": "100GE1/0/2", "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-2"}, {"id": "port-dev-010-qsfp-3", "speed": "100G", "status": "up", "deviceId": "dev-010", "portType": "QSFP28", "linkStatus": "disconnected", "portNumber": "100GE1/0/3", "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-2"}, {"id": "port-dev-010-qsfp-4", "speed": "100G", "status": "up", "deviceId": "dev-010", "portType": "QSFP28", "linkStatus": "disconnected", "portNumber": "100GE1/0/4", "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-2"}, {"id": "port-dev-010-qsfp-5", "speed": "100G", "status": "up", "deviceId": "dev-010", "portType": "QSFP28", "linkStatus": "disconnected", "portNumber": "100GE1/0/5", "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-2"}, {"id": "port-dev-010-qsfp-6", "speed": "100G", "status": "up", "deviceId": "dev-010", "portType": "QSFP28", "linkStatus": "disconnected", "portNumber": "100GE1/0/6", "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-2"}, {"id": "port-dev-011-sfp-1", "speed": "10G", "status": "up", "deviceId": "dev-011", "portType": "SFP+", "linkStatus": "connected", "portNumber": "XGE1/0/1", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-011-sfp-2", "speed": "10G", "status": "up", "deviceId": "dev-011", "portType": "SFP+", "linkStatus": "connected", "portNumber": "XGE1/0/2", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-011-sfp-3", "speed": "10G", "status": "up", "deviceId": "dev-011", "portType": "SFP+", "linkStatus": "connected", "portNumber": "XGE1/0/3", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-011-sfp-4", "speed": "10G", "status": "up", "deviceId": "dev-011", "portType": "SFP+", "linkStatus": "connected", "portNumber": "XGE1/0/4", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-011-sfp-5", "speed": "10G", "status": "up", "deviceId": "dev-011", "portType": "SFP+", "linkStatus": "connected", "portNumber": "XGE1/0/5", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-011-sfp-6", "speed": "10G", "status": "up", "deviceId": "dev-011", "portType": "SFP+", "linkStatus": "connected", "portNumber": "XGE1/0/6", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-011-sfp-7", "speed": "10G", "status": "up", "deviceId": "dev-011", "portType": "SFP+", "linkStatus": "connected", "portNumber": "XGE1/0/7", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-011-sfp-8", "speed": "10G", "status": "up", "deviceId": "dev-011", "portType": "SFP+", "linkStatus": "connected", "portNumber": "XGE1/0/8", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-011-sfp-9", "speed": "10G", "status": "up", "deviceId": "dev-011", "portType": "SFP+", "linkStatus": "connected", "portNumber": "XGE1/0/9", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-011-sfp-10", "speed": "10G", "status": "up", "deviceId": "dev-011", "portType": "SFP+", "linkStatus": "connected", "portNumber": "XGE1/0/10", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-011-sfp-11", "speed": "10G", "status": "up", "deviceId": "dev-011", "portType": "SFP+", "linkStatus": "connected", "portNumber": "XGE1/0/11", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-011-sfp-12", "speed": "10G", "status": "up", "deviceId": "dev-011", "portType": "SFP+", "linkStatus": "connected", "portNumber": "XGE1/0/12", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-011-sfp-13", "speed": "10G", "status": "up", "deviceId": "dev-011", "portType": "SFP+", "linkStatus": "connected", "portNumber": "XGE1/0/13", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-011-sfp-14", "speed": "10G", "status": "up", "deviceId": "dev-011", "portType": "SFP+", "linkStatus": "connected", "portNumber": "XGE1/0/14", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-011-sfp-15", "speed": "10G", "status": "up", "deviceId": "dev-011", "portType": "SFP+", "linkStatus": "connected", "portNumber": "XGE1/0/15", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-011-sfp-16", "speed": "10G", "status": "up", "deviceId": "dev-011", "portType": "SFP+", "linkStatus": "connected", "portNumber": "XGE1/0/16", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-011-sfp-17", "speed": "10G", "status": "up", "deviceId": "dev-011", "portType": "SFP+", "linkStatus": "connected", "portNumber": "XGE1/0/17", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-011-sfp-18", "speed": "10G", "status": "up", "deviceId": "dev-011", "portType": "SFP+", "linkStatus": "connected", "portNumber": "XGE1/0/18", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-011-sfp-19", "speed": "10G", "status": "up", "deviceId": "dev-011", "portType": "SFP+", "linkStatus": "connected", "portNumber": "XGE1/0/19", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-011-sfp-20", "speed": "10G", "status": "up", "deviceId": "dev-011", "portType": "SFP+", "linkStatus": "connected", "portNumber": "XGE1/0/20", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-011-sfp-21", "speed": "10G", "status": "up", "deviceId": "dev-011", "portType": "SFP+", "linkStatus": "connected", "portNumber": "XGE1/0/21", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-011-sfp-22", "speed": "10G", "status": "up", "deviceId": "dev-011", "portType": "SFP+", "linkStatus": "connected", "portNumber": "XGE1/0/22", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-011-sfp-23", "speed": "10G", "status": "up", "deviceId": "dev-011", "portType": "SFP+", "linkStatus": "connected", "portNumber": "XGE1/0/23", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-011-sfp-24", "speed": "10G", "status": "up", "deviceId": "dev-011", "portType": "SFP+", "linkStatus": "connected", "portNumber": "XGE1/0/24", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-011-sfp-25", "speed": "10G", "status": "up", "deviceId": "dev-011", "portType": "SFP+", "linkStatus": "disconnected", "portNumber": "XGE1/0/25", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-011-sfp-26", "speed": "10G", "status": "up", "deviceId": "dev-011", "portType": "SFP+", "linkStatus": "disconnected", "portNumber": "XGE1/0/26", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-011-sfp-27", "speed": "10G", "status": "up", "deviceId": "dev-011", "portType": "SFP+", "linkStatus": "disconnected", "portNumber": "XGE1/0/27", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-011-sfp-28", "speed": "10G", "status": "up", "deviceId": "dev-011", "portType": "SFP+", "linkStatus": "disconnected", "portNumber": "XGE1/0/28", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-011-sfp-29", "speed": "10G", "status": "up", "deviceId": "dev-011", "portType": "SFP+", "linkStatus": "disconnected", "portNumber": "XGE1/0/29", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-011-sfp-30", "speed": "10G", "status": "up", "deviceId": "dev-011", "portType": "SFP+", "linkStatus": "disconnected", "portNumber": "XGE1/0/30", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-011-sfp-31", "speed": "10G", "status": "up", "deviceId": "dev-011", "portType": "SFP+", "linkStatus": "disconnected", "portNumber": "XGE1/0/31", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-011-sfp-32", "speed": "10G", "status": "up", "deviceId": "dev-011", "portType": "SFP+", "linkStatus": "disconnected", "portNumber": "XGE1/0/32", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-011-sfp-33", "speed": "10G", "status": "up", "deviceId": "dev-011", "portType": "SFP+", "linkStatus": "disconnected", "portNumber": "XGE1/0/33", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-011-sfp-34", "speed": "10G", "status": "up", "deviceId": "dev-011", "portType": "SFP+", "linkStatus": "disconnected", "portNumber": "XGE1/0/34", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-011-sfp-35", "speed": "10G", "status": "up", "deviceId": "dev-011", "portType": "SFP+", "linkStatus": "disconnected", "portNumber": "XGE1/0/35", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-011-sfp-36", "speed": "10G", "status": "up", "deviceId": "dev-011", "portType": "SFP+", "linkStatus": "disconnected", "portNumber": "XGE1/0/36", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-011-sfp-37", "speed": "10G", "status": "up", "deviceId": "dev-011", "portType": "SFP+", "linkStatus": "disconnected", "portNumber": "XGE1/0/37", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-011-sfp-38", "speed": "10G", "status": "up", "deviceId": "dev-011", "portType": "SFP+", "linkStatus": "disconnected", "portNumber": "XGE1/0/38", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-011-sfp-39", "speed": "10G", "status": "up", "deviceId": "dev-011", "portType": "SFP+", "linkStatus": "disconnected", "portNumber": "XGE1/0/39", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-011-sfp-40", "speed": "10G", "status": "up", "deviceId": "dev-011", "portType": "SFP+", "linkStatus": "disconnected", "portNumber": "XGE1/0/40", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-011-sfp-41", "speed": "10G", "status": "up", "deviceId": "dev-011", "portType": "SFP+", "linkStatus": "disconnected", "portNumber": "XGE1/0/41", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-011-sfp-42", "speed": "10G", "status": "up", "deviceId": "dev-011", "portType": "SFP+", "linkStatus": "disconnected", "portNumber": "XGE1/0/42", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-011-sfp-43", "speed": "10G", "status": "up", "deviceId": "dev-011", "portType": "SFP+", "linkStatus": "disconnected", "portNumber": "XGE1/0/43", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-011-sfp-44", "speed": "10G", "status": "up", "deviceId": "dev-011", "portType": "SFP+", "linkStatus": "disconnected", "portNumber": "XGE1/0/44", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-011-sfp-45", "speed": "10G", "status": "up", "deviceId": "dev-011", "portType": "SFP+", "linkStatus": "disconnected", "portNumber": "XGE1/0/45", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-011-sfp-46", "speed": "10G", "status": "up", "deviceId": "dev-011", "portType": "SFP+", "linkStatus": "disconnected", "portNumber": "XGE1/0/46", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-011-sfp-47", "speed": "10G", "status": "up", "deviceId": "dev-011", "portType": "SFP+", "linkStatus": "disconnected", "portNumber": "XGE1/0/47", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-011-sfp-48", "speed": "10G", "status": "up", "deviceId": "dev-011", "portType": "SFP+", "linkStatus": "disconnected", "portNumber": "XGE1/0/48", "vlanConfig": {"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}, "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-011-qsfp-1", "speed": "40G", "status": "up", "deviceId": "dev-011", "portType": "QSFP+", "linkStatus": "connected", "portNumber": "40GE1/0/1", "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-2"}, {"id": "port-dev-011-qsfp-2", "speed": "40G", "status": "up", "deviceId": "dev-011", "portType": "QSFP+", "linkStatus": "connected", "portNumber": "40GE1/0/2", "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-2"}, {"id": "port-dev-011-qsfp-3", "speed": "40G", "status": "up", "deviceId": "dev-011", "portType": "QSFP+", "linkStatus": "disconnected", "portNumber": "40GE1/0/3", "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-2"}, {"id": "port-dev-011-qsfp-4", "speed": "40G", "status": "up", "deviceId": "dev-011", "portType": "QSFP+", "linkStatus": "disconnected", "portNumber": "40GE1/0/4", "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-2"}, {"id": "port-dev-011-qsfp-5", "speed": "40G", "status": "up", "deviceId": "dev-011", "portType": "QSFP+", "linkStatus": "disconnected", "portNumber": "40GE1/0/5", "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-2"}, {"id": "port-dev-011-qsfp-6", "speed": "40G", "status": "up", "deviceId": "dev-011", "portType": "QSFP+", "linkStatus": "disconnected", "portNumber": "40GE1/0/6", "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-2"}, {"id": "port-dev-011-qsfp-7", "speed": "40G", "status": "up", "deviceId": "dev-011", "portType": "QSFP+", "linkStatus": "disconnected", "portNumber": "40GE1/0/7", "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-2"}, {"id": "port-dev-011-qsfp-8", "speed": "40G", "status": "up", "deviceId": "dev-011", "portType": "QSFP+", "linkStatus": "disconnected", "portNumber": "40GE1/0/8", "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-2"}, {"id": "port-dev-012-mgmt", "speed": "1G", "status": "up", "deviceId": "dev-012", "portType": "RJ45", "portAlias": "IPMI管理口", "linkStatus": "connected", "portNumber": "Mgmt", "description": "IPMI/iLO/iDRAC管理口", "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-1"}, {"id": "port-dev-012-eth-1", "speed": "1G", "status": "up", "deviceId": "dev-012", "portType": "RJ45", "linkStatus": "connected", "portNumber": "eth1", "vlanConfig": {"mode": "access", "pvid": 100}, "description": "业务网络", "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-2"}, {"id": "port-dev-012-eth-2", "speed": "1G", "status": "up", "deviceId": "dev-012", "portType": "RJ45", "linkStatus": "connected", "portNumber": "eth2", "vlanConfig": {"mode": "access", "pvid": 200}, "description": "管理网络", "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-2"}, {"id": "port-dev-012-eth-3", "speed": "1G", "status": "up", "deviceId": "dev-012", "portType": "RJ45", "linkStatus": "disconnected", "portNumber": "eth3", "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-2"}, {"id": "port-dev-012-eth-4", "speed": "1G", "status": "up", "deviceId": "dev-012", "portType": "RJ45", "linkStatus": "disconnected", "portNumber": "eth4", "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-2"}, {"id": "port-dev-012-pwr-1", "speed": "N/A", "status": "up", "deviceId": "dev-012", "portType": "Power", "linkStatus": "connected", "portNumber": "PWR1", "description": "电源模块1", "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-3"}, {"id": "port-dev-012-pwr-2", "speed": "N/A", "status": "up", "deviceId": "dev-012", "portType": "Power", "linkStatus": "connected", "portNumber": "PWR2", "description": "电源模块2", "lastUpdated": "2024-12-01T10:00:00Z", "portGroupId": "pg-3"}]	2026-06-23 08:38:42.107162+00
raw-connections	connections	[{"id": "conn-001", "status": "active", "cableType": "SingleModeFiber", "createdAt": "2023-02-25T08:00:00Z", "updatedAt": "2024-12-01T10:00:00Z", "cableColor": "#3498db", "cableLength": 3, "cableNumber": "BJ-FIBER-001", "description": "核心到接入上联-1", "sourcePortId": "port-dev-001-sfp-1", "targetPortId": "port-dev-002-sfp-1", "connectionType": "network", "sourceDeviceId": "dev-001", "targetDeviceId": "dev-002"}, {"id": "conn-002", "status": "active", "cableType": "SingleModeFiber", "createdAt": "2023-02-25T08:00:00Z", "updatedAt": "2024-12-01T10:00:00Z", "cableColor": "#3498db", "cableLength": 3, "cableNumber": "BJ-FIBER-002", "description": "核心到接入上联-2", "sourcePortId": "port-dev-001-sfp-2", "targetPortId": "port-dev-002-sfp-2", "connectionType": "network", "sourceDeviceId": "dev-001", "targetDeviceId": "dev-002"}, {"id": "conn-003", "status": "active", "cableType": "Cat6a", "createdAt": "2023-03-20T08:00:00Z", "updatedAt": "2024-11-20T14:00:00Z", "cableColor": "#2ecc71", "cableLength": 2, "cableNumber": "BJ-CAT6A-001", "description": "服务器A1-1业务网络", "sourcePortId": "port-dev-002-rj45-1", "targetPortId": "port-dev-003-eth-1", "connectionType": "network", "sourceDeviceId": "dev-002", "targetDeviceId": "dev-003"}, {"id": "conn-004", "status": "active", "cableType": "Cat6a", "createdAt": "2023-03-20T08:00:00Z", "updatedAt": "2024-11-20T14:00:00Z", "cableColor": "#2ecc71", "cableLength": 2, "cableNumber": "BJ-CAT6A-002", "description": "服务器A1-1管理网络", "sourcePortId": "port-dev-002-rj45-2", "targetPortId": "port-dev-003-eth-2", "connectionType": "network", "sourceDeviceId": "dev-002", "targetDeviceId": "dev-003"}, {"id": "conn-005", "status": "active", "cableType": "Cat6a", "createdAt": "2023-03-20T08:00:00Z", "updatedAt": "2024-11-20T14:00:00Z", "cableColor": "#2ecc71", "cableLength": 2, "cableNumber": "BJ-CAT6A-003", "description": "服务器A1-2业务网络", "sourcePortId": "port-dev-002-rj45-3", "targetPortId": "port-dev-004-eth-1", "connectionType": "network", "sourceDeviceId": "dev-002", "targetDeviceId": "dev-004"}, {"id": "conn-006", "status": "active", "cableType": "Cat6a", "createdAt": "2023-04-10T08:00:00Z", "updatedAt": "2024-10-15T16:00:00Z", "cableColor": "#2ecc71", "cableLength": 2, "cableNumber": "BJ-CAT6A-004", "description": "数据库服务器业务网络", "sourcePortId": "port-dev-002-rj45-4", "targetPortId": "port-dev-005-eth-1", "connectionType": "network", "sourceDeviceId": "dev-002", "targetDeviceId": "dev-005"}, {"id": "conn-007", "status": "active", "cableType": "MultiModeFiber", "createdAt": "2023-02-10T08:00:00Z", "updatedAt": "2024-11-28T11:00:00Z", "cableColor": "#e67e22", "cableLength": 5, "cableNumber": "BJ-FIBER-003", "description": "防火墙到负载均衡", "sourcePortId": "port-dev-006-sfp-1", "targetPortId": "port-dev-007-sfp-1", "connectionType": "network", "sourceDeviceId": "dev-006", "targetDeviceId": "dev-007"}, {"id": "conn-008", "status": "active", "cableType": "Cat6a", "createdAt": "2023-05-15T08:00:00Z", "updatedAt": "2024-09-20T09:00:00Z", "cableColor": "#9b59b6", "cableLength": 10, "cableNumber": "BJ-ISCSI-001", "description": "数据库到存储iSCSI连接", "sourcePortId": "port-dev-005-eth-2", "targetPortId": "port-dev-008-iscsi-1", "connectionType": "storage", "sourceDeviceId": "dev-005", "targetDeviceId": "dev-008"}, {"id": "conn-009", "status": "active", "cableType": "SingleModeFiber", "createdAt": "2023-02-10T08:00:00Z", "updatedAt": "2024-12-01T10:00:00Z", "cableColor": "#3498db", "cableLength": 15, "cableNumber": "BJ-FIBER-004", "description": "核心交换机到防火墙", "sourcePortId": "port-dev-001-sfp-3", "targetPortId": "port-dev-006-sfp-2", "connectionType": "network", "sourceDeviceId": "dev-001", "targetDeviceId": "dev-006"}, {"id": "conn-010", "status": "active", "cableType": "Cat6", "createdAt": "2023-03-20T08:00:00Z", "updatedAt": "2024-11-20T14:00:00Z", "cableColor": "#27ae60", "cableLength": 3, "cableNumber": "BJ-MGMT-001", "description": "服务器IPMI管理", "sourcePortId": "port-dev-002-rj45-47", "targetPortId": "port-dev-003-mgmt", "connectionType": "management", "sourceDeviceId": "dev-002", "targetDeviceId": "dev-003"}]	2026-06-23 08:38:42.107162+00
raw-pduDevices	pduDevices	[{"id": "pdu-001", "endU": 2, "name": "PDU-A-01", "startU": 1, "status": "online", "pduData": {"brand": "APC", "model": "AP7921", "maxLoad": 3000, "powerPath": "A", "currentLoad": 1800, "outputPorts": 16, "inputVoltage": 220}, "uHeight": 2, "category": "pdu", "assetCode": "PDU-2024-001", "cabinetId": "cab-bj-001", "createdAt": "2024-01-15T08:00:00Z", "updatedAt": "2024-01-28T10:00:00Z", "managementIp": "192.168.1.101"}, {"id": "pdu-002", "endU": 4, "name": "PDU-B-01", "startU": 3, "status": "online", "pduData": {"brand": "APC", "model": "AP7921", "maxLoad": 3000, "powerPath": "B", "currentLoad": 1650, "outputPorts": 16, "inputVoltage": 220}, "uHeight": 2, "category": "pdu", "assetCode": "PDU-2024-002", "cabinetId": "cab-bj-001", "createdAt": "2024-01-15T08:00:00Z", "updatedAt": "2024-01-28T10:00:00Z", "managementIp": "192.168.1.102"}, {"id": "pdu-003", "endU": 2, "name": "PDU-A-02", "startU": 1, "status": "online", "pduData": {"brand": "Schneider", "model": "AP8941", "maxLoad": 5000, "powerPath": "A", "currentLoad": 2400, "outputPorts": 24, "inputVoltage": 220}, "uHeight": 2, "category": "pdu", "assetCode": "PDU-2024-003", "cabinetId": "cab-bj-002", "createdAt": "2024-01-15T08:00:00Z", "updatedAt": "2024-01-28T10:00:00Z", "managementIp": "192.168.1.103"}, {"id": "pdu-004", "endU": 4, "name": "PDU-B-02", "startU": 3, "status": "warning", "pduData": {"brand": "Schneider", "model": "AP8941", "maxLoad": 5000, "powerPath": "B", "currentLoad": 4200, "outputPorts": 24, "inputVoltage": 220}, "uHeight": 2, "category": "pdu", "assetCode": "PDU-2024-004", "cabinetId": "cab-bj-002", "createdAt": "2024-01-15T08:00:00Z", "updatedAt": "2024-01-28T10:00:00Z", "managementIp": "192.168.1.104"}]	2026-06-23 08:38:42.107162+00
raw-pduTemplates	pduTemplates	[{"id": "tpl-pdu-001", "brand": "APC", "model": "AP7921", "specs": {"maxLoad": "3000W", "outputPorts": 16, "inputVoltage": "220V", "ratedCurrent": "16A"}, "uHeight": 2, "category": "pdu", "portGroups": [], "powerConsumption": 0}, {"id": "tpl-pdu-002", "brand": "Schneider", "model": "AP8941", "specs": {"maxLoad": "5000W", "outputPorts": 24, "inputVoltage": "220V", "ratedCurrent": "32A"}, "uHeight": 2, "category": "pdu", "portGroups": [], "powerConsumption": 0}]	2026-06-23 08:38:42.107162+00
raw-powerTopology	powerTopology	{"links": [{"id": "link-001", "source": "utility-001", "status": "active", "target": "ups-001", "powerPath": "A", "datacenterId": "dc-001"}, {"id": "link-002", "source": "utility-002", "status": "active", "target": "ups-002", "powerPath": "B", "datacenterId": "dc-001"}, {"id": "link-003", "source": "ups-001", "status": "active", "target": "pdu-001", "powerPath": "A", "datacenterId": "dc-001"}, {"id": "link-004", "source": "ups-002", "status": "active", "target": "pdu-002", "powerPath": "B", "datacenterId": "dc-001"}, {"id": "link-005", "source": "ups-001", "status": "active", "target": "pdu-003", "powerPath": "A", "datacenterId": "dc-001"}, {"id": "link-006", "source": "ups-002", "status": "active", "target": "pdu-004", "powerPath": "B", "datacenterId": "dc-001"}, {"id": "link-007", "source": "pdu-001", "status": "active", "target": "dev-001", "powerPath": "A", "datacenterId": "dc-001"}, {"id": "link-008", "source": "pdu-002", "status": "active", "target": "dev-001", "powerPath": "B", "datacenterId": "dc-001"}, {"id": "link-009", "source": "pdu-001", "status": "active", "target": "dev-002", "powerPath": "A", "datacenterId": "dc-001"}, {"id": "link-010", "source": "pdu-002", "status": "active", "target": "dev-002", "powerPath": "B", "datacenterId": "dc-001"}, {"id": "link-011", "source": "pdu-003", "status": "active", "target": "dev-003", "powerPath": "A", "datacenterId": "dc-001"}, {"id": "link-012", "source": "pdu-003", "status": "active", "target": "dev-004", "powerPath": "A", "datacenterId": "dc-001"}, {"id": "link-013", "source": "pdu-004", "status": "active", "target": "dev-004", "powerPath": "B", "datacenterId": "dc-001"}, {"id": "link-101", "source": "utility-101", "status": "active", "target": "ups-101", "powerPath": "A", "datacenterId": "dc-002"}, {"id": "link-102", "source": "utility-102", "status": "active", "target": "ups-102", "powerPath": "B", "datacenterId": "dc-002"}, {"id": "link-103", "source": "ups-101", "status": "active", "target": "pdu-101", "powerPath": "A", "datacenterId": "dc-002"}, {"id": "link-104", "source": "ups-102", "status": "active", "target": "pdu-102", "powerPath": "B", "datacenterId": "dc-002"}, {"id": "link-105", "source": "pdu-101", "status": "active", "target": "dev-009", "powerPath": "A", "datacenterId": "dc-002"}, {"id": "link-106", "source": "pdu-102", "status": "active", "target": "dev-009", "powerPath": "B", "datacenterId": "dc-002"}, {"id": "link-107", "source": "pdu-101", "status": "active", "target": "dev-010", "powerPath": "A", "datacenterId": "dc-002"}], "nodes": [{"id": "utility-001", "name": "市电A路", "type": "utility", "status": "online", "capacity": 50000, "datacenterId": "dc-001"}, {"id": "utility-002", "name": "市电B路", "type": "utility", "status": "online", "capacity": 50000, "datacenterId": "dc-001"}, {"id": "ups-001", "load": 18000, "name": "UPS-A-01", "type": "ups", "status": "online", "capacity": 30000, "datacenterId": "dc-001"}, {"id": "ups-002", "load": 16500, "name": "UPS-B-01", "type": "ups", "status": "online", "capacity": 30000, "datacenterId": "dc-001"}, {"id": "pdu-001", "load": 1800, "name": "PDU-A-01", "type": "pdu", "status": "online", "capacity": 3000, "datacenterId": "dc-001"}, {"id": "pdu-002", "load": 1650, "name": "PDU-B-01", "type": "pdu", "status": "online", "capacity": 3000, "datacenterId": "dc-001"}, {"id": "pdu-003", "load": 2400, "name": "PDU-A-02", "type": "pdu", "status": "online", "capacity": 5000, "datacenterId": "dc-001"}, {"id": "pdu-004", "load": 4200, "name": "PDU-B-02", "type": "pdu", "status": "warning", "capacity": 5000, "datacenterId": "dc-001"}, {"id": "dev-001", "load": 300, "name": "核心交换机-A1", "type": "device", "status": "online", "datacenterId": "dc-001"}, {"id": "dev-002", "load": 350, "name": "接入交换机-A1-1", "type": "device", "status": "online", "datacenterId": "dc-001"}, {"id": "dev-003", "load": 150, "name": "应用服务器-A1-1", "type": "device", "status": "online", "datacenterId": "dc-001"}, {"id": "dev-004", "load": 400, "name": "应用服务器-A1-2", "type": "device", "status": "online", "datacenterId": "dc-001"}, {"id": "utility-101", "name": "市电A路", "type": "utility", "status": "online", "capacity": 40000, "datacenterId": "dc-002"}, {"id": "utility-102", "name": "市电B路", "type": "utility", "status": "warning", "capacity": 40000, "datacenterId": "dc-002"}, {"id": "ups-101", "load": 12000, "name": "UPS-A-01", "type": "ups", "status": "online", "capacity": 25000, "datacenterId": "dc-002"}, {"id": "ups-102", "load": 10500, "name": "UPS-B-01", "type": "ups", "status": "online", "capacity": 25000, "datacenterId": "dc-002"}, {"id": "pdu-101", "load": 2000, "name": "PDU-A-01", "type": "pdu", "status": "online", "capacity": 4000, "datacenterId": "dc-002"}, {"id": "pdu-102", "load": 1800, "name": "PDU-B-01", "type": "pdu", "status": "online", "capacity": 4000, "datacenterId": "dc-002"}, {"id": "dev-009", "load": 280, "name": "接入交换机-B1-1", "type": "device", "status": "online", "datacenterId": "dc-002"}, {"id": "dev-010", "load": 320, "name": "核心交换机-B1", "type": "device", "status": "warning", "datacenterId": "dc-002"}]}	2026-06-23 08:38:42.107162+00
raw-cabinetUsageRank	cabinetUsageRank	[{"usage": 0.92, "cabinetId": "cab-bj-001", "cabinetName": "A区1排1号"}, {"usage": 0.88, "cabinetId": "cab-bj-003", "cabinetName": "A区1排3号"}, {"usage": 0.85, "cabinetId": "cab-sz-001", "cabinetName": "C区1排1号"}, {"usage": 0.82, "cabinetId": "cab-bj-002", "cabinetName": "A区1排2号"}, {"usage": 0.78, "cabinetId": "cab-sh-001", "cabinetName": "B区1排1号"}, {"usage": 0.75, "cabinetId": "cab-sz-002", "cabinetName": "C区1排2号"}, {"usage": 0.72, "cabinetId": "cab-bj-004", "cabinetName": "A区1排4号"}, {"usage": 0.68, "cabinetId": "cab-sh-002", "cabinetName": "B区1排2号"}, {"usage": 0.65, "cabinetId": "cab-bj-005", "cabinetName": "A区1排5号"}, {"usage": 0.6, "cabinetId": "cab-sz-003", "cabinetName": "C区1排3号"}]	2026-06-23 08:38:42.107162+00
raw-powerRedundancy	powerRedundancy	{"summary": {"totalDevices": 6, "dualPowerCount": 4, "redundancyRate": "66.67%", "singlePowerCount": 2}, "dualPower": [{"id": "dev-001", "load": 300, "name": "核心交换机-A1", "type": "device", "status": "online", "powerPaths": ["A", "B"], "datacenterId": "dc-001"}, {"id": "dev-002", "load": 350, "name": "接入交换机-A1-1", "type": "device", "status": "online", "powerPaths": ["A", "B"], "datacenterId": "dc-001"}, {"id": "dev-004", "load": 400, "name": "应用服务器-A1-2", "type": "device", "status": "online", "powerPaths": ["A", "B"], "datacenterId": "dc-001"}, {"id": "dev-009", "load": 280, "name": "接入交换机-B1-1", "type": "device", "status": "online", "powerPaths": ["A", "B"], "datacenterId": "dc-002"}], "singlePower": [{"id": "dev-003", "load": 150, "name": "应用服务器-A1-1", "risk": "single-point-failure", "type": "device", "status": "online", "powerPaths": ["A"], "datacenterId": "dc-001"}, {"id": "dev-010", "load": 320, "name": "核心交换机-B1", "risk": "single-point-failure", "type": "device", "status": "warning", "powerPaths": ["A"], "datacenterId": "dc-002"}]}	2026-06-23 08:38:42.107162+00
raw-powerLoadBalance	powerLoadBalance	{"pathA": {"load": 38000, "percentage": "51.37%"}, "pathB": {"load": 35980, "percentage": "48.63%"}, "status": "balanced", "totalLoad": 73980, "balanceRate": "2.73%"}	2026-06-23 08:38:42.107162+00
raw-cabinetEnvironment	cabinetEnvironment	[{"status": "normal", "cabinetId": "cab-bj-001", "avgHumidity": 37.8, "cabinetName": "A区1排1号", "datacenterId": "dc-001", "avgTemperature": 20.9, "datacenterName": "北京亦庄数据中心", "maxTemperature": 21.3, "minTemperature": 19.2}, {"status": "normal", "cabinetId": "cab-bj-002", "avgHumidity": 54.7, "cabinetName": "A区1排2号", "datacenterId": "dc-001", "avgTemperature": 22, "datacenterName": "北京亦庄数据中心", "maxTemperature": 23.9, "minTemperature": 21.9}, {"status": "normal", "cabinetId": "cab-bj-003", "avgHumidity": 51.6, "cabinetName": "A区1排3号", "datacenterId": "dc-001", "avgTemperature": 21.5, "datacenterName": "北京亦庄数据中心", "maxTemperature": 23.9, "minTemperature": 20.5}, {"status": "normal", "cabinetId": "cab-bj-004", "avgHumidity": 53.7, "cabinetName": "A区1排4号", "datacenterId": "dc-001", "avgTemperature": 22.7, "datacenterName": "北京亦庄数据中心", "maxTemperature": 23, "minTemperature": 22.3}, {"status": "warning", "cabinetId": "cab-bj-005", "avgHumidity": 38.3, "cabinetName": "A区1排5号", "datacenterId": "dc-001", "avgTemperature": 27.2, "datacenterName": "北京亦庄数据中心", "maxTemperature": 27.9, "minTemperature": 27.1}, {"status": "normal", "cabinetId": "cab-bj-006", "avgHumidity": 50.7, "cabinetName": "A区2排1号", "datacenterId": "dc-001", "avgTemperature": 23.8, "datacenterName": "北京亦庄数据中心", "maxTemperature": 25.6, "minTemperature": 23.1}, {"status": "warning", "cabinetId": "cab-bj-007", "avgHumidity": 37, "cabinetName": "A区2排2号", "datacenterId": "dc-001", "avgTemperature": 27.3, "datacenterName": "北京亦庄数据中心", "maxTemperature": 29.7, "minTemperature": 26.7}, {"status": "normal", "cabinetId": "cab-bj-008", "avgHumidity": 50.4, "cabinetName": "A区2排3号", "datacenterId": "dc-001", "avgTemperature": 25.1, "datacenterName": "北京亦庄数据中心", "maxTemperature": 25.3, "minTemperature": 24.5}, {"status": "normal", "cabinetId": "cab-bj-009", "avgHumidity": 35.1, "cabinetName": "A区2排4号", "datacenterId": "dc-001", "avgTemperature": 25.8, "datacenterName": "北京亦庄数据中心", "maxTemperature": 27.2, "minTemperature": 24.4}, {"status": "normal", "cabinetId": "cab-bj-010", "avgHumidity": 49.9, "cabinetName": "A区2排5号", "datacenterId": "dc-001", "avgTemperature": 22, "datacenterName": "北京亦庄数据中心", "maxTemperature": 22.3, "minTemperature": 21.5}, {"status": "warning", "cabinetId": "cab-bj-011", "avgHumidity": 37.1, "cabinetName": "A区3排1号", "datacenterId": "dc-001", "avgTemperature": 27.7, "datacenterName": "北京亦庄数据中心", "maxTemperature": 30.6, "minTemperature": 26.6}, {"status": "normal", "cabinetId": "cab-bj-012", "avgHumidity": 50.4, "cabinetName": "A区3排2号", "datacenterId": "dc-001", "avgTemperature": 21.1, "datacenterName": "北京亦庄数据中心", "maxTemperature": 23.1, "minTemperature": 19.2}, {"status": "normal", "cabinetId": "cab-bj-013", "avgHumidity": 51, "cabinetName": "A区3排3号", "datacenterId": "dc-001", "avgTemperature": 21, "datacenterName": "北京亦庄数据中心", "maxTemperature": 22.2, "minTemperature": 20.3}, {"status": "warning", "cabinetId": "cab-bj-014", "avgHumidity": 38.3, "cabinetName": "A区3排4号", "datacenterId": "dc-001", "avgTemperature": 26.4, "datacenterName": "北京亦庄数据中心", "maxTemperature": 28.3, "minTemperature": 24.5}, {"status": "normal", "cabinetId": "cab-bj-015", "avgHumidity": 42.3, "cabinetName": "A区3排5号", "datacenterId": "dc-001", "avgTemperature": 23.7, "datacenterName": "北京亦庄数据中心", "maxTemperature": 26.2, "minTemperature": 21.8}, {"status": "normal", "cabinetId": "cab-bj-016", "avgHumidity": 37.2, "cabinetName": "A区4排1号", "datacenterId": "dc-001", "avgTemperature": 26, "datacenterName": "北京亦庄数据中心", "maxTemperature": 27.5, "minTemperature": 25.8}, {"status": "normal", "cabinetId": "cab-bj-017", "avgHumidity": 37.5, "cabinetName": "A区4排2号", "datacenterId": "dc-001", "avgTemperature": 24.6, "datacenterName": "北京亦庄数据中心", "maxTemperature": 27.3, "minTemperature": 23.1}, {"status": "normal", "cabinetId": "cab-bj-018", "avgHumidity": 45.8, "cabinetName": "A区4排3号", "datacenterId": "dc-001", "avgTemperature": 22, "datacenterName": "北京亦庄数据中心", "maxTemperature": 24.7, "minTemperature": 21.4}, {"status": "normal", "cabinetId": "cab-bj-019", "avgHumidity": 42, "cabinetName": "A区4排4号", "datacenterId": "dc-001", "avgTemperature": 22.4, "datacenterName": "北京亦庄数据中心", "maxTemperature": 25.2, "minTemperature": 22.2}, {"status": "warning", "cabinetId": "cab-bj-020", "avgHumidity": 46.8, "cabinetName": "A区4排5号", "datacenterId": "dc-001", "avgTemperature": 27.1, "datacenterName": "北京亦庄数据中心", "maxTemperature": 28.3, "minTemperature": 26}, {"status": "normal", "cabinetId": "cab-sh-001", "avgHumidity": 37.6, "cabinetName": "B区1排1号", "datacenterId": "dc-002", "avgTemperature": 21.6, "datacenterName": "上海嘉定数据中心", "maxTemperature": 24, "minTemperature": 20.3}, {"status": "warning", "cabinetId": "cab-sh-002", "avgHumidity": 36.2, "cabinetName": "B区1排2号", "datacenterId": "dc-002", "avgTemperature": 27, "datacenterName": "上海嘉定数据中心", "maxTemperature": 27, "minTemperature": 26.8}, {"status": "warning", "cabinetId": "cab-sh-003", "avgHumidity": 48.1, "cabinetName": "B区1排3号", "datacenterId": "dc-002", "avgTemperature": 26.6, "datacenterName": "上海嘉定数据中心", "maxTemperature": 29.3, "minTemperature": 25.9}, {"status": "normal", "cabinetId": "cab-sh-004", "avgHumidity": 46.1, "cabinetName": "B区1排4号", "datacenterId": "dc-002", "avgTemperature": 22.4, "datacenterName": "上海嘉定数据中心", "maxTemperature": 23.5, "minTemperature": 22.1}, {"status": "normal", "cabinetId": "cab-sh-005", "avgHumidity": 43.7, "cabinetName": "B区1排5号", "datacenterId": "dc-002", "avgTemperature": 25.7, "datacenterName": "上海嘉定数据中心", "maxTemperature": 27.4, "minTemperature": 24.3}, {"status": "normal", "cabinetId": "cab-sh-006", "avgHumidity": 42.4, "cabinetName": "B区2排1号", "datacenterId": "dc-002", "avgTemperature": 20.2, "datacenterName": "上海嘉定数据中心", "maxTemperature": 21.6, "minTemperature": 19.2}, {"status": "normal", "cabinetId": "cab-sh-007", "avgHumidity": 45.8, "cabinetName": "B区2排2号", "datacenterId": "dc-002", "avgTemperature": 23.2, "datacenterName": "上海嘉定数据中心", "maxTemperature": 23.7, "minTemperature": 21.9}, {"status": "normal", "cabinetId": "cab-sh-008", "avgHumidity": 38.1, "cabinetName": "B区2排3号", "datacenterId": "dc-002", "avgTemperature": 20.3, "datacenterName": "上海嘉定数据中心", "maxTemperature": 21.3, "minTemperature": 18.5}, {"status": "normal", "cabinetId": "cab-sh-009", "avgHumidity": 37.3, "cabinetName": "B区2排4号", "datacenterId": "dc-002", "avgTemperature": 24.8, "datacenterName": "上海嘉定数据中心", "maxTemperature": 26.6, "minTemperature": 23.2}, {"status": "normal", "cabinetId": "cab-sh-010", "avgHumidity": 35.1, "cabinetName": "B区2排5号", "datacenterId": "dc-002", "avgTemperature": 22.4, "datacenterName": "上海嘉定数据中心", "maxTemperature": 23.9, "minTemperature": 20.5}, {"status": "normal", "cabinetId": "cab-sh-011", "avgHumidity": 36, "cabinetName": "B区3排1号", "datacenterId": "dc-002", "avgTemperature": 23, "datacenterName": "上海嘉定数据中心", "maxTemperature": 25.3, "minTemperature": 22.8}, {"status": "normal", "cabinetId": "cab-sh-012", "avgHumidity": 38.5, "cabinetName": "B区3排2号", "datacenterId": "dc-002", "avgTemperature": 22.6, "datacenterName": "上海嘉定数据中心", "maxTemperature": 24.6, "minTemperature": 20.7}, {"status": "normal", "cabinetId": "cab-sh-013", "avgHumidity": 50.6, "cabinetName": "B区3排3号", "datacenterId": "dc-002", "avgTemperature": 21.7, "datacenterName": "上海嘉定数据中心", "maxTemperature": 22.3, "minTemperature": 21.4}, {"status": "normal", "cabinetId": "cab-sh-014", "avgHumidity": 36.4, "cabinetName": "B区3排4号", "datacenterId": "dc-002", "avgTemperature": 25.9, "datacenterName": "上海嘉定数据中心", "maxTemperature": 28.5, "minTemperature": 24.9}, {"status": "normal", "cabinetId": "cab-sh-015", "avgHumidity": 37.7, "cabinetName": "B区3排5号", "datacenterId": "dc-002", "avgTemperature": 25.7, "datacenterName": "上海嘉定数据中心", "maxTemperature": 26.7, "minTemperature": 25.2}, {"status": "normal", "cabinetId": "cab-sz-001", "avgHumidity": 36.5, "cabinetName": "C区1排1号", "datacenterId": "dc-003", "avgTemperature": 24.8, "datacenterName": "深圳坪山数据中心", "maxTemperature": 25.4, "minTemperature": 24.5}, {"status": "warning", "cabinetId": "cab-sz-002", "avgHumidity": 49.2, "cabinetName": "C区1排2号", "datacenterId": "dc-003", "avgTemperature": 26.7, "datacenterName": "深圳坪山数据中心", "maxTemperature": 28.1, "minTemperature": 25.5}, {"status": "normal", "cabinetId": "cab-sz-003", "avgHumidity": 38.9, "cabinetName": "C区1排3号", "datacenterId": "dc-003", "avgTemperature": 26, "datacenterName": "深圳坪山数据中心", "maxTemperature": 26.1, "minTemperature": 25.1}, {"status": "normal", "cabinetId": "cab-sz-004", "avgHumidity": 49.9, "cabinetName": "C区1排4号", "datacenterId": "dc-003", "avgTemperature": 23.8, "datacenterName": "深圳坪山数据中心", "maxTemperature": 26.6, "minTemperature": 23.3}, {"status": "normal", "cabinetId": "cab-sz-005", "avgHumidity": 45.9, "cabinetName": "C区1排5号", "datacenterId": "dc-003", "avgTemperature": 25.3, "datacenterName": "深圳坪山数据中心", "maxTemperature": 28.2, "minTemperature": 24.4}, {"status": "warning", "cabinetId": "cab-sz-006", "avgHumidity": 47.6, "cabinetName": "C区1排6号", "datacenterId": "dc-003", "avgTemperature": 26.7, "datacenterName": "深圳坪山数据中心", "maxTemperature": 28.5, "minTemperature": 25}, {"status": "normal", "cabinetId": "cab-sz-007", "avgHumidity": 41.4, "cabinetName": "C区2排1号", "datacenterId": "dc-003", "avgTemperature": 25.3, "datacenterName": "深圳坪山数据中心", "maxTemperature": 27.2, "minTemperature": 25.2}, {"status": "normal", "cabinetId": "cab-sz-008", "avgHumidity": 49.2, "cabinetName": "C区2排2号", "datacenterId": "dc-003", "avgTemperature": 22.2, "datacenterName": "深圳坪山数据中心", "maxTemperature": 23.8, "minTemperature": 21.7}, {"status": "normal", "cabinetId": "cab-sz-009", "avgHumidity": 45, "cabinetName": "C区2排3号", "datacenterId": "dc-003", "avgTemperature": 20.9, "datacenterName": "深圳坪山数据中心", "maxTemperature": 21.4, "minTemperature": 19.6}, {"status": "normal", "cabinetId": "cab-sz-010", "avgHumidity": 50.1, "cabinetName": "C区2排4号", "datacenterId": "dc-003", "avgTemperature": 24.3, "datacenterName": "深圳坪山数据中心", "maxTemperature": 26, "minTemperature": 24.1}, {"status": "warning", "cabinetId": "cab-sz-011", "avgHumidity": 48, "cabinetName": "C区2排5号", "datacenterId": "dc-003", "avgTemperature": 26.4, "datacenterName": "深圳坪山数据中心", "maxTemperature": 26.8, "minTemperature": 24.6}, {"status": "normal", "cabinetId": "cab-sz-012", "avgHumidity": 35.3, "cabinetName": "C区2排6号", "datacenterId": "dc-003", "avgTemperature": 21.2, "datacenterName": "深圳坪山数据中心", "maxTemperature": 21.7, "minTemperature": 20.6}, {"status": "normal", "cabinetId": "cab-sz-013", "avgHumidity": 47.7, "cabinetName": "C区3排1号", "datacenterId": "dc-003", "avgTemperature": 24, "datacenterName": "深圳坪山数据中心", "maxTemperature": 24.8, "minTemperature": 22.2}, {"status": "normal", "cabinetId": "cab-sz-014", "avgHumidity": 43.6, "cabinetName": "C区3排2号", "datacenterId": "dc-003", "avgTemperature": 20.4, "datacenterName": "深圳坪山数据中心", "maxTemperature": 23.1, "minTemperature": 19}, {"status": "normal", "cabinetId": "cab-sz-015", "avgHumidity": 36.6, "cabinetName": "C区3排3号", "datacenterId": "dc-003", "avgTemperature": 24.9, "datacenterName": "深圳坪山数据中心", "maxTemperature": 25.7, "minTemperature": 23.1}, {"status": "normal", "cabinetId": "cab-sz-016", "avgHumidity": 54.9, "cabinetName": "C区3排4号", "datacenterId": "dc-003", "avgTemperature": 22.9, "datacenterName": "深圳坪山数据中心", "maxTemperature": 24.1, "minTemperature": 22.7}, {"status": "normal", "cabinetId": "cab-sz-017", "avgHumidity": 49.9, "cabinetName": "C区3排5号", "datacenterId": "dc-003", "avgTemperature": 24.5, "datacenterName": "深圳坪山数据中心", "maxTemperature": 26.1, "minTemperature": 24.2}, {"status": "normal", "cabinetId": "cab-sz-018", "avgHumidity": 35.9, "cabinetName": "C区3排6号", "datacenterId": "dc-003", "avgTemperature": 25.5, "datacenterName": "深圳坪山数据中心", "maxTemperature": 25.7, "minTemperature": 23.6}, {"status": "normal", "cabinetId": "cab-cd-001", "avgHumidity": 38.2, "cabinetName": "D区1排1号", "datacenterId": "dc-004", "avgTemperature": 25.1, "datacenterName": "成都天府数据中心", "maxTemperature": 26.2, "minTemperature": 23.3}, {"status": "normal", "cabinetId": "cab-cd-002", "avgHumidity": 42.5, "cabinetName": "D区1排2号", "datacenterId": "dc-004", "avgTemperature": 26, "datacenterName": "成都天府数据中心", "maxTemperature": 26.9, "minTemperature": 25.3}, {"status": "normal", "cabinetId": "cab-cd-003", "avgHumidity": 41.8, "cabinetName": "D区1排3号", "datacenterId": "dc-004", "avgTemperature": 22, "datacenterName": "成都天府数据中心", "maxTemperature": 23.9, "minTemperature": 21}, {"status": "normal", "cabinetId": "cab-cd-004", "avgHumidity": 35, "cabinetName": "D区1排4号", "datacenterId": "dc-004", "avgTemperature": 22.1, "datacenterName": "成都天府数据中心", "maxTemperature": 22.7, "minTemperature": 20.3}, {"status": "normal", "cabinetId": "cab-cd-005", "avgHumidity": 50, "cabinetName": "D区2排1号", "datacenterId": "dc-004", "avgTemperature": 24, "datacenterName": "成都天府数据中心", "maxTemperature": 26.2, "minTemperature": 22.5}, {"status": "normal", "cabinetId": "cab-cd-006", "avgHumidity": 35.1, "cabinetName": "D区2排2号", "datacenterId": "dc-004", "avgTemperature": 21.9, "datacenterName": "成都天府数据中心", "maxTemperature": 22.4, "minTemperature": 20.3}, {"status": "normal", "cabinetId": "cab-cd-007", "avgHumidity": 38.4, "cabinetName": "D区2排3号", "datacenterId": "dc-004", "avgTemperature": 23.5, "datacenterName": "成都天府数据中心", "maxTemperature": 25.1, "minTemperature": 21.7}, {"status": "normal", "cabinetId": "cab-cd-008", "avgHumidity": 46.8, "cabinetName": "D区2排4号", "datacenterId": "dc-004", "avgTemperature": 25.3, "datacenterName": "成都天府数据中心", "maxTemperature": 28, "minTemperature": 23.7}, {"status": "normal", "cabinetId": "cab-cd-009", "avgHumidity": 54.1, "cabinetName": "D区3排1号", "datacenterId": "dc-004", "avgTemperature": 20.6, "datacenterName": "成都天府数据中心", "maxTemperature": 22.9, "minTemperature": 20.2}, {"status": "normal", "cabinetId": "cab-cd-010", "avgHumidity": 51.6, "cabinetName": "D区3排2号", "datacenterId": "dc-004", "avgTemperature": 23.2, "datacenterName": "成都天府数据中心", "maxTemperature": 26.1, "minTemperature": 22.1}, {"status": "normal", "cabinetId": "cab-cd-011", "avgHumidity": 36.5, "cabinetName": "D区3排3号", "datacenterId": "dc-004", "avgTemperature": 22.9, "datacenterName": "成都天府数据中心", "maxTemperature": 24.9, "minTemperature": 21.1}, {"status": "warning", "cabinetId": "cab-cd-012", "avgHumidity": 42.7, "cabinetName": "D区3排4号", "datacenterId": "dc-004", "avgTemperature": 26.5, "datacenterName": "成都天府数据中心", "maxTemperature": 28.6, "minTemperature": 25.5}]	2026-06-23 08:38:42.107162+00
raw-cabinetSensors	cabinetSensors	[{"id": "sensor-cab-bj-001-front", "humidity": 42.2, "position": "front", "cabinetId": "cab-bj-001", "cabinetName": "A区1排1号", "lastUpdated": "2026-06-23T08:38:37.882Z", "temperature": 21.1}, {"id": "sensor-cab-bj-001-rear", "humidity": 46, "position": "rear", "cabinetId": "cab-bj-001", "cabinetName": "A区1排1号", "lastUpdated": "2026-06-23T08:38:37.882Z", "temperature": 29.2}, {"id": "sensor-cab-bj-001-top", "humidity": 45.5, "position": "top", "cabinetId": "cab-bj-001", "cabinetName": "A区1排1号", "lastUpdated": "2026-06-23T08:38:37.882Z", "temperature": 26.4}, {"id": "sensor-cab-bj-002-front", "humidity": 49.8, "position": "front", "cabinetId": "cab-bj-002", "cabinetName": "A区1排2号", "lastUpdated": "2026-06-23T08:38:37.882Z", "temperature": 21.1}, {"id": "sensor-cab-bj-002-rear", "humidity": 30.4, "position": "rear", "cabinetId": "cab-bj-002", "cabinetName": "A区1排2号", "lastUpdated": "2026-06-23T08:38:37.882Z", "temperature": 24.8}, {"id": "sensor-cab-bj-002-top", "humidity": 42.9, "position": "top", "cabinetId": "cab-bj-002", "cabinetName": "A区1排2号", "lastUpdated": "2026-06-23T08:38:37.882Z", "temperature": 23.2}, {"id": "sensor-cab-bj-003-front", "humidity": 54.8, "position": "front", "cabinetId": "cab-bj-003", "cabinetName": "A区1排3号", "lastUpdated": "2026-06-23T08:38:37.882Z", "temperature": 20}, {"id": "sensor-cab-bj-003-rear", "humidity": 45.4, "position": "rear", "cabinetId": "cab-bj-003", "cabinetName": "A区1排3号", "lastUpdated": "2026-06-23T08:38:37.882Z", "temperature": 24.5}, {"id": "sensor-cab-bj-003-top", "humidity": 40.9, "position": "top", "cabinetId": "cab-bj-003", "cabinetName": "A区1排3号", "lastUpdated": "2026-06-23T08:38:37.882Z", "temperature": 29.6}, {"id": "sensor-cab-bj-004-front", "humidity": 35.3, "position": "front", "cabinetId": "cab-bj-004", "cabinetName": "A区1排4号", "lastUpdated": "2026-06-23T08:38:37.882Z", "temperature": 26.6}, {"id": "sensor-cab-bj-004-rear", "humidity": 43.7, "position": "rear", "cabinetId": "cab-bj-004", "cabinetName": "A区1排4号", "lastUpdated": "2026-06-23T08:38:37.882Z", "temperature": 30.9}, {"id": "sensor-cab-bj-004-top", "humidity": 50.3, "position": "top", "cabinetId": "cab-bj-004", "cabinetName": "A区1排4号", "lastUpdated": "2026-06-23T08:38:37.882Z", "temperature": 24}, {"id": "sensor-cab-bj-005-front", "humidity": 38.8, "position": "front", "cabinetId": "cab-bj-005", "cabinetName": "A区1排5号", "lastUpdated": "2026-06-23T08:38:37.882Z", "temperature": 26.2}, {"id": "sensor-cab-bj-005-rear", "humidity": 44.2, "position": "rear", "cabinetId": "cab-bj-005", "cabinetName": "A区1排5号", "lastUpdated": "2026-06-23T08:38:37.882Z", "temperature": 24.3}, {"id": "sensor-cab-bj-005-top", "humidity": 44.8, "position": "top", "cabinetId": "cab-bj-005", "cabinetName": "A区1排5号", "lastUpdated": "2026-06-23T08:38:37.882Z", "temperature": 28}, {"id": "sensor-cab-bj-006-front", "humidity": 51, "position": "front", "cabinetId": "cab-bj-006", "cabinetName": "A区2排1号", "lastUpdated": "2026-06-23T08:38:37.882Z", "temperature": 26.2}, {"id": "sensor-cab-bj-006-rear", "humidity": 43.3, "position": "rear", "cabinetId": "cab-bj-006", "cabinetName": "A区2排1号", "lastUpdated": "2026-06-23T08:38:37.882Z", "temperature": 26.8}, {"id": "sensor-cab-bj-006-top", "humidity": 35.7, "position": "top", "cabinetId": "cab-bj-006", "cabinetName": "A区2排1号", "lastUpdated": "2026-06-23T08:38:37.882Z", "temperature": 27.8}, {"id": "sensor-cab-bj-007-front", "humidity": 54.7, "position": "front", "cabinetId": "cab-bj-007", "cabinetName": "A区2排2号", "lastUpdated": "2026-06-23T08:38:37.882Z", "temperature": 20.7}, {"id": "sensor-cab-bj-007-rear", "humidity": 41.2, "position": "rear", "cabinetId": "cab-bj-007", "cabinetName": "A区2排2号", "lastUpdated": "2026-06-23T08:38:37.882Z", "temperature": 29.9}, {"id": "sensor-cab-bj-007-top", "humidity": 36, "position": "top", "cabinetId": "cab-bj-007", "cabinetName": "A区2排2号", "lastUpdated": "2026-06-23T08:38:37.882Z", "temperature": 28.9}, {"id": "sensor-cab-bj-008-front", "humidity": 35.2, "position": "front", "cabinetId": "cab-bj-008", "cabinetName": "A区2排3号", "lastUpdated": "2026-06-23T08:38:37.882Z", "temperature": 20.4}, {"id": "sensor-cab-bj-008-rear", "humidity": 40.6, "position": "rear", "cabinetId": "cab-bj-008", "cabinetName": "A区2排3号", "lastUpdated": "2026-06-23T08:38:37.882Z", "temperature": 29.7}, {"id": "sensor-cab-bj-008-top", "humidity": 32.6, "position": "top", "cabinetId": "cab-bj-008", "cabinetName": "A区2排3号", "lastUpdated": "2026-06-23T08:38:37.882Z", "temperature": 23.9}, {"id": "sensor-cab-bj-009-front", "humidity": 39.2, "position": "front", "cabinetId": "cab-bj-009", "cabinetName": "A区2排4号", "lastUpdated": "2026-06-23T08:38:37.882Z", "temperature": 19.8}, {"id": "sensor-cab-bj-009-rear", "humidity": 44.4, "position": "rear", "cabinetId": "cab-bj-009", "cabinetName": "A区2排4号", "lastUpdated": "2026-06-23T08:38:37.882Z", "temperature": 29.5}, {"id": "sensor-cab-bj-009-top", "humidity": 37.6, "position": "top", "cabinetId": "cab-bj-009", "cabinetName": "A区2排4号", "lastUpdated": "2026-06-23T08:38:37.882Z", "temperature": 27.7}, {"id": "sensor-cab-bj-010-front", "humidity": 48, "position": "front", "cabinetId": "cab-bj-010", "cabinetName": "A区2排5号", "lastUpdated": "2026-06-23T08:38:37.882Z", "temperature": 21.7}, {"id": "sensor-cab-bj-010-rear", "humidity": 41.2, "position": "rear", "cabinetId": "cab-bj-010", "cabinetName": "A区2排5号", "lastUpdated": "2026-06-23T08:38:37.882Z", "temperature": 26.3}, {"id": "sensor-cab-bj-010-top", "humidity": 34.7, "position": "top", "cabinetId": "cab-bj-010", "cabinetName": "A区2排5号", "lastUpdated": "2026-06-23T08:38:37.882Z", "temperature": 25.2}, {"id": "sensor-cab-bj-011-front", "humidity": 49.1, "position": "front", "cabinetId": "cab-bj-011", "cabinetName": "A区3排1号", "lastUpdated": "2026-06-23T08:38:37.882Z", "temperature": 25}, {"id": "sensor-cab-bj-011-rear", "humidity": 41.1, "position": "rear", "cabinetId": "cab-bj-011", "cabinetName": "A区3排1号", "lastUpdated": "2026-06-23T08:38:37.882Z", "temperature": 28.8}, {"id": "sensor-cab-bj-011-top", "humidity": 45.1, "position": "top", "cabinetId": "cab-bj-011", "cabinetName": "A区3排1号", "lastUpdated": "2026-06-23T08:38:37.882Z", "temperature": 24.3}, {"id": "sensor-cab-bj-012-front", "humidity": 35.7, "position": "front", "cabinetId": "cab-bj-012", "cabinetName": "A区3排2号", "lastUpdated": "2026-06-23T08:38:37.882Z", "temperature": 21.8}, {"id": "sensor-cab-bj-012-rear", "humidity": 32, "position": "rear", "cabinetId": "cab-bj-012", "cabinetName": "A区3排2号", "lastUpdated": "2026-06-23T08:38:37.882Z", "temperature": 25.7}, {"id": "sensor-cab-bj-012-top", "humidity": 32.8, "position": "top", "cabinetId": "cab-bj-012", "cabinetName": "A区3排2号", "lastUpdated": "2026-06-23T08:38:37.882Z", "temperature": 23.5}, {"id": "sensor-cab-bj-013-front", "humidity": 37.2, "position": "front", "cabinetId": "cab-bj-013", "cabinetName": "A区3排3号", "lastUpdated": "2026-06-23T08:38:37.882Z", "temperature": 26.1}, {"id": "sensor-cab-bj-013-rear", "humidity": 38.2, "position": "rear", "cabinetId": "cab-bj-013", "cabinetName": "A区3排3号", "lastUpdated": "2026-06-23T08:38:37.882Z", "temperature": 27.9}, {"id": "sensor-cab-bj-013-top", "humidity": 36.2, "position": "top", "cabinetId": "cab-bj-013", "cabinetName": "A区3排3号", "lastUpdated": "2026-06-23T08:38:37.882Z", "temperature": 26.5}, {"id": "sensor-cab-bj-014-front", "humidity": 47.7, "position": "front", "cabinetId": "cab-bj-014", "cabinetName": "A区3排4号", "lastUpdated": "2026-06-23T08:38:37.882Z", "temperature": 22.7}, {"id": "sensor-cab-bj-014-rear", "humidity": 47.4, "position": "rear", "cabinetId": "cab-bj-014", "cabinetName": "A区3排4号", "lastUpdated": "2026-06-23T08:38:37.882Z", "temperature": 28.5}, {"id": "sensor-cab-bj-014-top", "humidity": 43.8, "position": "top", "cabinetId": "cab-bj-014", "cabinetName": "A区3排4号", "lastUpdated": "2026-06-23T08:38:37.882Z", "temperature": 27.8}, {"id": "sensor-cab-bj-015-front", "humidity": 43.1, "position": "front", "cabinetId": "cab-bj-015", "cabinetName": "A区3排5号", "lastUpdated": "2026-06-23T08:38:37.882Z", "temperature": 19}, {"id": "sensor-cab-bj-015-rear", "humidity": 35.4, "position": "rear", "cabinetId": "cab-bj-015", "cabinetName": "A区3排5号", "lastUpdated": "2026-06-23T08:38:37.882Z", "temperature": 29.1}, {"id": "sensor-cab-bj-015-top", "humidity": 32.9, "position": "top", "cabinetId": "cab-bj-015", "cabinetName": "A区3排5号", "lastUpdated": "2026-06-23T08:38:37.882Z", "temperature": 29.2}, {"id": "sensor-cab-bj-016-front", "humidity": 37.4, "position": "front", "cabinetId": "cab-bj-016", "cabinetName": "A区4排1号", "lastUpdated": "2026-06-23T08:38:37.882Z", "temperature": 23.2}, {"id": "sensor-cab-bj-016-rear", "humidity": 48.8, "position": "rear", "cabinetId": "cab-bj-016", "cabinetName": "A区4排1号", "lastUpdated": "2026-06-23T08:38:37.882Z", "temperature": 30}, {"id": "sensor-cab-bj-016-top", "humidity": 35.9, "position": "top", "cabinetId": "cab-bj-016", "cabinetName": "A区4排1号", "lastUpdated": "2026-06-23T08:38:37.882Z", "temperature": 22.9}, {"id": "sensor-cab-bj-017-front", "humidity": 51, "position": "front", "cabinetId": "cab-bj-017", "cabinetName": "A区4排2号", "lastUpdated": "2026-06-23T08:38:37.882Z", "temperature": 25.5}, {"id": "sensor-cab-bj-017-rear", "humidity": 49.9, "position": "rear", "cabinetId": "cab-bj-017", "cabinetName": "A区4排2号", "lastUpdated": "2026-06-23T08:38:37.882Z", "temperature": 29.2}, {"id": "sensor-cab-bj-017-top", "humidity": 32.3, "position": "top", "cabinetId": "cab-bj-017", "cabinetName": "A区4排2号", "lastUpdated": "2026-06-23T08:38:37.882Z", "temperature": 22.6}, {"id": "sensor-cab-bj-018-front", "humidity": 50.7, "position": "front", "cabinetId": "cab-bj-018", "cabinetName": "A区4排3号", "lastUpdated": "2026-06-23T08:38:37.882Z", "temperature": 25.4}, {"id": "sensor-cab-bj-018-rear", "humidity": 31, "position": "rear", "cabinetId": "cab-bj-018", "cabinetName": "A区4排3号", "lastUpdated": "2026-06-23T08:38:37.882Z", "temperature": 26.6}, {"id": "sensor-cab-bj-018-top", "humidity": 38.2, "position": "top", "cabinetId": "cab-bj-018", "cabinetName": "A区4排3号", "lastUpdated": "2026-06-23T08:38:37.882Z", "temperature": 24.9}, {"id": "sensor-cab-bj-019-front", "humidity": 38.2, "position": "front", "cabinetId": "cab-bj-019", "cabinetName": "A区4排4号", "lastUpdated": "2026-06-23T08:38:37.882Z", "temperature": 25.3}, {"id": "sensor-cab-bj-019-rear", "humidity": 34.7, "position": "rear", "cabinetId": "cab-bj-019", "cabinetName": "A区4排4号", "lastUpdated": "2026-06-23T08:38:37.882Z", "temperature": 24.9}, {"id": "sensor-cab-bj-019-top", "humidity": 50.3, "position": "top", "cabinetId": "cab-bj-019", "cabinetName": "A区4排4号", "lastUpdated": "2026-06-23T08:38:37.882Z", "temperature": 26.2}, {"id": "sensor-cab-bj-020-front", "humidity": 46.2, "position": "front", "cabinetId": "cab-bj-020", "cabinetName": "A区4排5号", "lastUpdated": "2026-06-23T08:38:37.882Z", "temperature": 21.2}, {"id": "sensor-cab-bj-020-rear", "humidity": 38.5, "position": "rear", "cabinetId": "cab-bj-020", "cabinetName": "A区4排5号", "lastUpdated": "2026-06-23T08:38:37.882Z", "temperature": 30.3}, {"id": "sensor-cab-bj-020-top", "humidity": 47.7, "position": "top", "cabinetId": "cab-bj-020", "cabinetName": "A区4排5号", "lastUpdated": "2026-06-23T08:38:37.882Z", "temperature": 22.6}, {"id": "sensor-cab-sh-001-front", "humidity": 39.6, "position": "front", "cabinetId": "cab-sh-001", "cabinetName": "B区1排1号", "lastUpdated": "2026-06-23T08:38:37.882Z", "temperature": 24.2}, {"id": "sensor-cab-sh-001-rear", "humidity": 41.4, "position": "rear", "cabinetId": "cab-sh-001", "cabinetName": "B区1排1号", "lastUpdated": "2026-06-23T08:38:37.882Z", "temperature": 31.6}, {"id": "sensor-cab-sh-001-top", "humidity": 35.2, "position": "top", "cabinetId": "cab-sh-001", "cabinetName": "B区1排1号", "lastUpdated": "2026-06-23T08:38:37.882Z", "temperature": 28.7}, {"id": "sensor-cab-sh-002-front", "humidity": 50.9, "position": "front", "cabinetId": "cab-sh-002", "cabinetName": "B区1排2号", "lastUpdated": "2026-06-23T08:38:37.882Z", "temperature": 26.9}, {"id": "sensor-cab-sh-002-rear", "humidity": 37.6, "position": "rear", "cabinetId": "cab-sh-002", "cabinetName": "B区1排2号", "lastUpdated": "2026-06-23T08:38:37.882Z", "temperature": 31.2}, {"id": "sensor-cab-sh-002-top", "humidity": 45.8, "position": "top", "cabinetId": "cab-sh-002", "cabinetName": "B区1排2号", "lastUpdated": "2026-06-23T08:38:37.882Z", "temperature": 25.9}, {"id": "sensor-cab-sh-003-front", "humidity": 42, "position": "front", "cabinetId": "cab-sh-003", "cabinetName": "B区1排3号", "lastUpdated": "2026-06-23T08:38:37.882Z", "temperature": 20.3}, {"id": "sensor-cab-sh-003-rear", "humidity": 41.9, "position": "rear", "cabinetId": "cab-sh-003", "cabinetName": "B区1排3号", "lastUpdated": "2026-06-23T08:38:37.882Z", "temperature": 30.9}, {"id": "sensor-cab-sh-003-top", "humidity": 42.4, "position": "top", "cabinetId": "cab-sh-003", "cabinetName": "B区1排3号", "lastUpdated": "2026-06-23T08:38:37.882Z", "temperature": 22.6}, {"id": "sensor-cab-sh-004-front", "humidity": 53.7, "position": "front", "cabinetId": "cab-sh-004", "cabinetName": "B区1排4号", "lastUpdated": "2026-06-23T08:38:37.882Z", "temperature": 25}, {"id": "sensor-cab-sh-004-rear", "humidity": 38.6, "position": "rear", "cabinetId": "cab-sh-004", "cabinetName": "B区1排4号", "lastUpdated": "2026-06-23T08:38:37.882Z", "temperature": 31.1}, {"id": "sensor-cab-sh-004-top", "humidity": 37.8, "position": "top", "cabinetId": "cab-sh-004", "cabinetName": "B区1排4号", "lastUpdated": "2026-06-23T08:38:37.882Z", "temperature": 24.6}, {"id": "sensor-cab-sh-005-front", "humidity": 47.4, "position": "front", "cabinetId": "cab-sh-005", "cabinetName": "B区1排5号", "lastUpdated": "2026-06-23T08:38:37.882Z", "temperature": 21.7}, {"id": "sensor-cab-sh-005-rear", "humidity": 42.9, "position": "rear", "cabinetId": "cab-sh-005", "cabinetName": "B区1排5号", "lastUpdated": "2026-06-23T08:38:37.882Z", "temperature": 29.8}, {"id": "sensor-cab-sh-005-top", "humidity": 38.8, "position": "top", "cabinetId": "cab-sh-005", "cabinetName": "B区1排5号", "lastUpdated": "2026-06-23T08:38:37.882Z", "temperature": 24.3}, {"id": "sensor-cab-sh-006-front", "humidity": 42.4, "position": "front", "cabinetId": "cab-sh-006", "cabinetName": "B区2排1号", "lastUpdated": "2026-06-23T08:38:37.882Z", "temperature": 21.8}, {"id": "sensor-cab-sh-006-rear", "humidity": 48.8, "position": "rear", "cabinetId": "cab-sh-006", "cabinetName": "B区2排1号", "lastUpdated": "2026-06-23T08:38:37.882Z", "temperature": 29}, {"id": "sensor-cab-sh-006-top", "humidity": 36.1, "position": "top", "cabinetId": "cab-sh-006", "cabinetName": "B区2排1号", "lastUpdated": "2026-06-23T08:38:37.882Z", "temperature": 24.9}, {"id": "sensor-cab-sh-007-front", "humidity": 52.5, "position": "front", "cabinetId": "cab-sh-007", "cabinetName": "B区2排2号", "lastUpdated": "2026-06-23T08:38:37.882Z", "temperature": 25.3}, {"id": "sensor-cab-sh-007-rear", "humidity": 47.2, "position": "rear", "cabinetId": "cab-sh-007", "cabinetName": "B区2排2号", "lastUpdated": "2026-06-23T08:38:37.882Z", "temperature": 29.9}, {"id": "sensor-cab-sh-007-top", "humidity": 48.2, "position": "top", "cabinetId": "cab-sh-007", "cabinetName": "B区2排2号", "lastUpdated": "2026-06-23T08:38:37.882Z", "temperature": 23.7}, {"id": "sensor-cab-sh-008-front", "humidity": 37.8, "position": "front", "cabinetId": "cab-sh-008", "cabinetName": "B区2排3号", "lastUpdated": "2026-06-23T08:38:37.882Z", "temperature": 22.2}, {"id": "sensor-cab-sh-008-rear", "humidity": 32.7, "position": "rear", "cabinetId": "cab-sh-008", "cabinetName": "B区2排3号", "lastUpdated": "2026-06-23T08:38:37.882Z", "temperature": 26.4}, {"id": "sensor-cab-sh-008-top", "humidity": 47.5, "position": "top", "cabinetId": "cab-sh-008", "cabinetName": "B区2排3号", "lastUpdated": "2026-06-23T08:38:37.882Z", "temperature": 27.7}, {"id": "sensor-cab-sh-009-front", "humidity": 41.5, "position": "front", "cabinetId": "cab-sh-009", "cabinetName": "B区2排4号", "lastUpdated": "2026-06-23T08:38:37.882Z", "temperature": 22.2}, {"id": "sensor-cab-sh-009-rear", "humidity": 35.1, "position": "rear", "cabinetId": "cab-sh-009", "cabinetName": "B区2排4号", "lastUpdated": "2026-06-23T08:38:37.882Z", "temperature": 26.3}, {"id": "sensor-cab-sh-009-top", "humidity": 48.9, "position": "top", "cabinetId": "cab-sh-009", "cabinetName": "B区2排4号", "lastUpdated": "2026-06-23T08:38:37.882Z", "temperature": 28.1}, {"id": "sensor-cab-sh-010-front", "humidity": 48.2, "position": "front", "cabinetId": "cab-sh-010", "cabinetName": "B区2排5号", "lastUpdated": "2026-06-23T08:38:37.882Z", "temperature": 23}, {"id": "sensor-cab-sh-010-rear", "humidity": 34.2, "position": "rear", "cabinetId": "cab-sh-010", "cabinetName": "B区2排5号", "lastUpdated": "2026-06-23T08:38:37.882Z", "temperature": 25.1}, {"id": "sensor-cab-sh-010-top", "humidity": 51.7, "position": "top", "cabinetId": "cab-sh-010", "cabinetName": "B区2排5号", "lastUpdated": "2026-06-23T08:38:37.882Z", "temperature": 24.6}, {"id": "sensor-cab-sh-011-front", "humidity": 37.3, "position": "front", "cabinetId": "cab-sh-011", "cabinetName": "B区3排1号", "lastUpdated": "2026-06-23T08:38:37.882Z", "temperature": 21.1}, {"id": "sensor-cab-sh-011-rear", "humidity": 38.9, "position": "rear", "cabinetId": "cab-sh-011", "cabinetName": "B区3排1号", "lastUpdated": "2026-06-23T08:38:37.882Z", "temperature": 24.5}, {"id": "sensor-cab-sh-011-top", "humidity": 43.8, "position": "top", "cabinetId": "cab-sh-011", "cabinetName": "B区3排1号", "lastUpdated": "2026-06-23T08:38:37.882Z", "temperature": 23.2}, {"id": "sensor-cab-sh-012-front", "humidity": 36.3, "position": "front", "cabinetId": "cab-sh-012", "cabinetName": "B区3排2号", "lastUpdated": "2026-06-23T08:38:37.882Z", "temperature": 26}, {"id": "sensor-cab-sh-012-rear", "humidity": 46.5, "position": "rear", "cabinetId": "cab-sh-012", "cabinetName": "B区3排2号", "lastUpdated": "2026-06-23T08:38:37.882Z", "temperature": 31.4}, {"id": "sensor-cab-sh-012-top", "humidity": 37.3, "position": "top", "cabinetId": "cab-sh-012", "cabinetName": "B区3排2号", "lastUpdated": "2026-06-23T08:38:37.882Z", "temperature": 24.3}, {"id": "sensor-cab-sh-013-front", "humidity": 42.4, "position": "front", "cabinetId": "cab-sh-013", "cabinetName": "B区3排3号", "lastUpdated": "2026-06-23T08:38:37.882Z", "temperature": 20.9}, {"id": "sensor-cab-sh-013-rear", "humidity": 39.9, "position": "rear", "cabinetId": "cab-sh-013", "cabinetName": "B区3排3号", "lastUpdated": "2026-06-23T08:38:37.882Z", "temperature": 26.4}, {"id": "sensor-cab-sh-013-top", "humidity": 41.2, "position": "top", "cabinetId": "cab-sh-013", "cabinetName": "B区3排3号", "lastUpdated": "2026-06-23T08:38:37.882Z", "temperature": 29.7}, {"id": "sensor-cab-sh-014-front", "humidity": 43.1, "position": "front", "cabinetId": "cab-sh-014", "cabinetName": "B区3排4号", "lastUpdated": "2026-06-23T08:38:37.882Z", "temperature": 23.6}, {"id": "sensor-cab-sh-014-rear", "humidity": 49.5, "position": "rear", "cabinetId": "cab-sh-014", "cabinetName": "B区3排4号", "lastUpdated": "2026-06-23T08:38:37.882Z", "temperature": 31.2}, {"id": "sensor-cab-sh-014-top", "humidity": 48.2, "position": "top", "cabinetId": "cab-sh-014", "cabinetName": "B区3排4号", "lastUpdated": "2026-06-23T08:38:37.882Z", "temperature": 26.9}, {"id": "sensor-cab-sh-015-front", "humidity": 38.8, "position": "front", "cabinetId": "cab-sh-015", "cabinetName": "B区3排5号", "lastUpdated": "2026-06-23T08:38:37.882Z", "temperature": 21.5}, {"id": "sensor-cab-sh-015-rear", "humidity": 38.7, "position": "rear", "cabinetId": "cab-sh-015", "cabinetName": "B区3排5号", "lastUpdated": "2026-06-23T08:38:37.882Z", "temperature": 29.3}, {"id": "sensor-cab-sh-015-top", "humidity": 51.5, "position": "top", "cabinetId": "cab-sh-015", "cabinetName": "B区3排5号", "lastUpdated": "2026-06-23T08:38:37.882Z", "temperature": 25.9}, {"id": "sensor-cab-sz-001-front", "humidity": 40.6, "position": "front", "cabinetId": "cab-sz-001", "cabinetName": "C区1排1号", "lastUpdated": "2026-06-23T08:38:37.882Z", "temperature": 24.9}, {"id": "sensor-cab-sz-001-rear", "humidity": 49.6, "position": "rear", "cabinetId": "cab-sz-001", "cabinetName": "C区1排1号", "lastUpdated": "2026-06-23T08:38:37.882Z", "temperature": 25.5}, {"id": "sensor-cab-sz-001-top", "humidity": 38, "position": "top", "cabinetId": "cab-sz-001", "cabinetName": "C区1排1号", "lastUpdated": "2026-06-23T08:38:37.882Z", "temperature": 26.6}, {"id": "sensor-cab-sz-002-front", "humidity": 37.7, "position": "front", "cabinetId": "cab-sz-002", "cabinetName": "C区1排2号", "lastUpdated": "2026-06-23T08:38:37.882Z", "temperature": 26.3}, {"id": "sensor-cab-sz-002-rear", "humidity": 47.3, "position": "rear", "cabinetId": "cab-sz-002", "cabinetName": "C区1排2号", "lastUpdated": "2026-06-23T08:38:37.882Z", "temperature": 27.7}, {"id": "sensor-cab-sz-002-top", "humidity": 37.9, "position": "top", "cabinetId": "cab-sz-002", "cabinetName": "C区1排2号", "lastUpdated": "2026-06-23T08:38:37.882Z", "temperature": 23.6}, {"id": "sensor-cab-sz-003-front", "humidity": 49.6, "position": "front", "cabinetId": "cab-sz-003", "cabinetName": "C区1排3号", "lastUpdated": "2026-06-23T08:38:37.882Z", "temperature": 21.7}, {"id": "sensor-cab-sz-003-rear", "humidity": 44.8, "position": "rear", "cabinetId": "cab-sz-003", "cabinetName": "C区1排3号", "lastUpdated": "2026-06-23T08:38:37.882Z", "temperature": 27.9}, {"id": "sensor-cab-sz-003-top", "humidity": 44.9, "position": "top", "cabinetId": "cab-sz-003", "cabinetName": "C区1排3号", "lastUpdated": "2026-06-23T08:38:37.882Z", "temperature": 22.2}, {"id": "sensor-cab-sz-004-front", "humidity": 50.7, "position": "front", "cabinetId": "cab-sz-004", "cabinetName": "C区1排4号", "lastUpdated": "2026-06-23T08:38:37.882Z", "temperature": 21.5}, {"id": "sensor-cab-sz-004-rear", "humidity": 32.2, "position": "rear", "cabinetId": "cab-sz-004", "cabinetName": "C区1排4号", "lastUpdated": "2026-06-23T08:38:37.882Z", "temperature": 29.6}, {"id": "sensor-cab-sz-004-top", "humidity": 39.7, "position": "top", "cabinetId": "cab-sz-004", "cabinetName": "C区1排4号", "lastUpdated": "2026-06-23T08:38:37.882Z", "temperature": 27.4}, {"id": "sensor-cab-sz-005-front", "humidity": 50.3, "position": "front", "cabinetId": "cab-sz-005", "cabinetName": "C区1排5号", "lastUpdated": "2026-06-23T08:38:37.882Z", "temperature": 24}, {"id": "sensor-cab-sz-005-rear", "humidity": 44.4, "position": "rear", "cabinetId": "cab-sz-005", "cabinetName": "C区1排5号", "lastUpdated": "2026-06-23T08:38:37.882Z", "temperature": 30.9}, {"id": "sensor-cab-sz-005-top", "humidity": 34.5, "position": "top", "cabinetId": "cab-sz-005", "cabinetName": "C区1排5号", "lastUpdated": "2026-06-23T08:38:37.882Z", "temperature": 25.5}, {"id": "sensor-cab-sz-006-front", "humidity": 52.5, "position": "front", "cabinetId": "cab-sz-006", "cabinetName": "C区1排6号", "lastUpdated": "2026-06-23T08:38:37.882Z", "temperature": 20.2}, {"id": "sensor-cab-sz-006-rear", "humidity": 41, "position": "rear", "cabinetId": "cab-sz-006", "cabinetName": "C区1排6号", "lastUpdated": "2026-06-23T08:38:37.882Z", "temperature": 24.2}, {"id": "sensor-cab-sz-006-top", "humidity": 47.9, "position": "top", "cabinetId": "cab-sz-006", "cabinetName": "C区1排6号", "lastUpdated": "2026-06-23T08:38:37.882Z", "temperature": 25.7}, {"id": "sensor-cab-sz-007-front", "humidity": 40.9, "position": "front", "cabinetId": "cab-sz-007", "cabinetName": "C区2排1号", "lastUpdated": "2026-06-23T08:38:37.882Z", "temperature": 24.3}, {"id": "sensor-cab-sz-007-rear", "humidity": 32.1, "position": "rear", "cabinetId": "cab-sz-007", "cabinetName": "C区2排1号", "lastUpdated": "2026-06-23T08:38:37.882Z", "temperature": 29.1}, {"id": "sensor-cab-sz-007-top", "humidity": 40.6, "position": "top", "cabinetId": "cab-sz-007", "cabinetName": "C区2排1号", "lastUpdated": "2026-06-23T08:38:37.882Z", "temperature": 27.9}, {"id": "sensor-cab-sz-008-front", "humidity": 54.5, "position": "front", "cabinetId": "cab-sz-008", "cabinetName": "C区2排2号", "lastUpdated": "2026-06-23T08:38:37.882Z", "temperature": 24.2}, {"id": "sensor-cab-sz-008-rear", "humidity": 40.5, "position": "rear", "cabinetId": "cab-sz-008", "cabinetName": "C区2排2号", "lastUpdated": "2026-06-23T08:38:37.882Z", "temperature": 32}, {"id": "sensor-cab-sz-008-top", "humidity": 34.6, "position": "top", "cabinetId": "cab-sz-008", "cabinetName": "C区2排2号", "lastUpdated": "2026-06-23T08:38:37.882Z", "temperature": 24.2}, {"id": "sensor-cab-sz-009-front", "humidity": 45.6, "position": "front", "cabinetId": "cab-sz-009", "cabinetName": "C区2排3号", "lastUpdated": "2026-06-23T08:38:37.882Z", "temperature": 21.3}, {"id": "sensor-cab-sz-009-rear", "humidity": 36.2, "position": "rear", "cabinetId": "cab-sz-009", "cabinetName": "C区2排3号", "lastUpdated": "2026-06-23T08:38:37.882Z", "temperature": 28.8}, {"id": "sensor-cab-sz-009-top", "humidity": 33.1, "position": "top", "cabinetId": "cab-sz-009", "cabinetName": "C区2排3号", "lastUpdated": "2026-06-23T08:38:37.882Z", "temperature": 24.6}, {"id": "sensor-cab-sz-010-front", "humidity": 52.8, "position": "front", "cabinetId": "cab-sz-010", "cabinetName": "C区2排4号", "lastUpdated": "2026-06-23T08:38:37.882Z", "temperature": 20}, {"id": "sensor-cab-sz-010-rear", "humidity": 36.3, "position": "rear", "cabinetId": "cab-sz-010", "cabinetName": "C区2排4号", "lastUpdated": "2026-06-23T08:38:37.882Z", "temperature": 24.1}, {"id": "sensor-cab-sz-010-top", "humidity": 44.1, "position": "top", "cabinetId": "cab-sz-010", "cabinetName": "C区2排4号", "lastUpdated": "2026-06-23T08:38:37.882Z", "temperature": 28.2}, {"id": "sensor-cab-sz-011-front", "humidity": 41.2, "position": "front", "cabinetId": "cab-sz-011", "cabinetName": "C区2排5号", "lastUpdated": "2026-06-23T08:38:37.882Z", "temperature": 23.2}, {"id": "sensor-cab-sz-011-rear", "humidity": 37.9, "position": "rear", "cabinetId": "cab-sz-011", "cabinetName": "C区2排5号", "lastUpdated": "2026-06-23T08:38:37.882Z", "temperature": 24.5}, {"id": "sensor-cab-sz-011-top", "humidity": 33.4, "position": "top", "cabinetId": "cab-sz-011", "cabinetName": "C区2排5号", "lastUpdated": "2026-06-23T08:38:37.882Z", "temperature": 25.7}, {"id": "sensor-cab-sz-012-front", "humidity": 39.3, "position": "front", "cabinetId": "cab-sz-012", "cabinetName": "C区2排6号", "lastUpdated": "2026-06-23T08:38:37.882Z", "temperature": 20.6}, {"id": "sensor-cab-sz-012-rear", "humidity": 34.8, "position": "rear", "cabinetId": "cab-sz-012", "cabinetName": "C区2排6号", "lastUpdated": "2026-06-23T08:38:37.882Z", "temperature": 30.8}, {"id": "sensor-cab-sz-012-top", "humidity": 36, "position": "top", "cabinetId": "cab-sz-012", "cabinetName": "C区2排6号", "lastUpdated": "2026-06-23T08:38:37.882Z", "temperature": 24.8}, {"id": "sensor-cab-sz-013-front", "humidity": 40.4, "position": "front", "cabinetId": "cab-sz-013", "cabinetName": "C区3排1号", "lastUpdated": "2026-06-23T08:38:37.882Z", "temperature": 25.5}, {"id": "sensor-cab-sz-013-rear", "humidity": 43.7, "position": "rear", "cabinetId": "cab-sz-013", "cabinetName": "C区3排1号", "lastUpdated": "2026-06-23T08:38:37.882Z", "temperature": 28.8}, {"id": "sensor-cab-sz-013-top", "humidity": 51.4, "position": "top", "cabinetId": "cab-sz-013", "cabinetName": "C区3排1号", "lastUpdated": "2026-06-23T08:38:37.882Z", "temperature": 25.7}, {"id": "sensor-cab-sz-014-front", "humidity": 47.7, "position": "front", "cabinetId": "cab-sz-014", "cabinetName": "C区3排2号", "lastUpdated": "2026-06-23T08:38:37.882Z", "temperature": 22.2}, {"id": "sensor-cab-sz-014-rear", "humidity": 42.7, "position": "rear", "cabinetId": "cab-sz-014", "cabinetName": "C区3排2号", "lastUpdated": "2026-06-23T08:38:37.882Z", "temperature": 29.3}, {"id": "sensor-cab-sz-014-top", "humidity": 36.4, "position": "top", "cabinetId": "cab-sz-014", "cabinetName": "C区3排2号", "lastUpdated": "2026-06-23T08:38:37.882Z", "temperature": 23.2}, {"id": "sensor-cab-sz-015-front", "humidity": 35.5, "position": "front", "cabinetId": "cab-sz-015", "cabinetName": "C区3排3号", "lastUpdated": "2026-06-23T08:38:37.882Z", "temperature": 24.2}, {"id": "sensor-cab-sz-015-rear", "humidity": 45.4, "position": "rear", "cabinetId": "cab-sz-015", "cabinetName": "C区3排3号", "lastUpdated": "2026-06-23T08:38:37.882Z", "temperature": 28}, {"id": "sensor-cab-sz-015-top", "humidity": 49.2, "position": "top", "cabinetId": "cab-sz-015", "cabinetName": "C区3排3号", "lastUpdated": "2026-06-23T08:38:37.882Z", "temperature": 22.4}, {"id": "sensor-cab-sz-016-front", "humidity": 52.5, "position": "front", "cabinetId": "cab-sz-016", "cabinetName": "C区3排4号", "lastUpdated": "2026-06-23T08:38:37.882Z", "temperature": 21.7}, {"id": "sensor-cab-sz-016-rear", "humidity": 33.5, "position": "rear", "cabinetId": "cab-sz-016", "cabinetName": "C区3排4号", "lastUpdated": "2026-06-23T08:38:37.882Z", "temperature": 27.7}, {"id": "sensor-cab-sz-016-top", "humidity": 48.2, "position": "top", "cabinetId": "cab-sz-016", "cabinetName": "C区3排4号", "lastUpdated": "2026-06-23T08:38:37.882Z", "temperature": 26.2}, {"id": "sensor-cab-sz-017-front", "humidity": 41.4, "position": "front", "cabinetId": "cab-sz-017", "cabinetName": "C区3排5号", "lastUpdated": "2026-06-23T08:38:37.882Z", "temperature": 25.8}, {"id": "sensor-cab-sz-017-rear", "humidity": 32.6, "position": "rear", "cabinetId": "cab-sz-017", "cabinetName": "C区3排5号", "lastUpdated": "2026-06-23T08:38:37.882Z", "temperature": 25.8}, {"id": "sensor-cab-sz-017-top", "humidity": 40.5, "position": "top", "cabinetId": "cab-sz-017", "cabinetName": "C区3排5号", "lastUpdated": "2026-06-23T08:38:37.882Z", "temperature": 26.8}, {"id": "sensor-cab-sz-018-front", "humidity": 36.8, "position": "front", "cabinetId": "cab-sz-018", "cabinetName": "C区3排6号", "lastUpdated": "2026-06-23T08:38:37.882Z", "temperature": 20.7}, {"id": "sensor-cab-sz-018-rear", "humidity": 49.1, "position": "rear", "cabinetId": "cab-sz-018", "cabinetName": "C区3排6号", "lastUpdated": "2026-06-23T08:38:37.882Z", "temperature": 25.8}, {"id": "sensor-cab-sz-018-top", "humidity": 47.7, "position": "top", "cabinetId": "cab-sz-018", "cabinetName": "C区3排6号", "lastUpdated": "2026-06-23T08:38:37.882Z", "temperature": 27.6}, {"id": "sensor-cab-cd-001-front", "humidity": 51.2, "position": "front", "cabinetId": "cab-cd-001", "cabinetName": "D区1排1号", "lastUpdated": "2026-06-23T08:38:37.882Z", "temperature": 22}, {"id": "sensor-cab-cd-001-rear", "humidity": 34.3, "position": "rear", "cabinetId": "cab-cd-001", "cabinetName": "D区1排1号", "lastUpdated": "2026-06-23T08:38:37.882Z", "temperature": 29.8}, {"id": "sensor-cab-cd-001-top", "humidity": 38.2, "position": "top", "cabinetId": "cab-cd-001", "cabinetName": "D区1排1号", "lastUpdated": "2026-06-23T08:38:37.882Z", "temperature": 23.1}, {"id": "sensor-cab-cd-002-front", "humidity": 41.1, "position": "front", "cabinetId": "cab-cd-002", "cabinetName": "D区1排2号", "lastUpdated": "2026-06-23T08:38:37.882Z", "temperature": 24.5}, {"id": "sensor-cab-cd-002-rear", "humidity": 46.6, "position": "rear", "cabinetId": "cab-cd-002", "cabinetName": "D区1排2号", "lastUpdated": "2026-06-23T08:38:37.882Z", "temperature": 30.7}, {"id": "sensor-cab-cd-002-top", "humidity": 51.2, "position": "top", "cabinetId": "cab-cd-002", "cabinetName": "D区1排2号", "lastUpdated": "2026-06-23T08:38:37.882Z", "temperature": 23.9}, {"id": "sensor-cab-cd-003-front", "humidity": 52.4, "position": "front", "cabinetId": "cab-cd-003", "cabinetName": "D区1排3号", "lastUpdated": "2026-06-23T08:38:37.882Z", "temperature": 19.3}, {"id": "sensor-cab-cd-003-rear", "humidity": 46.9, "position": "rear", "cabinetId": "cab-cd-003", "cabinetName": "D区1排3号", "lastUpdated": "2026-06-23T08:38:37.882Z", "temperature": 28.8}, {"id": "sensor-cab-cd-003-top", "humidity": 48.9, "position": "top", "cabinetId": "cab-cd-003", "cabinetName": "D区1排3号", "lastUpdated": "2026-06-23T08:38:37.882Z", "temperature": 23.3}, {"id": "sensor-cab-cd-004-front", "humidity": 40.5, "position": "front", "cabinetId": "cab-cd-004", "cabinetName": "D区1排4号", "lastUpdated": "2026-06-23T08:38:37.882Z", "temperature": 26.8}, {"id": "sensor-cab-cd-004-rear", "humidity": 35.1, "position": "rear", "cabinetId": "cab-cd-004", "cabinetName": "D区1排4号", "lastUpdated": "2026-06-23T08:38:37.882Z", "temperature": 27}, {"id": "sensor-cab-cd-004-top", "humidity": 34, "position": "top", "cabinetId": "cab-cd-004", "cabinetName": "D区1排4号", "lastUpdated": "2026-06-23T08:38:37.883Z", "temperature": 24}, {"id": "sensor-cab-cd-005-front", "humidity": 35.4, "position": "front", "cabinetId": "cab-cd-005", "cabinetName": "D区2排1号", "lastUpdated": "2026-06-23T08:38:37.883Z", "temperature": 19.5}, {"id": "sensor-cab-cd-005-rear", "humidity": 33.6, "position": "rear", "cabinetId": "cab-cd-005", "cabinetName": "D区2排1号", "lastUpdated": "2026-06-23T08:38:37.883Z", "temperature": 27.2}, {"id": "sensor-cab-cd-005-top", "humidity": 32.1, "position": "top", "cabinetId": "cab-cd-005", "cabinetName": "D区2排1号", "lastUpdated": "2026-06-23T08:38:37.883Z", "temperature": 23.4}, {"id": "sensor-cab-cd-006-front", "humidity": 38.6, "position": "front", "cabinetId": "cab-cd-006", "cabinetName": "D区2排2号", "lastUpdated": "2026-06-23T08:38:37.883Z", "temperature": 23.5}, {"id": "sensor-cab-cd-006-rear", "humidity": 31.6, "position": "rear", "cabinetId": "cab-cd-006", "cabinetName": "D区2排2号", "lastUpdated": "2026-06-23T08:38:37.883Z", "temperature": 26.8}, {"id": "sensor-cab-cd-006-top", "humidity": 49, "position": "top", "cabinetId": "cab-cd-006", "cabinetName": "D区2排2号", "lastUpdated": "2026-06-23T08:38:37.883Z", "temperature": 25}, {"id": "sensor-cab-cd-007-front", "humidity": 43.5, "position": "front", "cabinetId": "cab-cd-007", "cabinetName": "D区2排3号", "lastUpdated": "2026-06-23T08:38:37.883Z", "temperature": 21}, {"id": "sensor-cab-cd-007-rear", "humidity": 41.7, "position": "rear", "cabinetId": "cab-cd-007", "cabinetName": "D区2排3号", "lastUpdated": "2026-06-23T08:38:37.883Z", "temperature": 29.4}, {"id": "sensor-cab-cd-007-top", "humidity": 48.4, "position": "top", "cabinetId": "cab-cd-007", "cabinetName": "D区2排3号", "lastUpdated": "2026-06-23T08:38:37.883Z", "temperature": 26.8}, {"id": "sensor-cab-cd-008-front", "humidity": 50.3, "position": "front", "cabinetId": "cab-cd-008", "cabinetName": "D区2排4号", "lastUpdated": "2026-06-23T08:38:37.883Z", "temperature": 26.5}, {"id": "sensor-cab-cd-008-rear", "humidity": 46.3, "position": "rear", "cabinetId": "cab-cd-008", "cabinetName": "D区2排4号", "lastUpdated": "2026-06-23T08:38:37.883Z", "temperature": 27.6}, {"id": "sensor-cab-cd-008-top", "humidity": 34.9, "position": "top", "cabinetId": "cab-cd-008", "cabinetName": "D区2排4号", "lastUpdated": "2026-06-23T08:38:37.883Z", "temperature": 26.8}, {"id": "sensor-cab-cd-009-front", "humidity": 54.4, "position": "front", "cabinetId": "cab-cd-009", "cabinetName": "D区3排1号", "lastUpdated": "2026-06-23T08:38:37.883Z", "temperature": 19}, {"id": "sensor-cab-cd-009-rear", "humidity": 33.5, "position": "rear", "cabinetId": "cab-cd-009", "cabinetName": "D区3排1号", "lastUpdated": "2026-06-23T08:38:37.883Z", "temperature": 31.9}, {"id": "sensor-cab-cd-009-top", "humidity": 34.2, "position": "top", "cabinetId": "cab-cd-009", "cabinetName": "D区3排1号", "lastUpdated": "2026-06-23T08:38:37.883Z", "temperature": 25.3}, {"id": "sensor-cab-cd-010-front", "humidity": 51.9, "position": "front", "cabinetId": "cab-cd-010", "cabinetName": "D区3排2号", "lastUpdated": "2026-06-23T08:38:37.883Z", "temperature": 24.7}, {"id": "sensor-cab-cd-010-rear", "humidity": 32.5, "position": "rear", "cabinetId": "cab-cd-010", "cabinetName": "D区3排2号", "lastUpdated": "2026-06-23T08:38:37.883Z", "temperature": 27.3}, {"id": "sensor-cab-cd-010-top", "humidity": 36.1, "position": "top", "cabinetId": "cab-cd-010", "cabinetName": "D区3排2号", "lastUpdated": "2026-06-23T08:38:37.883Z", "temperature": 24.7}, {"id": "sensor-cab-cd-011-front", "humidity": 43.4, "position": "front", "cabinetId": "cab-cd-011", "cabinetName": "D区3排3号", "lastUpdated": "2026-06-23T08:38:37.883Z", "temperature": 26.8}, {"id": "sensor-cab-cd-011-rear", "humidity": 40.7, "position": "rear", "cabinetId": "cab-cd-011", "cabinetName": "D区3排3号", "lastUpdated": "2026-06-23T08:38:37.883Z", "temperature": 25}, {"id": "sensor-cab-cd-011-top", "humidity": 48.7, "position": "top", "cabinetId": "cab-cd-011", "cabinetName": "D区3排3号", "lastUpdated": "2026-06-23T08:38:37.883Z", "temperature": 28.3}, {"id": "sensor-cab-cd-012-front", "humidity": 42.8, "position": "front", "cabinetId": "cab-cd-012", "cabinetName": "D区3排4号", "lastUpdated": "2026-06-23T08:38:37.883Z", "temperature": 19.7}, {"id": "sensor-cab-cd-012-rear", "humidity": 43.4, "position": "rear", "cabinetId": "cab-cd-012", "cabinetName": "D区3排4号", "lastUpdated": "2026-06-23T08:38:37.883Z", "temperature": 25.7}, {"id": "sensor-cab-cd-012-top", "humidity": 33.7, "position": "top", "cabinetId": "cab-cd-012", "cabinetName": "D区3排4号", "lastUpdated": "2026-06-23T08:38:37.883Z", "temperature": 22.2}]	2026-06-23 08:38:42.107162+00
raw-temperatureTrend	temperatureTrend	[{"timestamp": "2026-06-22T08:38:38.184Z", "avgTemperature": 25.6, "maxTemperature": 28.9, "minTemperature": 22.4}, {"timestamp": "2026-06-22T09:38:38.184Z", "avgTemperature": 24.3, "maxTemperature": 28.9, "minTemperature": 23.8}, {"timestamp": "2026-06-22T10:38:38.184Z", "avgTemperature": 25.4, "maxTemperature": 28.8, "minTemperature": 22.2}, {"timestamp": "2026-06-22T11:38:38.184Z", "avgTemperature": 24.5, "maxTemperature": 27.1, "minTemperature": 21.7}, {"timestamp": "2026-06-22T12:38:38.184Z", "avgTemperature": 22.3, "maxTemperature": 28, "minTemperature": 21}, {"timestamp": "2026-06-22T13:38:38.184Z", "avgTemperature": 21.4, "maxTemperature": 26.2, "minTemperature": 21.2}, {"timestamp": "2026-06-22T14:38:38.184Z", "avgTemperature": 23.1, "maxTemperature": 26.1, "minTemperature": 20.4}, {"timestamp": "2026-06-22T15:38:38.184Z", "avgTemperature": 21.4, "maxTemperature": 27.6, "minTemperature": 21.9}, {"timestamp": "2026-06-22T16:38:38.184Z", "avgTemperature": 23.5, "maxTemperature": 24.3, "minTemperature": 21.8}, {"timestamp": "2026-06-22T17:38:38.184Z", "avgTemperature": 24.2, "maxTemperature": 25.4, "minTemperature": 21.3}, {"timestamp": "2026-06-22T18:38:38.184Z", "avgTemperature": 24.2, "maxTemperature": 27.6, "minTemperature": 20.3}, {"timestamp": "2026-06-22T19:38:38.184Z", "avgTemperature": 22, "maxTemperature": 27, "minTemperature": 20.3}, {"timestamp": "2026-06-22T20:38:38.184Z", "avgTemperature": 23.9, "maxTemperature": 25.4, "minTemperature": 20.4}, {"timestamp": "2026-06-22T21:38:38.184Z", "avgTemperature": 22.3, "maxTemperature": 26.8, "minTemperature": 21.4}, {"timestamp": "2026-06-22T22:38:38.184Z", "avgTemperature": 22, "maxTemperature": 26.7, "minTemperature": 21.1}, {"timestamp": "2026-06-22T23:38:38.184Z", "avgTemperature": 21, "maxTemperature": 25.1, "minTemperature": 21.1}, {"timestamp": "2026-06-23T00:38:38.184Z", "avgTemperature": 23.4, "maxTemperature": 27.4, "minTemperature": 21.4}, {"timestamp": "2026-06-23T01:38:38.184Z", "avgTemperature": 24.2, "maxTemperature": 26.6, "minTemperature": 22.6}, {"timestamp": "2026-06-23T02:38:38.184Z", "avgTemperature": 23.3, "maxTemperature": 29.3, "minTemperature": 22.3}, {"timestamp": "2026-06-23T03:38:38.184Z", "avgTemperature": 23.2, "maxTemperature": 29.3, "minTemperature": 23.7}, {"timestamp": "2026-06-23T04:38:38.184Z", "avgTemperature": 26.9, "maxTemperature": 26.9, "minTemperature": 22.8}, {"timestamp": "2026-06-23T05:38:38.184Z", "avgTemperature": 24.3, "maxTemperature": 29, "minTemperature": 23.5}, {"timestamp": "2026-06-23T06:38:38.184Z", "avgTemperature": 24, "maxTemperature": 26.2, "minTemperature": 22.5}, {"timestamp": "2026-06-23T07:38:38.184Z", "avgTemperature": 23.5, "maxTemperature": 28.4, "minTemperature": 23.1}, {"timestamp": "2026-06-23T08:38:38.184Z", "avgTemperature": 24, "maxTemperature": 27.2, "minTemperature": 23.7}]	2026-06-23 08:38:42.107162+00
raw-pueTrend	pueTrend	[{"pue": 1.45, "date": "2026-05-24", "itPower": 187.4, "totalPower": 271.9, "coolingPower": 57.8, "datacenterId": "dc-001", "datacenterName": "北京亦庄"}, {"pue": 1.46, "date": "2026-05-25", "itPower": 159.9, "totalPower": 232.7, "coolingPower": 51.3, "datacenterId": "dc-001", "datacenterName": "北京亦庄"}, {"pue": 1.62, "date": "2026-05-26", "itPower": 151.6, "totalPower": 245.5, "coolingPower": 65.4, "datacenterId": "dc-001", "datacenterName": "北京亦庄"}, {"pue": 1.56, "date": "2026-05-27", "itPower": 199.2, "totalPower": 310.7, "coolingPower": 83.8, "datacenterId": "dc-001", "datacenterName": "北京亦庄"}, {"pue": 1.51, "date": "2026-05-28", "itPower": 184.3, "totalPower": 277.4, "coolingPower": 70.5, "datacenterId": "dc-001", "datacenterName": "北京亦庄"}, {"pue": 1.52, "date": "2026-05-29", "itPower": 168.5, "totalPower": 256.9, "coolingPower": 66.8, "datacenterId": "dc-001", "datacenterName": "北京亦庄"}, {"pue": 1.5, "date": "2026-05-30", "itPower": 175.4, "totalPower": 262.4, "coolingPower": 61.7, "datacenterId": "dc-001", "datacenterName": "北京亦庄"}, {"pue": 1.64, "date": "2026-05-31", "itPower": 150.9, "totalPower": 247.1, "coolingPower": 70.9, "datacenterId": "dc-001", "datacenterName": "北京亦庄"}, {"pue": 1.46, "date": "2026-06-01", "itPower": 190.5, "totalPower": 279.1, "coolingPower": 59.5, "datacenterId": "dc-001", "datacenterName": "北京亦庄"}, {"pue": 1.52, "date": "2026-06-02", "itPower": 175.7, "totalPower": 267.9, "coolingPower": 64.2, "datacenterId": "dc-001", "datacenterName": "北京亦庄"}, {"pue": 1.45, "date": "2026-06-03", "itPower": 159, "totalPower": 231.3, "coolingPower": 48.2, "datacenterId": "dc-001", "datacenterName": "北京亦庄"}, {"pue": 1.54, "date": "2026-06-04", "itPower": 187.7, "totalPower": 288.4, "coolingPower": 79.9, "datacenterId": "dc-001", "datacenterName": "北京亦庄"}, {"pue": 1.48, "date": "2026-06-05", "itPower": 150, "totalPower": 222.5, "coolingPower": 50.9, "datacenterId": "dc-001", "datacenterName": "北京亦庄"}, {"pue": 1.59, "date": "2026-06-06", "itPower": 163.3, "totalPower": 259.6, "coolingPower": 71.5, "datacenterId": "dc-001", "datacenterName": "北京亦庄"}, {"pue": 1.46, "date": "2026-06-07", "itPower": 197.5, "totalPower": 288.2, "coolingPower": 62.7, "datacenterId": "dc-001", "datacenterName": "北京亦庄"}, {"pue": 1.5, "date": "2026-06-08", "itPower": 184.1, "totalPower": 275.3, "coolingPower": 68.5, "datacenterId": "dc-001", "datacenterName": "北京亦庄"}, {"pue": 1.54, "date": "2026-06-09", "itPower": 161.6, "totalPower": 249.1, "coolingPower": 66.8, "datacenterId": "dc-001", "datacenterName": "北京亦庄"}, {"pue": 1.52, "date": "2026-06-10", "itPower": 154.6, "totalPower": 235.1, "coolingPower": 59, "datacenterId": "dc-001", "datacenterName": "北京亦庄"}, {"pue": 1.62, "date": "2026-06-11", "itPower": 193.9, "totalPower": 315.1, "coolingPower": 91.6, "datacenterId": "dc-001", "datacenterName": "北京亦庄"}, {"pue": 1.55, "date": "2026-06-12", "itPower": 172.7, "totalPower": 268.3, "coolingPower": 74.5, "datacenterId": "dc-001", "datacenterName": "北京亦庄"}, {"pue": 1.63, "date": "2026-06-13", "itPower": 171.1, "totalPower": 278.3, "coolingPower": 78.5, "datacenterId": "dc-001", "datacenterName": "北京亦庄"}, {"pue": 1.43, "date": "2026-06-14", "itPower": 177, "totalPower": 252.4, "coolingPower": 54.2, "datacenterId": "dc-001", "datacenterName": "北京亦庄"}, {"pue": 1.45, "date": "2026-06-15", "itPower": 195.6, "totalPower": 284.1, "coolingPower": 64.7, "datacenterId": "dc-001", "datacenterName": "北京亦庄"}, {"pue": 1.56, "date": "2026-06-16", "itPower": 195.2, "totalPower": 304.7, "coolingPower": 86.5, "datacenterId": "dc-001", "datacenterName": "北京亦庄"}, {"pue": 1.55, "date": "2026-06-17", "itPower": 178.8, "totalPower": 276.3, "coolingPower": 69.1, "datacenterId": "dc-001", "datacenterName": "北京亦庄"}, {"pue": 1.54, "date": "2026-06-18", "itPower": 189.8, "totalPower": 292.6, "coolingPower": 79.7, "datacenterId": "dc-001", "datacenterName": "北京亦庄"}, {"pue": 1.52, "date": "2026-06-19", "itPower": 179.1, "totalPower": 271.8, "coolingPower": 70.8, "datacenterId": "dc-001", "datacenterName": "北京亦庄"}, {"pue": 1.49, "date": "2026-06-20", "itPower": 158.5, "totalPower": 236.6, "coolingPower": 51.8, "datacenterId": "dc-001", "datacenterName": "北京亦庄"}, {"pue": 1.54, "date": "2026-06-21", "itPower": 179, "totalPower": 276.3, "coolingPower": 67.6, "datacenterId": "dc-001", "datacenterName": "北京亦庄"}, {"pue": 1.51, "date": "2026-06-22", "itPower": 157.9, "totalPower": 238.8, "coolingPower": 51.3, "datacenterId": "dc-001", "datacenterName": "北京亦庄"}, {"pue": 1.55, "date": "2026-06-23", "itPower": 152.8, "totalPower": 236.2, "coolingPower": 59.9, "datacenterId": "dc-001", "datacenterName": "北京亦庄"}, {"pue": 1.58, "date": "2026-05-24", "itPower": 180.7, "totalPower": 286.1, "coolingPower": 78.1, "datacenterId": "dc-002", "datacenterName": "上海嘉定"}, {"pue": 1.43, "date": "2026-05-25", "itPower": 175.8, "totalPower": 251, "coolingPower": 54.6, "datacenterId": "dc-002", "datacenterName": "上海嘉定"}, {"pue": 1.59, "date": "2026-05-26", "itPower": 157.1, "totalPower": 249.6, "coolingPower": 71.6, "datacenterId": "dc-002", "datacenterName": "上海嘉定"}, {"pue": 1.57, "date": "2026-05-27", "itPower": 158.8, "totalPower": 250, "coolingPower": 68.5, "datacenterId": "dc-002", "datacenterName": "上海嘉定"}, {"pue": 1.63, "date": "2026-05-28", "itPower": 165.8, "totalPower": 271, "coolingPower": 75.5, "datacenterId": "dc-002", "datacenterName": "上海嘉定"}, {"pue": 1.61, "date": "2026-05-29", "itPower": 170.2, "totalPower": 274.8, "coolingPower": 82.1, "datacenterId": "dc-002", "datacenterName": "上海嘉定"}, {"pue": 1.5, "date": "2026-05-30", "itPower": 184.5, "totalPower": 276.5, "coolingPower": 63.2, "datacenterId": "dc-002", "datacenterName": "上海嘉定"}, {"pue": 1.48, "date": "2026-05-31", "itPower": 197.7, "totalPower": 291.8, "coolingPower": 69.6, "datacenterId": "dc-002", "datacenterName": "上海嘉定"}, {"pue": 1.52, "date": "2026-06-01", "itPower": 151.5, "totalPower": 230.6, "coolingPower": 55.7, "datacenterId": "dc-002", "datacenterName": "上海嘉定"}, {"pue": 1.59, "date": "2026-06-02", "itPower": 164.9, "totalPower": 262.2, "coolingPower": 71.7, "datacenterId": "dc-002", "datacenterName": "上海嘉定"}, {"pue": 1.6, "date": "2026-06-03", "itPower": 156.6, "totalPower": 251.1, "coolingPower": 73.9, "datacenterId": "dc-002", "datacenterName": "上海嘉定"}, {"pue": 1.54, "date": "2026-06-04", "itPower": 152.6, "totalPower": 235.5, "coolingPower": 60.6, "datacenterId": "dc-002", "datacenterName": "上海嘉定"}, {"pue": 1.51, "date": "2026-06-05", "itPower": 171.5, "totalPower": 259.5, "coolingPower": 63.6, "datacenterId": "dc-002", "datacenterName": "上海嘉定"}, {"pue": 1.6, "date": "2026-06-06", "itPower": 199.7, "totalPower": 319.7, "coolingPower": 96, "datacenterId": "dc-002", "datacenterName": "上海嘉定"}, {"pue": 1.45, "date": "2026-06-07", "itPower": 178.8, "totalPower": 258.4, "coolingPower": 56.3, "datacenterId": "dc-002", "datacenterName": "上海嘉定"}, {"pue": 1.57, "date": "2026-06-08", "itPower": 166.7, "totalPower": 262.2, "coolingPower": 70.8, "datacenterId": "dc-002", "datacenterName": "上海嘉定"}, {"pue": 1.57, "date": "2026-06-09", "itPower": 175.6, "totalPower": 276.2, "coolingPower": 72.2, "datacenterId": "dc-002", "datacenterName": "上海嘉定"}, {"pue": 1.46, "date": "2026-06-10", "itPower": 173.6, "totalPower": 252.8, "coolingPower": 53.9, "datacenterId": "dc-002", "datacenterName": "上海嘉定"}, {"pue": 1.52, "date": "2026-06-11", "itPower": 181.2, "totalPower": 276.3, "coolingPower": 69.4, "datacenterId": "dc-002", "datacenterName": "上海嘉定"}, {"pue": 1.62, "date": "2026-06-12", "itPower": 159.4, "totalPower": 259, "coolingPower": 74, "datacenterId": "dc-002", "datacenterName": "上海嘉定"}, {"pue": 1.48, "date": "2026-06-13", "itPower": 198.9, "totalPower": 293.9, "coolingPower": 66.8, "datacenterId": "dc-002", "datacenterName": "上海嘉定"}, {"pue": 1.49, "date": "2026-06-14", "itPower": 198.7, "totalPower": 296.9, "coolingPower": 70.3, "datacenterId": "dc-002", "datacenterName": "上海嘉定"}, {"pue": 1.43, "date": "2026-06-15", "itPower": 193.8, "totalPower": 278, "coolingPower": 61.5, "datacenterId": "dc-002", "datacenterName": "上海嘉定"}, {"pue": 1.59, "date": "2026-06-16", "itPower": 163.8, "totalPower": 260.9, "coolingPower": 67.7, "datacenterId": "dc-002", "datacenterName": "上海嘉定"}, {"pue": 1.59, "date": "2026-06-17", "itPower": 198.8, "totalPower": 316.6, "coolingPower": 97.7, "datacenterId": "dc-002", "datacenterName": "上海嘉定"}, {"pue": 1.46, "date": "2026-06-18", "itPower": 183.6, "totalPower": 268.4, "coolingPower": 59.4, "datacenterId": "dc-002", "datacenterName": "上海嘉定"}, {"pue": 1.59, "date": "2026-06-19", "itPower": 187.9, "totalPower": 299.6, "coolingPower": 87.4, "datacenterId": "dc-002", "datacenterName": "上海嘉定"}, {"pue": 1.47, "date": "2026-06-20", "itPower": 177, "totalPower": 259.6, "coolingPower": 60.9, "datacenterId": "dc-002", "datacenterName": "上海嘉定"}, {"pue": 1.6, "date": "2026-06-21", "itPower": 195.9, "totalPower": 313, "coolingPower": 94.2, "datacenterId": "dc-002", "datacenterName": "上海嘉定"}, {"pue": 1.52, "date": "2026-06-22", "itPower": 164.9, "totalPower": 250.4, "coolingPower": 62.4, "datacenterId": "dc-002", "datacenterName": "上海嘉定"}, {"pue": 1.56, "date": "2026-06-23", "itPower": 153.3, "totalPower": 239.3, "coolingPower": 57.8, "datacenterId": "dc-002", "datacenterName": "上海嘉定"}, {"pue": 1.51, "date": "2026-05-24", "itPower": 158.2, "totalPower": 238.4, "coolingPower": 56.8, "datacenterId": "dc-003", "datacenterName": "深圳坪山"}, {"pue": 1.63, "date": "2026-05-25", "itPower": 199.7, "totalPower": 325.1, "coolingPower": 98.7, "datacenterId": "dc-003", "datacenterName": "深圳坪山"}, {"pue": 1.58, "date": "2026-05-26", "itPower": 156.9, "totalPower": 247.8, "coolingPower": 61.5, "datacenterId": "dc-003", "datacenterName": "深圳坪山"}, {"pue": 1.53, "date": "2026-05-27", "itPower": 170.5, "totalPower": 261.2, "coolingPower": 62.2, "datacenterId": "dc-003", "datacenterName": "深圳坪山"}, {"pue": 1.45, "date": "2026-05-28", "itPower": 193.4, "totalPower": 280.9, "coolingPower": 59.1, "datacenterId": "dc-003", "datacenterName": "深圳坪山"}, {"pue": 1.59, "date": "2026-05-29", "itPower": 159.9, "totalPower": 254.6, "coolingPower": 65.8, "datacenterId": "dc-003", "datacenterName": "深圳坪山"}, {"pue": 1.58, "date": "2026-05-30", "itPower": 169.2, "totalPower": 267.5, "coolingPower": 71.6, "datacenterId": "dc-003", "datacenterName": "深圳坪山"}, {"pue": 1.52, "date": "2026-05-31", "itPower": 190.6, "totalPower": 289.2, "coolingPower": 71.5, "datacenterId": "dc-003", "datacenterName": "深圳坪山"}, {"pue": 1.57, "date": "2026-06-01", "itPower": 162.7, "totalPower": 255.8, "coolingPower": 63.3, "datacenterId": "dc-003", "datacenterName": "深圳坪山"}, {"pue": 1.49, "date": "2026-06-02", "itPower": 177.7, "totalPower": 265.5, "coolingPower": 60.2, "datacenterId": "dc-003", "datacenterName": "深圳坪山"}, {"pue": 1.59, "date": "2026-06-03", "itPower": 172.8, "totalPower": 275.5, "coolingPower": 81, "datacenterId": "dc-003", "datacenterName": "深圳坪山"}, {"pue": 1.52, "date": "2026-06-04", "itPower": 188.2, "totalPower": 286.8, "coolingPower": 75.7, "datacenterId": "dc-003", "datacenterName": "深圳坪山"}, {"pue": 1.53, "date": "2026-06-05", "itPower": 199.8, "totalPower": 306.6, "coolingPower": 85.7, "datacenterId": "dc-003", "datacenterName": "深圳坪山"}, {"pue": 1.56, "date": "2026-06-06", "itPower": 185.8, "totalPower": 289.1, "coolingPower": 78.3, "datacenterId": "dc-003", "datacenterName": "深圳坪山"}, {"pue": 1.63, "date": "2026-06-07", "itPower": 182.8, "totalPower": 297.5, "coolingPower": 90.6, "datacenterId": "dc-003", "datacenterName": "深圳坪山"}, {"pue": 1.63, "date": "2026-06-08", "itPower": 172.6, "totalPower": 281.5, "coolingPower": 85.7, "datacenterId": "dc-003", "datacenterName": "深圳坪山"}, {"pue": 1.53, "date": "2026-06-09", "itPower": 183.3, "totalPower": 280.3, "coolingPower": 68.5, "datacenterId": "dc-003", "datacenterName": "深圳坪山"}, {"pue": 1.62, "date": "2026-06-10", "itPower": 173.5, "totalPower": 281.2, "coolingPower": 85.2, "datacenterId": "dc-003", "datacenterName": "深圳坪山"}, {"pue": 1.64, "date": "2026-06-11", "itPower": 157.5, "totalPower": 259, "coolingPower": 73.6, "datacenterId": "dc-003", "datacenterName": "深圳坪山"}, {"pue": 1.63, "date": "2026-06-12", "itPower": 172.3, "totalPower": 280.4, "coolingPower": 84, "datacenterId": "dc-003", "datacenterName": "深圳坪山"}, {"pue": 1.61, "date": "2026-06-13", "itPower": 185.3, "totalPower": 297.6, "coolingPower": 82.4, "datacenterId": "dc-003", "datacenterName": "深圳坪山"}, {"pue": 1.5, "date": "2026-06-14", "itPower": 181.5, "totalPower": 272.8, "coolingPower": 62.6, "datacenterId": "dc-003", "datacenterName": "深圳坪山"}, {"pue": 1.46, "date": "2026-06-15", "itPower": 154.2, "totalPower": 225.8, "coolingPower": 49.9, "datacenterId": "dc-003", "datacenterName": "深圳坪山"}, {"pue": 1.59, "date": "2026-06-16", "itPower": 195.5, "totalPower": 311.5, "coolingPower": 92.8, "datacenterId": "dc-003", "datacenterName": "深圳坪山"}, {"pue": 1.52, "date": "2026-06-17", "itPower": 187, "totalPower": 284.8, "coolingPower": 74.2, "datacenterId": "dc-003", "datacenterName": "深圳坪山"}, {"pue": 1.48, "date": "2026-06-18", "itPower": 180.9, "totalPower": 268.6, "coolingPower": 58.6, "datacenterId": "dc-003", "datacenterName": "深圳坪山"}, {"pue": 1.51, "date": "2026-06-19", "itPower": 150.1, "totalPower": 226.2, "coolingPower": 50.9, "datacenterId": "dc-003", "datacenterName": "深圳坪山"}, {"pue": 1.59, "date": "2026-06-20", "itPower": 169.3, "totalPower": 269.7, "coolingPower": 78.1, "datacenterId": "dc-003", "datacenterName": "深圳坪山"}, {"pue": 1.5, "date": "2026-06-21", "itPower": 185.3, "totalPower": 277.5, "coolingPower": 65.4, "datacenterId": "dc-003", "datacenterName": "深圳坪山"}, {"pue": 1.51, "date": "2026-06-22", "itPower": 199, "totalPower": 300.2, "coolingPower": 76.6, "datacenterId": "dc-003", "datacenterName": "深圳坪山"}, {"pue": 1.66, "date": "2026-06-23", "itPower": 170.7, "totalPower": 283.3, "coolingPower": 84.2, "datacenterId": "dc-003", "datacenterName": "深圳坪山"}, {"pue": 1.53, "date": "2026-05-24", "itPower": 159.3, "totalPower": 244.3, "coolingPower": 57.7, "datacenterId": "dc-004", "datacenterName": "未知数据中心"}, {"pue": 1.59, "date": "2026-05-25", "itPower": 193, "totalPower": 307.5, "coolingPower": 84.6, "datacenterId": "dc-004", "datacenterName": "未知数据中心"}, {"pue": 1.54, "date": "2026-05-26", "itPower": 191.3, "totalPower": 294.2, "coolingPower": 73, "datacenterId": "dc-004", "datacenterName": "未知数据中心"}, {"pue": 1.59, "date": "2026-05-27", "itPower": 175.9, "totalPower": 279.4, "coolingPower": 79.6, "datacenterId": "dc-004", "datacenterName": "未知数据中心"}, {"pue": 1.59, "date": "2026-05-28", "itPower": 179.9, "totalPower": 286.1, "coolingPower": 76.6, "datacenterId": "dc-004", "datacenterName": "未知数据中心"}, {"pue": 1.64, "date": "2026-05-29", "itPower": 156.8, "totalPower": 256.7, "coolingPower": 78.3, "datacenterId": "dc-004", "datacenterName": "未知数据中心"}, {"pue": 1.48, "date": "2026-05-30", "itPower": 192.5, "totalPower": 284.5, "coolingPower": 65, "datacenterId": "dc-004", "datacenterName": "未知数据中心"}, {"pue": 1.53, "date": "2026-05-31", "itPower": 198.1, "totalPower": 303.5, "coolingPower": 79.1, "datacenterId": "dc-004", "datacenterName": "未知数据中心"}, {"pue": 1.62, "date": "2026-06-01", "itPower": 152.2, "totalPower": 246.9, "coolingPower": 66, "datacenterId": "dc-004", "datacenterName": "未知数据中心"}, {"pue": 1.52, "date": "2026-06-02", "itPower": 165.9, "totalPower": 252.1, "coolingPower": 65.8, "datacenterId": "dc-004", "datacenterName": "未知数据中心"}, {"pue": 1.5, "date": "2026-06-03", "itPower": 164.7, "totalPower": 247.2, "coolingPower": 53.2, "datacenterId": "dc-004", "datacenterName": "未知数据中心"}, {"pue": 1.57, "date": "2026-06-04", "itPower": 168.8, "totalPower": 264.8, "coolingPower": 73.2, "datacenterId": "dc-004", "datacenterName": "未知数据中心"}, {"pue": 1.61, "date": "2026-06-05", "itPower": 162.6, "totalPower": 261.4, "coolingPower": 74.9, "datacenterId": "dc-004", "datacenterName": "未知数据中心"}, {"pue": 1.56, "date": "2026-06-06", "itPower": 159.7, "totalPower": 249.2, "coolingPower": 64.5, "datacenterId": "dc-004", "datacenterName": "未知数据中心"}, {"pue": 1.47, "date": "2026-06-07", "itPower": 196.5, "totalPower": 288.3, "coolingPower": 69.1, "datacenterId": "dc-004", "datacenterName": "未知数据中心"}, {"pue": 1.5, "date": "2026-06-08", "itPower": 181.7, "totalPower": 272.9, "coolingPower": 71, "datacenterId": "dc-004", "datacenterName": "未知数据中心"}, {"pue": 1.64, "date": "2026-06-09", "itPower": 155.2, "totalPower": 255.1, "coolingPower": 71.3, "datacenterId": "dc-004", "datacenterName": "未知数据中心"}, {"pue": 1.6, "date": "2026-06-10", "itPower": 187.8, "totalPower": 299.9, "coolingPower": 84.5, "datacenterId": "dc-004", "datacenterName": "未知数据中心"}, {"pue": 1.59, "date": "2026-06-11", "itPower": 168, "totalPower": 267.8, "coolingPower": 71.5, "datacenterId": "dc-004", "datacenterName": "未知数据中心"}, {"pue": 1.56, "date": "2026-06-12", "itPower": 183.9, "totalPower": 287.6, "coolingPower": 83.3, "datacenterId": "dc-004", "datacenterName": "未知数据中心"}, {"pue": 1.45, "date": "2026-06-13", "itPower": 170.9, "totalPower": 248.5, "coolingPower": 52.5, "datacenterId": "dc-004", "datacenterName": "未知数据中心"}, {"pue": 1.53, "date": "2026-06-14", "itPower": 193.6, "totalPower": 296.8, "coolingPower": 79.4, "datacenterId": "dc-004", "datacenterName": "未知数据中心"}, {"pue": 1.52, "date": "2026-06-15", "itPower": 183, "totalPower": 278, "coolingPower": 65.6, "datacenterId": "dc-004", "datacenterName": "未知数据中心"}, {"pue": 1.53, "date": "2026-06-16", "itPower": 155.8, "totalPower": 238.2, "coolingPower": 60.7, "datacenterId": "dc-004", "datacenterName": "未知数据中心"}, {"pue": 1.51, "date": "2026-06-17", "itPower": 175.8, "totalPower": 265.4, "coolingPower": 68.5, "datacenterId": "dc-004", "datacenterName": "未知数据中心"}, {"pue": 1.58, "date": "2026-06-18", "itPower": 181.1, "totalPower": 286.2, "coolingPower": 75.2, "datacenterId": "dc-004", "datacenterName": "未知数据中心"}, {"pue": 1.5, "date": "2026-06-19", "itPower": 167.9, "totalPower": 251.1, "coolingPower": 60, "datacenterId": "dc-004", "datacenterName": "未知数据中心"}, {"pue": 1.47, "date": "2026-06-20", "itPower": 169.1, "totalPower": 247.8, "coolingPower": 54.9, "datacenterId": "dc-004", "datacenterName": "未知数据中心"}, {"pue": 1.46, "date": "2026-06-21", "itPower": 174, "totalPower": 253.8, "coolingPower": 56.9, "datacenterId": "dc-004", "datacenterName": "未知数据中心"}, {"pue": 1.54, "date": "2026-06-22", "itPower": 167.1, "totalPower": 256.8, "coolingPower": 62.8, "datacenterId": "dc-004", "datacenterName": "未知数据中心"}, {"pue": 1.58, "date": "2026-06-23", "itPower": 194.5, "totalPower": 307.6, "coolingPower": 90.7, "datacenterId": "dc-004", "datacenterName": "未知数据中心"}]	2026-06-23 08:38:42.107162+00
raw-energyStats	energyStats	{"avgPue": 1.42, "totalCost": 87976, "totalEnergy": 125680, "carbonEmission": 62840, "comparedLastMonth": -3.2}	2026-06-23 08:38:42.107162+00
raw-powerConsumption	powerConsumption	[{"id": "power-cab-bj-001", "energy": 1536.1, "current": 11.7, "voltage": 221.2, "cabinetId": "cab-bj-001", "timestamp": "2026-06-23T08:38:38.986Z", "activePower": 3.88, "cabinetName": "A区1排1号", "powerFactor": 0.93, "datacenterId": "dc-001", "apparentPower": 3.96, "datacenterName": "北京亦庄数据中心"}, {"id": "power-cab-bj-002", "energy": 1503.1, "current": 14.6, "voltage": 220.9, "cabinetId": "cab-bj-002", "timestamp": "2026-06-23T08:38:38.986Z", "activePower": 5.34, "cabinetName": "A区1排2号", "powerFactor": 0.95, "datacenterId": "dc-001", "apparentPower": 6.61, "datacenterName": "北京亦庄数据中心"}, {"id": "power-cab-bj-003", "energy": 1711.7, "current": 11.8, "voltage": 221.7, "cabinetId": "cab-bj-003", "timestamp": "2026-06-23T08:38:38.986Z", "activePower": 6.26, "cabinetName": "A区1排3号", "powerFactor": 0.91, "datacenterId": "dc-001", "apparentPower": 4.24, "datacenterName": "北京亦庄数据中心"}, {"id": "power-cab-bj-004", "energy": 1932.5, "current": 12.3, "voltage": 220.7, "cabinetId": "cab-bj-004", "timestamp": "2026-06-23T08:38:38.986Z", "activePower": 6.46, "cabinetName": "A区1排4号", "powerFactor": 0.89, "datacenterId": "dc-001", "apparentPower": 6.73, "datacenterName": "北京亦庄数据中心"}, {"id": "power-cab-bj-005", "energy": 1908.7, "current": 14.5, "voltage": 223.5, "cabinetId": "cab-bj-005", "timestamp": "2026-06-23T08:38:38.986Z", "activePower": 4.84, "cabinetName": "A区1排5号", "powerFactor": 0.88, "datacenterId": "dc-001", "apparentPower": 6.94, "datacenterName": "北京亦庄数据中心"}, {"id": "power-cab-bj-006", "energy": 1991.3, "current": 10.5, "voltage": 223.7, "cabinetId": "cab-bj-006", "timestamp": "2026-06-23T08:38:38.986Z", "activePower": 5.4, "cabinetName": "A区2排1号", "powerFactor": 0.91, "datacenterId": "dc-001", "apparentPower": 7.98, "datacenterName": "北京亦庄数据中心"}, {"id": "power-cab-bj-007", "energy": 1778.7, "current": 12.1, "voltage": 221.1, "cabinetId": "cab-bj-007", "timestamp": "2026-06-23T08:38:38.986Z", "activePower": 4.34, "cabinetName": "A区2排2号", "powerFactor": 0.87, "datacenterId": "dc-001", "apparentPower": 7.51, "datacenterName": "北京亦庄数据中心"}, {"id": "power-cab-bj-008", "energy": 1536.3, "current": 12.5, "voltage": 223.7, "cabinetId": "cab-bj-008", "timestamp": "2026-06-23T08:38:38.986Z", "activePower": 6.2, "cabinetName": "A区2排3号", "powerFactor": 0.87, "datacenterId": "dc-001", "apparentPower": 6.25, "datacenterName": "北京亦庄数据中心"}, {"id": "power-cab-bj-009", "energy": 1987.9, "current": 13.2, "voltage": 220.8, "cabinetId": "cab-bj-009", "timestamp": "2026-06-23T08:38:38.986Z", "activePower": 3.18, "cabinetName": "A区2排4号", "powerFactor": 0.9, "datacenterId": "dc-001", "apparentPower": 5.6, "datacenterName": "北京亦庄数据中心"}, {"id": "power-cab-bj-010", "energy": 1833.5, "current": 14.8, "voltage": 220.8, "cabinetId": "cab-bj-010", "timestamp": "2026-06-23T08:38:38.986Z", "activePower": 6.51, "cabinetName": "A区2排5号", "powerFactor": 0.93, "datacenterId": "dc-001", "apparentPower": 5.61, "datacenterName": "北京亦庄数据中心"}, {"id": "power-cab-bj-011", "energy": 1555.2, "current": 14.7, "voltage": 221.5, "cabinetId": "cab-bj-011", "timestamp": "2026-06-23T08:38:38.986Z", "activePower": 3.37, "cabinetName": "A区3排1号", "powerFactor": 0.93, "datacenterId": "dc-001", "apparentPower": 7.27, "datacenterName": "北京亦庄数据中心"}, {"id": "power-cab-bj-012", "energy": 1517.4, "current": 12.4, "voltage": 220.2, "cabinetId": "cab-bj-012", "timestamp": "2026-06-23T08:38:38.986Z", "activePower": 4.78, "cabinetName": "A区3排2号", "powerFactor": 0.93, "datacenterId": "dc-001", "apparentPower": 7.99, "datacenterName": "北京亦庄数据中心"}, {"id": "power-cab-bj-013", "energy": 1976, "current": 10.6, "voltage": 223.4, "cabinetId": "cab-bj-013", "timestamp": "2026-06-23T08:38:38.986Z", "activePower": 6.72, "cabinetName": "A区3排3号", "powerFactor": 0.94, "datacenterId": "dc-001", "apparentPower": 7.13, "datacenterName": "北京亦庄数据中心"}, {"id": "power-cab-bj-014", "energy": 1679.8, "current": 13.2, "voltage": 224.3, "cabinetId": "cab-bj-014", "timestamp": "2026-06-23T08:38:38.986Z", "activePower": 4.93, "cabinetName": "A区3排4号", "powerFactor": 0.92, "datacenterId": "dc-001", "apparentPower": 3.61, "datacenterName": "北京亦庄数据中心"}, {"id": "power-cab-bj-015", "energy": 1991.8, "current": 11.3, "voltage": 223.2, "cabinetId": "cab-bj-015", "timestamp": "2026-06-23T08:38:38.986Z", "activePower": 3.14, "cabinetName": "A区3排5号", "powerFactor": 0.87, "datacenterId": "dc-001", "apparentPower": 4.91, "datacenterName": "北京亦庄数据中心"}, {"id": "power-cab-bj-016", "energy": 1741.5, "current": 10.3, "voltage": 224.4, "cabinetId": "cab-bj-016", "timestamp": "2026-06-23T08:38:38.986Z", "activePower": 6.15, "cabinetName": "A区4排1号", "powerFactor": 0.93, "datacenterId": "dc-001", "apparentPower": 7.73, "datacenterName": "北京亦庄数据中心"}, {"id": "power-cab-bj-017", "energy": 1548.2, "current": 14.8, "voltage": 222.7, "cabinetId": "cab-bj-017", "timestamp": "2026-06-23T08:38:38.986Z", "activePower": 3.23, "cabinetName": "A区4排2号", "powerFactor": 0.94, "datacenterId": "dc-001", "apparentPower": 4.36, "datacenterName": "北京亦庄数据中心"}, {"id": "power-cab-bj-018", "energy": 1937.6, "current": 13.8, "voltage": 222.3, "cabinetId": "cab-bj-018", "timestamp": "2026-06-23T08:38:38.986Z", "activePower": 3.71, "cabinetName": "A区4排3号", "powerFactor": 0.92, "datacenterId": "dc-001", "apparentPower": 4.58, "datacenterName": "北京亦庄数据中心"}, {"id": "power-cab-bj-019", "energy": 1710.8, "current": 10.1, "voltage": 222.3, "cabinetId": "cab-bj-019", "timestamp": "2026-06-23T08:38:38.986Z", "activePower": 3.6, "cabinetName": "A区4排4号", "powerFactor": 0.92, "datacenterId": "dc-001", "apparentPower": 5.13, "datacenterName": "北京亦庄数据中心"}, {"id": "power-cab-bj-020", "energy": 1890.4, "current": 11, "voltage": 224.5, "cabinetId": "cab-bj-020", "timestamp": "2026-06-23T08:38:38.986Z", "activePower": 6.33, "cabinetName": "A区4排5号", "powerFactor": 0.95, "datacenterId": "dc-001", "apparentPower": 7.91, "datacenterName": "北京亦庄数据中心"}, {"id": "power-cab-sh-001", "energy": 1689.9, "current": 11.8, "voltage": 224, "cabinetId": "cab-sh-001", "timestamp": "2026-06-23T08:38:38.986Z", "activePower": 4.04, "cabinetName": "B区1排1号", "powerFactor": 0.87, "datacenterId": "dc-002", "apparentPower": 3.51, "datacenterName": "上海嘉定数据中心"}, {"id": "power-cab-sh-002", "energy": 1509.6, "current": 11.8, "voltage": 222.1, "cabinetId": "cab-sh-002", "timestamp": "2026-06-23T08:38:38.986Z", "activePower": 4.54, "cabinetName": "B区1排2号", "powerFactor": 0.87, "datacenterId": "dc-002", "apparentPower": 6.24, "datacenterName": "上海嘉定数据中心"}, {"id": "power-cab-sh-003", "energy": 1627.1, "current": 13.5, "voltage": 221.8, "cabinetId": "cab-sh-003", "timestamp": "2026-06-23T08:38:38.986Z", "activePower": 6.32, "cabinetName": "B区1排3号", "powerFactor": 0.93, "datacenterId": "dc-002", "apparentPower": 3.98, "datacenterName": "上海嘉定数据中心"}, {"id": "power-cab-sh-004", "energy": 1615, "current": 14.9, "voltage": 224.2, "cabinetId": "cab-sh-004", "timestamp": "2026-06-23T08:38:38.986Z", "activePower": 3.53, "cabinetName": "B区1排4号", "powerFactor": 0.87, "datacenterId": "dc-002", "apparentPower": 4.49, "datacenterName": "上海嘉定数据中心"}, {"id": "power-cab-sh-005", "energy": 1789.6, "current": 11.9, "voltage": 220.1, "cabinetId": "cab-sh-005", "timestamp": "2026-06-23T08:38:38.986Z", "activePower": 5.17, "cabinetName": "B区1排5号", "powerFactor": 0.87, "datacenterId": "dc-002", "apparentPower": 5.12, "datacenterName": "上海嘉定数据中心"}, {"id": "power-cab-sh-006", "energy": 1638.6, "current": 14.1, "voltage": 221.1, "cabinetId": "cab-sh-006", "timestamp": "2026-06-23T08:38:38.986Z", "activePower": 6.35, "cabinetName": "B区2排1号", "powerFactor": 0.9, "datacenterId": "dc-002", "apparentPower": 6.35, "datacenterName": "上海嘉定数据中心"}, {"id": "power-cab-sh-007", "energy": 1689.3, "current": 11.7, "voltage": 223.8, "cabinetId": "cab-sh-007", "timestamp": "2026-06-23T08:38:38.986Z", "activePower": 6.79, "cabinetName": "B区2排2号", "powerFactor": 0.94, "datacenterId": "dc-002", "apparentPower": 5.44, "datacenterName": "上海嘉定数据中心"}, {"id": "power-cab-sh-008", "energy": 1613.2, "current": 14, "voltage": 223.6, "cabinetId": "cab-sh-008", "timestamp": "2026-06-23T08:38:38.986Z", "activePower": 5.61, "cabinetName": "B区2排3号", "powerFactor": 0.95, "datacenterId": "dc-002", "apparentPower": 4.23, "datacenterName": "上海嘉定数据中心"}, {"id": "power-cab-sh-009", "energy": 1893.8, "current": 13.4, "voltage": 222.2, "cabinetId": "cab-sh-009", "timestamp": "2026-06-23T08:38:38.986Z", "activePower": 5.33, "cabinetName": "B区2排4号", "powerFactor": 0.88, "datacenterId": "dc-002", "apparentPower": 4.22, "datacenterName": "上海嘉定数据中心"}, {"id": "power-cab-sh-010", "energy": 1553.6, "current": 13.5, "voltage": 222.1, "cabinetId": "cab-sh-010", "timestamp": "2026-06-23T08:38:38.986Z", "activePower": 3.24, "cabinetName": "B区2排5号", "powerFactor": 0.91, "datacenterId": "dc-002", "apparentPower": 4.35, "datacenterName": "上海嘉定数据中心"}, {"id": "power-cab-sh-011", "energy": 1860.4, "current": 10.4, "voltage": 222.4, "cabinetId": "cab-sh-011", "timestamp": "2026-06-23T08:38:38.986Z", "activePower": 6.66, "cabinetName": "B区3排1号", "powerFactor": 0.85, "datacenterId": "dc-002", "apparentPower": 5.32, "datacenterName": "上海嘉定数据中心"}, {"id": "power-cab-sh-012", "energy": 1532.7, "current": 12.7, "voltage": 223.5, "cabinetId": "cab-sh-012", "timestamp": "2026-06-23T08:38:38.986Z", "activePower": 6.86, "cabinetName": "B区3排2号", "powerFactor": 0.9, "datacenterId": "dc-002", "apparentPower": 6.91, "datacenterName": "上海嘉定数据中心"}, {"id": "power-cab-sh-013", "energy": 1657.9, "current": 11.5, "voltage": 220.3, "cabinetId": "cab-sh-013", "timestamp": "2026-06-23T08:38:38.986Z", "activePower": 3.29, "cabinetName": "B区3排3号", "powerFactor": 0.89, "datacenterId": "dc-002", "apparentPower": 5.9, "datacenterName": "上海嘉定数据中心"}, {"id": "power-cab-sh-014", "energy": 1930, "current": 11.8, "voltage": 223.6, "cabinetId": "cab-sh-014", "timestamp": "2026-06-23T08:38:38.986Z", "activePower": 6.35, "cabinetName": "B区3排4号", "powerFactor": 0.86, "datacenterId": "dc-002", "apparentPower": 3.92, "datacenterName": "上海嘉定数据中心"}, {"id": "power-cab-sh-015", "energy": 1628.3, "current": 10.1, "voltage": 224.8, "cabinetId": "cab-sh-015", "timestamp": "2026-06-23T08:38:38.986Z", "activePower": 5.22, "cabinetName": "B区3排5号", "powerFactor": 0.85, "datacenterId": "dc-002", "apparentPower": 5.56, "datacenterName": "上海嘉定数据中心"}, {"id": "power-cab-sz-001", "energy": 1915, "current": 10.1, "voltage": 221.1, "cabinetId": "cab-sz-001", "timestamp": "2026-06-23T08:38:38.986Z", "activePower": 5.68, "cabinetName": "C区1排1号", "powerFactor": 0.92, "datacenterId": "dc-003", "apparentPower": 7.06, "datacenterName": "深圳坪山数据中心"}, {"id": "power-cab-sz-002", "energy": 1772.3, "current": 11.9, "voltage": 225, "cabinetId": "cab-sz-002", "timestamp": "2026-06-23T08:38:38.986Z", "activePower": 5.43, "cabinetName": "C区1排2号", "powerFactor": 0.88, "datacenterId": "dc-003", "apparentPower": 4.94, "datacenterName": "深圳坪山数据中心"}, {"id": "power-cab-sz-003", "energy": 1814.2, "current": 12.4, "voltage": 221.6, "cabinetId": "cab-sz-003", "timestamp": "2026-06-23T08:38:38.986Z", "activePower": 3.34, "cabinetName": "C区1排3号", "powerFactor": 0.94, "datacenterId": "dc-003", "apparentPower": 5.54, "datacenterName": "深圳坪山数据中心"}, {"id": "power-cab-sz-004", "energy": 1775, "current": 11.8, "voltage": 221.4, "cabinetId": "cab-sz-004", "timestamp": "2026-06-23T08:38:38.986Z", "activePower": 3.25, "cabinetName": "C区1排4号", "powerFactor": 0.92, "datacenterId": "dc-003", "apparentPower": 7.9, "datacenterName": "深圳坪山数据中心"}, {"id": "power-cab-sz-005", "energy": 1563.3, "current": 10.8, "voltage": 220.6, "cabinetId": "cab-sz-005", "timestamp": "2026-06-23T08:38:38.986Z", "activePower": 4.28, "cabinetName": "C区1排5号", "powerFactor": 0.95, "datacenterId": "dc-003", "apparentPower": 4.27, "datacenterName": "深圳坪山数据中心"}, {"id": "power-cab-sz-006", "energy": 1783.4, "current": 12.4, "voltage": 222.1, "cabinetId": "cab-sz-006", "timestamp": "2026-06-23T08:38:38.986Z", "activePower": 6.79, "cabinetName": "C区1排6号", "powerFactor": 0.91, "datacenterId": "dc-003", "apparentPower": 7.31, "datacenterName": "深圳坪山数据中心"}, {"id": "power-cab-sz-007", "energy": 1994.3, "current": 10.9, "voltage": 221.9, "cabinetId": "cab-sz-007", "timestamp": "2026-06-23T08:38:38.986Z", "activePower": 3.42, "cabinetName": "C区2排1号", "powerFactor": 0.93, "datacenterId": "dc-003", "apparentPower": 4.15, "datacenterName": "深圳坪山数据中心"}, {"id": "power-cab-sz-008", "energy": 1961.6, "current": 11.6, "voltage": 222.5, "cabinetId": "cab-sz-008", "timestamp": "2026-06-23T08:38:38.987Z", "activePower": 4.91, "cabinetName": "C区2排2号", "powerFactor": 0.89, "datacenterId": "dc-003", "apparentPower": 7.3, "datacenterName": "深圳坪山数据中心"}, {"id": "power-cab-sz-009", "energy": 1920.2, "current": 13.4, "voltage": 220.9, "cabinetId": "cab-sz-009", "timestamp": "2026-06-23T08:38:38.987Z", "activePower": 4.24, "cabinetName": "C区2排3号", "powerFactor": 0.86, "datacenterId": "dc-003", "apparentPower": 7.76, "datacenterName": "深圳坪山数据中心"}, {"id": "power-cab-sz-010", "energy": 1707.3, "current": 13.6, "voltage": 221.4, "cabinetId": "cab-sz-010", "timestamp": "2026-06-23T08:38:38.987Z", "activePower": 5.36, "cabinetName": "C区2排4号", "powerFactor": 0.93, "datacenterId": "dc-003", "apparentPower": 7.86, "datacenterName": "深圳坪山数据中心"}, {"id": "power-cab-sz-011", "energy": 1900.7, "current": 10.1, "voltage": 222, "cabinetId": "cab-sz-011", "timestamp": "2026-06-23T08:38:38.987Z", "activePower": 6.38, "cabinetName": "C区2排5号", "powerFactor": 0.93, "datacenterId": "dc-003", "apparentPower": 4.76, "datacenterName": "深圳坪山数据中心"}, {"id": "power-cab-sz-012", "energy": 1613.3, "current": 14.2, "voltage": 222.1, "cabinetId": "cab-sz-012", "timestamp": "2026-06-23T08:38:38.987Z", "activePower": 4.14, "cabinetName": "C区2排6号", "powerFactor": 0.87, "datacenterId": "dc-003", "apparentPower": 5.08, "datacenterName": "深圳坪山数据中心"}, {"id": "power-cab-sz-013", "energy": 1519.8, "current": 12.3, "voltage": 221, "cabinetId": "cab-sz-013", "timestamp": "2026-06-23T08:38:38.987Z", "activePower": 5.22, "cabinetName": "C区3排1号", "powerFactor": 0.92, "datacenterId": "dc-003", "apparentPower": 7.25, "datacenterName": "深圳坪山数据中心"}, {"id": "power-cab-sz-014", "energy": 1795.5, "current": 11.7, "voltage": 223.8, "cabinetId": "cab-sz-014", "timestamp": "2026-06-23T08:38:38.987Z", "activePower": 5.89, "cabinetName": "C区3排2号", "powerFactor": 0.94, "datacenterId": "dc-003", "apparentPower": 4, "datacenterName": "深圳坪山数据中心"}, {"id": "power-cab-sz-015", "energy": 1864.9, "current": 12.6, "voltage": 224.5, "cabinetId": "cab-sz-015", "timestamp": "2026-06-23T08:38:38.987Z", "activePower": 3.14, "cabinetName": "C区3排3号", "powerFactor": 0.95, "datacenterId": "dc-003", "apparentPower": 4.42, "datacenterName": "深圳坪山数据中心"}, {"id": "power-cab-sz-016", "energy": 1881.8, "current": 14.1, "voltage": 220.5, "cabinetId": "cab-sz-016", "timestamp": "2026-06-23T08:38:38.987Z", "activePower": 6.58, "cabinetName": "C区3排4号", "powerFactor": 0.89, "datacenterId": "dc-003", "apparentPower": 4.96, "datacenterName": "深圳坪山数据中心"}, {"id": "power-cab-sz-017", "energy": 1620.3, "current": 12.8, "voltage": 222, "cabinetId": "cab-sz-017", "timestamp": "2026-06-23T08:38:38.987Z", "activePower": 5.07, "cabinetName": "C区3排5号", "powerFactor": 0.89, "datacenterId": "dc-003", "apparentPower": 7.69, "datacenterName": "深圳坪山数据中心"}, {"id": "power-cab-sz-018", "energy": 1945.3, "current": 10.2, "voltage": 221.7, "cabinetId": "cab-sz-018", "timestamp": "2026-06-23T08:38:38.987Z", "activePower": 4.61, "cabinetName": "C区3排6号", "powerFactor": 0.94, "datacenterId": "dc-003", "apparentPower": 5.85, "datacenterName": "深圳坪山数据中心"}, {"id": "power-cab-cd-001", "energy": 1947.8, "current": 12.6, "voltage": 224.2, "cabinetId": "cab-cd-001", "timestamp": "2026-06-23T08:38:38.987Z", "activePower": 3.42, "cabinetName": "D区1排1号", "powerFactor": 0.85, "datacenterId": "dc-004", "apparentPower": 3.92, "datacenterName": "成都天府数据中心"}, {"id": "power-cab-cd-002", "energy": 1863.9, "current": 12.7, "voltage": 222.2, "cabinetId": "cab-cd-002", "timestamp": "2026-06-23T08:38:38.987Z", "activePower": 6.59, "cabinetName": "D区1排2号", "powerFactor": 0.86, "datacenterId": "dc-004", "apparentPower": 7.3, "datacenterName": "成都天府数据中心"}, {"id": "power-cab-cd-003", "energy": 1837.8, "current": 11.7, "voltage": 221.1, "cabinetId": "cab-cd-003", "timestamp": "2026-06-23T08:38:38.987Z", "activePower": 4.91, "cabinetName": "D区1排3号", "powerFactor": 0.87, "datacenterId": "dc-004", "apparentPower": 4.05, "datacenterName": "成都天府数据中心"}, {"id": "power-cab-cd-004", "energy": 1966.7, "current": 13.5, "voltage": 221.6, "cabinetId": "cab-cd-004", "timestamp": "2026-06-23T08:38:38.987Z", "activePower": 6.83, "cabinetName": "D区1排4号", "powerFactor": 0.95, "datacenterId": "dc-004", "apparentPower": 3.72, "datacenterName": "成都天府数据中心"}, {"id": "power-cab-cd-005", "energy": 1559.6, "current": 10.3, "voltage": 223.4, "cabinetId": "cab-cd-005", "timestamp": "2026-06-23T08:38:38.987Z", "activePower": 3.85, "cabinetName": "D区2排1号", "powerFactor": 0.88, "datacenterId": "dc-004", "apparentPower": 4.38, "datacenterName": "成都天府数据中心"}, {"id": "power-cab-cd-006", "energy": 1913.1, "current": 10.8, "voltage": 222.3, "cabinetId": "cab-cd-006", "timestamp": "2026-06-23T08:38:38.987Z", "activePower": 6.17, "cabinetName": "D区2排2号", "powerFactor": 0.85, "datacenterId": "dc-004", "apparentPower": 5.12, "datacenterName": "成都天府数据中心"}, {"id": "power-cab-cd-007", "energy": 1535.6, "current": 14.9, "voltage": 223.1, "cabinetId": "cab-cd-007", "timestamp": "2026-06-23T08:38:38.987Z", "activePower": 4.73, "cabinetName": "D区2排3号", "powerFactor": 0.92, "datacenterId": "dc-004", "apparentPower": 7.74, "datacenterName": "成都天府数据中心"}, {"id": "power-cab-cd-008", "energy": 1735.9, "current": 11.6, "voltage": 220.2, "cabinetId": "cab-cd-008", "timestamp": "2026-06-23T08:38:38.987Z", "activePower": 6.26, "cabinetName": "D区2排4号", "powerFactor": 0.93, "datacenterId": "dc-004", "apparentPower": 4.8, "datacenterName": "成都天府数据中心"}, {"id": "power-cab-cd-009", "energy": 1656, "current": 11.8, "voltage": 222.1, "cabinetId": "cab-cd-009", "timestamp": "2026-06-23T08:38:38.987Z", "activePower": 3.48, "cabinetName": "D区3排1号", "powerFactor": 0.92, "datacenterId": "dc-004", "apparentPower": 7.72, "datacenterName": "成都天府数据中心"}, {"id": "power-cab-cd-010", "energy": 1505.7, "current": 14.1, "voltage": 223, "cabinetId": "cab-cd-010", "timestamp": "2026-06-23T08:38:38.987Z", "activePower": 4.02, "cabinetName": "D区3排2号", "powerFactor": 0.92, "datacenterId": "dc-004", "apparentPower": 5.03, "datacenterName": "成都天府数据中心"}, {"id": "power-cab-cd-011", "energy": 1844.7, "current": 13.3, "voltage": 221.5, "cabinetId": "cab-cd-011", "timestamp": "2026-06-23T08:38:38.987Z", "activePower": 5.03, "cabinetName": "D区3排3号", "powerFactor": 0.9, "datacenterId": "dc-004", "apparentPower": 5.88, "datacenterName": "成都天府数据中心"}, {"id": "power-cab-cd-012", "energy": 1983.1, "current": 12.5, "voltage": 222.8, "cabinetId": "cab-cd-012", "timestamp": "2026-06-23T08:38:38.987Z", "activePower": 6.74, "cabinetName": "D区3排4号", "powerFactor": 0.87, "datacenterId": "dc-004", "apparentPower": 7.26, "datacenterName": "成都天府数据中心"}]	2026-06-23 08:38:42.107162+00
raw-environmentOverview	environmentOverview	{"avgPue": 1.42, "totalPower": 186.5, "avgHumidity": 45.2, "totalCabinets": 65, "avgTemperature": 24.5, "maxTemperature": 29.8, "minTemperature": 21.2, "normalCabinets": 60, "warningCabinets": 4, "criticalCabinets": 1, "maxTemperatureCabinet": "A区1排3号"}	2026-06-23 08:38:42.107162+00
raw-alerts	alerts	[{"id": "alert-001", "type": "temperature", "level": "critical", "value": 29.8, "ruleId": "rule-001", "source": "rule", "message": "机柜温度超过28℃阈值，当前温度29.8℃", "deviceId": "dev-003", "ruleName": "高温告警", "cabinetId": "cab-bj-003", "createdAt": "2026-01-17T09:30:00Z", "threshold": 28, "deviceName": "应用服务器-A1-1", "cabinetName": "A区1排3号", "acknowledged": false, "datacenterId": "dc-001", "datacenterName": "北京亦庄"}, {"id": "alert-002", "type": "port_status", "level": "warning", "value": 85, "source": "system", "message": "端口利用率超过80%", "deviceId": "dev-010", "cabinetId": "cab-bj-001", "createdAt": "2026-01-17T09:00:00Z", "threshold": 80, "deviceName": "核心交换机-B1", "cabinetName": "A区1排1号", "acknowledged": false, "datacenterId": "dc-001", "datacenterName": "北京亦庄"}, {"id": "alert-003", "type": "power", "level": "warning", "notes": "已通知设备负责人，计划迁移部分负载", "value": 6.8, "ruleId": "rule-003", "source": "rule", "message": "机柜功率超过额定的85%", "ruleName": "功率告警", "cabinetId": "cab-sz-001", "createdAt": "2026-01-17T08:45:00Z", "threshold": 6.5, "cabinetName": "C区1排1号", "acknowledged": true, "datacenterId": "dc-003", "acknowledgedAt": "2026-01-17T09:10:00Z", "acknowledgedBy": "张运维", "datacenterName": "深圳坪山"}, {"id": "alert-004", "type": "device_status", "level": "error", "notes": "网络闪断导致，已恢复", "source": "system", "message": "设备心跳超时，疑似离线", "deviceId": "dev-005", "cabinetId": "cab-bj-002", "createdAt": "2026-01-17T07:30:00Z", "deviceName": "数据库服务器-A1-1", "resolvedAt": "2026-01-17T08:00:00Z", "resolvedBy": "李运维", "cabinetName": "A区1排2号", "acknowledged": true, "datacenterId": "dc-001", "acknowledgedAt": "2026-01-17T07:35:00Z", "acknowledgedBy": "李运维", "datacenterName": "北京亦庄"}, {"id": "alert-005", "type": "capacity", "level": "info", "value": 92, "ruleId": "rule-005", "source": "rule", "message": "机柜U位使用率达到92%", "ruleName": "U位容量预警", "cabinetId": "cab-bj-001", "createdAt": "2026-01-16T14:00:00Z", "threshold": 90, "cabinetName": "A区1排1号", "acknowledged": true, "datacenterId": "dc-001", "acknowledgedAt": "2026-01-16T15:00:00Z", "acknowledgedBy": "王运维", "datacenterName": "北京亦庄"}, {"id": "alert-006", "type": "humidity", "level": "warning", "value": 35, "ruleId": "rule-002", "source": "rule", "message": "机柜湿度低于40%", "ruleName": "湿度告警", "cabinetId": "cab-sh-001", "createdAt": "2026-01-16T10:00:00Z", "threshold": 40, "cabinetName": "B区1排1号", "acknowledged": false, "datacenterId": "dc-002", "datacenterName": "上海嘉定"}]	2026-06-23 08:38:42.107162+00
raw-alertRules	alertRules	[{"id": "rule-001", "name": "高温告警", "type": "temperature", "enabled": true, "severity": "critical", "condition": {"metric": "temperature", "duration": 300, "operator": ">", "threshold": 28}, "createdAt": "2025-01-01T00:00:00Z", "updatedAt": "2026-01-10T08:00:00Z", "notification": {"sms": true, "email": true}}, {"id": "rule-002", "name": "湿度告警", "type": "humidity", "enabled": true, "severity": "warning", "condition": {"metric": "humidity", "duration": 600, "operator": "<", "threshold": 40}, "createdAt": "2025-01-01T00:00:00Z", "updatedAt": "2026-01-10T08:00:00Z", "notification": {"email": true}}, {"id": "rule-003", "name": "功率告警", "type": "power", "enabled": true, "severity": "warning", "condition": {"metric": "power_usage_percent", "operator": ">=", "threshold": 85}, "createdAt": "2025-01-01T00:00:00Z", "updatedAt": "2026-01-10T08:00:00Z", "notification": {"email": true}}, {"id": "rule-004", "name": "设备离线告警", "type": "device_status", "enabled": true, "severity": "error", "condition": {"metric": "device_status", "duration": 120, "operator": "==", "threshold": 0}, "createdAt": "2025-01-01T00:00:00Z", "updatedAt": "2026-01-10T08:00:00Z", "notification": {"sms": true, "email": true}}, {"id": "rule-005", "name": "U位容量预警", "type": "capacity", "enabled": true, "severity": "info", "condition": {"metric": "u_usage_percent", "operator": ">=", "threshold": 90}, "createdAt": "2025-01-01T00:00:00Z", "updatedAt": "2026-01-10T08:00:00Z", "notification": {"email": true}}, {"id": "rule-006", "name": "端口利用率告警", "type": "port_status", "enabled": false, "severity": "warning", "condition": {"metric": "port_usage_percent", "operator": ">", "threshold": 80}, "createdAt": "2025-06-01T00:00:00Z", "updatedAt": "2026-01-05T08:00:00Z", "notification": {"email": true}}]	2026-06-23 08:38:42.107162+00
raw-alertStats	alertStats	{"info": 1, "error": 1, "total": 6, "warning": 3, "critical": 1, "todayNew": 0, "avgResolveTime": 45, "unacknowledged": 3}	2026-06-23 08:38:42.107162+00
raw-dashboardStats	dashboardStats	{"uUsageRate": 0.65, "deviceCount": 12, "cabinetCount": 65, "errorDevices": 0, "recentAlerts": [{"id": "alert-001", "type": "port_usage", "level": "warning", "message": "端口利用率超过80%", "deviceId": "dev-010", "createdAt": "2024-12-05T09:00:00Z", "deviceName": "核心交换机-B1", "acknowledged": false}, {"id": "alert-002", "type": "maintenance", "level": "info", "message": "计划维护：存储系统固件升级", "deviceId": "dev-008", "createdAt": "2024-12-04T14:30:00Z", "deviceName": "核心存储-1", "acknowledged": true, "acknowledgedAt": "2024-12-04T15:00:00Z", "acknowledgedBy": "周存储"}, {"id": "alert-003", "type": "warranty", "level": "warning", "message": "设备质保将于90天后到期", "deviceId": "dev-001", "createdAt": "2024-12-03T08:00:00Z", "deviceName": "核心交换机-A1", "acknowledged": false}, {"id": "alert-004", "type": "device_online", "level": "info", "message": "设备上线", "deviceId": "dev-012", "createdAt": "2024-12-02T10:20:00Z", "deviceName": "GPU服务器-C1-1", "acknowledged": true, "acknowledgedAt": "2024-12-02T10:25:00Z", "acknowledgedBy": "钱AI"}], "onlineDevices": 11, "offlineDevices": 0, "warningDevices": 1, "connectionCount": 10, "datacenterCount": 4, "cabinetUsageRate": 1}	2026-06-23 08:38:42.107162+00
raw-deviceTrend	deviceTrend	[{"date": "2026-06-17", "error": 0, "online": 11, "offline": 0, "warning": 0}, {"date": "2026-06-18", "error": 0, "online": 10, "offline": 1, "warning": 1}, {"date": "2026-06-19", "error": 0, "online": 11, "offline": 1, "warning": 0}, {"date": "2026-06-20", "error": 0, "online": 11, "offline": 1, "warning": 0}, {"date": "2026-06-21", "error": 0, "online": 11, "offline": 0, "warning": 1}, {"date": "2026-06-22", "error": 0, "online": 11, "offline": 0, "warning": 0}, {"date": "2026-06-23", "error": 0, "online": 10, "offline": 1, "warning": 1}]	2026-06-23 08:38:42.107162+00
raw-deviceCategory	deviceCategory	[{"color": "#1890ff", "count": 5, "label": "交换机", "category": "switch"}, {"color": "#52c41a", "count": 4, "label": "服务器", "category": "server"}, {"color": "#faad14", "count": 1, "label": "存储", "category": "storage"}, {"color": "#f5222d", "count": 1, "label": "防火墙", "category": "firewall"}, {"color": "#722ed1", "count": 1, "label": "负载均衡", "category": "loadbalancer"}]	2026-06-23 08:38:42.107162+00
raw-datacenterLoad	datacenterLoad	[{"name": "北京亦庄", "powerUsage": 0.65, "deviceCount": 8, "cabinetUsage": 1, "datacenterId": "dc-001"}, {"name": "上海嘉定", "powerUsage": 0.58, "deviceCount": 2, "cabinetUsage": 1, "datacenterId": "dc-002"}, {"name": "深圳坪山", "powerUsage": 0.62, "deviceCount": 2, "cabinetUsage": 1, "datacenterId": "dc-003"}, {"name": "成都天府", "powerUsage": 0.25, "deviceCount": 0, "cabinetUsage": 1, "datacenterId": "dc-004"}]	2026-06-23 08:38:42.107162+00
raw-recentOperations	recentOperations	[{"id": "op-001", "type": "device_mount", "target": "GPU服务器-C1-1", "operator": "钱AI", "createdAt": "2024-12-05T10:30:00Z", "description": "设备上架"}, {"id": "op-002", "type": "port_config", "target": "接入交换机-A1-1 GE1/0/24", "operator": "张运维", "createdAt": "2024-12-05T09:15:00Z", "description": "VLAN配置变更: Access VLAN 100 -> 102"}, {"id": "op-003", "type": "connection_create", "target": "BJ-CAT6A-005", "operator": "张运维", "createdAt": "2024-12-04T16:20:00Z", "description": "创建网络连线"}, {"id": "op-004", "type": "device_update", "target": "核心交换机-B1", "operator": "李运维", "createdAt": "2024-12-04T14:00:00Z", "description": "更新设备管理IP"}, {"id": "op-005", "type": "cabinet_create", "target": "C区2排3号", "operator": "王运维", "createdAt": "2024-12-03T11:00:00Z", "description": "新增机柜"}]	2026-06-23 08:38:42.107162+00
raw-topologies	topologies	[{"edges": [{"type": "network", "source": "dev-001", "target": "dev-002"}, {"type": "network", "source": "dev-001", "target": "dev-006"}, {"type": "network", "source": "dev-006", "target": "dev-007"}, {"type": "network", "source": "dev-002", "target": "dev-003"}, {"type": "network", "source": "dev-002", "target": "dev-004"}, {"type": "network", "source": "dev-002", "target": "dev-005"}, {"type": "storage", "source": "dev-005", "target": "dev-008"}], "nodes": [{"x": 400, "y": 100, "id": "dev-001", "type": "switch", "label": "核心交换机-A1", "status": "online"}, {"x": 200, "y": 250, "id": "dev-002", "type": "switch", "label": "接入交换机-A1-1", "status": "online"}, {"x": 600, "y": 250, "id": "dev-006", "type": "firewall", "label": "边界防火墙-1", "status": "online"}, {"x": 600, "y": 400, "id": "dev-007", "type": "loadbalancer", "label": "负载均衡器-1", "status": "online"}, {"x": 100, "y": 400, "id": "dev-003", "type": "server", "label": "应用服务器-A1-1", "status": "online"}, {"x": 200, "y": 400, "id": "dev-004", "type": "server", "label": "应用服务器-A1-2", "status": "online"}, {"x": 300, "y": 400, "id": "dev-005", "type": "server", "label": "数据库服务器-A1-1", "status": "online"}, {"x": 300, "y": 550, "id": "dev-008", "type": "storage", "label": "核心存储-1", "status": "online"}], "datacenterId": "dc-001"}, {"edges": [{"type": "network", "source": "dev-001", "target": "dev-002"}, {"type": "network", "source": "dev-001", "target": "dev-006"}, {"type": "network", "source": "dev-006", "target": "dev-007"}, {"type": "network", "source": "dev-002", "target": "dev-003"}, {"type": "network", "source": "dev-002", "target": "dev-004"}, {"type": "network", "source": "dev-002", "target": "dev-005"}, {"type": "storage", "source": "dev-005", "target": "dev-008"}], "nodes": [{"x": 400, "y": 100, "id": "dev-001", "type": "switch", "label": "核心交换机-A1", "status": "online"}, {"x": 200, "y": 250, "id": "dev-002", "type": "switch", "label": "接入交换机-A1-1", "status": "online"}, {"x": 600, "y": 250, "id": "dev-006", "type": "firewall", "label": "边界防火墙-1", "status": "online"}, {"x": 600, "y": 400, "id": "dev-007", "type": "loadbalancer", "label": "负载均衡器-1", "status": "online"}, {"x": 100, "y": 400, "id": "dev-003", "type": "server", "label": "应用服务器-A1-1", "status": "online"}, {"x": 200, "y": 400, "id": "dev-004", "type": "server", "label": "应用服务器-A1-2", "status": "online"}, {"x": 300, "y": 400, "id": "dev-005", "type": "server", "label": "数据库服务器-A1-1", "status": "online"}, {"x": 300, "y": 550, "id": "dev-008", "type": "storage", "label": "核心存储-1", "status": "online"}], "datacenterId": "dc-002"}, {"edges": [{"type": "network", "source": "dev-001", "target": "dev-002"}, {"type": "network", "source": "dev-001", "target": "dev-006"}, {"type": "network", "source": "dev-006", "target": "dev-007"}, {"type": "network", "source": "dev-002", "target": "dev-003"}, {"type": "network", "source": "dev-002", "target": "dev-004"}, {"type": "network", "source": "dev-002", "target": "dev-005"}, {"type": "storage", "source": "dev-005", "target": "dev-008"}], "nodes": [{"x": 400, "y": 100, "id": "dev-001", "type": "switch", "label": "核心交换机-A1", "status": "online"}, {"x": 200, "y": 250, "id": "dev-002", "type": "switch", "label": "接入交换机-A1-1", "status": "online"}, {"x": 600, "y": 250, "id": "dev-006", "type": "firewall", "label": "边界防火墙-1", "status": "online"}, {"x": 600, "y": 400, "id": "dev-007", "type": "loadbalancer", "label": "负载均衡器-1", "status": "online"}, {"x": 100, "y": 400, "id": "dev-003", "type": "server", "label": "应用服务器-A1-1", "status": "online"}, {"x": 200, "y": 400, "id": "dev-004", "type": "server", "label": "应用服务器-A1-2", "status": "online"}, {"x": 300, "y": 400, "id": "dev-005", "type": "server", "label": "数据库服务器-A1-1", "status": "online"}, {"x": 300, "y": 550, "id": "dev-008", "type": "storage", "label": "核心存储-1", "status": "online"}], "datacenterId": "dc-003"}, {"edges": [{"type": "network", "source": "dev-001", "target": "dev-002"}, {"type": "network", "source": "dev-001", "target": "dev-006"}, {"type": "network", "source": "dev-006", "target": "dev-007"}, {"type": "network", "source": "dev-002", "target": "dev-003"}, {"type": "network", "source": "dev-002", "target": "dev-004"}, {"type": "network", "source": "dev-002", "target": "dev-005"}, {"type": "storage", "source": "dev-005", "target": "dev-008"}], "nodes": [{"x": 400, "y": 100, "id": "dev-001", "type": "switch", "label": "核心交换机-A1", "status": "online"}, {"x": 200, "y": 250, "id": "dev-002", "type": "switch", "label": "接入交换机-A1-1", "status": "online"}, {"x": 600, "y": 250, "id": "dev-006", "type": "firewall", "label": "边界防火墙-1", "status": "online"}, {"x": 600, "y": 400, "id": "dev-007", "type": "loadbalancer", "label": "负载均衡器-1", "status": "online"}, {"x": 100, "y": 400, "id": "dev-003", "type": "server", "label": "应用服务器-A1-1", "status": "online"}, {"x": 200, "y": 400, "id": "dev-004", "type": "server", "label": "应用服务器-A1-2", "status": "online"}, {"x": 300, "y": 400, "id": "dev-005", "type": "server", "label": "数据库服务器-A1-1", "status": "online"}, {"x": 300, "y": 550, "id": "dev-008", "type": "storage", "label": "核心存储-1", "status": "online"}], "datacenterId": "dc-004"}]	2026-06-23 08:38:42.107162+00
raw-layouts	layouts	[{"zones": [], "version": 1, "cabinets": [], "updatedAt": "2026-06-23T08:38:42.001Z", "facilities": [], "pxPerMeter": 50, "canvasWidth": 60, "canvasHeight": 40, "datacenterId": "dc-001"}, {"zones": [], "version": 1, "cabinets": [], "updatedAt": "2026-06-23T08:38:42.001Z", "facilities": [], "pxPerMeter": 50, "canvasWidth": 60, "canvasHeight": 40, "datacenterId": "dc-002"}, {"zones": [], "version": 1, "cabinets": [], "updatedAt": "2026-06-23T08:38:42.001Z", "facilities": [], "pxPerMeter": 50, "canvasWidth": 60, "canvasHeight": 40, "datacenterId": "dc-003"}, {"zones": [], "version": 1, "cabinets": [], "updatedAt": "2026-06-23T08:38:42.001Z", "facilities": [], "pxPerMeter": 50, "canvasWidth": 60, "canvasHeight": 40, "datacenterId": "dc-004"}]	2026-06-23 08:38:42.107162+00
\.


--
-- Data for Name: observation; Type: TABLE DATA; Schema: dcim_ontology_demo_20260623083835; Owner: -
--

COPY "__DCIM_TARGET_SCHEMA__".observation (id, target_type, target_id, sensor_id, sensor_position, metric, value_num, unit, observed_at, source_system, confidence) FROM stdin;
obs-sensor-cab-bj-001-front-temperature	cabinet	cab-bj-001	sensor-cab-bj-001-front	front	temperature	21.1000	Celsius	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-bj-001-front-humidity	cabinet	cab-bj-001	sensor-cab-bj-001-front	front	humidity	42.2000	Percent	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-bj-001-rear-temperature	cabinet	cab-bj-001	sensor-cab-bj-001-rear	rear	temperature	29.2000	Celsius	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-bj-001-rear-humidity	cabinet	cab-bj-001	sensor-cab-bj-001-rear	rear	humidity	46.0000	Percent	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-bj-001-top-temperature	cabinet	cab-bj-001	sensor-cab-bj-001-top	top	temperature	26.4000	Celsius	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-bj-001-top-humidity	cabinet	cab-bj-001	sensor-cab-bj-001-top	top	humidity	45.5000	Percent	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-bj-002-front-temperature	cabinet	cab-bj-002	sensor-cab-bj-002-front	front	temperature	21.1000	Celsius	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-bj-002-front-humidity	cabinet	cab-bj-002	sensor-cab-bj-002-front	front	humidity	49.8000	Percent	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-bj-002-rear-temperature	cabinet	cab-bj-002	sensor-cab-bj-002-rear	rear	temperature	24.8000	Celsius	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-bj-002-rear-humidity	cabinet	cab-bj-002	sensor-cab-bj-002-rear	rear	humidity	30.4000	Percent	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-bj-002-top-temperature	cabinet	cab-bj-002	sensor-cab-bj-002-top	top	temperature	23.2000	Celsius	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-bj-002-top-humidity	cabinet	cab-bj-002	sensor-cab-bj-002-top	top	humidity	42.9000	Percent	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-bj-003-front-temperature	cabinet	cab-bj-003	sensor-cab-bj-003-front	front	temperature	20.0000	Celsius	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-bj-003-front-humidity	cabinet	cab-bj-003	sensor-cab-bj-003-front	front	humidity	54.8000	Percent	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-bj-003-rear-temperature	cabinet	cab-bj-003	sensor-cab-bj-003-rear	rear	temperature	24.5000	Celsius	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-bj-003-rear-humidity	cabinet	cab-bj-003	sensor-cab-bj-003-rear	rear	humidity	45.4000	Percent	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-bj-003-top-temperature	cabinet	cab-bj-003	sensor-cab-bj-003-top	top	temperature	29.6000	Celsius	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-bj-003-top-humidity	cabinet	cab-bj-003	sensor-cab-bj-003-top	top	humidity	40.9000	Percent	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-bj-004-front-temperature	cabinet	cab-bj-004	sensor-cab-bj-004-front	front	temperature	26.6000	Celsius	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-bj-004-front-humidity	cabinet	cab-bj-004	sensor-cab-bj-004-front	front	humidity	35.3000	Percent	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-bj-004-rear-temperature	cabinet	cab-bj-004	sensor-cab-bj-004-rear	rear	temperature	30.9000	Celsius	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-bj-004-rear-humidity	cabinet	cab-bj-004	sensor-cab-bj-004-rear	rear	humidity	43.7000	Percent	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-bj-004-top-temperature	cabinet	cab-bj-004	sensor-cab-bj-004-top	top	temperature	24.0000	Celsius	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-bj-004-top-humidity	cabinet	cab-bj-004	sensor-cab-bj-004-top	top	humidity	50.3000	Percent	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-bj-005-front-temperature	cabinet	cab-bj-005	sensor-cab-bj-005-front	front	temperature	26.2000	Celsius	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-bj-005-front-humidity	cabinet	cab-bj-005	sensor-cab-bj-005-front	front	humidity	38.8000	Percent	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-bj-005-rear-temperature	cabinet	cab-bj-005	sensor-cab-bj-005-rear	rear	temperature	24.3000	Celsius	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-bj-005-rear-humidity	cabinet	cab-bj-005	sensor-cab-bj-005-rear	rear	humidity	44.2000	Percent	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-bj-005-top-temperature	cabinet	cab-bj-005	sensor-cab-bj-005-top	top	temperature	28.0000	Celsius	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-bj-005-top-humidity	cabinet	cab-bj-005	sensor-cab-bj-005-top	top	humidity	44.8000	Percent	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-bj-006-front-temperature	cabinet	cab-bj-006	sensor-cab-bj-006-front	front	temperature	26.2000	Celsius	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-bj-006-front-humidity	cabinet	cab-bj-006	sensor-cab-bj-006-front	front	humidity	51.0000	Percent	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-bj-006-rear-temperature	cabinet	cab-bj-006	sensor-cab-bj-006-rear	rear	temperature	26.8000	Celsius	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-bj-006-rear-humidity	cabinet	cab-bj-006	sensor-cab-bj-006-rear	rear	humidity	43.3000	Percent	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-bj-006-top-temperature	cabinet	cab-bj-006	sensor-cab-bj-006-top	top	temperature	27.8000	Celsius	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-bj-006-top-humidity	cabinet	cab-bj-006	sensor-cab-bj-006-top	top	humidity	35.7000	Percent	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-bj-007-front-temperature	cabinet	cab-bj-007	sensor-cab-bj-007-front	front	temperature	20.7000	Celsius	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-bj-007-front-humidity	cabinet	cab-bj-007	sensor-cab-bj-007-front	front	humidity	54.7000	Percent	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-bj-007-rear-temperature	cabinet	cab-bj-007	sensor-cab-bj-007-rear	rear	temperature	29.9000	Celsius	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-bj-007-rear-humidity	cabinet	cab-bj-007	sensor-cab-bj-007-rear	rear	humidity	41.2000	Percent	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-bj-007-top-temperature	cabinet	cab-bj-007	sensor-cab-bj-007-top	top	temperature	28.9000	Celsius	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-bj-007-top-humidity	cabinet	cab-bj-007	sensor-cab-bj-007-top	top	humidity	36.0000	Percent	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-bj-008-front-temperature	cabinet	cab-bj-008	sensor-cab-bj-008-front	front	temperature	20.4000	Celsius	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-bj-008-front-humidity	cabinet	cab-bj-008	sensor-cab-bj-008-front	front	humidity	35.2000	Percent	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-bj-008-rear-temperature	cabinet	cab-bj-008	sensor-cab-bj-008-rear	rear	temperature	29.7000	Celsius	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-bj-008-rear-humidity	cabinet	cab-bj-008	sensor-cab-bj-008-rear	rear	humidity	40.6000	Percent	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-bj-008-top-temperature	cabinet	cab-bj-008	sensor-cab-bj-008-top	top	temperature	23.9000	Celsius	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-bj-008-top-humidity	cabinet	cab-bj-008	sensor-cab-bj-008-top	top	humidity	32.6000	Percent	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-bj-009-front-temperature	cabinet	cab-bj-009	sensor-cab-bj-009-front	front	temperature	19.8000	Celsius	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-bj-009-front-humidity	cabinet	cab-bj-009	sensor-cab-bj-009-front	front	humidity	39.2000	Percent	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-bj-009-rear-temperature	cabinet	cab-bj-009	sensor-cab-bj-009-rear	rear	temperature	29.5000	Celsius	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-bj-009-rear-humidity	cabinet	cab-bj-009	sensor-cab-bj-009-rear	rear	humidity	44.4000	Percent	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-bj-009-top-temperature	cabinet	cab-bj-009	sensor-cab-bj-009-top	top	temperature	27.7000	Celsius	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-bj-009-top-humidity	cabinet	cab-bj-009	sensor-cab-bj-009-top	top	humidity	37.6000	Percent	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-bj-010-front-temperature	cabinet	cab-bj-010	sensor-cab-bj-010-front	front	temperature	21.7000	Celsius	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-bj-010-front-humidity	cabinet	cab-bj-010	sensor-cab-bj-010-front	front	humidity	48.0000	Percent	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-bj-010-rear-temperature	cabinet	cab-bj-010	sensor-cab-bj-010-rear	rear	temperature	26.3000	Celsius	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-bj-010-rear-humidity	cabinet	cab-bj-010	sensor-cab-bj-010-rear	rear	humidity	41.2000	Percent	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-bj-010-top-temperature	cabinet	cab-bj-010	sensor-cab-bj-010-top	top	temperature	25.2000	Celsius	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-bj-010-top-humidity	cabinet	cab-bj-010	sensor-cab-bj-010-top	top	humidity	34.7000	Percent	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-bj-011-front-temperature	cabinet	cab-bj-011	sensor-cab-bj-011-front	front	temperature	25.0000	Celsius	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-bj-011-front-humidity	cabinet	cab-bj-011	sensor-cab-bj-011-front	front	humidity	49.1000	Percent	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-bj-011-rear-temperature	cabinet	cab-bj-011	sensor-cab-bj-011-rear	rear	temperature	28.8000	Celsius	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-bj-011-rear-humidity	cabinet	cab-bj-011	sensor-cab-bj-011-rear	rear	humidity	41.1000	Percent	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-bj-011-top-temperature	cabinet	cab-bj-011	sensor-cab-bj-011-top	top	temperature	24.3000	Celsius	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-bj-011-top-humidity	cabinet	cab-bj-011	sensor-cab-bj-011-top	top	humidity	45.1000	Percent	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-bj-012-front-temperature	cabinet	cab-bj-012	sensor-cab-bj-012-front	front	temperature	21.8000	Celsius	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-bj-012-front-humidity	cabinet	cab-bj-012	sensor-cab-bj-012-front	front	humidity	35.7000	Percent	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-bj-012-rear-temperature	cabinet	cab-bj-012	sensor-cab-bj-012-rear	rear	temperature	25.7000	Celsius	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-bj-012-rear-humidity	cabinet	cab-bj-012	sensor-cab-bj-012-rear	rear	humidity	32.0000	Percent	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-bj-012-top-temperature	cabinet	cab-bj-012	sensor-cab-bj-012-top	top	temperature	23.5000	Celsius	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-bj-012-top-humidity	cabinet	cab-bj-012	sensor-cab-bj-012-top	top	humidity	32.8000	Percent	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-bj-013-front-temperature	cabinet	cab-bj-013	sensor-cab-bj-013-front	front	temperature	26.1000	Celsius	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-bj-013-front-humidity	cabinet	cab-bj-013	sensor-cab-bj-013-front	front	humidity	37.2000	Percent	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-bj-013-rear-temperature	cabinet	cab-bj-013	sensor-cab-bj-013-rear	rear	temperature	27.9000	Celsius	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-bj-013-rear-humidity	cabinet	cab-bj-013	sensor-cab-bj-013-rear	rear	humidity	38.2000	Percent	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-bj-013-top-temperature	cabinet	cab-bj-013	sensor-cab-bj-013-top	top	temperature	26.5000	Celsius	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-bj-013-top-humidity	cabinet	cab-bj-013	sensor-cab-bj-013-top	top	humidity	36.2000	Percent	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-bj-014-front-temperature	cabinet	cab-bj-014	sensor-cab-bj-014-front	front	temperature	22.7000	Celsius	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-bj-014-front-humidity	cabinet	cab-bj-014	sensor-cab-bj-014-front	front	humidity	47.7000	Percent	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-bj-014-rear-temperature	cabinet	cab-bj-014	sensor-cab-bj-014-rear	rear	temperature	28.5000	Celsius	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-bj-014-rear-humidity	cabinet	cab-bj-014	sensor-cab-bj-014-rear	rear	humidity	47.4000	Percent	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-bj-014-top-temperature	cabinet	cab-bj-014	sensor-cab-bj-014-top	top	temperature	27.8000	Celsius	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-bj-014-top-humidity	cabinet	cab-bj-014	sensor-cab-bj-014-top	top	humidity	43.8000	Percent	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-bj-015-front-temperature	cabinet	cab-bj-015	sensor-cab-bj-015-front	front	temperature	19.0000	Celsius	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-bj-015-front-humidity	cabinet	cab-bj-015	sensor-cab-bj-015-front	front	humidity	43.1000	Percent	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-bj-015-rear-temperature	cabinet	cab-bj-015	sensor-cab-bj-015-rear	rear	temperature	29.1000	Celsius	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-bj-015-rear-humidity	cabinet	cab-bj-015	sensor-cab-bj-015-rear	rear	humidity	35.4000	Percent	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-bj-015-top-temperature	cabinet	cab-bj-015	sensor-cab-bj-015-top	top	temperature	29.2000	Celsius	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-bj-015-top-humidity	cabinet	cab-bj-015	sensor-cab-bj-015-top	top	humidity	32.9000	Percent	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-bj-016-front-temperature	cabinet	cab-bj-016	sensor-cab-bj-016-front	front	temperature	23.2000	Celsius	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-bj-016-front-humidity	cabinet	cab-bj-016	sensor-cab-bj-016-front	front	humidity	37.4000	Percent	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-bj-016-rear-temperature	cabinet	cab-bj-016	sensor-cab-bj-016-rear	rear	temperature	30.0000	Celsius	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-bj-016-rear-humidity	cabinet	cab-bj-016	sensor-cab-bj-016-rear	rear	humidity	48.8000	Percent	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-bj-016-top-temperature	cabinet	cab-bj-016	sensor-cab-bj-016-top	top	temperature	22.9000	Celsius	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-bj-016-top-humidity	cabinet	cab-bj-016	sensor-cab-bj-016-top	top	humidity	35.9000	Percent	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-bj-017-front-temperature	cabinet	cab-bj-017	sensor-cab-bj-017-front	front	temperature	25.5000	Celsius	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-bj-017-front-humidity	cabinet	cab-bj-017	sensor-cab-bj-017-front	front	humidity	51.0000	Percent	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-bj-017-rear-temperature	cabinet	cab-bj-017	sensor-cab-bj-017-rear	rear	temperature	29.2000	Celsius	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-bj-017-rear-humidity	cabinet	cab-bj-017	sensor-cab-bj-017-rear	rear	humidity	49.9000	Percent	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-bj-017-top-temperature	cabinet	cab-bj-017	sensor-cab-bj-017-top	top	temperature	22.6000	Celsius	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-bj-017-top-humidity	cabinet	cab-bj-017	sensor-cab-bj-017-top	top	humidity	32.3000	Percent	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-bj-018-front-temperature	cabinet	cab-bj-018	sensor-cab-bj-018-front	front	temperature	25.4000	Celsius	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-bj-018-front-humidity	cabinet	cab-bj-018	sensor-cab-bj-018-front	front	humidity	50.7000	Percent	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-bj-018-rear-temperature	cabinet	cab-bj-018	sensor-cab-bj-018-rear	rear	temperature	26.6000	Celsius	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-bj-018-rear-humidity	cabinet	cab-bj-018	sensor-cab-bj-018-rear	rear	humidity	31.0000	Percent	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-bj-018-top-temperature	cabinet	cab-bj-018	sensor-cab-bj-018-top	top	temperature	24.9000	Celsius	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-bj-018-top-humidity	cabinet	cab-bj-018	sensor-cab-bj-018-top	top	humidity	38.2000	Percent	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-bj-019-front-temperature	cabinet	cab-bj-019	sensor-cab-bj-019-front	front	temperature	25.3000	Celsius	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-bj-019-front-humidity	cabinet	cab-bj-019	sensor-cab-bj-019-front	front	humidity	38.2000	Percent	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-bj-019-rear-temperature	cabinet	cab-bj-019	sensor-cab-bj-019-rear	rear	temperature	24.9000	Celsius	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-bj-019-rear-humidity	cabinet	cab-bj-019	sensor-cab-bj-019-rear	rear	humidity	34.7000	Percent	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-bj-019-top-temperature	cabinet	cab-bj-019	sensor-cab-bj-019-top	top	temperature	26.2000	Celsius	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-bj-019-top-humidity	cabinet	cab-bj-019	sensor-cab-bj-019-top	top	humidity	50.3000	Percent	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-bj-020-front-temperature	cabinet	cab-bj-020	sensor-cab-bj-020-front	front	temperature	21.2000	Celsius	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-bj-020-front-humidity	cabinet	cab-bj-020	sensor-cab-bj-020-front	front	humidity	46.2000	Percent	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-bj-020-rear-temperature	cabinet	cab-bj-020	sensor-cab-bj-020-rear	rear	temperature	30.3000	Celsius	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-bj-020-rear-humidity	cabinet	cab-bj-020	sensor-cab-bj-020-rear	rear	humidity	38.5000	Percent	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-bj-020-top-temperature	cabinet	cab-bj-020	sensor-cab-bj-020-top	top	temperature	22.6000	Celsius	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-bj-020-top-humidity	cabinet	cab-bj-020	sensor-cab-bj-020-top	top	humidity	47.7000	Percent	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sh-001-front-temperature	cabinet	cab-sh-001	sensor-cab-sh-001-front	front	temperature	24.2000	Celsius	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sh-001-front-humidity	cabinet	cab-sh-001	sensor-cab-sh-001-front	front	humidity	39.6000	Percent	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sh-001-rear-temperature	cabinet	cab-sh-001	sensor-cab-sh-001-rear	rear	temperature	31.6000	Celsius	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sh-001-rear-humidity	cabinet	cab-sh-001	sensor-cab-sh-001-rear	rear	humidity	41.4000	Percent	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sh-001-top-temperature	cabinet	cab-sh-001	sensor-cab-sh-001-top	top	temperature	28.7000	Celsius	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sh-001-top-humidity	cabinet	cab-sh-001	sensor-cab-sh-001-top	top	humidity	35.2000	Percent	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sh-002-front-temperature	cabinet	cab-sh-002	sensor-cab-sh-002-front	front	temperature	26.9000	Celsius	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sh-002-front-humidity	cabinet	cab-sh-002	sensor-cab-sh-002-front	front	humidity	50.9000	Percent	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sh-002-rear-temperature	cabinet	cab-sh-002	sensor-cab-sh-002-rear	rear	temperature	31.2000	Celsius	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sh-002-rear-humidity	cabinet	cab-sh-002	sensor-cab-sh-002-rear	rear	humidity	37.6000	Percent	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sh-002-top-temperature	cabinet	cab-sh-002	sensor-cab-sh-002-top	top	temperature	25.9000	Celsius	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sh-002-top-humidity	cabinet	cab-sh-002	sensor-cab-sh-002-top	top	humidity	45.8000	Percent	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sh-003-front-temperature	cabinet	cab-sh-003	sensor-cab-sh-003-front	front	temperature	20.3000	Celsius	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sh-003-front-humidity	cabinet	cab-sh-003	sensor-cab-sh-003-front	front	humidity	42.0000	Percent	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sh-003-rear-temperature	cabinet	cab-sh-003	sensor-cab-sh-003-rear	rear	temperature	30.9000	Celsius	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sh-003-rear-humidity	cabinet	cab-sh-003	sensor-cab-sh-003-rear	rear	humidity	41.9000	Percent	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sh-003-top-temperature	cabinet	cab-sh-003	sensor-cab-sh-003-top	top	temperature	22.6000	Celsius	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sh-003-top-humidity	cabinet	cab-sh-003	sensor-cab-sh-003-top	top	humidity	42.4000	Percent	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sh-004-front-temperature	cabinet	cab-sh-004	sensor-cab-sh-004-front	front	temperature	25.0000	Celsius	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sh-004-front-humidity	cabinet	cab-sh-004	sensor-cab-sh-004-front	front	humidity	53.7000	Percent	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sh-004-rear-temperature	cabinet	cab-sh-004	sensor-cab-sh-004-rear	rear	temperature	31.1000	Celsius	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sh-004-rear-humidity	cabinet	cab-sh-004	sensor-cab-sh-004-rear	rear	humidity	38.6000	Percent	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sh-004-top-temperature	cabinet	cab-sh-004	sensor-cab-sh-004-top	top	temperature	24.6000	Celsius	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sh-004-top-humidity	cabinet	cab-sh-004	sensor-cab-sh-004-top	top	humidity	37.8000	Percent	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sh-005-front-temperature	cabinet	cab-sh-005	sensor-cab-sh-005-front	front	temperature	21.7000	Celsius	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sh-005-front-humidity	cabinet	cab-sh-005	sensor-cab-sh-005-front	front	humidity	47.4000	Percent	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sh-005-rear-temperature	cabinet	cab-sh-005	sensor-cab-sh-005-rear	rear	temperature	29.8000	Celsius	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sh-005-rear-humidity	cabinet	cab-sh-005	sensor-cab-sh-005-rear	rear	humidity	42.9000	Percent	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sh-005-top-temperature	cabinet	cab-sh-005	sensor-cab-sh-005-top	top	temperature	24.3000	Celsius	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sh-005-top-humidity	cabinet	cab-sh-005	sensor-cab-sh-005-top	top	humidity	38.8000	Percent	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sh-006-front-temperature	cabinet	cab-sh-006	sensor-cab-sh-006-front	front	temperature	21.8000	Celsius	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sh-006-front-humidity	cabinet	cab-sh-006	sensor-cab-sh-006-front	front	humidity	42.4000	Percent	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sh-006-rear-temperature	cabinet	cab-sh-006	sensor-cab-sh-006-rear	rear	temperature	29.0000	Celsius	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sh-006-rear-humidity	cabinet	cab-sh-006	sensor-cab-sh-006-rear	rear	humidity	48.8000	Percent	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sh-006-top-temperature	cabinet	cab-sh-006	sensor-cab-sh-006-top	top	temperature	24.9000	Celsius	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sh-006-top-humidity	cabinet	cab-sh-006	sensor-cab-sh-006-top	top	humidity	36.1000	Percent	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sh-007-front-temperature	cabinet	cab-sh-007	sensor-cab-sh-007-front	front	temperature	25.3000	Celsius	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sh-007-front-humidity	cabinet	cab-sh-007	sensor-cab-sh-007-front	front	humidity	52.5000	Percent	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sh-007-rear-temperature	cabinet	cab-sh-007	sensor-cab-sh-007-rear	rear	temperature	29.9000	Celsius	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sh-007-rear-humidity	cabinet	cab-sh-007	sensor-cab-sh-007-rear	rear	humidity	47.2000	Percent	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sh-007-top-temperature	cabinet	cab-sh-007	sensor-cab-sh-007-top	top	temperature	23.7000	Celsius	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sh-007-top-humidity	cabinet	cab-sh-007	sensor-cab-sh-007-top	top	humidity	48.2000	Percent	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sh-008-front-temperature	cabinet	cab-sh-008	sensor-cab-sh-008-front	front	temperature	22.2000	Celsius	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sh-008-front-humidity	cabinet	cab-sh-008	sensor-cab-sh-008-front	front	humidity	37.8000	Percent	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sh-008-rear-temperature	cabinet	cab-sh-008	sensor-cab-sh-008-rear	rear	temperature	26.4000	Celsius	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sh-008-rear-humidity	cabinet	cab-sh-008	sensor-cab-sh-008-rear	rear	humidity	32.7000	Percent	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sh-008-top-temperature	cabinet	cab-sh-008	sensor-cab-sh-008-top	top	temperature	27.7000	Celsius	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sh-008-top-humidity	cabinet	cab-sh-008	sensor-cab-sh-008-top	top	humidity	47.5000	Percent	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sh-009-front-temperature	cabinet	cab-sh-009	sensor-cab-sh-009-front	front	temperature	22.2000	Celsius	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sh-009-front-humidity	cabinet	cab-sh-009	sensor-cab-sh-009-front	front	humidity	41.5000	Percent	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sh-009-rear-temperature	cabinet	cab-sh-009	sensor-cab-sh-009-rear	rear	temperature	26.3000	Celsius	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sh-009-rear-humidity	cabinet	cab-sh-009	sensor-cab-sh-009-rear	rear	humidity	35.1000	Percent	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sh-009-top-temperature	cabinet	cab-sh-009	sensor-cab-sh-009-top	top	temperature	28.1000	Celsius	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sh-009-top-humidity	cabinet	cab-sh-009	sensor-cab-sh-009-top	top	humidity	48.9000	Percent	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sh-010-front-temperature	cabinet	cab-sh-010	sensor-cab-sh-010-front	front	temperature	23.0000	Celsius	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sh-010-front-humidity	cabinet	cab-sh-010	sensor-cab-sh-010-front	front	humidity	48.2000	Percent	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sh-010-rear-temperature	cabinet	cab-sh-010	sensor-cab-sh-010-rear	rear	temperature	25.1000	Celsius	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sh-010-rear-humidity	cabinet	cab-sh-010	sensor-cab-sh-010-rear	rear	humidity	34.2000	Percent	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sh-010-top-temperature	cabinet	cab-sh-010	sensor-cab-sh-010-top	top	temperature	24.6000	Celsius	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sh-010-top-humidity	cabinet	cab-sh-010	sensor-cab-sh-010-top	top	humidity	51.7000	Percent	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sh-011-front-temperature	cabinet	cab-sh-011	sensor-cab-sh-011-front	front	temperature	21.1000	Celsius	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sh-011-front-humidity	cabinet	cab-sh-011	sensor-cab-sh-011-front	front	humidity	37.3000	Percent	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sh-011-rear-temperature	cabinet	cab-sh-011	sensor-cab-sh-011-rear	rear	temperature	24.5000	Celsius	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sh-011-rear-humidity	cabinet	cab-sh-011	sensor-cab-sh-011-rear	rear	humidity	38.9000	Percent	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sh-011-top-temperature	cabinet	cab-sh-011	sensor-cab-sh-011-top	top	temperature	23.2000	Celsius	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sh-011-top-humidity	cabinet	cab-sh-011	sensor-cab-sh-011-top	top	humidity	43.8000	Percent	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sh-012-front-temperature	cabinet	cab-sh-012	sensor-cab-sh-012-front	front	temperature	26.0000	Celsius	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sh-012-front-humidity	cabinet	cab-sh-012	sensor-cab-sh-012-front	front	humidity	36.3000	Percent	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sh-012-rear-temperature	cabinet	cab-sh-012	sensor-cab-sh-012-rear	rear	temperature	31.4000	Celsius	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sh-012-rear-humidity	cabinet	cab-sh-012	sensor-cab-sh-012-rear	rear	humidity	46.5000	Percent	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sh-012-top-temperature	cabinet	cab-sh-012	sensor-cab-sh-012-top	top	temperature	24.3000	Celsius	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sh-012-top-humidity	cabinet	cab-sh-012	sensor-cab-sh-012-top	top	humidity	37.3000	Percent	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sh-013-front-temperature	cabinet	cab-sh-013	sensor-cab-sh-013-front	front	temperature	20.9000	Celsius	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sh-013-front-humidity	cabinet	cab-sh-013	sensor-cab-sh-013-front	front	humidity	42.4000	Percent	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sh-013-rear-temperature	cabinet	cab-sh-013	sensor-cab-sh-013-rear	rear	temperature	26.4000	Celsius	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sh-013-rear-humidity	cabinet	cab-sh-013	sensor-cab-sh-013-rear	rear	humidity	39.9000	Percent	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sh-013-top-temperature	cabinet	cab-sh-013	sensor-cab-sh-013-top	top	temperature	29.7000	Celsius	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sh-013-top-humidity	cabinet	cab-sh-013	sensor-cab-sh-013-top	top	humidity	41.2000	Percent	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sh-014-front-temperature	cabinet	cab-sh-014	sensor-cab-sh-014-front	front	temperature	23.6000	Celsius	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sh-014-front-humidity	cabinet	cab-sh-014	sensor-cab-sh-014-front	front	humidity	43.1000	Percent	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sh-014-rear-temperature	cabinet	cab-sh-014	sensor-cab-sh-014-rear	rear	temperature	31.2000	Celsius	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sh-014-rear-humidity	cabinet	cab-sh-014	sensor-cab-sh-014-rear	rear	humidity	49.5000	Percent	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sh-014-top-temperature	cabinet	cab-sh-014	sensor-cab-sh-014-top	top	temperature	26.9000	Celsius	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sh-014-top-humidity	cabinet	cab-sh-014	sensor-cab-sh-014-top	top	humidity	48.2000	Percent	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sh-015-front-temperature	cabinet	cab-sh-015	sensor-cab-sh-015-front	front	temperature	21.5000	Celsius	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sh-015-front-humidity	cabinet	cab-sh-015	sensor-cab-sh-015-front	front	humidity	38.8000	Percent	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sh-015-rear-temperature	cabinet	cab-sh-015	sensor-cab-sh-015-rear	rear	temperature	29.3000	Celsius	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sh-015-rear-humidity	cabinet	cab-sh-015	sensor-cab-sh-015-rear	rear	humidity	38.7000	Percent	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sh-015-top-temperature	cabinet	cab-sh-015	sensor-cab-sh-015-top	top	temperature	25.9000	Celsius	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sh-015-top-humidity	cabinet	cab-sh-015	sensor-cab-sh-015-top	top	humidity	51.5000	Percent	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sz-001-front-temperature	cabinet	cab-sz-001	sensor-cab-sz-001-front	front	temperature	24.9000	Celsius	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sz-001-front-humidity	cabinet	cab-sz-001	sensor-cab-sz-001-front	front	humidity	40.6000	Percent	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sz-001-rear-temperature	cabinet	cab-sz-001	sensor-cab-sz-001-rear	rear	temperature	25.5000	Celsius	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sz-001-rear-humidity	cabinet	cab-sz-001	sensor-cab-sz-001-rear	rear	humidity	49.6000	Percent	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sz-001-top-temperature	cabinet	cab-sz-001	sensor-cab-sz-001-top	top	temperature	26.6000	Celsius	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sz-001-top-humidity	cabinet	cab-sz-001	sensor-cab-sz-001-top	top	humidity	38.0000	Percent	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sz-002-front-temperature	cabinet	cab-sz-002	sensor-cab-sz-002-front	front	temperature	26.3000	Celsius	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sz-002-front-humidity	cabinet	cab-sz-002	sensor-cab-sz-002-front	front	humidity	37.7000	Percent	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sz-002-rear-temperature	cabinet	cab-sz-002	sensor-cab-sz-002-rear	rear	temperature	27.7000	Celsius	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sz-002-rear-humidity	cabinet	cab-sz-002	sensor-cab-sz-002-rear	rear	humidity	47.3000	Percent	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sz-002-top-temperature	cabinet	cab-sz-002	sensor-cab-sz-002-top	top	temperature	23.6000	Celsius	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sz-002-top-humidity	cabinet	cab-sz-002	sensor-cab-sz-002-top	top	humidity	37.9000	Percent	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sz-003-front-temperature	cabinet	cab-sz-003	sensor-cab-sz-003-front	front	temperature	21.7000	Celsius	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sz-003-front-humidity	cabinet	cab-sz-003	sensor-cab-sz-003-front	front	humidity	49.6000	Percent	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sz-003-rear-temperature	cabinet	cab-sz-003	sensor-cab-sz-003-rear	rear	temperature	27.9000	Celsius	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sz-003-rear-humidity	cabinet	cab-sz-003	sensor-cab-sz-003-rear	rear	humidity	44.8000	Percent	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sz-003-top-temperature	cabinet	cab-sz-003	sensor-cab-sz-003-top	top	temperature	22.2000	Celsius	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sz-003-top-humidity	cabinet	cab-sz-003	sensor-cab-sz-003-top	top	humidity	44.9000	Percent	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sz-004-front-temperature	cabinet	cab-sz-004	sensor-cab-sz-004-front	front	temperature	21.5000	Celsius	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sz-004-front-humidity	cabinet	cab-sz-004	sensor-cab-sz-004-front	front	humidity	50.7000	Percent	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sz-004-rear-temperature	cabinet	cab-sz-004	sensor-cab-sz-004-rear	rear	temperature	29.6000	Celsius	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sz-004-rear-humidity	cabinet	cab-sz-004	sensor-cab-sz-004-rear	rear	humidity	32.2000	Percent	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sz-004-top-temperature	cabinet	cab-sz-004	sensor-cab-sz-004-top	top	temperature	27.4000	Celsius	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sz-004-top-humidity	cabinet	cab-sz-004	sensor-cab-sz-004-top	top	humidity	39.7000	Percent	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sz-005-front-temperature	cabinet	cab-sz-005	sensor-cab-sz-005-front	front	temperature	24.0000	Celsius	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sz-005-front-humidity	cabinet	cab-sz-005	sensor-cab-sz-005-front	front	humidity	50.3000	Percent	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sz-005-rear-temperature	cabinet	cab-sz-005	sensor-cab-sz-005-rear	rear	temperature	30.9000	Celsius	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sz-005-rear-humidity	cabinet	cab-sz-005	sensor-cab-sz-005-rear	rear	humidity	44.4000	Percent	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sz-005-top-temperature	cabinet	cab-sz-005	sensor-cab-sz-005-top	top	temperature	25.5000	Celsius	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sz-005-top-humidity	cabinet	cab-sz-005	sensor-cab-sz-005-top	top	humidity	34.5000	Percent	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sz-006-front-temperature	cabinet	cab-sz-006	sensor-cab-sz-006-front	front	temperature	20.2000	Celsius	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sz-006-front-humidity	cabinet	cab-sz-006	sensor-cab-sz-006-front	front	humidity	52.5000	Percent	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sz-006-rear-temperature	cabinet	cab-sz-006	sensor-cab-sz-006-rear	rear	temperature	24.2000	Celsius	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sz-006-rear-humidity	cabinet	cab-sz-006	sensor-cab-sz-006-rear	rear	humidity	41.0000	Percent	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sz-006-top-temperature	cabinet	cab-sz-006	sensor-cab-sz-006-top	top	temperature	25.7000	Celsius	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sz-006-top-humidity	cabinet	cab-sz-006	sensor-cab-sz-006-top	top	humidity	47.9000	Percent	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sz-007-front-temperature	cabinet	cab-sz-007	sensor-cab-sz-007-front	front	temperature	24.3000	Celsius	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sz-007-front-humidity	cabinet	cab-sz-007	sensor-cab-sz-007-front	front	humidity	40.9000	Percent	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sz-007-rear-temperature	cabinet	cab-sz-007	sensor-cab-sz-007-rear	rear	temperature	29.1000	Celsius	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sz-007-rear-humidity	cabinet	cab-sz-007	sensor-cab-sz-007-rear	rear	humidity	32.1000	Percent	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sz-007-top-temperature	cabinet	cab-sz-007	sensor-cab-sz-007-top	top	temperature	27.9000	Celsius	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sz-007-top-humidity	cabinet	cab-sz-007	sensor-cab-sz-007-top	top	humidity	40.6000	Percent	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sz-008-front-temperature	cabinet	cab-sz-008	sensor-cab-sz-008-front	front	temperature	24.2000	Celsius	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sz-008-front-humidity	cabinet	cab-sz-008	sensor-cab-sz-008-front	front	humidity	54.5000	Percent	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sz-008-rear-temperature	cabinet	cab-sz-008	sensor-cab-sz-008-rear	rear	temperature	32.0000	Celsius	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sz-008-rear-humidity	cabinet	cab-sz-008	sensor-cab-sz-008-rear	rear	humidity	40.5000	Percent	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sz-008-top-temperature	cabinet	cab-sz-008	sensor-cab-sz-008-top	top	temperature	24.2000	Celsius	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sz-008-top-humidity	cabinet	cab-sz-008	sensor-cab-sz-008-top	top	humidity	34.6000	Percent	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sz-009-front-temperature	cabinet	cab-sz-009	sensor-cab-sz-009-front	front	temperature	21.3000	Celsius	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sz-009-front-humidity	cabinet	cab-sz-009	sensor-cab-sz-009-front	front	humidity	45.6000	Percent	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sz-009-rear-temperature	cabinet	cab-sz-009	sensor-cab-sz-009-rear	rear	temperature	28.8000	Celsius	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sz-009-rear-humidity	cabinet	cab-sz-009	sensor-cab-sz-009-rear	rear	humidity	36.2000	Percent	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sz-009-top-temperature	cabinet	cab-sz-009	sensor-cab-sz-009-top	top	temperature	24.6000	Celsius	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sz-009-top-humidity	cabinet	cab-sz-009	sensor-cab-sz-009-top	top	humidity	33.1000	Percent	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sz-010-front-temperature	cabinet	cab-sz-010	sensor-cab-sz-010-front	front	temperature	20.0000	Celsius	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sz-010-front-humidity	cabinet	cab-sz-010	sensor-cab-sz-010-front	front	humidity	52.8000	Percent	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sz-010-rear-temperature	cabinet	cab-sz-010	sensor-cab-sz-010-rear	rear	temperature	24.1000	Celsius	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sz-010-rear-humidity	cabinet	cab-sz-010	sensor-cab-sz-010-rear	rear	humidity	36.3000	Percent	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sz-010-top-temperature	cabinet	cab-sz-010	sensor-cab-sz-010-top	top	temperature	28.2000	Celsius	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sz-010-top-humidity	cabinet	cab-sz-010	sensor-cab-sz-010-top	top	humidity	44.1000	Percent	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sz-011-front-temperature	cabinet	cab-sz-011	sensor-cab-sz-011-front	front	temperature	23.2000	Celsius	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sz-011-front-humidity	cabinet	cab-sz-011	sensor-cab-sz-011-front	front	humidity	41.2000	Percent	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sz-011-rear-temperature	cabinet	cab-sz-011	sensor-cab-sz-011-rear	rear	temperature	24.5000	Celsius	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sz-011-rear-humidity	cabinet	cab-sz-011	sensor-cab-sz-011-rear	rear	humidity	37.9000	Percent	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sz-011-top-temperature	cabinet	cab-sz-011	sensor-cab-sz-011-top	top	temperature	25.7000	Celsius	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sz-011-top-humidity	cabinet	cab-sz-011	sensor-cab-sz-011-top	top	humidity	33.4000	Percent	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sz-012-front-temperature	cabinet	cab-sz-012	sensor-cab-sz-012-front	front	temperature	20.6000	Celsius	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sz-012-front-humidity	cabinet	cab-sz-012	sensor-cab-sz-012-front	front	humidity	39.3000	Percent	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sz-012-rear-temperature	cabinet	cab-sz-012	sensor-cab-sz-012-rear	rear	temperature	30.8000	Celsius	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sz-012-rear-humidity	cabinet	cab-sz-012	sensor-cab-sz-012-rear	rear	humidity	34.8000	Percent	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sz-012-top-temperature	cabinet	cab-sz-012	sensor-cab-sz-012-top	top	temperature	24.8000	Celsius	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sz-012-top-humidity	cabinet	cab-sz-012	sensor-cab-sz-012-top	top	humidity	36.0000	Percent	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sz-013-front-temperature	cabinet	cab-sz-013	sensor-cab-sz-013-front	front	temperature	25.5000	Celsius	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sz-013-front-humidity	cabinet	cab-sz-013	sensor-cab-sz-013-front	front	humidity	40.4000	Percent	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sz-013-rear-temperature	cabinet	cab-sz-013	sensor-cab-sz-013-rear	rear	temperature	28.8000	Celsius	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sz-013-rear-humidity	cabinet	cab-sz-013	sensor-cab-sz-013-rear	rear	humidity	43.7000	Percent	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sz-013-top-temperature	cabinet	cab-sz-013	sensor-cab-sz-013-top	top	temperature	25.7000	Celsius	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sz-013-top-humidity	cabinet	cab-sz-013	sensor-cab-sz-013-top	top	humidity	51.4000	Percent	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sz-014-front-temperature	cabinet	cab-sz-014	sensor-cab-sz-014-front	front	temperature	22.2000	Celsius	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sz-014-front-humidity	cabinet	cab-sz-014	sensor-cab-sz-014-front	front	humidity	47.7000	Percent	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sz-014-rear-temperature	cabinet	cab-sz-014	sensor-cab-sz-014-rear	rear	temperature	29.3000	Celsius	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sz-014-rear-humidity	cabinet	cab-sz-014	sensor-cab-sz-014-rear	rear	humidity	42.7000	Percent	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sz-014-top-temperature	cabinet	cab-sz-014	sensor-cab-sz-014-top	top	temperature	23.2000	Celsius	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sz-014-top-humidity	cabinet	cab-sz-014	sensor-cab-sz-014-top	top	humidity	36.4000	Percent	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sz-015-front-temperature	cabinet	cab-sz-015	sensor-cab-sz-015-front	front	temperature	24.2000	Celsius	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sz-015-front-humidity	cabinet	cab-sz-015	sensor-cab-sz-015-front	front	humidity	35.5000	Percent	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sz-015-rear-temperature	cabinet	cab-sz-015	sensor-cab-sz-015-rear	rear	temperature	28.0000	Celsius	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sz-015-rear-humidity	cabinet	cab-sz-015	sensor-cab-sz-015-rear	rear	humidity	45.4000	Percent	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sz-015-top-temperature	cabinet	cab-sz-015	sensor-cab-sz-015-top	top	temperature	22.4000	Celsius	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sz-015-top-humidity	cabinet	cab-sz-015	sensor-cab-sz-015-top	top	humidity	49.2000	Percent	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sz-016-front-temperature	cabinet	cab-sz-016	sensor-cab-sz-016-front	front	temperature	21.7000	Celsius	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sz-016-front-humidity	cabinet	cab-sz-016	sensor-cab-sz-016-front	front	humidity	52.5000	Percent	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sz-016-rear-temperature	cabinet	cab-sz-016	sensor-cab-sz-016-rear	rear	temperature	27.7000	Celsius	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sz-016-rear-humidity	cabinet	cab-sz-016	sensor-cab-sz-016-rear	rear	humidity	33.5000	Percent	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sz-016-top-temperature	cabinet	cab-sz-016	sensor-cab-sz-016-top	top	temperature	26.2000	Celsius	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sz-016-top-humidity	cabinet	cab-sz-016	sensor-cab-sz-016-top	top	humidity	48.2000	Percent	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sz-017-front-temperature	cabinet	cab-sz-017	sensor-cab-sz-017-front	front	temperature	25.8000	Celsius	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sz-017-front-humidity	cabinet	cab-sz-017	sensor-cab-sz-017-front	front	humidity	41.4000	Percent	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sz-017-rear-temperature	cabinet	cab-sz-017	sensor-cab-sz-017-rear	rear	temperature	25.8000	Celsius	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sz-017-rear-humidity	cabinet	cab-sz-017	sensor-cab-sz-017-rear	rear	humidity	32.6000	Percent	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sz-017-top-temperature	cabinet	cab-sz-017	sensor-cab-sz-017-top	top	temperature	26.8000	Celsius	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sz-017-top-humidity	cabinet	cab-sz-017	sensor-cab-sz-017-top	top	humidity	40.5000	Percent	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sz-018-front-temperature	cabinet	cab-sz-018	sensor-cab-sz-018-front	front	temperature	20.7000	Celsius	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sz-018-front-humidity	cabinet	cab-sz-018	sensor-cab-sz-018-front	front	humidity	36.8000	Percent	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sz-018-rear-temperature	cabinet	cab-sz-018	sensor-cab-sz-018-rear	rear	temperature	25.8000	Celsius	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sz-018-rear-humidity	cabinet	cab-sz-018	sensor-cab-sz-018-rear	rear	humidity	49.1000	Percent	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sz-018-top-temperature	cabinet	cab-sz-018	sensor-cab-sz-018-top	top	temperature	27.6000	Celsius	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-sz-018-top-humidity	cabinet	cab-sz-018	sensor-cab-sz-018-top	top	humidity	47.7000	Percent	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-cd-001-front-temperature	cabinet	cab-cd-001	sensor-cab-cd-001-front	front	temperature	22.0000	Celsius	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-cd-001-front-humidity	cabinet	cab-cd-001	sensor-cab-cd-001-front	front	humidity	51.2000	Percent	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-cd-001-rear-temperature	cabinet	cab-cd-001	sensor-cab-cd-001-rear	rear	temperature	29.8000	Celsius	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-cd-001-rear-humidity	cabinet	cab-cd-001	sensor-cab-cd-001-rear	rear	humidity	34.3000	Percent	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-cd-001-top-temperature	cabinet	cab-cd-001	sensor-cab-cd-001-top	top	temperature	23.1000	Celsius	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-cd-001-top-humidity	cabinet	cab-cd-001	sensor-cab-cd-001-top	top	humidity	38.2000	Percent	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-cd-002-front-temperature	cabinet	cab-cd-002	sensor-cab-cd-002-front	front	temperature	24.5000	Celsius	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-cd-002-front-humidity	cabinet	cab-cd-002	sensor-cab-cd-002-front	front	humidity	41.1000	Percent	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-cd-002-rear-temperature	cabinet	cab-cd-002	sensor-cab-cd-002-rear	rear	temperature	30.7000	Celsius	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-cd-002-rear-humidity	cabinet	cab-cd-002	sensor-cab-cd-002-rear	rear	humidity	46.6000	Percent	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-cd-002-top-temperature	cabinet	cab-cd-002	sensor-cab-cd-002-top	top	temperature	23.9000	Celsius	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-cd-002-top-humidity	cabinet	cab-cd-002	sensor-cab-cd-002-top	top	humidity	51.2000	Percent	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-cd-003-front-temperature	cabinet	cab-cd-003	sensor-cab-cd-003-front	front	temperature	19.3000	Celsius	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-cd-003-front-humidity	cabinet	cab-cd-003	sensor-cab-cd-003-front	front	humidity	52.4000	Percent	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-cd-003-rear-temperature	cabinet	cab-cd-003	sensor-cab-cd-003-rear	rear	temperature	28.8000	Celsius	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-cd-003-rear-humidity	cabinet	cab-cd-003	sensor-cab-cd-003-rear	rear	humidity	46.9000	Percent	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-cd-003-top-temperature	cabinet	cab-cd-003	sensor-cab-cd-003-top	top	temperature	23.3000	Celsius	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-cd-003-top-humidity	cabinet	cab-cd-003	sensor-cab-cd-003-top	top	humidity	48.9000	Percent	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-cd-004-front-temperature	cabinet	cab-cd-004	sensor-cab-cd-004-front	front	temperature	26.8000	Celsius	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-cd-004-front-humidity	cabinet	cab-cd-004	sensor-cab-cd-004-front	front	humidity	40.5000	Percent	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-cd-004-rear-temperature	cabinet	cab-cd-004	sensor-cab-cd-004-rear	rear	temperature	27.0000	Celsius	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-cd-004-rear-humidity	cabinet	cab-cd-004	sensor-cab-cd-004-rear	rear	humidity	35.1000	Percent	2026-06-23 08:38:37.882+00	mock	1.000
obs-sensor-cab-cd-004-top-temperature	cabinet	cab-cd-004	sensor-cab-cd-004-top	top	temperature	24.0000	Celsius	2026-06-23 08:38:37.883+00	mock	1.000
obs-sensor-cab-cd-004-top-humidity	cabinet	cab-cd-004	sensor-cab-cd-004-top	top	humidity	34.0000	Percent	2026-06-23 08:38:37.883+00	mock	1.000
obs-sensor-cab-cd-005-front-temperature	cabinet	cab-cd-005	sensor-cab-cd-005-front	front	temperature	19.5000	Celsius	2026-06-23 08:38:37.883+00	mock	1.000
obs-sensor-cab-cd-005-front-humidity	cabinet	cab-cd-005	sensor-cab-cd-005-front	front	humidity	35.4000	Percent	2026-06-23 08:38:37.883+00	mock	1.000
obs-sensor-cab-cd-005-rear-temperature	cabinet	cab-cd-005	sensor-cab-cd-005-rear	rear	temperature	27.2000	Celsius	2026-06-23 08:38:37.883+00	mock	1.000
obs-sensor-cab-cd-005-rear-humidity	cabinet	cab-cd-005	sensor-cab-cd-005-rear	rear	humidity	33.6000	Percent	2026-06-23 08:38:37.883+00	mock	1.000
obs-sensor-cab-cd-005-top-temperature	cabinet	cab-cd-005	sensor-cab-cd-005-top	top	temperature	23.4000	Celsius	2026-06-23 08:38:37.883+00	mock	1.000
obs-sensor-cab-cd-005-top-humidity	cabinet	cab-cd-005	sensor-cab-cd-005-top	top	humidity	32.1000	Percent	2026-06-23 08:38:37.883+00	mock	1.000
obs-sensor-cab-cd-006-front-temperature	cabinet	cab-cd-006	sensor-cab-cd-006-front	front	temperature	23.5000	Celsius	2026-06-23 08:38:37.883+00	mock	1.000
obs-sensor-cab-cd-006-front-humidity	cabinet	cab-cd-006	sensor-cab-cd-006-front	front	humidity	38.6000	Percent	2026-06-23 08:38:37.883+00	mock	1.000
obs-sensor-cab-cd-006-rear-temperature	cabinet	cab-cd-006	sensor-cab-cd-006-rear	rear	temperature	26.8000	Celsius	2026-06-23 08:38:37.883+00	mock	1.000
obs-sensor-cab-cd-006-rear-humidity	cabinet	cab-cd-006	sensor-cab-cd-006-rear	rear	humidity	31.6000	Percent	2026-06-23 08:38:37.883+00	mock	1.000
obs-sensor-cab-cd-006-top-temperature	cabinet	cab-cd-006	sensor-cab-cd-006-top	top	temperature	25.0000	Celsius	2026-06-23 08:38:37.883+00	mock	1.000
obs-sensor-cab-cd-006-top-humidity	cabinet	cab-cd-006	sensor-cab-cd-006-top	top	humidity	49.0000	Percent	2026-06-23 08:38:37.883+00	mock	1.000
obs-sensor-cab-cd-007-front-temperature	cabinet	cab-cd-007	sensor-cab-cd-007-front	front	temperature	21.0000	Celsius	2026-06-23 08:38:37.883+00	mock	1.000
obs-sensor-cab-cd-007-front-humidity	cabinet	cab-cd-007	sensor-cab-cd-007-front	front	humidity	43.5000	Percent	2026-06-23 08:38:37.883+00	mock	1.000
obs-sensor-cab-cd-007-rear-temperature	cabinet	cab-cd-007	sensor-cab-cd-007-rear	rear	temperature	29.4000	Celsius	2026-06-23 08:38:37.883+00	mock	1.000
obs-sensor-cab-cd-007-rear-humidity	cabinet	cab-cd-007	sensor-cab-cd-007-rear	rear	humidity	41.7000	Percent	2026-06-23 08:38:37.883+00	mock	1.000
obs-sensor-cab-cd-007-top-temperature	cabinet	cab-cd-007	sensor-cab-cd-007-top	top	temperature	26.8000	Celsius	2026-06-23 08:38:37.883+00	mock	1.000
obs-sensor-cab-cd-007-top-humidity	cabinet	cab-cd-007	sensor-cab-cd-007-top	top	humidity	48.4000	Percent	2026-06-23 08:38:37.883+00	mock	1.000
obs-sensor-cab-cd-008-front-temperature	cabinet	cab-cd-008	sensor-cab-cd-008-front	front	temperature	26.5000	Celsius	2026-06-23 08:38:37.883+00	mock	1.000
obs-sensor-cab-cd-008-front-humidity	cabinet	cab-cd-008	sensor-cab-cd-008-front	front	humidity	50.3000	Percent	2026-06-23 08:38:37.883+00	mock	1.000
obs-sensor-cab-cd-008-rear-temperature	cabinet	cab-cd-008	sensor-cab-cd-008-rear	rear	temperature	27.6000	Celsius	2026-06-23 08:38:37.883+00	mock	1.000
obs-sensor-cab-cd-008-rear-humidity	cabinet	cab-cd-008	sensor-cab-cd-008-rear	rear	humidity	46.3000	Percent	2026-06-23 08:38:37.883+00	mock	1.000
obs-sensor-cab-cd-008-top-temperature	cabinet	cab-cd-008	sensor-cab-cd-008-top	top	temperature	26.8000	Celsius	2026-06-23 08:38:37.883+00	mock	1.000
obs-sensor-cab-cd-008-top-humidity	cabinet	cab-cd-008	sensor-cab-cd-008-top	top	humidity	34.9000	Percent	2026-06-23 08:38:37.883+00	mock	1.000
obs-sensor-cab-cd-009-front-temperature	cabinet	cab-cd-009	sensor-cab-cd-009-front	front	temperature	19.0000	Celsius	2026-06-23 08:38:37.883+00	mock	1.000
obs-sensor-cab-cd-009-front-humidity	cabinet	cab-cd-009	sensor-cab-cd-009-front	front	humidity	54.4000	Percent	2026-06-23 08:38:37.883+00	mock	1.000
obs-sensor-cab-cd-009-rear-temperature	cabinet	cab-cd-009	sensor-cab-cd-009-rear	rear	temperature	31.9000	Celsius	2026-06-23 08:38:37.883+00	mock	1.000
obs-sensor-cab-cd-009-rear-humidity	cabinet	cab-cd-009	sensor-cab-cd-009-rear	rear	humidity	33.5000	Percent	2026-06-23 08:38:37.883+00	mock	1.000
obs-sensor-cab-cd-009-top-temperature	cabinet	cab-cd-009	sensor-cab-cd-009-top	top	temperature	25.3000	Celsius	2026-06-23 08:38:37.883+00	mock	1.000
obs-sensor-cab-cd-009-top-humidity	cabinet	cab-cd-009	sensor-cab-cd-009-top	top	humidity	34.2000	Percent	2026-06-23 08:38:37.883+00	mock	1.000
obs-sensor-cab-cd-010-front-temperature	cabinet	cab-cd-010	sensor-cab-cd-010-front	front	temperature	24.7000	Celsius	2026-06-23 08:38:37.883+00	mock	1.000
obs-sensor-cab-cd-010-front-humidity	cabinet	cab-cd-010	sensor-cab-cd-010-front	front	humidity	51.9000	Percent	2026-06-23 08:38:37.883+00	mock	1.000
obs-sensor-cab-cd-010-rear-temperature	cabinet	cab-cd-010	sensor-cab-cd-010-rear	rear	temperature	27.3000	Celsius	2026-06-23 08:38:37.883+00	mock	1.000
obs-sensor-cab-cd-010-rear-humidity	cabinet	cab-cd-010	sensor-cab-cd-010-rear	rear	humidity	32.5000	Percent	2026-06-23 08:38:37.883+00	mock	1.000
obs-sensor-cab-cd-010-top-temperature	cabinet	cab-cd-010	sensor-cab-cd-010-top	top	temperature	24.7000	Celsius	2026-06-23 08:38:37.883+00	mock	1.000
obs-sensor-cab-cd-010-top-humidity	cabinet	cab-cd-010	sensor-cab-cd-010-top	top	humidity	36.1000	Percent	2026-06-23 08:38:37.883+00	mock	1.000
obs-sensor-cab-cd-011-front-temperature	cabinet	cab-cd-011	sensor-cab-cd-011-front	front	temperature	26.8000	Celsius	2026-06-23 08:38:37.883+00	mock	1.000
obs-sensor-cab-cd-011-front-humidity	cabinet	cab-cd-011	sensor-cab-cd-011-front	front	humidity	43.4000	Percent	2026-06-23 08:38:37.883+00	mock	1.000
obs-sensor-cab-cd-011-rear-temperature	cabinet	cab-cd-011	sensor-cab-cd-011-rear	rear	temperature	25.0000	Celsius	2026-06-23 08:38:37.883+00	mock	1.000
obs-sensor-cab-cd-011-rear-humidity	cabinet	cab-cd-011	sensor-cab-cd-011-rear	rear	humidity	40.7000	Percent	2026-06-23 08:38:37.883+00	mock	1.000
obs-sensor-cab-cd-011-top-temperature	cabinet	cab-cd-011	sensor-cab-cd-011-top	top	temperature	28.3000	Celsius	2026-06-23 08:38:37.883+00	mock	1.000
obs-sensor-cab-cd-011-top-humidity	cabinet	cab-cd-011	sensor-cab-cd-011-top	top	humidity	48.7000	Percent	2026-06-23 08:38:37.883+00	mock	1.000
obs-sensor-cab-cd-012-front-temperature	cabinet	cab-cd-012	sensor-cab-cd-012-front	front	temperature	19.7000	Celsius	2026-06-23 08:38:37.883+00	mock	1.000
obs-sensor-cab-cd-012-front-humidity	cabinet	cab-cd-012	sensor-cab-cd-012-front	front	humidity	42.8000	Percent	2026-06-23 08:38:37.883+00	mock	1.000
obs-sensor-cab-cd-012-rear-temperature	cabinet	cab-cd-012	sensor-cab-cd-012-rear	rear	temperature	25.7000	Celsius	2026-06-23 08:38:37.883+00	mock	1.000
obs-sensor-cab-cd-012-rear-humidity	cabinet	cab-cd-012	sensor-cab-cd-012-rear	rear	humidity	43.4000	Percent	2026-06-23 08:38:37.883+00	mock	1.000
obs-sensor-cab-cd-012-top-temperature	cabinet	cab-cd-012	sensor-cab-cd-012-top	top	temperature	22.2000	Celsius	2026-06-23 08:38:37.883+00	mock	1.000
obs-sensor-cab-cd-012-top-humidity	cabinet	cab-cd-012	sensor-cab-cd-012-top	top	humidity	33.7000	Percent	2026-06-23 08:38:37.883+00	mock	1.000
obs-power-cab-bj-001-active_power	cabinet	cab-bj-001	\N	\N	active_power	3.8800	kW	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-bj-001-apparent_power	cabinet	cab-bj-001	\N	\N	apparent_power	3.9600	kVA	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-bj-001-power_factor	cabinet	cab-bj-001	\N	\N	power_factor	0.9300	Ratio	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-bj-001-energy	cabinet	cab-bj-001	\N	\N	energy	1536.1000	kWh	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-bj-001-current	cabinet	cab-bj-001	\N	\N	current	11.7000	A	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-bj-001-voltage	cabinet	cab-bj-001	\N	\N	voltage	221.2000	V	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-bj-002-active_power	cabinet	cab-bj-002	\N	\N	active_power	5.3400	kW	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-bj-002-apparent_power	cabinet	cab-bj-002	\N	\N	apparent_power	6.6100	kVA	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-bj-002-power_factor	cabinet	cab-bj-002	\N	\N	power_factor	0.9500	Ratio	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-bj-002-energy	cabinet	cab-bj-002	\N	\N	energy	1503.1000	kWh	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-bj-002-current	cabinet	cab-bj-002	\N	\N	current	14.6000	A	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-bj-002-voltage	cabinet	cab-bj-002	\N	\N	voltage	220.9000	V	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-bj-003-active_power	cabinet	cab-bj-003	\N	\N	active_power	6.2600	kW	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-bj-003-apparent_power	cabinet	cab-bj-003	\N	\N	apparent_power	4.2400	kVA	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-bj-003-power_factor	cabinet	cab-bj-003	\N	\N	power_factor	0.9100	Ratio	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-bj-003-energy	cabinet	cab-bj-003	\N	\N	energy	1711.7000	kWh	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-bj-003-current	cabinet	cab-bj-003	\N	\N	current	11.8000	A	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-bj-003-voltage	cabinet	cab-bj-003	\N	\N	voltage	221.7000	V	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-bj-004-active_power	cabinet	cab-bj-004	\N	\N	active_power	6.4600	kW	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-bj-004-apparent_power	cabinet	cab-bj-004	\N	\N	apparent_power	6.7300	kVA	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-bj-004-power_factor	cabinet	cab-bj-004	\N	\N	power_factor	0.8900	Ratio	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-bj-004-energy	cabinet	cab-bj-004	\N	\N	energy	1932.5000	kWh	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-bj-004-current	cabinet	cab-bj-004	\N	\N	current	12.3000	A	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-bj-004-voltage	cabinet	cab-bj-004	\N	\N	voltage	220.7000	V	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-bj-005-active_power	cabinet	cab-bj-005	\N	\N	active_power	4.8400	kW	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-bj-005-apparent_power	cabinet	cab-bj-005	\N	\N	apparent_power	6.9400	kVA	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-bj-005-power_factor	cabinet	cab-bj-005	\N	\N	power_factor	0.8800	Ratio	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-bj-005-energy	cabinet	cab-bj-005	\N	\N	energy	1908.7000	kWh	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-bj-005-current	cabinet	cab-bj-005	\N	\N	current	14.5000	A	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-bj-005-voltage	cabinet	cab-bj-005	\N	\N	voltage	223.5000	V	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-bj-006-active_power	cabinet	cab-bj-006	\N	\N	active_power	5.4000	kW	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-bj-006-apparent_power	cabinet	cab-bj-006	\N	\N	apparent_power	7.9800	kVA	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-bj-006-power_factor	cabinet	cab-bj-006	\N	\N	power_factor	0.9100	Ratio	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-bj-006-energy	cabinet	cab-bj-006	\N	\N	energy	1991.3000	kWh	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-bj-006-current	cabinet	cab-bj-006	\N	\N	current	10.5000	A	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-bj-006-voltage	cabinet	cab-bj-006	\N	\N	voltage	223.7000	V	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-bj-007-active_power	cabinet	cab-bj-007	\N	\N	active_power	4.3400	kW	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-bj-007-apparent_power	cabinet	cab-bj-007	\N	\N	apparent_power	7.5100	kVA	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-bj-007-power_factor	cabinet	cab-bj-007	\N	\N	power_factor	0.8700	Ratio	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-bj-007-energy	cabinet	cab-bj-007	\N	\N	energy	1778.7000	kWh	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-bj-007-current	cabinet	cab-bj-007	\N	\N	current	12.1000	A	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-bj-007-voltage	cabinet	cab-bj-007	\N	\N	voltage	221.1000	V	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-bj-008-active_power	cabinet	cab-bj-008	\N	\N	active_power	6.2000	kW	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-bj-008-apparent_power	cabinet	cab-bj-008	\N	\N	apparent_power	6.2500	kVA	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-bj-008-power_factor	cabinet	cab-bj-008	\N	\N	power_factor	0.8700	Ratio	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-bj-008-energy	cabinet	cab-bj-008	\N	\N	energy	1536.3000	kWh	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-bj-008-current	cabinet	cab-bj-008	\N	\N	current	12.5000	A	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-bj-008-voltage	cabinet	cab-bj-008	\N	\N	voltage	223.7000	V	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-bj-009-active_power	cabinet	cab-bj-009	\N	\N	active_power	3.1800	kW	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-bj-009-apparent_power	cabinet	cab-bj-009	\N	\N	apparent_power	5.6000	kVA	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-bj-009-power_factor	cabinet	cab-bj-009	\N	\N	power_factor	0.9000	Ratio	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-bj-009-energy	cabinet	cab-bj-009	\N	\N	energy	1987.9000	kWh	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-bj-009-current	cabinet	cab-bj-009	\N	\N	current	13.2000	A	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-bj-009-voltage	cabinet	cab-bj-009	\N	\N	voltage	220.8000	V	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-bj-010-active_power	cabinet	cab-bj-010	\N	\N	active_power	6.5100	kW	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-bj-010-apparent_power	cabinet	cab-bj-010	\N	\N	apparent_power	5.6100	kVA	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-bj-010-power_factor	cabinet	cab-bj-010	\N	\N	power_factor	0.9300	Ratio	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-bj-010-energy	cabinet	cab-bj-010	\N	\N	energy	1833.5000	kWh	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-bj-010-current	cabinet	cab-bj-010	\N	\N	current	14.8000	A	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-bj-010-voltage	cabinet	cab-bj-010	\N	\N	voltage	220.8000	V	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-bj-011-active_power	cabinet	cab-bj-011	\N	\N	active_power	3.3700	kW	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-bj-011-apparent_power	cabinet	cab-bj-011	\N	\N	apparent_power	7.2700	kVA	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-bj-011-power_factor	cabinet	cab-bj-011	\N	\N	power_factor	0.9300	Ratio	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-bj-011-energy	cabinet	cab-bj-011	\N	\N	energy	1555.2000	kWh	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-bj-011-current	cabinet	cab-bj-011	\N	\N	current	14.7000	A	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-bj-011-voltage	cabinet	cab-bj-011	\N	\N	voltage	221.5000	V	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-bj-012-active_power	cabinet	cab-bj-012	\N	\N	active_power	4.7800	kW	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-bj-012-apparent_power	cabinet	cab-bj-012	\N	\N	apparent_power	7.9900	kVA	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-bj-012-power_factor	cabinet	cab-bj-012	\N	\N	power_factor	0.9300	Ratio	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-bj-012-energy	cabinet	cab-bj-012	\N	\N	energy	1517.4000	kWh	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-bj-012-current	cabinet	cab-bj-012	\N	\N	current	12.4000	A	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-bj-012-voltage	cabinet	cab-bj-012	\N	\N	voltage	220.2000	V	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-bj-013-active_power	cabinet	cab-bj-013	\N	\N	active_power	6.7200	kW	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-bj-013-apparent_power	cabinet	cab-bj-013	\N	\N	apparent_power	7.1300	kVA	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-bj-013-power_factor	cabinet	cab-bj-013	\N	\N	power_factor	0.9400	Ratio	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-bj-013-energy	cabinet	cab-bj-013	\N	\N	energy	1976.0000	kWh	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-bj-013-current	cabinet	cab-bj-013	\N	\N	current	10.6000	A	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-bj-013-voltage	cabinet	cab-bj-013	\N	\N	voltage	223.4000	V	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-bj-014-active_power	cabinet	cab-bj-014	\N	\N	active_power	4.9300	kW	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-bj-014-apparent_power	cabinet	cab-bj-014	\N	\N	apparent_power	3.6100	kVA	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-bj-014-power_factor	cabinet	cab-bj-014	\N	\N	power_factor	0.9200	Ratio	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-bj-014-energy	cabinet	cab-bj-014	\N	\N	energy	1679.8000	kWh	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-bj-014-current	cabinet	cab-bj-014	\N	\N	current	13.2000	A	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-bj-014-voltage	cabinet	cab-bj-014	\N	\N	voltage	224.3000	V	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-bj-015-active_power	cabinet	cab-bj-015	\N	\N	active_power	3.1400	kW	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-bj-015-apparent_power	cabinet	cab-bj-015	\N	\N	apparent_power	4.9100	kVA	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-bj-015-power_factor	cabinet	cab-bj-015	\N	\N	power_factor	0.8700	Ratio	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-bj-015-energy	cabinet	cab-bj-015	\N	\N	energy	1991.8000	kWh	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-bj-015-current	cabinet	cab-bj-015	\N	\N	current	11.3000	A	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-bj-015-voltage	cabinet	cab-bj-015	\N	\N	voltage	223.2000	V	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-bj-016-active_power	cabinet	cab-bj-016	\N	\N	active_power	6.1500	kW	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-bj-016-apparent_power	cabinet	cab-bj-016	\N	\N	apparent_power	7.7300	kVA	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-bj-016-power_factor	cabinet	cab-bj-016	\N	\N	power_factor	0.9300	Ratio	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-bj-016-energy	cabinet	cab-bj-016	\N	\N	energy	1741.5000	kWh	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-bj-016-current	cabinet	cab-bj-016	\N	\N	current	10.3000	A	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-bj-016-voltage	cabinet	cab-bj-016	\N	\N	voltage	224.4000	V	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-bj-017-active_power	cabinet	cab-bj-017	\N	\N	active_power	3.2300	kW	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-bj-017-apparent_power	cabinet	cab-bj-017	\N	\N	apparent_power	4.3600	kVA	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-bj-017-power_factor	cabinet	cab-bj-017	\N	\N	power_factor	0.9400	Ratio	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-bj-017-energy	cabinet	cab-bj-017	\N	\N	energy	1548.2000	kWh	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-bj-017-current	cabinet	cab-bj-017	\N	\N	current	14.8000	A	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-bj-017-voltage	cabinet	cab-bj-017	\N	\N	voltage	222.7000	V	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-bj-018-active_power	cabinet	cab-bj-018	\N	\N	active_power	3.7100	kW	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-bj-018-apparent_power	cabinet	cab-bj-018	\N	\N	apparent_power	4.5800	kVA	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-bj-018-power_factor	cabinet	cab-bj-018	\N	\N	power_factor	0.9200	Ratio	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-bj-018-energy	cabinet	cab-bj-018	\N	\N	energy	1937.6000	kWh	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-bj-018-current	cabinet	cab-bj-018	\N	\N	current	13.8000	A	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-bj-018-voltage	cabinet	cab-bj-018	\N	\N	voltage	222.3000	V	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-bj-019-active_power	cabinet	cab-bj-019	\N	\N	active_power	3.6000	kW	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-bj-019-apparent_power	cabinet	cab-bj-019	\N	\N	apparent_power	5.1300	kVA	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-bj-019-power_factor	cabinet	cab-bj-019	\N	\N	power_factor	0.9200	Ratio	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-bj-019-energy	cabinet	cab-bj-019	\N	\N	energy	1710.8000	kWh	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-bj-019-current	cabinet	cab-bj-019	\N	\N	current	10.1000	A	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-bj-019-voltage	cabinet	cab-bj-019	\N	\N	voltage	222.3000	V	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-bj-020-active_power	cabinet	cab-bj-020	\N	\N	active_power	6.3300	kW	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-bj-020-apparent_power	cabinet	cab-bj-020	\N	\N	apparent_power	7.9100	kVA	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-bj-020-power_factor	cabinet	cab-bj-020	\N	\N	power_factor	0.9500	Ratio	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-bj-020-energy	cabinet	cab-bj-020	\N	\N	energy	1890.4000	kWh	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-bj-020-current	cabinet	cab-bj-020	\N	\N	current	11.0000	A	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-bj-020-voltage	cabinet	cab-bj-020	\N	\N	voltage	224.5000	V	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-sh-001-active_power	cabinet	cab-sh-001	\N	\N	active_power	4.0400	kW	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-sh-001-apparent_power	cabinet	cab-sh-001	\N	\N	apparent_power	3.5100	kVA	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-sh-001-power_factor	cabinet	cab-sh-001	\N	\N	power_factor	0.8700	Ratio	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-sh-001-energy	cabinet	cab-sh-001	\N	\N	energy	1689.9000	kWh	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-sh-001-current	cabinet	cab-sh-001	\N	\N	current	11.8000	A	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-sh-001-voltage	cabinet	cab-sh-001	\N	\N	voltage	224.0000	V	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-sh-002-active_power	cabinet	cab-sh-002	\N	\N	active_power	4.5400	kW	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-sh-002-apparent_power	cabinet	cab-sh-002	\N	\N	apparent_power	6.2400	kVA	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-sh-002-power_factor	cabinet	cab-sh-002	\N	\N	power_factor	0.8700	Ratio	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-sh-002-energy	cabinet	cab-sh-002	\N	\N	energy	1509.6000	kWh	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-sh-002-current	cabinet	cab-sh-002	\N	\N	current	11.8000	A	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-sh-002-voltage	cabinet	cab-sh-002	\N	\N	voltage	222.1000	V	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-sh-003-active_power	cabinet	cab-sh-003	\N	\N	active_power	6.3200	kW	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-sh-003-apparent_power	cabinet	cab-sh-003	\N	\N	apparent_power	3.9800	kVA	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-sh-003-power_factor	cabinet	cab-sh-003	\N	\N	power_factor	0.9300	Ratio	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-sh-003-energy	cabinet	cab-sh-003	\N	\N	energy	1627.1000	kWh	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-sh-003-current	cabinet	cab-sh-003	\N	\N	current	13.5000	A	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-sh-003-voltage	cabinet	cab-sh-003	\N	\N	voltage	221.8000	V	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-sh-004-active_power	cabinet	cab-sh-004	\N	\N	active_power	3.5300	kW	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-sh-004-apparent_power	cabinet	cab-sh-004	\N	\N	apparent_power	4.4900	kVA	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-sh-004-power_factor	cabinet	cab-sh-004	\N	\N	power_factor	0.8700	Ratio	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-sh-004-energy	cabinet	cab-sh-004	\N	\N	energy	1615.0000	kWh	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-sh-004-current	cabinet	cab-sh-004	\N	\N	current	14.9000	A	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-sh-004-voltage	cabinet	cab-sh-004	\N	\N	voltage	224.2000	V	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-sh-005-active_power	cabinet	cab-sh-005	\N	\N	active_power	5.1700	kW	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-sh-005-apparent_power	cabinet	cab-sh-005	\N	\N	apparent_power	5.1200	kVA	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-sh-005-power_factor	cabinet	cab-sh-005	\N	\N	power_factor	0.8700	Ratio	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-sh-005-energy	cabinet	cab-sh-005	\N	\N	energy	1789.6000	kWh	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-sh-005-current	cabinet	cab-sh-005	\N	\N	current	11.9000	A	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-sh-005-voltage	cabinet	cab-sh-005	\N	\N	voltage	220.1000	V	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-sh-006-active_power	cabinet	cab-sh-006	\N	\N	active_power	6.3500	kW	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-sh-006-apparent_power	cabinet	cab-sh-006	\N	\N	apparent_power	6.3500	kVA	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-sh-006-power_factor	cabinet	cab-sh-006	\N	\N	power_factor	0.9000	Ratio	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-sh-006-energy	cabinet	cab-sh-006	\N	\N	energy	1638.6000	kWh	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-sh-006-current	cabinet	cab-sh-006	\N	\N	current	14.1000	A	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-sh-006-voltage	cabinet	cab-sh-006	\N	\N	voltage	221.1000	V	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-sh-007-active_power	cabinet	cab-sh-007	\N	\N	active_power	6.7900	kW	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-sh-007-apparent_power	cabinet	cab-sh-007	\N	\N	apparent_power	5.4400	kVA	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-sh-007-power_factor	cabinet	cab-sh-007	\N	\N	power_factor	0.9400	Ratio	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-sh-007-energy	cabinet	cab-sh-007	\N	\N	energy	1689.3000	kWh	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-sh-007-current	cabinet	cab-sh-007	\N	\N	current	11.7000	A	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-sh-007-voltage	cabinet	cab-sh-007	\N	\N	voltage	223.8000	V	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-sh-008-active_power	cabinet	cab-sh-008	\N	\N	active_power	5.6100	kW	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-sh-008-apparent_power	cabinet	cab-sh-008	\N	\N	apparent_power	4.2300	kVA	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-sh-008-power_factor	cabinet	cab-sh-008	\N	\N	power_factor	0.9500	Ratio	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-sh-008-energy	cabinet	cab-sh-008	\N	\N	energy	1613.2000	kWh	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-sh-008-current	cabinet	cab-sh-008	\N	\N	current	14.0000	A	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-sh-008-voltage	cabinet	cab-sh-008	\N	\N	voltage	223.6000	V	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-sh-009-active_power	cabinet	cab-sh-009	\N	\N	active_power	5.3300	kW	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-sh-009-apparent_power	cabinet	cab-sh-009	\N	\N	apparent_power	4.2200	kVA	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-sh-009-power_factor	cabinet	cab-sh-009	\N	\N	power_factor	0.8800	Ratio	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-sh-009-energy	cabinet	cab-sh-009	\N	\N	energy	1893.8000	kWh	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-sh-009-current	cabinet	cab-sh-009	\N	\N	current	13.4000	A	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-sh-009-voltage	cabinet	cab-sh-009	\N	\N	voltage	222.2000	V	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-sh-010-active_power	cabinet	cab-sh-010	\N	\N	active_power	3.2400	kW	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-sh-010-apparent_power	cabinet	cab-sh-010	\N	\N	apparent_power	4.3500	kVA	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-sh-010-power_factor	cabinet	cab-sh-010	\N	\N	power_factor	0.9100	Ratio	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-sh-010-energy	cabinet	cab-sh-010	\N	\N	energy	1553.6000	kWh	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-sh-010-current	cabinet	cab-sh-010	\N	\N	current	13.5000	A	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-sh-010-voltage	cabinet	cab-sh-010	\N	\N	voltage	222.1000	V	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-sh-011-active_power	cabinet	cab-sh-011	\N	\N	active_power	6.6600	kW	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-sh-011-apparent_power	cabinet	cab-sh-011	\N	\N	apparent_power	5.3200	kVA	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-sh-011-power_factor	cabinet	cab-sh-011	\N	\N	power_factor	0.8500	Ratio	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-sh-011-energy	cabinet	cab-sh-011	\N	\N	energy	1860.4000	kWh	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-sh-011-current	cabinet	cab-sh-011	\N	\N	current	10.4000	A	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-sh-011-voltage	cabinet	cab-sh-011	\N	\N	voltage	222.4000	V	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-sh-012-active_power	cabinet	cab-sh-012	\N	\N	active_power	6.8600	kW	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-sh-012-apparent_power	cabinet	cab-sh-012	\N	\N	apparent_power	6.9100	kVA	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-sh-012-power_factor	cabinet	cab-sh-012	\N	\N	power_factor	0.9000	Ratio	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-sh-012-energy	cabinet	cab-sh-012	\N	\N	energy	1532.7000	kWh	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-sh-012-current	cabinet	cab-sh-012	\N	\N	current	12.7000	A	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-sh-012-voltage	cabinet	cab-sh-012	\N	\N	voltage	223.5000	V	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-sh-013-active_power	cabinet	cab-sh-013	\N	\N	active_power	3.2900	kW	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-sh-013-apparent_power	cabinet	cab-sh-013	\N	\N	apparent_power	5.9000	kVA	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-sh-013-power_factor	cabinet	cab-sh-013	\N	\N	power_factor	0.8900	Ratio	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-sh-013-energy	cabinet	cab-sh-013	\N	\N	energy	1657.9000	kWh	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-sh-013-current	cabinet	cab-sh-013	\N	\N	current	11.5000	A	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-sh-013-voltage	cabinet	cab-sh-013	\N	\N	voltage	220.3000	V	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-sh-014-active_power	cabinet	cab-sh-014	\N	\N	active_power	6.3500	kW	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-sh-014-apparent_power	cabinet	cab-sh-014	\N	\N	apparent_power	3.9200	kVA	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-sh-014-power_factor	cabinet	cab-sh-014	\N	\N	power_factor	0.8600	Ratio	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-sh-014-energy	cabinet	cab-sh-014	\N	\N	energy	1930.0000	kWh	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-sh-014-current	cabinet	cab-sh-014	\N	\N	current	11.8000	A	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-sh-014-voltage	cabinet	cab-sh-014	\N	\N	voltage	223.6000	V	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-sh-015-active_power	cabinet	cab-sh-015	\N	\N	active_power	5.2200	kW	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-sh-015-apparent_power	cabinet	cab-sh-015	\N	\N	apparent_power	5.5600	kVA	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-sh-015-power_factor	cabinet	cab-sh-015	\N	\N	power_factor	0.8500	Ratio	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-sh-015-energy	cabinet	cab-sh-015	\N	\N	energy	1628.3000	kWh	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-sh-015-current	cabinet	cab-sh-015	\N	\N	current	10.1000	A	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-sh-015-voltage	cabinet	cab-sh-015	\N	\N	voltage	224.8000	V	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-sz-001-active_power	cabinet	cab-sz-001	\N	\N	active_power	5.6800	kW	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-sz-001-apparent_power	cabinet	cab-sz-001	\N	\N	apparent_power	7.0600	kVA	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-sz-001-power_factor	cabinet	cab-sz-001	\N	\N	power_factor	0.9200	Ratio	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-sz-001-energy	cabinet	cab-sz-001	\N	\N	energy	1915.0000	kWh	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-sz-001-current	cabinet	cab-sz-001	\N	\N	current	10.1000	A	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-sz-001-voltage	cabinet	cab-sz-001	\N	\N	voltage	221.1000	V	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-sz-002-active_power	cabinet	cab-sz-002	\N	\N	active_power	5.4300	kW	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-sz-002-apparent_power	cabinet	cab-sz-002	\N	\N	apparent_power	4.9400	kVA	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-sz-002-power_factor	cabinet	cab-sz-002	\N	\N	power_factor	0.8800	Ratio	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-sz-002-energy	cabinet	cab-sz-002	\N	\N	energy	1772.3000	kWh	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-sz-002-current	cabinet	cab-sz-002	\N	\N	current	11.9000	A	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-sz-002-voltage	cabinet	cab-sz-002	\N	\N	voltage	225.0000	V	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-sz-003-active_power	cabinet	cab-sz-003	\N	\N	active_power	3.3400	kW	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-sz-003-apparent_power	cabinet	cab-sz-003	\N	\N	apparent_power	5.5400	kVA	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-sz-003-power_factor	cabinet	cab-sz-003	\N	\N	power_factor	0.9400	Ratio	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-sz-003-energy	cabinet	cab-sz-003	\N	\N	energy	1814.2000	kWh	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-sz-003-current	cabinet	cab-sz-003	\N	\N	current	12.4000	A	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-sz-003-voltage	cabinet	cab-sz-003	\N	\N	voltage	221.6000	V	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-sz-004-active_power	cabinet	cab-sz-004	\N	\N	active_power	3.2500	kW	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-sz-004-apparent_power	cabinet	cab-sz-004	\N	\N	apparent_power	7.9000	kVA	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-sz-004-power_factor	cabinet	cab-sz-004	\N	\N	power_factor	0.9200	Ratio	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-sz-004-energy	cabinet	cab-sz-004	\N	\N	energy	1775.0000	kWh	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-sz-004-current	cabinet	cab-sz-004	\N	\N	current	11.8000	A	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-sz-004-voltage	cabinet	cab-sz-004	\N	\N	voltage	221.4000	V	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-sz-005-active_power	cabinet	cab-sz-005	\N	\N	active_power	4.2800	kW	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-sz-005-apparent_power	cabinet	cab-sz-005	\N	\N	apparent_power	4.2700	kVA	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-sz-005-power_factor	cabinet	cab-sz-005	\N	\N	power_factor	0.9500	Ratio	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-sz-005-energy	cabinet	cab-sz-005	\N	\N	energy	1563.3000	kWh	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-sz-005-current	cabinet	cab-sz-005	\N	\N	current	10.8000	A	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-sz-005-voltage	cabinet	cab-sz-005	\N	\N	voltage	220.6000	V	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-sz-006-active_power	cabinet	cab-sz-006	\N	\N	active_power	6.7900	kW	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-sz-006-apparent_power	cabinet	cab-sz-006	\N	\N	apparent_power	7.3100	kVA	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-sz-006-power_factor	cabinet	cab-sz-006	\N	\N	power_factor	0.9100	Ratio	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-sz-006-energy	cabinet	cab-sz-006	\N	\N	energy	1783.4000	kWh	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-sz-006-current	cabinet	cab-sz-006	\N	\N	current	12.4000	A	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-sz-006-voltage	cabinet	cab-sz-006	\N	\N	voltage	222.1000	V	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-sz-007-active_power	cabinet	cab-sz-007	\N	\N	active_power	3.4200	kW	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-sz-007-apparent_power	cabinet	cab-sz-007	\N	\N	apparent_power	4.1500	kVA	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-sz-007-power_factor	cabinet	cab-sz-007	\N	\N	power_factor	0.9300	Ratio	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-sz-007-energy	cabinet	cab-sz-007	\N	\N	energy	1994.3000	kWh	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-sz-007-current	cabinet	cab-sz-007	\N	\N	current	10.9000	A	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-sz-007-voltage	cabinet	cab-sz-007	\N	\N	voltage	221.9000	V	2026-06-23 08:38:38.986+00	mock	1.000
obs-power-cab-sz-008-active_power	cabinet	cab-sz-008	\N	\N	active_power	4.9100	kW	2026-06-23 08:38:38.987+00	mock	1.000
obs-power-cab-sz-008-apparent_power	cabinet	cab-sz-008	\N	\N	apparent_power	7.3000	kVA	2026-06-23 08:38:38.987+00	mock	1.000
obs-power-cab-sz-008-power_factor	cabinet	cab-sz-008	\N	\N	power_factor	0.8900	Ratio	2026-06-23 08:38:38.987+00	mock	1.000
obs-power-cab-sz-008-energy	cabinet	cab-sz-008	\N	\N	energy	1961.6000	kWh	2026-06-23 08:38:38.987+00	mock	1.000
obs-power-cab-sz-008-current	cabinet	cab-sz-008	\N	\N	current	11.6000	A	2026-06-23 08:38:38.987+00	mock	1.000
obs-power-cab-sz-008-voltage	cabinet	cab-sz-008	\N	\N	voltage	222.5000	V	2026-06-23 08:38:38.987+00	mock	1.000
obs-power-cab-sz-009-active_power	cabinet	cab-sz-009	\N	\N	active_power	4.2400	kW	2026-06-23 08:38:38.987+00	mock	1.000
obs-power-cab-sz-009-apparent_power	cabinet	cab-sz-009	\N	\N	apparent_power	7.7600	kVA	2026-06-23 08:38:38.987+00	mock	1.000
obs-power-cab-sz-009-power_factor	cabinet	cab-sz-009	\N	\N	power_factor	0.8600	Ratio	2026-06-23 08:38:38.987+00	mock	1.000
obs-power-cab-sz-009-energy	cabinet	cab-sz-009	\N	\N	energy	1920.2000	kWh	2026-06-23 08:38:38.987+00	mock	1.000
obs-power-cab-sz-009-current	cabinet	cab-sz-009	\N	\N	current	13.4000	A	2026-06-23 08:38:38.987+00	mock	1.000
obs-power-cab-sz-009-voltage	cabinet	cab-sz-009	\N	\N	voltage	220.9000	V	2026-06-23 08:38:38.987+00	mock	1.000
obs-power-cab-sz-010-active_power	cabinet	cab-sz-010	\N	\N	active_power	5.3600	kW	2026-06-23 08:38:38.987+00	mock	1.000
obs-power-cab-sz-010-apparent_power	cabinet	cab-sz-010	\N	\N	apparent_power	7.8600	kVA	2026-06-23 08:38:38.987+00	mock	1.000
obs-power-cab-sz-010-power_factor	cabinet	cab-sz-010	\N	\N	power_factor	0.9300	Ratio	2026-06-23 08:38:38.987+00	mock	1.000
obs-power-cab-sz-010-energy	cabinet	cab-sz-010	\N	\N	energy	1707.3000	kWh	2026-06-23 08:38:38.987+00	mock	1.000
obs-power-cab-sz-010-current	cabinet	cab-sz-010	\N	\N	current	13.6000	A	2026-06-23 08:38:38.987+00	mock	1.000
obs-power-cab-sz-010-voltage	cabinet	cab-sz-010	\N	\N	voltage	221.4000	V	2026-06-23 08:38:38.987+00	mock	1.000
obs-power-cab-sz-011-active_power	cabinet	cab-sz-011	\N	\N	active_power	6.3800	kW	2026-06-23 08:38:38.987+00	mock	1.000
obs-power-cab-sz-011-apparent_power	cabinet	cab-sz-011	\N	\N	apparent_power	4.7600	kVA	2026-06-23 08:38:38.987+00	mock	1.000
obs-power-cab-sz-011-power_factor	cabinet	cab-sz-011	\N	\N	power_factor	0.9300	Ratio	2026-06-23 08:38:38.987+00	mock	1.000
obs-power-cab-sz-011-energy	cabinet	cab-sz-011	\N	\N	energy	1900.7000	kWh	2026-06-23 08:38:38.987+00	mock	1.000
obs-power-cab-sz-011-current	cabinet	cab-sz-011	\N	\N	current	10.1000	A	2026-06-23 08:38:38.987+00	mock	1.000
obs-power-cab-sz-011-voltage	cabinet	cab-sz-011	\N	\N	voltage	222.0000	V	2026-06-23 08:38:38.987+00	mock	1.000
obs-power-cab-sz-012-active_power	cabinet	cab-sz-012	\N	\N	active_power	4.1400	kW	2026-06-23 08:38:38.987+00	mock	1.000
obs-power-cab-sz-012-apparent_power	cabinet	cab-sz-012	\N	\N	apparent_power	5.0800	kVA	2026-06-23 08:38:38.987+00	mock	1.000
obs-power-cab-sz-012-power_factor	cabinet	cab-sz-012	\N	\N	power_factor	0.8700	Ratio	2026-06-23 08:38:38.987+00	mock	1.000
obs-power-cab-sz-012-energy	cabinet	cab-sz-012	\N	\N	energy	1613.3000	kWh	2026-06-23 08:38:38.987+00	mock	1.000
obs-power-cab-sz-012-current	cabinet	cab-sz-012	\N	\N	current	14.2000	A	2026-06-23 08:38:38.987+00	mock	1.000
obs-power-cab-sz-012-voltage	cabinet	cab-sz-012	\N	\N	voltage	222.1000	V	2026-06-23 08:38:38.987+00	mock	1.000
obs-power-cab-sz-013-active_power	cabinet	cab-sz-013	\N	\N	active_power	5.2200	kW	2026-06-23 08:38:38.987+00	mock	1.000
obs-power-cab-sz-013-apparent_power	cabinet	cab-sz-013	\N	\N	apparent_power	7.2500	kVA	2026-06-23 08:38:38.987+00	mock	1.000
obs-power-cab-sz-013-power_factor	cabinet	cab-sz-013	\N	\N	power_factor	0.9200	Ratio	2026-06-23 08:38:38.987+00	mock	1.000
obs-power-cab-sz-013-energy	cabinet	cab-sz-013	\N	\N	energy	1519.8000	kWh	2026-06-23 08:38:38.987+00	mock	1.000
obs-power-cab-sz-013-current	cabinet	cab-sz-013	\N	\N	current	12.3000	A	2026-06-23 08:38:38.987+00	mock	1.000
obs-power-cab-sz-013-voltage	cabinet	cab-sz-013	\N	\N	voltage	221.0000	V	2026-06-23 08:38:38.987+00	mock	1.000
obs-power-cab-sz-014-active_power	cabinet	cab-sz-014	\N	\N	active_power	5.8900	kW	2026-06-23 08:38:38.987+00	mock	1.000
obs-power-cab-sz-014-apparent_power	cabinet	cab-sz-014	\N	\N	apparent_power	4.0000	kVA	2026-06-23 08:38:38.987+00	mock	1.000
obs-power-cab-sz-014-power_factor	cabinet	cab-sz-014	\N	\N	power_factor	0.9400	Ratio	2026-06-23 08:38:38.987+00	mock	1.000
obs-power-cab-sz-014-energy	cabinet	cab-sz-014	\N	\N	energy	1795.5000	kWh	2026-06-23 08:38:38.987+00	mock	1.000
obs-power-cab-sz-014-current	cabinet	cab-sz-014	\N	\N	current	11.7000	A	2026-06-23 08:38:38.987+00	mock	1.000
obs-power-cab-sz-014-voltage	cabinet	cab-sz-014	\N	\N	voltage	223.8000	V	2026-06-23 08:38:38.987+00	mock	1.000
obs-power-cab-sz-015-active_power	cabinet	cab-sz-015	\N	\N	active_power	3.1400	kW	2026-06-23 08:38:38.987+00	mock	1.000
obs-power-cab-sz-015-apparent_power	cabinet	cab-sz-015	\N	\N	apparent_power	4.4200	kVA	2026-06-23 08:38:38.987+00	mock	1.000
obs-power-cab-sz-015-power_factor	cabinet	cab-sz-015	\N	\N	power_factor	0.9500	Ratio	2026-06-23 08:38:38.987+00	mock	1.000
obs-power-cab-sz-015-energy	cabinet	cab-sz-015	\N	\N	energy	1864.9000	kWh	2026-06-23 08:38:38.987+00	mock	1.000
obs-power-cab-sz-015-current	cabinet	cab-sz-015	\N	\N	current	12.6000	A	2026-06-23 08:38:38.987+00	mock	1.000
obs-power-cab-sz-015-voltage	cabinet	cab-sz-015	\N	\N	voltage	224.5000	V	2026-06-23 08:38:38.987+00	mock	1.000
obs-power-cab-sz-016-active_power	cabinet	cab-sz-016	\N	\N	active_power	6.5800	kW	2026-06-23 08:38:38.987+00	mock	1.000
obs-power-cab-sz-016-apparent_power	cabinet	cab-sz-016	\N	\N	apparent_power	4.9600	kVA	2026-06-23 08:38:38.987+00	mock	1.000
obs-power-cab-sz-016-power_factor	cabinet	cab-sz-016	\N	\N	power_factor	0.8900	Ratio	2026-06-23 08:38:38.987+00	mock	1.000
obs-power-cab-sz-016-energy	cabinet	cab-sz-016	\N	\N	energy	1881.8000	kWh	2026-06-23 08:38:38.987+00	mock	1.000
obs-power-cab-sz-016-current	cabinet	cab-sz-016	\N	\N	current	14.1000	A	2026-06-23 08:38:38.987+00	mock	1.000
obs-power-cab-sz-016-voltage	cabinet	cab-sz-016	\N	\N	voltage	220.5000	V	2026-06-23 08:38:38.987+00	mock	1.000
obs-power-cab-sz-017-active_power	cabinet	cab-sz-017	\N	\N	active_power	5.0700	kW	2026-06-23 08:38:38.987+00	mock	1.000
obs-power-cab-sz-017-apparent_power	cabinet	cab-sz-017	\N	\N	apparent_power	7.6900	kVA	2026-06-23 08:38:38.987+00	mock	1.000
obs-power-cab-sz-017-power_factor	cabinet	cab-sz-017	\N	\N	power_factor	0.8900	Ratio	2026-06-23 08:38:38.987+00	mock	1.000
obs-power-cab-sz-017-energy	cabinet	cab-sz-017	\N	\N	energy	1620.3000	kWh	2026-06-23 08:38:38.987+00	mock	1.000
obs-power-cab-sz-017-current	cabinet	cab-sz-017	\N	\N	current	12.8000	A	2026-06-23 08:38:38.987+00	mock	1.000
obs-power-cab-sz-017-voltage	cabinet	cab-sz-017	\N	\N	voltage	222.0000	V	2026-06-23 08:38:38.987+00	mock	1.000
obs-power-cab-sz-018-active_power	cabinet	cab-sz-018	\N	\N	active_power	4.6100	kW	2026-06-23 08:38:38.987+00	mock	1.000
obs-power-cab-sz-018-apparent_power	cabinet	cab-sz-018	\N	\N	apparent_power	5.8500	kVA	2026-06-23 08:38:38.987+00	mock	1.000
obs-power-cab-sz-018-power_factor	cabinet	cab-sz-018	\N	\N	power_factor	0.9400	Ratio	2026-06-23 08:38:38.987+00	mock	1.000
obs-power-cab-sz-018-energy	cabinet	cab-sz-018	\N	\N	energy	1945.3000	kWh	2026-06-23 08:38:38.987+00	mock	1.000
obs-power-cab-sz-018-current	cabinet	cab-sz-018	\N	\N	current	10.2000	A	2026-06-23 08:38:38.987+00	mock	1.000
obs-power-cab-sz-018-voltage	cabinet	cab-sz-018	\N	\N	voltage	221.7000	V	2026-06-23 08:38:38.987+00	mock	1.000
obs-power-cab-cd-001-active_power	cabinet	cab-cd-001	\N	\N	active_power	3.4200	kW	2026-06-23 08:38:38.987+00	mock	1.000
obs-power-cab-cd-001-apparent_power	cabinet	cab-cd-001	\N	\N	apparent_power	3.9200	kVA	2026-06-23 08:38:38.987+00	mock	1.000
obs-power-cab-cd-001-power_factor	cabinet	cab-cd-001	\N	\N	power_factor	0.8500	Ratio	2026-06-23 08:38:38.987+00	mock	1.000
obs-power-cab-cd-001-energy	cabinet	cab-cd-001	\N	\N	energy	1947.8000	kWh	2026-06-23 08:38:38.987+00	mock	1.000
obs-power-cab-cd-001-current	cabinet	cab-cd-001	\N	\N	current	12.6000	A	2026-06-23 08:38:38.987+00	mock	1.000
obs-power-cab-cd-001-voltage	cabinet	cab-cd-001	\N	\N	voltage	224.2000	V	2026-06-23 08:38:38.987+00	mock	1.000
obs-power-cab-cd-002-active_power	cabinet	cab-cd-002	\N	\N	active_power	6.5900	kW	2026-06-23 08:38:38.987+00	mock	1.000
obs-power-cab-cd-002-apparent_power	cabinet	cab-cd-002	\N	\N	apparent_power	7.3000	kVA	2026-06-23 08:38:38.987+00	mock	1.000
obs-power-cab-cd-002-power_factor	cabinet	cab-cd-002	\N	\N	power_factor	0.8600	Ratio	2026-06-23 08:38:38.987+00	mock	1.000
obs-power-cab-cd-002-energy	cabinet	cab-cd-002	\N	\N	energy	1863.9000	kWh	2026-06-23 08:38:38.987+00	mock	1.000
obs-power-cab-cd-002-current	cabinet	cab-cd-002	\N	\N	current	12.7000	A	2026-06-23 08:38:38.987+00	mock	1.000
obs-power-cab-cd-002-voltage	cabinet	cab-cd-002	\N	\N	voltage	222.2000	V	2026-06-23 08:38:38.987+00	mock	1.000
obs-power-cab-cd-003-active_power	cabinet	cab-cd-003	\N	\N	active_power	4.9100	kW	2026-06-23 08:38:38.987+00	mock	1.000
obs-power-cab-cd-003-apparent_power	cabinet	cab-cd-003	\N	\N	apparent_power	4.0500	kVA	2026-06-23 08:38:38.987+00	mock	1.000
obs-power-cab-cd-003-power_factor	cabinet	cab-cd-003	\N	\N	power_factor	0.8700	Ratio	2026-06-23 08:38:38.987+00	mock	1.000
obs-power-cab-cd-003-energy	cabinet	cab-cd-003	\N	\N	energy	1837.8000	kWh	2026-06-23 08:38:38.987+00	mock	1.000
obs-power-cab-cd-003-current	cabinet	cab-cd-003	\N	\N	current	11.7000	A	2026-06-23 08:38:38.987+00	mock	1.000
obs-power-cab-cd-003-voltage	cabinet	cab-cd-003	\N	\N	voltage	221.1000	V	2026-06-23 08:38:38.987+00	mock	1.000
obs-power-cab-cd-004-active_power	cabinet	cab-cd-004	\N	\N	active_power	6.8300	kW	2026-06-23 08:38:38.987+00	mock	1.000
obs-power-cab-cd-004-apparent_power	cabinet	cab-cd-004	\N	\N	apparent_power	3.7200	kVA	2026-06-23 08:38:38.987+00	mock	1.000
obs-power-cab-cd-004-power_factor	cabinet	cab-cd-004	\N	\N	power_factor	0.9500	Ratio	2026-06-23 08:38:38.987+00	mock	1.000
obs-power-cab-cd-004-energy	cabinet	cab-cd-004	\N	\N	energy	1966.7000	kWh	2026-06-23 08:38:38.987+00	mock	1.000
obs-power-cab-cd-004-current	cabinet	cab-cd-004	\N	\N	current	13.5000	A	2026-06-23 08:38:38.987+00	mock	1.000
obs-power-cab-cd-004-voltage	cabinet	cab-cd-004	\N	\N	voltage	221.6000	V	2026-06-23 08:38:38.987+00	mock	1.000
obs-power-cab-cd-005-active_power	cabinet	cab-cd-005	\N	\N	active_power	3.8500	kW	2026-06-23 08:38:38.987+00	mock	1.000
obs-power-cab-cd-005-apparent_power	cabinet	cab-cd-005	\N	\N	apparent_power	4.3800	kVA	2026-06-23 08:38:38.987+00	mock	1.000
obs-power-cab-cd-005-power_factor	cabinet	cab-cd-005	\N	\N	power_factor	0.8800	Ratio	2026-06-23 08:38:38.987+00	mock	1.000
obs-power-cab-cd-005-energy	cabinet	cab-cd-005	\N	\N	energy	1559.6000	kWh	2026-06-23 08:38:38.987+00	mock	1.000
obs-power-cab-cd-005-current	cabinet	cab-cd-005	\N	\N	current	10.3000	A	2026-06-23 08:38:38.987+00	mock	1.000
obs-power-cab-cd-005-voltage	cabinet	cab-cd-005	\N	\N	voltage	223.4000	V	2026-06-23 08:38:38.987+00	mock	1.000
obs-power-cab-cd-006-active_power	cabinet	cab-cd-006	\N	\N	active_power	6.1700	kW	2026-06-23 08:38:38.987+00	mock	1.000
obs-power-cab-cd-006-apparent_power	cabinet	cab-cd-006	\N	\N	apparent_power	5.1200	kVA	2026-06-23 08:38:38.987+00	mock	1.000
obs-power-cab-cd-006-power_factor	cabinet	cab-cd-006	\N	\N	power_factor	0.8500	Ratio	2026-06-23 08:38:38.987+00	mock	1.000
obs-power-cab-cd-006-energy	cabinet	cab-cd-006	\N	\N	energy	1913.1000	kWh	2026-06-23 08:38:38.987+00	mock	1.000
obs-power-cab-cd-006-current	cabinet	cab-cd-006	\N	\N	current	10.8000	A	2026-06-23 08:38:38.987+00	mock	1.000
obs-power-cab-cd-006-voltage	cabinet	cab-cd-006	\N	\N	voltage	222.3000	V	2026-06-23 08:38:38.987+00	mock	1.000
obs-power-cab-cd-007-active_power	cabinet	cab-cd-007	\N	\N	active_power	4.7300	kW	2026-06-23 08:38:38.987+00	mock	1.000
obs-power-cab-cd-007-apparent_power	cabinet	cab-cd-007	\N	\N	apparent_power	7.7400	kVA	2026-06-23 08:38:38.987+00	mock	1.000
obs-power-cab-cd-007-power_factor	cabinet	cab-cd-007	\N	\N	power_factor	0.9200	Ratio	2026-06-23 08:38:38.987+00	mock	1.000
obs-power-cab-cd-007-energy	cabinet	cab-cd-007	\N	\N	energy	1535.6000	kWh	2026-06-23 08:38:38.987+00	mock	1.000
obs-power-cab-cd-007-current	cabinet	cab-cd-007	\N	\N	current	14.9000	A	2026-06-23 08:38:38.987+00	mock	1.000
obs-power-cab-cd-007-voltage	cabinet	cab-cd-007	\N	\N	voltage	223.1000	V	2026-06-23 08:38:38.987+00	mock	1.000
obs-power-cab-cd-008-active_power	cabinet	cab-cd-008	\N	\N	active_power	6.2600	kW	2026-06-23 08:38:38.987+00	mock	1.000
obs-power-cab-cd-008-apparent_power	cabinet	cab-cd-008	\N	\N	apparent_power	4.8000	kVA	2026-06-23 08:38:38.987+00	mock	1.000
obs-power-cab-cd-008-power_factor	cabinet	cab-cd-008	\N	\N	power_factor	0.9300	Ratio	2026-06-23 08:38:38.987+00	mock	1.000
obs-power-cab-cd-008-energy	cabinet	cab-cd-008	\N	\N	energy	1735.9000	kWh	2026-06-23 08:38:38.987+00	mock	1.000
obs-power-cab-cd-008-current	cabinet	cab-cd-008	\N	\N	current	11.6000	A	2026-06-23 08:38:38.987+00	mock	1.000
obs-power-cab-cd-008-voltage	cabinet	cab-cd-008	\N	\N	voltage	220.2000	V	2026-06-23 08:38:38.987+00	mock	1.000
obs-power-cab-cd-009-active_power	cabinet	cab-cd-009	\N	\N	active_power	3.4800	kW	2026-06-23 08:38:38.987+00	mock	1.000
obs-power-cab-cd-009-apparent_power	cabinet	cab-cd-009	\N	\N	apparent_power	7.7200	kVA	2026-06-23 08:38:38.987+00	mock	1.000
obs-power-cab-cd-009-power_factor	cabinet	cab-cd-009	\N	\N	power_factor	0.9200	Ratio	2026-06-23 08:38:38.987+00	mock	1.000
obs-power-cab-cd-009-energy	cabinet	cab-cd-009	\N	\N	energy	1656.0000	kWh	2026-06-23 08:38:38.987+00	mock	1.000
obs-power-cab-cd-009-current	cabinet	cab-cd-009	\N	\N	current	11.8000	A	2026-06-23 08:38:38.987+00	mock	1.000
obs-power-cab-cd-009-voltage	cabinet	cab-cd-009	\N	\N	voltage	222.1000	V	2026-06-23 08:38:38.987+00	mock	1.000
obs-power-cab-cd-010-active_power	cabinet	cab-cd-010	\N	\N	active_power	4.0200	kW	2026-06-23 08:38:38.987+00	mock	1.000
obs-power-cab-cd-010-apparent_power	cabinet	cab-cd-010	\N	\N	apparent_power	5.0300	kVA	2026-06-23 08:38:38.987+00	mock	1.000
obs-power-cab-cd-010-power_factor	cabinet	cab-cd-010	\N	\N	power_factor	0.9200	Ratio	2026-06-23 08:38:38.987+00	mock	1.000
obs-power-cab-cd-010-energy	cabinet	cab-cd-010	\N	\N	energy	1505.7000	kWh	2026-06-23 08:38:38.987+00	mock	1.000
obs-power-cab-cd-010-current	cabinet	cab-cd-010	\N	\N	current	14.1000	A	2026-06-23 08:38:38.987+00	mock	1.000
obs-power-cab-cd-010-voltage	cabinet	cab-cd-010	\N	\N	voltage	223.0000	V	2026-06-23 08:38:38.987+00	mock	1.000
obs-power-cab-cd-011-active_power	cabinet	cab-cd-011	\N	\N	active_power	5.0300	kW	2026-06-23 08:38:38.987+00	mock	1.000
obs-power-cab-cd-011-apparent_power	cabinet	cab-cd-011	\N	\N	apparent_power	5.8800	kVA	2026-06-23 08:38:38.987+00	mock	1.000
obs-power-cab-cd-011-power_factor	cabinet	cab-cd-011	\N	\N	power_factor	0.9000	Ratio	2026-06-23 08:38:38.987+00	mock	1.000
obs-power-cab-cd-011-energy	cabinet	cab-cd-011	\N	\N	energy	1844.7000	kWh	2026-06-23 08:38:38.987+00	mock	1.000
obs-power-cab-cd-011-current	cabinet	cab-cd-011	\N	\N	current	13.3000	A	2026-06-23 08:38:38.987+00	mock	1.000
obs-power-cab-cd-011-voltage	cabinet	cab-cd-011	\N	\N	voltage	221.5000	V	2026-06-23 08:38:38.987+00	mock	1.000
obs-power-cab-cd-012-active_power	cabinet	cab-cd-012	\N	\N	active_power	6.7400	kW	2026-06-23 08:38:38.987+00	mock	1.000
obs-power-cab-cd-012-apparent_power	cabinet	cab-cd-012	\N	\N	apparent_power	7.2600	kVA	2026-06-23 08:38:38.987+00	mock	1.000
obs-power-cab-cd-012-power_factor	cabinet	cab-cd-012	\N	\N	power_factor	0.8700	Ratio	2026-06-23 08:38:38.987+00	mock	1.000
obs-power-cab-cd-012-energy	cabinet	cab-cd-012	\N	\N	energy	1983.1000	kWh	2026-06-23 08:38:38.987+00	mock	1.000
obs-power-cab-cd-012-current	cabinet	cab-cd-012	\N	\N	current	12.5000	A	2026-06-23 08:38:38.987+00	mock	1.000
obs-power-cab-cd-012-voltage	cabinet	cab-cd-012	\N	\N	voltage	222.8000	V	2026-06-23 08:38:38.987+00	mock	1.000
\.


--
-- Data for Name: ontology_individual; Type: TABLE DATA; Schema: dcim_ontology_demo_20260623083835; Owner: -
--

COPY "__DCIM_TARGET_SCHEMA__".ontology_individual (id, ontology_class, source_table, source_id, label, source_system, created_at) FROM stdin;
datacenter:dc-001:Datacenter	Datacenter	datacenter	dc-001	北京亦庄数据中心	mock	2026-06-23 08:38:42.107162+00
datacenter:dc-002:Datacenter	Datacenter	datacenter	dc-002	上海嘉定数据中心	mock	2026-06-23 08:38:42.107162+00
datacenter:dc-003:Datacenter	Datacenter	datacenter	dc-003	深圳坪山数据中心	mock	2026-06-23 08:38:42.107162+00
datacenter:dc-004:Datacenter	Datacenter	datacenter	dc-004	成都天府数据中心	mock	2026-06-23 08:38:42.107162+00
cabinet:cab-bj-001:Cabinet	Cabinet	cabinet	cab-bj-001	A区1排1号机柜	mock	2026-06-23 08:38:42.107162+00
cabinet:cab-bj-002:Cabinet	Cabinet	cabinet	cab-bj-002	A区1排2号机柜	mock	2026-06-23 08:38:42.107162+00
cabinet:cab-bj-003:Cabinet	Cabinet	cabinet	cab-bj-003	A区1排3号机柜	mock	2026-06-23 08:38:42.107162+00
cabinet:cab-bj-004:Cabinet	Cabinet	cabinet	cab-bj-004	A区1排4号机柜	mock	2026-06-23 08:38:42.107162+00
cabinet:cab-bj-005:Cabinet	Cabinet	cabinet	cab-bj-005	A区1排5号机柜	mock	2026-06-23 08:38:42.107162+00
cabinet:cab-bj-006:Cabinet	Cabinet	cabinet	cab-bj-006	A区2排1号机柜	mock	2026-06-23 08:38:42.107162+00
cabinet:cab-bj-007:Cabinet	Cabinet	cabinet	cab-bj-007	A区2排2号机柜	mock	2026-06-23 08:38:42.107162+00
cabinet:cab-bj-008:Cabinet	Cabinet	cabinet	cab-bj-008	A区2排3号机柜	mock	2026-06-23 08:38:42.107162+00
cabinet:cab-bj-009:Cabinet	Cabinet	cabinet	cab-bj-009	A区2排4号机柜	mock	2026-06-23 08:38:42.107162+00
cabinet:cab-bj-010:Cabinet	Cabinet	cabinet	cab-bj-010	A区2排5号机柜	mock	2026-06-23 08:38:42.107162+00
cabinet:cab-bj-011:Cabinet	Cabinet	cabinet	cab-bj-011	A区3排1号机柜	mock	2026-06-23 08:38:42.107162+00
cabinet:cab-bj-012:Cabinet	Cabinet	cabinet	cab-bj-012	A区3排2号机柜	mock	2026-06-23 08:38:42.107162+00
cabinet:cab-bj-013:Cabinet	Cabinet	cabinet	cab-bj-013	A区3排3号机柜	mock	2026-06-23 08:38:42.107162+00
cabinet:cab-bj-014:Cabinet	Cabinet	cabinet	cab-bj-014	A区3排4号机柜	mock	2026-06-23 08:38:42.107162+00
cabinet:cab-bj-015:Cabinet	Cabinet	cabinet	cab-bj-015	A区3排5号机柜	mock	2026-06-23 08:38:42.107162+00
cabinet:cab-bj-016:Cabinet	Cabinet	cabinet	cab-bj-016	A区4排1号机柜	mock	2026-06-23 08:38:42.107162+00
cabinet:cab-bj-017:Cabinet	Cabinet	cabinet	cab-bj-017	A区4排2号机柜	mock	2026-06-23 08:38:42.107162+00
cabinet:cab-bj-018:Cabinet	Cabinet	cabinet	cab-bj-018	A区4排3号机柜	mock	2026-06-23 08:38:42.107162+00
cabinet:cab-bj-019:Cabinet	Cabinet	cabinet	cab-bj-019	A区4排4号机柜	mock	2026-06-23 08:38:42.107162+00
cabinet:cab-bj-020:Cabinet	Cabinet	cabinet	cab-bj-020	A区4排5号机柜	mock	2026-06-23 08:38:42.107162+00
cabinet:cab-sh-001:Cabinet	Cabinet	cabinet	cab-sh-001	B区1排1号机柜	mock	2026-06-23 08:38:42.107162+00
cabinet:cab-sh-002:Cabinet	Cabinet	cabinet	cab-sh-002	B区1排2号机柜	mock	2026-06-23 08:38:42.107162+00
cabinet:cab-sh-003:Cabinet	Cabinet	cabinet	cab-sh-003	B区1排3号机柜	mock	2026-06-23 08:38:42.107162+00
cabinet:cab-sh-004:Cabinet	Cabinet	cabinet	cab-sh-004	B区1排4号机柜	mock	2026-06-23 08:38:42.107162+00
cabinet:cab-sh-005:Cabinet	Cabinet	cabinet	cab-sh-005	B区1排5号机柜	mock	2026-06-23 08:38:42.107162+00
cabinet:cab-sh-006:Cabinet	Cabinet	cabinet	cab-sh-006	B区2排1号机柜	mock	2026-06-23 08:38:42.107162+00
cabinet:cab-sh-007:Cabinet	Cabinet	cabinet	cab-sh-007	B区2排2号机柜	mock	2026-06-23 08:38:42.107162+00
cabinet:cab-sh-008:Cabinet	Cabinet	cabinet	cab-sh-008	B区2排3号机柜	mock	2026-06-23 08:38:42.107162+00
cabinet:cab-sh-009:Cabinet	Cabinet	cabinet	cab-sh-009	B区2排4号机柜	mock	2026-06-23 08:38:42.107162+00
cabinet:cab-sh-010:Cabinet	Cabinet	cabinet	cab-sh-010	B区2排5号机柜	mock	2026-06-23 08:38:42.107162+00
cabinet:cab-sh-011:Cabinet	Cabinet	cabinet	cab-sh-011	B区3排1号机柜	mock	2026-06-23 08:38:42.107162+00
cabinet:cab-sh-012:Cabinet	Cabinet	cabinet	cab-sh-012	B区3排2号机柜	mock	2026-06-23 08:38:42.107162+00
cabinet:cab-sh-013:Cabinet	Cabinet	cabinet	cab-sh-013	B区3排3号机柜	mock	2026-06-23 08:38:42.107162+00
cabinet:cab-sh-014:Cabinet	Cabinet	cabinet	cab-sh-014	B区3排4号机柜	mock	2026-06-23 08:38:42.107162+00
cabinet:cab-sh-015:Cabinet	Cabinet	cabinet	cab-sh-015	B区3排5号机柜	mock	2026-06-23 08:38:42.107162+00
cabinet:cab-sz-001:Cabinet	Cabinet	cabinet	cab-sz-001	C区1排1号机柜	mock	2026-06-23 08:38:42.107162+00
cabinet:cab-sz-002:Cabinet	Cabinet	cabinet	cab-sz-002	C区1排2号机柜	mock	2026-06-23 08:38:42.107162+00
cabinet:cab-sz-003:Cabinet	Cabinet	cabinet	cab-sz-003	C区1排3号机柜	mock	2026-06-23 08:38:42.107162+00
cabinet:cab-sz-004:Cabinet	Cabinet	cabinet	cab-sz-004	C区1排4号机柜	mock	2026-06-23 08:38:42.107162+00
cabinet:cab-sz-005:Cabinet	Cabinet	cabinet	cab-sz-005	C区1排5号机柜	mock	2026-06-23 08:38:42.107162+00
cabinet:cab-sz-006:Cabinet	Cabinet	cabinet	cab-sz-006	C区1排6号机柜	mock	2026-06-23 08:38:42.107162+00
cabinet:cab-sz-007:Cabinet	Cabinet	cabinet	cab-sz-007	C区2排1号机柜	mock	2026-06-23 08:38:42.107162+00
cabinet:cab-sz-008:Cabinet	Cabinet	cabinet	cab-sz-008	C区2排2号机柜	mock	2026-06-23 08:38:42.107162+00
cabinet:cab-sz-009:Cabinet	Cabinet	cabinet	cab-sz-009	C区2排3号机柜	mock	2026-06-23 08:38:42.107162+00
cabinet:cab-sz-010:Cabinet	Cabinet	cabinet	cab-sz-010	C区2排4号机柜	mock	2026-06-23 08:38:42.107162+00
cabinet:cab-sz-011:Cabinet	Cabinet	cabinet	cab-sz-011	C区2排5号机柜	mock	2026-06-23 08:38:42.107162+00
cabinet:cab-sz-012:Cabinet	Cabinet	cabinet	cab-sz-012	C区2排6号机柜	mock	2026-06-23 08:38:42.107162+00
cabinet:cab-sz-013:Cabinet	Cabinet	cabinet	cab-sz-013	C区3排1号机柜	mock	2026-06-23 08:38:42.107162+00
cabinet:cab-sz-014:Cabinet	Cabinet	cabinet	cab-sz-014	C区3排2号机柜	mock	2026-06-23 08:38:42.107162+00
cabinet:cab-sz-015:Cabinet	Cabinet	cabinet	cab-sz-015	C区3排3号机柜	mock	2026-06-23 08:38:42.107162+00
cabinet:cab-sz-016:Cabinet	Cabinet	cabinet	cab-sz-016	C区3排4号机柜	mock	2026-06-23 08:38:42.107162+00
cabinet:cab-sz-017:Cabinet	Cabinet	cabinet	cab-sz-017	C区3排5号机柜	mock	2026-06-23 08:38:42.107162+00
cabinet:cab-sz-018:Cabinet	Cabinet	cabinet	cab-sz-018	C区3排6号机柜	mock	2026-06-23 08:38:42.107162+00
cabinet:cab-cd-001:Cabinet	Cabinet	cabinet	cab-cd-001	D区1排1号机柜	mock	2026-06-23 08:38:42.107162+00
cabinet:cab-cd-002:Cabinet	Cabinet	cabinet	cab-cd-002	D区1排2号机柜	mock	2026-06-23 08:38:42.107162+00
cabinet:cab-cd-003:Cabinet	Cabinet	cabinet	cab-cd-003	D区1排3号机柜	mock	2026-06-23 08:38:42.107162+00
cabinet:cab-cd-004:Cabinet	Cabinet	cabinet	cab-cd-004	D区1排4号机柜	mock	2026-06-23 08:38:42.107162+00
cabinet:cab-cd-005:Cabinet	Cabinet	cabinet	cab-cd-005	D区2排1号机柜	mock	2026-06-23 08:38:42.107162+00
cabinet:cab-cd-006:Cabinet	Cabinet	cabinet	cab-cd-006	D区2排2号机柜	mock	2026-06-23 08:38:42.107162+00
cabinet:cab-cd-007:Cabinet	Cabinet	cabinet	cab-cd-007	D区2排3号机柜	mock	2026-06-23 08:38:42.107162+00
cabinet:cab-cd-008:Cabinet	Cabinet	cabinet	cab-cd-008	D区2排4号机柜	mock	2026-06-23 08:38:42.107162+00
cabinet:cab-cd-009:Cabinet	Cabinet	cabinet	cab-cd-009	D区3排1号机柜	mock	2026-06-23 08:38:42.107162+00
cabinet:cab-cd-010:Cabinet	Cabinet	cabinet	cab-cd-010	D区3排2号机柜	mock	2026-06-23 08:38:42.107162+00
cabinet:cab-cd-011:Cabinet	Cabinet	cabinet	cab-cd-011	D区3排3号机柜	mock	2026-06-23 08:38:42.107162+00
cabinet:cab-cd-012:Cabinet	Cabinet	cabinet	cab-cd-012	D区3排4号机柜	mock	2026-06-23 08:38:42.107162+00
port:port-dev-001-sfp-31:Port	Port	port	port-dev-001-sfp-31	XGE1/0/31	mock	2026-06-23 08:38:42.107162+00
device_template:tpl-huawei-s5735-48t4x:ProductModel	ProductModel	device_template	tpl-huawei-s5735-48t4x	华为S5735-L48T4X-A	mock	2026-06-23 08:38:42.107162+00
device_template:tpl-huawei-s6730-48x6c:ProductModel	ProductModel	device_template	tpl-huawei-s6730-48x6c	华为S6730-H48X6C	mock	2026-06-23 08:38:42.107162+00
device_template:tpl-huawei-ce6881-48s6cq:ProductModel	ProductModel	device_template	tpl-huawei-ce6881-48s6cq	华为CE6881-48S6CQ	mock	2026-06-23 08:38:42.107162+00
device_template:tpl-cisco-c9300-48p:ProductModel	ProductModel	device_template	tpl-cisco-c9300-48p	Cisco Catalyst 9300-48P	mock	2026-06-23 08:38:42.107162+00
device_template:tpl-cisco-n9k-93180yc:ProductModel	ProductModel	device_template	tpl-cisco-n9k-93180yc	Cisco Nexus 93180YC-FX	mock	2026-06-23 08:38:42.107162+00
device_template:tpl-h3c-s6850-56hf:ProductModel	ProductModel	device_template	tpl-h3c-s6850-56hf	H3C S6850-56HF	mock	2026-06-23 08:38:42.107162+00
device_template:tpl-ruijie-s6220-48xs6qxs:ProductModel	ProductModel	device_template	tpl-ruijie-s6220-48xs6qxs	锐捷RG-S6220-48XS6QXS	mock	2026-06-23 08:38:42.107162+00
device_template:tpl-huawei-2288h-v6:ProductModel	ProductModel	device_template	tpl-huawei-2288h-v6	华为FusionServer 2288H V6	mock	2026-06-23 08:38:42.107162+00
device_template:tpl-dell-r750:ProductModel	ProductModel	device_template	tpl-dell-r750	Dell PowerEdge R750	mock	2026-06-23 08:38:42.107162+00
device_template:tpl-hpe-dl380-gen10:ProductModel	ProductModel	device_template	tpl-hpe-dl380-gen10	HPE ProLiant DL380 Gen10	mock	2026-06-23 08:38:42.107162+00
device_template:tpl-inspur-nf5280m6:ProductModel	ProductModel	device_template	tpl-inspur-nf5280m6	浪潮NF5280M6	mock	2026-06-23 08:38:42.107162+00
device_template:tpl-huawei-ne40e-x8:ProductModel	ProductModel	device_template	tpl-huawei-ne40e-x8	华为NE40E-X8	mock	2026-06-23 08:38:42.107162+00
device_template:tpl-cisco-asr-9000:ProductModel	ProductModel	device_template	tpl-cisco-asr-9000	Cisco ASR 9006	mock	2026-06-23 08:38:42.107162+00
device_template:tpl-huawei-oceanstor-5500:ProductModel	ProductModel	device_template	tpl-huawei-oceanstor-5500	华为OceanStor 5500 V5	mock	2026-06-23 08:38:42.107162+00
device_template:tpl-huawei-usg6680:ProductModel	ProductModel	device_template	tpl-huawei-usg6680	华为USG6680	mock	2026-06-23 08:38:42.107162+00
device_template:tpl-f5-big-ip-i5800:ProductModel	ProductModel	device_template	tpl-f5-big-ip-i5800	F5 BIG-IP i5800	mock	2026-06-23 08:38:42.107162+00
device_template:tpl-pdu-001:ProductModel	ProductModel	device_template	tpl-pdu-001	APC AP7921	mock	2026-06-23 08:38:42.107162+00
device_template:tpl-pdu-002:ProductModel	ProductModel	device_template	tpl-pdu-002	Schneider AP8941	mock	2026-06-23 08:38:42.107162+00
device:dev-001:Switch	Switch	device	dev-001	核心交换机-A1	mock	2026-06-23 08:38:42.107162+00
device:dev-002:Switch	Switch	device	dev-002	接入交换机-A1-1	mock	2026-06-23 08:38:42.107162+00
device:dev-003:Server	Server	device	dev-003	应用服务器-A1-1	mock	2026-06-23 08:38:42.107162+00
device:dev-004:Server	Server	device	dev-004	应用服务器-A1-2	mock	2026-06-23 08:38:42.107162+00
device:dev-005:Server	Server	device	dev-005	数据库服务器-A1-1	mock	2026-06-23 08:38:42.107162+00
device:dev-006:Firewall	Firewall	device	dev-006	边界防火墙-1	mock	2026-06-23 08:38:42.107162+00
device:dev-007:Loadbalancer	Loadbalancer	device	dev-007	负载均衡器-1	mock	2026-06-23 08:38:42.107162+00
device:dev-008:Storage	Storage	device	dev-008	核心存储-1	mock	2026-06-23 08:38:42.107162+00
device:dev-009:Switch	Switch	device	dev-009	接入交换机-B1-1	mock	2026-06-23 08:38:42.107162+00
device:dev-010:Switch	Switch	device	dev-010	核心交换机-B1	mock	2026-06-23 08:38:42.107162+00
device:dev-011:Switch	Switch	device	dev-011	汇聚交换机-C1	mock	2026-06-23 08:38:42.107162+00
device:dev-012:Server	Server	device	dev-012	GPU服务器-C1-1	mock	2026-06-23 08:38:42.107162+00
pdu:pdu-001:PowerDistributionUnit	PowerDistributionUnit	pdu	pdu-001	PDU-A-01	mock	2026-06-23 08:38:42.107162+00
pdu:pdu-002:PowerDistributionUnit	PowerDistributionUnit	pdu	pdu-002	PDU-B-01	mock	2026-06-23 08:38:42.107162+00
pdu:pdu-003:PowerDistributionUnit	PowerDistributionUnit	pdu	pdu-003	PDU-A-02	mock	2026-06-23 08:38:42.107162+00
pdu:pdu-004:PowerDistributionUnit	PowerDistributionUnit	pdu	pdu-004	PDU-B-02	mock	2026-06-23 08:38:42.107162+00
port:port-dev-001-sfp-1:Port	Port	port	port-dev-001-sfp-1	XGE1/0/1	mock	2026-06-23 08:38:42.107162+00
port:port-dev-001-sfp-2:Port	Port	port	port-dev-001-sfp-2	XGE1/0/2	mock	2026-06-23 08:38:42.107162+00
port:port-dev-001-sfp-3:Port	Port	port	port-dev-001-sfp-3	XGE1/0/3	mock	2026-06-23 08:38:42.107162+00
port:port-dev-001-sfp-4:Port	Port	port	port-dev-001-sfp-4	XGE1/0/4	mock	2026-06-23 08:38:42.107162+00
port:port-dev-001-sfp-5:Port	Port	port	port-dev-001-sfp-5	XGE1/0/5	mock	2026-06-23 08:38:42.107162+00
port:port-dev-001-sfp-6:Port	Port	port	port-dev-001-sfp-6	XGE1/0/6	mock	2026-06-23 08:38:42.107162+00
port:port-dev-001-sfp-7:Port	Port	port	port-dev-001-sfp-7	XGE1/0/7	mock	2026-06-23 08:38:42.107162+00
port:port-dev-001-sfp-8:Port	Port	port	port-dev-001-sfp-8	XGE1/0/8	mock	2026-06-23 08:38:42.107162+00
port:port-dev-001-sfp-9:Port	Port	port	port-dev-001-sfp-9	XGE1/0/9	mock	2026-06-23 08:38:42.107162+00
port:port-dev-001-sfp-10:Port	Port	port	port-dev-001-sfp-10	XGE1/0/10	mock	2026-06-23 08:38:42.107162+00
port:port-dev-001-sfp-11:Port	Port	port	port-dev-001-sfp-11	XGE1/0/11	mock	2026-06-23 08:38:42.107162+00
port:port-dev-001-sfp-12:Port	Port	port	port-dev-001-sfp-12	XGE1/0/12	mock	2026-06-23 08:38:42.107162+00
port:port-dev-001-sfp-13:Port	Port	port	port-dev-001-sfp-13	XGE1/0/13	mock	2026-06-23 08:38:42.107162+00
port:port-dev-001-sfp-14:Port	Port	port	port-dev-001-sfp-14	XGE1/0/14	mock	2026-06-23 08:38:42.107162+00
port:port-dev-001-sfp-15:Port	Port	port	port-dev-001-sfp-15	XGE1/0/15	mock	2026-06-23 08:38:42.107162+00
port:port-dev-001-sfp-16:Port	Port	port	port-dev-001-sfp-16	XGE1/0/16	mock	2026-06-23 08:38:42.107162+00
port:port-dev-001-sfp-17:Port	Port	port	port-dev-001-sfp-17	XGE1/0/17	mock	2026-06-23 08:38:42.107162+00
port:port-dev-001-sfp-18:Port	Port	port	port-dev-001-sfp-18	XGE1/0/18	mock	2026-06-23 08:38:42.107162+00
port:port-dev-001-sfp-19:Port	Port	port	port-dev-001-sfp-19	XGE1/0/19	mock	2026-06-23 08:38:42.107162+00
port:port-dev-001-sfp-20:Port	Port	port	port-dev-001-sfp-20	XGE1/0/20	mock	2026-06-23 08:38:42.107162+00
port:port-dev-001-sfp-21:Port	Port	port	port-dev-001-sfp-21	XGE1/0/21	mock	2026-06-23 08:38:42.107162+00
port:port-dev-001-sfp-22:Port	Port	port	port-dev-001-sfp-22	XGE1/0/22	mock	2026-06-23 08:38:42.107162+00
port:port-dev-001-sfp-23:Port	Port	port	port-dev-001-sfp-23	XGE1/0/23	mock	2026-06-23 08:38:42.107162+00
port:port-dev-001-sfp-24:Port	Port	port	port-dev-001-sfp-24	XGE1/0/24	mock	2026-06-23 08:38:42.107162+00
port:port-dev-001-sfp-25:Port	Port	port	port-dev-001-sfp-25	XGE1/0/25	mock	2026-06-23 08:38:42.107162+00
port:port-dev-001-sfp-26:Port	Port	port	port-dev-001-sfp-26	XGE1/0/26	mock	2026-06-23 08:38:42.107162+00
port:port-dev-001-sfp-27:Port	Port	port	port-dev-001-sfp-27	XGE1/0/27	mock	2026-06-23 08:38:42.107162+00
port:port-dev-001-sfp-28:Port	Port	port	port-dev-001-sfp-28	XGE1/0/28	mock	2026-06-23 08:38:42.107162+00
port:port-dev-001-sfp-29:Port	Port	port	port-dev-001-sfp-29	XGE1/0/29	mock	2026-06-23 08:38:42.107162+00
port:port-dev-001-sfp-30:Port	Port	port	port-dev-001-sfp-30	XGE1/0/30	mock	2026-06-23 08:38:42.107162+00
port:port-dev-001-sfp-32:Port	Port	port	port-dev-001-sfp-32	XGE1/0/32	mock	2026-06-23 08:38:42.107162+00
port:port-dev-001-sfp-33:Port	Port	port	port-dev-001-sfp-33	XGE1/0/33	mock	2026-06-23 08:38:42.107162+00
port:port-dev-001-sfp-34:Port	Port	port	port-dev-001-sfp-34	XGE1/0/34	mock	2026-06-23 08:38:42.107162+00
port:port-dev-001-sfp-35:Port	Port	port	port-dev-001-sfp-35	XGE1/0/35	mock	2026-06-23 08:38:42.107162+00
port:port-dev-001-sfp-36:Port	Port	port	port-dev-001-sfp-36	XGE1/0/36	mock	2026-06-23 08:38:42.107162+00
port:port-dev-001-sfp-37:Port	Port	port	port-dev-001-sfp-37	XGE1/0/37	mock	2026-06-23 08:38:42.107162+00
port:port-dev-001-sfp-38:Port	Port	port	port-dev-001-sfp-38	XGE1/0/38	mock	2026-06-23 08:38:42.107162+00
port:port-dev-001-sfp-39:Port	Port	port	port-dev-001-sfp-39	XGE1/0/39	mock	2026-06-23 08:38:42.107162+00
port:port-dev-001-sfp-40:Port	Port	port	port-dev-001-sfp-40	XGE1/0/40	mock	2026-06-23 08:38:42.107162+00
port:port-dev-001-sfp-41:Port	Port	port	port-dev-001-sfp-41	XGE1/0/41	mock	2026-06-23 08:38:42.107162+00
port:port-dev-001-sfp-42:Port	Port	port	port-dev-001-sfp-42	XGE1/0/42	mock	2026-06-23 08:38:42.107162+00
port:port-dev-001-sfp-43:Port	Port	port	port-dev-001-sfp-43	XGE1/0/43	mock	2026-06-23 08:38:42.107162+00
port:port-dev-001-sfp-44:Port	Port	port	port-dev-001-sfp-44	XGE1/0/44	mock	2026-06-23 08:38:42.107162+00
port:port-dev-001-sfp-45:Port	Port	port	port-dev-001-sfp-45	XGE1/0/45	mock	2026-06-23 08:38:42.107162+00
port:port-dev-001-sfp-46:Port	Port	port	port-dev-001-sfp-46	XGE1/0/46	mock	2026-06-23 08:38:42.107162+00
port:port-dev-001-sfp-47:Port	Port	port	port-dev-001-sfp-47	XGE1/0/47	mock	2026-06-23 08:38:42.107162+00
port:port-dev-001-sfp-48:Port	Port	port	port-dev-001-sfp-48	XGE1/0/48	mock	2026-06-23 08:38:42.107162+00
port:port-dev-001-qsfp-1:Port	Port	port	port-dev-001-qsfp-1	100GE1/0/1	mock	2026-06-23 08:38:42.107162+00
port:port-dev-001-qsfp-2:Port	Port	port	port-dev-001-qsfp-2	100GE1/0/2	mock	2026-06-23 08:38:42.107162+00
port:port-dev-001-qsfp-3:Port	Port	port	port-dev-001-qsfp-3	100GE1/0/3	mock	2026-06-23 08:38:42.107162+00
port:port-dev-001-qsfp-4:Port	Port	port	port-dev-001-qsfp-4	100GE1/0/4	mock	2026-06-23 08:38:42.107162+00
port:port-dev-001-qsfp-5:Port	Port	port	port-dev-001-qsfp-5	100GE1/0/5	mock	2026-06-23 08:38:42.107162+00
port:port-dev-001-qsfp-6:Port	Port	port	port-dev-001-qsfp-6	100GE1/0/6	mock	2026-06-23 08:38:42.107162+00
port:port-dev-002-rj45-1:Port	Port	port	port-dev-002-rj45-1	GE1/0/1	mock	2026-06-23 08:38:42.107162+00
port:port-dev-002-rj45-2:Port	Port	port	port-dev-002-rj45-2	GE1/0/2	mock	2026-06-23 08:38:42.107162+00
port:port-dev-002-rj45-3:Port	Port	port	port-dev-002-rj45-3	GE1/0/3	mock	2026-06-23 08:38:42.107162+00
port:port-dev-002-rj45-4:Port	Port	port	port-dev-002-rj45-4	GE1/0/4	mock	2026-06-23 08:38:42.107162+00
port:port-dev-002-rj45-5:Port	Port	port	port-dev-002-rj45-5	GE1/0/5	mock	2026-06-23 08:38:42.107162+00
port:port-dev-002-rj45-6:Port	Port	port	port-dev-002-rj45-6	GE1/0/6	mock	2026-06-23 08:38:42.107162+00
port:port-dev-002-rj45-7:Port	Port	port	port-dev-002-rj45-7	GE1/0/7	mock	2026-06-23 08:38:42.107162+00
port:port-dev-002-rj45-8:Port	Port	port	port-dev-002-rj45-8	GE1/0/8	mock	2026-06-23 08:38:42.107162+00
port:port-dev-002-rj45-9:Port	Port	port	port-dev-002-rj45-9	GE1/0/9	mock	2026-06-23 08:38:42.107162+00
port:port-dev-002-rj45-10:Port	Port	port	port-dev-002-rj45-10	GE1/0/10	mock	2026-06-23 08:38:42.107162+00
port:port-dev-002-rj45-11:Port	Port	port	port-dev-002-rj45-11	GE1/0/11	mock	2026-06-23 08:38:42.107162+00
port:port-dev-002-rj45-12:Port	Port	port	port-dev-002-rj45-12	GE1/0/12	mock	2026-06-23 08:38:42.107162+00
port:port-dev-002-rj45-13:Port	Port	port	port-dev-002-rj45-13	GE1/0/13	mock	2026-06-23 08:38:42.107162+00
port:port-dev-002-rj45-14:Port	Port	port	port-dev-002-rj45-14	GE1/0/14	mock	2026-06-23 08:38:42.107162+00
port:port-dev-002-rj45-15:Port	Port	port	port-dev-002-rj45-15	GE1/0/15	mock	2026-06-23 08:38:42.107162+00
port:port-dev-002-rj45-16:Port	Port	port	port-dev-002-rj45-16	GE1/0/16	mock	2026-06-23 08:38:42.107162+00
port:port-dev-002-rj45-17:Port	Port	port	port-dev-002-rj45-17	GE1/0/17	mock	2026-06-23 08:38:42.107162+00
port:port-dev-002-rj45-18:Port	Port	port	port-dev-002-rj45-18	GE1/0/18	mock	2026-06-23 08:38:42.107162+00
port:port-dev-002-rj45-19:Port	Port	port	port-dev-002-rj45-19	GE1/0/19	mock	2026-06-23 08:38:42.107162+00
port:port-dev-002-rj45-20:Port	Port	port	port-dev-002-rj45-20	GE1/0/20	mock	2026-06-23 08:38:42.107162+00
port:port-dev-002-rj45-21:Port	Port	port	port-dev-002-rj45-21	GE1/0/21	mock	2026-06-23 08:38:42.107162+00
port:port-dev-002-rj45-22:Port	Port	port	port-dev-002-rj45-22	GE1/0/22	mock	2026-06-23 08:38:42.107162+00
port:port-dev-002-rj45-23:Port	Port	port	port-dev-002-rj45-23	GE1/0/23	mock	2026-06-23 08:38:42.107162+00
port:port-dev-002-rj45-24:Port	Port	port	port-dev-002-rj45-24	GE1/0/24	mock	2026-06-23 08:38:42.107162+00
port:port-dev-002-rj45-25:Port	Port	port	port-dev-002-rj45-25	GE1/0/25	mock	2026-06-23 08:38:42.107162+00
port:port-dev-002-rj45-26:Port	Port	port	port-dev-002-rj45-26	GE1/0/26	mock	2026-06-23 08:38:42.107162+00
port:port-dev-002-rj45-27:Port	Port	port	port-dev-002-rj45-27	GE1/0/27	mock	2026-06-23 08:38:42.107162+00
port:port-dev-002-rj45-28:Port	Port	port	port-dev-002-rj45-28	GE1/0/28	mock	2026-06-23 08:38:42.107162+00
port:port-dev-002-rj45-29:Port	Port	port	port-dev-002-rj45-29	GE1/0/29	mock	2026-06-23 08:38:42.107162+00
port:port-dev-002-rj45-30:Port	Port	port	port-dev-002-rj45-30	GE1/0/30	mock	2026-06-23 08:38:42.107162+00
port:port-dev-002-rj45-31:Port	Port	port	port-dev-002-rj45-31	GE1/0/31	mock	2026-06-23 08:38:42.107162+00
port:port-dev-002-rj45-32:Port	Port	port	port-dev-002-rj45-32	GE1/0/32	mock	2026-06-23 08:38:42.107162+00
port:port-dev-002-rj45-33:Port	Port	port	port-dev-002-rj45-33	GE1/0/33	mock	2026-06-23 08:38:42.107162+00
port:port-dev-002-rj45-34:Port	Port	port	port-dev-002-rj45-34	GE1/0/34	mock	2026-06-23 08:38:42.107162+00
port:port-dev-002-rj45-35:Port	Port	port	port-dev-002-rj45-35	GE1/0/35	mock	2026-06-23 08:38:42.107162+00
port:port-dev-002-rj45-36:Port	Port	port	port-dev-002-rj45-36	GE1/0/36	mock	2026-06-23 08:38:42.107162+00
port:port-dev-002-rj45-37:Port	Port	port	port-dev-002-rj45-37	GE1/0/37	mock	2026-06-23 08:38:42.107162+00
port:port-dev-002-rj45-38:Port	Port	port	port-dev-002-rj45-38	GE1/0/38	mock	2026-06-23 08:38:42.107162+00
port:port-dev-002-rj45-39:Port	Port	port	port-dev-002-rj45-39	GE1/0/39	mock	2026-06-23 08:38:42.107162+00
port:port-dev-002-rj45-40:Port	Port	port	port-dev-002-rj45-40	GE1/0/40	mock	2026-06-23 08:38:42.107162+00
port:port-dev-002-rj45-41:Port	Port	port	port-dev-002-rj45-41	GE1/0/41	mock	2026-06-23 08:38:42.107162+00
port:port-dev-002-rj45-42:Port	Port	port	port-dev-002-rj45-42	GE1/0/42	mock	2026-06-23 08:38:42.107162+00
port:port-dev-002-rj45-43:Port	Port	port	port-dev-002-rj45-43	GE1/0/43	mock	2026-06-23 08:38:42.107162+00
port:port-dev-002-rj45-44:Port	Port	port	port-dev-002-rj45-44	GE1/0/44	mock	2026-06-23 08:38:42.107162+00
port:port-dev-002-rj45-45:Port	Port	port	port-dev-002-rj45-45	GE1/0/45	mock	2026-06-23 08:38:42.107162+00
port:port-dev-002-rj45-46:Port	Port	port	port-dev-002-rj45-46	GE1/0/46	mock	2026-06-23 08:38:42.107162+00
port:port-dev-002-rj45-47:Port	Port	port	port-dev-002-rj45-47	GE1/0/47	mock	2026-06-23 08:38:42.107162+00
port:port-dev-002-rj45-48:Port	Port	port	port-dev-002-rj45-48	GE1/0/48	mock	2026-06-23 08:38:42.107162+00
port:port-dev-002-sfp-1:Port	Port	port	port-dev-002-sfp-1	XGE1/0/1	mock	2026-06-23 08:38:42.107162+00
port:port-dev-002-sfp-2:Port	Port	port	port-dev-002-sfp-2	XGE1/0/2	mock	2026-06-23 08:38:42.107162+00
port:port-dev-002-sfp-3:Port	Port	port	port-dev-002-sfp-3	XGE1/0/3	mock	2026-06-23 08:38:42.107162+00
port:port-dev-002-sfp-4:Port	Port	port	port-dev-002-sfp-4	XGE1/0/4	mock	2026-06-23 08:38:42.107162+00
port:port-dev-003-mgmt:Port	Port	port	port-dev-003-mgmt	Mgmt	mock	2026-06-23 08:38:42.107162+00
port:port-dev-003-eth-1:Port	Port	port	port-dev-003-eth-1	eth1	mock	2026-06-23 08:38:42.107162+00
port:port-dev-003-eth-2:Port	Port	port	port-dev-003-eth-2	eth2	mock	2026-06-23 08:38:42.107162+00
port:port-dev-003-eth-3:Port	Port	port	port-dev-003-eth-3	eth3	mock	2026-06-23 08:38:42.107162+00
port:port-dev-003-eth-4:Port	Port	port	port-dev-003-eth-4	eth4	mock	2026-06-23 08:38:42.107162+00
port:port-dev-003-pwr-1:Port	Port	port	port-dev-003-pwr-1	PWR1	mock	2026-06-23 08:38:42.107162+00
port:port-dev-003-pwr-2:Port	Port	port	port-dev-003-pwr-2	PWR2	mock	2026-06-23 08:38:42.107162+00
port:port-dev-004-mgmt:Port	Port	port	port-dev-004-mgmt	Mgmt	mock	2026-06-23 08:38:42.107162+00
port:port-dev-004-eth-1:Port	Port	port	port-dev-004-eth-1	eth1	mock	2026-06-23 08:38:42.107162+00
port:port-dev-004-eth-2:Port	Port	port	port-dev-004-eth-2	eth2	mock	2026-06-23 08:38:42.107162+00
port:port-dev-004-eth-3:Port	Port	port	port-dev-004-eth-3	eth3	mock	2026-06-23 08:38:42.107162+00
port:port-dev-004-eth-4:Port	Port	port	port-dev-004-eth-4	eth4	mock	2026-06-23 08:38:42.107162+00
port:port-dev-004-pwr-1:Port	Port	port	port-dev-004-pwr-1	PWR1	mock	2026-06-23 08:38:42.107162+00
port:port-dev-004-pwr-2:Port	Port	port	port-dev-004-pwr-2	PWR2	mock	2026-06-23 08:38:42.107162+00
port:port-dev-005-mgmt:Port	Port	port	port-dev-005-mgmt	Mgmt	mock	2026-06-23 08:38:42.107162+00
port:port-dev-005-eth-1:Port	Port	port	port-dev-005-eth-1	eth1	mock	2026-06-23 08:38:42.107162+00
port:port-dev-005-eth-2:Port	Port	port	port-dev-005-eth-2	eth2	mock	2026-06-23 08:38:42.107162+00
port:port-dev-005-eth-3:Port	Port	port	port-dev-005-eth-3	eth3	mock	2026-06-23 08:38:42.107162+00
port:port-dev-005-eth-4:Port	Port	port	port-dev-005-eth-4	eth4	mock	2026-06-23 08:38:42.107162+00
port:port-dev-005-pwr-1:Port	Port	port	port-dev-005-pwr-1	PWR1	mock	2026-06-23 08:38:42.107162+00
port:port-dev-005-pwr-2:Port	Port	port	port-dev-005-pwr-2	PWR2	mock	2026-06-23 08:38:42.107162+00
port:port-dev-006-mgmt:Port	Port	port	port-dev-006-mgmt	Mgmt	mock	2026-06-23 08:38:42.107162+00
port:port-dev-006-rj45-1:Port	Port	port	port-dev-006-rj45-1	GE0/0/1	mock	2026-06-23 08:38:42.107162+00
port:port-dev-006-rj45-2:Port	Port	port	port-dev-006-rj45-2	GE0/0/2	mock	2026-06-23 08:38:42.107162+00
port:port-dev-006-rj45-3:Port	Port	port	port-dev-006-rj45-3	GE0/0/3	mock	2026-06-23 08:38:42.107162+00
port:port-dev-006-rj45-4:Port	Port	port	port-dev-006-rj45-4	GE0/0/4	mock	2026-06-23 08:38:42.107162+00
port:port-dev-006-rj45-5:Port	Port	port	port-dev-006-rj45-5	GE0/0/5	mock	2026-06-23 08:38:42.107162+00
port:port-dev-006-rj45-6:Port	Port	port	port-dev-006-rj45-6	GE0/0/6	mock	2026-06-23 08:38:42.107162+00
port:port-dev-006-rj45-7:Port	Port	port	port-dev-006-rj45-7	GE0/0/7	mock	2026-06-23 08:38:42.107162+00
port:port-dev-006-rj45-8:Port	Port	port	port-dev-006-rj45-8	GE0/0/8	mock	2026-06-23 08:38:42.107162+00
port:port-dev-006-sfp-1:Port	Port	port	port-dev-006-sfp-1	XGE0/0/1	mock	2026-06-23 08:38:42.107162+00
port:port-dev-006-sfp-2:Port	Port	port	port-dev-006-sfp-2	XGE0/0/2	mock	2026-06-23 08:38:42.107162+00
port:port-dev-006-sfp-3:Port	Port	port	port-dev-006-sfp-3	XGE0/0/3	mock	2026-06-23 08:38:42.107162+00
port:port-dev-006-sfp-4:Port	Port	port	port-dev-006-sfp-4	XGE0/0/4	mock	2026-06-23 08:38:42.107162+00
port:port-dev-007-mgmt:Port	Port	port	port-dev-007-mgmt	Mgmt	mock	2026-06-23 08:38:42.107162+00
port:port-dev-007-sfp-1:Port	Port	port	port-dev-007-sfp-1	XGE1/1	mock	2026-06-23 08:38:42.107162+00
port:port-dev-007-sfp-2:Port	Port	port	port-dev-007-sfp-2	XGE1/2	mock	2026-06-23 08:38:42.107162+00
port:port-dev-007-sfp-3:Port	Port	port	port-dev-007-sfp-3	XGE1/3	mock	2026-06-23 08:38:42.107162+00
port:port-dev-007-sfp-4:Port	Port	port	port-dev-007-sfp-4	XGE1/4	mock	2026-06-23 08:38:42.107162+00
port:port-dev-007-sfp-5:Port	Port	port	port-dev-007-sfp-5	XGE1/5	mock	2026-06-23 08:38:42.107162+00
port:port-dev-007-sfp-6:Port	Port	port	port-dev-007-sfp-6	XGE1/6	mock	2026-06-23 08:38:42.107162+00
port:port-dev-007-sfp-7:Port	Port	port	port-dev-007-sfp-7	XGE1/7	mock	2026-06-23 08:38:42.107162+00
port:port-dev-007-sfp-8:Port	Port	port	port-dev-007-sfp-8	XGE1/8	mock	2026-06-23 08:38:42.107162+00
port:port-dev-008-mgmt-1:Port	Port	port	port-dev-008-mgmt-1	Mgmt1	mock	2026-06-23 08:38:42.107162+00
port:port-dev-008-mgmt-2:Port	Port	port	port-dev-008-mgmt-2	Mgmt2	mock	2026-06-23 08:38:42.107162+00
port:port-dev-008-fc-1:Port	Port	port	port-dev-008-fc-1	FC1	mock	2026-06-23 08:38:42.107162+00
port:port-dev-008-fc-2:Port	Port	port	port-dev-008-fc-2	FC2	mock	2026-06-23 08:38:42.107162+00
port:port-dev-008-fc-3:Port	Port	port	port-dev-008-fc-3	FC3	mock	2026-06-23 08:38:42.107162+00
port:port-dev-008-fc-4:Port	Port	port	port-dev-008-fc-4	FC4	mock	2026-06-23 08:38:42.107162+00
port:port-dev-008-fc-5:Port	Port	port	port-dev-008-fc-5	FC5	mock	2026-06-23 08:38:42.107162+00
port:port-dev-008-fc-6:Port	Port	port	port-dev-008-fc-6	FC6	mock	2026-06-23 08:38:42.107162+00
port:port-dev-008-fc-7:Port	Port	port	port-dev-008-fc-7	FC7	mock	2026-06-23 08:38:42.107162+00
port:port-dev-008-fc-8:Port	Port	port	port-dev-008-fc-8	FC8	mock	2026-06-23 08:38:42.107162+00
port:port-dev-008-iscsi-1:Port	Port	port	port-dev-008-iscsi-1	iSCSI1	mock	2026-06-23 08:38:42.107162+00
port:port-dev-008-iscsi-2:Port	Port	port	port-dev-008-iscsi-2	iSCSI2	mock	2026-06-23 08:38:42.107162+00
port:port-dev-008-iscsi-3:Port	Port	port	port-dev-008-iscsi-3	iSCSI3	mock	2026-06-23 08:38:42.107162+00
port:port-dev-008-iscsi-4:Port	Port	port	port-dev-008-iscsi-4	iSCSI4	mock	2026-06-23 08:38:42.107162+00
port:port-dev-009-rj45-1:Port	Port	port	port-dev-009-rj45-1	GE1/0/1	mock	2026-06-23 08:38:42.107162+00
port:port-dev-009-rj45-2:Port	Port	port	port-dev-009-rj45-2	GE1/0/2	mock	2026-06-23 08:38:42.107162+00
port:port-dev-009-rj45-3:Port	Port	port	port-dev-009-rj45-3	GE1/0/3	mock	2026-06-23 08:38:42.107162+00
port:port-dev-009-rj45-4:Port	Port	port	port-dev-009-rj45-4	GE1/0/4	mock	2026-06-23 08:38:42.107162+00
port:port-dev-009-rj45-5:Port	Port	port	port-dev-009-rj45-5	GE1/0/5	mock	2026-06-23 08:38:42.107162+00
port:port-dev-009-rj45-6:Port	Port	port	port-dev-009-rj45-6	GE1/0/6	mock	2026-06-23 08:38:42.107162+00
port:port-dev-009-rj45-7:Port	Port	port	port-dev-009-rj45-7	GE1/0/7	mock	2026-06-23 08:38:42.107162+00
port:port-dev-009-rj45-8:Port	Port	port	port-dev-009-rj45-8	GE1/0/8	mock	2026-06-23 08:38:42.107162+00
port:port-dev-009-rj45-9:Port	Port	port	port-dev-009-rj45-9	GE1/0/9	mock	2026-06-23 08:38:42.107162+00
port:port-dev-009-rj45-10:Port	Port	port	port-dev-009-rj45-10	GE1/0/10	mock	2026-06-23 08:38:42.107162+00
port:port-dev-009-rj45-11:Port	Port	port	port-dev-009-rj45-11	GE1/0/11	mock	2026-06-23 08:38:42.107162+00
port:port-dev-009-rj45-12:Port	Port	port	port-dev-009-rj45-12	GE1/0/12	mock	2026-06-23 08:38:42.107162+00
port:port-dev-009-rj45-13:Port	Port	port	port-dev-009-rj45-13	GE1/0/13	mock	2026-06-23 08:38:42.107162+00
port:port-dev-009-rj45-14:Port	Port	port	port-dev-009-rj45-14	GE1/0/14	mock	2026-06-23 08:38:42.107162+00
port:port-dev-009-rj45-15:Port	Port	port	port-dev-009-rj45-15	GE1/0/15	mock	2026-06-23 08:38:42.107162+00
port:port-dev-009-rj45-16:Port	Port	port	port-dev-009-rj45-16	GE1/0/16	mock	2026-06-23 08:38:42.107162+00
port:port-dev-009-rj45-17:Port	Port	port	port-dev-009-rj45-17	GE1/0/17	mock	2026-06-23 08:38:42.107162+00
port:port-dev-009-rj45-18:Port	Port	port	port-dev-009-rj45-18	GE1/0/18	mock	2026-06-23 08:38:42.107162+00
port:port-dev-009-rj45-19:Port	Port	port	port-dev-009-rj45-19	GE1/0/19	mock	2026-06-23 08:38:42.107162+00
port:port-dev-009-rj45-20:Port	Port	port	port-dev-009-rj45-20	GE1/0/20	mock	2026-06-23 08:38:42.107162+00
port:port-dev-009-rj45-21:Port	Port	port	port-dev-009-rj45-21	GE1/0/21	mock	2026-06-23 08:38:42.107162+00
port:port-dev-009-rj45-22:Port	Port	port	port-dev-009-rj45-22	GE1/0/22	mock	2026-06-23 08:38:42.107162+00
port:port-dev-009-rj45-23:Port	Port	port	port-dev-009-rj45-23	GE1/0/23	mock	2026-06-23 08:38:42.107162+00
port:port-dev-009-rj45-24:Port	Port	port	port-dev-009-rj45-24	GE1/0/24	mock	2026-06-23 08:38:42.107162+00
port:port-dev-009-rj45-25:Port	Port	port	port-dev-009-rj45-25	GE1/0/25	mock	2026-06-23 08:38:42.107162+00
port:port-dev-009-rj45-26:Port	Port	port	port-dev-009-rj45-26	GE1/0/26	mock	2026-06-23 08:38:42.107162+00
port:port-dev-009-rj45-27:Port	Port	port	port-dev-009-rj45-27	GE1/0/27	mock	2026-06-23 08:38:42.107162+00
port:port-dev-009-rj45-28:Port	Port	port	port-dev-009-rj45-28	GE1/0/28	mock	2026-06-23 08:38:42.107162+00
port:port-dev-009-rj45-29:Port	Port	port	port-dev-009-rj45-29	GE1/0/29	mock	2026-06-23 08:38:42.107162+00
port:port-dev-009-rj45-30:Port	Port	port	port-dev-009-rj45-30	GE1/0/30	mock	2026-06-23 08:38:42.107162+00
port:port-dev-009-rj45-31:Port	Port	port	port-dev-009-rj45-31	GE1/0/31	mock	2026-06-23 08:38:42.107162+00
port:port-dev-009-rj45-32:Port	Port	port	port-dev-009-rj45-32	GE1/0/32	mock	2026-06-23 08:38:42.107162+00
port:port-dev-009-rj45-33:Port	Port	port	port-dev-009-rj45-33	GE1/0/33	mock	2026-06-23 08:38:42.107162+00
port:port-dev-009-rj45-34:Port	Port	port	port-dev-009-rj45-34	GE1/0/34	mock	2026-06-23 08:38:42.107162+00
port:port-dev-009-rj45-35:Port	Port	port	port-dev-009-rj45-35	GE1/0/35	mock	2026-06-23 08:38:42.107162+00
port:port-dev-009-rj45-36:Port	Port	port	port-dev-009-rj45-36	GE1/0/36	mock	2026-06-23 08:38:42.107162+00
port:port-dev-009-rj45-37:Port	Port	port	port-dev-009-rj45-37	GE1/0/37	mock	2026-06-23 08:38:42.107162+00
port:port-dev-009-rj45-38:Port	Port	port	port-dev-009-rj45-38	GE1/0/38	mock	2026-06-23 08:38:42.107162+00
port:port-dev-009-rj45-39:Port	Port	port	port-dev-009-rj45-39	GE1/0/39	mock	2026-06-23 08:38:42.107162+00
port:port-dev-009-rj45-40:Port	Port	port	port-dev-009-rj45-40	GE1/0/40	mock	2026-06-23 08:38:42.107162+00
port:port-dev-009-rj45-41:Port	Port	port	port-dev-009-rj45-41	GE1/0/41	mock	2026-06-23 08:38:42.107162+00
port:port-dev-009-rj45-42:Port	Port	port	port-dev-009-rj45-42	GE1/0/42	mock	2026-06-23 08:38:42.107162+00
port:port-dev-009-rj45-43:Port	Port	port	port-dev-009-rj45-43	GE1/0/43	mock	2026-06-23 08:38:42.107162+00
port:port-dev-009-rj45-44:Port	Port	port	port-dev-009-rj45-44	GE1/0/44	mock	2026-06-23 08:38:42.107162+00
port:port-dev-009-rj45-45:Port	Port	port	port-dev-009-rj45-45	GE1/0/45	mock	2026-06-23 08:38:42.107162+00
port:port-dev-009-rj45-46:Port	Port	port	port-dev-009-rj45-46	GE1/0/46	mock	2026-06-23 08:38:42.107162+00
port:port-dev-009-rj45-47:Port	Port	port	port-dev-009-rj45-47	GE1/0/47	mock	2026-06-23 08:38:42.107162+00
port:port-dev-009-rj45-48:Port	Port	port	port-dev-009-rj45-48	GE1/0/48	mock	2026-06-23 08:38:42.107162+00
port:port-dev-009-sfp-1:Port	Port	port	port-dev-009-sfp-1	XGE1/0/1	mock	2026-06-23 08:38:42.107162+00
port:port-dev-009-sfp-2:Port	Port	port	port-dev-009-sfp-2	XGE1/0/2	mock	2026-06-23 08:38:42.107162+00
port:port-dev-009-sfp-3:Port	Port	port	port-dev-009-sfp-3	XGE1/0/3	mock	2026-06-23 08:38:42.107162+00
port:port-dev-009-sfp-4:Port	Port	port	port-dev-009-sfp-4	XGE1/0/4	mock	2026-06-23 08:38:42.107162+00
port:port-dev-010-sfp-1:Port	Port	port	port-dev-010-sfp-1	XGE1/0/1	mock	2026-06-23 08:38:42.107162+00
port:port-dev-010-sfp-2:Port	Port	port	port-dev-010-sfp-2	XGE1/0/2	mock	2026-06-23 08:38:42.107162+00
port:port-dev-010-sfp-3:Port	Port	port	port-dev-010-sfp-3	XGE1/0/3	mock	2026-06-23 08:38:42.107162+00
port:port-dev-010-sfp-4:Port	Port	port	port-dev-010-sfp-4	XGE1/0/4	mock	2026-06-23 08:38:42.107162+00
port:port-dev-010-sfp-5:Port	Port	port	port-dev-010-sfp-5	XGE1/0/5	mock	2026-06-23 08:38:42.107162+00
port:port-dev-010-sfp-6:Port	Port	port	port-dev-010-sfp-6	XGE1/0/6	mock	2026-06-23 08:38:42.107162+00
port:port-dev-010-sfp-7:Port	Port	port	port-dev-010-sfp-7	XGE1/0/7	mock	2026-06-23 08:38:42.107162+00
port:port-dev-010-sfp-8:Port	Port	port	port-dev-010-sfp-8	XGE1/0/8	mock	2026-06-23 08:38:42.107162+00
port:port-dev-010-sfp-9:Port	Port	port	port-dev-010-sfp-9	XGE1/0/9	mock	2026-06-23 08:38:42.107162+00
port:port-dev-010-sfp-10:Port	Port	port	port-dev-010-sfp-10	XGE1/0/10	mock	2026-06-23 08:38:42.107162+00
port:port-dev-010-sfp-11:Port	Port	port	port-dev-010-sfp-11	XGE1/0/11	mock	2026-06-23 08:38:42.107162+00
port:port-dev-010-sfp-12:Port	Port	port	port-dev-010-sfp-12	XGE1/0/12	mock	2026-06-23 08:38:42.107162+00
port:port-dev-010-sfp-13:Port	Port	port	port-dev-010-sfp-13	XGE1/0/13	mock	2026-06-23 08:38:42.107162+00
port:port-dev-010-sfp-14:Port	Port	port	port-dev-010-sfp-14	XGE1/0/14	mock	2026-06-23 08:38:42.107162+00
port:port-dev-010-sfp-15:Port	Port	port	port-dev-010-sfp-15	XGE1/0/15	mock	2026-06-23 08:38:42.107162+00
port:port-dev-010-sfp-16:Port	Port	port	port-dev-010-sfp-16	XGE1/0/16	mock	2026-06-23 08:38:42.107162+00
port:port-dev-010-sfp-17:Port	Port	port	port-dev-010-sfp-17	XGE1/0/17	mock	2026-06-23 08:38:42.107162+00
port:port-dev-010-sfp-18:Port	Port	port	port-dev-010-sfp-18	XGE1/0/18	mock	2026-06-23 08:38:42.107162+00
port:port-dev-010-sfp-19:Port	Port	port	port-dev-010-sfp-19	XGE1/0/19	mock	2026-06-23 08:38:42.107162+00
port:port-dev-010-sfp-20:Port	Port	port	port-dev-010-sfp-20	XGE1/0/20	mock	2026-06-23 08:38:42.107162+00
port:port-dev-010-sfp-21:Port	Port	port	port-dev-010-sfp-21	XGE1/0/21	mock	2026-06-23 08:38:42.107162+00
port:port-dev-010-sfp-22:Port	Port	port	port-dev-010-sfp-22	XGE1/0/22	mock	2026-06-23 08:38:42.107162+00
port:port-dev-010-sfp-23:Port	Port	port	port-dev-010-sfp-23	XGE1/0/23	mock	2026-06-23 08:38:42.107162+00
port:port-dev-010-sfp-24:Port	Port	port	port-dev-010-sfp-24	XGE1/0/24	mock	2026-06-23 08:38:42.107162+00
port:port-dev-010-sfp-25:Port	Port	port	port-dev-010-sfp-25	XGE1/0/25	mock	2026-06-23 08:38:42.107162+00
port:port-dev-010-sfp-26:Port	Port	port	port-dev-010-sfp-26	XGE1/0/26	mock	2026-06-23 08:38:42.107162+00
port:port-dev-010-sfp-27:Port	Port	port	port-dev-010-sfp-27	XGE1/0/27	mock	2026-06-23 08:38:42.107162+00
port:port-dev-010-sfp-28:Port	Port	port	port-dev-010-sfp-28	XGE1/0/28	mock	2026-06-23 08:38:42.107162+00
port:port-dev-010-sfp-29:Port	Port	port	port-dev-010-sfp-29	XGE1/0/29	mock	2026-06-23 08:38:42.107162+00
port:port-dev-010-sfp-30:Port	Port	port	port-dev-010-sfp-30	XGE1/0/30	mock	2026-06-23 08:38:42.107162+00
port:port-dev-010-sfp-31:Port	Port	port	port-dev-010-sfp-31	XGE1/0/31	mock	2026-06-23 08:38:42.107162+00
port:port-dev-010-sfp-32:Port	Port	port	port-dev-010-sfp-32	XGE1/0/32	mock	2026-06-23 08:38:42.107162+00
port:port-dev-010-sfp-33:Port	Port	port	port-dev-010-sfp-33	XGE1/0/33	mock	2026-06-23 08:38:42.107162+00
port:port-dev-010-sfp-34:Port	Port	port	port-dev-010-sfp-34	XGE1/0/34	mock	2026-06-23 08:38:42.107162+00
port:port-dev-010-sfp-35:Port	Port	port	port-dev-010-sfp-35	XGE1/0/35	mock	2026-06-23 08:38:42.107162+00
port:port-dev-010-sfp-36:Port	Port	port	port-dev-010-sfp-36	XGE1/0/36	mock	2026-06-23 08:38:42.107162+00
port:port-dev-010-sfp-37:Port	Port	port	port-dev-010-sfp-37	XGE1/0/37	mock	2026-06-23 08:38:42.107162+00
port:port-dev-010-sfp-38:Port	Port	port	port-dev-010-sfp-38	XGE1/0/38	mock	2026-06-23 08:38:42.107162+00
port:port-dev-010-sfp-39:Port	Port	port	port-dev-010-sfp-39	XGE1/0/39	mock	2026-06-23 08:38:42.107162+00
port:port-dev-010-sfp-40:Port	Port	port	port-dev-010-sfp-40	XGE1/0/40	mock	2026-06-23 08:38:42.107162+00
port:port-dev-010-sfp-41:Port	Port	port	port-dev-010-sfp-41	XGE1/0/41	mock	2026-06-23 08:38:42.107162+00
port:port-dev-010-sfp-42:Port	Port	port	port-dev-010-sfp-42	XGE1/0/42	mock	2026-06-23 08:38:42.107162+00
port:port-dev-010-sfp-43:Port	Port	port	port-dev-010-sfp-43	XGE1/0/43	mock	2026-06-23 08:38:42.107162+00
port:port-dev-010-sfp-44:Port	Port	port	port-dev-010-sfp-44	XGE1/0/44	mock	2026-06-23 08:38:42.107162+00
port:port-dev-010-sfp-45:Port	Port	port	port-dev-010-sfp-45	XGE1/0/45	mock	2026-06-23 08:38:42.107162+00
port:port-dev-010-sfp-46:Port	Port	port	port-dev-010-sfp-46	XGE1/0/46	mock	2026-06-23 08:38:42.107162+00
port:port-dev-010-sfp-47:Port	Port	port	port-dev-010-sfp-47	XGE1/0/47	mock	2026-06-23 08:38:42.107162+00
port:port-dev-010-sfp-48:Port	Port	port	port-dev-010-sfp-48	XGE1/0/48	mock	2026-06-23 08:38:42.107162+00
port:port-dev-010-qsfp-1:Port	Port	port	port-dev-010-qsfp-1	100GE1/0/1	mock	2026-06-23 08:38:42.107162+00
port:port-dev-010-qsfp-2:Port	Port	port	port-dev-010-qsfp-2	100GE1/0/2	mock	2026-06-23 08:38:42.107162+00
port:port-dev-010-qsfp-3:Port	Port	port	port-dev-010-qsfp-3	100GE1/0/3	mock	2026-06-23 08:38:42.107162+00
port:port-dev-010-qsfp-4:Port	Port	port	port-dev-010-qsfp-4	100GE1/0/4	mock	2026-06-23 08:38:42.107162+00
port:port-dev-010-qsfp-5:Port	Port	port	port-dev-010-qsfp-5	100GE1/0/5	mock	2026-06-23 08:38:42.107162+00
port:port-dev-010-qsfp-6:Port	Port	port	port-dev-010-qsfp-6	100GE1/0/6	mock	2026-06-23 08:38:42.107162+00
port:port-dev-011-sfp-1:Port	Port	port	port-dev-011-sfp-1	XGE1/0/1	mock	2026-06-23 08:38:42.107162+00
port:port-dev-011-sfp-2:Port	Port	port	port-dev-011-sfp-2	XGE1/0/2	mock	2026-06-23 08:38:42.107162+00
port:port-dev-011-sfp-3:Port	Port	port	port-dev-011-sfp-3	XGE1/0/3	mock	2026-06-23 08:38:42.107162+00
port:port-dev-011-sfp-4:Port	Port	port	port-dev-011-sfp-4	XGE1/0/4	mock	2026-06-23 08:38:42.107162+00
port:port-dev-011-sfp-5:Port	Port	port	port-dev-011-sfp-5	XGE1/0/5	mock	2026-06-23 08:38:42.107162+00
port:port-dev-011-sfp-6:Port	Port	port	port-dev-011-sfp-6	XGE1/0/6	mock	2026-06-23 08:38:42.107162+00
port:port-dev-011-sfp-7:Port	Port	port	port-dev-011-sfp-7	XGE1/0/7	mock	2026-06-23 08:38:42.107162+00
port:port-dev-011-sfp-8:Port	Port	port	port-dev-011-sfp-8	XGE1/0/8	mock	2026-06-23 08:38:42.107162+00
port:port-dev-011-sfp-9:Port	Port	port	port-dev-011-sfp-9	XGE1/0/9	mock	2026-06-23 08:38:42.107162+00
port:port-dev-011-sfp-10:Port	Port	port	port-dev-011-sfp-10	XGE1/0/10	mock	2026-06-23 08:38:42.107162+00
port:port-dev-011-sfp-11:Port	Port	port	port-dev-011-sfp-11	XGE1/0/11	mock	2026-06-23 08:38:42.107162+00
port:port-dev-011-sfp-12:Port	Port	port	port-dev-011-sfp-12	XGE1/0/12	mock	2026-06-23 08:38:42.107162+00
port:port-dev-011-sfp-13:Port	Port	port	port-dev-011-sfp-13	XGE1/0/13	mock	2026-06-23 08:38:42.107162+00
port:port-dev-011-sfp-14:Port	Port	port	port-dev-011-sfp-14	XGE1/0/14	mock	2026-06-23 08:38:42.107162+00
port:port-dev-011-sfp-15:Port	Port	port	port-dev-011-sfp-15	XGE1/0/15	mock	2026-06-23 08:38:42.107162+00
port:port-dev-011-sfp-16:Port	Port	port	port-dev-011-sfp-16	XGE1/0/16	mock	2026-06-23 08:38:42.107162+00
port:port-dev-011-sfp-17:Port	Port	port	port-dev-011-sfp-17	XGE1/0/17	mock	2026-06-23 08:38:42.107162+00
port:port-dev-011-sfp-18:Port	Port	port	port-dev-011-sfp-18	XGE1/0/18	mock	2026-06-23 08:38:42.107162+00
port:port-dev-011-sfp-19:Port	Port	port	port-dev-011-sfp-19	XGE1/0/19	mock	2026-06-23 08:38:42.107162+00
port:port-dev-011-sfp-20:Port	Port	port	port-dev-011-sfp-20	XGE1/0/20	mock	2026-06-23 08:38:42.107162+00
port:port-dev-011-sfp-21:Port	Port	port	port-dev-011-sfp-21	XGE1/0/21	mock	2026-06-23 08:38:42.107162+00
port:port-dev-011-sfp-22:Port	Port	port	port-dev-011-sfp-22	XGE1/0/22	mock	2026-06-23 08:38:42.107162+00
port:port-dev-011-sfp-23:Port	Port	port	port-dev-011-sfp-23	XGE1/0/23	mock	2026-06-23 08:38:42.107162+00
port:port-dev-011-sfp-24:Port	Port	port	port-dev-011-sfp-24	XGE1/0/24	mock	2026-06-23 08:38:42.107162+00
port:port-dev-011-sfp-25:Port	Port	port	port-dev-011-sfp-25	XGE1/0/25	mock	2026-06-23 08:38:42.107162+00
port:port-dev-011-sfp-26:Port	Port	port	port-dev-011-sfp-26	XGE1/0/26	mock	2026-06-23 08:38:42.107162+00
port:port-dev-011-sfp-27:Port	Port	port	port-dev-011-sfp-27	XGE1/0/27	mock	2026-06-23 08:38:42.107162+00
port:port-dev-011-sfp-28:Port	Port	port	port-dev-011-sfp-28	XGE1/0/28	mock	2026-06-23 08:38:42.107162+00
port:port-dev-011-sfp-29:Port	Port	port	port-dev-011-sfp-29	XGE1/0/29	mock	2026-06-23 08:38:42.107162+00
port:port-dev-011-sfp-30:Port	Port	port	port-dev-011-sfp-30	XGE1/0/30	mock	2026-06-23 08:38:42.107162+00
port:port-dev-011-sfp-31:Port	Port	port	port-dev-011-sfp-31	XGE1/0/31	mock	2026-06-23 08:38:42.107162+00
port:port-dev-011-sfp-32:Port	Port	port	port-dev-011-sfp-32	XGE1/0/32	mock	2026-06-23 08:38:42.107162+00
port:port-dev-011-sfp-33:Port	Port	port	port-dev-011-sfp-33	XGE1/0/33	mock	2026-06-23 08:38:42.107162+00
port:port-dev-011-sfp-34:Port	Port	port	port-dev-011-sfp-34	XGE1/0/34	mock	2026-06-23 08:38:42.107162+00
port:port-dev-011-sfp-35:Port	Port	port	port-dev-011-sfp-35	XGE1/0/35	mock	2026-06-23 08:38:42.107162+00
port:port-dev-011-sfp-36:Port	Port	port	port-dev-011-sfp-36	XGE1/0/36	mock	2026-06-23 08:38:42.107162+00
port:port-dev-011-sfp-37:Port	Port	port	port-dev-011-sfp-37	XGE1/0/37	mock	2026-06-23 08:38:42.107162+00
port:port-dev-011-sfp-38:Port	Port	port	port-dev-011-sfp-38	XGE1/0/38	mock	2026-06-23 08:38:42.107162+00
port:port-dev-011-sfp-39:Port	Port	port	port-dev-011-sfp-39	XGE1/0/39	mock	2026-06-23 08:38:42.107162+00
port:port-dev-011-sfp-40:Port	Port	port	port-dev-011-sfp-40	XGE1/0/40	mock	2026-06-23 08:38:42.107162+00
port:port-dev-011-sfp-41:Port	Port	port	port-dev-011-sfp-41	XGE1/0/41	mock	2026-06-23 08:38:42.107162+00
port:port-dev-011-sfp-42:Port	Port	port	port-dev-011-sfp-42	XGE1/0/42	mock	2026-06-23 08:38:42.107162+00
port:port-dev-011-sfp-43:Port	Port	port	port-dev-011-sfp-43	XGE1/0/43	mock	2026-06-23 08:38:42.107162+00
port:port-dev-011-sfp-44:Port	Port	port	port-dev-011-sfp-44	XGE1/0/44	mock	2026-06-23 08:38:42.107162+00
port:port-dev-011-sfp-45:Port	Port	port	port-dev-011-sfp-45	XGE1/0/45	mock	2026-06-23 08:38:42.107162+00
port:port-dev-011-sfp-46:Port	Port	port	port-dev-011-sfp-46	XGE1/0/46	mock	2026-06-23 08:38:42.107162+00
port:port-dev-011-sfp-47:Port	Port	port	port-dev-011-sfp-47	XGE1/0/47	mock	2026-06-23 08:38:42.107162+00
port:port-dev-011-sfp-48:Port	Port	port	port-dev-011-sfp-48	XGE1/0/48	mock	2026-06-23 08:38:42.107162+00
port:port-dev-011-qsfp-1:Port	Port	port	port-dev-011-qsfp-1	40GE1/0/1	mock	2026-06-23 08:38:42.107162+00
port:port-dev-011-qsfp-2:Port	Port	port	port-dev-011-qsfp-2	40GE1/0/2	mock	2026-06-23 08:38:42.107162+00
port:port-dev-011-qsfp-3:Port	Port	port	port-dev-011-qsfp-3	40GE1/0/3	mock	2026-06-23 08:38:42.107162+00
port:port-dev-011-qsfp-4:Port	Port	port	port-dev-011-qsfp-4	40GE1/0/4	mock	2026-06-23 08:38:42.107162+00
port:port-dev-011-qsfp-5:Port	Port	port	port-dev-011-qsfp-5	40GE1/0/5	mock	2026-06-23 08:38:42.107162+00
port:port-dev-011-qsfp-6:Port	Port	port	port-dev-011-qsfp-6	40GE1/0/6	mock	2026-06-23 08:38:42.107162+00
port:port-dev-011-qsfp-7:Port	Port	port	port-dev-011-qsfp-7	40GE1/0/7	mock	2026-06-23 08:38:42.107162+00
port:port-dev-011-qsfp-8:Port	Port	port	port-dev-011-qsfp-8	40GE1/0/8	mock	2026-06-23 08:38:42.107162+00
port:port-dev-012-mgmt:Port	Port	port	port-dev-012-mgmt	Mgmt	mock	2026-06-23 08:38:42.107162+00
port:port-dev-012-eth-1:Port	Port	port	port-dev-012-eth-1	eth1	mock	2026-06-23 08:38:42.107162+00
port:port-dev-012-eth-2:Port	Port	port	port-dev-012-eth-2	eth2	mock	2026-06-23 08:38:42.107162+00
port:port-dev-012-eth-3:Port	Port	port	port-dev-012-eth-3	eth3	mock	2026-06-23 08:38:42.107162+00
port:port-dev-012-eth-4:Port	Port	port	port-dev-012-eth-4	eth4	mock	2026-06-23 08:38:42.107162+00
port:port-dev-012-pwr-1:Port	Port	port	port-dev-012-pwr-1	PWR1	mock	2026-06-23 08:38:42.107162+00
port:port-dev-012-pwr-2:Port	Port	port	port-dev-012-pwr-2	PWR2	mock	2026-06-23 08:38:42.107162+00
power_node:utility-001:UtilityFeed	UtilityFeed	power_node	utility-001	市电A路	mock	2026-06-23 08:38:42.107162+00
power_node:utility-002:UtilityFeed	UtilityFeed	power_node	utility-002	市电B路	mock	2026-06-23 08:38:42.107162+00
power_node:ups-001:UPS	UPS	power_node	ups-001	UPS-A-01	mock	2026-06-23 08:38:42.107162+00
power_node:ups-002:UPS	UPS	power_node	ups-002	UPS-B-01	mock	2026-06-23 08:38:42.107162+00
power_node:pdu-001:PDU	PDU	power_node	pdu-001	PDU-A-01	mock	2026-06-23 08:38:42.107162+00
power_node:pdu-002:PDU	PDU	power_node	pdu-002	PDU-B-01	mock	2026-06-23 08:38:42.107162+00
power_node:pdu-003:PDU	PDU	power_node	pdu-003	PDU-A-02	mock	2026-06-23 08:38:42.107162+00
power_node:pdu-004:PDU	PDU	power_node	pdu-004	PDU-B-02	mock	2026-06-23 08:38:42.107162+00
power_node:dev-001:DEVICE	DEVICE	power_node	dev-001	核心交换机-A1	mock	2026-06-23 08:38:42.107162+00
power_node:dev-002:DEVICE	DEVICE	power_node	dev-002	接入交换机-A1-1	mock	2026-06-23 08:38:42.107162+00
power_node:dev-003:DEVICE	DEVICE	power_node	dev-003	应用服务器-A1-1	mock	2026-06-23 08:38:42.107162+00
power_node:dev-004:DEVICE	DEVICE	power_node	dev-004	应用服务器-A1-2	mock	2026-06-23 08:38:42.107162+00
power_node:utility-101:UtilityFeed	UtilityFeed	power_node	utility-101	市电A路	mock	2026-06-23 08:38:42.107162+00
power_node:utility-102:UtilityFeed	UtilityFeed	power_node	utility-102	市电B路	mock	2026-06-23 08:38:42.107162+00
power_node:ups-101:UPS	UPS	power_node	ups-101	UPS-A-01	mock	2026-06-23 08:38:42.107162+00
power_node:ups-102:UPS	UPS	power_node	ups-102	UPS-B-01	mock	2026-06-23 08:38:42.107162+00
power_node:pdu-101:PDU	PDU	power_node	pdu-101	PDU-A-01	mock	2026-06-23 08:38:42.107162+00
power_node:pdu-102:PDU	PDU	power_node	pdu-102	PDU-B-01	mock	2026-06-23 08:38:42.107162+00
power_node:dev-009:DEVICE	DEVICE	power_node	dev-009	接入交换机-B1-1	mock	2026-06-23 08:38:42.107162+00
power_node:dev-010:DEVICE	DEVICE	power_node	dev-010	核心交换机-B1	mock	2026-06-23 08:38:42.107162+00
\.


--
-- Data for Name: ontology_relationship; Type: TABLE DATA; Schema: dcim_ontology_demo_20260623083835; Owner: -
--

COPY "__DCIM_TARGET_SCHEMA__".ontology_relationship (id, relationship_type, source_individual_id, target_individual_id, fact_table, fact_id, valid_from, valid_to, source_system, confidence) FROM stdin;
contains:datacenter:dc-001:Datacenter->cabinet:cab-bj-001:Cabinet:cab-bj-001	contains	datacenter:dc-001:Datacenter	cabinet:cab-bj-001:Cabinet	cabinet	cab-bj-001	2023-01-20 08:00:00+00	\N	mock	1.000
contains:datacenter:dc-001:Datacenter->cabinet:cab-bj-002:Cabinet:cab-bj-002	contains	datacenter:dc-001:Datacenter	cabinet:cab-bj-002:Cabinet	cabinet	cab-bj-002	2023-01-20 08:00:00+00	\N	mock	1.000
contains:datacenter:dc-001:Datacenter->cabinet:cab-bj-003:Cabinet:cab-bj-003	contains	datacenter:dc-001:Datacenter	cabinet:cab-bj-003:Cabinet	cabinet	cab-bj-003	2023-01-20 08:00:00+00	\N	mock	1.000
contains:datacenter:dc-001:Datacenter->cabinet:cab-bj-004:Cabinet:cab-bj-004	contains	datacenter:dc-001:Datacenter	cabinet:cab-bj-004:Cabinet	cabinet	cab-bj-004	2023-01-20 08:00:00+00	\N	mock	1.000
contains:datacenter:dc-001:Datacenter->cabinet:cab-bj-005:Cabinet:cab-bj-005	contains	datacenter:dc-001:Datacenter	cabinet:cab-bj-005:Cabinet	cabinet	cab-bj-005	2023-01-20 08:00:00+00	\N	mock	1.000
contains:datacenter:dc-001:Datacenter->cabinet:cab-bj-006:Cabinet:cab-bj-006	contains	datacenter:dc-001:Datacenter	cabinet:cab-bj-006:Cabinet	cabinet	cab-bj-006	2023-01-20 08:00:00+00	\N	mock	1.000
contains:datacenter:dc-001:Datacenter->cabinet:cab-bj-007:Cabinet:cab-bj-007	contains	datacenter:dc-001:Datacenter	cabinet:cab-bj-007:Cabinet	cabinet	cab-bj-007	2023-01-20 08:00:00+00	\N	mock	1.000
contains:datacenter:dc-001:Datacenter->cabinet:cab-bj-008:Cabinet:cab-bj-008	contains	datacenter:dc-001:Datacenter	cabinet:cab-bj-008:Cabinet	cabinet	cab-bj-008	2023-01-20 08:00:00+00	\N	mock	1.000
contains:datacenter:dc-001:Datacenter->cabinet:cab-bj-009:Cabinet:cab-bj-009	contains	datacenter:dc-001:Datacenter	cabinet:cab-bj-009:Cabinet	cabinet	cab-bj-009	2023-01-20 08:00:00+00	\N	mock	1.000
contains:datacenter:dc-001:Datacenter->cabinet:cab-bj-010:Cabinet:cab-bj-010	contains	datacenter:dc-001:Datacenter	cabinet:cab-bj-010:Cabinet	cabinet	cab-bj-010	2023-01-20 08:00:00+00	\N	mock	1.000
contains:datacenter:dc-001:Datacenter->cabinet:cab-bj-011:Cabinet:cab-bj-011	contains	datacenter:dc-001:Datacenter	cabinet:cab-bj-011:Cabinet	cabinet	cab-bj-011	2023-01-20 08:00:00+00	\N	mock	1.000
contains:datacenter:dc-001:Datacenter->cabinet:cab-bj-012:Cabinet:cab-bj-012	contains	datacenter:dc-001:Datacenter	cabinet:cab-bj-012:Cabinet	cabinet	cab-bj-012	2023-01-20 08:00:00+00	\N	mock	1.000
contains:datacenter:dc-001:Datacenter->cabinet:cab-bj-013:Cabinet:cab-bj-013	contains	datacenter:dc-001:Datacenter	cabinet:cab-bj-013:Cabinet	cabinet	cab-bj-013	2023-01-20 08:00:00+00	\N	mock	1.000
contains:datacenter:dc-001:Datacenter->cabinet:cab-bj-014:Cabinet:cab-bj-014	contains	datacenter:dc-001:Datacenter	cabinet:cab-bj-014:Cabinet	cabinet	cab-bj-014	2023-01-20 08:00:00+00	\N	mock	1.000
contains:datacenter:dc-001:Datacenter->cabinet:cab-bj-015:Cabinet:cab-bj-015	contains	datacenter:dc-001:Datacenter	cabinet:cab-bj-015:Cabinet	cabinet	cab-bj-015	2023-01-20 08:00:00+00	\N	mock	1.000
contains:datacenter:dc-001:Datacenter->cabinet:cab-bj-016:Cabinet:cab-bj-016	contains	datacenter:dc-001:Datacenter	cabinet:cab-bj-016:Cabinet	cabinet	cab-bj-016	2023-01-20 08:00:00+00	\N	mock	1.000
contains:datacenter:dc-001:Datacenter->cabinet:cab-bj-017:Cabinet:cab-bj-017	contains	datacenter:dc-001:Datacenter	cabinet:cab-bj-017:Cabinet	cabinet	cab-bj-017	2023-01-20 08:00:00+00	\N	mock	1.000
contains:datacenter:dc-001:Datacenter->cabinet:cab-bj-018:Cabinet:cab-bj-018	contains	datacenter:dc-001:Datacenter	cabinet:cab-bj-018:Cabinet	cabinet	cab-bj-018	2023-01-20 08:00:00+00	\N	mock	1.000
contains:datacenter:dc-001:Datacenter->cabinet:cab-bj-019:Cabinet:cab-bj-019	contains	datacenter:dc-001:Datacenter	cabinet:cab-bj-019:Cabinet	cabinet	cab-bj-019	2023-01-20 08:00:00+00	\N	mock	1.000
contains:datacenter:dc-001:Datacenter->cabinet:cab-bj-020:Cabinet:cab-bj-020	contains	datacenter:dc-001:Datacenter	cabinet:cab-bj-020:Cabinet	cabinet	cab-bj-020	2023-01-20 08:00:00+00	\N	mock	1.000
contains:datacenter:dc-002:Datacenter->cabinet:cab-sh-001:Cabinet:cab-sh-001	contains	datacenter:dc-002:Datacenter	cabinet:cab-sh-001:Cabinet	cabinet	cab-sh-001	2023-06-25 09:00:00+00	\N	mock	1.000
contains:datacenter:dc-002:Datacenter->cabinet:cab-sh-002:Cabinet:cab-sh-002	contains	datacenter:dc-002:Datacenter	cabinet:cab-sh-002:Cabinet	cabinet	cab-sh-002	2023-06-25 09:00:00+00	\N	mock	1.000
contains:datacenter:dc-002:Datacenter->cabinet:cab-sh-003:Cabinet:cab-sh-003	contains	datacenter:dc-002:Datacenter	cabinet:cab-sh-003:Cabinet	cabinet	cab-sh-003	2023-06-25 09:00:00+00	\N	mock	1.000
contains:datacenter:dc-002:Datacenter->cabinet:cab-sh-004:Cabinet:cab-sh-004	contains	datacenter:dc-002:Datacenter	cabinet:cab-sh-004:Cabinet	cabinet	cab-sh-004	2023-06-25 09:00:00+00	\N	mock	1.000
contains:datacenter:dc-002:Datacenter->cabinet:cab-sh-005:Cabinet:cab-sh-005	contains	datacenter:dc-002:Datacenter	cabinet:cab-sh-005:Cabinet	cabinet	cab-sh-005	2023-06-25 09:00:00+00	\N	mock	1.000
contains:datacenter:dc-002:Datacenter->cabinet:cab-sh-006:Cabinet:cab-sh-006	contains	datacenter:dc-002:Datacenter	cabinet:cab-sh-006:Cabinet	cabinet	cab-sh-006	2023-06-25 09:00:00+00	\N	mock	1.000
contains:datacenter:dc-002:Datacenter->cabinet:cab-sh-007:Cabinet:cab-sh-007	contains	datacenter:dc-002:Datacenter	cabinet:cab-sh-007:Cabinet	cabinet	cab-sh-007	2023-06-25 09:00:00+00	\N	mock	1.000
contains:datacenter:dc-002:Datacenter->cabinet:cab-sh-008:Cabinet:cab-sh-008	contains	datacenter:dc-002:Datacenter	cabinet:cab-sh-008:Cabinet	cabinet	cab-sh-008	2023-06-25 09:00:00+00	\N	mock	1.000
contains:datacenter:dc-002:Datacenter->cabinet:cab-sh-009:Cabinet:cab-sh-009	contains	datacenter:dc-002:Datacenter	cabinet:cab-sh-009:Cabinet	cabinet	cab-sh-009	2023-06-25 09:00:00+00	\N	mock	1.000
contains:datacenter:dc-002:Datacenter->cabinet:cab-sh-010:Cabinet:cab-sh-010	contains	datacenter:dc-002:Datacenter	cabinet:cab-sh-010:Cabinet	cabinet	cab-sh-010	2023-06-25 09:00:00+00	\N	mock	1.000
contains:datacenter:dc-002:Datacenter->cabinet:cab-sh-011:Cabinet:cab-sh-011	contains	datacenter:dc-002:Datacenter	cabinet:cab-sh-011:Cabinet	cabinet	cab-sh-011	2023-06-25 09:00:00+00	\N	mock	1.000
contains:datacenter:dc-002:Datacenter->cabinet:cab-sh-012:Cabinet:cab-sh-012	contains	datacenter:dc-002:Datacenter	cabinet:cab-sh-012:Cabinet	cabinet	cab-sh-012	2023-06-25 09:00:00+00	\N	mock	1.000
contains:datacenter:dc-002:Datacenter->cabinet:cab-sh-013:Cabinet:cab-sh-013	contains	datacenter:dc-002:Datacenter	cabinet:cab-sh-013:Cabinet	cabinet	cab-sh-013	2023-06-25 09:00:00+00	\N	mock	1.000
contains:datacenter:dc-002:Datacenter->cabinet:cab-sh-014:Cabinet:cab-sh-014	contains	datacenter:dc-002:Datacenter	cabinet:cab-sh-014:Cabinet	cabinet	cab-sh-014	2023-06-25 09:00:00+00	\N	mock	1.000
contains:datacenter:dc-002:Datacenter->cabinet:cab-sh-015:Cabinet:cab-sh-015	contains	datacenter:dc-002:Datacenter	cabinet:cab-sh-015:Cabinet	cabinet	cab-sh-015	2023-06-25 09:00:00+00	\N	mock	1.000
contains:datacenter:dc-003:Datacenter->cabinet:cab-sz-001:Cabinet:cab-sz-001	contains	datacenter:dc-003:Datacenter	cabinet:cab-sz-001:Cabinet	cabinet	cab-sz-001	2023-03-15 10:00:00+00	\N	mock	1.000
contains:datacenter:dc-003:Datacenter->cabinet:cab-sz-002:Cabinet:cab-sz-002	contains	datacenter:dc-003:Datacenter	cabinet:cab-sz-002:Cabinet	cabinet	cab-sz-002	2023-03-15 10:00:00+00	\N	mock	1.000
contains:datacenter:dc-003:Datacenter->cabinet:cab-sz-003:Cabinet:cab-sz-003	contains	datacenter:dc-003:Datacenter	cabinet:cab-sz-003:Cabinet	cabinet	cab-sz-003	2023-03-15 10:00:00+00	\N	mock	1.000
contains:datacenter:dc-003:Datacenter->cabinet:cab-sz-004:Cabinet:cab-sz-004	contains	datacenter:dc-003:Datacenter	cabinet:cab-sz-004:Cabinet	cabinet	cab-sz-004	2023-03-15 10:00:00+00	\N	mock	1.000
contains:datacenter:dc-003:Datacenter->cabinet:cab-sz-005:Cabinet:cab-sz-005	contains	datacenter:dc-003:Datacenter	cabinet:cab-sz-005:Cabinet	cabinet	cab-sz-005	2023-03-15 10:00:00+00	\N	mock	1.000
contains:datacenter:dc-003:Datacenter->cabinet:cab-sz-006:Cabinet:cab-sz-006	contains	datacenter:dc-003:Datacenter	cabinet:cab-sz-006:Cabinet	cabinet	cab-sz-006	2023-03-15 10:00:00+00	\N	mock	1.000
contains:datacenter:dc-003:Datacenter->cabinet:cab-sz-007:Cabinet:cab-sz-007	contains	datacenter:dc-003:Datacenter	cabinet:cab-sz-007:Cabinet	cabinet	cab-sz-007	2023-03-15 10:00:00+00	\N	mock	1.000
contains:datacenter:dc-003:Datacenter->cabinet:cab-sz-008:Cabinet:cab-sz-008	contains	datacenter:dc-003:Datacenter	cabinet:cab-sz-008:Cabinet	cabinet	cab-sz-008	2023-03-15 10:00:00+00	\N	mock	1.000
contains:datacenter:dc-003:Datacenter->cabinet:cab-sz-009:Cabinet:cab-sz-009	contains	datacenter:dc-003:Datacenter	cabinet:cab-sz-009:Cabinet	cabinet	cab-sz-009	2023-03-15 10:00:00+00	\N	mock	1.000
contains:datacenter:dc-003:Datacenter->cabinet:cab-sz-010:Cabinet:cab-sz-010	contains	datacenter:dc-003:Datacenter	cabinet:cab-sz-010:Cabinet	cabinet	cab-sz-010	2023-03-15 10:00:00+00	\N	mock	1.000
contains:datacenter:dc-003:Datacenter->cabinet:cab-sz-011:Cabinet:cab-sz-011	contains	datacenter:dc-003:Datacenter	cabinet:cab-sz-011:Cabinet	cabinet	cab-sz-011	2023-03-15 10:00:00+00	\N	mock	1.000
contains:datacenter:dc-003:Datacenter->cabinet:cab-sz-012:Cabinet:cab-sz-012	contains	datacenter:dc-003:Datacenter	cabinet:cab-sz-012:Cabinet	cabinet	cab-sz-012	2023-03-15 10:00:00+00	\N	mock	1.000
contains:datacenter:dc-003:Datacenter->cabinet:cab-sz-013:Cabinet:cab-sz-013	contains	datacenter:dc-003:Datacenter	cabinet:cab-sz-013:Cabinet	cabinet	cab-sz-013	2023-03-15 10:00:00+00	\N	mock	1.000
contains:datacenter:dc-003:Datacenter->cabinet:cab-sz-014:Cabinet:cab-sz-014	contains	datacenter:dc-003:Datacenter	cabinet:cab-sz-014:Cabinet	cabinet	cab-sz-014	2023-03-15 10:00:00+00	\N	mock	1.000
contains:datacenter:dc-003:Datacenter->cabinet:cab-sz-015:Cabinet:cab-sz-015	contains	datacenter:dc-003:Datacenter	cabinet:cab-sz-015:Cabinet	cabinet	cab-sz-015	2023-03-15 10:00:00+00	\N	mock	1.000
contains:datacenter:dc-003:Datacenter->cabinet:cab-sz-016:Cabinet:cab-sz-016	contains	datacenter:dc-003:Datacenter	cabinet:cab-sz-016:Cabinet	cabinet	cab-sz-016	2023-03-15 10:00:00+00	\N	mock	1.000
contains:datacenter:dc-003:Datacenter->cabinet:cab-sz-017:Cabinet:cab-sz-017	contains	datacenter:dc-003:Datacenter	cabinet:cab-sz-017:Cabinet	cabinet	cab-sz-017	2023-03-15 10:00:00+00	\N	mock	1.000
contains:datacenter:dc-003:Datacenter->cabinet:cab-sz-018:Cabinet:cab-sz-018	contains	datacenter:dc-003:Datacenter	cabinet:cab-sz-018:Cabinet	cabinet	cab-sz-018	2023-03-15 10:00:00+00	\N	mock	1.000
contains:datacenter:dc-004:Datacenter->cabinet:cab-cd-001:Cabinet:cab-cd-001	contains	datacenter:dc-004:Datacenter	cabinet:cab-cd-001:Cabinet	cabinet	cab-cd-001	2024-01-08 11:00:00+00	\N	mock	1.000
contains:datacenter:dc-004:Datacenter->cabinet:cab-cd-002:Cabinet:cab-cd-002	contains	datacenter:dc-004:Datacenter	cabinet:cab-cd-002:Cabinet	cabinet	cab-cd-002	2024-01-08 11:00:00+00	\N	mock	1.000
contains:datacenter:dc-004:Datacenter->cabinet:cab-cd-003:Cabinet:cab-cd-003	contains	datacenter:dc-004:Datacenter	cabinet:cab-cd-003:Cabinet	cabinet	cab-cd-003	2024-01-08 11:00:00+00	\N	mock	1.000
contains:datacenter:dc-004:Datacenter->cabinet:cab-cd-004:Cabinet:cab-cd-004	contains	datacenter:dc-004:Datacenter	cabinet:cab-cd-004:Cabinet	cabinet	cab-cd-004	2024-01-08 11:00:00+00	\N	mock	1.000
contains:datacenter:dc-004:Datacenter->cabinet:cab-cd-005:Cabinet:cab-cd-005	contains	datacenter:dc-004:Datacenter	cabinet:cab-cd-005:Cabinet	cabinet	cab-cd-005	2024-01-08 11:00:00+00	\N	mock	1.000
contains:datacenter:dc-004:Datacenter->cabinet:cab-cd-006:Cabinet:cab-cd-006	contains	datacenter:dc-004:Datacenter	cabinet:cab-cd-006:Cabinet	cabinet	cab-cd-006	2024-01-08 11:00:00+00	\N	mock	1.000
contains:datacenter:dc-004:Datacenter->cabinet:cab-cd-007:Cabinet:cab-cd-007	contains	datacenter:dc-004:Datacenter	cabinet:cab-cd-007:Cabinet	cabinet	cab-cd-007	2024-01-08 11:00:00+00	\N	mock	1.000
contains:datacenter:dc-004:Datacenter->cabinet:cab-cd-008:Cabinet:cab-cd-008	contains	datacenter:dc-004:Datacenter	cabinet:cab-cd-008:Cabinet	cabinet	cab-cd-008	2024-01-08 11:00:00+00	\N	mock	1.000
contains:datacenter:dc-004:Datacenter->cabinet:cab-cd-009:Cabinet:cab-cd-009	contains	datacenter:dc-004:Datacenter	cabinet:cab-cd-009:Cabinet	cabinet	cab-cd-009	2024-01-08 11:00:00+00	\N	mock	1.000
contains:datacenter:dc-004:Datacenter->cabinet:cab-cd-010:Cabinet:cab-cd-010	contains	datacenter:dc-004:Datacenter	cabinet:cab-cd-010:Cabinet	cabinet	cab-cd-010	2024-01-08 11:00:00+00	\N	mock	1.000
contains:datacenter:dc-004:Datacenter->cabinet:cab-cd-011:Cabinet:cab-cd-011	contains	datacenter:dc-004:Datacenter	cabinet:cab-cd-011:Cabinet	cabinet	cab-cd-011	2024-01-08 11:00:00+00	\N	mock	1.000
contains:datacenter:dc-004:Datacenter->cabinet:cab-cd-012:Cabinet:cab-cd-012	contains	datacenter:dc-004:Datacenter	cabinet:cab-cd-012:Cabinet	cabinet	cab-cd-012	2024-01-08 11:00:00+00	\N	mock	1.000
hasProductModel:device:dev-001:Switch->device_template:tpl-huawei-s6730-48x6c:ProductModel:dev-001	hasProductModel	device:dev-001:Switch	device_template:tpl-huawei-s6730-48x6c:ProductModel	device	dev-001	2023-02-20 08:00:00+00	\N	mock	1.000
installedIn:device:dev-001:Switch->cabinet:cab-bj-001:Cabinet:dev-001	installedIn	device:dev-001:Switch	cabinet:cab-bj-001:Cabinet	rack_installation	dev-001	2023-02-20 08:00:00+00	\N	mock	1.000
hasProductModel:device:dev-002:Switch->device_template:tpl-huawei-s5735-48t4x:ProductModel:dev-002	hasProductModel	device:dev-002:Switch	device_template:tpl-huawei-s5735-48t4x:ProductModel	device	dev-002	2023-02-20 08:00:00+00	\N	mock	1.000
installedIn:device:dev-002:Switch->cabinet:cab-bj-001:Cabinet:dev-002	installedIn	device:dev-002:Switch	cabinet:cab-bj-001:Cabinet	rack_installation	dev-002	2023-02-20 08:00:00+00	\N	mock	1.000
hasProductModel:device:dev-003:Server->device_template:tpl-huawei-2288h-v6:ProductModel:dev-003	hasProductModel	device:dev-003:Server	device_template:tpl-huawei-2288h-v6:ProductModel	device	dev-003	2023-03-15 08:00:00+00	\N	mock	1.000
installedIn:device:dev-003:Server->cabinet:cab-bj-001:Cabinet:dev-003	installedIn	device:dev-003:Server	cabinet:cab-bj-001:Cabinet	rack_installation	dev-003	2023-03-15 08:00:00+00	\N	mock	1.000
hasProductModel:device:dev-004:Server->device_template:tpl-huawei-2288h-v6:ProductModel:dev-004	hasProductModel	device:dev-004:Server	device_template:tpl-huawei-2288h-v6:ProductModel	device	dev-004	2023-03-15 08:00:00+00	\N	mock	1.000
installedIn:device:dev-004:Server->cabinet:cab-bj-001:Cabinet:dev-004	installedIn	device:dev-004:Server	cabinet:cab-bj-001:Cabinet	rack_installation	dev-004	2023-03-15 08:00:00+00	\N	mock	1.000
hasProductModel:device:dev-005:Server->device_template:tpl-dell-r750:ProductModel:dev-005	hasProductModel	device:dev-005:Server	device_template:tpl-dell-r750:ProductModel	device	dev-005	2023-04-05 08:00:00+00	\N	mock	1.000
installedIn:device:dev-005:Server->cabinet:cab-bj-001:Cabinet:dev-005	installedIn	device:dev-005:Server	cabinet:cab-bj-001:Cabinet	rack_installation	dev-005	2023-04-05 08:00:00+00	\N	mock	1.000
hasProductModel:device:dev-006:Firewall->device_template:tpl-huawei-usg6680:ProductModel:dev-006	hasProductModel	device:dev-006:Firewall	device_template:tpl-huawei-usg6680:ProductModel	device	dev-006	2023-01-25 08:00:00+00	\N	mock	1.000
installedIn:device:dev-006:Firewall->cabinet:cab-bj-002:Cabinet:dev-006	installedIn	device:dev-006:Firewall	cabinet:cab-bj-002:Cabinet	rack_installation	dev-006	2023-01-25 08:00:00+00	\N	mock	1.000
hasProductModel:device:dev-007:Loadbalancer->device_template:tpl-f5-big-ip-i5800:ProductModel:dev-007	hasProductModel	device:dev-007:Loadbalancer	device_template:tpl-f5-big-ip-i5800:ProductModel	device	dev-007	2023-02-05 08:00:00+00	\N	mock	1.000
installedIn:device:dev-007:Loadbalancer->cabinet:cab-bj-002:Cabinet:dev-007	installedIn	device:dev-007:Loadbalancer	cabinet:cab-bj-002:Cabinet	rack_installation	dev-007	2023-02-05 08:00:00+00	\N	mock	1.000
hasProductModel:device:dev-008:Storage->device_template:tpl-huawei-oceanstor-5500:ProductModel:dev-008	hasProductModel	device:dev-008:Storage	device_template:tpl-huawei-oceanstor-5500:ProductModel	device	dev-008	2023-05-10 08:00:00+00	\N	mock	1.000
installedIn:device:dev-008:Storage->cabinet:cab-bj-003:Cabinet:dev-008	installedIn	device:dev-008:Storage	cabinet:cab-bj-003:Cabinet	rack_installation	dev-008	2023-05-10 08:00:00+00	\N	mock	1.000
hasProductModel:device:dev-009:Switch->device_template:tpl-cisco-c9300-48p:ProductModel:dev-009	hasProductModel	device:dev-009:Switch	device_template:tpl-cisco-c9300-48p:ProductModel	device	dev-009	2023-07-10 08:00:00+00	\N	mock	1.000
installedIn:device:dev-009:Switch->cabinet:cab-sh-001:Cabinet:dev-009	installedIn	device:dev-009:Switch	cabinet:cab-sh-001:Cabinet	rack_installation	dev-009	2023-07-10 08:00:00+00	\N	mock	1.000
hasProductModel:device:dev-010:Switch->device_template:tpl-cisco-n9k-93180yc:ProductModel:dev-010	hasProductModel	device:dev-010:Switch	device_template:tpl-cisco-n9k-93180yc:ProductModel	device	dev-010	2023-07-10 08:00:00+00	\N	mock	1.000
installedIn:device:dev-010:Switch->cabinet:cab-sh-001:Cabinet:dev-010	installedIn	device:dev-010:Switch	cabinet:cab-sh-001:Cabinet	rack_installation	dev-010	2023-07-10 08:00:00+00	\N	mock	1.000
hasProductModel:device:dev-011:Switch->device_template:tpl-h3c-s6850-56hf:ProductModel:dev-011	hasProductModel	device:dev-011:Switch	device_template:tpl-h3c-s6850-56hf:ProductModel	device	dev-011	2023-04-10 08:00:00+00	\N	mock	1.000
installedIn:device:dev-011:Switch->cabinet:cab-sz-001:Cabinet:dev-011	installedIn	device:dev-011:Switch	cabinet:cab-sz-001:Cabinet	rack_installation	dev-011	2023-04-10 08:00:00+00	\N	mock	1.000
hasProductModel:device:dev-012:Server->device_template:tpl-inspur-nf5280m6:ProductModel:dev-012	hasProductModel	device:dev-012:Server	device_template:tpl-inspur-nf5280m6:ProductModel	device	dev-012	2024-01-20 08:00:00+00	\N	mock	1.000
installedIn:device:dev-012:Server->cabinet:cab-sz-001:Cabinet:dev-012	installedIn	device:dev-012:Server	cabinet:cab-sz-001:Cabinet	rack_installation	dev-012	2024-01-20 08:00:00+00	\N	mock	1.000
hasProductModel:pdu:pdu-001:PowerDistributionUnit->device_template:tpl-pdu-001:ProductModel:pdu-001	hasProductModel	pdu:pdu-001:PowerDistributionUnit	device_template:tpl-pdu-001:ProductModel	pdu	pdu-001	2024-01-15 08:00:00+00	\N	mock	1.000
installedIn:pdu:pdu-001:PowerDistributionUnit->cabinet:cab-bj-001:Cabinet:pdu-001	installedIn	pdu:pdu-001:PowerDistributionUnit	cabinet:cab-bj-001:Cabinet	rack_installation	pdu-001	2024-01-15 08:00:00+00	\N	mock	1.000
hasProductModel:pdu:pdu-002:PowerDistributionUnit->device_template:tpl-pdu-001:ProductModel:pdu-002	hasProductModel	pdu:pdu-002:PowerDistributionUnit	device_template:tpl-pdu-001:ProductModel	pdu	pdu-002	2024-01-15 08:00:00+00	\N	mock	1.000
installedIn:pdu:pdu-002:PowerDistributionUnit->cabinet:cab-bj-001:Cabinet:pdu-002	installedIn	pdu:pdu-002:PowerDistributionUnit	cabinet:cab-bj-001:Cabinet	rack_installation	pdu-002	2024-01-15 08:00:00+00	\N	mock	1.000
hasProductModel:pdu:pdu-003:PowerDistributionUnit->device_template:tpl-pdu-002:ProductModel:pdu-003	hasProductModel	pdu:pdu-003:PowerDistributionUnit	device_template:tpl-pdu-002:ProductModel	pdu	pdu-003	2024-01-15 08:00:00+00	\N	mock	1.000
installedIn:pdu:pdu-003:PowerDistributionUnit->cabinet:cab-bj-002:Cabinet:pdu-003	installedIn	pdu:pdu-003:PowerDistributionUnit	cabinet:cab-bj-002:Cabinet	rack_installation	pdu-003	2024-01-15 08:00:00+00	\N	mock	1.000
hasProductModel:pdu:pdu-004:PowerDistributionUnit->device_template:tpl-pdu-002:ProductModel:pdu-004	hasProductModel	pdu:pdu-004:PowerDistributionUnit	device_template:tpl-pdu-002:ProductModel	pdu	pdu-004	2024-01-15 08:00:00+00	\N	mock	1.000
installedIn:pdu:pdu-004:PowerDistributionUnit->cabinet:cab-bj-002:Cabinet:pdu-004	installedIn	pdu:pdu-004:PowerDistributionUnit	cabinet:cab-bj-002:Cabinet	rack_installation	pdu-004	2024-01-15 08:00:00+00	\N	mock	1.000
hasPort:device:dev-001:Switch->port:port-dev-001-sfp-1:Port:port-dev-001-sfp-1	hasPort	device:dev-001:Switch	port:port-dev-001-sfp-1:Port	port	port-dev-001-sfp-1	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-001:Switch->port:port-dev-001-sfp-2:Port:port-dev-001-sfp-2	hasPort	device:dev-001:Switch	port:port-dev-001-sfp-2:Port	port	port-dev-001-sfp-2	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-001:Switch->port:port-dev-001-sfp-3:Port:port-dev-001-sfp-3	hasPort	device:dev-001:Switch	port:port-dev-001-sfp-3:Port	port	port-dev-001-sfp-3	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-001:Switch->port:port-dev-001-sfp-4:Port:port-dev-001-sfp-4	hasPort	device:dev-001:Switch	port:port-dev-001-sfp-4:Port	port	port-dev-001-sfp-4	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-001:Switch->port:port-dev-001-sfp-5:Port:port-dev-001-sfp-5	hasPort	device:dev-001:Switch	port:port-dev-001-sfp-5:Port	port	port-dev-001-sfp-5	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-001:Switch->port:port-dev-001-sfp-6:Port:port-dev-001-sfp-6	hasPort	device:dev-001:Switch	port:port-dev-001-sfp-6:Port	port	port-dev-001-sfp-6	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-001:Switch->port:port-dev-001-sfp-7:Port:port-dev-001-sfp-7	hasPort	device:dev-001:Switch	port:port-dev-001-sfp-7:Port	port	port-dev-001-sfp-7	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-001:Switch->port:port-dev-001-sfp-8:Port:port-dev-001-sfp-8	hasPort	device:dev-001:Switch	port:port-dev-001-sfp-8:Port	port	port-dev-001-sfp-8	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-001:Switch->port:port-dev-001-sfp-9:Port:port-dev-001-sfp-9	hasPort	device:dev-001:Switch	port:port-dev-001-sfp-9:Port	port	port-dev-001-sfp-9	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-001:Switch->port:port-dev-001-sfp-10:Port:port-dev-001-sfp-10	hasPort	device:dev-001:Switch	port:port-dev-001-sfp-10:Port	port	port-dev-001-sfp-10	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-001:Switch->port:port-dev-001-sfp-11:Port:port-dev-001-sfp-11	hasPort	device:dev-001:Switch	port:port-dev-001-sfp-11:Port	port	port-dev-001-sfp-11	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-001:Switch->port:port-dev-001-sfp-12:Port:port-dev-001-sfp-12	hasPort	device:dev-001:Switch	port:port-dev-001-sfp-12:Port	port	port-dev-001-sfp-12	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-001:Switch->port:port-dev-001-sfp-13:Port:port-dev-001-sfp-13	hasPort	device:dev-001:Switch	port:port-dev-001-sfp-13:Port	port	port-dev-001-sfp-13	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-001:Switch->port:port-dev-001-sfp-14:Port:port-dev-001-sfp-14	hasPort	device:dev-001:Switch	port:port-dev-001-sfp-14:Port	port	port-dev-001-sfp-14	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-001:Switch->port:port-dev-001-sfp-15:Port:port-dev-001-sfp-15	hasPort	device:dev-001:Switch	port:port-dev-001-sfp-15:Port	port	port-dev-001-sfp-15	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-001:Switch->port:port-dev-001-sfp-16:Port:port-dev-001-sfp-16	hasPort	device:dev-001:Switch	port:port-dev-001-sfp-16:Port	port	port-dev-001-sfp-16	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-001:Switch->port:port-dev-001-sfp-17:Port:port-dev-001-sfp-17	hasPort	device:dev-001:Switch	port:port-dev-001-sfp-17:Port	port	port-dev-001-sfp-17	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-001:Switch->port:port-dev-001-sfp-18:Port:port-dev-001-sfp-18	hasPort	device:dev-001:Switch	port:port-dev-001-sfp-18:Port	port	port-dev-001-sfp-18	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-001:Switch->port:port-dev-001-sfp-19:Port:port-dev-001-sfp-19	hasPort	device:dev-001:Switch	port:port-dev-001-sfp-19:Port	port	port-dev-001-sfp-19	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-001:Switch->port:port-dev-001-sfp-20:Port:port-dev-001-sfp-20	hasPort	device:dev-001:Switch	port:port-dev-001-sfp-20:Port	port	port-dev-001-sfp-20	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-001:Switch->port:port-dev-001-sfp-21:Port:port-dev-001-sfp-21	hasPort	device:dev-001:Switch	port:port-dev-001-sfp-21:Port	port	port-dev-001-sfp-21	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-001:Switch->port:port-dev-001-sfp-22:Port:port-dev-001-sfp-22	hasPort	device:dev-001:Switch	port:port-dev-001-sfp-22:Port	port	port-dev-001-sfp-22	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-001:Switch->port:port-dev-001-sfp-23:Port:port-dev-001-sfp-23	hasPort	device:dev-001:Switch	port:port-dev-001-sfp-23:Port	port	port-dev-001-sfp-23	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-001:Switch->port:port-dev-001-sfp-24:Port:port-dev-001-sfp-24	hasPort	device:dev-001:Switch	port:port-dev-001-sfp-24:Port	port	port-dev-001-sfp-24	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-001:Switch->port:port-dev-001-sfp-25:Port:port-dev-001-sfp-25	hasPort	device:dev-001:Switch	port:port-dev-001-sfp-25:Port	port	port-dev-001-sfp-25	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-001:Switch->port:port-dev-001-sfp-26:Port:port-dev-001-sfp-26	hasPort	device:dev-001:Switch	port:port-dev-001-sfp-26:Port	port	port-dev-001-sfp-26	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-001:Switch->port:port-dev-001-sfp-27:Port:port-dev-001-sfp-27	hasPort	device:dev-001:Switch	port:port-dev-001-sfp-27:Port	port	port-dev-001-sfp-27	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-001:Switch->port:port-dev-001-sfp-28:Port:port-dev-001-sfp-28	hasPort	device:dev-001:Switch	port:port-dev-001-sfp-28:Port	port	port-dev-001-sfp-28	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-001:Switch->port:port-dev-001-sfp-29:Port:port-dev-001-sfp-29	hasPort	device:dev-001:Switch	port:port-dev-001-sfp-29:Port	port	port-dev-001-sfp-29	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-001:Switch->port:port-dev-001-sfp-30:Port:port-dev-001-sfp-30	hasPort	device:dev-001:Switch	port:port-dev-001-sfp-30:Port	port	port-dev-001-sfp-30	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-001:Switch->port:port-dev-001-sfp-31:Port:port-dev-001-sfp-31	hasPort	device:dev-001:Switch	port:port-dev-001-sfp-31:Port	port	port-dev-001-sfp-31	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-001:Switch->port:port-dev-001-sfp-32:Port:port-dev-001-sfp-32	hasPort	device:dev-001:Switch	port:port-dev-001-sfp-32:Port	port	port-dev-001-sfp-32	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-001:Switch->port:port-dev-001-sfp-33:Port:port-dev-001-sfp-33	hasPort	device:dev-001:Switch	port:port-dev-001-sfp-33:Port	port	port-dev-001-sfp-33	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-001:Switch->port:port-dev-001-sfp-34:Port:port-dev-001-sfp-34	hasPort	device:dev-001:Switch	port:port-dev-001-sfp-34:Port	port	port-dev-001-sfp-34	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-001:Switch->port:port-dev-001-sfp-35:Port:port-dev-001-sfp-35	hasPort	device:dev-001:Switch	port:port-dev-001-sfp-35:Port	port	port-dev-001-sfp-35	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-001:Switch->port:port-dev-001-sfp-36:Port:port-dev-001-sfp-36	hasPort	device:dev-001:Switch	port:port-dev-001-sfp-36:Port	port	port-dev-001-sfp-36	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-001:Switch->port:port-dev-001-sfp-37:Port:port-dev-001-sfp-37	hasPort	device:dev-001:Switch	port:port-dev-001-sfp-37:Port	port	port-dev-001-sfp-37	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-001:Switch->port:port-dev-001-sfp-38:Port:port-dev-001-sfp-38	hasPort	device:dev-001:Switch	port:port-dev-001-sfp-38:Port	port	port-dev-001-sfp-38	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-001:Switch->port:port-dev-001-sfp-39:Port:port-dev-001-sfp-39	hasPort	device:dev-001:Switch	port:port-dev-001-sfp-39:Port	port	port-dev-001-sfp-39	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-001:Switch->port:port-dev-001-sfp-40:Port:port-dev-001-sfp-40	hasPort	device:dev-001:Switch	port:port-dev-001-sfp-40:Port	port	port-dev-001-sfp-40	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-001:Switch->port:port-dev-001-sfp-41:Port:port-dev-001-sfp-41	hasPort	device:dev-001:Switch	port:port-dev-001-sfp-41:Port	port	port-dev-001-sfp-41	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-001:Switch->port:port-dev-001-sfp-42:Port:port-dev-001-sfp-42	hasPort	device:dev-001:Switch	port:port-dev-001-sfp-42:Port	port	port-dev-001-sfp-42	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-001:Switch->port:port-dev-001-sfp-43:Port:port-dev-001-sfp-43	hasPort	device:dev-001:Switch	port:port-dev-001-sfp-43:Port	port	port-dev-001-sfp-43	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-001:Switch->port:port-dev-001-sfp-44:Port:port-dev-001-sfp-44	hasPort	device:dev-001:Switch	port:port-dev-001-sfp-44:Port	port	port-dev-001-sfp-44	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-001:Switch->port:port-dev-001-sfp-45:Port:port-dev-001-sfp-45	hasPort	device:dev-001:Switch	port:port-dev-001-sfp-45:Port	port	port-dev-001-sfp-45	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-001:Switch->port:port-dev-001-sfp-46:Port:port-dev-001-sfp-46	hasPort	device:dev-001:Switch	port:port-dev-001-sfp-46:Port	port	port-dev-001-sfp-46	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-001:Switch->port:port-dev-001-sfp-47:Port:port-dev-001-sfp-47	hasPort	device:dev-001:Switch	port:port-dev-001-sfp-47:Port	port	port-dev-001-sfp-47	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-001:Switch->port:port-dev-001-sfp-48:Port:port-dev-001-sfp-48	hasPort	device:dev-001:Switch	port:port-dev-001-sfp-48:Port	port	port-dev-001-sfp-48	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-001:Switch->port:port-dev-001-qsfp-1:Port:port-dev-001-qsfp-1	hasPort	device:dev-001:Switch	port:port-dev-001-qsfp-1:Port	port	port-dev-001-qsfp-1	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-001:Switch->port:port-dev-001-qsfp-2:Port:port-dev-001-qsfp-2	hasPort	device:dev-001:Switch	port:port-dev-001-qsfp-2:Port	port	port-dev-001-qsfp-2	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-001:Switch->port:port-dev-001-qsfp-3:Port:port-dev-001-qsfp-3	hasPort	device:dev-001:Switch	port:port-dev-001-qsfp-3:Port	port	port-dev-001-qsfp-3	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-001:Switch->port:port-dev-001-qsfp-4:Port:port-dev-001-qsfp-4	hasPort	device:dev-001:Switch	port:port-dev-001-qsfp-4:Port	port	port-dev-001-qsfp-4	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-001:Switch->port:port-dev-001-qsfp-5:Port:port-dev-001-qsfp-5	hasPort	device:dev-001:Switch	port:port-dev-001-qsfp-5:Port	port	port-dev-001-qsfp-5	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-001:Switch->port:port-dev-001-qsfp-6:Port:port-dev-001-qsfp-6	hasPort	device:dev-001:Switch	port:port-dev-001-qsfp-6:Port	port	port-dev-001-qsfp-6	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-002:Switch->port:port-dev-002-rj45-1:Port:port-dev-002-rj45-1	hasPort	device:dev-002:Switch	port:port-dev-002-rj45-1:Port	port	port-dev-002-rj45-1	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-002:Switch->port:port-dev-002-rj45-2:Port:port-dev-002-rj45-2	hasPort	device:dev-002:Switch	port:port-dev-002-rj45-2:Port	port	port-dev-002-rj45-2	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-002:Switch->port:port-dev-002-rj45-3:Port:port-dev-002-rj45-3	hasPort	device:dev-002:Switch	port:port-dev-002-rj45-3:Port	port	port-dev-002-rj45-3	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-002:Switch->port:port-dev-002-rj45-4:Port:port-dev-002-rj45-4	hasPort	device:dev-002:Switch	port:port-dev-002-rj45-4:Port	port	port-dev-002-rj45-4	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-002:Switch->port:port-dev-002-rj45-5:Port:port-dev-002-rj45-5	hasPort	device:dev-002:Switch	port:port-dev-002-rj45-5:Port	port	port-dev-002-rj45-5	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-002:Switch->port:port-dev-002-rj45-6:Port:port-dev-002-rj45-6	hasPort	device:dev-002:Switch	port:port-dev-002-rj45-6:Port	port	port-dev-002-rj45-6	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-002:Switch->port:port-dev-002-rj45-7:Port:port-dev-002-rj45-7	hasPort	device:dev-002:Switch	port:port-dev-002-rj45-7:Port	port	port-dev-002-rj45-7	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-002:Switch->port:port-dev-002-rj45-8:Port:port-dev-002-rj45-8	hasPort	device:dev-002:Switch	port:port-dev-002-rj45-8:Port	port	port-dev-002-rj45-8	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-002:Switch->port:port-dev-002-rj45-9:Port:port-dev-002-rj45-9	hasPort	device:dev-002:Switch	port:port-dev-002-rj45-9:Port	port	port-dev-002-rj45-9	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-002:Switch->port:port-dev-002-rj45-10:Port:port-dev-002-rj45-10	hasPort	device:dev-002:Switch	port:port-dev-002-rj45-10:Port	port	port-dev-002-rj45-10	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-002:Switch->port:port-dev-002-rj45-11:Port:port-dev-002-rj45-11	hasPort	device:dev-002:Switch	port:port-dev-002-rj45-11:Port	port	port-dev-002-rj45-11	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-002:Switch->port:port-dev-002-rj45-12:Port:port-dev-002-rj45-12	hasPort	device:dev-002:Switch	port:port-dev-002-rj45-12:Port	port	port-dev-002-rj45-12	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-002:Switch->port:port-dev-002-rj45-13:Port:port-dev-002-rj45-13	hasPort	device:dev-002:Switch	port:port-dev-002-rj45-13:Port	port	port-dev-002-rj45-13	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-002:Switch->port:port-dev-002-rj45-14:Port:port-dev-002-rj45-14	hasPort	device:dev-002:Switch	port:port-dev-002-rj45-14:Port	port	port-dev-002-rj45-14	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-002:Switch->port:port-dev-002-rj45-15:Port:port-dev-002-rj45-15	hasPort	device:dev-002:Switch	port:port-dev-002-rj45-15:Port	port	port-dev-002-rj45-15	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-002:Switch->port:port-dev-002-rj45-16:Port:port-dev-002-rj45-16	hasPort	device:dev-002:Switch	port:port-dev-002-rj45-16:Port	port	port-dev-002-rj45-16	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-002:Switch->port:port-dev-002-rj45-17:Port:port-dev-002-rj45-17	hasPort	device:dev-002:Switch	port:port-dev-002-rj45-17:Port	port	port-dev-002-rj45-17	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-002:Switch->port:port-dev-002-rj45-18:Port:port-dev-002-rj45-18	hasPort	device:dev-002:Switch	port:port-dev-002-rj45-18:Port	port	port-dev-002-rj45-18	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-002:Switch->port:port-dev-002-rj45-19:Port:port-dev-002-rj45-19	hasPort	device:dev-002:Switch	port:port-dev-002-rj45-19:Port	port	port-dev-002-rj45-19	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-002:Switch->port:port-dev-002-rj45-20:Port:port-dev-002-rj45-20	hasPort	device:dev-002:Switch	port:port-dev-002-rj45-20:Port	port	port-dev-002-rj45-20	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-002:Switch->port:port-dev-002-rj45-21:Port:port-dev-002-rj45-21	hasPort	device:dev-002:Switch	port:port-dev-002-rj45-21:Port	port	port-dev-002-rj45-21	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-002:Switch->port:port-dev-002-rj45-22:Port:port-dev-002-rj45-22	hasPort	device:dev-002:Switch	port:port-dev-002-rj45-22:Port	port	port-dev-002-rj45-22	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-002:Switch->port:port-dev-002-rj45-23:Port:port-dev-002-rj45-23	hasPort	device:dev-002:Switch	port:port-dev-002-rj45-23:Port	port	port-dev-002-rj45-23	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-002:Switch->port:port-dev-002-rj45-24:Port:port-dev-002-rj45-24	hasPort	device:dev-002:Switch	port:port-dev-002-rj45-24:Port	port	port-dev-002-rj45-24	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-002:Switch->port:port-dev-002-rj45-25:Port:port-dev-002-rj45-25	hasPort	device:dev-002:Switch	port:port-dev-002-rj45-25:Port	port	port-dev-002-rj45-25	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-002:Switch->port:port-dev-002-rj45-26:Port:port-dev-002-rj45-26	hasPort	device:dev-002:Switch	port:port-dev-002-rj45-26:Port	port	port-dev-002-rj45-26	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-002:Switch->port:port-dev-002-rj45-27:Port:port-dev-002-rj45-27	hasPort	device:dev-002:Switch	port:port-dev-002-rj45-27:Port	port	port-dev-002-rj45-27	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-002:Switch->port:port-dev-002-rj45-28:Port:port-dev-002-rj45-28	hasPort	device:dev-002:Switch	port:port-dev-002-rj45-28:Port	port	port-dev-002-rj45-28	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-002:Switch->port:port-dev-002-rj45-29:Port:port-dev-002-rj45-29	hasPort	device:dev-002:Switch	port:port-dev-002-rj45-29:Port	port	port-dev-002-rj45-29	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-002:Switch->port:port-dev-002-rj45-30:Port:port-dev-002-rj45-30	hasPort	device:dev-002:Switch	port:port-dev-002-rj45-30:Port	port	port-dev-002-rj45-30	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-002:Switch->port:port-dev-002-rj45-31:Port:port-dev-002-rj45-31	hasPort	device:dev-002:Switch	port:port-dev-002-rj45-31:Port	port	port-dev-002-rj45-31	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-002:Switch->port:port-dev-002-rj45-32:Port:port-dev-002-rj45-32	hasPort	device:dev-002:Switch	port:port-dev-002-rj45-32:Port	port	port-dev-002-rj45-32	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-002:Switch->port:port-dev-002-rj45-33:Port:port-dev-002-rj45-33	hasPort	device:dev-002:Switch	port:port-dev-002-rj45-33:Port	port	port-dev-002-rj45-33	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-002:Switch->port:port-dev-002-rj45-34:Port:port-dev-002-rj45-34	hasPort	device:dev-002:Switch	port:port-dev-002-rj45-34:Port	port	port-dev-002-rj45-34	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-002:Switch->port:port-dev-002-rj45-35:Port:port-dev-002-rj45-35	hasPort	device:dev-002:Switch	port:port-dev-002-rj45-35:Port	port	port-dev-002-rj45-35	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-002:Switch->port:port-dev-002-rj45-36:Port:port-dev-002-rj45-36	hasPort	device:dev-002:Switch	port:port-dev-002-rj45-36:Port	port	port-dev-002-rj45-36	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-002:Switch->port:port-dev-002-rj45-37:Port:port-dev-002-rj45-37	hasPort	device:dev-002:Switch	port:port-dev-002-rj45-37:Port	port	port-dev-002-rj45-37	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-002:Switch->port:port-dev-002-rj45-38:Port:port-dev-002-rj45-38	hasPort	device:dev-002:Switch	port:port-dev-002-rj45-38:Port	port	port-dev-002-rj45-38	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-002:Switch->port:port-dev-002-rj45-39:Port:port-dev-002-rj45-39	hasPort	device:dev-002:Switch	port:port-dev-002-rj45-39:Port	port	port-dev-002-rj45-39	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-002:Switch->port:port-dev-002-rj45-40:Port:port-dev-002-rj45-40	hasPort	device:dev-002:Switch	port:port-dev-002-rj45-40:Port	port	port-dev-002-rj45-40	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-002:Switch->port:port-dev-002-rj45-41:Port:port-dev-002-rj45-41	hasPort	device:dev-002:Switch	port:port-dev-002-rj45-41:Port	port	port-dev-002-rj45-41	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-002:Switch->port:port-dev-002-rj45-42:Port:port-dev-002-rj45-42	hasPort	device:dev-002:Switch	port:port-dev-002-rj45-42:Port	port	port-dev-002-rj45-42	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-002:Switch->port:port-dev-002-rj45-43:Port:port-dev-002-rj45-43	hasPort	device:dev-002:Switch	port:port-dev-002-rj45-43:Port	port	port-dev-002-rj45-43	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-002:Switch->port:port-dev-002-rj45-44:Port:port-dev-002-rj45-44	hasPort	device:dev-002:Switch	port:port-dev-002-rj45-44:Port	port	port-dev-002-rj45-44	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-002:Switch->port:port-dev-002-rj45-45:Port:port-dev-002-rj45-45	hasPort	device:dev-002:Switch	port:port-dev-002-rj45-45:Port	port	port-dev-002-rj45-45	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-002:Switch->port:port-dev-002-rj45-46:Port:port-dev-002-rj45-46	hasPort	device:dev-002:Switch	port:port-dev-002-rj45-46:Port	port	port-dev-002-rj45-46	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-002:Switch->port:port-dev-002-rj45-47:Port:port-dev-002-rj45-47	hasPort	device:dev-002:Switch	port:port-dev-002-rj45-47:Port	port	port-dev-002-rj45-47	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-002:Switch->port:port-dev-002-rj45-48:Port:port-dev-002-rj45-48	hasPort	device:dev-002:Switch	port:port-dev-002-rj45-48:Port	port	port-dev-002-rj45-48	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-002:Switch->port:port-dev-002-sfp-1:Port:port-dev-002-sfp-1	hasPort	device:dev-002:Switch	port:port-dev-002-sfp-1:Port	port	port-dev-002-sfp-1	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-002:Switch->port:port-dev-002-sfp-2:Port:port-dev-002-sfp-2	hasPort	device:dev-002:Switch	port:port-dev-002-sfp-2:Port	port	port-dev-002-sfp-2	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-002:Switch->port:port-dev-002-sfp-3:Port:port-dev-002-sfp-3	hasPort	device:dev-002:Switch	port:port-dev-002-sfp-3:Port	port	port-dev-002-sfp-3	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-002:Switch->port:port-dev-002-sfp-4:Port:port-dev-002-sfp-4	hasPort	device:dev-002:Switch	port:port-dev-002-sfp-4:Port	port	port-dev-002-sfp-4	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-003:Server->port:port-dev-003-mgmt:Port:port-dev-003-mgmt	hasPort	device:dev-003:Server	port:port-dev-003-mgmt:Port	port	port-dev-003-mgmt	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-003:Server->port:port-dev-003-eth-1:Port:port-dev-003-eth-1	hasPort	device:dev-003:Server	port:port-dev-003-eth-1:Port	port	port-dev-003-eth-1	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-003:Server->port:port-dev-003-eth-2:Port:port-dev-003-eth-2	hasPort	device:dev-003:Server	port:port-dev-003-eth-2:Port	port	port-dev-003-eth-2	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-003:Server->port:port-dev-003-eth-3:Port:port-dev-003-eth-3	hasPort	device:dev-003:Server	port:port-dev-003-eth-3:Port	port	port-dev-003-eth-3	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-003:Server->port:port-dev-003-eth-4:Port:port-dev-003-eth-4	hasPort	device:dev-003:Server	port:port-dev-003-eth-4:Port	port	port-dev-003-eth-4	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-003:Server->port:port-dev-003-pwr-1:Port:port-dev-003-pwr-1	hasPort	device:dev-003:Server	port:port-dev-003-pwr-1:Port	port	port-dev-003-pwr-1	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-003:Server->port:port-dev-003-pwr-2:Port:port-dev-003-pwr-2	hasPort	device:dev-003:Server	port:port-dev-003-pwr-2:Port	port	port-dev-003-pwr-2	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-004:Server->port:port-dev-004-mgmt:Port:port-dev-004-mgmt	hasPort	device:dev-004:Server	port:port-dev-004-mgmt:Port	port	port-dev-004-mgmt	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-004:Server->port:port-dev-004-eth-1:Port:port-dev-004-eth-1	hasPort	device:dev-004:Server	port:port-dev-004-eth-1:Port	port	port-dev-004-eth-1	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-004:Server->port:port-dev-004-eth-2:Port:port-dev-004-eth-2	hasPort	device:dev-004:Server	port:port-dev-004-eth-2:Port	port	port-dev-004-eth-2	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-004:Server->port:port-dev-004-eth-3:Port:port-dev-004-eth-3	hasPort	device:dev-004:Server	port:port-dev-004-eth-3:Port	port	port-dev-004-eth-3	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-004:Server->port:port-dev-004-eth-4:Port:port-dev-004-eth-4	hasPort	device:dev-004:Server	port:port-dev-004-eth-4:Port	port	port-dev-004-eth-4	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-004:Server->port:port-dev-004-pwr-1:Port:port-dev-004-pwr-1	hasPort	device:dev-004:Server	port:port-dev-004-pwr-1:Port	port	port-dev-004-pwr-1	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-004:Server->port:port-dev-004-pwr-2:Port:port-dev-004-pwr-2	hasPort	device:dev-004:Server	port:port-dev-004-pwr-2:Port	port	port-dev-004-pwr-2	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-005:Server->port:port-dev-005-mgmt:Port:port-dev-005-mgmt	hasPort	device:dev-005:Server	port:port-dev-005-mgmt:Port	port	port-dev-005-mgmt	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-005:Server->port:port-dev-005-eth-1:Port:port-dev-005-eth-1	hasPort	device:dev-005:Server	port:port-dev-005-eth-1:Port	port	port-dev-005-eth-1	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-005:Server->port:port-dev-005-eth-2:Port:port-dev-005-eth-2	hasPort	device:dev-005:Server	port:port-dev-005-eth-2:Port	port	port-dev-005-eth-2	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-005:Server->port:port-dev-005-eth-3:Port:port-dev-005-eth-3	hasPort	device:dev-005:Server	port:port-dev-005-eth-3:Port	port	port-dev-005-eth-3	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-005:Server->port:port-dev-005-eth-4:Port:port-dev-005-eth-4	hasPort	device:dev-005:Server	port:port-dev-005-eth-4:Port	port	port-dev-005-eth-4	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-005:Server->port:port-dev-005-pwr-1:Port:port-dev-005-pwr-1	hasPort	device:dev-005:Server	port:port-dev-005-pwr-1:Port	port	port-dev-005-pwr-1	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-005:Server->port:port-dev-005-pwr-2:Port:port-dev-005-pwr-2	hasPort	device:dev-005:Server	port:port-dev-005-pwr-2:Port	port	port-dev-005-pwr-2	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-006:Firewall->port:port-dev-006-mgmt:Port:port-dev-006-mgmt	hasPort	device:dev-006:Firewall	port:port-dev-006-mgmt:Port	port	port-dev-006-mgmt	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-006:Firewall->port:port-dev-006-rj45-1:Port:port-dev-006-rj45-1	hasPort	device:dev-006:Firewall	port:port-dev-006-rj45-1:Port	port	port-dev-006-rj45-1	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-006:Firewall->port:port-dev-006-rj45-2:Port:port-dev-006-rj45-2	hasPort	device:dev-006:Firewall	port:port-dev-006-rj45-2:Port	port	port-dev-006-rj45-2	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-006:Firewall->port:port-dev-006-rj45-3:Port:port-dev-006-rj45-3	hasPort	device:dev-006:Firewall	port:port-dev-006-rj45-3:Port	port	port-dev-006-rj45-3	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-006:Firewall->port:port-dev-006-rj45-4:Port:port-dev-006-rj45-4	hasPort	device:dev-006:Firewall	port:port-dev-006-rj45-4:Port	port	port-dev-006-rj45-4	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-006:Firewall->port:port-dev-006-rj45-5:Port:port-dev-006-rj45-5	hasPort	device:dev-006:Firewall	port:port-dev-006-rj45-5:Port	port	port-dev-006-rj45-5	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-006:Firewall->port:port-dev-006-rj45-6:Port:port-dev-006-rj45-6	hasPort	device:dev-006:Firewall	port:port-dev-006-rj45-6:Port	port	port-dev-006-rj45-6	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-006:Firewall->port:port-dev-006-rj45-7:Port:port-dev-006-rj45-7	hasPort	device:dev-006:Firewall	port:port-dev-006-rj45-7:Port	port	port-dev-006-rj45-7	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-006:Firewall->port:port-dev-006-rj45-8:Port:port-dev-006-rj45-8	hasPort	device:dev-006:Firewall	port:port-dev-006-rj45-8:Port	port	port-dev-006-rj45-8	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-006:Firewall->port:port-dev-006-sfp-1:Port:port-dev-006-sfp-1	hasPort	device:dev-006:Firewall	port:port-dev-006-sfp-1:Port	port	port-dev-006-sfp-1	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-006:Firewall->port:port-dev-006-sfp-2:Port:port-dev-006-sfp-2	hasPort	device:dev-006:Firewall	port:port-dev-006-sfp-2:Port	port	port-dev-006-sfp-2	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-006:Firewall->port:port-dev-006-sfp-3:Port:port-dev-006-sfp-3	hasPort	device:dev-006:Firewall	port:port-dev-006-sfp-3:Port	port	port-dev-006-sfp-3	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-006:Firewall->port:port-dev-006-sfp-4:Port:port-dev-006-sfp-4	hasPort	device:dev-006:Firewall	port:port-dev-006-sfp-4:Port	port	port-dev-006-sfp-4	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-007:Loadbalancer->port:port-dev-007-mgmt:Port:port-dev-007-mgmt	hasPort	device:dev-007:Loadbalancer	port:port-dev-007-mgmt:Port	port	port-dev-007-mgmt	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-007:Loadbalancer->port:port-dev-007-sfp-1:Port:port-dev-007-sfp-1	hasPort	device:dev-007:Loadbalancer	port:port-dev-007-sfp-1:Port	port	port-dev-007-sfp-1	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-007:Loadbalancer->port:port-dev-007-sfp-2:Port:port-dev-007-sfp-2	hasPort	device:dev-007:Loadbalancer	port:port-dev-007-sfp-2:Port	port	port-dev-007-sfp-2	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-007:Loadbalancer->port:port-dev-007-sfp-3:Port:port-dev-007-sfp-3	hasPort	device:dev-007:Loadbalancer	port:port-dev-007-sfp-3:Port	port	port-dev-007-sfp-3	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-007:Loadbalancer->port:port-dev-007-sfp-4:Port:port-dev-007-sfp-4	hasPort	device:dev-007:Loadbalancer	port:port-dev-007-sfp-4:Port	port	port-dev-007-sfp-4	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-007:Loadbalancer->port:port-dev-007-sfp-5:Port:port-dev-007-sfp-5	hasPort	device:dev-007:Loadbalancer	port:port-dev-007-sfp-5:Port	port	port-dev-007-sfp-5	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-007:Loadbalancer->port:port-dev-007-sfp-6:Port:port-dev-007-sfp-6	hasPort	device:dev-007:Loadbalancer	port:port-dev-007-sfp-6:Port	port	port-dev-007-sfp-6	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-007:Loadbalancer->port:port-dev-007-sfp-7:Port:port-dev-007-sfp-7	hasPort	device:dev-007:Loadbalancer	port:port-dev-007-sfp-7:Port	port	port-dev-007-sfp-7	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-007:Loadbalancer->port:port-dev-007-sfp-8:Port:port-dev-007-sfp-8	hasPort	device:dev-007:Loadbalancer	port:port-dev-007-sfp-8:Port	port	port-dev-007-sfp-8	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-008:Storage->port:port-dev-008-mgmt-1:Port:port-dev-008-mgmt-1	hasPort	device:dev-008:Storage	port:port-dev-008-mgmt-1:Port	port	port-dev-008-mgmt-1	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-008:Storage->port:port-dev-008-mgmt-2:Port:port-dev-008-mgmt-2	hasPort	device:dev-008:Storage	port:port-dev-008-mgmt-2:Port	port	port-dev-008-mgmt-2	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-008:Storage->port:port-dev-008-fc-1:Port:port-dev-008-fc-1	hasPort	device:dev-008:Storage	port:port-dev-008-fc-1:Port	port	port-dev-008-fc-1	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-008:Storage->port:port-dev-008-fc-2:Port:port-dev-008-fc-2	hasPort	device:dev-008:Storage	port:port-dev-008-fc-2:Port	port	port-dev-008-fc-2	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-008:Storage->port:port-dev-008-fc-3:Port:port-dev-008-fc-3	hasPort	device:dev-008:Storage	port:port-dev-008-fc-3:Port	port	port-dev-008-fc-3	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-008:Storage->port:port-dev-008-fc-4:Port:port-dev-008-fc-4	hasPort	device:dev-008:Storage	port:port-dev-008-fc-4:Port	port	port-dev-008-fc-4	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-008:Storage->port:port-dev-008-fc-5:Port:port-dev-008-fc-5	hasPort	device:dev-008:Storage	port:port-dev-008-fc-5:Port	port	port-dev-008-fc-5	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-008:Storage->port:port-dev-008-fc-6:Port:port-dev-008-fc-6	hasPort	device:dev-008:Storage	port:port-dev-008-fc-6:Port	port	port-dev-008-fc-6	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-008:Storage->port:port-dev-008-fc-7:Port:port-dev-008-fc-7	hasPort	device:dev-008:Storage	port:port-dev-008-fc-7:Port	port	port-dev-008-fc-7	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-008:Storage->port:port-dev-008-fc-8:Port:port-dev-008-fc-8	hasPort	device:dev-008:Storage	port:port-dev-008-fc-8:Port	port	port-dev-008-fc-8	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-008:Storage->port:port-dev-008-iscsi-1:Port:port-dev-008-iscsi-1	hasPort	device:dev-008:Storage	port:port-dev-008-iscsi-1:Port	port	port-dev-008-iscsi-1	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-008:Storage->port:port-dev-008-iscsi-2:Port:port-dev-008-iscsi-2	hasPort	device:dev-008:Storage	port:port-dev-008-iscsi-2:Port	port	port-dev-008-iscsi-2	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-008:Storage->port:port-dev-008-iscsi-3:Port:port-dev-008-iscsi-3	hasPort	device:dev-008:Storage	port:port-dev-008-iscsi-3:Port	port	port-dev-008-iscsi-3	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-008:Storage->port:port-dev-008-iscsi-4:Port:port-dev-008-iscsi-4	hasPort	device:dev-008:Storage	port:port-dev-008-iscsi-4:Port	port	port-dev-008-iscsi-4	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-009:Switch->port:port-dev-009-rj45-1:Port:port-dev-009-rj45-1	hasPort	device:dev-009:Switch	port:port-dev-009-rj45-1:Port	port	port-dev-009-rj45-1	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-009:Switch->port:port-dev-009-rj45-2:Port:port-dev-009-rj45-2	hasPort	device:dev-009:Switch	port:port-dev-009-rj45-2:Port	port	port-dev-009-rj45-2	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-009:Switch->port:port-dev-009-rj45-3:Port:port-dev-009-rj45-3	hasPort	device:dev-009:Switch	port:port-dev-009-rj45-3:Port	port	port-dev-009-rj45-3	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-009:Switch->port:port-dev-009-rj45-4:Port:port-dev-009-rj45-4	hasPort	device:dev-009:Switch	port:port-dev-009-rj45-4:Port	port	port-dev-009-rj45-4	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-009:Switch->port:port-dev-009-rj45-5:Port:port-dev-009-rj45-5	hasPort	device:dev-009:Switch	port:port-dev-009-rj45-5:Port	port	port-dev-009-rj45-5	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-009:Switch->port:port-dev-009-rj45-6:Port:port-dev-009-rj45-6	hasPort	device:dev-009:Switch	port:port-dev-009-rj45-6:Port	port	port-dev-009-rj45-6	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-009:Switch->port:port-dev-009-rj45-7:Port:port-dev-009-rj45-7	hasPort	device:dev-009:Switch	port:port-dev-009-rj45-7:Port	port	port-dev-009-rj45-7	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-009:Switch->port:port-dev-009-rj45-8:Port:port-dev-009-rj45-8	hasPort	device:dev-009:Switch	port:port-dev-009-rj45-8:Port	port	port-dev-009-rj45-8	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-009:Switch->port:port-dev-009-rj45-9:Port:port-dev-009-rj45-9	hasPort	device:dev-009:Switch	port:port-dev-009-rj45-9:Port	port	port-dev-009-rj45-9	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-009:Switch->port:port-dev-009-rj45-10:Port:port-dev-009-rj45-10	hasPort	device:dev-009:Switch	port:port-dev-009-rj45-10:Port	port	port-dev-009-rj45-10	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-009:Switch->port:port-dev-009-rj45-11:Port:port-dev-009-rj45-11	hasPort	device:dev-009:Switch	port:port-dev-009-rj45-11:Port	port	port-dev-009-rj45-11	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-009:Switch->port:port-dev-009-rj45-12:Port:port-dev-009-rj45-12	hasPort	device:dev-009:Switch	port:port-dev-009-rj45-12:Port	port	port-dev-009-rj45-12	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-009:Switch->port:port-dev-009-rj45-13:Port:port-dev-009-rj45-13	hasPort	device:dev-009:Switch	port:port-dev-009-rj45-13:Port	port	port-dev-009-rj45-13	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-009:Switch->port:port-dev-009-rj45-14:Port:port-dev-009-rj45-14	hasPort	device:dev-009:Switch	port:port-dev-009-rj45-14:Port	port	port-dev-009-rj45-14	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-009:Switch->port:port-dev-009-rj45-15:Port:port-dev-009-rj45-15	hasPort	device:dev-009:Switch	port:port-dev-009-rj45-15:Port	port	port-dev-009-rj45-15	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-009:Switch->port:port-dev-009-rj45-16:Port:port-dev-009-rj45-16	hasPort	device:dev-009:Switch	port:port-dev-009-rj45-16:Port	port	port-dev-009-rj45-16	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-009:Switch->port:port-dev-009-rj45-17:Port:port-dev-009-rj45-17	hasPort	device:dev-009:Switch	port:port-dev-009-rj45-17:Port	port	port-dev-009-rj45-17	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-009:Switch->port:port-dev-009-rj45-18:Port:port-dev-009-rj45-18	hasPort	device:dev-009:Switch	port:port-dev-009-rj45-18:Port	port	port-dev-009-rj45-18	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-009:Switch->port:port-dev-009-rj45-19:Port:port-dev-009-rj45-19	hasPort	device:dev-009:Switch	port:port-dev-009-rj45-19:Port	port	port-dev-009-rj45-19	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-009:Switch->port:port-dev-009-rj45-20:Port:port-dev-009-rj45-20	hasPort	device:dev-009:Switch	port:port-dev-009-rj45-20:Port	port	port-dev-009-rj45-20	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-009:Switch->port:port-dev-009-rj45-21:Port:port-dev-009-rj45-21	hasPort	device:dev-009:Switch	port:port-dev-009-rj45-21:Port	port	port-dev-009-rj45-21	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-009:Switch->port:port-dev-009-rj45-22:Port:port-dev-009-rj45-22	hasPort	device:dev-009:Switch	port:port-dev-009-rj45-22:Port	port	port-dev-009-rj45-22	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-009:Switch->port:port-dev-009-rj45-23:Port:port-dev-009-rj45-23	hasPort	device:dev-009:Switch	port:port-dev-009-rj45-23:Port	port	port-dev-009-rj45-23	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-009:Switch->port:port-dev-009-rj45-24:Port:port-dev-009-rj45-24	hasPort	device:dev-009:Switch	port:port-dev-009-rj45-24:Port	port	port-dev-009-rj45-24	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-009:Switch->port:port-dev-009-rj45-25:Port:port-dev-009-rj45-25	hasPort	device:dev-009:Switch	port:port-dev-009-rj45-25:Port	port	port-dev-009-rj45-25	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-009:Switch->port:port-dev-009-rj45-26:Port:port-dev-009-rj45-26	hasPort	device:dev-009:Switch	port:port-dev-009-rj45-26:Port	port	port-dev-009-rj45-26	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-009:Switch->port:port-dev-009-rj45-27:Port:port-dev-009-rj45-27	hasPort	device:dev-009:Switch	port:port-dev-009-rj45-27:Port	port	port-dev-009-rj45-27	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-009:Switch->port:port-dev-009-rj45-28:Port:port-dev-009-rj45-28	hasPort	device:dev-009:Switch	port:port-dev-009-rj45-28:Port	port	port-dev-009-rj45-28	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-009:Switch->port:port-dev-009-rj45-29:Port:port-dev-009-rj45-29	hasPort	device:dev-009:Switch	port:port-dev-009-rj45-29:Port	port	port-dev-009-rj45-29	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-009:Switch->port:port-dev-009-rj45-30:Port:port-dev-009-rj45-30	hasPort	device:dev-009:Switch	port:port-dev-009-rj45-30:Port	port	port-dev-009-rj45-30	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-009:Switch->port:port-dev-009-rj45-31:Port:port-dev-009-rj45-31	hasPort	device:dev-009:Switch	port:port-dev-009-rj45-31:Port	port	port-dev-009-rj45-31	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-009:Switch->port:port-dev-009-rj45-32:Port:port-dev-009-rj45-32	hasPort	device:dev-009:Switch	port:port-dev-009-rj45-32:Port	port	port-dev-009-rj45-32	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-009:Switch->port:port-dev-009-rj45-33:Port:port-dev-009-rj45-33	hasPort	device:dev-009:Switch	port:port-dev-009-rj45-33:Port	port	port-dev-009-rj45-33	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-009:Switch->port:port-dev-009-rj45-34:Port:port-dev-009-rj45-34	hasPort	device:dev-009:Switch	port:port-dev-009-rj45-34:Port	port	port-dev-009-rj45-34	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-009:Switch->port:port-dev-009-rj45-35:Port:port-dev-009-rj45-35	hasPort	device:dev-009:Switch	port:port-dev-009-rj45-35:Port	port	port-dev-009-rj45-35	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-009:Switch->port:port-dev-009-rj45-36:Port:port-dev-009-rj45-36	hasPort	device:dev-009:Switch	port:port-dev-009-rj45-36:Port	port	port-dev-009-rj45-36	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-009:Switch->port:port-dev-009-rj45-37:Port:port-dev-009-rj45-37	hasPort	device:dev-009:Switch	port:port-dev-009-rj45-37:Port	port	port-dev-009-rj45-37	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-009:Switch->port:port-dev-009-rj45-38:Port:port-dev-009-rj45-38	hasPort	device:dev-009:Switch	port:port-dev-009-rj45-38:Port	port	port-dev-009-rj45-38	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-009:Switch->port:port-dev-009-rj45-39:Port:port-dev-009-rj45-39	hasPort	device:dev-009:Switch	port:port-dev-009-rj45-39:Port	port	port-dev-009-rj45-39	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-009:Switch->port:port-dev-009-rj45-40:Port:port-dev-009-rj45-40	hasPort	device:dev-009:Switch	port:port-dev-009-rj45-40:Port	port	port-dev-009-rj45-40	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-009:Switch->port:port-dev-009-rj45-41:Port:port-dev-009-rj45-41	hasPort	device:dev-009:Switch	port:port-dev-009-rj45-41:Port	port	port-dev-009-rj45-41	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-009:Switch->port:port-dev-009-rj45-42:Port:port-dev-009-rj45-42	hasPort	device:dev-009:Switch	port:port-dev-009-rj45-42:Port	port	port-dev-009-rj45-42	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-009:Switch->port:port-dev-009-rj45-43:Port:port-dev-009-rj45-43	hasPort	device:dev-009:Switch	port:port-dev-009-rj45-43:Port	port	port-dev-009-rj45-43	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-009:Switch->port:port-dev-009-rj45-44:Port:port-dev-009-rj45-44	hasPort	device:dev-009:Switch	port:port-dev-009-rj45-44:Port	port	port-dev-009-rj45-44	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-009:Switch->port:port-dev-009-rj45-45:Port:port-dev-009-rj45-45	hasPort	device:dev-009:Switch	port:port-dev-009-rj45-45:Port	port	port-dev-009-rj45-45	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-009:Switch->port:port-dev-009-rj45-46:Port:port-dev-009-rj45-46	hasPort	device:dev-009:Switch	port:port-dev-009-rj45-46:Port	port	port-dev-009-rj45-46	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-009:Switch->port:port-dev-009-rj45-47:Port:port-dev-009-rj45-47	hasPort	device:dev-009:Switch	port:port-dev-009-rj45-47:Port	port	port-dev-009-rj45-47	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-009:Switch->port:port-dev-009-rj45-48:Port:port-dev-009-rj45-48	hasPort	device:dev-009:Switch	port:port-dev-009-rj45-48:Port	port	port-dev-009-rj45-48	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-009:Switch->port:port-dev-009-sfp-1:Port:port-dev-009-sfp-1	hasPort	device:dev-009:Switch	port:port-dev-009-sfp-1:Port	port	port-dev-009-sfp-1	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-009:Switch->port:port-dev-009-sfp-2:Port:port-dev-009-sfp-2	hasPort	device:dev-009:Switch	port:port-dev-009-sfp-2:Port	port	port-dev-009-sfp-2	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-009:Switch->port:port-dev-009-sfp-3:Port:port-dev-009-sfp-3	hasPort	device:dev-009:Switch	port:port-dev-009-sfp-3:Port	port	port-dev-009-sfp-3	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-009:Switch->port:port-dev-009-sfp-4:Port:port-dev-009-sfp-4	hasPort	device:dev-009:Switch	port:port-dev-009-sfp-4:Port	port	port-dev-009-sfp-4	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-010:Switch->port:port-dev-010-sfp-1:Port:port-dev-010-sfp-1	hasPort	device:dev-010:Switch	port:port-dev-010-sfp-1:Port	port	port-dev-010-sfp-1	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-010:Switch->port:port-dev-010-sfp-2:Port:port-dev-010-sfp-2	hasPort	device:dev-010:Switch	port:port-dev-010-sfp-2:Port	port	port-dev-010-sfp-2	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-010:Switch->port:port-dev-010-sfp-3:Port:port-dev-010-sfp-3	hasPort	device:dev-010:Switch	port:port-dev-010-sfp-3:Port	port	port-dev-010-sfp-3	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-010:Switch->port:port-dev-010-sfp-4:Port:port-dev-010-sfp-4	hasPort	device:dev-010:Switch	port:port-dev-010-sfp-4:Port	port	port-dev-010-sfp-4	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-010:Switch->port:port-dev-010-sfp-5:Port:port-dev-010-sfp-5	hasPort	device:dev-010:Switch	port:port-dev-010-sfp-5:Port	port	port-dev-010-sfp-5	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-010:Switch->port:port-dev-010-sfp-6:Port:port-dev-010-sfp-6	hasPort	device:dev-010:Switch	port:port-dev-010-sfp-6:Port	port	port-dev-010-sfp-6	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-010:Switch->port:port-dev-010-sfp-7:Port:port-dev-010-sfp-7	hasPort	device:dev-010:Switch	port:port-dev-010-sfp-7:Port	port	port-dev-010-sfp-7	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-010:Switch->port:port-dev-010-sfp-8:Port:port-dev-010-sfp-8	hasPort	device:dev-010:Switch	port:port-dev-010-sfp-8:Port	port	port-dev-010-sfp-8	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-010:Switch->port:port-dev-010-sfp-9:Port:port-dev-010-sfp-9	hasPort	device:dev-010:Switch	port:port-dev-010-sfp-9:Port	port	port-dev-010-sfp-9	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-010:Switch->port:port-dev-010-sfp-10:Port:port-dev-010-sfp-10	hasPort	device:dev-010:Switch	port:port-dev-010-sfp-10:Port	port	port-dev-010-sfp-10	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-010:Switch->port:port-dev-010-sfp-11:Port:port-dev-010-sfp-11	hasPort	device:dev-010:Switch	port:port-dev-010-sfp-11:Port	port	port-dev-010-sfp-11	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-010:Switch->port:port-dev-010-sfp-12:Port:port-dev-010-sfp-12	hasPort	device:dev-010:Switch	port:port-dev-010-sfp-12:Port	port	port-dev-010-sfp-12	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-010:Switch->port:port-dev-010-sfp-13:Port:port-dev-010-sfp-13	hasPort	device:dev-010:Switch	port:port-dev-010-sfp-13:Port	port	port-dev-010-sfp-13	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-010:Switch->port:port-dev-010-sfp-14:Port:port-dev-010-sfp-14	hasPort	device:dev-010:Switch	port:port-dev-010-sfp-14:Port	port	port-dev-010-sfp-14	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-010:Switch->port:port-dev-010-sfp-15:Port:port-dev-010-sfp-15	hasPort	device:dev-010:Switch	port:port-dev-010-sfp-15:Port	port	port-dev-010-sfp-15	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-010:Switch->port:port-dev-010-sfp-16:Port:port-dev-010-sfp-16	hasPort	device:dev-010:Switch	port:port-dev-010-sfp-16:Port	port	port-dev-010-sfp-16	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-010:Switch->port:port-dev-010-sfp-17:Port:port-dev-010-sfp-17	hasPort	device:dev-010:Switch	port:port-dev-010-sfp-17:Port	port	port-dev-010-sfp-17	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-010:Switch->port:port-dev-010-sfp-18:Port:port-dev-010-sfp-18	hasPort	device:dev-010:Switch	port:port-dev-010-sfp-18:Port	port	port-dev-010-sfp-18	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-010:Switch->port:port-dev-010-sfp-19:Port:port-dev-010-sfp-19	hasPort	device:dev-010:Switch	port:port-dev-010-sfp-19:Port	port	port-dev-010-sfp-19	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-010:Switch->port:port-dev-010-sfp-20:Port:port-dev-010-sfp-20	hasPort	device:dev-010:Switch	port:port-dev-010-sfp-20:Port	port	port-dev-010-sfp-20	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-010:Switch->port:port-dev-010-sfp-21:Port:port-dev-010-sfp-21	hasPort	device:dev-010:Switch	port:port-dev-010-sfp-21:Port	port	port-dev-010-sfp-21	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-010:Switch->port:port-dev-010-sfp-22:Port:port-dev-010-sfp-22	hasPort	device:dev-010:Switch	port:port-dev-010-sfp-22:Port	port	port-dev-010-sfp-22	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-010:Switch->port:port-dev-010-sfp-23:Port:port-dev-010-sfp-23	hasPort	device:dev-010:Switch	port:port-dev-010-sfp-23:Port	port	port-dev-010-sfp-23	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-010:Switch->port:port-dev-010-sfp-24:Port:port-dev-010-sfp-24	hasPort	device:dev-010:Switch	port:port-dev-010-sfp-24:Port	port	port-dev-010-sfp-24	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-010:Switch->port:port-dev-010-sfp-25:Port:port-dev-010-sfp-25	hasPort	device:dev-010:Switch	port:port-dev-010-sfp-25:Port	port	port-dev-010-sfp-25	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-010:Switch->port:port-dev-010-sfp-26:Port:port-dev-010-sfp-26	hasPort	device:dev-010:Switch	port:port-dev-010-sfp-26:Port	port	port-dev-010-sfp-26	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-010:Switch->port:port-dev-010-sfp-27:Port:port-dev-010-sfp-27	hasPort	device:dev-010:Switch	port:port-dev-010-sfp-27:Port	port	port-dev-010-sfp-27	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-010:Switch->port:port-dev-010-sfp-28:Port:port-dev-010-sfp-28	hasPort	device:dev-010:Switch	port:port-dev-010-sfp-28:Port	port	port-dev-010-sfp-28	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-010:Switch->port:port-dev-010-sfp-29:Port:port-dev-010-sfp-29	hasPort	device:dev-010:Switch	port:port-dev-010-sfp-29:Port	port	port-dev-010-sfp-29	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-010:Switch->port:port-dev-010-sfp-30:Port:port-dev-010-sfp-30	hasPort	device:dev-010:Switch	port:port-dev-010-sfp-30:Port	port	port-dev-010-sfp-30	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-010:Switch->port:port-dev-010-sfp-31:Port:port-dev-010-sfp-31	hasPort	device:dev-010:Switch	port:port-dev-010-sfp-31:Port	port	port-dev-010-sfp-31	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-010:Switch->port:port-dev-010-sfp-32:Port:port-dev-010-sfp-32	hasPort	device:dev-010:Switch	port:port-dev-010-sfp-32:Port	port	port-dev-010-sfp-32	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-010:Switch->port:port-dev-010-sfp-33:Port:port-dev-010-sfp-33	hasPort	device:dev-010:Switch	port:port-dev-010-sfp-33:Port	port	port-dev-010-sfp-33	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-010:Switch->port:port-dev-010-sfp-34:Port:port-dev-010-sfp-34	hasPort	device:dev-010:Switch	port:port-dev-010-sfp-34:Port	port	port-dev-010-sfp-34	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-010:Switch->port:port-dev-010-sfp-35:Port:port-dev-010-sfp-35	hasPort	device:dev-010:Switch	port:port-dev-010-sfp-35:Port	port	port-dev-010-sfp-35	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-010:Switch->port:port-dev-010-sfp-36:Port:port-dev-010-sfp-36	hasPort	device:dev-010:Switch	port:port-dev-010-sfp-36:Port	port	port-dev-010-sfp-36	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-010:Switch->port:port-dev-010-sfp-37:Port:port-dev-010-sfp-37	hasPort	device:dev-010:Switch	port:port-dev-010-sfp-37:Port	port	port-dev-010-sfp-37	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-010:Switch->port:port-dev-010-sfp-38:Port:port-dev-010-sfp-38	hasPort	device:dev-010:Switch	port:port-dev-010-sfp-38:Port	port	port-dev-010-sfp-38	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-010:Switch->port:port-dev-010-sfp-39:Port:port-dev-010-sfp-39	hasPort	device:dev-010:Switch	port:port-dev-010-sfp-39:Port	port	port-dev-010-sfp-39	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-010:Switch->port:port-dev-010-sfp-40:Port:port-dev-010-sfp-40	hasPort	device:dev-010:Switch	port:port-dev-010-sfp-40:Port	port	port-dev-010-sfp-40	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-010:Switch->port:port-dev-010-sfp-41:Port:port-dev-010-sfp-41	hasPort	device:dev-010:Switch	port:port-dev-010-sfp-41:Port	port	port-dev-010-sfp-41	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-010:Switch->port:port-dev-010-sfp-42:Port:port-dev-010-sfp-42	hasPort	device:dev-010:Switch	port:port-dev-010-sfp-42:Port	port	port-dev-010-sfp-42	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-010:Switch->port:port-dev-010-sfp-43:Port:port-dev-010-sfp-43	hasPort	device:dev-010:Switch	port:port-dev-010-sfp-43:Port	port	port-dev-010-sfp-43	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-010:Switch->port:port-dev-010-sfp-44:Port:port-dev-010-sfp-44	hasPort	device:dev-010:Switch	port:port-dev-010-sfp-44:Port	port	port-dev-010-sfp-44	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-010:Switch->port:port-dev-010-sfp-45:Port:port-dev-010-sfp-45	hasPort	device:dev-010:Switch	port:port-dev-010-sfp-45:Port	port	port-dev-010-sfp-45	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-010:Switch->port:port-dev-010-sfp-46:Port:port-dev-010-sfp-46	hasPort	device:dev-010:Switch	port:port-dev-010-sfp-46:Port	port	port-dev-010-sfp-46	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-010:Switch->port:port-dev-010-sfp-47:Port:port-dev-010-sfp-47	hasPort	device:dev-010:Switch	port:port-dev-010-sfp-47:Port	port	port-dev-010-sfp-47	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-010:Switch->port:port-dev-010-sfp-48:Port:port-dev-010-sfp-48	hasPort	device:dev-010:Switch	port:port-dev-010-sfp-48:Port	port	port-dev-010-sfp-48	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-010:Switch->port:port-dev-010-qsfp-1:Port:port-dev-010-qsfp-1	hasPort	device:dev-010:Switch	port:port-dev-010-qsfp-1:Port	port	port-dev-010-qsfp-1	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-010:Switch->port:port-dev-010-qsfp-2:Port:port-dev-010-qsfp-2	hasPort	device:dev-010:Switch	port:port-dev-010-qsfp-2:Port	port	port-dev-010-qsfp-2	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-010:Switch->port:port-dev-010-qsfp-3:Port:port-dev-010-qsfp-3	hasPort	device:dev-010:Switch	port:port-dev-010-qsfp-3:Port	port	port-dev-010-qsfp-3	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-010:Switch->port:port-dev-010-qsfp-4:Port:port-dev-010-qsfp-4	hasPort	device:dev-010:Switch	port:port-dev-010-qsfp-4:Port	port	port-dev-010-qsfp-4	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-010:Switch->port:port-dev-010-qsfp-5:Port:port-dev-010-qsfp-5	hasPort	device:dev-010:Switch	port:port-dev-010-qsfp-5:Port	port	port-dev-010-qsfp-5	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-010:Switch->port:port-dev-010-qsfp-6:Port:port-dev-010-qsfp-6	hasPort	device:dev-010:Switch	port:port-dev-010-qsfp-6:Port	port	port-dev-010-qsfp-6	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-011:Switch->port:port-dev-011-sfp-1:Port:port-dev-011-sfp-1	hasPort	device:dev-011:Switch	port:port-dev-011-sfp-1:Port	port	port-dev-011-sfp-1	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-011:Switch->port:port-dev-011-sfp-2:Port:port-dev-011-sfp-2	hasPort	device:dev-011:Switch	port:port-dev-011-sfp-2:Port	port	port-dev-011-sfp-2	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-011:Switch->port:port-dev-011-sfp-3:Port:port-dev-011-sfp-3	hasPort	device:dev-011:Switch	port:port-dev-011-sfp-3:Port	port	port-dev-011-sfp-3	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-011:Switch->port:port-dev-011-sfp-4:Port:port-dev-011-sfp-4	hasPort	device:dev-011:Switch	port:port-dev-011-sfp-4:Port	port	port-dev-011-sfp-4	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-011:Switch->port:port-dev-011-sfp-5:Port:port-dev-011-sfp-5	hasPort	device:dev-011:Switch	port:port-dev-011-sfp-5:Port	port	port-dev-011-sfp-5	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-011:Switch->port:port-dev-011-sfp-6:Port:port-dev-011-sfp-6	hasPort	device:dev-011:Switch	port:port-dev-011-sfp-6:Port	port	port-dev-011-sfp-6	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-011:Switch->port:port-dev-011-sfp-7:Port:port-dev-011-sfp-7	hasPort	device:dev-011:Switch	port:port-dev-011-sfp-7:Port	port	port-dev-011-sfp-7	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-011:Switch->port:port-dev-011-sfp-8:Port:port-dev-011-sfp-8	hasPort	device:dev-011:Switch	port:port-dev-011-sfp-8:Port	port	port-dev-011-sfp-8	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-011:Switch->port:port-dev-011-sfp-9:Port:port-dev-011-sfp-9	hasPort	device:dev-011:Switch	port:port-dev-011-sfp-9:Port	port	port-dev-011-sfp-9	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-011:Switch->port:port-dev-011-sfp-10:Port:port-dev-011-sfp-10	hasPort	device:dev-011:Switch	port:port-dev-011-sfp-10:Port	port	port-dev-011-sfp-10	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-011:Switch->port:port-dev-011-sfp-11:Port:port-dev-011-sfp-11	hasPort	device:dev-011:Switch	port:port-dev-011-sfp-11:Port	port	port-dev-011-sfp-11	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-011:Switch->port:port-dev-011-sfp-12:Port:port-dev-011-sfp-12	hasPort	device:dev-011:Switch	port:port-dev-011-sfp-12:Port	port	port-dev-011-sfp-12	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-011:Switch->port:port-dev-011-sfp-13:Port:port-dev-011-sfp-13	hasPort	device:dev-011:Switch	port:port-dev-011-sfp-13:Port	port	port-dev-011-sfp-13	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-011:Switch->port:port-dev-011-sfp-14:Port:port-dev-011-sfp-14	hasPort	device:dev-011:Switch	port:port-dev-011-sfp-14:Port	port	port-dev-011-sfp-14	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-011:Switch->port:port-dev-011-sfp-15:Port:port-dev-011-sfp-15	hasPort	device:dev-011:Switch	port:port-dev-011-sfp-15:Port	port	port-dev-011-sfp-15	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-011:Switch->port:port-dev-011-sfp-16:Port:port-dev-011-sfp-16	hasPort	device:dev-011:Switch	port:port-dev-011-sfp-16:Port	port	port-dev-011-sfp-16	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-011:Switch->port:port-dev-011-sfp-17:Port:port-dev-011-sfp-17	hasPort	device:dev-011:Switch	port:port-dev-011-sfp-17:Port	port	port-dev-011-sfp-17	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-011:Switch->port:port-dev-011-sfp-18:Port:port-dev-011-sfp-18	hasPort	device:dev-011:Switch	port:port-dev-011-sfp-18:Port	port	port-dev-011-sfp-18	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-011:Switch->port:port-dev-011-sfp-19:Port:port-dev-011-sfp-19	hasPort	device:dev-011:Switch	port:port-dev-011-sfp-19:Port	port	port-dev-011-sfp-19	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-011:Switch->port:port-dev-011-sfp-20:Port:port-dev-011-sfp-20	hasPort	device:dev-011:Switch	port:port-dev-011-sfp-20:Port	port	port-dev-011-sfp-20	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-011:Switch->port:port-dev-011-sfp-21:Port:port-dev-011-sfp-21	hasPort	device:dev-011:Switch	port:port-dev-011-sfp-21:Port	port	port-dev-011-sfp-21	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-011:Switch->port:port-dev-011-sfp-22:Port:port-dev-011-sfp-22	hasPort	device:dev-011:Switch	port:port-dev-011-sfp-22:Port	port	port-dev-011-sfp-22	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-011:Switch->port:port-dev-011-sfp-23:Port:port-dev-011-sfp-23	hasPort	device:dev-011:Switch	port:port-dev-011-sfp-23:Port	port	port-dev-011-sfp-23	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-011:Switch->port:port-dev-011-sfp-24:Port:port-dev-011-sfp-24	hasPort	device:dev-011:Switch	port:port-dev-011-sfp-24:Port	port	port-dev-011-sfp-24	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-011:Switch->port:port-dev-011-sfp-25:Port:port-dev-011-sfp-25	hasPort	device:dev-011:Switch	port:port-dev-011-sfp-25:Port	port	port-dev-011-sfp-25	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-011:Switch->port:port-dev-011-sfp-26:Port:port-dev-011-sfp-26	hasPort	device:dev-011:Switch	port:port-dev-011-sfp-26:Port	port	port-dev-011-sfp-26	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-011:Switch->port:port-dev-011-sfp-27:Port:port-dev-011-sfp-27	hasPort	device:dev-011:Switch	port:port-dev-011-sfp-27:Port	port	port-dev-011-sfp-27	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-011:Switch->port:port-dev-011-sfp-28:Port:port-dev-011-sfp-28	hasPort	device:dev-011:Switch	port:port-dev-011-sfp-28:Port	port	port-dev-011-sfp-28	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-011:Switch->port:port-dev-011-sfp-29:Port:port-dev-011-sfp-29	hasPort	device:dev-011:Switch	port:port-dev-011-sfp-29:Port	port	port-dev-011-sfp-29	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-011:Switch->port:port-dev-011-sfp-30:Port:port-dev-011-sfp-30	hasPort	device:dev-011:Switch	port:port-dev-011-sfp-30:Port	port	port-dev-011-sfp-30	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-011:Switch->port:port-dev-011-sfp-31:Port:port-dev-011-sfp-31	hasPort	device:dev-011:Switch	port:port-dev-011-sfp-31:Port	port	port-dev-011-sfp-31	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-011:Switch->port:port-dev-011-sfp-32:Port:port-dev-011-sfp-32	hasPort	device:dev-011:Switch	port:port-dev-011-sfp-32:Port	port	port-dev-011-sfp-32	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-011:Switch->port:port-dev-011-sfp-33:Port:port-dev-011-sfp-33	hasPort	device:dev-011:Switch	port:port-dev-011-sfp-33:Port	port	port-dev-011-sfp-33	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-011:Switch->port:port-dev-011-sfp-34:Port:port-dev-011-sfp-34	hasPort	device:dev-011:Switch	port:port-dev-011-sfp-34:Port	port	port-dev-011-sfp-34	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-011:Switch->port:port-dev-011-sfp-35:Port:port-dev-011-sfp-35	hasPort	device:dev-011:Switch	port:port-dev-011-sfp-35:Port	port	port-dev-011-sfp-35	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-011:Switch->port:port-dev-011-sfp-36:Port:port-dev-011-sfp-36	hasPort	device:dev-011:Switch	port:port-dev-011-sfp-36:Port	port	port-dev-011-sfp-36	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-011:Switch->port:port-dev-011-sfp-37:Port:port-dev-011-sfp-37	hasPort	device:dev-011:Switch	port:port-dev-011-sfp-37:Port	port	port-dev-011-sfp-37	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-011:Switch->port:port-dev-011-sfp-38:Port:port-dev-011-sfp-38	hasPort	device:dev-011:Switch	port:port-dev-011-sfp-38:Port	port	port-dev-011-sfp-38	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-011:Switch->port:port-dev-011-sfp-39:Port:port-dev-011-sfp-39	hasPort	device:dev-011:Switch	port:port-dev-011-sfp-39:Port	port	port-dev-011-sfp-39	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-011:Switch->port:port-dev-011-sfp-40:Port:port-dev-011-sfp-40	hasPort	device:dev-011:Switch	port:port-dev-011-sfp-40:Port	port	port-dev-011-sfp-40	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-011:Switch->port:port-dev-011-sfp-41:Port:port-dev-011-sfp-41	hasPort	device:dev-011:Switch	port:port-dev-011-sfp-41:Port	port	port-dev-011-sfp-41	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-011:Switch->port:port-dev-011-sfp-42:Port:port-dev-011-sfp-42	hasPort	device:dev-011:Switch	port:port-dev-011-sfp-42:Port	port	port-dev-011-sfp-42	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-011:Switch->port:port-dev-011-sfp-43:Port:port-dev-011-sfp-43	hasPort	device:dev-011:Switch	port:port-dev-011-sfp-43:Port	port	port-dev-011-sfp-43	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-011:Switch->port:port-dev-011-sfp-44:Port:port-dev-011-sfp-44	hasPort	device:dev-011:Switch	port:port-dev-011-sfp-44:Port	port	port-dev-011-sfp-44	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-011:Switch->port:port-dev-011-sfp-45:Port:port-dev-011-sfp-45	hasPort	device:dev-011:Switch	port:port-dev-011-sfp-45:Port	port	port-dev-011-sfp-45	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-011:Switch->port:port-dev-011-sfp-46:Port:port-dev-011-sfp-46	hasPort	device:dev-011:Switch	port:port-dev-011-sfp-46:Port	port	port-dev-011-sfp-46	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-011:Switch->port:port-dev-011-sfp-47:Port:port-dev-011-sfp-47	hasPort	device:dev-011:Switch	port:port-dev-011-sfp-47:Port	port	port-dev-011-sfp-47	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-011:Switch->port:port-dev-011-sfp-48:Port:port-dev-011-sfp-48	hasPort	device:dev-011:Switch	port:port-dev-011-sfp-48:Port	port	port-dev-011-sfp-48	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-011:Switch->port:port-dev-011-qsfp-1:Port:port-dev-011-qsfp-1	hasPort	device:dev-011:Switch	port:port-dev-011-qsfp-1:Port	port	port-dev-011-qsfp-1	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-011:Switch->port:port-dev-011-qsfp-2:Port:port-dev-011-qsfp-2	hasPort	device:dev-011:Switch	port:port-dev-011-qsfp-2:Port	port	port-dev-011-qsfp-2	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-011:Switch->port:port-dev-011-qsfp-3:Port:port-dev-011-qsfp-3	hasPort	device:dev-011:Switch	port:port-dev-011-qsfp-3:Port	port	port-dev-011-qsfp-3	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-011:Switch->port:port-dev-011-qsfp-4:Port:port-dev-011-qsfp-4	hasPort	device:dev-011:Switch	port:port-dev-011-qsfp-4:Port	port	port-dev-011-qsfp-4	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-011:Switch->port:port-dev-011-qsfp-5:Port:port-dev-011-qsfp-5	hasPort	device:dev-011:Switch	port:port-dev-011-qsfp-5:Port	port	port-dev-011-qsfp-5	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-011:Switch->port:port-dev-011-qsfp-6:Port:port-dev-011-qsfp-6	hasPort	device:dev-011:Switch	port:port-dev-011-qsfp-6:Port	port	port-dev-011-qsfp-6	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-011:Switch->port:port-dev-011-qsfp-7:Port:port-dev-011-qsfp-7	hasPort	device:dev-011:Switch	port:port-dev-011-qsfp-7:Port	port	port-dev-011-qsfp-7	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-011:Switch->port:port-dev-011-qsfp-8:Port:port-dev-011-qsfp-8	hasPort	device:dev-011:Switch	port:port-dev-011-qsfp-8:Port	port	port-dev-011-qsfp-8	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-012:Server->port:port-dev-012-mgmt:Port:port-dev-012-mgmt	hasPort	device:dev-012:Server	port:port-dev-012-mgmt:Port	port	port-dev-012-mgmt	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-012:Server->port:port-dev-012-eth-1:Port:port-dev-012-eth-1	hasPort	device:dev-012:Server	port:port-dev-012-eth-1:Port	port	port-dev-012-eth-1	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-012:Server->port:port-dev-012-eth-2:Port:port-dev-012-eth-2	hasPort	device:dev-012:Server	port:port-dev-012-eth-2:Port	port	port-dev-012-eth-2	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-012:Server->port:port-dev-012-eth-3:Port:port-dev-012-eth-3	hasPort	device:dev-012:Server	port:port-dev-012-eth-3:Port	port	port-dev-012-eth-3	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-012:Server->port:port-dev-012-eth-4:Port:port-dev-012-eth-4	hasPort	device:dev-012:Server	port:port-dev-012-eth-4:Port	port	port-dev-012-eth-4	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-012:Server->port:port-dev-012-pwr-1:Port:port-dev-012-pwr-1	hasPort	device:dev-012:Server	port:port-dev-012-pwr-1:Port	port	port-dev-012-pwr-1	2024-12-01 10:00:00+00	\N	mock	1.000
hasPort:device:dev-012:Server->port:port-dev-012-pwr-2:Port:port-dev-012-pwr-2	hasPort	device:dev-012:Server	port:port-dev-012-pwr-2:Port	port	port-dev-012-pwr-2	2024-12-01 10:00:00+00	\N	mock	1.000
connectedByCable:port:port-dev-001-sfp-1:Port->port:port-dev-002-sfp-1:Port:conn-001	connectedByCable	port:port-dev-001-sfp-1:Port	port:port-dev-002-sfp-1:Port	cable_connection	conn-001	2023-02-25 08:00:00+00	\N	mock	1.000
connectedByCable:port:port-dev-001-sfp-2:Port->port:port-dev-002-sfp-2:Port:conn-002	connectedByCable	port:port-dev-001-sfp-2:Port	port:port-dev-002-sfp-2:Port	cable_connection	conn-002	2023-02-25 08:00:00+00	\N	mock	1.000
connectedByCable:port:port-dev-002-rj45-1:Port->port:port-dev-003-eth-1:Port:conn-003	connectedByCable	port:port-dev-002-rj45-1:Port	port:port-dev-003-eth-1:Port	cable_connection	conn-003	2023-03-20 08:00:00+00	\N	mock	1.000
connectedByCable:port:port-dev-002-rj45-2:Port->port:port-dev-003-eth-2:Port:conn-004	connectedByCable	port:port-dev-002-rj45-2:Port	port:port-dev-003-eth-2:Port	cable_connection	conn-004	2023-03-20 08:00:00+00	\N	mock	1.000
connectedByCable:port:port-dev-002-rj45-3:Port->port:port-dev-004-eth-1:Port:conn-005	connectedByCable	port:port-dev-002-rj45-3:Port	port:port-dev-004-eth-1:Port	cable_connection	conn-005	2023-03-20 08:00:00+00	\N	mock	1.000
connectedByCable:port:port-dev-002-rj45-4:Port->port:port-dev-005-eth-1:Port:conn-006	connectedByCable	port:port-dev-002-rj45-4:Port	port:port-dev-005-eth-1:Port	cable_connection	conn-006	2023-04-10 08:00:00+00	\N	mock	1.000
connectedByCable:port:port-dev-006-sfp-1:Port->port:port-dev-007-sfp-1:Port:conn-007	connectedByCable	port:port-dev-006-sfp-1:Port	port:port-dev-007-sfp-1:Port	cable_connection	conn-007	2023-02-10 08:00:00+00	\N	mock	1.000
connectedByCable:port:port-dev-005-eth-2:Port->port:port-dev-008-iscsi-1:Port:conn-008	connectedByCable	port:port-dev-005-eth-2:Port	port:port-dev-008-iscsi-1:Port	cable_connection	conn-008	2023-05-15 08:00:00+00	\N	mock	1.000
connectedByCable:port:port-dev-001-sfp-3:Port->port:port-dev-006-sfp-2:Port:conn-009	connectedByCable	port:port-dev-001-sfp-3:Port	port:port-dev-006-sfp-2:Port	cable_connection	conn-009	2023-02-10 08:00:00+00	\N	mock	1.000
connectedByCable:port:port-dev-002-rj45-47:Port->port:port-dev-003-mgmt:Port:conn-010	connectedByCable	port:port-dev-002-rj45-47:Port	port:port-dev-003-mgmt:Port	cable_connection	conn-010	2023-03-20 08:00:00+00	\N	mock	1.000
poweredBy:power_node:ups-001:UPS->power_node:utility-001:UtilityFeed:link-001	poweredBy	power_node:ups-001:UPS	power_node:utility-001:UtilityFeed	power_connection	link-001	2024-01-01 00:00:00+00	\N	mock	1.000
poweredBy:power_node:ups-002:UPS->power_node:utility-002:UtilityFeed:link-002	poweredBy	power_node:ups-002:UPS	power_node:utility-002:UtilityFeed	power_connection	link-002	2024-01-01 00:00:00+00	\N	mock	1.000
poweredBy:power_node:pdu-001:PDU->power_node:ups-001:UPS:link-003	poweredBy	power_node:pdu-001:PDU	power_node:ups-001:UPS	power_connection	link-003	2024-01-01 00:00:00+00	\N	mock	1.000
poweredBy:power_node:pdu-002:PDU->power_node:ups-002:UPS:link-004	poweredBy	power_node:pdu-002:PDU	power_node:ups-002:UPS	power_connection	link-004	2024-01-01 00:00:00+00	\N	mock	1.000
poweredBy:power_node:pdu-003:PDU->power_node:ups-001:UPS:link-005	poweredBy	power_node:pdu-003:PDU	power_node:ups-001:UPS	power_connection	link-005	2024-01-01 00:00:00+00	\N	mock	1.000
poweredBy:power_node:pdu-004:PDU->power_node:ups-002:UPS:link-006	poweredBy	power_node:pdu-004:PDU	power_node:ups-002:UPS	power_connection	link-006	2024-01-01 00:00:00+00	\N	mock	1.000
poweredBy:power_node:dev-001:DEVICE->power_node:pdu-001:PDU:link-007	poweredBy	power_node:dev-001:DEVICE	power_node:pdu-001:PDU	power_connection	link-007	2024-01-01 00:00:00+00	\N	mock	1.000
poweredBy:power_node:dev-001:DEVICE->power_node:pdu-002:PDU:link-008	poweredBy	power_node:dev-001:DEVICE	power_node:pdu-002:PDU	power_connection	link-008	2024-01-01 00:00:00+00	\N	mock	1.000
poweredBy:power_node:dev-002:DEVICE->power_node:pdu-001:PDU:link-009	poweredBy	power_node:dev-002:DEVICE	power_node:pdu-001:PDU	power_connection	link-009	2024-01-01 00:00:00+00	\N	mock	1.000
poweredBy:power_node:dev-002:DEVICE->power_node:pdu-002:PDU:link-010	poweredBy	power_node:dev-002:DEVICE	power_node:pdu-002:PDU	power_connection	link-010	2024-01-01 00:00:00+00	\N	mock	1.000
poweredBy:power_node:dev-003:DEVICE->power_node:pdu-003:PDU:link-011	poweredBy	power_node:dev-003:DEVICE	power_node:pdu-003:PDU	power_connection	link-011	2024-01-01 00:00:00+00	\N	mock	1.000
poweredBy:power_node:dev-004:DEVICE->power_node:pdu-003:PDU:link-012	poweredBy	power_node:dev-004:DEVICE	power_node:pdu-003:PDU	power_connection	link-012	2024-01-01 00:00:00+00	\N	mock	1.000
poweredBy:power_node:dev-004:DEVICE->power_node:pdu-004:PDU:link-013	poweredBy	power_node:dev-004:DEVICE	power_node:pdu-004:PDU	power_connection	link-013	2024-01-01 00:00:00+00	\N	mock	1.000
poweredBy:power_node:ups-101:UPS->power_node:utility-101:UtilityFeed:link-101	poweredBy	power_node:ups-101:UPS	power_node:utility-101:UtilityFeed	power_connection	link-101	2024-01-01 00:00:00+00	\N	mock	1.000
poweredBy:power_node:ups-102:UPS->power_node:utility-102:UtilityFeed:link-102	poweredBy	power_node:ups-102:UPS	power_node:utility-102:UtilityFeed	power_connection	link-102	2024-01-01 00:00:00+00	\N	mock	1.000
poweredBy:power_node:pdu-101:PDU->power_node:ups-101:UPS:link-103	poweredBy	power_node:pdu-101:PDU	power_node:ups-101:UPS	power_connection	link-103	2024-01-01 00:00:00+00	\N	mock	1.000
poweredBy:power_node:pdu-102:PDU->power_node:ups-102:UPS:link-104	poweredBy	power_node:pdu-102:PDU	power_node:ups-102:UPS	power_connection	link-104	2024-01-01 00:00:00+00	\N	mock	1.000
poweredBy:power_node:dev-009:DEVICE->power_node:pdu-101:PDU:link-105	poweredBy	power_node:dev-009:DEVICE	power_node:pdu-101:PDU	power_connection	link-105	2024-01-01 00:00:00+00	\N	mock	1.000
poweredBy:power_node:dev-009:DEVICE->power_node:pdu-102:PDU:link-106	poweredBy	power_node:dev-009:DEVICE	power_node:pdu-102:PDU	power_connection	link-106	2024-01-01 00:00:00+00	\N	mock	1.000
poweredBy:power_node:dev-010:DEVICE->power_node:pdu-101:PDU:link-107	poweredBy	power_node:dev-010:DEVICE	power_node:pdu-101:PDU	power_connection	link-107	2024-01-01 00:00:00+00	\N	mock	1.000
\.


--
-- Data for Name: operation_record; Type: TABLE DATA; Schema: dcim_ontology_demo_20260623083835; Owner: -
--

COPY "__DCIM_TARGET_SCHEMA__".operation_record (id, operation_type, operator_name, target, description, created_at, source_system) FROM stdin;
op-001	device_mount	钱AI	GPU服务器-C1-1	设备上架	2024-12-05 10:30:00+00	mock
op-002	port_config	张运维	接入交换机-A1-1 GE1/0/24	VLAN配置变更: Access VLAN 100 -> 102	2024-12-05 09:15:00+00	mock
op-003	connection_create	张运维	BJ-CAT6A-005	创建网络连线	2024-12-04 16:20:00+00	mock
op-004	device_update	李运维	核心交换机-B1	更新设备管理IP	2024-12-04 14:00:00+00	mock
op-005	cabinet_create	王运维	C区2排3号	新增机柜	2024-12-03 11:00:00+00	mock
\.


--
-- Data for Name: pdu; Type: TABLE DATA; Schema: dcim_ontology_demo_20260623083835; Owner: -
--

COPY "__DCIM_TARGET_SCHEMA__".pdu (id, template_id, cabinet_id, name, asset_code, management_ip, power_path, input_voltage, output_ports, max_load_w, current_load_w, brand, model, operational_status, source_system, created_at, updated_at) FROM stdin;
pdu-001	tpl-pdu-001	cab-bj-001	PDU-A-01	PDU-2024-001	192.168.1.101	A	220.00	16	3000.00	1800.00	APC	AP7921	online	mock	2024-01-15 08:00:00+00	2024-01-28 10:00:00+00
pdu-002	tpl-pdu-001	cab-bj-001	PDU-B-01	PDU-2024-002	192.168.1.102	B	220.00	16	3000.00	1650.00	APC	AP7921	online	mock	2024-01-15 08:00:00+00	2024-01-28 10:00:00+00
pdu-003	tpl-pdu-002	cab-bj-002	PDU-A-02	PDU-2024-003	192.168.1.103	A	220.00	24	5000.00	2400.00	Schneider	AP8941	online	mock	2024-01-15 08:00:00+00	2024-01-28 10:00:00+00
pdu-004	tpl-pdu-002	cab-bj-002	PDU-B-02	PDU-2024-004	192.168.1.104	B	220.00	24	5000.00	4200.00	Schneider	AP8941	warning	mock	2024-01-15 08:00:00+00	2024-01-28 10:00:00+00
\.


--
-- Data for Name: port; Type: TABLE DATA; Schema: dcim_ontology_demo_20260623083835; Owner: -
--

COPY "__DCIM_TARGET_SCHEMA__".port (id, device_id, port_group_id, port_number, port_alias, port_type, speed, admin_status, link_status, vlan_config, qos_config, mac_bindings, port_security, max_mac_count, dot1x_enabled, connection_purpose, description, last_updated) FROM stdin;
port-dev-001-sfp-2	dev-001	pg-1	XGE1/0/2	\N	SFP+	10G	up	connected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-001-sfp-30	dev-001	pg-1	XGE1/0/30	\N	SFP+	10G	up	disconnected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-002-rj45-8	dev-002	pg-1	GE1/0/8	Server-8	RJ45	1G	up	disconnected	{"mode": "access", "pvid": 101}	{"trustMode": "dscp", "defaultPriority": 0, "ingressRateLimit": 1000}	\N	\N	\N	\N	\N	连接服务器8	2026-07-16 06:54:20.035954+00
port-dev-002-rj45-35	dev-002	pg-1	GE1/0/35	\N	RJ45	1G	disabled	disconnected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	{"trustMode": "dscp", "defaultPriority": 0}	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-011-qsfp-6	dev-011	pg-2	40GE1/0/6	\N	QSFP+	40G	up	disconnected	\N	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-011-qsfp-7	dev-011	pg-2	40GE1/0/7	\N	QSFP+	40G	up	disconnected	\N	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-011-qsfp-8	dev-011	pg-2	40GE1/0/8	\N	QSFP+	40G	up	disconnected	\N	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-012-mgmt	dev-012	pg-1	Mgmt	IPMI管理口	RJ45	1G	up	disconnected	\N	\N	\N	\N	\N	\N	\N	IPMI/iLO/iDRAC管理口	2026-07-16 06:54:20.035954+00
port-dev-012-eth-1	dev-012	pg-2	eth1	\N	RJ45	1G	up	disconnected	{"mode": "access", "pvid": 100}	\N	\N	\N	\N	\N	\N	业务网络	2026-07-16 06:54:20.035954+00
port-dev-012-eth-2	dev-012	pg-2	eth2	\N	RJ45	1G	up	disconnected	{"mode": "access", "pvid": 200}	\N	\N	\N	\N	\N	\N	管理网络	2026-07-16 06:54:20.035954+00
port-dev-001-sfp-3	dev-001	pg-1	XGE1/0/3	\N	SFP+	10G	up	connected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-001-sfp-4	dev-001	pg-1	XGE1/0/4	\N	SFP+	10G	up	disconnected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-001-sfp-5	dev-001	pg-1	XGE1/0/5	\N	SFP+	10G	up	disconnected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-001-sfp-6	dev-001	pg-1	XGE1/0/6	\N	SFP+	10G	up	disconnected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-001-sfp-7	dev-001	pg-1	XGE1/0/7	\N	SFP+	10G	up	disconnected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-001-sfp-8	dev-001	pg-1	XGE1/0/8	\N	SFP+	10G	up	disconnected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-008-fc-7	dev-008	pg-2	FC7	\N	FC	10G	up	disconnected	\N	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-008-fc-8	dev-008	pg-2	FC8	\N	FC	10G	up	disconnected	\N	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-012-eth-3	dev-012	pg-2	eth3	\N	RJ45	1G	up	disconnected	\N	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-012-eth-4	dev-012	pg-2	eth4	\N	RJ45	1G	up	disconnected	\N	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-012-pwr-1	dev-012	pg-3	PWR1	\N	Power	N/A	up	disconnected	\N	\N	\N	\N	\N	\N	\N	电源模块1	2026-07-16 06:54:20.035954+00
port-dev-012-pwr-2	dev-012	pg-3	PWR2	\N	Power	N/A	up	disconnected	\N	\N	\N	\N	\N	\N	\N	电源模块2	2026-07-16 06:54:20.035954+00
port-dev-002-rj45-31	dev-002	pg-1	GE1/0/31	\N	RJ45	1G	up	disconnected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	{"trustMode": "dscp", "defaultPriority": 0}	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-001-sfp-37	dev-001	pg-1	XGE1/0/37	\N	SFP+	10G	up	disconnected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-f9f15364-pg-1-1	dev-f9f15364	pg-1	pg-1-1	\N	RJ45	1G	up	disconnected	\N	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-f9f15364-pg-2-2	dev-f9f15364	pg-2	pg-2-2	A1-3-P02	SFP	40G	up	disconnected	\N	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-001-sfp-1	dev-001	pg-1	XGE1/0/1	\N	SFP+	10G	up	connected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-f9f15364-pg-2-1	dev-f9f15364	pg-2	pg-2-1	A1-3-P01	SFP	40G	up	disconnected	\N	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-001-sfp-9	dev-001	pg-1	XGE1/0/9	\N	SFP+	10G	up	disconnected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-001-sfp-10	dev-001	pg-1	XGE1/0/10	\N	SFP+	10G	up	disconnected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-001-sfp-11	dev-001	pg-1	XGE1/0/11	\N	SFP+	10G	up	disconnected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-001-sfp-12	dev-001	pg-1	XGE1/0/12	\N	SFP+	10G	up	disconnected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-001-sfp-13	dev-001	pg-1	XGE1/0/13	\N	SFP+	10G	up	disconnected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-001-sfp-14	dev-001	pg-1	XGE1/0/14	\N	SFP+	10G	up	disconnected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-001-sfp-15	dev-001	pg-1	XGE1/0/15	\N	SFP+	10G	up	disconnected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-001-sfp-16	dev-001	pg-1	XGE1/0/16	\N	SFP+	10G	up	disconnected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-001-sfp-17	dev-001	pg-1	XGE1/0/17	\N	SFP+	10G	up	disconnected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-001-sfp-18	dev-001	pg-1	XGE1/0/18	\N	SFP+	10G	up	disconnected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-001-sfp-19	dev-001	pg-1	XGE1/0/19	\N	SFP+	10G	up	disconnected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-001-sfp-20	dev-001	pg-1	XGE1/0/20	\N	SFP+	10G	up	disconnected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-001-sfp-21	dev-001	pg-1	XGE1/0/21	\N	SFP+	10G	up	disconnected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-001-sfp-22	dev-001	pg-1	XGE1/0/22	\N	SFP+	10G	up	disconnected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-001-sfp-23	dev-001	pg-1	XGE1/0/23	\N	SFP+	10G	up	disconnected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-001-sfp-24	dev-001	pg-1	XGE1/0/24	\N	SFP+	10G	up	disconnected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-001-sfp-25	dev-001	pg-1	XGE1/0/25	\N	SFP+	10G	up	disconnected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-001-sfp-26	dev-001	pg-1	XGE1/0/26	\N	SFP+	10G	up	disconnected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-001-sfp-27	dev-001	pg-1	XGE1/0/27	\N	SFP+	10G	up	disconnected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-001-sfp-28	dev-001	pg-1	XGE1/0/28	\N	SFP+	10G	up	disconnected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-001-sfp-29	dev-001	pg-1	XGE1/0/29	\N	SFP+	10G	up	disconnected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-001-sfp-31	dev-001	pg-1	XGE1/0/31	\N	SFP+	10G	up	disconnected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-001-sfp-32	dev-001	pg-1	XGE1/0/32	\N	SFP+	10G	up	disconnected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-001-sfp-33	dev-001	pg-1	XGE1/0/33	\N	SFP+	10G	up	disconnected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-001-sfp-34	dev-001	pg-1	XGE1/0/34	\N	SFP+	10G	up	disconnected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-001-sfp-35	dev-001	pg-1	XGE1/0/35	\N	SFP+	10G	up	disconnected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-001-sfp-36	dev-001	pg-1	XGE1/0/36	\N	SFP+	10G	up	disconnected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-001-sfp-38	dev-001	pg-1	XGE1/0/38	\N	SFP+	10G	up	disconnected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-008-iscsi-1	dev-008	pg-3	iSCSI1	\N	RJ45	10G	up	connected	\N	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-001-sfp-39	dev-001	pg-1	XGE1/0/39	\N	SFP+	10G	up	disconnected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-001-sfp-40	dev-001	pg-1	XGE1/0/40	\N	SFP+	10G	up	disconnected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-001-sfp-41	dev-001	pg-1	XGE1/0/41	\N	SFP+	10G	up	disconnected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-001-sfp-42	dev-001	pg-1	XGE1/0/42	\N	SFP+	10G	up	disconnected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-001-sfp-43	dev-001	pg-1	XGE1/0/43	\N	SFP+	10G	up	disconnected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-001-sfp-44	dev-001	pg-1	XGE1/0/44	\N	SFP+	10G	up	disconnected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-001-sfp-45	dev-001	pg-1	XGE1/0/45	\N	SFP+	10G	up	disconnected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-001-sfp-46	dev-001	pg-1	XGE1/0/46	\N	SFP+	10G	up	disconnected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-001-sfp-47	dev-001	pg-1	XGE1/0/47	\N	SFP+	10G	up	disconnected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-001-sfp-48	dev-001	pg-1	XGE1/0/48	\N	SFP+	10G	up	disconnected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-001-qsfp-1	dev-001	pg-2	100GE1/0/1	\N	QSFP28	100G	up	disconnected	\N	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-001-qsfp-2	dev-001	pg-2	100GE1/0/2	\N	QSFP28	100G	up	disconnected	\N	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-001-qsfp-3	dev-001	pg-2	100GE1/0/3	\N	QSFP28	100G	up	disconnected	\N	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-001-qsfp-4	dev-001	pg-2	100GE1/0/4	\N	QSFP28	100G	up	disconnected	\N	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-001-qsfp-5	dev-001	pg-2	100GE1/0/5	\N	QSFP28	100G	up	disconnected	\N	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-001-qsfp-6	dev-001	pg-2	100GE1/0/6	\N	QSFP28	100G	up	disconnected	\N	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-002-rj45-2	dev-002	pg-1	GE1/0/2	Server-2	RJ45	1G	up	connected	{"mode": "access", "pvid": 100}	{"trustMode": "dscp", "defaultPriority": 0, "ingressRateLimit": 1000}	\N	\N	\N	\N	\N	连接服务器2	2026-07-16 06:54:20.035954+00
port-dev-002-rj45-3	dev-002	pg-1	GE1/0/3	Server-3	RJ45	1G	up	connected	{"mode": "access", "pvid": 100}	{"trustMode": "dscp", "defaultPriority": 0, "ingressRateLimit": 1000}	\N	\N	\N	\N	\N	连接服务器3	2026-07-16 06:54:20.035954+00
port-dev-002-rj45-4	dev-002	pg-1	GE1/0/4	Server-4	RJ45	1G	up	connected	{"mode": "access", "pvid": 100}	{"trustMode": "dscp", "defaultPriority": 0, "ingressRateLimit": 1000}	\N	\N	\N	\N	\N	连接服务器4	2026-07-16 06:54:20.035954+00
port-dev-002-rj45-5	dev-002	pg-1	GE1/0/5	Server-5	RJ45	1G	disabled	disconnected	{"mode": "access", "pvid": 100}	{"trustMode": "dscp", "defaultPriority": 0, "ingressRateLimit": 1000}	\N	\N	\N	\N	\N	连接服务器5	2026-07-16 06:54:20.035954+00
port-dev-002-rj45-6	dev-002	pg-1	GE1/0/6	Server-6	RJ45	1G	up	disconnected	{"mode": "access", "pvid": 101}	{"trustMode": "dscp", "defaultPriority": 0, "ingressRateLimit": 1000}	\N	\N	\N	\N	\N	连接服务器6	2026-07-16 06:54:20.035954+00
port-dev-002-rj45-7	dev-002	pg-1	GE1/0/7	Server-7	RJ45	1G	up	disconnected	{"mode": "access", "pvid": 101}	{"trustMode": "dscp", "defaultPriority": 0, "ingressRateLimit": 1000}	\N	\N	\N	\N	\N	连接服务器7	2026-07-16 06:54:20.035954+00
port-dev-005-eth-2	dev-005	pg-2	eth2	\N	RJ45	1G	up	connected	{"mode": "access", "pvid": 200}	\N	\N	\N	\N	\N	\N	管理网络	2026-07-16 06:54:20.035954+00
port-dev-002-rj45-1	dev-002	pg-1	GE1/0/1	Server-1	RJ45	1G	up	connected	{"mode": "access", "pvid": 100}	{"trustMode": "dscp", "defaultPriority": 0, "ingressRateLimit": 1000}	\N	\N	\N	\N	\N	连接服务器1	2026-07-16 06:54:20.035954+00
port-dev-002-rj45-9	dev-002	pg-1	GE1/0/9	Server-9	RJ45	1G	up	disconnected	{"mode": "access", "pvid": 101}	{"trustMode": "dscp", "defaultPriority": 0, "ingressRateLimit": 1000}	\N	\N	\N	\N	\N	连接服务器9	2026-07-16 06:54:20.035954+00
port-dev-002-rj45-10	dev-002	pg-1	GE1/0/10	Server-10	RJ45	1G	disabled	disconnected	{"mode": "access", "pvid": 101}	{"trustMode": "dscp", "defaultPriority": 0, "ingressRateLimit": 1000}	\N	\N	\N	\N	\N	连接服务器10	2026-07-16 06:54:20.035954+00
port-dev-002-rj45-11	dev-002	pg-1	GE1/0/11	Server-11	RJ45	1G	up	disconnected	{"mode": "access", "pvid": 101}	{"trustMode": "dscp", "defaultPriority": 0, "ingressRateLimit": 1000}	\N	\N	\N	\N	\N	连接服务器11	2026-07-16 06:54:20.035954+00
port-dev-002-rj45-12	dev-002	pg-1	GE1/0/12	Server-12	RJ45	1G	up	disconnected	{"mode": "access", "pvid": 102}	{"trustMode": "dscp", "defaultPriority": 0, "ingressRateLimit": 1000}	\N	\N	\N	\N	\N	连接服务器12	2026-07-16 06:54:20.035954+00
port-dev-002-rj45-13	dev-002	pg-1	GE1/0/13	Server-13	RJ45	1G	up	disconnected	{"mode": "access", "pvid": 102}	{"trustMode": "dscp", "defaultPriority": 0, "ingressRateLimit": 1000}	\N	\N	\N	\N	\N	连接服务器13	2026-07-16 06:54:20.035954+00
port-dev-002-rj45-14	dev-002	pg-1	GE1/0/14	Server-14	RJ45	1G	up	disconnected	{"mode": "access", "pvid": 102}	{"trustMode": "dscp", "defaultPriority": 0, "ingressRateLimit": 1000}	\N	\N	\N	\N	\N	连接服务器14	2026-07-16 06:54:20.035954+00
port-dev-002-rj45-15	dev-002	pg-1	GE1/0/15	Server-15	RJ45	1G	disabled	disconnected	{"mode": "access", "pvid": 102}	{"trustMode": "dscp", "defaultPriority": 0, "ingressRateLimit": 1000}	\N	\N	\N	\N	\N	连接服务器15	2026-07-16 06:54:20.035954+00
port-dev-002-rj45-16	dev-002	pg-1	GE1/0/16	Server-16	RJ45	1G	up	disconnected	{"mode": "access", "pvid": 102}	{"trustMode": "dscp", "defaultPriority": 0, "ingressRateLimit": 1000}	\N	\N	\N	\N	\N	连接服务器16	2026-07-16 06:54:20.035954+00
port-dev-002-rj45-17	dev-002	pg-1	GE1/0/17	Server-17	RJ45	1G	up	disconnected	{"mode": "access", "pvid": 102}	{"trustMode": "dscp", "defaultPriority": 0, "ingressRateLimit": 1000}	\N	\N	\N	\N	\N	连接服务器17	2026-07-16 06:54:20.035954+00
port-dev-002-rj45-18	dev-002	pg-1	GE1/0/18	Server-18	RJ45	1G	up	disconnected	{"mode": "access", "pvid": 103}	{"trustMode": "dscp", "defaultPriority": 0, "ingressRateLimit": 1000}	\N	\N	\N	\N	\N	连接服务器18	2026-07-16 06:54:20.035954+00
port-dev-002-rj45-19	dev-002	pg-1	GE1/0/19	Server-19	RJ45	1G	up	disconnected	{"mode": "access", "pvid": 103}	{"trustMode": "dscp", "defaultPriority": 0, "ingressRateLimit": 1000}	\N	\N	\N	\N	\N	连接服务器19	2026-07-16 06:54:20.035954+00
port-dev-002-rj45-20	dev-002	pg-1	GE1/0/20	Server-20	RJ45	1G	disabled	disconnected	{"mode": "access", "pvid": 103}	{"trustMode": "dscp", "defaultPriority": 0, "ingressRateLimit": 1000}	\N	\N	\N	\N	\N	连接服务器20	2026-07-16 06:54:20.035954+00
port-dev-002-rj45-21	dev-002	pg-1	GE1/0/21	Server-21	RJ45	1G	up	disconnected	{"mode": "access", "pvid": 103}	{"trustMode": "dscp", "defaultPriority": 0, "ingressRateLimit": 1000}	\N	\N	\N	\N	\N	连接服务器21	2026-07-16 06:54:20.035954+00
port-dev-002-rj45-22	dev-002	pg-1	GE1/0/22	Server-22	RJ45	1G	up	disconnected	{"mode": "access", "pvid": 103}	{"trustMode": "dscp", "defaultPriority": 0, "ingressRateLimit": 1000}	\N	\N	\N	\N	\N	连接服务器22	2026-07-16 06:54:20.035954+00
port-dev-002-rj45-23	dev-002	pg-1	GE1/0/23	Server-23	RJ45	1G	up	disconnected	{"mode": "access", "pvid": 103}	{"trustMode": "dscp", "defaultPriority": 0, "ingressRateLimit": 1000}	\N	\N	\N	\N	\N	连接服务器23	2026-07-16 06:54:20.035954+00
port-dev-002-rj45-24	dev-002	pg-1	GE1/0/24	Server-24	RJ45	1G	up	disconnected	{"mode": "access", "pvid": 104}	{"trustMode": "dscp", "defaultPriority": 0, "ingressRateLimit": 1000}	\N	\N	\N	\N	\N	连接服务器24	2026-07-16 06:54:20.035954+00
port-dev-002-rj45-25	dev-002	pg-1	GE1/0/25	\N	RJ45	1G	disabled	disconnected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	{"trustMode": "dscp", "defaultPriority": 0}	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-002-rj45-26	dev-002	pg-1	GE1/0/26	\N	RJ45	1G	up	disconnected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	{"trustMode": "dscp", "defaultPriority": 0}	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-002-rj45-27	dev-002	pg-1	GE1/0/27	\N	RJ45	1G	up	disconnected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	{"trustMode": "dscp", "defaultPriority": 0}	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-002-rj45-28	dev-002	pg-1	GE1/0/28	\N	RJ45	1G	up	disconnected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	{"trustMode": "dscp", "defaultPriority": 0}	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-002-rj45-29	dev-002	pg-1	GE1/0/29	\N	RJ45	1G	up	disconnected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	{"trustMode": "dscp", "defaultPriority": 0}	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-002-rj45-30	dev-002	pg-1	GE1/0/30	\N	RJ45	1G	disabled	disconnected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	{"trustMode": "dscp", "defaultPriority": 0}	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-002-rj45-32	dev-002	pg-1	GE1/0/32	\N	RJ45	1G	up	disconnected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	{"trustMode": "dscp", "defaultPriority": 0}	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-002-rj45-33	dev-002	pg-1	GE1/0/33	\N	RJ45	1G	up	disconnected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	{"trustMode": "dscp", "defaultPriority": 0}	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-002-rj45-34	dev-002	pg-1	GE1/0/34	\N	RJ45	1G	up	disconnected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	{"trustMode": "dscp", "defaultPriority": 0}	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-002-rj45-36	dev-002	pg-1	GE1/0/36	\N	RJ45	1G	up	disconnected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	{"trustMode": "dscp", "defaultPriority": 0}	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-002-rj45-37	dev-002	pg-1	GE1/0/37	\N	RJ45	1G	up	disconnected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	{"trustMode": "dscp", "defaultPriority": 0}	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-002-rj45-39	dev-002	pg-1	GE1/0/39	\N	RJ45	1G	up	disconnected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	{"trustMode": "dscp", "defaultPriority": 0}	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-002-rj45-40	dev-002	pg-1	GE1/0/40	\N	RJ45	1G	disabled	disconnected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	{"trustMode": "dscp", "defaultPriority": 0}	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-002-rj45-41	dev-002	pg-1	GE1/0/41	\N	RJ45	1G	up	disconnected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	{"trustMode": "dscp", "defaultPriority": 0}	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-002-rj45-42	dev-002	pg-1	GE1/0/42	\N	RJ45	1G	up	disconnected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	{"trustMode": "dscp", "defaultPriority": 0}	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-002-rj45-43	dev-002	pg-1	GE1/0/43	\N	RJ45	1G	up	disconnected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	{"trustMode": "dscp", "defaultPriority": 0}	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-002-rj45-44	dev-002	pg-1	GE1/0/44	\N	RJ45	1G	up	disconnected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	{"trustMode": "dscp", "defaultPriority": 0}	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-002-rj45-45	dev-002	pg-1	GE1/0/45	\N	RJ45	1G	disabled	disconnected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	{"trustMode": "dscp", "defaultPriority": 0}	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-002-rj45-46	dev-002	pg-1	GE1/0/46	\N	RJ45	1G	up	disconnected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	{"trustMode": "dscp", "defaultPriority": 0}	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-002-rj45-47	dev-002	pg-1	GE1/0/47	\N	RJ45	1G	up	connected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	{"trustMode": "dscp", "defaultPriority": 0}	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-002-rj45-48	dev-002	pg-1	GE1/0/48	\N	RJ45	1G	up	disconnected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	{"trustMode": "dscp", "defaultPriority": 0}	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-002-sfp-1	dev-002	pg-2	XGE1/0/1	Uplink-1	SFP+	10G	up	connected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	\N	\N	\N	\N	\N	\N	上联核心交换机-1	2026-07-16 06:54:20.035954+00
port-dev-002-sfp-2	dev-002	pg-2	XGE1/0/2	Uplink-2	SFP+	10G	up	connected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	\N	\N	\N	\N	\N	\N	上联核心交换机-2	2026-07-16 06:54:20.035954+00
port-dev-002-sfp-3	dev-002	pg-2	XGE1/0/3	\N	SFP+	10G	up	disconnected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-002-sfp-4	dev-002	pg-2	XGE1/0/4	\N	SFP+	10G	up	disconnected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-003-mgmt	dev-003	pg-1	Mgmt	IPMI管理口	RJ45	1G	up	connected	\N	\N	\N	\N	\N	\N	\N	IPMI/iLO/iDRAC管理口	2026-07-16 06:54:20.035954+00
port-dev-003-eth-1	dev-003	pg-2	eth1	\N	RJ45	1G	up	connected	{"mode": "access", "pvid": 100}	\N	\N	\N	\N	\N	\N	业务网络	2026-07-16 06:54:20.035954+00
port-dev-003-eth-2	dev-003	pg-2	eth2	\N	RJ45	1G	up	connected	{"mode": "access", "pvid": 200}	\N	\N	\N	\N	\N	\N	管理网络	2026-07-16 06:54:20.035954+00
port-dev-003-eth-3	dev-003	pg-2	eth3	\N	RJ45	1G	up	disconnected	\N	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-003-eth-4	dev-003	pg-2	eth4	\N	RJ45	1G	up	disconnected	\N	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-003-pwr-1	dev-003	pg-3	PWR1	\N	Power	N/A	up	disconnected	\N	\N	\N	\N	\N	\N	\N	电源模块1	2026-07-16 06:54:20.035954+00
port-dev-003-pwr-2	dev-003	pg-3	PWR2	\N	Power	N/A	up	disconnected	\N	\N	\N	\N	\N	\N	\N	电源模块2	2026-07-16 06:54:20.035954+00
port-dev-004-mgmt	dev-004	pg-1	Mgmt	IPMI管理口	RJ45	1G	up	disconnected	\N	\N	\N	\N	\N	\N	\N	IPMI/iLO/iDRAC管理口	2026-07-16 06:54:20.035954+00
port-dev-004-eth-1	dev-004	pg-2	eth1	\N	RJ45	1G	up	connected	{"mode": "access", "pvid": 100}	\N	\N	\N	\N	\N	\N	业务网络	2026-07-16 06:54:20.035954+00
port-dev-004-eth-2	dev-004	pg-2	eth2	\N	RJ45	1G	up	disconnected	{"mode": "access", "pvid": 200}	\N	\N	\N	\N	\N	\N	管理网络	2026-07-16 06:54:20.035954+00
port-dev-004-eth-3	dev-004	pg-2	eth3	\N	RJ45	1G	up	disconnected	\N	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-004-eth-4	dev-004	pg-2	eth4	\N	RJ45	1G	up	disconnected	\N	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-004-pwr-1	dev-004	pg-3	PWR1	\N	Power	N/A	up	disconnected	\N	\N	\N	\N	\N	\N	\N	电源模块1	2026-07-16 06:54:20.035954+00
port-dev-004-pwr-2	dev-004	pg-3	PWR2	\N	Power	N/A	up	disconnected	\N	\N	\N	\N	\N	\N	\N	电源模块2	2026-07-16 06:54:20.035954+00
port-dev-005-mgmt	dev-005	pg-1	Mgmt	IPMI管理口	RJ45	1G	up	disconnected	\N	\N	\N	\N	\N	\N	\N	IPMI/iLO/iDRAC管理口	2026-07-16 06:54:20.035954+00
port-dev-005-eth-1	dev-005	pg-2	eth1	\N	RJ45	1G	up	connected	{"mode": "access", "pvid": 100}	\N	\N	\N	\N	\N	\N	业务网络	2026-07-16 06:54:20.035954+00
port-dev-005-eth-3	dev-005	pg-2	eth3	\N	RJ45	1G	up	disconnected	\N	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-005-eth-4	dev-005	pg-2	eth4	\N	RJ45	1G	up	disconnected	\N	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-005-pwr-1	dev-005	pg-3	PWR1	\N	Power	N/A	up	disconnected	\N	\N	\N	\N	\N	\N	\N	电源模块1	2026-07-16 06:54:20.035954+00
port-dev-005-pwr-2	dev-005	pg-3	PWR2	\N	Power	N/A	up	disconnected	\N	\N	\N	\N	\N	\N	\N	电源模块2	2026-07-16 06:54:20.035954+00
port-dev-006-mgmt	dev-006	pg-1	Mgmt	\N	RJ45	1G	up	disconnected	\N	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-006-rj45-1	dev-006	pg-2	GE0/0/1	\N	RJ45	1G	up	disconnected	\N	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-006-rj45-2	dev-006	pg-2	GE0/0/2	\N	RJ45	1G	up	disconnected	\N	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-006-rj45-3	dev-006	pg-2	GE0/0/3	\N	RJ45	1G	up	disconnected	\N	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-006-rj45-4	dev-006	pg-2	GE0/0/4	\N	RJ45	1G	up	disconnected	\N	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-006-rj45-5	dev-006	pg-2	GE0/0/5	\N	RJ45	1G	up	disconnected	\N	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-006-rj45-6	dev-006	pg-2	GE0/0/6	\N	RJ45	1G	up	disconnected	\N	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-006-rj45-7	dev-006	pg-2	GE0/0/7	\N	RJ45	1G	up	disconnected	\N	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-006-rj45-8	dev-006	pg-2	GE0/0/8	\N	RJ45	1G	up	disconnected	\N	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-006-sfp-1	dev-006	pg-3	XGE0/0/1	\N	SFP+	10G	up	connected	\N	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-006-sfp-2	dev-006	pg-3	XGE0/0/2	\N	SFP+	10G	up	connected	\N	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-006-sfp-3	dev-006	pg-3	XGE0/0/3	\N	SFP+	10G	up	disconnected	\N	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-006-sfp-4	dev-006	pg-3	XGE0/0/4	\N	SFP+	10G	up	disconnected	\N	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-007-mgmt	dev-007	pg-1	Mgmt	\N	RJ45	1G	up	disconnected	\N	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-007-sfp-1	dev-007	pg-2	XGE1/1	\N	SFP+	10G	up	connected	\N	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-007-sfp-2	dev-007	pg-2	XGE1/2	\N	SFP+	10G	up	disconnected	\N	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-007-sfp-3	dev-007	pg-2	XGE1/3	\N	SFP+	10G	up	disconnected	\N	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-007-sfp-4	dev-007	pg-2	XGE1/4	\N	SFP+	10G	up	disconnected	\N	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-007-sfp-5	dev-007	pg-2	XGE1/5	\N	SFP+	10G	up	disconnected	\N	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-007-sfp-6	dev-007	pg-2	XGE1/6	\N	SFP+	10G	up	disconnected	\N	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-007-sfp-7	dev-007	pg-2	XGE1/7	\N	SFP+	10G	up	disconnected	\N	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-007-sfp-8	dev-007	pg-2	XGE1/8	\N	SFP+	10G	up	disconnected	\N	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-008-mgmt-1	dev-008	pg-1	Mgmt1	\N	RJ45	1G	up	disconnected	\N	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-008-mgmt-2	dev-008	pg-1	Mgmt2	\N	RJ45	1G	up	disconnected	\N	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-008-fc-1	dev-008	pg-2	FC1	\N	FC	10G	up	disconnected	\N	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-008-fc-2	dev-008	pg-2	FC2	\N	FC	10G	up	disconnected	\N	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-008-fc-3	dev-008	pg-2	FC3	\N	FC	10G	up	disconnected	\N	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-008-fc-4	dev-008	pg-2	FC4	\N	FC	10G	up	disconnected	\N	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-008-fc-5	dev-008	pg-2	FC5	\N	FC	10G	up	disconnected	\N	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-008-fc-6	dev-008	pg-2	FC6	\N	FC	10G	up	disconnected	\N	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-008-iscsi-2	dev-008	pg-3	iSCSI2	\N	RJ45	10G	up	disconnected	\N	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-008-iscsi-3	dev-008	pg-3	iSCSI3	\N	RJ45	10G	up	disconnected	\N	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-008-iscsi-4	dev-008	pg-3	iSCSI4	\N	RJ45	10G	up	disconnected	\N	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-009-rj45-1	dev-009	pg-1	GE1/0/1	Server-1	RJ45	1G	up	disconnected	{"mode": "access", "pvid": 100}	{"trustMode": "dscp", "defaultPriority": 0, "ingressRateLimit": 1000}	\N	\N	\N	\N	\N	连接服务器1	2026-07-16 06:54:20.035954+00
port-dev-009-rj45-2	dev-009	pg-1	GE1/0/2	Server-2	RJ45	1G	up	disconnected	{"mode": "access", "pvid": 100}	{"trustMode": "dscp", "defaultPriority": 0, "ingressRateLimit": 1000}	\N	\N	\N	\N	\N	连接服务器2	2026-07-16 06:54:20.035954+00
port-dev-009-rj45-3	dev-009	pg-1	GE1/0/3	Server-3	RJ45	1G	up	disconnected	{"mode": "access", "pvid": 100}	{"trustMode": "dscp", "defaultPriority": 0, "ingressRateLimit": 1000}	\N	\N	\N	\N	\N	连接服务器3	2026-07-16 06:54:20.035954+00
port-dev-009-rj45-4	dev-009	pg-1	GE1/0/4	Server-4	RJ45	1G	up	disconnected	{"mode": "access", "pvid": 100}	{"trustMode": "dscp", "defaultPriority": 0, "ingressRateLimit": 1000}	\N	\N	\N	\N	\N	连接服务器4	2026-07-16 06:54:20.035954+00
port-dev-009-rj45-5	dev-009	pg-1	GE1/0/5	Server-5	RJ45	1G	disabled	disconnected	{"mode": "access", "pvid": 100}	{"trustMode": "dscp", "defaultPriority": 0, "ingressRateLimit": 1000}	\N	\N	\N	\N	\N	连接服务器5	2026-07-16 06:54:20.035954+00
port-dev-009-rj45-6	dev-009	pg-1	GE1/0/6	Server-6	RJ45	1G	up	disconnected	{"mode": "access", "pvid": 101}	{"trustMode": "dscp", "defaultPriority": 0, "ingressRateLimit": 1000}	\N	\N	\N	\N	\N	连接服务器6	2026-07-16 06:54:20.035954+00
port-dev-009-rj45-7	dev-009	pg-1	GE1/0/7	Server-7	RJ45	1G	up	disconnected	{"mode": "access", "pvid": 101}	{"trustMode": "dscp", "defaultPriority": 0, "ingressRateLimit": 1000}	\N	\N	\N	\N	\N	连接服务器7	2026-07-16 06:54:20.035954+00
port-dev-009-rj45-8	dev-009	pg-1	GE1/0/8	Server-8	RJ45	1G	up	disconnected	{"mode": "access", "pvid": 101}	{"trustMode": "dscp", "defaultPriority": 0, "ingressRateLimit": 1000}	\N	\N	\N	\N	\N	连接服务器8	2026-07-16 06:54:20.035954+00
port-dev-009-rj45-9	dev-009	pg-1	GE1/0/9	Server-9	RJ45	1G	up	disconnected	{"mode": "access", "pvid": 101}	{"trustMode": "dscp", "defaultPriority": 0, "ingressRateLimit": 1000}	\N	\N	\N	\N	\N	连接服务器9	2026-07-16 06:54:20.035954+00
port-dev-009-rj45-10	dev-009	pg-1	GE1/0/10	Server-10	RJ45	1G	disabled	disconnected	{"mode": "access", "pvid": 101}	{"trustMode": "dscp", "defaultPriority": 0, "ingressRateLimit": 1000}	\N	\N	\N	\N	\N	连接服务器10	2026-07-16 06:54:20.035954+00
port-dev-009-rj45-11	dev-009	pg-1	GE1/0/11	Server-11	RJ45	1G	up	disconnected	{"mode": "access", "pvid": 101}	{"trustMode": "dscp", "defaultPriority": 0, "ingressRateLimit": 1000}	\N	\N	\N	\N	\N	连接服务器11	2026-07-16 06:54:20.035954+00
port-dev-009-rj45-12	dev-009	pg-1	GE1/0/12	Server-12	RJ45	1G	up	disconnected	{"mode": "access", "pvid": 102}	{"trustMode": "dscp", "defaultPriority": 0, "ingressRateLimit": 1000}	\N	\N	\N	\N	\N	连接服务器12	2026-07-16 06:54:20.035954+00
port-dev-009-rj45-13	dev-009	pg-1	GE1/0/13	Server-13	RJ45	1G	up	disconnected	{"mode": "access", "pvid": 102}	{"trustMode": "dscp", "defaultPriority": 0, "ingressRateLimit": 1000}	\N	\N	\N	\N	\N	连接服务器13	2026-07-16 06:54:20.035954+00
port-dev-011-qsfp-2	dev-011	pg-2	40GE1/0/2	\N	QSFP+	40G	up	disconnected	\N	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-011-qsfp-3	dev-011	pg-2	40GE1/0/3	\N	QSFP+	40G	up	disconnected	\N	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-009-rj45-14	dev-009	pg-1	GE1/0/14	Server-14	RJ45	1G	up	disconnected	{"mode": "access", "pvid": 102}	{"trustMode": "dscp", "defaultPriority": 0, "ingressRateLimit": 1000}	\N	\N	\N	\N	\N	连接服务器14	2026-07-16 06:54:20.035954+00
port-dev-009-rj45-15	dev-009	pg-1	GE1/0/15	Server-15	RJ45	1G	disabled	disconnected	{"mode": "access", "pvid": 102}	{"trustMode": "dscp", "defaultPriority": 0, "ingressRateLimit": 1000}	\N	\N	\N	\N	\N	连接服务器15	2026-07-16 06:54:20.035954+00
port-dev-009-rj45-16	dev-009	pg-1	GE1/0/16	Server-16	RJ45	1G	up	disconnected	{"mode": "access", "pvid": 102}	{"trustMode": "dscp", "defaultPriority": 0, "ingressRateLimit": 1000}	\N	\N	\N	\N	\N	连接服务器16	2026-07-16 06:54:20.035954+00
port-dev-009-rj45-17	dev-009	pg-1	GE1/0/17	Server-17	RJ45	1G	up	disconnected	{"mode": "access", "pvid": 102}	{"trustMode": "dscp", "defaultPriority": 0, "ingressRateLimit": 1000}	\N	\N	\N	\N	\N	连接服务器17	2026-07-16 06:54:20.035954+00
port-dev-009-rj45-18	dev-009	pg-1	GE1/0/18	Server-18	RJ45	1G	up	disconnected	{"mode": "access", "pvid": 103}	{"trustMode": "dscp", "defaultPriority": 0, "ingressRateLimit": 1000}	\N	\N	\N	\N	\N	连接服务器18	2026-07-16 06:54:20.035954+00
port-dev-009-rj45-19	dev-009	pg-1	GE1/0/19	Server-19	RJ45	1G	up	disconnected	{"mode": "access", "pvid": 103}	{"trustMode": "dscp", "defaultPriority": 0, "ingressRateLimit": 1000}	\N	\N	\N	\N	\N	连接服务器19	2026-07-16 06:54:20.035954+00
port-dev-009-rj45-20	dev-009	pg-1	GE1/0/20	Server-20	RJ45	1G	disabled	disconnected	{"mode": "access", "pvid": 103}	{"trustMode": "dscp", "defaultPriority": 0, "ingressRateLimit": 1000}	\N	\N	\N	\N	\N	连接服务器20	2026-07-16 06:54:20.035954+00
port-dev-009-rj45-21	dev-009	pg-1	GE1/0/21	Server-21	RJ45	1G	up	disconnected	{"mode": "access", "pvid": 103}	{"trustMode": "dscp", "defaultPriority": 0, "ingressRateLimit": 1000}	\N	\N	\N	\N	\N	连接服务器21	2026-07-16 06:54:20.035954+00
port-dev-009-rj45-22	dev-009	pg-1	GE1/0/22	Server-22	RJ45	1G	up	disconnected	{"mode": "access", "pvid": 103}	{"trustMode": "dscp", "defaultPriority": 0, "ingressRateLimit": 1000}	\N	\N	\N	\N	\N	连接服务器22	2026-07-16 06:54:20.035954+00
port-dev-009-rj45-23	dev-009	pg-1	GE1/0/23	Server-23	RJ45	1G	up	disconnected	{"mode": "access", "pvid": 103}	{"trustMode": "dscp", "defaultPriority": 0, "ingressRateLimit": 1000}	\N	\N	\N	\N	\N	连接服务器23	2026-07-16 06:54:20.035954+00
port-dev-009-rj45-24	dev-009	pg-1	GE1/0/24	Server-24	RJ45	1G	up	disconnected	{"mode": "access", "pvid": 104}	{"trustMode": "dscp", "defaultPriority": 0, "ingressRateLimit": 1000}	\N	\N	\N	\N	\N	连接服务器24	2026-07-16 06:54:20.035954+00
port-dev-009-rj45-25	dev-009	pg-1	GE1/0/25	\N	RJ45	1G	disabled	disconnected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	{"trustMode": "dscp", "defaultPriority": 0}	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-009-rj45-26	dev-009	pg-1	GE1/0/26	\N	RJ45	1G	up	disconnected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	{"trustMode": "dscp", "defaultPriority": 0}	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-009-rj45-27	dev-009	pg-1	GE1/0/27	\N	RJ45	1G	up	disconnected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	{"trustMode": "dscp", "defaultPriority": 0}	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-009-rj45-28	dev-009	pg-1	GE1/0/28	\N	RJ45	1G	up	disconnected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	{"trustMode": "dscp", "defaultPriority": 0}	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-009-rj45-29	dev-009	pg-1	GE1/0/29	\N	RJ45	1G	up	disconnected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	{"trustMode": "dscp", "defaultPriority": 0}	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-009-rj45-30	dev-009	pg-1	GE1/0/30	\N	RJ45	1G	disabled	disconnected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	{"trustMode": "dscp", "defaultPriority": 0}	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-009-rj45-31	dev-009	pg-1	GE1/0/31	\N	RJ45	1G	up	disconnected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	{"trustMode": "dscp", "defaultPriority": 0}	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-009-rj45-32	dev-009	pg-1	GE1/0/32	\N	RJ45	1G	up	disconnected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	{"trustMode": "dscp", "defaultPriority": 0}	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-009-rj45-33	dev-009	pg-1	GE1/0/33	\N	RJ45	1G	up	disconnected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	{"trustMode": "dscp", "defaultPriority": 0}	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-009-rj45-34	dev-009	pg-1	GE1/0/34	\N	RJ45	1G	up	disconnected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	{"trustMode": "dscp", "defaultPriority": 0}	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-009-rj45-35	dev-009	pg-1	GE1/0/35	\N	RJ45	1G	disabled	disconnected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	{"trustMode": "dscp", "defaultPriority": 0}	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-009-rj45-36	dev-009	pg-1	GE1/0/36	\N	RJ45	1G	up	disconnected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	{"trustMode": "dscp", "defaultPriority": 0}	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-009-rj45-37	dev-009	pg-1	GE1/0/37	\N	RJ45	1G	up	disconnected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	{"trustMode": "dscp", "defaultPriority": 0}	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-009-rj45-38	dev-009	pg-1	GE1/0/38	\N	RJ45	1G	up	disconnected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	{"trustMode": "dscp", "defaultPriority": 0}	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-009-rj45-39	dev-009	pg-1	GE1/0/39	\N	RJ45	1G	up	disconnected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	{"trustMode": "dscp", "defaultPriority": 0}	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-009-rj45-40	dev-009	pg-1	GE1/0/40	\N	RJ45	1G	disabled	disconnected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	{"trustMode": "dscp", "defaultPriority": 0}	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-009-rj45-41	dev-009	pg-1	GE1/0/41	\N	RJ45	1G	up	disconnected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	{"trustMode": "dscp", "defaultPriority": 0}	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-009-rj45-42	dev-009	pg-1	GE1/0/42	\N	RJ45	1G	up	disconnected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	{"trustMode": "dscp", "defaultPriority": 0}	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-009-rj45-43	dev-009	pg-1	GE1/0/43	\N	RJ45	1G	up	disconnected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	{"trustMode": "dscp", "defaultPriority": 0}	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-009-rj45-44	dev-009	pg-1	GE1/0/44	\N	RJ45	1G	up	disconnected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	{"trustMode": "dscp", "defaultPriority": 0}	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-009-rj45-45	dev-009	pg-1	GE1/0/45	\N	RJ45	1G	disabled	disconnected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	{"trustMode": "dscp", "defaultPriority": 0}	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-009-rj45-46	dev-009	pg-1	GE1/0/46	\N	RJ45	1G	up	disconnected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	{"trustMode": "dscp", "defaultPriority": 0}	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-009-rj45-47	dev-009	pg-1	GE1/0/47	\N	RJ45	1G	up	disconnected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	{"trustMode": "dscp", "defaultPriority": 0}	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-009-rj45-48	dev-009	pg-1	GE1/0/48	\N	RJ45	1G	up	disconnected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	{"trustMode": "dscp", "defaultPriority": 0}	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-009-sfp-1	dev-009	pg-2	XGE1/0/1	Uplink-1	SFP+	10G	up	disconnected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	\N	\N	\N	\N	\N	\N	上联核心交换机-1	2026-07-16 06:54:20.035954+00
port-dev-009-sfp-2	dev-009	pg-2	XGE1/0/2	Uplink-2	SFP+	10G	up	disconnected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	\N	\N	\N	\N	\N	\N	上联核心交换机-2	2026-07-16 06:54:20.035954+00
port-dev-009-sfp-3	dev-009	pg-2	XGE1/0/3	\N	SFP+	10G	up	disconnected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-009-sfp-4	dev-009	pg-2	XGE1/0/4	\N	SFP+	10G	up	disconnected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-010-sfp-1	dev-010	pg-1	XGE1/0/1	\N	SFP+	10G	up	disconnected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-010-sfp-2	dev-010	pg-1	XGE1/0/2	\N	SFP+	10G	up	disconnected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-010-sfp-3	dev-010	pg-1	XGE1/0/3	\N	SFP+	10G	up	disconnected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-010-sfp-4	dev-010	pg-1	XGE1/0/4	\N	SFP+	10G	up	disconnected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-010-sfp-5	dev-010	pg-1	XGE1/0/5	\N	SFP+	10G	up	disconnected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-010-sfp-6	dev-010	pg-1	XGE1/0/6	\N	SFP+	10G	up	disconnected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-010-sfp-7	dev-010	pg-1	XGE1/0/7	\N	SFP+	10G	up	disconnected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-010-sfp-8	dev-010	pg-1	XGE1/0/8	\N	SFP+	10G	up	disconnected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-010-sfp-9	dev-010	pg-1	XGE1/0/9	\N	SFP+	10G	up	disconnected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-010-sfp-10	dev-010	pg-1	XGE1/0/10	\N	SFP+	10G	up	disconnected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-010-sfp-11	dev-010	pg-1	XGE1/0/11	\N	SFP+	10G	up	disconnected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-010-sfp-12	dev-010	pg-1	XGE1/0/12	\N	SFP+	10G	up	disconnected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-010-sfp-13	dev-010	pg-1	XGE1/0/13	\N	SFP+	10G	up	disconnected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-010-sfp-14	dev-010	pg-1	XGE1/0/14	\N	SFP+	10G	up	disconnected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-010-sfp-15	dev-010	pg-1	XGE1/0/15	\N	SFP+	10G	up	disconnected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-010-sfp-16	dev-010	pg-1	XGE1/0/16	\N	SFP+	10G	up	disconnected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-010-sfp-17	dev-010	pg-1	XGE1/0/17	\N	SFP+	10G	up	disconnected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-010-sfp-18	dev-010	pg-1	XGE1/0/18	\N	SFP+	10G	up	disconnected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-010-sfp-19	dev-010	pg-1	XGE1/0/19	\N	SFP+	10G	up	disconnected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-010-sfp-20	dev-010	pg-1	XGE1/0/20	\N	SFP+	10G	up	disconnected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-010-sfp-21	dev-010	pg-1	XGE1/0/21	\N	SFP+	10G	up	disconnected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-010-sfp-22	dev-010	pg-1	XGE1/0/22	\N	SFP+	10G	up	disconnected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-010-sfp-23	dev-010	pg-1	XGE1/0/23	\N	SFP+	10G	up	disconnected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-010-sfp-24	dev-010	pg-1	XGE1/0/24	\N	SFP+	10G	up	disconnected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-010-sfp-25	dev-010	pg-1	XGE1/0/25	\N	SFP+	10G	up	disconnected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-010-sfp-26	dev-010	pg-1	XGE1/0/26	\N	SFP+	10G	up	disconnected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-010-sfp-27	dev-010	pg-1	XGE1/0/27	\N	SFP+	10G	up	disconnected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-010-sfp-28	dev-010	pg-1	XGE1/0/28	\N	SFP+	10G	up	disconnected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-010-sfp-29	dev-010	pg-1	XGE1/0/29	\N	SFP+	10G	up	disconnected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-010-sfp-30	dev-010	pg-1	XGE1/0/30	\N	SFP+	10G	up	disconnected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-010-sfp-31	dev-010	pg-1	XGE1/0/31	\N	SFP+	10G	up	disconnected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-010-sfp-32	dev-010	pg-1	XGE1/0/32	\N	SFP+	10G	up	disconnected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-010-sfp-33	dev-010	pg-1	XGE1/0/33	\N	SFP+	10G	up	disconnected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-010-sfp-34	dev-010	pg-1	XGE1/0/34	\N	SFP+	10G	up	disconnected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-010-sfp-35	dev-010	pg-1	XGE1/0/35	\N	SFP+	10G	up	disconnected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-010-sfp-36	dev-010	pg-1	XGE1/0/36	\N	SFP+	10G	up	disconnected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-010-sfp-37	dev-010	pg-1	XGE1/0/37	\N	SFP+	10G	up	disconnected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-010-sfp-38	dev-010	pg-1	XGE1/0/38	\N	SFP+	10G	up	disconnected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-010-sfp-39	dev-010	pg-1	XGE1/0/39	\N	SFP+	10G	up	disconnected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-010-sfp-40	dev-010	pg-1	XGE1/0/40	\N	SFP+	10G	up	disconnected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-010-sfp-41	dev-010	pg-1	XGE1/0/41	\N	SFP+	10G	up	disconnected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-010-sfp-42	dev-010	pg-1	XGE1/0/42	\N	SFP+	10G	up	disconnected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-011-qsfp-4	dev-011	pg-2	40GE1/0/4	\N	QSFP+	40G	up	disconnected	\N	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-010-sfp-43	dev-010	pg-1	XGE1/0/43	\N	SFP+	10G	up	disconnected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-010-sfp-44	dev-010	pg-1	XGE1/0/44	\N	SFP+	10G	up	disconnected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-010-sfp-45	dev-010	pg-1	XGE1/0/45	\N	SFP+	10G	up	disconnected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-010-sfp-46	dev-010	pg-1	XGE1/0/46	\N	SFP+	10G	up	disconnected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-010-sfp-47	dev-010	pg-1	XGE1/0/47	\N	SFP+	10G	up	disconnected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-010-sfp-48	dev-010	pg-1	XGE1/0/48	\N	SFP+	10G	up	disconnected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-010-qsfp-1	dev-010	pg-2	100GE1/0/1	\N	QSFP28	100G	up	disconnected	\N	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-010-qsfp-2	dev-010	pg-2	100GE1/0/2	\N	QSFP28	100G	up	disconnected	\N	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-010-qsfp-3	dev-010	pg-2	100GE1/0/3	\N	QSFP28	100G	up	disconnected	\N	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-010-qsfp-4	dev-010	pg-2	100GE1/0/4	\N	QSFP28	100G	up	disconnected	\N	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-010-qsfp-5	dev-010	pg-2	100GE1/0/5	\N	QSFP28	100G	up	disconnected	\N	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-010-qsfp-6	dev-010	pg-2	100GE1/0/6	\N	QSFP28	100G	up	disconnected	\N	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-011-sfp-1	dev-011	pg-1	XGE1/0/1	\N	SFP+	10G	up	disconnected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-011-sfp-2	dev-011	pg-1	XGE1/0/2	\N	SFP+	10G	up	disconnected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-011-sfp-3	dev-011	pg-1	XGE1/0/3	\N	SFP+	10G	up	disconnected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-011-sfp-4	dev-011	pg-1	XGE1/0/4	\N	SFP+	10G	up	disconnected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-011-sfp-5	dev-011	pg-1	XGE1/0/5	\N	SFP+	10G	up	disconnected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-011-sfp-6	dev-011	pg-1	XGE1/0/6	\N	SFP+	10G	up	disconnected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-011-sfp-7	dev-011	pg-1	XGE1/0/7	\N	SFP+	10G	up	disconnected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-011-sfp-8	dev-011	pg-1	XGE1/0/8	\N	SFP+	10G	up	disconnected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-011-sfp-9	dev-011	pg-1	XGE1/0/9	\N	SFP+	10G	up	disconnected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-011-sfp-10	dev-011	pg-1	XGE1/0/10	\N	SFP+	10G	up	disconnected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-011-sfp-11	dev-011	pg-1	XGE1/0/11	\N	SFP+	10G	up	disconnected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-011-sfp-12	dev-011	pg-1	XGE1/0/12	\N	SFP+	10G	up	disconnected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-011-sfp-13	dev-011	pg-1	XGE1/0/13	\N	SFP+	10G	up	disconnected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-011-sfp-14	dev-011	pg-1	XGE1/0/14	\N	SFP+	10G	up	disconnected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-011-sfp-15	dev-011	pg-1	XGE1/0/15	\N	SFP+	10G	up	disconnected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-011-sfp-16	dev-011	pg-1	XGE1/0/16	\N	SFP+	10G	up	disconnected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-011-sfp-17	dev-011	pg-1	XGE1/0/17	\N	SFP+	10G	up	disconnected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-011-sfp-18	dev-011	pg-1	XGE1/0/18	\N	SFP+	10G	up	disconnected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-011-sfp-19	dev-011	pg-1	XGE1/0/19	\N	SFP+	10G	up	disconnected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-011-sfp-20	dev-011	pg-1	XGE1/0/20	\N	SFP+	10G	up	disconnected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-011-qsfp-5	dev-011	pg-2	40GE1/0/5	\N	QSFP+	40G	up	disconnected	\N	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-011-sfp-21	dev-011	pg-1	XGE1/0/21	\N	SFP+	10G	up	disconnected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-011-sfp-22	dev-011	pg-1	XGE1/0/22	\N	SFP+	10G	up	disconnected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-011-sfp-23	dev-011	pg-1	XGE1/0/23	\N	SFP+	10G	up	disconnected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-011-sfp-24	dev-011	pg-1	XGE1/0/24	\N	SFP+	10G	up	disconnected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-011-sfp-25	dev-011	pg-1	XGE1/0/25	\N	SFP+	10G	up	disconnected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-011-sfp-26	dev-011	pg-1	XGE1/0/26	\N	SFP+	10G	up	disconnected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-011-sfp-27	dev-011	pg-1	XGE1/0/27	\N	SFP+	10G	up	disconnected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-011-sfp-28	dev-011	pg-1	XGE1/0/28	\N	SFP+	10G	up	disconnected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-011-sfp-29	dev-011	pg-1	XGE1/0/29	\N	SFP+	10G	up	disconnected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-011-sfp-30	dev-011	pg-1	XGE1/0/30	\N	SFP+	10G	up	disconnected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-011-sfp-31	dev-011	pg-1	XGE1/0/31	\N	SFP+	10G	up	disconnected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-011-sfp-32	dev-011	pg-1	XGE1/0/32	\N	SFP+	10G	up	disconnected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-011-sfp-33	dev-011	pg-1	XGE1/0/33	\N	SFP+	10G	up	disconnected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-011-sfp-34	dev-011	pg-1	XGE1/0/34	\N	SFP+	10G	up	disconnected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-011-sfp-35	dev-011	pg-1	XGE1/0/35	\N	SFP+	10G	up	disconnected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-011-sfp-36	dev-011	pg-1	XGE1/0/36	\N	SFP+	10G	up	disconnected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-011-sfp-37	dev-011	pg-1	XGE1/0/37	\N	SFP+	10G	up	disconnected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-011-sfp-38	dev-011	pg-1	XGE1/0/38	\N	SFP+	10G	up	disconnected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-011-sfp-39	dev-011	pg-1	XGE1/0/39	\N	SFP+	10G	up	disconnected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-011-sfp-40	dev-011	pg-1	XGE1/0/40	\N	SFP+	10G	up	disconnected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-011-sfp-41	dev-011	pg-1	XGE1/0/41	\N	SFP+	10G	up	disconnected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-011-sfp-42	dev-011	pg-1	XGE1/0/42	\N	SFP+	10G	up	disconnected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-011-sfp-43	dev-011	pg-1	XGE1/0/43	\N	SFP+	10G	up	disconnected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-011-sfp-44	dev-011	pg-1	XGE1/0/44	\N	SFP+	10G	up	disconnected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-011-sfp-45	dev-011	pg-1	XGE1/0/45	\N	SFP+	10G	up	disconnected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-011-sfp-46	dev-011	pg-1	XGE1/0/46	\N	SFP+	10G	up	disconnected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-011-sfp-47	dev-011	pg-1	XGE1/0/47	\N	SFP+	10G	up	disconnected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-011-sfp-48	dev-011	pg-1	XGE1/0/48	\N	SFP+	10G	up	disconnected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-011-qsfp-1	dev-011	pg-2	40GE1/0/1	\N	QSFP+	40G	up	disconnected	\N	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-8d582d62-pg-1-1	dev-8d582d62	pg-1	pg-1-1	\N	RJ45	1G	up	disconnected	\N	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-8d582d62-pg-2-2	dev-8d582d62	pg-2	pg-2-2	\N	SFP	40G	up	disconnected	\N	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-002-rj45-38	dev-002	pg-1	GE1/0/38	\N	RJ45	1G	up	connected	{"mode": "trunk", "pvid": 1, "allowedVlans": [1, 100, 101, 102, 103, 104, 200, 300]}	{"trustMode": "dscp", "defaultPriority": 0}	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-8d582d62-pg-2-1	dev-8d582d62	pg-2	pg-2-1	\N	SFP	40G	up	connected	\N	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-9635142f-pg-1-1	dev-9635142f	pg-1	pg-1-1	\N	RJ45	1G	up	disconnected	\N	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-9635142f-pg-2-1	dev-9635142f	pg-2	pg-2-1	\N	SFP	40G	up	disconnected	\N	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
port-dev-9635142f-pg-2-2	dev-9635142f	pg-2	pg-2-2	\N	SFP	40G	up	disconnected	\N	\N	\N	\N	\N	\N	\N	\N	2026-07-16 06:54:20.035954+00
\.


--
-- Data for Name: port_group_template; Type: TABLE DATA; Schema: dcim_ontology_demo_20260623083835; Owner: -
--

COPY "__DCIM_TARGET_SCHEMA__".port_group_template (id, template_id, name, port_type, port_count, speed, poe) FROM stdin;
pg-1	tpl-huawei-s5735-48t4x	千兆电口	RJ45	48	1G	f
pg-2	tpl-huawei-s5735-48t4x	万兆光口	SFP+	4	10G	f
pg-1	tpl-huawei-s6730-48x6c	万兆光口	SFP+	48	10G	f
pg-2	tpl-huawei-s6730-48x6c	100G光口	QSFP28	6	100G	f
pg-1	tpl-huawei-ce6881-48s6cq	25G光口	SFP+	48	25G	f
pg-2	tpl-huawei-ce6881-48s6cq	100G光口	QSFP28	6	100G	f
pg-1	tpl-cisco-c9300-48p	千兆PoE+电口	RJ45	48	1G	t
pg-2	tpl-cisco-c9300-48p	上行模块槽	SFP+	4	10G	f
pg-1	tpl-cisco-n9k-93180yc	25G光口	SFP+	48	25G	f
pg-2	tpl-cisco-n9k-93180yc	100G光口	QSFP28	6	100G	f
pg-1	tpl-h3c-s6850-56hf	万兆光口	SFP+	48	10G	f
pg-2	tpl-h3c-s6850-56hf	40G光口	QSFP+	8	40G	f
pg-1	tpl-ruijie-s6220-48xs6qxs	万兆光口	SFP+	48	10G	f
pg-2	tpl-ruijie-s6220-48xs6qxs	40G光口	QSFP+	6	40G	f
pg-1	tpl-huawei-2288h-v6	管理口	RJ45	1	1G	f
pg-2	tpl-huawei-2288h-v6	业务网口	RJ45	4	1G	f
pg-3	tpl-huawei-2288h-v6	电源接口	Power	2	N/A	f
pg-1	tpl-dell-r750	iDRAC管理口	RJ45	1	1G	f
pg-2	tpl-dell-r750	业务网口	RJ45	4	1G	f
pg-3	tpl-dell-r750	电源接口	Power	2	N/A	f
pg-1	tpl-hpe-dl380-gen10	iLO管理口	RJ45	1	1G	f
pg-2	tpl-hpe-dl380-gen10	业务网口	RJ45	4	1G	f
pg-3	tpl-hpe-dl380-gen10	电源接口	Power	2	N/A	f
pg-1	tpl-inspur-nf5280m6	BMC管理口	RJ45	1	1G	f
pg-2	tpl-inspur-nf5280m6	业务网口	RJ45	4	1G	f
pg-3	tpl-inspur-nf5280m6	电源接口	Power	2	N/A	f
pg-1	tpl-huawei-ne40e-x8	业务板卡槽位	SFP+	8	10G	f
pg-1	tpl-cisco-asr-9000	线卡槽位	SFP+	6	10G	f
pg-1	tpl-huawei-oceanstor-5500	管理口	RJ45	2	1G	f
pg-2	tpl-huawei-oceanstor-5500	FC存储口	FC	8	10G	f
pg-3	tpl-huawei-oceanstor-5500	iSCSI口	RJ45	4	10G	f
pg-1	tpl-huawei-usg6680	管理口	RJ45	1	1G	f
pg-2	tpl-huawei-usg6680	业务电口	RJ45	8	1G	f
pg-3	tpl-huawei-usg6680	业务光口	SFP+	4	10G	f
pg-1	tpl-f5-big-ip-i5800	管理口	RJ45	1	1G	f
pg-2	tpl-f5-big-ip-i5800	业务口	SFP+	8	10G	f
pg-1	tpl-custom-83749738	iDRAC	RJ45	1	1G	f
pg-2	tpl-custom-83749738	B	SFP	2	40G	f
\.


--
-- Data for Name: power_connection; Type: TABLE DATA; Schema: dcim_ontology_demo_20260623083835; Owner: -
--

COPY "__DCIM_TARGET_SCHEMA__".power_connection (id, datacenter_id, source_node_id, target_node_id, target_node_type, power_path, status, valid_from, valid_to, source_system, confidence) FROM stdin;
link-001	dc-001	utility-001	ups-001	ups	A	active	2024-01-01 00:00:00+00	\N	mock	1.000
link-002	dc-001	utility-002	ups-002	ups	B	active	2024-01-01 00:00:00+00	\N	mock	1.000
link-003	dc-001	ups-001	pdu-001	pdu	A	active	2024-01-01 00:00:00+00	\N	mock	1.000
link-004	dc-001	ups-002	pdu-002	pdu	B	active	2024-01-01 00:00:00+00	\N	mock	1.000
link-005	dc-001	ups-001	pdu-003	pdu	A	active	2024-01-01 00:00:00+00	\N	mock	1.000
link-006	dc-001	ups-002	pdu-004	pdu	B	active	2024-01-01 00:00:00+00	\N	mock	1.000
link-007	dc-001	pdu-001	dev-001	device	A	active	2024-01-01 00:00:00+00	\N	mock	1.000
link-008	dc-001	pdu-002	dev-001	device	B	active	2024-01-01 00:00:00+00	\N	mock	1.000
link-009	dc-001	pdu-001	dev-002	device	A	active	2024-01-01 00:00:00+00	\N	mock	1.000
link-010	dc-001	pdu-002	dev-002	device	B	active	2024-01-01 00:00:00+00	\N	mock	1.000
link-011	dc-001	pdu-003	dev-003	device	A	active	2024-01-01 00:00:00+00	\N	mock	1.000
link-012	dc-001	pdu-003	dev-004	device	A	active	2024-01-01 00:00:00+00	\N	mock	1.000
link-013	dc-001	pdu-004	dev-004	device	B	active	2024-01-01 00:00:00+00	\N	mock	1.000
link-101	dc-002	utility-101	ups-101	ups	A	active	2024-01-01 00:00:00+00	\N	mock	1.000
link-102	dc-002	utility-102	ups-102	ups	B	active	2024-01-01 00:00:00+00	\N	mock	1.000
link-103	dc-002	ups-101	pdu-101	pdu	A	active	2024-01-01 00:00:00+00	\N	mock	1.000
link-104	dc-002	ups-102	pdu-102	pdu	B	active	2024-01-01 00:00:00+00	\N	mock	1.000
link-105	dc-002	pdu-101	dev-009	device	A	active	2024-01-01 00:00:00+00	\N	mock	1.000
link-106	dc-002	pdu-102	dev-009	device	B	active	2024-01-01 00:00:00+00	\N	mock	1.000
link-107	dc-002	pdu-101	dev-010	device	A	active	2024-01-01 00:00:00+00	\N	mock	1.000
\.


--
-- Data for Name: power_node; Type: TABLE DATA; Schema: dcim_ontology_demo_20260623083835; Owner: -
--

COPY "__DCIM_TARGET_SCHEMA__".power_node (id, datacenter_id, node_type, name, status, load_w, capacity_w, source_system) FROM stdin;
utility-001	dc-001	utility	市电A路	online	\N	50000.00	mock
utility-002	dc-001	utility	市电B路	online	\N	50000.00	mock
ups-001	dc-001	ups	UPS-A-01	online	18000.00	30000.00	mock
ups-002	dc-001	ups	UPS-B-01	online	16500.00	30000.00	mock
pdu-001	dc-001	pdu	PDU-A-01	online	1800.00	3000.00	mock
pdu-002	dc-001	pdu	PDU-B-01	online	1650.00	3000.00	mock
pdu-003	dc-001	pdu	PDU-A-02	online	2400.00	5000.00	mock
pdu-004	dc-001	pdu	PDU-B-02	warning	4200.00	5000.00	mock
dev-001	dc-001	device	核心交换机-A1	online	300.00	\N	mock
dev-002	dc-001	device	接入交换机-A1-1	online	350.00	\N	mock
dev-003	dc-001	device	应用服务器-A1-1	online	150.00	\N	mock
dev-004	dc-001	device	应用服务器-A1-2	online	400.00	\N	mock
utility-101	dc-002	utility	市电A路	online	\N	40000.00	mock
utility-102	dc-002	utility	市电B路	warning	\N	40000.00	mock
ups-101	dc-002	ups	UPS-A-01	online	12000.00	25000.00	mock
ups-102	dc-002	ups	UPS-B-01	online	10500.00	25000.00	mock
pdu-101	dc-002	pdu	PDU-A-01	online	2000.00	4000.00	mock
pdu-102	dc-002	pdu	PDU-B-01	online	1800.00	4000.00	mock
dev-009	dc-002	device	接入交换机-B1-1	online	280.00	\N	mock
dev-010	dc-002	device	核心交换机-B1	warning	320.00	\N	mock
\.


--
-- Data for Name: pue_daily; Type: TABLE DATA; Schema: dcim_ontology_demo_20260623083835; Owner: -
--

COPY "__DCIM_TARGET_SCHEMA__".pue_daily (datacenter_id, metric_date, pue, it_power_kw, total_power_kw, cooling_power_kw, source_system) FROM stdin;
dc-001	2026-05-24	1.450	187.400	271.900	57.800	mock
dc-001	2026-05-25	1.460	159.900	232.700	51.300	mock
dc-001	2026-05-26	1.620	151.600	245.500	65.400	mock
dc-001	2026-05-27	1.560	199.200	310.700	83.800	mock
dc-001	2026-05-28	1.510	184.300	277.400	70.500	mock
dc-001	2026-05-29	1.520	168.500	256.900	66.800	mock
dc-001	2026-05-30	1.500	175.400	262.400	61.700	mock
dc-001	2026-05-31	1.640	150.900	247.100	70.900	mock
dc-001	2026-06-01	1.460	190.500	279.100	59.500	mock
dc-001	2026-06-02	1.520	175.700	267.900	64.200	mock
dc-001	2026-06-03	1.450	159.000	231.300	48.200	mock
dc-001	2026-06-04	1.540	187.700	288.400	79.900	mock
dc-001	2026-06-05	1.480	150.000	222.500	50.900	mock
dc-001	2026-06-06	1.590	163.300	259.600	71.500	mock
dc-001	2026-06-07	1.460	197.500	288.200	62.700	mock
dc-001	2026-06-08	1.500	184.100	275.300	68.500	mock
dc-001	2026-06-09	1.540	161.600	249.100	66.800	mock
dc-001	2026-06-10	1.520	154.600	235.100	59.000	mock
dc-001	2026-06-11	1.620	193.900	315.100	91.600	mock
dc-001	2026-06-12	1.550	172.700	268.300	74.500	mock
dc-001	2026-06-13	1.630	171.100	278.300	78.500	mock
dc-001	2026-06-14	1.430	177.000	252.400	54.200	mock
dc-001	2026-06-15	1.450	195.600	284.100	64.700	mock
dc-001	2026-06-16	1.560	195.200	304.700	86.500	mock
dc-001	2026-06-17	1.550	178.800	276.300	69.100	mock
dc-001	2026-06-18	1.540	189.800	292.600	79.700	mock
dc-001	2026-06-19	1.520	179.100	271.800	70.800	mock
dc-001	2026-06-20	1.490	158.500	236.600	51.800	mock
dc-001	2026-06-21	1.540	179.000	276.300	67.600	mock
dc-001	2026-06-22	1.510	157.900	238.800	51.300	mock
dc-001	2026-06-23	1.550	152.800	236.200	59.900	mock
dc-002	2026-05-24	1.580	180.700	286.100	78.100	mock
dc-002	2026-05-25	1.430	175.800	251.000	54.600	mock
dc-002	2026-05-26	1.590	157.100	249.600	71.600	mock
dc-002	2026-05-27	1.570	158.800	250.000	68.500	mock
dc-002	2026-05-28	1.630	165.800	271.000	75.500	mock
dc-002	2026-05-29	1.610	170.200	274.800	82.100	mock
dc-002	2026-05-30	1.500	184.500	276.500	63.200	mock
dc-002	2026-05-31	1.480	197.700	291.800	69.600	mock
dc-002	2026-06-01	1.520	151.500	230.600	55.700	mock
dc-002	2026-06-02	1.590	164.900	262.200	71.700	mock
dc-002	2026-06-03	1.600	156.600	251.100	73.900	mock
dc-002	2026-06-04	1.540	152.600	235.500	60.600	mock
dc-002	2026-06-05	1.510	171.500	259.500	63.600	mock
dc-002	2026-06-06	1.600	199.700	319.700	96.000	mock
dc-002	2026-06-07	1.450	178.800	258.400	56.300	mock
dc-002	2026-06-08	1.570	166.700	262.200	70.800	mock
dc-002	2026-06-09	1.570	175.600	276.200	72.200	mock
dc-002	2026-06-10	1.460	173.600	252.800	53.900	mock
dc-002	2026-06-11	1.520	181.200	276.300	69.400	mock
dc-002	2026-06-12	1.620	159.400	259.000	74.000	mock
dc-002	2026-06-13	1.480	198.900	293.900	66.800	mock
dc-002	2026-06-14	1.490	198.700	296.900	70.300	mock
dc-002	2026-06-15	1.430	193.800	278.000	61.500	mock
dc-002	2026-06-16	1.590	163.800	260.900	67.700	mock
dc-002	2026-06-17	1.590	198.800	316.600	97.700	mock
dc-002	2026-06-18	1.460	183.600	268.400	59.400	mock
dc-002	2026-06-19	1.590	187.900	299.600	87.400	mock
dc-002	2026-06-20	1.470	177.000	259.600	60.900	mock
dc-002	2026-06-21	1.600	195.900	313.000	94.200	mock
dc-002	2026-06-22	1.520	164.900	250.400	62.400	mock
dc-002	2026-06-23	1.560	153.300	239.300	57.800	mock
dc-003	2026-05-24	1.510	158.200	238.400	56.800	mock
dc-003	2026-05-25	1.630	199.700	325.100	98.700	mock
dc-003	2026-05-26	1.580	156.900	247.800	61.500	mock
dc-003	2026-05-27	1.530	170.500	261.200	62.200	mock
dc-003	2026-05-28	1.450	193.400	280.900	59.100	mock
dc-003	2026-05-29	1.590	159.900	254.600	65.800	mock
dc-003	2026-05-30	1.580	169.200	267.500	71.600	mock
dc-003	2026-05-31	1.520	190.600	289.200	71.500	mock
dc-003	2026-06-01	1.570	162.700	255.800	63.300	mock
dc-003	2026-06-02	1.490	177.700	265.500	60.200	mock
dc-003	2026-06-03	1.590	172.800	275.500	81.000	mock
dc-003	2026-06-04	1.520	188.200	286.800	75.700	mock
dc-003	2026-06-05	1.530	199.800	306.600	85.700	mock
dc-003	2026-06-06	1.560	185.800	289.100	78.300	mock
dc-003	2026-06-07	1.630	182.800	297.500	90.600	mock
dc-003	2026-06-08	1.630	172.600	281.500	85.700	mock
dc-003	2026-06-09	1.530	183.300	280.300	68.500	mock
dc-003	2026-06-10	1.620	173.500	281.200	85.200	mock
dc-003	2026-06-11	1.640	157.500	259.000	73.600	mock
dc-003	2026-06-12	1.630	172.300	280.400	84.000	mock
dc-003	2026-06-13	1.610	185.300	297.600	82.400	mock
dc-003	2026-06-14	1.500	181.500	272.800	62.600	mock
dc-003	2026-06-15	1.460	154.200	225.800	49.900	mock
dc-003	2026-06-16	1.590	195.500	311.500	92.800	mock
dc-003	2026-06-17	1.520	187.000	284.800	74.200	mock
dc-003	2026-06-18	1.480	180.900	268.600	58.600	mock
dc-003	2026-06-19	1.510	150.100	226.200	50.900	mock
dc-003	2026-06-20	1.590	169.300	269.700	78.100	mock
dc-003	2026-06-21	1.500	185.300	277.500	65.400	mock
dc-003	2026-06-22	1.510	199.000	300.200	76.600	mock
dc-003	2026-06-23	1.660	170.700	283.300	84.200	mock
dc-004	2026-05-24	1.530	159.300	244.300	57.700	mock
dc-004	2026-05-25	1.590	193.000	307.500	84.600	mock
dc-004	2026-05-26	1.540	191.300	294.200	73.000	mock
dc-004	2026-05-27	1.590	175.900	279.400	79.600	mock
dc-004	2026-05-28	1.590	179.900	286.100	76.600	mock
dc-004	2026-05-29	1.640	156.800	256.700	78.300	mock
dc-004	2026-05-30	1.480	192.500	284.500	65.000	mock
dc-004	2026-05-31	1.530	198.100	303.500	79.100	mock
dc-004	2026-06-01	1.620	152.200	246.900	66.000	mock
dc-004	2026-06-02	1.520	165.900	252.100	65.800	mock
dc-004	2026-06-03	1.500	164.700	247.200	53.200	mock
dc-004	2026-06-04	1.570	168.800	264.800	73.200	mock
dc-004	2026-06-05	1.610	162.600	261.400	74.900	mock
dc-004	2026-06-06	1.560	159.700	249.200	64.500	mock
dc-004	2026-06-07	1.470	196.500	288.300	69.100	mock
dc-004	2026-06-08	1.500	181.700	272.900	71.000	mock
dc-004	2026-06-09	1.640	155.200	255.100	71.300	mock
dc-004	2026-06-10	1.600	187.800	299.900	84.500	mock
dc-004	2026-06-11	1.590	168.000	267.800	71.500	mock
dc-004	2026-06-12	1.560	183.900	287.600	83.300	mock
dc-004	2026-06-13	1.450	170.900	248.500	52.500	mock
dc-004	2026-06-14	1.530	193.600	296.800	79.400	mock
dc-004	2026-06-15	1.520	183.000	278.000	65.600	mock
dc-004	2026-06-16	1.530	155.800	238.200	60.700	mock
dc-004	2026-06-17	1.510	175.800	265.400	68.500	mock
dc-004	2026-06-18	1.580	181.100	286.200	75.200	mock
dc-004	2026-06-19	1.500	167.900	251.100	60.000	mock
dc-004	2026-06-20	1.470	169.100	247.800	54.900	mock
dc-004	2026-06-21	1.460	174.000	253.800	56.900	mock
dc-004	2026-06-22	1.540	167.100	256.800	62.800	mock
dc-004	2026-06-23	1.580	194.500	307.600	90.700	mock
\.


--
-- Data for Name: rack_installation; Type: TABLE DATA; Schema: dcim_ontology_demo_20260623083835; Owner: -
--

COPY "__DCIM_TARGET_SCHEMA__".rack_installation (id, asset_type, device_id, pdu_id, cabinet_id, start_u, end_u, valid_from, valid_to, source_system, confidence) FROM stdin;
1	device	dev-001	\N	cab-bj-001	40	40	2023-02-20 08:00:00+00	\N	mock	1.000
2	device	dev-002	\N	cab-bj-001	38	38	2023-02-20 08:00:00+00	\N	mock	1.000
3	device	dev-003	\N	cab-bj-001	35	36	2023-03-15 08:00:00+00	\N	mock	1.000
4	device	dev-004	\N	cab-bj-001	33	34	2023-03-15 08:00:00+00	\N	mock	1.000
5	device	dev-005	\N	cab-bj-001	30	31	2023-04-05 08:00:00+00	\N	mock	1.000
6	device	dev-006	\N	cab-bj-002	40	41	2023-01-25 08:00:00+00	\N	mock	1.000
7	device	dev-007	\N	cab-bj-002	38	38	2023-02-05 08:00:00+00	\N	mock	1.000
8	device	dev-008	\N	cab-bj-003	35	38	2023-05-10 08:00:00+00	\N	mock	1.000
9	device	dev-009	\N	cab-sh-001	40	40	2023-07-10 08:00:00+00	\N	mock	1.000
10	device	dev-010	\N	cab-sh-001	38	38	2023-07-10 08:00:00+00	\N	mock	1.000
11	device	dev-011	\N	cab-sz-001	45	45	2023-04-10 08:00:00+00	\N	mock	1.000
12	device	dev-012	\N	cab-sz-001	42	43	2024-01-20 08:00:00+00	\N	mock	1.000
13	pdu	\N	pdu-001	cab-bj-001	1	2	2024-01-15 08:00:00+00	\N	mock	1.000
14	pdu	\N	pdu-002	cab-bj-001	3	4	2024-01-15 08:00:00+00	\N	mock	1.000
15	pdu	\N	pdu-003	cab-bj-002	1	2	2024-01-15 08:00:00+00	\N	mock	1.000
16	pdu	\N	pdu-004	cab-bj-002	3	4	2024-01-15 08:00:00+00	\N	mock	1.000
21	device	dev-f9f15364	\N	cab-bj-001	27	28	2026-06-30 03:37:10.25942+00	\N	database	1.000
22	device	dev-8d582d62	\N	cab-bj-001	15	16	2026-06-30 04:10:54.083139+00	2026-06-30 04:41:27.073068+00	database	1.000
23	device	dev-8d582d62	\N	cab-b9ad0d40	34	35	2026-06-30 04:41:27.303788+00	\N	database	1.000
24	device	dev-9635142f	\N	cab-bj-001	24	25	2026-07-03 03:19:00.377073+00	\N	database	1.000
\.


--
-- Data for Name: topology_snapshot; Type: TABLE DATA; Schema: dcim_ontology_demo_20260623083835; Owner: -
--

COPY "__DCIM_TARGET_SCHEMA__".topology_snapshot (id, datacenter_id, payload, captured_at) FROM stdin;
topology-dc-001	dc-001	{"edges": [{"type": "network", "source": "dev-001", "target": "dev-002"}, {"type": "network", "source": "dev-001", "target": "dev-006"}, {"type": "network", "source": "dev-006", "target": "dev-007"}, {"type": "network", "source": "dev-002", "target": "dev-003"}, {"type": "network", "source": "dev-002", "target": "dev-004"}, {"type": "network", "source": "dev-002", "target": "dev-005"}, {"type": "storage", "source": "dev-005", "target": "dev-008"}], "nodes": [{"x": 400, "y": 100, "id": "dev-001", "type": "switch", "label": "核心交换机-A1", "status": "online"}, {"x": 200, "y": 250, "id": "dev-002", "type": "switch", "label": "接入交换机-A1-1", "status": "online"}, {"x": 600, "y": 250, "id": "dev-006", "type": "firewall", "label": "边界防火墙-1", "status": "online"}, {"x": 600, "y": 400, "id": "dev-007", "type": "loadbalancer", "label": "负载均衡器-1", "status": "online"}, {"x": 100, "y": 400, "id": "dev-003", "type": "server", "label": "应用服务器-A1-1", "status": "online"}, {"x": 200, "y": 400, "id": "dev-004", "type": "server", "label": "应用服务器-A1-2", "status": "online"}, {"x": 300, "y": 400, "id": "dev-005", "type": "server", "label": "数据库服务器-A1-1", "status": "online"}, {"x": 300, "y": 550, "id": "dev-008", "type": "storage", "label": "核心存储-1", "status": "online"}], "datacenterId": "dc-001"}	2026-06-23 08:38:42.107162+00
topology-dc-002	dc-002	{"edges": [{"type": "network", "source": "dev-001", "target": "dev-002"}, {"type": "network", "source": "dev-001", "target": "dev-006"}, {"type": "network", "source": "dev-006", "target": "dev-007"}, {"type": "network", "source": "dev-002", "target": "dev-003"}, {"type": "network", "source": "dev-002", "target": "dev-004"}, {"type": "network", "source": "dev-002", "target": "dev-005"}, {"type": "storage", "source": "dev-005", "target": "dev-008"}], "nodes": [{"x": 400, "y": 100, "id": "dev-001", "type": "switch", "label": "核心交换机-A1", "status": "online"}, {"x": 200, "y": 250, "id": "dev-002", "type": "switch", "label": "接入交换机-A1-1", "status": "online"}, {"x": 600, "y": 250, "id": "dev-006", "type": "firewall", "label": "边界防火墙-1", "status": "online"}, {"x": 600, "y": 400, "id": "dev-007", "type": "loadbalancer", "label": "负载均衡器-1", "status": "online"}, {"x": 100, "y": 400, "id": "dev-003", "type": "server", "label": "应用服务器-A1-1", "status": "online"}, {"x": 200, "y": 400, "id": "dev-004", "type": "server", "label": "应用服务器-A1-2", "status": "online"}, {"x": 300, "y": 400, "id": "dev-005", "type": "server", "label": "数据库服务器-A1-1", "status": "online"}, {"x": 300, "y": 550, "id": "dev-008", "type": "storage", "label": "核心存储-1", "status": "online"}], "datacenterId": "dc-002"}	2026-06-23 08:38:42.107162+00
topology-dc-003	dc-003	{"edges": [{"type": "network", "source": "dev-001", "target": "dev-002"}, {"type": "network", "source": "dev-001", "target": "dev-006"}, {"type": "network", "source": "dev-006", "target": "dev-007"}, {"type": "network", "source": "dev-002", "target": "dev-003"}, {"type": "network", "source": "dev-002", "target": "dev-004"}, {"type": "network", "source": "dev-002", "target": "dev-005"}, {"type": "storage", "source": "dev-005", "target": "dev-008"}], "nodes": [{"x": 400, "y": 100, "id": "dev-001", "type": "switch", "label": "核心交换机-A1", "status": "online"}, {"x": 200, "y": 250, "id": "dev-002", "type": "switch", "label": "接入交换机-A1-1", "status": "online"}, {"x": 600, "y": 250, "id": "dev-006", "type": "firewall", "label": "边界防火墙-1", "status": "online"}, {"x": 600, "y": 400, "id": "dev-007", "type": "loadbalancer", "label": "负载均衡器-1", "status": "online"}, {"x": 100, "y": 400, "id": "dev-003", "type": "server", "label": "应用服务器-A1-1", "status": "online"}, {"x": 200, "y": 400, "id": "dev-004", "type": "server", "label": "应用服务器-A1-2", "status": "online"}, {"x": 300, "y": 400, "id": "dev-005", "type": "server", "label": "数据库服务器-A1-1", "status": "online"}, {"x": 300, "y": 550, "id": "dev-008", "type": "storage", "label": "核心存储-1", "status": "online"}], "datacenterId": "dc-003"}	2026-06-23 08:38:42.107162+00
topology-dc-004	dc-004	{"edges": [{"type": "network", "source": "dev-001", "target": "dev-002"}, {"type": "network", "source": "dev-001", "target": "dev-006"}, {"type": "network", "source": "dev-006", "target": "dev-007"}, {"type": "network", "source": "dev-002", "target": "dev-003"}, {"type": "network", "source": "dev-002", "target": "dev-004"}, {"type": "network", "source": "dev-002", "target": "dev-005"}, {"type": "storage", "source": "dev-005", "target": "dev-008"}], "nodes": [{"x": 400, "y": 100, "id": "dev-001", "type": "switch", "label": "核心交换机-A1", "status": "online"}, {"x": 200, "y": 250, "id": "dev-002", "type": "switch", "label": "接入交换机-A1-1", "status": "online"}, {"x": 600, "y": 250, "id": "dev-006", "type": "firewall", "label": "边界防火墙-1", "status": "online"}, {"x": 600, "y": 400, "id": "dev-007", "type": "loadbalancer", "label": "负载均衡器-1", "status": "online"}, {"x": 100, "y": 400, "id": "dev-003", "type": "server", "label": "应用服务器-A1-1", "status": "online"}, {"x": 200, "y": 400, "id": "dev-004", "type": "server", "label": "应用服务器-A1-2", "status": "online"}, {"x": 300, "y": 400, "id": "dev-005", "type": "server", "label": "数据库服务器-A1-1", "status": "online"}, {"x": 300, "y": 550, "id": "dev-008", "type": "storage", "label": "核心存储-1", "status": "online"}], "datacenterId": "dc-004"}	2026-06-23 08:38:42.107162+00
\.


--
-- Name: rack_installation_id_seq; Type: SEQUENCE SET; Schema: dcim_ontology_demo_20260623083835; Owner: -
--

SELECT pg_catalog.setval('"__DCIM_TARGET_SCHEMA__".rack_installation_id_seq', 24, true);


--
-- Name: alert_event alert_event_pkey; Type: CONSTRAINT; Schema: dcim_ontology_demo_20260623083835; Owner: -
--

ALTER TABLE ONLY "__DCIM_TARGET_SCHEMA__".alert_event
    ADD CONSTRAINT alert_event_pkey PRIMARY KEY (id);


--
-- Name: alert_rule alert_rule_pkey; Type: CONSTRAINT; Schema: dcim_ontology_demo_20260623083835; Owner: -
--

ALTER TABLE ONLY "__DCIM_TARGET_SCHEMA__".alert_rule
    ADD CONSTRAINT alert_rule_pkey PRIMARY KEY (id);


--
-- Name: api_mock_response api_mock_response_pkey; Type: CONSTRAINT; Schema: dcim_ontology_demo_20260623083835; Owner: -
--

ALTER TABLE ONLY "__DCIM_TARGET_SCHEMA__".api_mock_response
    ADD CONSTRAINT api_mock_response_pkey PRIMARY KEY (route_key);


--
-- Name: cabinet cabinet_datacenter_id_code_key; Type: CONSTRAINT; Schema: dcim_ontology_demo_20260623083835; Owner: -
--

ALTER TABLE ONLY "__DCIM_TARGET_SCHEMA__".cabinet
    ADD CONSTRAINT cabinet_datacenter_id_code_key UNIQUE (datacenter_id, code);


--
-- Name: cabinet cabinet_datacenter_id_row_no_column_no_key; Type: CONSTRAINT; Schema: dcim_ontology_demo_20260623083835; Owner: -
--

ALTER TABLE ONLY "__DCIM_TARGET_SCHEMA__".cabinet
    ADD CONSTRAINT cabinet_datacenter_id_row_no_column_no_key UNIQUE (datacenter_id, row_no, column_no);


--
-- Name: cabinet cabinet_pkey; Type: CONSTRAINT; Schema: dcim_ontology_demo_20260623083835; Owner: -
--

ALTER TABLE ONLY "__DCIM_TARGET_SCHEMA__".cabinet
    ADD CONSTRAINT cabinet_pkey PRIMARY KEY (id);


--
-- Name: cabinet_telemetry_source cabinet_telemetry_source_pkey; Type: CONSTRAINT; Schema: dcim_ontology_demo_20260623083835; Owner: -
--

ALTER TABLE ONLY "__DCIM_TARGET_SCHEMA__".cabinet_telemetry_source
    ADD CONSTRAINT cabinet_telemetry_source_pkey PRIMARY KEY (cabinet_id);


--
-- Name: cabinet_telemetry_source cabinet_telemetry_source_source_id_key; Type: CONSTRAINT; Schema: dcim_ontology_demo_20260623083835; Owner: -
--

ALTER TABLE ONLY "__DCIM_TARGET_SCHEMA__".cabinet_telemetry_source
    ADD CONSTRAINT cabinet_telemetry_source_source_id_key UNIQUE (source_id);


--
-- Name: cable_connection cable_connection_cable_number_key; Type: CONSTRAINT; Schema: dcim_ontology_demo_20260623083835; Owner: -
--

ALTER TABLE ONLY "__DCIM_TARGET_SCHEMA__".cable_connection
    ADD CONSTRAINT cable_connection_cable_number_key UNIQUE (cable_number);


--
-- Name: cable_connection cable_connection_pkey; Type: CONSTRAINT; Schema: dcim_ontology_demo_20260623083835; Owner: -
--

ALTER TABLE ONLY "__DCIM_TARGET_SCHEMA__".cable_connection
    ADD CONSTRAINT cable_connection_pkey PRIMARY KEY (id);


--
-- Name: dashboard_snapshot dashboard_snapshot_pkey; Type: CONSTRAINT; Schema: dcim_ontology_demo_20260623083835; Owner: -
--

ALTER TABLE ONLY "__DCIM_TARGET_SCHEMA__".dashboard_snapshot
    ADD CONSTRAINT dashboard_snapshot_pkey PRIMARY KEY (id);


--
-- Name: datacenter datacenter_code_key; Type: CONSTRAINT; Schema: dcim_ontology_demo_20260623083835; Owner: -
--

ALTER TABLE ONLY "__DCIM_TARGET_SCHEMA__".datacenter
    ADD CONSTRAINT datacenter_code_key UNIQUE (code);


--
-- Name: datacenter datacenter_pkey; Type: CONSTRAINT; Schema: dcim_ontology_demo_20260623083835; Owner: -
--

ALTER TABLE ONLY "__DCIM_TARGET_SCHEMA__".datacenter
    ADD CONSTRAINT datacenter_pkey PRIMARY KEY (id);


--
-- Name: device device_asset_code_key; Type: CONSTRAINT; Schema: dcim_ontology_demo_20260623083835; Owner: -
--

ALTER TABLE ONLY "__DCIM_TARGET_SCHEMA__".device
    ADD CONSTRAINT device_asset_code_key UNIQUE (asset_code);


--
-- Name: device device_pkey; Type: CONSTRAINT; Schema: dcim_ontology_demo_20260623083835; Owner: -
--

ALTER TABLE ONLY "__DCIM_TARGET_SCHEMA__".device
    ADD CONSTRAINT device_pkey PRIMARY KEY (id);


--
-- Name: device_template device_template_pkey; Type: CONSTRAINT; Schema: dcim_ontology_demo_20260623083835; Owner: -
--

ALTER TABLE ONLY "__DCIM_TARGET_SCHEMA__".device_template
    ADD CONSTRAINT device_template_pkey PRIMARY KEY (id);


--
-- Name: layout_cabinet_position layout_cabinet_position_pkey; Type: CONSTRAINT; Schema: dcim_ontology_demo_20260623083835; Owner: -
--

ALTER TABLE ONLY "__DCIM_TARGET_SCHEMA__".layout_cabinet_position
    ADD CONSTRAINT layout_cabinet_position_pkey PRIMARY KEY (datacenter_id, cabinet_id);


--
-- Name: layout_facility layout_facility_pkey; Type: CONSTRAINT; Schema: dcim_ontology_demo_20260623083835; Owner: -
--

ALTER TABLE ONLY "__DCIM_TARGET_SCHEMA__".layout_facility
    ADD CONSTRAINT layout_facility_pkey PRIMARY KEY (id);


--
-- Name: layout_snapshot layout_snapshot_pkey; Type: CONSTRAINT; Schema: dcim_ontology_demo_20260623083835; Owner: -
--

ALTER TABLE ONLY "__DCIM_TARGET_SCHEMA__".layout_snapshot
    ADD CONSTRAINT layout_snapshot_pkey PRIMARY KEY (datacenter_id);


--
-- Name: layout_zone layout_zone_pkey; Type: CONSTRAINT; Schema: dcim_ontology_demo_20260623083835; Owner: -
--

ALTER TABLE ONLY "__DCIM_TARGET_SCHEMA__".layout_zone
    ADD CONSTRAINT layout_zone_pkey PRIMARY KEY (id);


--
-- Name: managed_user managed_user_email_key; Type: CONSTRAINT; Schema: dcim_ontology_demo_20260623083835; Owner: -
--

ALTER TABLE ONLY "__DCIM_TARGET_SCHEMA__".managed_user
    ADD CONSTRAINT managed_user_email_key UNIQUE (email);


--
-- Name: managed_user managed_user_pkey; Type: CONSTRAINT; Schema: dcim_ontology_demo_20260623083835; Owner: -
--

ALTER TABLE ONLY "__DCIM_TARGET_SCHEMA__".managed_user
    ADD CONSTRAINT managed_user_pkey PRIMARY KEY (id);


--
-- Name: managed_user managed_user_username_key; Type: CONSTRAINT; Schema: dcim_ontology_demo_20260623083835; Owner: -
--

ALTER TABLE ONLY "__DCIM_TARGET_SCHEMA__".managed_user
    ADD CONSTRAINT managed_user_username_key UNIQUE (username);


--
-- Name: mock_raw_payload mock_raw_payload_pkey; Type: CONSTRAINT; Schema: dcim_ontology_demo_20260623083835; Owner: -
--

ALTER TABLE ONLY "__DCIM_TARGET_SCHEMA__".mock_raw_payload
    ADD CONSTRAINT mock_raw_payload_pkey PRIMARY KEY (id);


--
-- Name: observation observation_pkey; Type: CONSTRAINT; Schema: dcim_ontology_demo_20260623083835; Owner: -
--

ALTER TABLE ONLY "__DCIM_TARGET_SCHEMA__".observation
    ADD CONSTRAINT observation_pkey PRIMARY KEY (id);


--
-- Name: ontology_individual ontology_individual_pkey; Type: CONSTRAINT; Schema: dcim_ontology_demo_20260623083835; Owner: -
--

ALTER TABLE ONLY "__DCIM_TARGET_SCHEMA__".ontology_individual
    ADD CONSTRAINT ontology_individual_pkey PRIMARY KEY (id);


--
-- Name: ontology_individual ontology_individual_source_table_source_id_ontology_class_key; Type: CONSTRAINT; Schema: dcim_ontology_demo_20260623083835; Owner: -
--

ALTER TABLE ONLY "__DCIM_TARGET_SCHEMA__".ontology_individual
    ADD CONSTRAINT ontology_individual_source_table_source_id_ontology_class_key UNIQUE (source_table, source_id, ontology_class);


--
-- Name: ontology_relationship ontology_relationship_pkey; Type: CONSTRAINT; Schema: dcim_ontology_demo_20260623083835; Owner: -
--

ALTER TABLE ONLY "__DCIM_TARGET_SCHEMA__".ontology_relationship
    ADD CONSTRAINT ontology_relationship_pkey PRIMARY KEY (id);


--
-- Name: operation_record operation_record_pkey; Type: CONSTRAINT; Schema: dcim_ontology_demo_20260623083835; Owner: -
--

ALTER TABLE ONLY "__DCIM_TARGET_SCHEMA__".operation_record
    ADD CONSTRAINT operation_record_pkey PRIMARY KEY (id);


--
-- Name: pdu pdu_asset_code_key; Type: CONSTRAINT; Schema: dcim_ontology_demo_20260623083835; Owner: -
--

ALTER TABLE ONLY "__DCIM_TARGET_SCHEMA__".pdu
    ADD CONSTRAINT pdu_asset_code_key UNIQUE (asset_code);


--
-- Name: pdu pdu_pkey; Type: CONSTRAINT; Schema: dcim_ontology_demo_20260623083835; Owner: -
--

ALTER TABLE ONLY "__DCIM_TARGET_SCHEMA__".pdu
    ADD CONSTRAINT pdu_pkey PRIMARY KEY (id);


--
-- Name: port port_device_id_port_number_key; Type: CONSTRAINT; Schema: dcim_ontology_demo_20260623083835; Owner: -
--

ALTER TABLE ONLY "__DCIM_TARGET_SCHEMA__".port
    ADD CONSTRAINT port_device_id_port_number_key UNIQUE (device_id, port_number);


--
-- Name: port_group_template port_group_template_pkey; Type: CONSTRAINT; Schema: dcim_ontology_demo_20260623083835; Owner: -
--

ALTER TABLE ONLY "__DCIM_TARGET_SCHEMA__".port_group_template
    ADD CONSTRAINT port_group_template_pkey PRIMARY KEY (template_id, id);


--
-- Name: port port_pkey; Type: CONSTRAINT; Schema: dcim_ontology_demo_20260623083835; Owner: -
--

ALTER TABLE ONLY "__DCIM_TARGET_SCHEMA__".port
    ADD CONSTRAINT port_pkey PRIMARY KEY (id);


--
-- Name: power_connection power_connection_pkey; Type: CONSTRAINT; Schema: dcim_ontology_demo_20260623083835; Owner: -
--

ALTER TABLE ONLY "__DCIM_TARGET_SCHEMA__".power_connection
    ADD CONSTRAINT power_connection_pkey PRIMARY KEY (id);


--
-- Name: power_node power_node_pkey; Type: CONSTRAINT; Schema: dcim_ontology_demo_20260623083835; Owner: -
--

ALTER TABLE ONLY "__DCIM_TARGET_SCHEMA__".power_node
    ADD CONSTRAINT power_node_pkey PRIMARY KEY (id);


--
-- Name: pue_daily pue_daily_pkey; Type: CONSTRAINT; Schema: dcim_ontology_demo_20260623083835; Owner: -
--

ALTER TABLE ONLY "__DCIM_TARGET_SCHEMA__".pue_daily
    ADD CONSTRAINT pue_daily_pkey PRIMARY KEY (datacenter_id, metric_date);


--
-- Name: rack_installation rack_installation_pkey; Type: CONSTRAINT; Schema: dcim_ontology_demo_20260623083835; Owner: -
--

ALTER TABLE ONLY "__DCIM_TARGET_SCHEMA__".rack_installation
    ADD CONSTRAINT rack_installation_pkey PRIMARY KEY (id);


--
-- Name: topology_snapshot topology_snapshot_pkey; Type: CONSTRAINT; Schema: dcim_ontology_demo_20260623083835; Owner: -
--

ALTER TABLE ONLY "__DCIM_TARGET_SCHEMA__".topology_snapshot
    ADD CONSTRAINT topology_snapshot_pkey PRIMARY KEY (id);


--
-- Name: idx_alert_event_scope; Type: INDEX; Schema: dcim_ontology_demo_20260623083835; Owner: -
--

CREATE INDEX idx_alert_event_scope ON "__DCIM_TARGET_SCHEMA__".alert_event USING btree (datacenter_id, cabinet_id, device_id, created_at DESC);


--
-- Name: idx_cabinet_datacenter; Type: INDEX; Schema: dcim_ontology_demo_20260623083835; Owner: -
--

CREATE INDEX idx_cabinet_datacenter ON "__DCIM_TARGET_SCHEMA__".cabinet USING btree (datacenter_id);


--
-- Name: idx_cable_connection_source_port; Type: INDEX; Schema: dcim_ontology_demo_20260623083835; Owner: -
--

CREATE INDEX idx_cable_connection_source_port ON "__DCIM_TARGET_SCHEMA__".cable_connection USING btree (source_port_id);


--
-- Name: idx_cable_connection_target_port; Type: INDEX; Schema: dcim_ontology_demo_20260623083835; Owner: -
--

CREATE INDEX idx_cable_connection_target_port ON "__DCIM_TARGET_SCHEMA__".cable_connection USING btree (target_port_id);


--
-- Name: idx_device_template; Type: INDEX; Schema: dcim_ontology_demo_20260623083835; Owner: -
--

CREATE INDEX idx_device_template ON "__DCIM_TARGET_SCHEMA__".device USING btree (template_id);


--
-- Name: idx_observation_target_metric_time; Type: INDEX; Schema: dcim_ontology_demo_20260623083835; Owner: -
--

CREATE INDEX idx_observation_target_metric_time ON "__DCIM_TARGET_SCHEMA__".observation USING btree (target_type, target_id, metric, observed_at DESC);


--
-- Name: idx_ontology_individual_class; Type: INDEX; Schema: dcim_ontology_demo_20260623083835; Owner: -
--

CREATE INDEX idx_ontology_individual_class ON "__DCIM_TARGET_SCHEMA__".ontology_individual USING btree (ontology_class);


--
-- Name: idx_ontology_relationship_type; Type: INDEX; Schema: dcim_ontology_demo_20260623083835; Owner: -
--

CREATE INDEX idx_ontology_relationship_type ON "__DCIM_TARGET_SCHEMA__".ontology_relationship USING btree (relationship_type);


--
-- Name: idx_port_device; Type: INDEX; Schema: dcim_ontology_demo_20260623083835; Owner: -
--

CREATE INDEX idx_port_device ON "__DCIM_TARGET_SCHEMA__".port USING btree (device_id);


--
-- Name: idx_power_connection_source; Type: INDEX; Schema: dcim_ontology_demo_20260623083835; Owner: -
--

CREATE INDEX idx_power_connection_source ON "__DCIM_TARGET_SCHEMA__".power_connection USING btree (source_node_id);


--
-- Name: idx_power_connection_target; Type: INDEX; Schema: dcim_ontology_demo_20260623083835; Owner: -
--

CREATE INDEX idx_power_connection_target ON "__DCIM_TARGET_SCHEMA__".power_connection USING btree (target_node_id);


--
-- Name: idx_rack_installation_cabinet; Type: INDEX; Schema: dcim_ontology_demo_20260623083835; Owner: -
--

CREATE INDEX idx_rack_installation_cabinet ON "__DCIM_TARGET_SCHEMA__".rack_installation USING btree (cabinet_id);


--
-- Name: cable_connection cable_connection_port_occupancy; Type: TRIGGER; Schema: dcim_ontology_demo_20260623083835; Owner: -
--

CREATE TRIGGER cable_connection_port_occupancy BEFORE INSERT OR UPDATE OF source_port_id, target_port_id ON "__DCIM_TARGET_SCHEMA__".cable_connection FOR EACH ROW EXECUTE FUNCTION "__DCIM_TARGET_SCHEMA__".enforce_cable_connection_port_occupancy();


--
-- Name: alert_event alert_event_cabinet_id_fkey; Type: FK CONSTRAINT; Schema: dcim_ontology_demo_20260623083835; Owner: -
--

ALTER TABLE ONLY "__DCIM_TARGET_SCHEMA__".alert_event
    ADD CONSTRAINT alert_event_cabinet_id_fkey FOREIGN KEY (cabinet_id) REFERENCES "__DCIM_TARGET_SCHEMA__".cabinet(id);


--
-- Name: alert_event alert_event_datacenter_id_fkey; Type: FK CONSTRAINT; Schema: dcim_ontology_demo_20260623083835; Owner: -
--

ALTER TABLE ONLY "__DCIM_TARGET_SCHEMA__".alert_event
    ADD CONSTRAINT alert_event_datacenter_id_fkey FOREIGN KEY (datacenter_id) REFERENCES "__DCIM_TARGET_SCHEMA__".datacenter(id);


--
-- Name: alert_event alert_event_device_id_fkey; Type: FK CONSTRAINT; Schema: dcim_ontology_demo_20260623083835; Owner: -
--

ALTER TABLE ONLY "__DCIM_TARGET_SCHEMA__".alert_event
    ADD CONSTRAINT alert_event_device_id_fkey FOREIGN KEY (device_id) REFERENCES "__DCIM_TARGET_SCHEMA__".device(id);


--
-- Name: alert_event alert_event_rule_id_fkey; Type: FK CONSTRAINT; Schema: dcim_ontology_demo_20260623083835; Owner: -
--

ALTER TABLE ONLY "__DCIM_TARGET_SCHEMA__".alert_event
    ADD CONSTRAINT alert_event_rule_id_fkey FOREIGN KEY (rule_id) REFERENCES "__DCIM_TARGET_SCHEMA__".alert_rule(id);


--
-- Name: cabinet cabinet_datacenter_id_fkey; Type: FK CONSTRAINT; Schema: dcim_ontology_demo_20260623083835; Owner: -
--

ALTER TABLE ONLY "__DCIM_TARGET_SCHEMA__".cabinet
    ADD CONSTRAINT cabinet_datacenter_id_fkey FOREIGN KEY (datacenter_id) REFERENCES "__DCIM_TARGET_SCHEMA__".datacenter(id);


--
-- Name: cabinet_telemetry_source cabinet_telemetry_source_cabinet_id_fkey; Type: FK CONSTRAINT; Schema: dcim_ontology_demo_20260623083835; Owner: -
--

ALTER TABLE ONLY "__DCIM_TARGET_SCHEMA__".cabinet_telemetry_source
    ADD CONSTRAINT cabinet_telemetry_source_cabinet_id_fkey FOREIGN KEY (cabinet_id) REFERENCES "__DCIM_TARGET_SCHEMA__".cabinet(id) ON DELETE CASCADE;


--
-- Name: cable_connection cable_connection_source_device_id_fkey; Type: FK CONSTRAINT; Schema: dcim_ontology_demo_20260623083835; Owner: -
--

ALTER TABLE ONLY "__DCIM_TARGET_SCHEMA__".cable_connection
    ADD CONSTRAINT cable_connection_source_device_id_fkey FOREIGN KEY (source_device_id) REFERENCES "__DCIM_TARGET_SCHEMA__".device(id);


--
-- Name: cable_connection cable_connection_source_port_id_fkey; Type: FK CONSTRAINT; Schema: dcim_ontology_demo_20260623083835; Owner: -
--

ALTER TABLE ONLY "__DCIM_TARGET_SCHEMA__".cable_connection
    ADD CONSTRAINT cable_connection_source_port_id_fkey FOREIGN KEY (source_port_id) REFERENCES "__DCIM_TARGET_SCHEMA__".port(id);


--
-- Name: cable_connection cable_connection_target_device_id_fkey; Type: FK CONSTRAINT; Schema: dcim_ontology_demo_20260623083835; Owner: -
--

ALTER TABLE ONLY "__DCIM_TARGET_SCHEMA__".cable_connection
    ADD CONSTRAINT cable_connection_target_device_id_fkey FOREIGN KEY (target_device_id) REFERENCES "__DCIM_TARGET_SCHEMA__".device(id);


--
-- Name: cable_connection cable_connection_target_port_id_fkey; Type: FK CONSTRAINT; Schema: dcim_ontology_demo_20260623083835; Owner: -
--

ALTER TABLE ONLY "__DCIM_TARGET_SCHEMA__".cable_connection
    ADD CONSTRAINT cable_connection_target_port_id_fkey FOREIGN KEY (target_port_id) REFERENCES "__DCIM_TARGET_SCHEMA__".port(id);


--
-- Name: device device_template_id_fkey; Type: FK CONSTRAINT; Schema: dcim_ontology_demo_20260623083835; Owner: -
--

ALTER TABLE ONLY "__DCIM_TARGET_SCHEMA__".device
    ADD CONSTRAINT device_template_id_fkey FOREIGN KEY (template_id) REFERENCES "__DCIM_TARGET_SCHEMA__".device_template(id);


--
-- Name: layout_cabinet_position layout_cabinet_position_cabinet_id_fkey; Type: FK CONSTRAINT; Schema: dcim_ontology_demo_20260623083835; Owner: -
--

ALTER TABLE ONLY "__DCIM_TARGET_SCHEMA__".layout_cabinet_position
    ADD CONSTRAINT layout_cabinet_position_cabinet_id_fkey FOREIGN KEY (cabinet_id) REFERENCES "__DCIM_TARGET_SCHEMA__".cabinet(id);


--
-- Name: layout_cabinet_position layout_cabinet_position_datacenter_id_fkey; Type: FK CONSTRAINT; Schema: dcim_ontology_demo_20260623083835; Owner: -
--

ALTER TABLE ONLY "__DCIM_TARGET_SCHEMA__".layout_cabinet_position
    ADD CONSTRAINT layout_cabinet_position_datacenter_id_fkey FOREIGN KEY (datacenter_id) REFERENCES "__DCIM_TARGET_SCHEMA__".datacenter(id);


--
-- Name: layout_facility layout_facility_datacenter_id_fkey; Type: FK CONSTRAINT; Schema: dcim_ontology_demo_20260623083835; Owner: -
--

ALTER TABLE ONLY "__DCIM_TARGET_SCHEMA__".layout_facility
    ADD CONSTRAINT layout_facility_datacenter_id_fkey FOREIGN KEY (datacenter_id) REFERENCES "__DCIM_TARGET_SCHEMA__".datacenter(id);


--
-- Name: layout_snapshot layout_snapshot_datacenter_id_fkey; Type: FK CONSTRAINT; Schema: dcim_ontology_demo_20260623083835; Owner: -
--

ALTER TABLE ONLY "__DCIM_TARGET_SCHEMA__".layout_snapshot
    ADD CONSTRAINT layout_snapshot_datacenter_id_fkey FOREIGN KEY (datacenter_id) REFERENCES "__DCIM_TARGET_SCHEMA__".datacenter(id);


--
-- Name: layout_zone layout_zone_datacenter_id_fkey; Type: FK CONSTRAINT; Schema: dcim_ontology_demo_20260623083835; Owner: -
--

ALTER TABLE ONLY "__DCIM_TARGET_SCHEMA__".layout_zone
    ADD CONSTRAINT layout_zone_datacenter_id_fkey FOREIGN KEY (datacenter_id) REFERENCES "__DCIM_TARGET_SCHEMA__".datacenter(id);


--
-- Name: ontology_relationship ontology_relationship_source_individual_id_fkey; Type: FK CONSTRAINT; Schema: dcim_ontology_demo_20260623083835; Owner: -
--

ALTER TABLE ONLY "__DCIM_TARGET_SCHEMA__".ontology_relationship
    ADD CONSTRAINT ontology_relationship_source_individual_id_fkey FOREIGN KEY (source_individual_id) REFERENCES "__DCIM_TARGET_SCHEMA__".ontology_individual(id);


--
-- Name: ontology_relationship ontology_relationship_target_individual_id_fkey; Type: FK CONSTRAINT; Schema: dcim_ontology_demo_20260623083835; Owner: -
--

ALTER TABLE ONLY "__DCIM_TARGET_SCHEMA__".ontology_relationship
    ADD CONSTRAINT ontology_relationship_target_individual_id_fkey FOREIGN KEY (target_individual_id) REFERENCES "__DCIM_TARGET_SCHEMA__".ontology_individual(id);


--
-- Name: pdu pdu_cabinet_id_fkey; Type: FK CONSTRAINT; Schema: dcim_ontology_demo_20260623083835; Owner: -
--

ALTER TABLE ONLY "__DCIM_TARGET_SCHEMA__".pdu
    ADD CONSTRAINT pdu_cabinet_id_fkey FOREIGN KEY (cabinet_id) REFERENCES "__DCIM_TARGET_SCHEMA__".cabinet(id);


--
-- Name: pdu pdu_template_id_fkey; Type: FK CONSTRAINT; Schema: dcim_ontology_demo_20260623083835; Owner: -
--

ALTER TABLE ONLY "__DCIM_TARGET_SCHEMA__".pdu
    ADD CONSTRAINT pdu_template_id_fkey FOREIGN KEY (template_id) REFERENCES "__DCIM_TARGET_SCHEMA__".device_template(id);


--
-- Name: port port_device_id_fkey; Type: FK CONSTRAINT; Schema: dcim_ontology_demo_20260623083835; Owner: -
--

ALTER TABLE ONLY "__DCIM_TARGET_SCHEMA__".port
    ADD CONSTRAINT port_device_id_fkey FOREIGN KEY (device_id) REFERENCES "__DCIM_TARGET_SCHEMA__".device(id);


--
-- Name: port_group_template port_group_template_template_id_fkey; Type: FK CONSTRAINT; Schema: dcim_ontology_demo_20260623083835; Owner: -
--

ALTER TABLE ONLY "__DCIM_TARGET_SCHEMA__".port_group_template
    ADD CONSTRAINT port_group_template_template_id_fkey FOREIGN KEY (template_id) REFERENCES "__DCIM_TARGET_SCHEMA__".device_template(id);


--
-- Name: power_connection power_connection_datacenter_id_fkey; Type: FK CONSTRAINT; Schema: dcim_ontology_demo_20260623083835; Owner: -
--

ALTER TABLE ONLY "__DCIM_TARGET_SCHEMA__".power_connection
    ADD CONSTRAINT power_connection_datacenter_id_fkey FOREIGN KEY (datacenter_id) REFERENCES "__DCIM_TARGET_SCHEMA__".datacenter(id);


--
-- Name: power_connection power_connection_source_node_id_fkey; Type: FK CONSTRAINT; Schema: dcim_ontology_demo_20260623083835; Owner: -
--

ALTER TABLE ONLY "__DCIM_TARGET_SCHEMA__".power_connection
    ADD CONSTRAINT power_connection_source_node_id_fkey FOREIGN KEY (source_node_id) REFERENCES "__DCIM_TARGET_SCHEMA__".power_node(id);


--
-- Name: power_connection power_connection_target_node_id_fkey; Type: FK CONSTRAINT; Schema: dcim_ontology_demo_20260623083835; Owner: -
--

ALTER TABLE ONLY "__DCIM_TARGET_SCHEMA__".power_connection
    ADD CONSTRAINT power_connection_target_node_id_fkey FOREIGN KEY (target_node_id) REFERENCES "__DCIM_TARGET_SCHEMA__".power_node(id);


--
-- Name: power_node power_node_datacenter_id_fkey; Type: FK CONSTRAINT; Schema: dcim_ontology_demo_20260623083835; Owner: -
--

ALTER TABLE ONLY "__DCIM_TARGET_SCHEMA__".power_node
    ADD CONSTRAINT power_node_datacenter_id_fkey FOREIGN KEY (datacenter_id) REFERENCES "__DCIM_TARGET_SCHEMA__".datacenter(id);


--
-- Name: pue_daily pue_daily_datacenter_id_fkey; Type: FK CONSTRAINT; Schema: dcim_ontology_demo_20260623083835; Owner: -
--

ALTER TABLE ONLY "__DCIM_TARGET_SCHEMA__".pue_daily
    ADD CONSTRAINT pue_daily_datacenter_id_fkey FOREIGN KEY (datacenter_id) REFERENCES "__DCIM_TARGET_SCHEMA__".datacenter(id);


--
-- Name: rack_installation rack_installation_cabinet_id_fkey; Type: FK CONSTRAINT; Schema: dcim_ontology_demo_20260623083835; Owner: -
--

ALTER TABLE ONLY "__DCIM_TARGET_SCHEMA__".rack_installation
    ADD CONSTRAINT rack_installation_cabinet_id_fkey FOREIGN KEY (cabinet_id) REFERENCES "__DCIM_TARGET_SCHEMA__".cabinet(id);


--
-- Name: rack_installation rack_installation_device_id_fkey; Type: FK CONSTRAINT; Schema: dcim_ontology_demo_20260623083835; Owner: -
--

ALTER TABLE ONLY "__DCIM_TARGET_SCHEMA__".rack_installation
    ADD CONSTRAINT rack_installation_device_id_fkey FOREIGN KEY (device_id) REFERENCES "__DCIM_TARGET_SCHEMA__".device(id);


--
-- Name: rack_installation rack_installation_pdu_id_fkey; Type: FK CONSTRAINT; Schema: dcim_ontology_demo_20260623083835; Owner: -
--

ALTER TABLE ONLY "__DCIM_TARGET_SCHEMA__".rack_installation
    ADD CONSTRAINT rack_installation_pdu_id_fkey FOREIGN KEY (pdu_id) REFERENCES "__DCIM_TARGET_SCHEMA__".pdu(id);


--
-- Name: topology_snapshot topology_snapshot_datacenter_id_fkey; Type: FK CONSTRAINT; Schema: dcim_ontology_demo_20260623083835; Owner: -
--

ALTER TABLE ONLY "__DCIM_TARGET_SCHEMA__".topology_snapshot
    ADD CONSTRAINT topology_snapshot_datacenter_id_fkey FOREIGN KEY (datacenter_id) REFERENCES "__DCIM_TARGET_SCHEMA__".datacenter(id);


--
-- PostgreSQL database dump complete
--

\unrestrict NIBP2xPcOawd2e9wWzdstLSYU40lX6WzsItu8UdtKs29ZNAsnglKZMP2pBdekd1
