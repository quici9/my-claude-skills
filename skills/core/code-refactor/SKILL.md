# Code Refactor

## Description

Systematic code refactoring specialist. Breaks down large functions, reduces cyclomatic complexity, improves naming, and eliminates duplication — all while preserving existing behavior. Output is production-ready code with clear before/after mapping.

## Triggered When

- User says "refactor this", "clean up this code", "simplify"
- User says "tái cấu trúc", "dọn dẹp code", "đơn giản hóa code này"
- User says "this function is too long", "too complex", "hard to read"
- User says "hàm này quá dài", "quá phức tạp", "khó đọc", "tách hàm này ra"
- User asks to "split this up", "extract this part", "tách phần này ra"
- Code smell detected in review (duplication, long method, dead code)

## Refactoring Checklist

### 1. Assess Complexity
- Count lines per function (> 40 lines = candidate)
- Count cyclomatic complexity branches (if/else/switch/loops)
- Count nesting depth (> 3 levels = refactor)
- Identify shared patterns (copy-paste detection)

### 2. Extract & Break Down
- Extract pure functions (no side effects → easy to test)
- Extract magic values → named constants
- Extract complex conditionals → well-named predicates
- Extract similar code → shared utility

### 3. Naming Improvements
- Function names: verb + noun, describe what it DOES
- Variable names: describe what it HOLDS, not type
- Boolean: is/has/can/should prefix
- Avoid: `data`, `info`, `temp`, `result`, `foo`, `x`

### 4. Simplify Control Flow
- Replace nested if/else → early returns
- Replace switch → object map / polymorphism
- Replace long boolean chain → extract predicate
- Replace loop + accumulate → reduce/map/filter

### 5. Preserve Behavior
- Run existing tests BEFORE and AFTER
- Refactor in small, verifiable steps
- If no tests: write tests BEFORE refactoring

## Output Format

```
## 🔧 Refactor — [function/filename]

### Issues Found
1. [Issue description] — [location]
2. ...

### Before → After

**1. [Name of change]**
\`\`\`diff
- [before]
+ [after]
\`\`\`

**2. [Name of change]**
\`\`\`diff
- [before]
+ [after]
\`\`\`

### Full Refactored Code
\`\`\`[language]
[complete refactored code]
\`\`\`

### Verification
- [ ] Behavior preserved (tests pass)
- [ ] No new lint errors
- [ ] Naming conventions followed
```

## Rules

- ALWAYS preserve existing behavior — never change functionality while refactoring
- Never refactor multiple things at once without clear mapping
- If no tests exist, flag this and suggest writing them first
- Keep refactoring commits separate from functional changes
- Use the simplest refactor that solves the problem
