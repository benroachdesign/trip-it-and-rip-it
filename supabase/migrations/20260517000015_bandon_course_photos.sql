-- First batch of course hero photos, sourced from Wikimedia Commons (free reuse).
-- Pacific Dunes, Old Macdonald, Sheep Ranch, and Shorty's have no
-- freely-licensed photos available on Wikipedia — left null for now.

update courses set hero_photo_url = 'https://upload.wikimedia.org/wikipedia/commons/2/29/Bandon_Dunes_-_4th_hole.jpg'
  where name = 'Bandon Dunes';

update courses set hero_photo_url = 'https://upload.wikimedia.org/wikipedia/commons/4/48/Bandon_Trails_approaching_the_18th_fairway.jpg'
  where name = 'Bandon Trails';

update courses set hero_photo_url = 'https://upload.wikimedia.org/wikipedia/commons/b/ba/Bandon_Preserve.jpg'
  where name = 'Bandon Preserve';
