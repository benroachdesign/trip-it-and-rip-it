-- Trophy Room data model.
-- Each award is for ONE trip and is given to EITHER one member OR one team
-- (never both, never neither). Multiple awards per trip per category are allowed
-- (e.g., "Low Score of Day" can repeat across days).

create table trip_awards (
  id uuid primary key default gen_random_uuid(),
  trip_id uuid not null references trips(id) on delete cascade,
  member_id uuid references members(id) on delete cascade,
  trip_team_id uuid references trip_teams(id) on delete cascade,
  title text not null,
  category text,
  description text,
  awarded_date date,
  sort_order int not null default 0,
  created_at timestamptz not null default now(),
  constraint trip_awards_exactly_one_recipient check (
    (member_id is not null and trip_team_id is null)
    or (member_id is null and trip_team_id is not null)
  )
);

create index trip_awards_trip_idx on trip_awards (trip_id, sort_order);
create index trip_awards_member_idx on trip_awards (member_id) where member_id is not null;
create index trip_awards_team_idx on trip_awards (trip_team_id) where trip_team_id is not null;

alter table trip_awards enable row level security;
create policy "allowed users can read trip_awards"
  on trip_awards for select to authenticated using (is_allowed());
