CREATE DATABASE IF NOT EXISTS social_connect_db;
USE social_connect_db;

CREATE TABLE User (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    bio TEXT NULL,
    d_o_b DATE NOT NULL,
    join_date DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE User_Phone (
    user_id INT NOT NULL,
    phone_no VARCHAR(15) NOT NULL,
    PRIMARY KEY (user_id, phone_no),
    FOREIGN KEY (user_id) REFERENCES User(user_id) ON DELETE CASCADE
);

CREATE TABLE Post (
    post_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    content TEXT NOT NULL,
    media_url VARCHAR(255) NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    visibility ENUM('public', 'private', 'friends') DEFAULT 'public',
    FOREIGN KEY (user_id) REFERENCES User(user_id) ON DELETE CASCADE
);

CREATE TABLE Comment (
    comment_id INT PRIMARY KEY AUTO_INCREMENT,
    post_id INT NOT NULL,
    user_id INT NOT NULL,
    comment_text TEXT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (post_id) REFERENCES Post(post_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES User(user_id) ON DELETE CASCADE
);

CREATE TABLE Message (
    message_id INT PRIMARY KEY AUTO_INCREMENT,
    sender_id INT NOT NULL,
    receiver_id INT NOT NULL,
    message_text TEXT NOT NULL,
    sent_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (sender_id) REFERENCES User(user_id) ON DELETE CASCADE,
    FOREIGN KEY (receiver_id) REFERENCES User(user_id) ON DELETE CASCADE
);

CREATE TABLE User_Group (
    group_id INT PRIMARY KEY AUTO_INCREMENT,
    group_name VARCHAR(100) NOT NULL,
    description TEXT NULL,
    created_on DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE HashTag (
    hashtag_id INT PRIMARY KEY AUTO_INCREMENT,
    tag_name VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE Follows (
    user_id INT NOT NULL,
    followee_id INT NOT NULL,
    follow_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (user_id, followee_id),
    FOREIGN KEY (user_id) REFERENCES User(user_id) ON DELETE CASCADE,
    FOREIGN KEY (followee_id) REFERENCES User(user_id) ON DELETE CASCADE,
    CONSTRAINT check_self_follow CHECK (user_id != followee_id)
);

CREATE TABLE Likes (
    user_id INT NOT NULL,
    post_id INT NOT NULL,
    liked_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (user_id, post_id),
    FOREIGN KEY (user_id) REFERENCES User(user_id) ON DELETE CASCADE,
    FOREIGN KEY (post_id) REFERENCES Post(post_id) ON DELETE CASCADE
);

CREATE TABLE Post_HashTag (
    post_id INT NOT NULL,
    hashtag_id INT NOT NULL,
    PRIMARY KEY (post_id, hashtag_id),
    FOREIGN KEY (post_id) REFERENCES Post(post_id) ON DELETE CASCADE,
    FOREIGN KEY (hashtag_id) REFERENCES HashTag(hashtag_id) ON DELETE CASCADE
);

CREATE TABLE Group_Member (
    user_id INT NOT NULL,
    group_id INT NOT NULL,
    join_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (user_id, group_id),
    FOREIGN KEY (user_id) REFERENCES User(user_id) ON DELETE CASCADE,
    FOREIGN KEY (group_id) REFERENCES User_Group(group_id) ON DELETE CASCADE
);