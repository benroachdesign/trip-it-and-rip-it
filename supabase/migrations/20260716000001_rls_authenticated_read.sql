-- Companion to the build-5 allowlist removal (PR #5): the app no longer gates
-- sign-in on allowed_emails, but these RLS policies still did — so any signed-in
-- user NOT in allowed_emails got zero rows back and the app spun forever.
-- TestFlight is the access gate now: any authenticated user can read.
-- RLS stays enabled, so the anon key still returns nothing.
-- allowed_emails keeps its existing policy; the is_allowed() function is left
-- in place (inert) so the allowlist can be re-enabled later if ever needed.

drop policy if exists "allowed users can read members" on members;
create policy "authenticated users can read members"
  on members for select to authenticated using (true);

drop policy if exists "allowed users can read trips" on trips;
create policy "authenticated users can read trips"
  on trips for select to authenticated using (true);

drop policy if exists "allowed users can read trip_attendees" on trip_attendees;
create policy "authenticated users can read trip_attendees"
  on trip_attendees for select to authenticated using (true);

drop policy if exists "allowed users can read courses" on courses;
create policy "authenticated users can read courses"
  on courses for select to authenticated using (true);

drop policy if exists "allowed users can read course_signature_holes" on course_signature_holes;
create policy "authenticated users can read course_signature_holes"
  on course_signature_holes for select to authenticated using (true);

drop policy if exists "allowed users can read course_holes" on course_holes;
create policy "authenticated users can read course_holes"
  on course_holes for select to authenticated using (true);

drop policy if exists "allowed users can read course_notes" on course_notes;
create policy "authenticated users can read course_notes"
  on course_notes for select to authenticated using (true);

drop policy if exists "allowed users can read trip_courses" on trip_courses;
create policy "authenticated users can read trip_courses"
  on trip_courses for select to authenticated using (true);

drop policy if exists "allowed users can read trip_teams" on trip_teams;
create policy "authenticated users can read trip_teams"
  on trip_teams for select to authenticated using (true);

drop policy if exists "allowed users can read trip_team_members" on trip_team_members;
create policy "authenticated users can read trip_team_members"
  on trip_team_members for select to authenticated using (true);

drop policy if exists "allowed users can read trip_events" on trip_events;
create policy "authenticated users can read trip_events"
  on trip_events for select to authenticated using (true);
