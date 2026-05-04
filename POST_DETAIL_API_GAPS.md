# Post Detail — API Gaps for Backend

The post detail screen (mobile design refs DTH-Mobile-6/7/8) needs the following
backend changes. The comment endpoints already in `api_doc.json` cover most of
the comments side; the gaps below all relate to **reactions, share, author
identity, viewer state, pagination, and sort** — none of which exist yet.

Resolved during review (no backend action needed):

- View count increments server-side on `GET /api/timeline-posts/:uid`.
- `media` is `null` for video posts, otherwise an array of image URLs. Confirmed.
- Edit/delete comment, realtime comments, reply-response envelope shape are all
  out of scope for this iteration.

---

## 1. Post & comment reactions endpoints (blocking)

The heart icon on both posts and comments has no backend. Need:

```
POST   /api/timeline-posts/:uid/reactions          like a post
DELETE /api/timeline-posts/:uid/reactions          unlike a post

POST   /api/timeline-posts/comments/:uid/reactions   like a comment
DELETE /api/timeline-posts/comments/:uid/reactions   unlike a comment
```

Response should return the **updated `counts.reactions`** and
**`viewer_reacted: true|false`** (see #3) so the client can settle
optimistic UI without a second request.

If reactions already exist but aren't documented, please document them.

## 2. Share endpoint (blocking)

Design shows a share count. Need a way to bump it after the native share
sheet completes:

```
POST   /api/timeline-posts/:uid/share
```

Response: updated `counts.shares`.

## 3. `viewer_reacted` field on post + comment responses (blocking)

Even with reactions endpoints in place, there's no way to render
filled-vs-outline heart correctly without knowing whether the **current
authenticated viewer** has already reacted. Add to every post and comment
payload:

```json
"viewer_reacted": true | false
```

Applies to: post list, post detail, comment list, replies list, and the
create-comment / create-reply / toggle-reaction responses.

## 4. Structured author on post (blocking)

Posts currently embed author in `title` ("X with Y"). The mobile client
parses this with a string heuristic (`_parseTitle` in `home_view_model.dart`),
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

## 5. Pagination params + envelope (blocking)

`api_doc.json` describes `comments` and `replies` as "paginated" but does
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

## 6. Comment sort param

Design shows a "Most recent ▾" dropdown, implying at least one alternative
(typically "Top"). Need:

```
GET /api/timeline-posts/:uid/comments?sort=recent|top
```

Confirm which sort modes are supported and the default.

---

## Mobile-side notes (no backend action)

- The Flutter client will use a **shared Riverpod cache keyed by post `uid`**
  so the home feed and post detail screen stay in sync after likes/shares
  without round-tripping. This relies on responses returning fresh
  `counts` + `viewer_reacted` after every mutation.
- Author parsing from `title` will be removed once #4 lands.
