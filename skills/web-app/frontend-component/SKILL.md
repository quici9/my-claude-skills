# Frontend Component

## Description

Specialist in building production-ready frontend components. Generates clean, accessible, responsive components following modern best practices for React/Vue/Svelte with TypeScript.

## Triggered When

- User says "create component", "build component", "make a component"
- User says "tạo component", "viết component", "build component"
- User shares a wireframe, mockup description, or feature requirement for UI
- User says "mockup này", "thiết kế này", "UI này", "xây dựng component"
- User asks "how do I structure this component", "cấu trúc component thế nào"
- User asks about accessibility, responsive design, or component architecture
- User says "responsive", "mobile", "di động", "thiết kế đáp ứng"

## Component Checklist

### 1. Structure & Architecture
- Single responsibility: does one thing well?
- File structure: `ComponentName/index.tsx`, `ComponentName.types.ts`, `ComponentName.test.tsx`
- Props interface defined with TypeScript (no `any`)
- Compound component pattern if it has sub-parts

### 2. Accessibility (WCAG 2.1 AA minimum)
- Semantic HTML (`<button>` not `<div onClick>`)
- ARIA labels for icon-only buttons
- Keyboard navigable (focus order, tabindex)
- Color contrast ≥ 4.5:1 for text
- `aria-live` for dynamic content
- Form inputs linked to `<label>`

### 3. Responsive Design
- Mobile-first CSS (media queries from min-width)
- Fluid typography with `clamp()`
- Touch targets ≥ 44×44px
- Breakpoints consistent with design system
- No horizontal scroll on mobile

### 4. State Management
- Local state only when needed (`useState`, `useReducer`)
- Lifted state only when truly shared
- Effects (`useEffect`) have dependency arrays
- No prop drilling > 2 levels (use context or state library)
- Loading / error / empty states handled

### 5. Styling
- CSS modules, styled-components, or Tailwind (match project)
- No inline styles except dynamic values
- CSS custom properties for theme tokens
- Responsive units (rem, %, vw/vh) over px for layout

### 6. Testing Hooks
- Unit test with `@testing-library/react`
- Test render with different prop variants
- Test user interactions (click, type)
- Test accessibility with `jest-axe`

## Output Format

```
## 🧩 Component — [Name]

### Props
| Name | Type | Required | Default | Description |
|---|---|---|---|---|

### States Handled
- Default / Loading / Error / Empty

### Accessibility
- Role: ...
- Keyboard: ...
- ARIA: ...

### Usage Example
\`\`\`tsx
// basic usage
\`\`\`

### Test Cases
- Should render [X] when [Y]
- Should call [handler] on [event]
- Should be accessible (axe-core)
```
