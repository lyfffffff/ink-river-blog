## ADDED Requirements

### Requirement: Controller-owned state
Each feature module MUST expose a dedicated controller that owns its state and actions.

#### Scenario: Home feature state
- **WHEN** the Home screen is loaded
- **THEN** it reads state from `HomeController` rather than managing data with page-local `setState`

### Requirement: Unified async state model
All feature controllers SHALL represent loading, success, and error states using a unified async state type.

#### Scenario: Loading posts
- **WHEN** a controller fetches posts
- **THEN** the UI shows a loading state until data is available or an error occurs

### Requirement: UI reads state and dispatches actions
UI layers MUST only read state from providers and dispatch actions to controllers, without directly calling repositories.

#### Scenario: Refresh action
- **WHEN** the user pulls to refresh
- **THEN** the UI calls a controller action and does not directly invoke repository methods

### Requirement: Shared state across screens
Shared data (e.g., favorites or auth) SHALL be provided via global providers to avoid duplicate fetches.

#### Scenario: Favorites usage
- **WHEN** a user toggles favorite on the detail screen
- **THEN** the list screen reflects the same favorite state without reloading from the network

### Requirement: Required feature controllers
The system SHALL provide controllers for Home, Search, Category, ArticleDetail, Auth, Favorites, and Settings.

#### Scenario: Controller availability
- **WHEN** each feature screen is initialized
- **THEN** a corresponding controller provider is available for that feature

### Requirement: Feature state shape
Feature states SHALL expose the minimal fields needed for their UI, including Home pagination data, Search keyword/results, and ArticleDetail post/comments/favorite status.

#### Scenario: Home state exposes pagination
- **WHEN** the Home controller loads page 2
- **THEN** Home state includes the current page and whether a next page exists
