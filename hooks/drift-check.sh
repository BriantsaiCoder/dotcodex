#!/usr/bin/env bash
set -uo pipefail

cd "$(dirname "${BASH_SOURCE[0]:-$0}")/.." || exit 0

if ! bash tests/global-config-ownership.sh >/dev/null 2>&1; then
  printf '%s\n' 'WARNING: ~/.codex global config integrity check failed; run bash ~/.codex/tests/global-config-ownership.sh' >&2
fi

exit 0
