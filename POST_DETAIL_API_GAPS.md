# Post Detail — API Gaps for Backend

The post detail screen (mobile design refs DTH-Mobile-6/7/8) needs the following
backend changes. The May 2026 Postman dump unblocked **reactions, viewer state,
and comment sort**; the remaining gaps are **share, structured author, and
pagination**.

Resolved during review (no backend action needed):

- View count increments server-side on `GET /api/timeline-posts/:uid`.
- `media` is `null` for video posts, otherwise an array of image URLs. Confirmed.
- Edit/delete comment, realtime comments, reply-response envelope shape are all
  out of scope for this iteration.

---

## ✅ 1. Post & comment reactions endpoints — RESOLVED

Now available as **toggle** endpoints (single POST flips state):

```
POST /api/timeline-posts/:uid/react              → returns updated post
POST /api/timeline-posts/comments/:uid/react     → returns updated comment
```

Response includes the full post/comment with fresh `counts.reactions` and
`viewer_reacted`. Wired up in `PostRepo.toggleReaction` /
`CommentRepo.toggleReaction` and consumed by `PostDetailViewModel` with
optimistic flip + rollback.

## 2. Share endpoint (still blocking)

Design shows a share count. Need a way to bump it after the native share
sheet completes:

```
POST   /api/timeline-posts/:uid/share
```

Response: updated `counts.shares`.

Currently stubbed client-side as a "Share coming soon" toast.

## ✅ 3. `viewer_reacted` field on post + comment responses — RESOLVED

Now present on:

- `GET /api/timeline-posts` (post list)
- `GET /api/timeline-posts/:uid` (post detail)
- `GET /api/timeline-posts/:uid/comments` (comment list)
- `GET /api/timeline-posts/comments/:uid/replies` (replies list — implicit, not
  shown in the example response but assumed)
- `POST .../react` toggle responses

Parsed in `TimelinePost.fromJson` / `TimelineComment.fromJson` and surfaced
through the domain `Post.viewerReacted` / `Comment.viewerReacted`.

## 4. Structured author on post (still blocking)

Posts currently embed author in `title` ("X with Y"). The mobile client
parses this with a string heuristic (`parsePostTitle` in `post_mapper.dart`),
which is brittle and breaks on any title that doesn't follow the pattern.

Comments already have a clean `user` block — please add the same to posts:

```json
"user": {
  "full_name": "de9jaspirit",
  "avatar": "https://...",
  "verified": true
}
```

(`verified` is optional but the design shows a verification tick on the
post header.) Once present, `title` can stay as a free-form caption or be
removed if redundant.

## 5. Pagination params + envelope (still blocking)

The Postman doc describes `comments` and `replies` as "paginated" but does
not document query params or the response envelope. Mobile needs:

- **Query params** — confirm one of:
  - `?page=N&per_page=M` (page-based)
  - `?cursor=...&limit=M` (cursor-based, preferred for feeds)
- **Response envelope** — confirm where `next` / `has_more` / total count live.
  Current responses only show `data.comments[]` with no `meta` block.

Suggested:

```json
"data": {
  "comments": [...],
  "meta": { "next_cursor": "...", "has_more": true }
}
```

Same applies to **`GET /api/timeline-posts`** (post list) — currently no
pagination params shown there either, which will hurt as the timeline grows.

## ✅ 6. Comment sort param — RESOLVED

Available via `?sort=latest|oldest` (not the `recent|top` we initially
proposed). The "Most recent ▾" dropdown in the design maps cleanly to
`latest`; the alternative is `oldest`. **No "top" sort exists yet** — flag
for future if engagement-based sorting becomes a requirement.

Default appears to be `latest` per the doc.

---

## Mobile-side notes (no backend action)

- **Cache-as-source-of-truth.** `PostsCache` (a `ChangeNotifier` keyed by
  post `uid`) holds every `Post` object. `HomeViewModel` stores **only the
  feed order** (`List<String> postUids`) and the home view derives the
  visible list with `uids.map(cache.get).whereType<Post>()`. The detail VM
  reads through the same cache. A like-toggle on detail mutates the cache,
  which broadcasts to anyone watching — home updates automatically with no
  sync code.
- Author parsing from `title` will be removed once #4 lands.
