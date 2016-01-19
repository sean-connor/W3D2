DROP TABLE IF EXISTS users;
CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  fname VARCHAR(255) NOT NULL,
  lname VARCHAR(255) NOT NULL
);

DROP TABLE IF EXISTS questions;
CREATE TABLE questions (
  id INTEGER PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  body TEXT,
  author_id INTEGER NOT NULL
);

DROP TABLE IF EXISTS question_follows;
CREATE TABLE question_follows (
  id INTEGER PRIMARY KEY,
  follower_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL
);

DROP TABLE IF EXISTS replies;
CREATE TABLE replies (
  id INTEGER PRIMARY KEY,
  question_id INTEGER NOT NULL,
  respondent_id INTEGER NOT NULL,
  body TEXT NOT NULL,
  parent_id INTEGER
);

DROP TABLE IF EXISTS likes;
CREATE TABLE likes (
  id INTEGER PRIMARY KEY,
  user_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL
);

INSERT INTO users (fname, lname)
VALUES
('Sean', 'Connor'),
('Edwin', 'Lai'),
('Sarah', 'Connor'),
('John', 'Connor');
INSERT INTO questions (title, body, author_id)
VALUES
('How do I do laundry?', 'Ive always had a maid do it for me and I just moved out on my own, so I dont understand how it works.', 1),
('How is babby formed?', 'idk :(' , 2),
('Why do I see cats and dogs literally falling from the sky?', 'wtf mate', 3),
('Where is Outer Sunset?', 'I am lost.', 4);
INSERT INTO question_follows (follower_id, question_id)
VALUES
(1, 4),
(2, 3),
(3, 1),
(4, 2);
INSERT INTO replies (question_id, respondent_id, body, parent_id)
VALUES
(1, 2, 'Put it into the oven. Preheat to 350 degrees. Take out after an hour.', NULL),
(1, 3, 'wtf bruv, thats not how you do laundry!!!1!11!', 1),
(2, 1, 'Step 1: Google. Step 2: Click on the first link from Yahoo Answers.', NULL),
(4, 1, 'Next to Inner Sunset.', NULL),
(4, 4, 'That was hella helpful dude, now give me some real directions.', 4);
INSERT INTO likes(user_id, question_id)
VALUES
(1, 2),
(2, 2),
(3, 2),
(4, 2);
