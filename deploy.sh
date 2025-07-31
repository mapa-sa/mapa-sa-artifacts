#!/bin/bash
set -e  # stop on error

# === Config ===
SOURCE_BRANCH="main"          # or "develop"
TARGET_BRANCH="gh-pages"
WORKTREE_DIR="../gh-pages"
FOLDERS_TO_DEPLOY=("datasets" "geojsons")

# === Script ===
echo "🚀 Deploying folders (${FOLDERS_TO_DEPLOY[*]}) from $SOURCE_BRANCH to $TARGET_BRANCH..."

# Add worktree if not exists
if [ ! -d "$WORKTREE_DIR" ]; then
    git worktree add "$WORKTREE_DIR" "$TARGET_BRANCH"
fi

cd "$WORKTREE_DIR"

# Ensure branch is up to date
git fetch origin "$TARGET_BRANCH"
git checkout "$TARGET_BRANCH"
git pull origin "$TARGET_BRANCH"

# Get folders from source branch
git checkout "$SOURCE_BRANCH" -- "${FOLDERS_TO_DEPLOY[@]}"

# Commit changes
git add "${FOLDERS_TO_DEPLOY[@]}"
git commit -m "Update datasets and geojsons from $SOURCE_BRANCH" || echo "✅ No changes to commit"

# Push
git push origin "$TARGET_BRANCH"

cd -
echo "🎉 Deployment complete!"

# Optional: remove worktree (uncomment if you want cleanup after each run)
git worktree remove "$WORKTREE_DIR"
