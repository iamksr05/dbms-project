# NexusNet: Relational Database System Capstone Project Report

NexusNet is a relational database-driven social network featuring member registration, publication shares, responses, upvotes, direct messaging, keyword indexing, and spaces enrollment.

The system is implemented on **MySQL** as the backend database, paired with a web frontend client.

---

## 1. Relational Schema & Attribute Mapping

The database schema maps all entity relationships cleanly while preserving integrity.

### Relational Schema (Textual Form)
Primary Keys are denoted by **PK**, Foreign Keys by **FK**, and composite keys are bracketed.

*   **Member** (<u>member_id</u>, handle, email, pass_hash, summary, birth_date, registered_at, account_status)
*   **Member_Contact** (<u>member_id (FK)</u>, <u>contact_no</u>)
*   **Publication** (<u>pub_id</u>, author_id (FK), body_text, attachment_url, published_at, view_scope)
*   **Response** (<u>response_id</u>, pub_id (FK), responder_id (FK), response_text, responded_at)
*   **Chat_Message** (<u>msg_id</u>, sender_member_id (FK), receiver_member_id (FK), msg_content, sent_at)
*   **Space** (<u>space_id</u>, space_title, space_desc, space_created_at)
*   **Keyword** (<u>keyword_id</u>, keyword_name)
*   **Subscription** (<u>[subscriber_id (FK), publisher_id (FK)]</u>, subscribed_at)
*   **Upvote** (<u>[voter_id (FK), pub_id (FK)]</u>, upvoted_at)
*   **Publication_Keyword** (<u>[pub_id (FK), keyword_id (FK)]</u>)
*   **Space_Enrollment** (<u>[member_id (FK), space_id (FK)]</u>, enrolled_at)

### E-R Diagram to Schema Mapping
*   **Member Contacts:** The multivalued attribute `contact_no` on the `Member` entity is mapped to a dedicated table `Member_Contact` to comply with First Normal Form (1NF).
*   **Subscriptions:** The recursive M:N subscription relationship (followers/following) is resolved via the `Subscription` junction table.
*   **Upvotes / Keywords / Enrollments:** All M:N relationships are resolved via junction tables (`Upvote`, `Publication_Keyword`, `Space_Enrollment`).

---

## 2. Data Dictionary

### Table: Member
Stores primary registration accounts.

| Column Name | Data Type | Constraints | Description |
| :--- | :--- | :--- | :--- |
| `member_id` | `INT` | PK, AUTO_INCREMENT | Unique identifier for each member |
| `handle` | `VARCHAR(50)` | UNIQUE, NOT NULL | Unique username handle |
| `email` | `VARCHAR(100)` | UNIQUE, NOT NULL | Account email address |
| `pass_hash` | `VARCHAR(255)` | NOT NULL | Hashed password |
| `summary` | `TEXT` | NULL | Bio statement |
| `birth_date` | `DATE` | NOT NULL | Birth date |
| `registered_at` | `DATETIME` | DEFAULT CURRENT_TIMESTAMP | Account creation date |
| `account_status` | `ENUM` | DEFAULT 'active' | Account state: 'active', 'suspended', 'deactivated' |

### Table: Member_Contact
Handles phone numbers (multivalued attribute).

| Column Name | Data Type | Constraints | Description |
| :--- | :--- | :--- | :--- |
| `member_id` | `INT` | PK, FK (Member.member_id) ON DELETE CASCADE | Associated member |
| `contact_no` | `VARCHAR(15)` | PK, NOT NULL | Phone contact value |

### Table: Publication
Stores updates/posts.

| Column Name | Data Type | Constraints | Description |
| :--- | :--- | :--- | :--- |
| `pub_id` | `INT` | PK, AUTO_INCREMENT | Unique publication identifier |
| `author_id` | `INT` | FK (Member.member_id) ON DELETE CASCADE | Author reference |
| `body_text` | `TEXT` | NOT NULL | Body content |
| `attachment_url` | `VARCHAR(255)` | NULL | Optional media file path |
| `published_at` | `DATETIME` | DEFAULT CURRENT_TIMESTAMP | Published time |
| `view_scope` | `ENUM` | DEFAULT 'public' | Visibility scope: 'public', 'private', 'connections' |

### Table: Response
Stores comments on publications.

| Column Name | Data Type | Constraints | Description |
| :--- | :--- | :--- | :--- |
| `response_id` | `INT` | PK, AUTO_INCREMENT | Unique response identifier |
| `pub_id` | `INT` | FK (Publication.pub_id) ON DELETE CASCADE | Publication commented on |
| `responder_id` | `INT` | FK (Member.member_id) ON DELETE CASCADE | Commenter member |
| `response_text` | `TEXT` | NOT NULL | Comments content |
| `responded_at` | `DATETIME` | DEFAULT CURRENT_TIMESTAMP | Responded time |

### Table: Chat_Message
Stores direct conversations.

| Column Name | Data Type | Constraints | Description |
| :--- | :--- | :--- | :--- |
| `msg_id` | `INT` | PK, AUTO_INCREMENT | Unique message identifier |
| `sender_member_id` | `INT` | FK (Member.member_id) ON DELETE CASCADE | Sender |
| `receiver_member_id`| `INT` | FK (Member.member_id) ON DELETE CASCADE | Receiver |
| `msg_content` | `TEXT` | NOT NULL | Message body |
| `sent_at` | `DATETIME` | DEFAULT CURRENT_TIMESTAMP | Sent timestamp |

### Table: Space
Stores user communities.

| Column Name | Data Type | Constraints | Description |
| :--- | :--- | :--- | :--- |
| `space_id` | `INT` | PK, AUTO_INCREMENT | Unique space identifier |
| `space_title` | `VARCHAR(100)` | NOT NULL | Title of the space |
| `space_desc` | `VARCHAR(600)` | NULL | Group description |
| `space_created_at` | `DATETIME` | DEFAULT CURRENT_TIMESTAMP | Space creation time |

### Table: Keyword
Stores hashtags/keywords.

| Column Name | Data Type | Constraints | Description |
| :--- | :--- | :--- | :--- |
| `keyword_id` | `INT` | PK, AUTO_INCREMENT | Unique keyword identifier |
| `keyword_name` | `VARCHAR(50)` | UNIQUE, NOT NULL | Keyword label |

### Table: Subscription (Junction)
Maps the recursive connections relationship.

| Column Name | Data Type | Constraints | Description |
| :--- | :--- | :--- | :--- |
| `subscriber_id` | `INT` | PK, FK (Member.member_id) ON DELETE CASCADE | Following user |
| `publisher_id` | `INT` | PK, FK (Member.member_id) ON DELETE CASCADE | Followed user |
| `subscribed_at` | `DATETIME` | DEFAULT CURRENT_TIMESTAMP | Follow date |

### Table: Upvote (Junction)
Maps the appreciation relationship.

| Column Name | Data Type | Constraints | Description |
| :--- | :--- | :--- | :--- |
| `voter_id` | `INT` | PK, FK (Member.member_id) ON DELETE CASCADE | Upvoting user |
| `pub_id` | `INT` | PK, FK (Publication.pub_id) ON DELETE CASCADE | Upvoted post |
| `upvoted_at` | `DATETIME` | DEFAULT CURRENT_TIMESTAMP | Upvote timestamp |

### Table: Publication_Keyword (Junction)
Maps keywords associated with publications.

| Column Name | Data Type | Constraints | Description |
| :--- | :--- | :--- | :--- |
| `pub_id` | `INT` | PK, FK (Publication.pub_id) ON DELETE CASCADE | Publication |
| `keyword_id` | `INT` | PK, FK (Keyword.keyword_id) ON DELETE CASCADE | Keyword |

### Table: Space_Enrollment (Junction)
Maps user community enrollments.

| Column Name | Data Type | Constraints | Description |
| :--- | :--- | :--- | :--- |
| `member_id` | `INT` | PK, FK (Member.member_id) ON DELETE CASCADE | Enrolled user |
| `space_id` | `INT` | PK, FK (Space.space_id) ON DELETE CASCADE | Enrolled group |
| `enrolled_at` | `DATETIME` | DEFAULT CURRENT_TIMESTAMP | Join date |

---

## 3. Cardinality & Participation Constraints

1.  **Creates (Member [1] ─── Creates ─── [N] Publication):**
    *   *Cardinality:* A member can share zero or many publications. A publication belongs to exactly one member.
    *   *Participation:* Member: Partial. Publication: Total.
2.  **Writes (Member [1] ─── Writes ─── [N] Response):**
    *   *Cardinality:* A member can write zero or many responses. A response belongs to exactly one member.
    *   *Participation:* Member: Partial. Response: Total.
3.  **on (Publication [1] ─── on ─── [N] Response):**
    *   *Cardinality:* A publication can have zero or many responses. A response must belong to one publication.
    *   *Participation:* Publication: Partial. Response: Total.
4.  **Upvote (Member [M] ─── Upvote ─── [N] Publication):**
    *   *Cardinality:* A member can upvote many publications. A publication can be upvoted by many members.
    *   *Participation:* Member: Partial. Publication: Partial.
5.  **Contains (Keyword [M] ─── Contains ─── [N] Publication):**
    *   *Cardinality:* A keyword can index many publications. A publication can contain many keywords.
    *   *Participation:* Keyword: Partial. Publication: Partial.
6.  **Subscription (Member [M] ─── Subscribes ─── [N] Member) [Recursive]:**
    *   *Cardinality:* A member can subscribe to many publishers. A publisher can be subscribed to by many members.
    *   *Participation:* Member: Partial.
7.  **Direct Messaging (Member [1] ─── Sends/Receives ─── [N] Chat_Message):**
    *   *Cardinality:* A member can send/receive many messages. A message has exactly one sender and one receiver.
    *   *Participation:* Member: Partial. Chat_Message: Total.
8.  **Space Enrollment (Member [N] ─── Enrollment ─── [M] Space):**
    *   *Cardinality:* A member can enroll in many spaces. A space can contain many members.
    *   *Participation:* Member: Partial. Space: Partial.

---

## 4. Normalization Proof

### First Normal Form (1NF)
*   **Rule:** Atomic columns, primary keys defined.
*   **Proof:** Every table has a primary key. Multivalued attributes like `contact_no` are extracted into `Member_Contact` so that every attribute contains atomic values.

### Second Normal Form (2NF)
*   **Rule:** In 1NF, no partial dependency (non-key columns must depend on the full primary key).
*   **Proof:** Tables with single-column keys are automatically in 2NF. Composite tables (`Subscription`, `Upvote`, `Publication_Keyword`, `Space_Enrollment`, `Member_Contact`) only contain attributes (`subscribed_at`, `upvoted_at`, `enrolled_at`) that functionally depend on the combined keys.

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
