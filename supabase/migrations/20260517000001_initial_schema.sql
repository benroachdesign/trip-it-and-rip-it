-- Trip it & Rip it! — initial schema
-- Run this first in Supabase SQL editor.

-- Members of the group. 10-person roster; 8 attend any given trip.
create table members (
  id uuid primary key default gen_random_uuid(),
  full_name text not null,
  nickname text,
  home_city text,
  handicap numeric(4,1),
  avatar_url text,
  sort_order int not null default 0,
  created_at timestamptz not null default now()
);

-- Allowlist for sign-up. Auth gating happens both app-side and via RLS.
create table allowed_emails (
  email text primary key,
  member_id uuid references members(id) on delete set null,
  note text,
  created_at timestamptz not null default now()
);

-- One row per annual trip.
create table trips (
  id uuid primary key default gen_random_uuid(),
  year int not null unique,
  trip_title text,
  location_city text not null,
  location_state text,
  start_date date,
  end_date date,
  winning_team_id uuid,
  hero_photo_url text,
  blurb text,
  created_at timestamptz not null default now()
);

-- Who attended which trip. sub_for_member_id lets us record "Bliz subbed for Lutz."
create table trip_attendees (
  trip_id uuid not null references trips(id) on delete cascade,
  member_id uuid not null references members(id) on delete cascade,
  sub_for_member_id uuid references members(id),
  primary key (trip_id, member_id)
);

-- Golf courses. Reused across trips.
create table courses (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  location_city text,
  location_state text,
  architect text,
  year_built int,
  hero_photo_url text,
  created_at timestamptz not null default now()
);

create table course_signature_holes (
  id uuid primary key default gen_random_uuid(),
  course_id uuid not null references courses(id) on delete cascade,
  hole_number int not null,
  title text,
  note text,
  photo_url text,
  sort_order int not null default 0
);

create table course_holes (
  id uuid primary key default gen_random_uuid(),
  course_id uuid not null references courses(id) on delete cascade,
  hole_number int not null,
  par int not null,
  yardages jsonb,
  unique (course_id, hole_number)
);

create table course_notes (
  id uuid primary key default gen_random_uuid(),
  course_id uuid not null references courses(id) on delete cascade,
  body text not null,
  sort_order int not null default 0
);

-- A specific course played at a specific trip.
create table trip_courses (
  id uuid primary key default gen_random_uuid(),
  trip_id uuid not null references trips(id) on delete cascade,
  course_id uuid not null references courses(id),
  scheduled_date date,
  tee_time time,
  walking_distance_text text,
  sort_order int not null default 0
);

-- Teams within a trip. The two-team Ryder Cup format only started in some years.
create table trip_teams (
  id uuid primary key default gen_random_uuid(),
  trip_id uuid not null references trips(id) on delete cascade,
  name text not null,
  result text check (result in ('won', 'lost', 'tied'))
);

alter table trips
  add constraint trips_winning_team_fk
  foreign key (winning_team_id) references trip_teams(id);

create table trip_team_members (
  trip_team_id uuid not null references trip_teams(id) on delete cascade,
  member_id uuid not null references members(id) on delete cascade,
  primary key (trip_team_id, member_id)
);

-- Unified schedule used by both the schedule view and the "Right now" view.
create table trip_events (
  id uuid primary key default gen_random_uuid(),
  trip_id uuid not null references trips(id) on delete cascade,
  starts_at timestamptz not null,
  ends_at timestamptz,
  title text not null,
  subtitle text,
  event_type text check (event_type in ('golf', 'meal', 'transport', 'lodging', 'other')),
  location_name text,
  course_id uuid references courses(id),
  notes text,
  sort_order int
);

create index trip_events_starts_at_idx on trip_events (trip_id, starts_at);
