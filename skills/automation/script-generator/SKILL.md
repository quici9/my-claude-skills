# Script Generator

## Description

Generates Python and Bash scripts for automating repetitive tasks: file processing, data conversion, batch operations, system maintenance, and workflow automation. Prioritizes clarity, safety, and reproducibility.

## Triggered When

- User says "write a script to", "automate this task", "batch process"
- User says "viết script", "tự động hóa", "batch process", "xử lý hàng loạt"
- User asks "how to rename files in bulk", "convert CSV to JSON", "process all files in folder"
- User says "đổi tên nhiều file", "chuyển CSV sang JSON", "xử lý nhiều file"
- User wants a CLI tool for a recurring task
- User says "Bash script to", "Python script to", "one-liner for"

## Workflow

### 1. Clarify the Task
- Input: what does the script receive? (files, arguments, stdin?)
- Output: what should it produce? (files, stdout, API call?)
- Error handling: what should happen on failure? (skip, abort, log?)
- Repeatability: is it safe to run multiple times?

### 2. Design the Script
- Choose language: Python for cross-platform logic, Bash for system tasks
- Define CLI interface: argparse, click, or simple positional args
- Plan file operations: read → transform → write
- Add logging, not just print()

### 3. Safety & Idempotency
- Dry-run mode: show what would be done without making changes
- Backup originals before overwriting
- Validate inputs before processing
- Handle missing files, empty dirs gracefully

### 4. Make it Configurable
- Hardcode nothing — use config file or CLI args
- Constants at top of script with clear comments

### 5. Add Usage Documentation
- `--help` output with examples
- Comments for non-obvious logic
- Requirements/dependencies listed at top

## Template: Python CLI Script

```python
#!/usr/bin/env python3
"""Short description of what this script does."""

import argparse
import logging
from pathlib import Path

logging.basicConfig(level=logging.INFO, format="%(asctime)s %(message)s")
logger = logging.getLogger(__name__)

def main():
    parser = argparse.ArgumentParser(description="What this does")
    parser.add_argument("--input", type=Path, required=True)
    parser.add_argument("--output", type=Path, required=True)
    parser.add_argument("--dry-run", action="store_true")
    args = parser.parse_args()

    if args.dry_run:
        logger.info("DRY RUN — no changes will be made")

    # Main logic here
    logger.info("Processing %s", args.input)

if __name__ == "__main__":
    main()
```

## Output Format

```
## 🤖 Script Generated — [task name]

### Language
[Python/Bash]

### Purpose
[1-sentence description]

### Usage
./script.py --input <path> --output <path> [--dry-run]

### Key Logic
1. [Step description]
2. [Step description]

### Safety
- Dry-run supported: [yes/no]
- Backup before overwrite: [yes/no]
- Input validation: [yes/no]

### Code
[full script code]
```

## Rules

- Always add `--dry-run` flag for file-modifying scripts
- Prefer Python over Bash for anything with logic or strings
- Use `logging` module, not `print()`, for production scripts
- Make scripts executable (chmod +x) and add shebang
