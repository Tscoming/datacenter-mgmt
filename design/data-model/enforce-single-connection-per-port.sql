-- Run with search_path set to the target DCIM schema.
-- Existing conflicts are resolved by keeping the oldest connection for each port.

begin;

create temporary table duplicate_port_connections on commit drop as
with connection_endpoints as (
  select id as connection_id, source_port_id as port_id, created_at
  from cable_connection
  union all
  select id as connection_id, target_port_id as port_id, created_at
  from cable_connection
),
ranked_endpoints as (
  select
    connection_id,
    row_number() over (
      partition by port_id
      order by created_at, connection_id
    ) as occupancy_rank
  from connection_endpoints
)
select distinct connection_id
from ranked_endpoints
where occupancy_rank > 1;

delete from cable_connection connection
using duplicate_port_connections duplicate
where connection.id = duplicate.connection_id;

update port
set
  link_status = case
    when exists (
      select 1
      from cable_connection connection
      where connection.source_port_id = port.id
         or connection.target_port_id = port.id
    ) then 'connected'
    else 'disconnected'
  end,
  last_updated = now();

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

drop trigger if exists cable_connection_port_occupancy on cable_connection;

create trigger cable_connection_port_occupancy
before insert or update of source_port_id, target_port_id
on cable_connection
for each row
execute function enforce_cable_connection_port_occupancy();

commit;
