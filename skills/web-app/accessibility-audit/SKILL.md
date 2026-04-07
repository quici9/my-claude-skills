# Accessibility Audit

## Description

Audits web apps for WCAG 2.1 AA/AAA compliance, ARIA usage, keyboard navigation, screen reader compatibility, and color contrast. Covers HTML structure, CSS, JavaScript interactions, and frameworks (React, Vue, Angular).

## Triggered When

- User says "accessibility audit", "WCAG check", "a11y review"
- User says "kiểm tra accessibility", "check a11y", "WCAG compliance"
- User asks "is this accessible", "keyboard navigation broken", "screen reader test"
- User says "bàn phím không hoạt động", "screen reader", "người khuyết tật dùng được không"
- User wants to fix ARIA errors, contrast issues, or navigation problems
- User says "run lighthouse a11y", "axe audit", "NVDA test", "contrast màu"

## Audit Checklist

### 1. Keyboard Navigation
- All interactive elements reachable via Tab
- Focus order logical (top-to-bottom, left-to-right)
- Focus indicator visible (not hidden with `outline: none`)
- Skip-to-content link present
- No keyboard traps (modal, custom widget)
- Escape closes overlays/menus

### 2. Screen Reader Compatibility
- Semantic HTML used (`<button>`, `<nav>`, `<main>`, `<h1>`–`<h6>`)
- Images have meaningful `alt` text (or `alt=""` if decorative)
- Form inputs have associated `<label>` (not just placeholder)
- Error messages programmatically associated with inputs
- Dynamic content uses `aria-live` regions
- Landmarks: `<header>`, `<main>`, `<nav>`, `<footer>`, `<aside>`

### 3. Color & Contrast
- Text contrast ratio ≥ 4.5:1 (WCAG AA normal text)
- Large text contrast ratio ≥ 3:1
- UI components & graphics: ≥ 3:1
- Use browser DevTools or WebAIM Contrast Checker

### 4. ARIA Correctness
- `aria-label`, `aria-describedby` used correctly
- `aria-expanded`, `aria-selected`, `aria-current` on interactive elements
- `role` matches semantic HTML intent (don't override unless necessary)
- No ARIA on non-interactive elements without purpose
- Modal has `role="dialog"` + `aria-modal="true"` + focus trap

### 5. Forms & Input
- Required fields marked with `aria-required` and visual indicator
- Error messages: specific, actionable, visible text (not just color)
- Autocomplete attributes for relevant fields
- No time limits without user control

### 6. Touch & Motion
- Touch targets ≥ 44×44px
- No auto-playing media without controls
- Respects `prefers-reduced-motion` media query

## Tools to Recommend

- **Automated**: axe DevTools, Lighthouse, WAVE
- **Manual**: Keyboard-only test, NVDA/VoiceOver screen reader test
- **Color contrast**: WebAIM Contrast Checker, Colour Contrast Analyser

## Output Format

```
## ♿ Accessibility Audit — [page/component name]

### Overall Rating
- WCAG Level: [A / AA / AAA]
- Automated issues: [N] | Manual issues: [N]

### 🔴 Critical Issues
1. [Issue] — Affects: [who/what]
   → Fix: [code suggestion]

### 🟡 Moderate Issues
1. [Issue] — WCAG criterion: [X.X.X]
   → Fix: [code suggestion]

### 🟢 Passed Checks
- [list of things that passed]

### Keyboard Navigation Order
[sequence of focus order]

### Color Contrast
| Element | Ratio | WCAG AA | WCAG AAA |
|---------|-------|---------|----------|
| body    | 7.2:1 | ✅      | ✅       |

### Recommended Tools for Manual Testing
- [tool list]
```

## Rules

- Automated tools catch ≤ 30% of a11y issues — always do manual testing
- Focus on critical first: keyboard nav + screen reader for interactive elements
- ARIA is not a substitute for semantic HTML — use semantic elements first
- Test with at least 2 screen readers: NVDA (Windows) + VoiceOver (Mac) or Safari
- Never rely on color alone to convey information
