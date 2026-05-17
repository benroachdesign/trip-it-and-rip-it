-- Handicaps for the three members who weren't on the 2026 roster
-- but still have data we want surfaced on their profiles.

update members set handicap = 13 where nickname = 'Lutz';
update members set handicap = 13 where nickname = 'Derek';
update members set handicap = 7  where nickname = 'Mike';
