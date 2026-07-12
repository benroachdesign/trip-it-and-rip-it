-- Add the metadata fields shown on the Roster row + profile.
-- handicap can be null; home_city populated from 2023 trip planning docs.
-- fun_fact + bio remain null until Ben supplies them.

alter table members add column if not exists home_city text;
alter table members add column if not exists fun_fact text;
alter table members add column if not exists bio text;

update members set home_city = 'Chicago'       where nickname = 'Roach';
update members set home_city = 'Portland'      where nickname = 'Strub';
update members set home_city = 'Dallas'        where nickname = 'Mader';
update members set home_city = 'Chicago'       where nickname = 'Braden';
update members set home_city = 'Austin'        where nickname = 'Webb';
update members set home_city = 'Chicago'       where nickname = 'Tommer';
update members set home_city = 'San Francisco' where nickname = 'Lutz';
update members set home_city = 'Houston'       where nickname = 'Derek';
-- Bliz, Kyle, Mike home cities unknown; left null.
