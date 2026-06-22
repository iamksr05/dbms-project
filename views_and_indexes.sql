USE social_connect_db;

-- 1. VIEW: Get count of posts per user
CREATE OR REPLACE VIEW vw_user_post_count AS
SELECT 
    u.user_id, 
    u.username, 
    COUNT(p.post_id) AS total_posts
FROM User u
LEFT JOIN Post p ON u.user_id = p.user_id
GROUP BY u.user_id;

-- 2. VIEW: Extract popular posts with more than 5 likes
CREATE OR REPLACE VIEW vw_popular_posts AS
SELECT 
    p.post_id, 
    p.content, 
    u.username AS author,
    COUNT(l.user_id) AS like_count
FROM Post p
JOIN User u ON p.user_id = u.user_id
JOIN Likes l ON p.post_id = l.post_id
GROUP BY p.post_id
HAVING like_count > 5;

-- 3. VIEW: Find active users who have posted, commented, or liked in the last 30 days
CREATE OR REPLACE VIEW vw_active_users AS
SELECT DISTINCT u.user_id, u.username
FROM User u
WHERE u.user_id IN (
    SELECT user_id FROM Post WHERE created_at >= DATE_SUB(NOW(), INTERVAL 30 DAY)
    UNION
    SELECT user_id FROM Comment WHERE created_at >= DATE_SUB(NOW(), INTERVAL 30 DAY)
    UNION
    SELECT user_id FROM Likes WHERE liked_at >= DATE_SUB(NOW(), INTERVAL 30 DAY)
);

-- 4. VIEW: Aggregate hashtags for each post as a comma-separated list
CREATE OR REPLACE VIEW vw_post_hashtags AS
SELECT 
    p.post_id, 
    p.content,
    GROUP_CONCAT(h.tag_name ORDER BY h.tag_name SEPARATOR ', ') AS hashtags
FROM Post p
LEFT JOIN Post_HashTag ph ON p.post_id = ph.post_id
LEFT JOIN HashTag h ON ph.hashtag_id = h.hashtag_id
GROUP BY p.post_id;

-- 5. INDEXES for optimizing search, join, and foreign key query performance
CREATE INDEX idx_post_user_id ON Post(user_id);
CREATE INDEX idx_comment_post_id ON Comment(post_id);
CREATE INDEX idx_follows_followee_id ON Follows(followee_id);
CREATE INDEX idx_message_receiver_id ON Message(receiver_id);