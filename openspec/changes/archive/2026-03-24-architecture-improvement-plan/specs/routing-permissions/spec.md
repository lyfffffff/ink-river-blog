## ADDED Requirements

### Requirement: Role model
The system MUST support three roles: Guest, User, and Owner.

#### Scenario: Guest role
- **WHEN** a user is not logged in
- **THEN** their role is Guest

### Requirement: Protected routes
Protected routes (management and edit) SHALL require authentication and redirect to login when accessed by a Guest.

#### Scenario: Guest accesses management
- **WHEN** a Guest navigates to `/article-management`
- **THEN** they are redirected to the login screen

### Requirement: Owner-only management
Editing or deleting an article MUST be allowed only when the current user is the owner of that article.

#### Scenario: Non-owner edit
- **WHEN** a logged-in user attempts to edit a post they do not own
- **THEN** the action is blocked and a permission message is shown

### Requirement: Deep link support for article detail
The article detail route SHALL load the article by id when navigation extras are missing.

#### Scenario: Shared link
- **WHEN** a user opens `/article/42` directly from a shared link
- **THEN** the article detail screen fetches and displays post 42

### Requirement: Post-login return
After successful login, the system MUST return the user to the originally requested protected route.

#### Scenario: Login redirect
- **WHEN** a Guest is redirected to login after attempting `/article/42/edit`
- **THEN** a successful login returns them to `/article/42/edit`

### Requirement: Guest restrictions on actions
Guests MUST NOT be allowed to favorite or comment on posts and SHALL be prompted to log in when attempting those actions.

#### Scenario: Guest tries to favorite
- **WHEN** a Guest taps the favorite action on a post
- **THEN** the action is blocked and the user is prompted to log in

### Requirement: Logged-in user actions
Logged-in users SHALL be able to favorite and comment on posts.

#### Scenario: User posts a comment
- **WHEN** a logged-in user submits a comment
- **THEN** the comment is accepted and displayed in the comment list

### Requirement: Protected route list
The system SHALL treat `/article-management` and `/article/:id/edit` as protected routes requiring authentication.

#### Scenario: Guest accesses edit route
- **WHEN** a Guest navigates to `/article/99/edit`
- **THEN** they are redirected to the login screen
