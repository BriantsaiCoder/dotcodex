#!/usr/bin/env bash
set -uo pipefail

cd "$(dirname "${BASH_SOURCE[0]:-$0}")/.." || exit 0

if ! bash tests/global-config-ownership.sh >/dev/null 2>&1; then
  printf '%s\n' 'WARNING: ~/.codex global config integrity check failed; run bash ~/.codex/tests/global-config-ownership.sh' >&2
fi

# [T0-3] guard 副本一致性。hooks/guard-git-push.sh 自 2026-07-29 起是實體副本
# 而非 wrapper（guard-codex-git-push.sh exec 的是本目錄那份），CI 比不了，
# 只能在本機驗。邏輯單一實作於 ~/.agents/bin/hook-parity-check；缺檔時靜默跳過。
if [ -x "$HOME/.agents/bin/hook-parity-check" ]; then
  bash "$HOME/.agents/bin/hook-parity-check" || true
fi

exit 0
