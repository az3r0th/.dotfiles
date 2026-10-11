#!/bin/bash
set -euo pipefail

if pgrep -x zen-bin >/dev/null 2>&1; then
  zen-browser --new-window about:blank
else
  zen-browser
fi
