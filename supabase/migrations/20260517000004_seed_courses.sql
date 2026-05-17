-- Seeds the 28 courses played across 2021-2026 and links them to their trips.
-- Course list provided by Ben on 2026-05-17 as the canonical source.

with course_data(year, course_name, course_city, course_state, sort_order) as (
  values
    -- 2021 Scottsdale
    (2021, 'TPC Scottsdale — Stadium Course',                'Scottsdale',  'AZ', 10),
    (2021, 'Troon North — Pinnacle Course',                  'Scottsdale',  'AZ', 20),
    (2021, 'We-Ko-Pa — Saguaro Course',                      'Fort McDowell','AZ', 30),
    (2021, 'We-Ko-Pa — Cholla Course',                       'Fort McDowell','AZ', 40),
    -- 2022 Palm Desert
    (2022, 'PGA West — Mountain Course',                     'La Quinta',   'CA', 10),
    (2022, 'Desert Willow — Mountain View Course',           'Palm Desert', 'CA', 20),
    (2022, 'Desert Springs — Palm Course',                   'Palm Desert', 'CA', 30),
    (2022, 'SilverRock Resort',                              'La Quinta',   'CA', 40),
    -- 2023 San Diego
    (2023, 'Maderas Golf Club',                              'Poway',       'CA', 10),
    (2023, 'Torrey Pines Golf Course — South',               'La Jolla',    'CA', 20),
    (2023, 'Aviara Golf Club',                               'Carlsbad',    'CA', 30),
    -- 2024 Tucson
    (2024, 'Sewailo Golf Club',                              'Tucson',      'AZ', 10),
    (2024, 'Ventana Canyon — Mountain Course',               'Tucson',      'AZ', 20),
    (2024, 'Tucson National at Omni Resort — Sonoran Course','Tucson',      'AZ', 30),
    (2024, 'Tucson National at Omni Resort — Catalina Course','Tucson',     'AZ', 40),
    -- 2025 St. George
    (2025, 'Sand Hollow Resort — Championship Course',       'Hurricane',   'UT', 10),
    (2025, 'Green Spring',                                   'Washington',  'UT', 20),
    (2025, 'Wolf Creek Golf Club',                           'Mesquite',    'NV', 30),
    (2025, 'Coral Canyon',                                   'Washington',  'UT', 40),
    (2025, 'Black Desert Resort',                            'Ivins',       'UT', 50),
    -- 2026 Bandon Dunes
    (2026, 'Bandon Preserve',                                'Bandon',      'OR', 10),
    (2026, 'Pacific Dunes',                                  'Bandon',      'OR', 20),
    (2026, 'Shorty''s',                                      'Bandon',      'OR', 30),
    (2026, 'Bandon Dunes',                                   'Bandon',      'OR', 40),
    (2026, 'Old Macdonald',                                  'Bandon',      'OR', 50),
    (2026, 'Sheep Ranch',                                    'Bandon',      'OR', 60),
    (2026, 'Bandon Trails',                                  'Bandon',      'OR', 70)
),
inserted_courses as (
  insert into courses (name, location_city, location_state)
  select course_name, course_city, course_state from course_data
  returning id, name
)
insert into trip_courses (trip_id, course_id, sort_order)
select
  t.id,
  ic.id,
  cd.sort_order
from course_data cd
join trips t on t.year = cd.year
join inserted_courses ic on ic.name = cd.course_name;
