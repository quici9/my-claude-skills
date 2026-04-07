# Unit Test Generator

## Description

Generates comprehensive unit tests with happy paths, edge cases, and error cases across Python (pytest), TypeScript/Jest, and other frameworks. Produces readable, maintainable tests that actually cover the important scenarios.

## Triggered When

- User says "write tests", "generate unit tests", "add tests"
- User says "viết test", "tạo unit test", "thêm test case"
- User says "what edge cases should I test", "test coverage", "các trường hợp cần test"
- User asks to test a function, module, or API endpoint
- After creating new code, to add test coverage

## Test Generation Process

### Step 1: Understand the Target
- Read the function/module signature carefully
- Understand input types, output types, side effects
- Identify what the function is supposed to DO (not just how)

### Step 2: Identify Test Scenarios

**Happy Path (must have)**
- Normal valid input → expected output
- Most common use case

**Edge Cases (always include)**
- Empty input: `[]`, `""`, `{}`, `null`, `undefined`
- Boundary: `0`, `-1`, `1`, max integer, empty string
- Single element
- Very large input
- Duplicates (for collection operations)
- Already in desired state

**Error Cases (include if applicable)**
- Invalid input types
- Missing required fields
- Out-of-range values
- Permission/authorization failures

**Edge cases specific to domain:**
- Negative numbers for financial/quantity
- Unicode/emoji in text
- Timezone edge cases (DST, year boundary)
- Concurrency/race conditions

### Step 3: Generate Tests

For each framework:

**Python / pytest**
```python
import pytest
from module import function_name

class TestFunctionName:
    def test_happy_path(self):
        result = function_name(valid_input)
        assert result == expected

    def test_edge_empty_list(self):
        result = function_name([])
        assert result == expected_empty

    def test_edge_null_raises(self):
        with pytest.raises(ValueError):
            function_name(None)
```

**TypeScript / Jest**
```typescript
import { functionName } from './module';

describe('functionName', () => {
  it('happy path', () => {
    const result = functionName(validInput);
    expect(result).toBe(expected);
  });

  it('edge: empty array', () => {
    const result = functionName([]);
    expect(result).toEqual(expectedEmpty);
  });

  it('error: null input throws', () => {
    expect(() => functionName(null as any)).toThrow();
  });
});
```

## Output Format

```
## 🧪 Unit Tests — [function/module name]

### Test Coverage Plan
| Scenario | Type | Description |
|---|---|---|
| Happy path | ✅ Happy | Normal valid input |
| Empty input | ⚠️ Edge | [] / "" / {} |
| Null/undefined | ⚠️ Edge | null, undefined |
| Negative number | ⚠️ Edge | -1, -999 |
| Invalid type | ❌ Error | wrong type passed |

### Generated Tests
\`\`\`[language]
[paste full test code]
\`\`\`

### Coverage Summary
- Happy path: ✅
- Edge cases: X scenarios
- Error cases: X scenarios
- Lines covered: ~X%
```

## Rules

- Generate REAL runnable code, not pseudocode
- Use descriptive test names: `test_<function>_<scenario>`
- One assertion concept per test (avoid mega-assertions)
- Include setup/teardown if needed
- Mark skipped tests with `@pytest.mark.skip(reason="...")` if applicable
- For async functions, use `async/await` or Promise patterns correctly
