## Why

We need a single, spec-driven architecture improvement plan for the Flutter blog app so decisions on data layer, state management, and routing/permissions are explicit, consistent, and ready for implementation. This reduces rework and gives a clear execution path for a first-time project.

## What Changes

- Document a **Local-first data layer** approach (Isar + Remote source + merge strategy) with pain points, solution, and concrete landing steps.
- Document a **global state management** approach (Riverpod + Controllers + unified async states) with pain points, solution, and landing steps.
- Document a **routing & permissions** model (Guest/User/Owner + route guards + action checks) with pain points, solution, and landing steps.
- Record remaining areas (error handling, performance/UX, testing/engineering, overall layering) as a backlog for later optimization.

## Capabilities

### New Capabilities
- `data-layer-local-first`: Local-first data storage and merge strategy for read-only remote APIs.
- `state-management-riverpod`: Global state management with Riverpod controllers and unified async states.
- `routing-permissions`: Route guards and permission model for Guest/User/Owner.

### Modified Capabilities
- (none)

## Impact

- `lib/data/`, `lib/repositories/`, `lib/services/` (data access patterns)
- `lib/screens/` (UI state access and routing usage)
- `lib/routes/app_router.dart` (route guards and deep links)
- Dependencies: add Isar + Riverpod (planned)
