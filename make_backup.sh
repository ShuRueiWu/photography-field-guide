#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")

LOCAL_BACKUP_DIR="${SCRIPT_DIR}/backups"
GLOBAL_BACKUP_DIR="${HOME}/Documents/備份/photography-field-guide"

mkdir -p "${LOCAL_BACKUP_DIR}" "${GLOBAL_BACKUP_DIR}"

echo "==> Creating local backups for photography-field-guide..."

# 1. Copy individual files with timestamp
cp "${SCRIPT_DIR}/index.html" "${LOCAL_BACKUP_DIR}/index_${TIMESTAMP}.html"
cp "${SCRIPT_DIR}/test_accuracy.py" "${LOCAL_BACKUP_DIR}/test_accuracy_${TIMESTAMP}.py"
cp "${SCRIPT_DIR}/README.md" "${LOCAL_BACKUP_DIR}/README_${TIMESTAMP}.md"

# Keep a "latest" copy
cp "${SCRIPT_DIR}/index.html" "${LOCAL_BACKUP_DIR}/index_latest.html"

# 2. Copy to global ~/Documents/備份/photography-field-guide
cp "${SCRIPT_DIR}/index.html" "${GLOBAL_BACKUP_DIR}/index_${TIMESTAMP}.html"
cp "${SCRIPT_DIR}/index.html" "${GLOBAL_BACKUP_DIR}/index_latest.html"

# 3. Create full zip archive in both locations
ZIP_NAME="photography-field-guide_${TIMESTAMP}.zip"
cd "${SCRIPT_DIR}"
zip -q -r "${LOCAL_BACKUP_DIR}/${ZIP_NAME}" index.html test_accuracy.py README.md
cp "${LOCAL_BACKUP_DIR}/${ZIP_NAME}" "${GLOBAL_BACKUP_DIR}/${ZIP_NAME}"
cp "${LOCAL_BACKUP_DIR}/${ZIP_NAME}" "${GLOBAL_BACKUP_DIR}/photography-field-guide_latest.zip"

# 4. Retention policy: keep latest 5 timestamped versions in both dirs, auto-prune older ones
MAX_KEEP=5
prune_old() {
    local DIR="$1"
    local PATTERN="$2"
    cd "$DIR"
    local COUNT=$(ls -1t ${PATTERN} 2>/dev/null | wc -l | tr -d ' ')
    if [ "$COUNT" -gt "$MAX_KEEP" ]; then
        ls -1t ${PATTERN} 2>/dev/null | tail -n +$((MAX_KEEP + 1)) | while read -r f; do
            [ -f "$f" ] && rm -f "$f"
        done
    fi
}

prune_old "${LOCAL_BACKUP_DIR}" "index_2*.html"
prune_old "${LOCAL_BACKUP_DIR}" "test_accuracy_2*.py"
prune_old "${LOCAL_BACKUP_DIR}" "README_2*.md"
prune_old "${LOCAL_BACKUP_DIR}" "photography-field-guide_2*.zip"
prune_old "${GLOBAL_BACKUP_DIR}" "index_2*.html"
prune_old "${GLOBAL_BACKUP_DIR}" "photography-field-guide_2*.zip"

echo "==> Backup complete (latest ${MAX_KEEP} versions retained)!"
echo "    Local:  ${LOCAL_BACKUP_DIR}/"
echo "    Global: ${GLOBAL_BACKUP_DIR}/"
echo "    (Cloud sync is scheduled daily at 04:30 via launchd com.sierra.backup-gdrive)"
ls -lh "${LOCAL_BACKUP_DIR}/${ZIP_NAME}"
