#!/usr/bin/env bash
set -euo pipefail

PROJECT_ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
DATA_DIR="${PROJECT_ROOT}/data"
STATE_DIR="${DATA_DIR}/.download-complete"

mkdir -p "$DATA_DIR" "$STATE_DIR"

download_and_extract() {
  local name="$1"
  local source="$2"
  local archive_name="$3"
  local archive_path="${DATA_DIR}/${archive_name}"
  local completion_marker="${STATE_DIR}/${name}"

  if [[ -f "$completion_marker" ]]; then
    echo "[skip] ${name} is already downloaded and extracted."
    return
  fi

  echo "[download] ${name}"
  uv run --project "$PROJECT_ROOT" gdown \
    --continue \
    --retries 5 \
    --output "$archive_path" \
    "$source"

  echo "[verify] ${archive_name}"
  unzip -tq "$archive_path"

  echo "[extract] ${archive_name} -> ${DATA_DIR}"
  unzip -oq "$archive_path" -d "$DATA_DIR"

  echo "[remove] ${archive_name}"
  rm -f -- "$archive_path"
  touch "$completion_marker"
}

download_and_extract \
  "UEA_archive" \
  "1XWgiN0-1K3HaC4CWHvQjTHVdVhajMzH_" \
  "UEA_archive.zip"

download_and_extract \
  "UEA_downsampled" \
  "1gYPohWLcpYWuTf9mTdyDl0TfH2aXyfV5" \
  "UEA_downsampled.zip"

download_and_extract \
  "TSB-AD-M" \
  "https://www.thedatum.org/datasets/TSB-AD-M.zip" \
  "TSB-AD-M.zip"

echo "All datasets are available under ${DATA_DIR}."
