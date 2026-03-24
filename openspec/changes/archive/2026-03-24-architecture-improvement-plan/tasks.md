## 1. Data Layer (Isar Local-first)

- [x] 1.1 Add Isar dependencies and build setup
- [x] 1.2 Define Isar entities: Post, Comment, Favorite, User, LocalChange
- [x] 1.3 Implement LocalDataSource CRUD for posts/comments/favorites/users
- [x] 1.4 Implement RemoteDataSource wrapper for JSONPlaceholder
- [x] 1.5 Implement merge strategy in BlogRepository (local delete/edit/create priority, comment append)
- [x] 1.6 Add initial sync and cache refresh flow
- [x] 1.7 Record local change log for create/update/delete actions
- [x] 1.8 Add offline fallback behavior using cached content

## 2. State Management (Riverpod)

- [x] 2.1 Add Riverpod dependencies and provider wiring
- [x] 2.2 Create HomeController and HomeState with AsyncValue
- [x] 2.3 Create ArticleDetailController (detail + comments + favorite)
- [x] 2.4 Create SearchController and CategoryController
- [x] 2.5 Create AuthController, FavoritesController, SettingsController
- [x] 2.6 Migrate HomeScreen to provider-driven state
- [x] 2.7 Migrate ArticleDetailScreen to provider-driven state
- [x] 2.8 Migrate SearchScreen and CategoryScreen to provider-driven state

## 3. Routing & Permissions

- [x] 3.1 Define role model (Guest/User/Owner) and Permission helper
- [x] 3.2 Add GoRouter guards for management/edit routes
- [x] 3.3 Support deep links for article detail by id
- [x] 3.4 Implement post-login redirect to original target
- [x] 3.5 Enforce owner-only actions in BlogService/Repository
- [x] 3.6 Update UI to reflect permission (hide/disable actions)

## 4. Backlog (Later Optimization)

- [x] 4.1 Draft error handling & stability plan
- [x] 4.2 Draft performance & UX optimization plan
- [x] 4.3 Draft testing & engineering standards plan
- [x] 4.4 Draft architecture layering refinement plan

