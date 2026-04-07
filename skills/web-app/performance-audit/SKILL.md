# Performance Audit

## Description

Expert frontend performance auditor. Diagnoses and fixes render bottlenecks, bundle bloat, network inefficiencies, and Core Web Vitals issues with concrete, measurable recommendations.

## Triggered When

- User says "slow", "laggy", "performance issue", "optimize"
- User says "chậm", "lag", "performance kém", "tối ưu", "web load chậm"
- User shares Lighthouse or WebPageTest report
- User says "Lighthouse score", "check performance", "điểm performance"
- User asks about bundle size, first contentful paint, or Time to Interactive
- User says "bundle size", "JS nhiều quá", "load lâu", "tối ưu tốc độ"
- User asks to audit render performance, memory usage, or network waterfall

## Audit Checklist

### 1. Core Web Vitals (LCP, CLS, INP)
- **LCP** > 2.5s? → large images, render-blocking resources, slow server
- **CLS** > 0.1? → missing image dimensions, dynamic font load, late-loading ads
- **INP** > 200ms? → long tasks on main thread, heavy event handlers
- Fix highest impact items first (LCP usually the biggest lever)

### 2. Bundle Size
- Run `npx bundlephobia-cli [package]` before adding any new dep
- Identify large dependencies (moment.js → day.js, lodash → native/esm)
- Code-split with `React.lazy()`, `loadable`, or Vite dynamic imports
- Route-based splitting (each route = separate chunk)
- Tree-shake unused code (ESM imports, sideEffects: false)
- Target: initial JS < 200KB gzipped

### 3. Render Performance
- React DevTools Profiler: find components rendering > 50ms
- Excessive re-renders: wrap with `React.memo`, use `useMemo`/`useCallback`
- Context value should be stable (memoize the value object)
- Virtualize long lists > 100 items (react-window, react-virtual)
- Avoid inline object/array literals in JSX props

### 4. Network / Data Fetching
- Waterfall: identify serial dependencies, parallelize fetches
- Add `rel="preconnect"` for critical third-party origins
- Lazy load below-fold images with `loading="lazy"`
- Preload critical fonts, LCP image with `<link rel="preload">`
- Use `compression` middleware (Brotli preferred over gzip)
- HTTP/2 push or early hints for critical assets

### 5. Caching & CDN
- Cache static assets with `Cache-Control: max-age=31536000, immutable`
- API responses: cacheable GET with ETag/Last-Modified
- Service worker for offline/app-like experience
- CDN for assets (images, fonts, third-party scripts)
- Image CDN (Cloudinary, imgix) for automatic optimization

### 6. Memory & Long Tasks
- Check for memory leaks: `performance.memory` in DevTools
- Clean up event listeners, subscriptions, timers on unmount
- Large data tables: pagination, virtual scrolling, or Web Workers
- Break up long tasks (> 50ms) with `requestIdleCallback` or scheduler

## Output Format

```
## ⚡ Performance Audit

### Core Web Vitals
| Metric | Current | Target | Status |
|---|---|---|---|
| LCP | Xms | <2500ms | 🟡/🟢/🔴 |
| CLS | X | <0.1 | 🟡/🟢/🔴 |
| INP | Xms | <200ms | 🟡/🟢/🔴 |

### Issues Found (sorted by impact)
1. **[HIGH — LCP]** ...
   → Fix: ...
   → Expected gain: ...

2. **[MED — Bundle]** ...
   → Fix: ...
   → Expected gain: ...

### Quick Wins (do first)
- ...

### Long-term Optimizations
- ...
```
