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
# Step 1 — Copy / update skills (supports nested: skills/<group>/<skill>/)
#
#   Logic:
#     - Source layout: skills/<group>/<skill>/SKILL.md
#     - Target layout: ~/.claude/skills/<group>/<skill>/SKILL.md
#     - Each <skill> is compared individually (not the whole <group>).
# ==============================================================================
log "Source: $SOURCE_DIR"
log "Target: $TARGET_DIR"

changes=0

# Fix: ((changes++)) returns exit 1 when changes=0, breaking "set -e"
# Use changes=$((changes+1)) or ||: to avoid premature exit

# Collect all skills across all groups
# Depth from SOURCE_DIR: skills/<group>/<skill>/SKILL.md = depth 3
find "$SOURCE_DIR" -mindepth 3 -maxdepth 3 -name "SKILL.md" | sort | while read -r src_skill_md; do
  src_skill_dir="$(dirname "$src_skill_md")"

  # Derive group and skill name from path:
  #   skills/<group>/<skill>/SKILL.md
  relative="${src_skill_dir#$SOURCE_DIR/}"   # e.g. security/secrets-detection
  group_name="${relative%/*}"                 # e.g. security
  skill_name="${relative#*/}"                # e.g. secrets-detection

  target_group="$TARGET_DIR/$group_name"
  target_path="$target_group/$skill_name"

  # Compare mtime — if source is newer → update
  source_mtime=$(stat -f '%m' "$src_skill_md" 2>/dev/null || echo 0)
  target_skill_md="$target_path/SKILL.md"
  target_mtime=$(stat -f '%m' "$target_skill_md" 2>/dev/null || echo 0)

  if [[ -d "$target_path" ]]; then
    if [[ "$source_mtime" -gt "$target_mtime" ]]; then
      if [[ "$DRY_RUN" == true ]]; then
        log "[DRY RUN] UPDATE   $group_name/$skill_name"
      else
        mkdir -p "$target_group"
        cp -r "$src_skill_dir" "$target_path"
        log "UPDATED  $group_name/$skill_name"
      fi
      changes=$((changes+1))
    else
      log "UNCHANGED $group_name/$skill_name"
    fi
  else
    if [[ "$DRY_RUN" == true ]]; then
      log "[DRY RUN] ADD      $group_name/$skill_name"
    else
      mkdir -p "$target_group"
      cp -r "$src_skill_dir" "$target_path"
      log "ADDED    $group_name/$skill_name"
    fi
    changes=$((changes+1))
  fi
done

# ==============================================================================
# Step 2 — Remove skills no longer in source (with backup)
# ==============================================================================
find "$TARGET_DIR" -mindepth 3 -maxdepth 3 -name "SKILL.md" | sort | while read -r tgt_skill_md; do
  tgt_skill_dir="$(dirname "$tgt_skill_md")"

  relative="${tgt_skill_dir#$TARGET_DIR/}"  # e.g. security/secrets-detection
  group_name="${relative%/*}"
  skill_name="${relative#*/}"

  src_skill_dir="$SOURCE_DIR/$group_name/$skill_name"

  if [[ ! -d "$src_skill_dir" ]]; then
    if [[ "$DRY_RUN" == true ]]; then
      log "[DRY RUN] REMOVE   $group_name/$skill_name (would back up → $BACKUP_DIR)"
    else
      ts=$(timestamp)
      backup_path="$BACKUP_DIR/${group_name}_${skill_name}_${ts}"
      mv "$tgt_skill_dir" "$backup_path"
      log "REMOVED  $group_name/$skill_name → backed up to $backup_path"
    fi
    changes=$((changes+1))
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
