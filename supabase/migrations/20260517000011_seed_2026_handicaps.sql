-- Current handicaps for the 8 people on the 2026 Bandon trip.
-- handicap column already exists from the initial schema (numeric(4,1)).
-- These will need updating after the trip; Ben said they're rough now.

update members set handicap = 11 where nickname = 'Roach';
update members set handicap = 12 where nickname = 'Strub';
update members set handicap = 18 where nickname = 'Mader';
update members set handicap = 10 where nickname = 'Braden';
update members set handicap = 9  where nickname = 'Webb';
update members set handicap = 12 where nickname = 'Tommer';
update members set handicap = 11 where nickname = 'Bliz';
update members set handicap = 4  where nickname = 'Kyle';
-- Lutz, Derek, Mike: not on 2026 trip; handicaps left null.
