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

echo "==> Backup complete!"
echo "    Local:  ${LOCAL_BACKUP_DIR}/"
echo "    Global: ${GLOBAL_BACKUP_DIR}/"
ls -lh "${LOCAL_BACKUP_DIR}/${ZIP_NAME}"

# 4. Sync to Google Drive via rclone if available
RCLONE="/opt/homebrew/bin/rclone"
if [ -x "$RCLONE" ]; then
    echo "==> Syncing photography-field-guide backup to Google Drive..."
    "$RCLONE" copy "${GLOBAL_BACKUP_DIR}/" "gdrive:/Documents重要檔案備份/photography-field-guide/" -v || echo "  (rclone sync failed or offline, local backup preserved)"
fi
