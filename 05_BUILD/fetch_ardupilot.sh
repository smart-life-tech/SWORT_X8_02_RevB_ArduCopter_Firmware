#!/usr/bin/env bash
set -euo pipefail
REPO_DIR="${1:-ardupilot}"
if [ -e "$REPO_DIR" ]; then
  echo "Refusing to overwrite existing path: $REPO_DIR" >&2
  exit 2
fi
git clone https://github.com/ArduPilot/ardupilot.git "$REPO_DIR"
git -C "$REPO_DIR" checkout Copter-4.7.2
HASH="$(git -C "$REPO_DIR" rev-parse --short HEAD)"
echo "Checked out Copter-4.7.2 at $HASH"
if [ "$HASH" != "fb77356" ]; then
  echo "WARNING: expected release short hash fb77356; verify official tag before proceeding." >&2
fi
