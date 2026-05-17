-- Adds is_guest to members (for one-off guests like Mike Steward in 2025),
-- inserts Mike, and backfills trip_attendees for 2021-2025 now that the
-- per-year roster is confirmed.

alter table members add column is_guest boolean not null default false;

insert into members (full_name, nickname, sort_order, is_guest) values
  ('Mike Steward', 'Mike', 110, true);

-- 2021 + 2022 — founding four: Roach, Strub, Mader, Braden
insert into trip_attendees (trip_id, member_id)
select t.id, m.id
from trips t
cross join members m
where t.year in (2021, 2022)
  and m.nickname in ('Roach', 'Strub', 'Mader', 'Braden');

-- 2023 + 2024 — expanded eight (founding four + Lutz, Derek, Webb, Tommer)
insert into trip_attendees (trip_id, member_id)
select t.id, m.id
from trips t
cross join members m
where t.year in (2023, 2024)
  and m.nickname in ('Roach', 'Strub', 'Mader', 'Braden', 'Lutz', 'Derek', 'Webb', 'Tommer');

-- 2025 — same eight plus Mike Steward as a one-time guest
insert into trip_attendees (trip_id, member_id)
select t.id, m.id
from trips t
cross join members m
where t.year = 2025
  and m.nickname in ('Roach', 'Strub', 'Mader', 'Braden', 'Lutz', 'Derek', 'Webb', 'Tommer', 'Mike');
