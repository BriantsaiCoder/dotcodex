#!/usr/bin/env bash
set -euo pipefail
root=$(cd "$(dirname "$0")/.." && pwd)
fork="$root/maintenance/ponytail"
probe=$(mktemp -d "${TMPDIR:-/tmp}/ponytail-fork.XXXXXX")
trap 'rm -rf "$probe"' EXIT
cp -R "$fork/base/." "$probe/"
(cd "$probe" && git apply --check "$fork/ponytail.patch" && git apply "$fork/ponytail.patch")
python3 - "$probe" "$fork/baseline-manifest.json" <<'PY'
import hashlib,json,pathlib,sys
root=pathlib.Path(sys.argv[1]);manifest=json.loads(pathlib.Path(sys.argv[2]).read_text())
expected={
 'skills/ponytail/SKILL.md':'1905c0e8661e5ed43716230da818bd6d882d6df904fbc831f2e619bdacfaf7aa',
 'hooks/ponytail-instructions.js':'4c5694d6e501d74db65174787545b213d5ef6565866ccfaa53309615fd69cb77',
}
for name,sha in expected.items():
 assert hashlib.sha256((root/name).read_bytes()).hexdigest()==sha,name
 assert name in manifest
text=(root/'skills/ponytail/SKILL.md').read_text()
assert 'at most three short lines' not in text
assert 'No frameworks, no' not in text
assert 'Complete all requested behavior' in text
exposure=json.loads((pathlib.Path(sys.argv[2]).parent/'exposure.json').read_text())
assert 'ponytail:ponytail-review' not in exposure['disable_names'], 'review mode requires the ponytail-review skill'
print('PASS: exact patch, complete scope and retained review-mode skill')
PY
node --check "$probe/hooks/ponytail-instructions.js"
(cd "$probe" && git apply --reverse --check "$fork/ponytail.patch" && git apply --reverse "$fork/ponytail.patch")
diff -r "$fork/base" "$probe"
