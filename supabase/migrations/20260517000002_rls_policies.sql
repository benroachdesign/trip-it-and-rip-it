-- Trip it & Rip it! — row-level security
-- Run after schema.sql.
--
-- Model: app is read-only for end users; all writes happen via the service role
-- (Supabase Studio, or our own dev tooling). RLS only governs SELECT.
--
-- Gate: a signed-in user can read any data only if their email is in
-- allowed_emails. This complements the app-side allowlist check.

create or replace function is_allowed()
returns boolean
language sql
stable
as $$
  select exists (
    select 1 from allowed_emails
    where email = (auth.jwt() ->> 'email')
  );
$$;

-- The allowlist itself is the one exception: we need to read it pre-gating
-- so the app can show a useful "you don't have access" screen.
alter table allowed_emails enable row level security;
create policy "anyone authenticated can read allowlist"
  on allowed_emails for select
  to authenticated
  using (true);

-- Everything else: read requires allowlist membership.
alter table members enable row level security;
create policy "allowed users can read members"
  on members for select to authenticated using (is_allowed());

alter table trips enable row level security;
create policy "allowed users can read trips"
  on trips for select to authenticated using (is_allowed());

alter table trip_attendees enable row level security;
create policy "allowed users can read trip_attendees"
  on trip_attendees for select to authenticated using (is_allowed());

alter table courses enable row level security;
create policy "allowed users can read courses"
  on courses for select to authenticated using (is_allowed());

alter table course_signature_holes enable row level security;
create policy "allowed users can read course_signature_holes"
  on course_signature_holes for select to authenticated using (is_allowed());

alter table course_holes enable row level security;
create policy "allowed users can read course_holes"
  on course_holes for select to authenticated using (is_allowed());

alter table course_notes enable row level security;
create policy "allowed users can read course_notes"
  on course_notes for select to authenticated using (is_allowed());

alter table trip_courses enable row level security;
create policy "allowed users can read trip_courses"
  on trip_courses for select to authenticated using (is_allowed());

alter table trip_teams enable row level security;
create policy "allowed users can read trip_teams"
  on trip_teams for select to authenticated using (is_allowed());

alter table trip_team_members enable row level security;
create policy "allowed users can read trip_team_members"
  on trip_team_members for select to authenticated using (is_allowed());

alter table trip_events enable row level security;
create policy "allowed users can read trip_events"
  on trip_events for select to authenticated using (is_allowed());
