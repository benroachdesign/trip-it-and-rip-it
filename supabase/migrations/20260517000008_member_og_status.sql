-- OG = original founding member from 2021/2022 when the trip was 4-person.
-- All four OGs are also core (never guests); enforce that with a check constraint.

alter table members add column is_og boolean not null default false;

alter table members add constraint members_og_not_guest
  check (not (is_og and is_guest));

update members set is_og = true
  where nickname in ('Roach', 'Strub', 'Mader', 'Braden');
