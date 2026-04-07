#!/usr/bin/env bash
# ==============================================================================
# sync-skills.sh — Sync local skills to Claude Code global skills directory
#
# Usage: ./sync-skills.sh [--dry-run]
#
# Behavior:
#   - Copies skills from ./skills/ → ~/.claude/skills/
#   - Adds new skills (not yet in target)
#   - Updates existing skills if source has changed (checks mtime)
#   - Removes skills from target that no longer exist in source (with backup)
#   - Creates timestamped backup before any destructive change
#   - --dry-run: shows what would be done without making changes
# ==============================================================================

set -euo pipefail

SOURCE_DIR="$(cd "$(dirname "$0")/skills" && pwd)"
TARGET_DIR="$HOME/.claude/skills"
BACKUP_DIR="$HOME/.claude/backups/skills"
DRY_RUN=false

# --- Helpers ---
log()  { printf '[INFO]  %s\n' "$*"; }
warn() { printf '[WARN]  %s\n' "$*" >&2; }
die()  { printf '[ERROR] %s\n' "$*" >&2; exit 1; }

timestamp() { date '+%Y%m%d_%H%M%S'; }

# --- Argument parsing ---
if [[ "${1:-}" == "--dry-run" ]]; then
  DRY_RUN=true
  log "DRY RUN — no changes will be made"
fi

# --- Validate source ---
[[ -d "$SOURCE_DIR" ]] || die "Source directory not found: $SOURCE_DIR"

# --- Ensure target and backup directories exist ---
if [[ "$DRY_RUN" == false ]]; then
  mkdir -p "$TARGET_DIR"
  mkdir -p "$BACKUP_DIR"
fi

# ==============================================================================
# Step 1 — Copy / update skills
# ==============================================================================
log "Source: $SOURCE_DIR"
log "Target: $TARGET_DIR"

changes=0

for skill_path in "$SOURCE_DIR"/*/; do
  [[ -d "$skill_path" ]] || continue
  skill_name="$(basename "$skill_path")"
  target_path="$TARGET_DIR/$skill_name"

  if [[ -d "$target_path" ]]; then
    # Compare mtime of SKILL.md (or any .md) — if source is newer → update
    source_mtime=$(stat -f '%m' "${skill_path}SKILL.md" 2>/dev/null || echo 0)
    target_mtime=$(stat -f '%m' "$target_path/SKILL.md" 2>/dev/null || echo 0)

    if [[ "$source_mtime" -gt "$target_mtime" ]]; then
      if [[ "$DRY_RUN" == true ]]; then
        log "[DRY RUN] UPDATE   $skill_name (source is newer)"
      else
        cp -r "$skill_path" "$target_path"
        log "UPDATED  $skill_name"
      fi
      ((changes++))
    else
      log "UNCHANGED $skill_name"
    fi
  else
    if [[ "$DRY_RUN" == true ]]; then
      log "[DRY RUN] ADD      $skill_name"
    else
      cp -r "$skill_path" "$target_path"
      log "ADDED    $skill_name"
    fi
    ((changes++))
  fi
done

# ==============================================================================
# Step 2 — Remove skills no longer in source (with backup)
# ==============================================================================
for skill_path in "$TARGET_DIR"/*/; do
  [[ -d "$skill_path" ]] || continue
  skill_name="$(basename "$skill_path")"
  source_skill="$SOURCE_DIR/$skill_name"

  if [[ ! -d "$source_skill" ]]; then
    if [[ "$DRY_RUN" == true ]]; then
      log "[DRY RUN] REMOVE   $skill_name (would back up → $BACKUP_DIR)"
    else
      ts=$(timestamp)
      backup_path="$BACKUP_DIR/${skill_name}_${ts}"
      mv "$skill_path" "$backup_path"
      log "REMOVED  $skill_name → backed up to $backup_path"
    fi
    ((changes++))
  fi
done

# ==============================================================================
# Summary
# ==============================================================================
echo ""
if [[ "$DRY_RUN" == true ]]; then
  log "Dry run complete. Run without --dry-run to apply changes."
else
  log "Sync complete. $changes change(s) made."
  log "Backups (if any) are in: $BACKUP_DIR"
fi
