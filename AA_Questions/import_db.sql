PRAGMA foreign_keys = ON;
DROP TABLE IF EXISTS question_likes; 
DROP TABLE IF EXISTS replies;
DROP TABLE IF EXISTS question_follows;
DROP TABLE IF EXISTS questions;
DROP TABLE IF EXISTS users;
-- change to reverse order for table dropping
-- USE SINGULAR FOR ID COLUMNS


CREATE TABLE users (
    id INTEGER PRIMARY KEY,
    fname TEXT NOT NULL,
    lname TEXT NOT NULL
);

INSERT INTO 
    users (fname, lname)
VALUES
    ('Adam', 'Liang'),
    ('Hugh', 'Mann'),
    ('Not', 'Mann'),
    ('Firstname', 'Lastname');


CREATE TABLE questions (
    id INTEGER PRIMARY KEY,
    title TEXT NOT NULL,
    body TEXT NOT NULL,
    author_id INTEGER,

    FOREIGN KEY (author_id) REFERENCES users(id)  
);

INSERT INTO 
    questions (title, body, author_id)
SELECT 
    "Hello?", "Hi", users.id
FROM
    users
WHERE  
    fname = 'Adam';

INSERT INTO 
    questions (title, body, author_id)
SELECT 
    "Is this a question?", "I was wondering...", users.id
FROM
    users
WHERE  
    fname = 'Hugh';

INSERT INTO 
    questions (title, body, author_id)
SELECT 
    "Wow?", "Sounds good", users.id
FROM
    users
WHERE  
    fname = 'Not';

CREATE TABLE question_follows (
    id INTEGER PRIMARY KEY,
    question_id INTEGER NOT NULL,
    user_id INTEGER NOT NULL, 

    FOREIGN KEY (question_id) REFERENCES questions(id),
    FOREIGN KEY (user_id) REFERENCES users(id)
);

INSERT INTO 
    question_follows (question_id, user_id)
VALUES
    ((SELECT id FROM questions WHERE title = 'Wow?'), 
    (SELECT id FROM users WHERE fname = 'Adam')),
    
    ((SELECT id FROM questions WHERE title = 'Hello?'), 
    (SELECT id FROM users WHERE fname = 'Hugh'));


CREATE TABLE replies (
    id INTEGER PRIMARY KEY,
    question_id INTEGER NOT NULL,
    parent_id INTEGER,
    author_id INTEGER NOT NULL,
    body TEXT NOT NULL,

    FOREIGN KEY (question_id) REFERENCES questions(id),
    FOREIGN KEY (parent_id) REFERENCES replies(id),
    FOREIGN KEY (author_id) REFERENCES users(id)
);

INSERT INTO 
    replies (question_id, parent_id, author_id, body)
VALUES  
    (1, NULL, (SELECT id FROM users WHERE fname = 'Firstname'), "Greetings"),

    (2, NULL, (SELECT id FROM users WHERE fname = 'Adam'), "It's not a question");
INSERT INTO
    replies (question_id, parent_id, author_id, body)
VALUES
    (1, (SELECT r1.id FROM replies r1 WHERE r1.id = 1 LIMIT 1), 
    (SELECT id FROM users WHERE fname = 'Adam'), "Hey");
    


CREATE TABLE question_likes (
    id INTEGER PRIMARY KEY,
    question_id INTEGER NOT NULL,
    user_id INTEGER NOT NULL,

    FOREIGN KEY (question_id) REFERENCES questions(id),
    FOREIGN KEY (user_id) REFERENCES users(id)
);

INSERT INTO 
    question_likes (question_id, user_id)
VALUES  
    (2, 1),
    (2, 2),
    (1, 4);

