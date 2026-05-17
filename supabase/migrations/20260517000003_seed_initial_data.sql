-- Trip it & Rip it! — initial seed data.
-- Run after schema.sql + rls.sql.
--
-- Seeds the full 10-person roster and the 6 trip year records. Handicaps and
-- avatar URLs are left blank — fill in as data becomes available.

insert into members (full_name, nickname, sort_order) values
  ('Ben Roach',         'Roach', 10),
  ('Ryan Strub',        'Strub', 20),
  ('Austin Mader',      'Mader', 30),
  ('Braden Carlson',    'Braden', 40),
  ('Matt Webb',         'Webb', 50),
  ('Tommer Butman',     'Tommer', 60),
  ('Alex Blizniak',     'Bliz', 70),
  ('Kyle Worley',       'Kyle', 80),
  ('Chris Lutz',        'Lutz', 90),
  ('Derek DeCarolis',   'Derek', 100);

-- Trip records. Course lists are seeded later once we have the data.

insert into trips (year, trip_title, location_city, location_state, start_date, end_date) values
  (2021, 'Men''s Golf Weekend',          'Scottsdale',  'AZ', null, null),
  (2022, 'Men''s Golf Weekend',          'Palm Desert', 'CA', null, null),
  (2023, 'Annual Gentlemen''s Golf Club','San Diego',   'CA', null, null),
  (2024, 'Annual Gentlemen''s Golf Club','Tucson',      'AZ', null, null),
  (2025, 'Trip it & Rip it!',            'St. George',  'UT', null, null),
  (2026, 'Trip it & Rip it!',            'Bandon',      'OR', '2026-07-23', '2026-07-27');

-- 2026 Bandon attendees (8): Roach, Strub, Mader, Braden, Webb, Tommer, Bliz, Kyle.
-- Bliz subs for Lutz. Kyle subs for Derek.

with t as (select id from trips where year = 2026),
     m as (select id, nickname from members)
insert into trip_attendees (trip_id, member_id, sub_for_member_id)
select
  t.id,
  m.id,
  case
    when m.nickname = 'Bliz' then (select id from members where nickname = 'Lutz')
    when m.nickname = 'Kyle' then (select id from members where nickname = 'Derek')
    else null
  end
from t, m
where m.nickname in ('Roach', 'Strub', 'Mader', 'Braden', 'Webb', 'Tommer', 'Bliz', 'Kyle');
