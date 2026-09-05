# Ponytail downstream policy patch

User authorization: 2026-09-05「依照建議開始實作」, accepting the global Sol/Astra skill optimization plan. This owns a two-file downstream patch of the installed Ponytail 4.9.0 payload; it does not claim an upstream release. Upstream: https://github.com/DietrichGebert/ponytail (Dietrich Gebert, MIT; LICENSE retained).

Only the canonical skill and the hook builder's fallback change. Remove output/prose caps and the framework prohibition; finish all requested scope in full/ultra; reuse existing tests and applicable workflow checks. Keep initialization, mode tracking, SessionStart/SubagentStart handlers, helper skills and runtime code unchanged. The existing hooks continue to inject the same canonical source; there is no second hook or competing local skill.

`base/` contains the two exact original files for review and offline patch verification. `baseline-manifest.json` pins all 171 files of the source payload by SHA-256/mode/size; cache version alone is insufficient provenance. `ponytail.patch` is the maintained delta. `payload/` is an ignored, generated full local fork: do not hand-edit it. The wrapper marketplace's local source points to `./payload`; the embedded upstream marketplace in the copied payload is not the registry used for installation.

## Prepare a durable candidate

After this maintenance package is in the live Codex checkout, use the existing installed 4.9.0 source and an absent `payload` destination. This command verifies the entire source before copying, and applies only the reviewed patch in the owned copy. It does not install or change configuration.

```sh
python3 - <<'PY'
from pathlib import Path
import hashlib,json,os,shutil,stat,subprocess
root=Path.home()/'.codex/maintenance/ponytail'
source=Path.home()/'.codex/plugins/cache/ponytail/ponytail/4.9.0'
target=root/'payload'
expected=json.loads((root/'baseline-manifest.json').read_text())
assert not target.exists(), 'Refuse to overwrite an existing payload; inspect it first'
assert not any(p.is_symlink() for p in source.rglob('*')), 'Unexpected source symlink'
actual={str(p.relative_to(source)) for p in source.rglob('*') if p.is_file()}
assert actual==set(expected), 'Source inventory changed; review upstream before proceeding'
for name,entry in expected.items():
 p=source/name
 assert hashlib.sha256(p.read_bytes()).hexdigest()==entry['sha256'],name
 assert oct(stat.S_IMODE(p.stat().st_mode))==entry['mode'],name
shutil.copytree(source,target)
env=dict(os.environ,GIT_CEILING_DIRECTORIES=str(root))
subprocess.run(['git','apply','--check',str(root/'ponytail.patch')],cwd=target,env=env,check=True)
subprocess.run(['git','apply',str(root/'ponytail.patch')],cwd=target,env=env,check=True)
print('Prepared owned payload; not installed')
PY
```

The source pair before patch: SKILL `1316a2f3f95741d2300b116fe0c2d81ce4a9568656ed0a62643f54aaf09957f2`, fallback `23c050103f28dbe6bad953ae21d98cd06d720a20f33d4716e9de419f947d495e`. After patch: SKILL `1905c0e8661e5ed43716230da818bd6d882d6df904fbc831f2e619bdacfaf7aa`, fallback `4c5694d6e501d74db65174787545b213d5ef6565866ccfaa53309615fd69cb77`.

## Install and observe

Only after repository/model gates pass, register this wrapper root as local marketplace `ponytail` and reinstall `ponytail@ponytail` using the native Codex plugin commands. Keep the existing plugin ID, enabled setting, trusted-hash fields and all hook handlers. The intended source is `$HOME/.codex/maintenance/ponytail`, source_type `local`; an invocation override alone does not replace an existing installed cache.

CLI 0.153.3 supports `codex plugin marketplace add <local-root> --json` and `codex plugin add ponytail@ponytail --json`. Verify existing-ID handling before making a completion claim. Native installation copies the source into a managed local cache; verify the resolved skill/hook paths and hashes through fresh `skills/list`/`hooks/list`, plus actual root/subagent hook output. Cache files are installation artifacts, not the authoring source. Do not manually patch a cache or bypass hook trust.

A current session retains previously injected instructions. Full/ultra controlled model comparisons and upstream hook tests do not alone prove Desktop SessionStart/resume/compact/SubagentStart activation. Report each unobserved path explicitly.

## Verification and rollback

`bash tests/ponytail-fork.sh` verifies exact forward/reverse patch application, resulting hashes, JS syntax and retained full-scope behavior without installation. On the complete candidate, run the existing hook tests and invariants:

```sh
node --test tests/hooks.test.js tests/hooks-windows.test.js pi-extension/test/helpers.test.js pi-extension/test/extension.test.js
node scripts/check-rule-copies.js
node scripts/check-versions.js
```

These passed before/after in the full local candidate (30 Node test entries; Windows shapes tested on macOS). They are not a Windows host canary.

Rollback before activation leaves the old installed plugin selected. After activation, restore the recorded original Git marketplace source `https://github.com/DietrichGebert/ponytail.git` and the previous installed 4.9.0 selection using verified native plugin behavior; do not assume changing source alone switches the cache. Preserve the original cache and installation metadata until that rollback path is proven. Never reset unrelated config, mode state, other plugins or trust settings.

At an upstream update, compare all source files with the pinned manifest. A mismatch stops automatic reuse: inspect new consumers/manifests, rebase the two-file patch and repeat tests/model canaries. Regenerate fingerprints only after review. Repository rollback is a revert of this maintenance package; installed-state rollback is separate.

Controlled model evidence: [model-evidence.json](model-evidence.json), eight full/ultra × old/new × Sol/Astra runs at fixed high effort. Both versions completed all requested behavior and reused unittest; each result passed 54 independent API/caller checks. This supports no regression in these cases, not a speed or universal quality claim. Actual installed root/subagent hook observation remains a distinct activation gate.

## Codex-only skill exposure

[exposure.json](exposure.json) selects four names for `skills.config` entries with `enabled=false`: the three Codex rescue helpers and Ponytail gain. [exposure-evidence.json](exposure-evidence.json) records the native prompt-input observer removing exactly those four entries (92→88), with no unexpected additions. This controls catalog exposure only: keep both plugins enabled, their tools/runtime and all hook handlers installed. Claude configuration is not changed.

After repository gates, merge these four selectors into the existing skills configuration through the native config API, preserving unrelated entries and using the current config version. Re-run the observer and hook metadata probe. Rollback removes only the four entries added by this change, or restores a matching entry's recorded previous value; never replace the full config. Chrome and plugin React remain exposed until their distinct capability canaries pass.

Keep `ponytail:ponytail-review` enabled: the unchanged mode tracker recognizes `@ponytail-review`, persists review mode, and SubagentStart emits a pointer to that skill. Disabling it would remove the rules behind a retained runtime mode. Its catalog overlap is therefore insufficient justification for removal.
