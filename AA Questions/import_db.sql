DROP TABLE IF EXISTS question_likes;
DROP TABLE IF EXISTS replies;
DROP TABLE IF EXISTS question_follows;
DROP TABLE IF EXISTS questions;
DROP TABLE IF EXISTS users;

PRAGMA foreign_keys = ON;

CREATE TABLE users(
    id INTEGER PRIMARY KEY,
    fname VARCHAR(255) NOT NULL,
    lname VARCHAR(255) NOT NULL
);

CREATE TABLE questions(
    id INTEGER PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    body TEXT NOT NULL,
    author_id INTEGER NOT NULL,

    FOREIGN KEY (author_id) REFERENCES users(id)
);

CREATE TABLE question_follows(
    id INTEGER PRIMARY KEY,
    user_id INTEGER NOT NULL,
    question_id INTEGER NOT NULL,

    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN key(question_id) REFERENCES questions(id)
);

CREATE TABLE replies(
    id INTEGER PRIMARY KEY,
    question_id INTEGER NOT NULL,
    parent_reply_id INTEGER ,
    author_id INTEGER NOT NULL,
    body TEXT NOT NULL,

    FOREIGN KEY(question_id)  REFERENCES questions(id),
    FOREIGN KEY(parent_reply_id) REFERENCES replies(id),
    FOREIGN KEY(author_id) REFERENCES users(id)
);

CREATE TABLE question_likes(
    id INTEGER PRIMARY KEY,
    question_id INTEGER NOT NULL,
    user_id INTEGER NOT NULL,

    FOREIGN KEY(question_id) REFERENCES questions(id)
    FOREIGN KEY(user_id) REFERENCES users(id)
);


--users table
INSERT INTO
    users(fname, lname)
VALUES
    ("Justin", "Time"), ("Natasha","Romanoff"), ("Lebron", "James");

--questions table
INSERT INTO
    questions(title, body, author_id)
SELECT
    "Justin's Question", "What is life", users.id
FROM
    users
WHERE
    users.fname LIKE "Justin" AND users.lname LIKE "Time";

INSERT INTO
    questions(title, body, author_id)
SELECT
    "Natasha's Question", "What is this", users.id
FROM
    users
WHERE
    users.fname LIKE "Natasha" AND users.lname LIKE "Romanoff";

INSERT INTO
    questions(title, body, author_id)
SELECT
    "Natasha's Question2", "What is this2", users.id
FROM
    users
WHERE
    users.fname LIKE "Natasha" AND users.lname LIKE "Romanoff";

INSERT INTO
    questions(title, body, author_id)
SELECT
    "Lebron's Question", "Basketball Question", users.id
FROM
    users
WHERE
    users.fname LIKE "Lebron" AND users.lname LIKE "James";

--question follows table
INSERT INTO
    question_follows(question_id, user_id)
VALUES
    (3,1), (3,2), (3,3), (2,1), (2,3), (1,2);

--replies table
INSERT INTO
    replies(question_id, parent_reply_id, author_id, body)
VALUES
    (
    (SELECT id FROM questions WHERE title LIKE "Justin's Question"),
    NULL,
    (SELECT id FROM users WHERE fname LIKE "Natasha" AND lname LIKE "Romanoff"),
    "Life is like lemons"
    );
INSERT INTO
    replies(question_id, parent_reply_id, author_id, body)
VALUES
    (
    (SELECT id FROM questions WHERE title LIKE "Justin's Question"),
    (SELECT id FROM replies WHERE body LIKE "Life is like lemons"),
    (SELECT id FROM users WHERE fname LIKE "Lebron" AND lname LIKE "James"),
    "I agree and I love lemons"
    );

--question likes table
INSERT INTO
    question_likes(question_id, user_id)
VALUES
    (
    (SELECT id FROM questions WHERE title LIKE "Justin's Question"),
    (SELECT id FROM users WHERE fname LIKE "Natasha" AND lname LIKE "Romanoff")
    ),
    (
    (SELECT id FROM questions WHERE title LIKE "Natasha's Question"),
    (SELECT id FROM users WHERE fname LIKE "Justin" AND lname LIKE "Time")
    ),
    (
    (SELECT id FROM questions WHERE title LIKE "Lebron's Question"),
    (SELECT id FROM users WHERE fname LIKE "Natasha" AND lname LIKE "Romanoff")
    ),
    (
    (SELECT id FROM questions WHERE title LIKE "Justin's Question"),
    (SELECT id FROM users WHERE fname LIKE "Lebron" AND lname LIKE "James")
    );

--For readability when viewing tables: .headers on , .mode column