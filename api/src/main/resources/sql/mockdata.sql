-- ------------------------------------------------------------
-- users
-- password values are placeholder bcrypt-style hashes, NOT real hashes
-- ------------------------------------------------------------
INSERT INTO users (uuid, name, email, password, is_moderator) VALUES
    ('11111111-1111-4111-8111-111111111111', 'Ava Thompson',      'ava.thompson@vt.edu',      '$2b$12$9k3F1z7QeYV1z0m6h1LmE.7xVYQKq2G8p1c3aRr9dQvJmN2sT6uWa', 1),
    ('22222222-2222-4222-8222-222222222222', 'Ben Rodriguez',     'ben.rodriguez@vt.edu',     '$2b$12$Kd8j2Lp0mYV1z0m6h1LmE.7xVYQKq2G8p1c3aRr9dQvJmN2sT6uWb', 0),
    ('33333333-3333-4333-8333-333333333333', 'Chloe Nguyen',      'chloe.nguyen@vt.edu',      '$2b$12$Zt5m9Xr3nYV1z0m6h1LmE.7xVYQKq2G8p1c3aRr9dQvJmN2sT6uWc', 0),
    ('44444444-4444-4444-8444-444444444444', 'Diego Alvarez',     'diego.alvarez@vt.edu',     '$2b$12$Pq7n4Ws6oYV1z0m6h1LmE.7xVYQKq2G8p1c3aRr9dQvJmN2sT6uWd', 0),
    ('55555555-5555-4555-8555-555555555555', 'Emma Wallace',      'emma.wallace@vt.edu',      '$2b$12$Rf2b8Ct1pYV1z0m6h1LmE.7xVYQKq2G8p1c3aRr9dQvJmN2sT6uWe', 0),
    ('66666666-6666-4666-8666-666666666666', 'Farid Haidari',     'farid.haidari@vt.edu',     '$2b$12$Ln6c3Dv5qYV1z0m6h1LmE.7xVYQKq2G8p1c3aRr9dQvJmN2sT6uWf', 0),
    ('77777777-7777-4777-8777-777777777777', 'Grace Kim',         'grace.kim@vt.edu',         '$2b$12$Ht9d1Ex8rYV1z0m6h1LmE.7xVYQKq2G8p1c3aRr9dQvJmN2sT6uWg', 0),
    ('88888888-8888-4888-8888-888888888888', 'Hunter Brooks',     'hunter.brooks@vt.edu',     '$2b$12$Ju0e4Fy2sYV1z0m6h1LmE.7xVYQKq2G8p1c3aRr9dQvJmN2sT6uWh', 0),
    ('99999999-9999-4999-8999-999999999999', 'Isabella Ferraro',  'isabella.ferraro@vt.edu',  '$2b$12$Mv1f7Gz9tYV1z0m6h1LmE.7xVYQKq2G8p1c3aRr9dQvJmN2sT6uWi', 0),
    ('aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa', 'Jack Sullivan',     'jack.sullivan@vt.edu',     '$2b$12$Nw2g0Hz1uYV1z0m6h1LmE.7xVYQKq2G8p1c3aRr9dQvJmN2sT6uWj', 0);

-- ------------------------------------------------------------
-- profiles
-- image is a tiny placeholder BLOB (1x1 px transparent PNG bytes) — swap
-- in real image data as needed, this just satisfies the NOT NULL column
-- ------------------------------------------------------------
INSERT INTO profiles (user_uuid, school_year, bio, major, interests, grad_date, next_steps, age, height_inches, gender, image) VALUES
     ('11111111-1111-4111-8111-111111111111', 'Senior', 'Fourth-year CS student who loves hackathons and rock climbing.', 'Computer Science', 'Climbing, hackathons, board games',        '2026-05-15', 'Software engineer at a startup', 21, 65, 'Female', X'89504E470D0A1A0A0000000D49484452000000010000000108060000001F15C4890000000A4944415478DA6360000002000155A32A4E0000000049454E44AE426082'),
     ('22222222-2222-4222-8222-222222222222', 'Junior', 'Junior studying mechanical engineering, into intramural soccer.', 'Mechanical Engineering', 'Soccer, robotics, camping',                '2027-12-14', 'Grad school for robotics',      20, 71, 'Male',   X'89504E470D0A1A0A0000000D49484452000000010000000108060000001F15C4890000000A4944415478DA6360000002000155A32A4E0000000049454E44AE426082'),
     ('33333333-3333-4333-8333-333333333333', 'Senior', 'Biology major planning on med school, plays violin in free time.', 'Biology', 'Violin, volunteering, hiking',             '2026-05-15', 'Applying to med school',        22, 63, 'Female', X'89504E470D0A1A0A0000000D49484452000000010000000108060000001F15C4890000000A4944415478DA6360000002000155A32A4E0000000049454E44AE426082'),
     ('44444444-4444-4444-8444-444444444444', 'Senior', 'Senior finance major, runs the investment club on campus.', 'Finance', 'Investing, golf, chess',                   '2025-12-14', 'Analyst role in NYC',           22, 69, 'Male',   X'89504E470D0A1A0A0000000D49484452000000010000000108060000001F15C4890000000A4944415478DA6360000002000155A32A4E0000000049454E44AE426082'),
     ('55555555-5555-4555-8555-555555555555', 'Freshman', 'Freshman exploring graphic design and photography.', 'Graphic Design', 'Photography, art, thrifting',              '2028-05-15', 'Undecided, exploring options',  18, 64, 'Female', X'89504E470D0A1A0A0000000D49484452000000010000000108060000001F15C4890000000A4944415478DA6360000002000155A32A4E0000000049454E44AE426082'),
     ('66666666-6666-4666-8666-666666666666', 'Senior', 'CS student focused on systems programming and Linux internals.', 'Computer Science', 'Linux, gaming, weightlifting',             '2026-05-15', 'Backend engineer role',         21, 73, 'Male',   X'89504E470D0A1A0A0000000D49484452000000010000000108060000001F15C4890000000A4944415478DA6360000002000155A32A4E0000000049454E44AE426082'),
     ('77777777-7777-4777-8777-777777777777', 'Junior', 'Psychology major, loves baking and true crime podcasts.', 'Psychology', 'Baking, podcasts, yoga',                   '2027-12-14', 'Masters in counseling',         20, 62, 'Female', X'89504E470D0A1A0A0000000D49484452000000010000000108060000001F15C4890000000A4944415478DA6360000002000155A32A4E0000000049454E44AE426082'),
     ('88888888-8888-4888-8888-888888888888', 'Junior', 'Civil engineering senior, avid trail runner.', 'Civil Engineering', 'Running, kayaking, craft beer',            '2025-05-15', 'PE license and consulting job', 23, 70, 'Male',   X'89504E470D0A1A0A0000000D49484452000000010000000108060000001F15C4890000000A4944415478DA6360000002000155A32A4E0000000049454E44AE426082'),
     ('99999999-9999-4999-8999-999999999999', 'Senior', 'Marketing major who runs a small Etsy shop on the side.', 'Marketing', 'Crafting, social media, dogs',             '2026-05-15', 'Brand marketing internship',    21, 66, 'Female', X'89504E470D0A1A0A0000000D49484452000000010000000108060000001F15C4890000000A4944415478DA6360000002000155A32A4E0000000049454E44AE426082'),
     ('aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa', 'Sophomore', 'Electrical engineering student who builds synths as a hobby.', 'Electrical Engineering', 'Synths, music production, chess',    '2027-12-14', 'Internship at an audio company', 20, 72, 'Male', X'89504E470D0A1A0A0000000D49484452000000010000000108060000001F15C4890000000A4944415478DA6360000002000155A32A4E0000000049454E44AE426082');

-- ------------------------------------------------------------
-- likes
-- ------------------------------------------------------------
INSERT INTO likes (liker_uuid, liked_uuid) VALUES
   ('11111111-1111-4111-8111-111111111111', '33333333-3333-4333-8333-333333333333'),
   ('33333333-3333-4333-8333-333333333333', '11111111-1111-4111-8111-111111111111'), -- mutual match
   ('22222222-2222-4222-8222-222222222222', '55555555-5555-4555-8555-555555555555'),
   ('55555555-5555-4555-8555-555555555555', '22222222-2222-4222-8222-222222222222'), -- mutual match
   ('66666666-6666-4666-8666-666666666666', '99999999-9999-4999-8999-999999999999'),
   ('99999999-9999-4999-8999-999999999999', '66666666-6666-4666-8666-666666666666'), -- mutual match
   ('77777777-7777-4777-8777-777777777777', 'aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa'),
   ('88888888-8888-4888-8888-888888888888', '77777777-7777-4777-8777-777777777777'), -- one-sided, no match
   ('44444444-4444-4444-8444-444444444444', '99999999-9999-4999-8999-999999999999'), -- one-sided, no match
   ('aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa', '11111111-1111-4111-8111-111111111111'); -- one-sided, no match

-- ------------------------------------------------------------
-- messages
-- timestamps are unix epoch seconds, roughly Sept 2026, in conversation order
-- ------------------------------------------------------------
INSERT INTO messages (sender_uuid, receiver_uuid, timestamp, message) VALUES
  ('11111111-1111-4111-8111-111111111111', '33333333-3333-4333-8333-333333333333', 1758901200, 'Hey! I saw we matched, congrats on the violin recital btw'),
  ('33333333-3333-4333-8333-333333333333', '11111111-1111-4111-8111-111111111111', 1758901500, 'Thank you!! Are you still into rock climbing? We should go sometime'),
  ('11111111-1111-4111-8111-111111111111', '33333333-3333-4333-8333-333333333333', 1758901800, 'Absolutely, there is a good gym near campus, want to go this weekend?'),
  ('22222222-2222-4222-8222-222222222222', '55555555-5555-4555-8555-555555555555', 1758988000, 'Hi Emma, love your photography portfolio!'),
  ('55555555-5555-4555-8555-555555555555', '22222222-2222-4222-8222-222222222222', 1758988400, 'Aw thank you so much! Do you play soccer intramurals still?'),
  ('66666666-6666-4666-8666-666666666666', '99999999-9999-4999-8999-999999999999', 1759074000, 'Hey Isabella, saw your Etsy shop, that pottery is really cool'),
  ('99999999-9999-4999-8999-999999999999', '66666666-6666-4666-8666-666666666666', 1759074300, 'Thanks! Are you the one who builds Linux servers? That is wild'),
  ('99999999-9999-4999-8999-999999999999', '66666666-6666-4666-8666-666666666666', 1759074600, 'We should grab coffee sometime and you can explain it to me lol'),
  ('44444444-4444-4444-8444-444444444444', '99999999-9999-4999-8999-999999999999', 1759161000, 'Hey, I noticed we have some mutual friends, want to chat?'),
  ('77777777-7777-4777-8777-777777777777', 'aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa', 1759247400, 'Hi Jack! Saw you make synths, that is so cool, do you perform anywhere?');