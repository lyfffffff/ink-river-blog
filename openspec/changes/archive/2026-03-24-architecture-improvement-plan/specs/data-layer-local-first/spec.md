## ADDED Requirements

### Requirement: Local-first read behavior
The system SHALL load cached post data from the local database first and render it without waiting for remote network responses.

#### Scenario: Cached data exists
- **WHEN** the user opens the home screen and cached posts exist
- **THEN** the UI renders the cached posts immediately and continues a background refresh

### Requirement: Persistent write operations
The system SHALL persist edits, deletions, comments, and favorites to local storage so that they survive app restarts.

#### Scenario: Edit survives restart
- **WHEN** a user edits a post and restarts the app
- **THEN** the edited content is still displayed for that post

### Requirement: Deterministic merge strategy
The system MUST apply local changes on top of remote data using deterministic rules: local deletions override remote, local edits override remote fields, and local creations appear in lists.

#### Scenario: Local delete overrides remote
- **WHEN** a post is deleted locally and the remote list includes that post
- **THEN** the post is not shown in the final list

### Requirement: Initial remote sync
The system SHALL fetch remote data on first run and store it in the local database without overwriting local changes.

#### Scenario: First run sync
- **WHEN** the app runs with an empty local database
- **THEN** remote posts are fetched and stored locally

### Requirement: Offline fallback
The system MUST allow browsing cached content when the remote fetch fails.

#### Scenario: Network failure
- **WHEN** the remote request fails due to no network
- **THEN** the UI still shows cached posts and a non-blocking error message

### Requirement: Core entities are persisted
The system SHALL persist posts, comments, favorites, users, and local change records in local storage.

#### Scenario: Entities survive restart
- **WHEN** the user restarts the app after creating edits, favorites, and comments
- **THEN** posts, comments, favorites, users, and local change records are still queryable locally

### Requirement: Local change log
The system SHALL record local create, update, and delete actions in a local change log for replay and merge.

#### Scenario: Edit creates change log entry
- **WHEN** a user edits a post
- **THEN** a local change entry is stored for that post

### Requirement: Merge priority order
The system MUST apply merge priority in this order: local deletions, local edits, local creations, then remote base data. Local comments MUST be appended after remote comments.

#### Scenario: Remote refresh preserves local edit
- **WHEN** a post is edited locally and the remote list refreshes
- **THEN** the edited fields remain as the local version in the merged result
