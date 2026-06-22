const users = [
    { id: 1, username: 'dev_dave', bio: 'Software developer building the future.', join_date: '2023-01-10', followers: 3, following: 3 },
    { id: 2, username: 'fitness_fiona', bio: 'Personal trainer & nutrition advisor.', join_date: '2023-01-15', followers: 5, following: 3 },
    { id: 3, username: 'travel_trevor', bio: 'Exploring the world, one city at a time.', join_date: '2023-02-01', followers: 5, following: 3 }
];

const posts = [
    {
        id: 1,
        user_id: 1,
        author: 'dev_dave',
        content: 'Excited to start building our new product today!',
        likes: 6,
        comments: [
            { user: 'fitness_fiona', text: 'Best of luck with the startup Dave!' },
            { user: 'chef_clara', text: 'Excellent post!' }
        ],
        hashtags: ['#coding', '#startup']
    },
    {
        id: 2,
        user_id: 2,
        author: 'fitness_fiona',
        content: 'Morning run complete! Feeling energized.',
        likes: 8,
        comments: [
            { user: 'dev_dave', text: 'Inspirational, Fiona. I need to run too.' },
            { user: 'chef_clara', text: 'Work hard, play hard.' }
        ],
        hashtags: ['#fitness', '#running']
    },
    {
        id: 18,
        user_id: 18,
        author: 'code_cody',
        content: 'Studying for my database exam. SQL joins are interesting!',
        likes: 5,
        comments: [
            { user: 'dev_dave', text: 'Keep practicing, Cody. It gets easier!' },
            { user: 'fitness_fiona', text: 'Joins are indeed powerful.' }
        ],
        hashtags: ['#database', '#coding']
    }
];

const hashtags = [
    { tag: '#coding', count: 18 },
    { tag: '#fitness', count: 5 },
    { tag: '#photography', count: 3 },
    { tag: '#writing', count: 3 },
    { tag: '#database', count: 2 }
];

let groups = [
    {
        id: 1,
        name: 'Tech & Innovation',
        description: 'A community for discussing software, hardware, and start-ups.',
        members: ['dev_dave', 'design_diana', 'science_sam', 'gamer_gary', 'code_cody']
    },
    {
        id: 2,
        name: 'Active Lifestyles',
        description: 'Sharing recipes, workouts, hiking trails, and health goals.',
        members: ['fitness_fiona', 'travel_trevor', 'nature_nate', 'pets_penny', 'yoga_yara']
    },
    {
        id: 3,
        name: 'Creative Minds',
        description: 'Everything about painting, writing, photography, and design.',
        members: ['design_diana', 'photo_phil', 'art_alice', 'writer_wendy']
    }
];

function renderNavbar() {
    const navbar = `
        <div class="logo">SocialConnect</div>
        <div class="nav-links">
            <a href="index.html">Feed</a>
            <a href="explore.html">Explore</a>
            <a href="groups.html">Groups</a>
            <a href="profile.html">Profile</a>
        </div>
    `;
    const navEl = document.getElementById('navbar');
    if (navEl) navEl.innerHTML = navbar;
}

function renderPost(post) {
    return `
        <div class="card" id="post-${post.id}">
            <div class="post-header">
                <div class="avatar">${post.author[0].toUpperCase()}</div>
                <div class="post-user">@${post.author}</div>
            </div>
            <div class="post-content">
                <p>${post.content}</p>
                <div style="color: var(--accent); margin-top: 0.5rem; font-weight: 500;">${post.hashtags ? post.hashtags.join(' ') : ''}</div>
            </div>
            <div class="post-footer">
                <div class="action-btn" onclick="likePost(${post.id})">❤️ <span id="likes-${post.id}">${post.likes}</span> Likes</div>
                <div class="action-btn" onclick="toggleComments(${post.id})">💬 ${post.comments.length} Comments</div>
            </div>
            <div id="comments-${post.id}" style="display: none; margin-top: 1rem; border-top: 1px solid var(--border); padding-top: 1rem;">
                <div id="comment-list-${post.id}">
                    ${post.comments.map(c => `
                        <div style="margin-bottom: 0.8rem; font-size: 0.95rem;">
                            <strong>@${c.user}:</strong> <span style="color: var(--text-secondary);">${c.text}</span>
                        </div>
                    `).join('')}
                </div>
                <div style="display: flex; gap: 0.5rem; margin-top: 1rem;">
                    <input type="text" id="new-comment-${post.id}" placeholder="Write a comment..." style="padding: 0.5rem;">
                    <button class="btn" onclick="addComment(${post.id})">Post</button>
                </div>
            </div>
        </div>
    `;
}

function likePost(postId) {
    const post = posts.find(p => p.id === postId);
    if (post) {
        post.likes++;
        const el = document.getElementById(`likes-${postId}`);
        if (el) el.innerText = post.likes;
    }
}

function addComment(postId) {
    const input = document.getElementById(`new-comment-${postId}`);
    const text = input.value.trim();
    if (text) {
        const post = posts.find(p => p.id === postId);
        if (post) {
            const newComment = { user: 'dev_dave', text: text };
            post.comments.push(newComment);

            const commentList = document.getElementById(`comment-list-${postId}`);
            const div = document.createElement('div');
            div.style.marginBottom = '0.8rem';
            div.style.fontSize = '0.95rem';
            div.innerHTML = `<strong>@${newComment.user}:</strong> <span style="color: var(--text-secondary);">${newComment.text}</span>`;
            if (commentList) commentList.appendChild(div);

            input.value = '';
            const footerBtns = document.querySelectorAll(`#post-${postId} .action-btn`);
            if (footerBtns[1]) footerBtns[1].innerHTML = `💬 ${post.comments.length} Comments`;
        }
    }
}

function createPost() {
    const contentInput = document.getElementById('post-content');
    const tagsInput = document.getElementById('post-tags');
    const content = contentInput ? contentInput.value.trim() : '';
    const tags = tagsInput ? tagsInput.value.split(',').map(t => t.trim().startsWith('#') ? t.trim() : '#' + t.trim()).filter(t => t !== '#') : [];

    if (content) {
        const newPost = {
            id: posts.length + 100,
            user_id: 1,
            author: 'dev_dave',
            content: content,
            likes: 0,
            comments: [],
            hashtags: tags
        };
        posts.unshift(newPost);
        if (contentInput) contentInput.value = '';
        if (tagsInput) tagsInput.value = '';
        renderFeed();
    }
}

function toggleComments(postId) {
    const el = document.getElementById(`comments-${postId}`);
    if (el) el.style.display = el.style.display === 'none' ? 'block' : 'none';
}

window.onload = () => {
    renderNavbar();
    const path = window.location.pathname;
    if (path.includes('index.html') || path === '/' || path.endsWith('project/') || path.endsWith('index.html')) {
        renderFeed();
    } else if (path.includes('groups.html')) {
        renderGroups();
    } else if (path.includes('profile.html')) {
        renderProfile();
    }
};

function renderGroups() {
    const groupsEl = document.getElementById('groups-list');
    if (groupsEl) {
        groupsEl.innerHTML = groups.map(g => {
            const isMember = g.members.includes('dev_dave');
            return `
                <div class="card">
                    <div style="display: flex; justify-content: space-between; align-items: start; gap: 1rem;">
                        <div>
                            <h2 style="color: var(--accent); margin-bottom: 0.5rem; font-weight: 700;">${g.name}</h2>
                            <p style="color: var(--text-secondary); margin-bottom: 1rem; font-size: 0.95rem;">${g.description}</p>
                            <p style="font-size: 0.9rem; font-weight: 500; color: var(--text-secondary);">👥 ${g.members.length} members</p>
                        </div>
                        <button class="btn" style="background: ${isMember ? '#ef4444' : 'var(--accent)'}; box-shadow: ${isMember ? '0 4px 12px rgba(239, 68, 68, 0.15)' : 'var(--shadow)'};" onclick="toggleJoinGroup(${g.id})">
                            ${isMember ? 'Leave Group' : 'Join Group'}
                        </button>
                    </div>
                    <div style="margin-top: 1.5rem; border-top: 1px solid var(--border); padding-top: 1rem; font-size: 0.95rem; color: var(--text-secondary);">
                        <strong style="color: var(--text-primary);">Members:</strong> ${g.members.map(m => '@' + m).join(', ')}
                    </div>
                </div>
            `;
        }).join('');
    }
}

function toggleJoinGroup(groupId) {
    const group = groups.find(g => g.id === groupId);
    if (group) {
        const index = group.members.indexOf('dev_dave');
        if (index > -1) {
            group.members.splice(index, 1);
        } else {
            group.members.push('dev_dave');
        }
        renderGroups();
    }
}

function createGroup() {
    const nameInput = document.getElementById('group-name');
    const descInput = document.getElementById('group-desc');
    const name = nameInput ? nameInput.value.trim() : '';
    const desc = descInput ? descInput.value.trim() : '';

    if (name) {
        const newGroup = {
            id: groups.length + 1,
            name: name,
            description: desc || 'No description provided.',
            members: ['dev_dave']
        };
        groups.push(newGroup);
        if (nameInput) nameInput.value = '';
        if (descInput) descInput.value = '';
        renderGroups();
    }
}

function renderFeed() {
    const feedEl = document.getElementById('feed');
    const trendingEl = document.getElementById('trending');

    if (feedEl) {
        const createPostForm = `
            <div class="card">
                <h2 class="sidebar-title">Create Post</h2>
                <textarea id="post-content" placeholder="What's on your mind?" style="margin-bottom: 1rem;"></textarea>
                <div style="display: flex; gap: 1rem;">
                    <input type="text" id="post-tags" placeholder="Hashtags (comma separated)" style="flex-grow: 1;">
                    <button class="btn" onclick="createPost()">Post</button>
                </div>
            </div>
        `;
        feedEl.innerHTML = createPostForm + posts.map(renderPost).join('');
    }

    if (trendingEl) {
        trendingEl.innerHTML = `
            <h2 class="sidebar-title">Trending Hashtags</h2>
            <ul class="tag-list">
                ${hashtags.map(h => `
                    <li class="tag-item">
                        <span class="tag-name" style="color: var(--accent); font-weight: 600;">${h.tag}</span>
                        <span class="tag-count">${h.count} posts</span>
                    </li>
                `).join('')}
            </ul>
        `;
    }
}

function renderProfile() {
    const profileFeedEl = document.getElementById('profile-feed');
    if (profileFeedEl) {
        const davePosts = posts.filter(p => p.author === 'dev_dave');
        if (davePosts.length === 0) {
            profileFeedEl.innerHTML = '<div class="card" style="text-align: center; color: var(--text-secondary);">You haven\'t posted anything yet.</div>';
        } else {
            profileFeedEl.innerHTML = davePosts.map(renderPost).join('');
        }
    }
}
