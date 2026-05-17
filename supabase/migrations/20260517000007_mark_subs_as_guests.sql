-- Reclassify Bliz and Kyle as guests (they are 2026-only subs for Lutz and Derek,
-- not part of the core eight). Re-pack sort_order so core comes first cleanly.

update members set is_guest = true where nickname in ('Bliz', 'Kyle');

update members set sort_order = 70  where nickname = 'Lutz';
update members set sort_order = 80  where nickname = 'Derek';
update members set sort_order = 90  where nickname = 'Bliz';
update members set sort_order = 100 where nickname = 'Kyle';
-- Mike stays at 110
