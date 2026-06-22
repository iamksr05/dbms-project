USE social_connect_db;

-- 1. JOIN QUERY: Retrieve posts alongside their authors and total likes
SELECT 
    p.post_id, 
    u.username AS author, 
    p.content, 
    COUNT(l.user_id) AS like_count
FROM Post p
JOIN User u ON p.user_id = u.user_id
LEFT JOIN Likes l ON p.post_id = l.post_id
GROUP BY p.post_id;

-- 2. JOIN QUERY: List comments on a specific post (e.g., post_id = 1)
SELECT 
    c.comment_id, 
    u.username AS commenter, 
    c.comment_text, 
    c.created_at
FROM Comment c
JOIN User u ON c.user_id = u.user_id
WHERE c.post_id = 1;

-- 3. JOIN QUERY: Fetch followers of a specific user (e.g., followee_id = 20)
SELECT 
    f.user_id AS follower_id, 
    u.username AS follower_name
FROM Follows f
JOIN User u ON f.user_id = u.user_id
WHERE f.followee_id = 20;

-- 4. JOIN QUERY: Retrieve users enrolled in a specific group
SELECT 
    u.username, 
    g.group_name
FROM Group_Member gm
JOIN User u ON gm.user_id = u.user_id
JOIN User_Group g ON gm.group_id = g.group_id
WHERE g.group_name = 'Tech & Innovation';

-- 5. JOIN QUERY: Find hashtags used by a specific user in their posts
SELECT DISTINCT 
    h.tag_name
FROM User u
JOIN Post p ON u.user_id = p.user_id
JOIN Post_HashTag ph ON p.post_id = ph.post_id
JOIN HashTag h ON ph.hashtag_id = h.hashtag_id
WHERE u.username = 'writer_wendy';

-- 6. GROUP BY & HAVING QUERY: Find users with more than 3 posts
SELECT 
    u.username, 
    COUNT(p.post_id) AS post_count
FROM User u
JOIN Post p ON u.user_id = p.user_id
GROUP BY u.user_id
HAVING post_count > 3;

-- 7. GROUP BY QUERY: Order posts by like count
SELECT 
    p.post_id, 
    p.content, 
    COUNT(l.user_id) AS like_count
FROM Post p
LEFT JOIN Likes l ON p.post_id = l.post_id
GROUP BY p.post_id
ORDER BY like_count DESC;

-- 8. GROUP BY QUERY: Get number of members for each group
SELECT 
    g.group_name, 
    COUNT(gm.user_id) AS member_count
FROM User_Group g
LEFT JOIN Group_Member gm ON g.group_id = gm.group_id
GROUP BY g.group_id;

-- 9. AGGREGATE FUNCTION QUERY: Average comment count per post
SELECT 
    AVG(comment_count) AS avg_comments_per_post
FROM (
    SELECT COUNT(c.comment_id) AS comment_count
    FROM Post p
    LEFT JOIN Comment c ON p.post_id = c.post_id
    GROUP BY p.post_id
) AS counts;

-- 10. AGGREGATE FUNCTION QUERY: Most popular hashtags ordered by usage
SELECT 
    h.tag_name, 
    COUNT(ph.post_id) AS usage_count
FROM HashTag h
LEFT JOIN Post_HashTag ph ON h.hashtag_id = ph.hashtag_id
GROUP BY h.hashtag_id
ORDER BY usage_count DESC;

-- 11. NESTED QUERY: Identify users who have not posted any content
SELECT username 
FROM User 
WHERE user_id NOT IN (SELECT DISTINCT user_id FROM Post);

-- 12. NESTED QUERY: Find user(s) with the highest follower count
SELECT u.username, COUNT(f.user_id) AS follower_count
FROM User u
JOIN Follows f ON u.user_id = f.followee_id
GROUP BY u.user_id
HAVING follower_count = (
    SELECT MAX(cnt) 
    FROM (SELECT COUNT(user_id) as cnt FROM Follows GROUP BY followee_id) AS counts
);

-- 13. NESTED QUERY: Get posts with likes strictly above average
SELECT post_id, content 
FROM Post 
WHERE post_id IN (
    SELECT post_id 
    FROM Likes 
    GROUP BY post_id 
    HAVING COUNT(user_id) > (
        SELECT AVG(like_count) 
        FROM (SELECT COUNT(user_id) as like_count FROM Likes GROUP BY post_id) AS avg_likes
    )
);

-- 14. NESTED QUERY (NOT EXISTS): Find follows that are not reciprocated
SELECT u.username AS user, f.followee_id AS followed_user_id
FROM Follows f
JOIN User u ON f.user_id = u.user_id
WHERE NOT EXISTS (
    SELECT 1 FROM Follows f2 
    WHERE f2.user_id = f.followee_id AND f2.followee_id = f.user_id
);

-- 15. JOIN QUERY: Retrieve messages exchanged between User 1 and User 2
SELECT 
    m.message_text, 
    m.sent_time, 
    u1.username AS sender, 
    u2.username AS receiver
FROM Message m
JOIN User u1 ON m.sender_id = u1.user_id
JOIN User u2 ON m.receiver_id = u2.user_id
WHERE (m.sender_id = 1 AND m.receiver_id = 2) 
   OR (m.sender_id = 2 AND m.receiver_id = 1)
ORDER BY m.sent_time;

-- 16. JOIN QUERY: Get posts from followed users (visibility check)
SELECT p.* 
FROM Post p
JOIN Follows f ON p.user_id = f.followee_id
WHERE f.user_id = 1 AND p.visibility = 'public';

-- 17. NESTED QUERY: Suggest connections (second-degree follows)
SELECT DISTINCT f2.followee_id, u.username
FROM Follows f1
JOIN Follows f2 ON f1.followee_id = f2.user_id
JOIN User u ON f2.followee_id = u.user_id
WHERE f1.user_id = 1 
  AND f2.followee_id != 1
  AND f2.followee_id NOT IN (SELECT followee_id FROM Follows WHERE user_id = 1);


-- =========================================================================
-- ADDITIONAL DDL & DML OPERATIONS (As required by College Guidelines)
-- =========================================================================

-- 1. ALTER OPERATIONS
-- A. Add an account_status column to the User table
ALTER TABLE User ADD COLUMN account_status ENUM('active', 'suspended', 'deactivated') DEFAULT 'active';

-- B. Modify the description column in User_Group to have a larger character capacity
ALTER TABLE User_Group MODIFY COLUMN description VARCHAR(600) NULL;

-- C. Add a check constraint to the Post table to ensure content is not empty
ALTER TABLE Post ADD CONSTRAINT chk_content_length CHECK (CHAR_LENGTH(content) > 0);


-- 2. UPDATE OPERATIONS
-- A. Update a user's bio
UPDATE User 
SET bio = 'Dave Miller: Software engineer building the future.' 
WHERE username = 'dev_dave';

-- B. Update a group's description
UPDATE User_Group 
SET description = 'The absolute best space for discussing technology, web dev, database systems, and innovation.' 
WHERE group_name = 'Tech & Innovation';

-- C. Update a post's visibility
UPDATE Post 
SET visibility = 'friends' 
WHERE post_id = 1 AND user_id = 1;


-- 3. DELETE OPERATIONS
-- A. Delete a specific comment
DELETE FROM Comment 
WHERE comment_id = 5;

-- B. Delete a hashtag that is no longer used
DELETE FROM HashTag 
WHERE tag_name = 'cooking';

-- C. Delete a User to demonstrate CASCADE DELETE in action
-- This automatically deletes the user's phone entries, posts, comments, likes, follows, messages, and group memberships.
DELETE FROM User 
WHERE username = 'fitness_fiona';