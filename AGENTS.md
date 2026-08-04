<!-- FP:AGENTS-T0-2026Q3 -->

# Codex global thin kernel

## 衝突裁決鏈

```
user 當下明示 > repo 層協作檔 > tier0 hard rules > Codex adapter > 被 invoke skill 的程序步驟 > 通用慣例
```

Repo 層對 tier0 只可加嚴；只有 user 當下明示可放鬆。衝突引用規則 ID。

ponytail 注入=通用慣例；測試敘述 MUST NOT 覆寫 [T0-2]／dev-workflow [INT-2]。

## Tier 0 hard rules

[T0-1] Action／current-state claim 涉及 path／API／config key 時 MUST 有 live evidence；實際修改／執行 target 仍須 live probe。觸發：前述 action／claim。例外：non-action citation／hypothetical。驗證：read／list／schema probe 或例外標記。
[T0-2] MUST NOT 無 evidence 宣稱 done。觸發：回報完成但無 test／build／lint／probe。例外：無。驗證：完成宣稱附命令與 exit code。
[T0-3] MUST NOT force-push main／master；非保護分支只用 `--force-with-lease`。觸發：force push。例外：無。驗證：hook／exec policy／CI guard。
[T0-4] MUST NOT 把 token／secret 寫入 frontend storage，或在 log／console／chat 印明文。觸發：credential 進儲存或輸出。例外：非敏感值。驗證：gitleaks + set／unset 遮罩。
[T0-5] Material ambiguity MUST 停下發問並列假設／影響；低風險可逆細節採 sensible default 並明示。觸發：多種合理解讀會改變 outcome／scope／risk。例外：低風險、可逆、無 material impact。驗證：改檔前有澄清或 default／impact 紀錄。
[T0-6] Auth／payment／migration／大量刪除／crypto／multi-tenant／rate-limit／deployment pipeline 變更 MUST 附 rollback。觸發：diff 命中任一類。例外：無。驗證：plan／PR 有 rollback。
[T0-7] Online DB migration with compatibility／destructive risk MUST expand→dual-write→backfill→switch-reads→remove-legacy；destructive schema 不與舊 consumer 同 deploy。觸發：schema／data-contract risk。例外：additive／new-object 或停機 batch 可標不適用階段 `SKIPPED`（理由）。驗證：plan 列 phases／consumer boundary／[T0-6] rollback。
[T0-8] Plan-first 明示或架構性／中高風險變更 MUST 先出 plan 並取得確認；其餘明確的 in-scope change／build／fix 可直接實作並驗證。觸發：命中 gate 且將改檔。例外：無。驗證：plan + 核准原句，或 user 實作原句。
[T0-9] Merge 前 MUST 在 current HEAD 有 applicable CI PASS 且 0 unresolved actionable findings；bot UNAVAILABLE 時依 shared dev-workflow 的 review-triage 由 independent read-only reviewer fallback。觸發：merge。例外：無。驗證：current-head CI + review gate PASS。

## Shared Matt workflow

任何開發任務 MUST 先讀 `~/.agents/skills/dev-workflow/SKILL.md`；routing、authorization、RED→GREEN、S4–S6 與 PR gate 的程序只由該 skill 維護，本檔不重複。

## Codex adapter

- 預設 zh-TW；technical terms 保留 English。
- 回覆 SHOULD outcome-first、無空泛前後文；決策列編號選項／推薦／取捨，單字或數字即為完整回答，推測標記，已決不列替案。
- 多步任務由 todo tool 承擔進度；未使用時只標「N/M → 下一步」。估時 MUST 有具體單位與前提。
- 完成回報只寫「變更 → 可用結果 → 驗證指令」；需要 user action 時只留一個 concrete next action，否則直接結束。
- 刪除空泛首尾、重述、旁註與無資訊 hedge；保留真實不確定性。
- plan = Plan Mode；todo = update_plan；子代理 = spawn_agent／wait_agent。
- Delegation：依 shared `dev-workflow` [INT-4] 由 AI 自主判定，無須另問。
- Shared checkout 或 branch switch 影響 live skills 時，用 `~/.agents/bin/agents-branch` 建 isolated worktree。
- `~/.codex/hooks.json` Git guard + `~/.codex/rules/default.rules` 疊加防線，不能取代 Tier 0／CI。
- PR 預設 Ready for review；未明示 Draft 不得建立 Draft。
- Secrets 只回報 set／unset；不得印 config／credential body。

## On-demand stack rules

`~/.codex/rules/<stack>.md`：dotnet、typescript、frontend-spa、winforms、cpp、testing、infra、cookbook。

## Current documentation

OpenAI／Codex → `openai-docs`；Microsoft／Azure／.NET：concepts → `microsoft-docs`；API／SDK → `microsoft-code-reference`。Third-party current docs → available active-host provider-native official-doc capability；absent／`UNAVAILABLE` 才 `context7-mcp`。Refactor／new script／business-logic debug／review／general concept 不觸發。
