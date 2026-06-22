# SocialConnect: Relational Database System Capstone Project Report

SocialConnect is a relational database-driven social network featuring user registration, posts, comments, likes, direct messaging, hashtag indexing, and group participation.

The system is implemented on **MySQL** as the backend database, paired with a web frontend client.

---

## 1. Relational Schema & Attribute Mapping

The database schema maps all entity relationships cleanly while preserving integrity.

### Relational Schema (Textual Form)
Primary Keys are denoted by **PK**, Foreign Keys by **FK**, and composite keys are bracketed.

*   **User** (<u>user_id</u>, username, email, password, bio, d_o_b, join_date, account_status)
*   **User_Phone** (<u>user_id (FK)</u>, <u>phone_no</u>)
*   **Post** (<u>post_id</u>, user_id (FK), content, media_url, created_at, visibility)
*   **Comment** (<u>comment_id</u>, post_id (FK), user_id (FK), comment_text, created_at)
*   **Message** (<u>message_id</u>, sender_id (FK), receiver_id (FK), message_text, sent_time)
*   **User_Group** (<u>group_id</u>, group_name, description, created_on)
*   **HashTag** (<u>hashtag_id</u>, tag_name)
*   **Follows** (<u>[user_id (FK), followee_id (FK)]</u>, follow_date)
*   **Likes** (<u>[user_id (FK), post_id (FK)]</u>, liked_at)
*   **Post_HashTag** (<u>[post_id (FK), hashtag_id (FK)]</u>)
*   **Group_Member** (<u>[user_id (FK), group_id (FK)]</u>, join_date)

### E-R Diagram to Schema Mapping
*   **User Contacts:** The multivalued attribute `phone_no` on the `User` entity is mapped to a dedicated table `User_Phone` to comply with First Normal Form (1NF).
*   **Followers:** The recursive M:N subscription relationship (followers/following) is resolved via the `Follows` junction table.
*   **Likes / HashTags / Group Members:** All M:N relationships are resolved via junction tables (`Likes`, `Post_HashTag`, `Group_Member`).

---

## 2. Data Dictionary

### Table: User
Stores primary user accounts.

| Column Name | Data Type | Constraints | Description |
| :--- | :--- | :--- | :--- |
| `user_id` | `INT` | PK, AUTO_INCREMENT | Unique identifier for each user |
| `username` | `VARCHAR(50)` | UNIQUE, NOT NULL | Unique username handle |
| `email` | `VARCHAR(100)` | UNIQUE, NOT NULL | Account email address |
| `password` | `VARCHAR(255)` | NOT NULL | Hashed password |
| `bio` | `TEXT` | NULL | Bio statement |
| `d_o_b` | `DATE` | NOT NULL | Birth date |
| `join_date` | `DATETIME` | DEFAULT CURRENT_TIMESTAMP | Account creation date |
| `account_status` | `ENUM` | DEFAULT 'active' | Account state: 'active', 'suspended', 'deactivated' |

### Table: User_Phone
Handles phone numbers (multivalued attribute).

| Column Name | Data Type | Constraints | Description |
| :--- | :--- | :--- | :--- |
| `user_id` | `INT` | PK, FK (User.user_id) ON DELETE CASCADE | Associated user |
| `phone_no` | `VARCHAR(15)` | PK, NOT NULL | Phone contact value |

### Table: Post
Stores updates/posts.

| Column Name | Data Type | Constraints | Description |
| :--- | :--- | :--- | :--- |
| `post_id` | `INT` | PK, AUTO_INCREMENT | Unique post identifier |
| `user_id` | `INT` | FK (User.user_id) ON DELETE CASCADE | Author reference |
| `content` | `TEXT` | NOT NULL | Post text content |
| `media_url` | `VARCHAR(255)` | NULL | Optional media file path |
| `created_at` | `DATETIME` | DEFAULT CURRENT_TIMESTAMP | Published time |
| `visibility` | `ENUM` | DEFAULT 'public' | Visibility settings: 'public', 'private', 'friends' |

### Table: Comment
Stores comments on posts.

| Column Name | Data Type | Constraints | Description |
| :--- | :--- | :--- | :--- |
| `comment_id` | `INT` | PK, AUTO_INCREMENT | Unique comment identifier |
| `post_id` | `INT` | FK (Post.post_id) ON DELETE CASCADE | Post commented on |
| `user_id` | `INT` | FK (User.user_id) ON DELETE CASCADE | Commenter user |
| `comment_text` | `TEXT` | NOT NULL | Comments content |
| `created_at` | `DATETIME` | DEFAULT CURRENT_TIMESTAMP | Commented time |

### Table: Message
Stores direct conversations.

| Column Name | Data Type | Constraints | Description |
| :--- | :--- | :--- | :--- |
| `message_id` | `INT` | PK, AUTO_INCREMENT | Unique message identifier |
| `sender_id` | `INT` | FK (User.user_id) ON DELETE CASCADE | Sender |
| `receiver_id` | `INT` | FK (User.user_id) ON DELETE CASCADE | Receiver |
| `message_text` | `TEXT` | NOT NULL | Message body |
| `sent_time` | `DATETIME` | DEFAULT CURRENT_TIMESTAMP | Sent timestamp |

### Table: User_Group
Stores user communities.

| Column Name | Data Type | Constraints | Description |
| :--- | :--- | :--- | :--- |
| `group_id` | `INT` | PK, AUTO_INCREMENT | Unique group identifier |
| `group_name` | `VARCHAR(100)` | NOT NULL | Title of the group |
| `description` | `VARCHAR(600)` | NULL | Group description |
| `created_on` | `DATETIME` | DEFAULT CURRENT_TIMESTAMP | Group creation time |

### Table: HashTag
Stores hashtags.

| Column Name | Data Type | Constraints | Description |
| :--- | :--- | :--- | :--- |
| `hashtag_id` | `INT` | PK, AUTO_INCREMENT | Unique hashtag identifier |
| `tag_name` | `VARCHAR(50)` | UNIQUE, NOT NULL | Hashtag label |

### Table: Follows (Junction)
Maps the recursive connections relationship.

| Column Name | Data Type | Constraints | Description |
| :--- | :--- | :--- | :--- |
| `user_id` | `INT` | PK, FK (User.user_id) ON DELETE CASCADE | Following user |
| `followee_id` | `INT` | PK, FK (User.user_id) ON DELETE CASCADE | Followed user |
| `follow_date` | `DATETIME` | DEFAULT CURRENT_TIMESTAMP | Follow date |

### Table: Likes (Junction)
Maps the appreciation relationship.

| Column Name | Data Type | Constraints | Description |
| :--- | :--- | :--- | :--- |
| `user_id` | `INT` | PK, FK (User.user_id) ON DELETE CASCADE | Liking user |
| `post_id` | `INT` | PK, FK (Post.post_id) ON DELETE CASCADE | Liked post |
| `liked_at` | `DATETIME` | DEFAULT CURRENT_TIMESTAMP | Like timestamp |

### Table: Post_HashTag (Junction)
Maps hashtags associated with posts.

| Column Name | Data Type | Constraints | Description |
| :--- | :--- | :--- | :--- |
| `post_id` | `INT` | PK, FK (Post.post_id) ON DELETE CASCADE | Post |
| `hashtag_id` | `INT` | PK, FK (HashTag.hashtag_id) ON DELETE CASCADE | Hashtag |

### Table: Group_Member (Junction)
Maps user community memberships.

| Column Name | Data Type | Constraints | Description |
| :--- | :--- | :--- | :--- |
| `user_id` | `INT` | PK, FK (User.user_id) ON DELETE CASCADE | Member user |
| `group_id` | `INT` | PK, FK (User_Group.group_id) ON DELETE CASCADE | Enrolled group |
| `join_date` | `DATETIME` | DEFAULT CURRENT_TIMESTAMP | Join date |

---

## 3. Cardinality & Participation Constraints

1.  **Creates (User [1] ─── Creates ─── [N] Post):**
    *   *Cardinality:* A user can create zero or many posts. A post belongs to exactly one user.
    *   *Participation:* User: Partial. Post: Total.
2.  **Writes (User [1] ─── Writes ─── [N] Comment):**
    *   *Cardinality:* A user can write zero or many comments. A comment belongs to exactly one user.
    *   *Participation:* User: Partial. Comment: Total.
3.  **on (Post [1] ─── on ─── [N] Comment):**
    *   *Cardinality:* A post can have zero or many comments. A comment must belong to one post.
    *   *Participation:* Post: Partial. Comment: Total.
4.  **Likes (User [M] ─── Likes ─── [N] Post):**
    *   *Cardinality:* A user can like many posts. A post can be liked by many users.
    *   *Participation:* User: Partial. Post: Partial.
5.  **Contains (HashTag [M] ─── Contains ─── [N] Post):**
    *   *Cardinality:* A hashtag can index many posts. A post can contain many hashtags.
    *   *Participation:* HashTag: Partial. Post: Partial.
6.  **Follows (User [M] ─── Follows ─── [N] User) [Recursive]:**
    *   *Cardinality:* A user can follow many users. A user can be followed by many users.
    *   *Participation:* User: Partial.
7.  **Direct Messaging (User [1] ─── Sends/Receives ─── [N] Message):**
    *   *Cardinality:* A user can send/receive many messages. A message has exactly one sender and one receiver.
    *   *Participation:* User: Partial. Message: Total.
8.  **Group Membership (User [N] ─── Joins ─── [M] User_Group):**
    *   *Cardinality:* A user can join many groups. A group can contain many users.
    *   *Participation:* User: Partial. User_Group: Partial.

---

## 4. Normalization Proof

### First Normal Form (1NF)
*   **Rule:** Atomic columns, primary keys defined.
*   **Proof:** Every table has a primary key. Multivalued attributes like `phone_no` are extracted into `User_Phone` so that every attribute contains atomic values.

### Second Normal Form (2NF)
*   **Rule:** In 1NF, no partial dependency (non-key columns must depend on the full primary key).
*   **Proof:** Tables with single-column keys are automatically in 2NF. Composite tables (`Follows`, `Likes`, `Post_HashTag`, `Group_Member`, `User_Phone`) only contain attributes (`follow_date`, `liked_at`, `join_date`) that functionally depend on the combined keys.

### Third Normal Form (3NF)
*   **Rule:** In 2NF, no transitive dependencies.
*   **Proof:** In all tables, non-key columns functionally depend directly on the primary key, with no intermediate non-key dependencies.

---

## 5. MySQL Implementation & Setup Instructions

To execute and test the database system, load these files in order in your MySQL server:

```bash
# 1. Recreate schema database
mysql -u [username] -p < social_media_db.sql

# 2. Populate fresh seed data
mysql -u [username] -p < seed_data.sql

# 3. Compile views and indexes
mysql -u [username] -p < views_and_indexes.sql

# 4. Run Transaction demo scripts
mysql -u [username] -p < transaction_demo.sql

# 5. Run analytical queries
mysql -u [username] -p < queries.sql
```
