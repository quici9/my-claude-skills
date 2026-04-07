# State Management

## Description

Expert in designing and implementing state management patterns for React/Vue/Svelte apps. Covers Redux Toolkit, Zustand, Pinia, React Context, and React Query with clear guidance on when to use which.

## Triggered When

- User says "setup state", "manage state", "add state management"
- User says "quản lý state", "setup state", "thêm redux/zustand"
- User asks "should I use Redux or Context?" or "Zustand vs Pinia?", "nên dùng gì quản lý state"
- User shares state-related bugs (stale data, too many re-renders)
- User says "data bị stale", "re-render nhiều quá", "state không đồng bộ"
- User asks about data fetching, caching, or server state
- User asks how to structure a store or slice

## State Management Decision Tree

```
Is data shared across multiple components?
├── NO  → Local state (useState / ref)
└── YES → Is it server/API data?
          ├── YES → React Query / TanStack Query
          └── NO  → Is app large/complex?
              ├── YES → Zustand / Redux Toolkit
              └── NO  → Context API / Pinia
```

## Checklist by Layer

### 1. Server State (React Query / TanStack Query)
- Define typed query keys: `['user', id]` not `userQuery(id)`
- Separate query from mutation logic
- Configure staleTime vs cacheTime correctly
- Optimistic updates for mutations
- Handle prefetching for navigation
- Infinite queries for pagination (cursor-based preferred)

### 2. Client State (Zustand / Redux Toolkit / Pinia)
- One store per domain feature (auth, cart, ui) not one giant store
- Actions/slices are named by feature, not "setState1"
- Selectors are memoized with `createSelector` (RTK) or computed (Zustand)
- Avoid storing derived data — compute on select
- Reset partial state on logout/flush

### 3. UI State (local + context)
- Theme, sidebar open/closed, modal visibility → local or UI context
- Toast/notification queue → UI context with reducer
- Form state → library state (React Hook Form / Zod)

### 4. Performance
- Selectors return minimal slice (no `state => state`)
- Use shallow equality check when selecting objects
- Split stores to avoid triggering unnecessary re-renders
- Batch updates when mutating multiple slices

### 5. Persistence
- Persist only public-safe data (preferences, cache) not tokens
- Encrypt sensitive persisted data
- Hydration strategy for SSR (Next.js/Nuxt)

## Output Format

```
## 🗂️ State Design — [Feature]

### Approach
- Why this tool/pattern chosen

### Store / Query Structure
\`\`\`typescript
// key types and structure
\`\`\`

### Key Patterns Used
- [ ] Optimistic update
- [ ] Optimistic rollback on error
- [ ] Prefetch on hover/navigation
- [ ] Cache invalidation strategy

### Potential Issues
- ...
```

## Rules

- Recommend the simplest solution first; escalate complexity only when needed
- Always use TypeScript — define State/Action types explicitly
- Never store tokens or secrets in client state/persistence
