USE social_connect_db;

START TRANSACTION;

SAVEPOINT before_post_creation;

-- 1. Create a new post
INSERT INTO Post (user_id, content, visibility) 
VALUES (1, 'Just discovered a new hidden library! #adventure #exploring', 'public');

-- Get the ID of the newly inserted post
SET @new_post_id = LAST_INSERT_ID();

-- 2. Insert tags, ignoring duplicate errors
INSERT INTO HashTag (tag_name) VALUES ('adventure') ON DUPLICATE KEY UPDATE tag_name=tag_name;
INSERT INTO HashTag (tag_name) VALUES ('exploring') ON DUPLICATE KEY UPDATE tag_name=tag_name;

-- 3. Link post and tags in the junction table
INSERT INTO Post_HashTag (post_id, hashtag_id) 
SELECT @new_post_id, hashtag_id FROM HashTag WHERE tag_name IN ('adventure', 'exploring');

COMMIT;