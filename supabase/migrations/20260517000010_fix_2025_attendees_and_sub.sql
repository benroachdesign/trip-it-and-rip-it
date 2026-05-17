-- Fix two facts that were wrong in earlier seeds:
-- 1. Strub did NOT attend 2025 (Mike Steward subbed in for him for that year)
-- 2. Mike's 2025 attendance record was missing the sub_for_member_id link to Strub

delete from trip_attendees
where trip_id = (select id from trips where year = 2025)
  and member_id = (select id from members where nickname = 'Strub');

update trip_attendees
set sub_for_member_id = (select id from members where nickname = 'Strub')
where trip_id = (select id from trips where year = 2025)
  and member_id = (select id from members where nickname = 'Mike');
