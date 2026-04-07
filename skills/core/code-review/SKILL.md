# Code Review

## Description

Expert code reviewer for all languages (Python, TypeScript, NestJS, etc.). Analyzes logic, naming, maintainability, performance, and security with concrete, prioritized suggestions.

## Triggered When

- User says "review this code", "kiểm tra code này", "check this code"
- User shares code and asks "review code này giúp tôi", "nhờ xem lại code"
- User shares a diff or pull request and asks "xem diff này đi"
- User asks "check logic", "kiểm tra logic", "check performance", "kiểm tra hiệu năng"
- User pastes code and says "có vấn đề gì không", "có lỗi gì không"

## Review Checklist (in priority order)

### 1. Read & Understand Context
- Identify language, framework, purpose of file/function
- Understand input/output contract

### 2. Logic & Correctness
- Is the logic correct? Any edge cases missed?
- Boundary conditions handled? (null, empty, 0, negative)
- Async/await handled correctly? Any promise leaks?
- Error handling sufficient?

### 3. Security
- SQL injection, XSS, IDOR potential?
- Input validation sufficient?
- Secrets or hardcoded credentials?
- Rate limiting, authentication checks?

### 4. Performance
- N+1 query, over-fetching?
- Unnecessary loop, expensive operation in loop?
- Missing index, inefficient data structure?
- Memory leak potential?

### 5. Maintainability
- Naming clear and consistent?
- Function too long (>30-40 lines)?
- Cyclomatic complexity high?
- DRY violation, duplicate code?

### 6. Code Style
- Convention matches project?
- Type annotation sufficient (TypeScript)?
- Docstring/comment purposeful?

## Output Format

```
## 🔍 Code Review — [filename]

### ✅ What's Good
- ...

### ⚠️ Needs Improvement
1. **[HIGH] Logic** — Issue description
   → Suggested fix

2. **[MED] Performance** — Issue description
   → Suggested fix

3. **[LOW] Style** — Issue description
   → Suggested fix

### 📋 Summary
- Issues: HIGH/MED/LOW
- Overall recommendation
```

## Rules

- Label HIGH/MED/LOW clearly; avoid over-critiquing
- If code is good, say "✅ No HIGH/MED issues"
- Give concrete code samples when suggesting fixes
- Explain WHY something is good, not just "you should do X"
