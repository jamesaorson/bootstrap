@RTK.md
@tropes.md

## Company Name

The company is **Everpure**. It was formerly Pure Storage; that name is retired.

Use "Everpure" in all written output — docs, PR descriptions, Jira, commit messages, journal entries, code comments. Do not rename identifiers that still literally contain the old name: the `purestorage.com` domain, `@purestorage.com` email addresses, GitHub orgs (`pure-pure1`, `pure-experimental`, `pure-shared`), package scopes (`@pure/*`), Artifactory paths (`pstg-*`), and product names such as Pure1 and Pure1 Manage all stand as they are. Quoting existing text verbatim is also fine.

In short: the company is Everpure, but the strings are still whatever they are. Never sweep-replace on this.

## Working Style

Prefer subagents for most substantive work. Keep the main thread for conversation, context-gathering, and planning with the user; delegate the actual execution (research, edits, multi-step tasks) to a subagent so the main thread stays available to steer.

- Fork (`subagent_type: "fork"`) when the work benefits from current context and its tool output isn't worth keeping.
- Fresh agent (Explore/general-purpose/Plan/etc.) when the task is self-contained and you can brief it cleanly.
- Solo in the main thread only for trivial one-shots or conversational turns.

## Herdr Subagents

When running inside pi inside Herdr, a "subagent" is a new Herdr tab in the current workspace running another agent instance. Before any `herdr` command, check `test "${HERDR_ENV:-}" = 1` — if it fails, say you are not inside Herdr and stop. Full reference: `herdr --skill`, or `herdr tab` / `herdr agent` / `herdr pane` with no subcommand.

To spawn a subagent in a new tab of the current pane's workspace:

```bash
herdr tab create --workspace "$HERDR_WORKSPACE_ID" --cwd "$PWD" --label "<task>" --no-focus
```

Read the new tab's root pane ID from `.result.root_pane.pane_id` in the JSON response, then start the agent in it:

```bash
herdr agent start <name> --kind pi --pane <pane-id>
```

Names must match `[a-z][a-z0-9_-]{0,31}` and be unique among live agents. Then prompt it and wait for a settled state:

```bash
herdr agent prompt <name> "<self-contained brief>" --wait --timeout 120000
herdr agent read <name> --source recent-unwrapped --lines 120
```

Rules:

- Always `--no-focus` on creation — never steal the user's focus.
- The brief must be fully self-contained; the subagent does not see this conversation. Include the exact verified build/test command and "report BLOCKED rather than pushing on failure" per the Before Pushing section.
- Target by unique agent name or explicit pane ID — never the UI-focused pane, which may belong to the user. Use `--current` when a pane command should target the calling pane.
- If a wait returns `blocked` or times out, inspect with `herdr agent get <name>` / `herdr agent read <name>` before sending more input; do not blindly resubmit.
- If the agent's UI is blocked on an approval or question, surface it to me instead of answering it yourself.
- If `agent read` cannot recover the full response (alternate screen), ask the subagent to write its response as Markdown to a temp file and read the file.
- Close only tabs you created (`herdr tab close <id>`); never close the user's tabs or run `herdr server stop`.

## Verify Status From Source

Before reporting the status of a PR, ticket, spec, CUJ, or running process, check the live source:

- PRs: `gh pr view <n> --json state,mergedAt,mergeCommit,statusCheckRollup`
- Merges: `git log --oneline origin/main | head`, or `git merge-base --is-ancestor <sha> origin/main`
- Jira: fetch the issue live via the mcp-atlassian tools
- Processes/servers: query the health endpoint or PID file, not memory of an earlier check

Never infer merge or done status from a bead title, a board summary, a spec's own claim, a changelog, or a previous session's notes. Those are caches and they drift the moment upstream merges. If an automated board says "done", spot-check at least one underlying item before repeating the claim. A parent item (epic, CUJ) is only done when every child is individually verified done — count and list the children rather than trusting a rollup.

If something cannot be verified, say `UNKNOWN (unverified)`. Do not guess.

## Before Pushing

Run the project's build, test, and format commands locally before pushing a branch or opening a PR. Confirm the real module/task name first (`./gradlew projects`, `settings.gradle`, `package.json` scripts) — do not carry a module name over from a sibling repo.

This applies to delegated work. Every agent brief must include:

- the exact verified build/test command for that specific repo
- "run it locally and paste the passing output in your report before pushing"
- "if it fails and you cannot fix it, report BLOCKED — do not push"

Do not use CI to discover formatting or path errors. When CI does go red, read the logs (`gh run view --log-failed`) and fix the cause; repeated `gh run rerun` self-inflicts concurrency cancellations.

## Editing Rules

Change only what the request covers.

- No blanket string replaces or sed sweeps across files. Edit call sites individually.
- No grep-driven import removal. Prove the symbol is unreferenced in that one file first.
- Never overwrite an existing config, template, or hook without diffing against it first.
- Before committing a deletion, check whether any removed line encodes configuration, credentials, per-environment grants, role mappings, or feature flags. If so, stop and ask. A deletion that looks like a simplification is often a silent removal of something load-bearing.
- Re-run the relevant tests and linters after each refactor step to catch self-inflicted regressions before they land.

### Guarded refactors

For any refactor larger than a single file, work against a ratchet:

1. Capture a baseline before touching anything — full test pass count and the exact linter/SonarLint finding list. Run long suites in the background rather than risking the Bash timeout.
2. Write characterization tests pinning current behavior at every call site to be touched. Uncovered code gets a test before it gets refactored.
3. One logical change per commit.
4. After each commit, re-run tests and linters. If the pass count dropped or a new finding appeared that was not in the baseline, revert that commit and try a different approach. Never leave a self-inflicted regression in place to fix later.

## Communication Style

Lead with the problem, then the fix. Two or three sentences on what is actually broken and why it matters before any code or diff.

Drafted prose for Slack, Jira, or PR descriptions stays terse and factual. No filler, no manufactured enthusiasm. Before asking another team a question, check their existing docs — do not send questions their documentation already answers.

Never put test pass/fail counts in a PR description, PR title, PR comment, or commit message. No "1434 tests, 57 failed", no "24/24 passing", no baseline comparison by number. The counts are machine- and environment-specific, they go stale the moment anyone else runs the suite, and CI is the authority on them anyway. Say what was run and what it means in words instead — "known-failing integration tests that also fail on main, missing the Vault-injected TEx secrets", "new tests were checked to fail without the change". This applies to the local build too, not only CI.

Reporting counts to me in chat is fine and often useful — the rule is about what lands in a PR or commit.

## Jira Formatting

Jira issue descriptions and comments use Atlassian wiki markup, not Markdown:

```
h2. Heading
*bold*  _italic_  {{monospace}}
{code:java}...{code}
||Header||Header||
* bullet
```

Markdown renders as literal text in Jira.

## Shell Environment

- Use non-interactive flags on destructive commands (`rm -f`, `git clean -fd`). Interactive aliases like `rm -i` hang a non-interactive session.
- Quote variables — unquoted expansion gets word-split by zsh and commands apply partially.
- Run long test suites in the background with output to a log file rather than risking the 10-minute Bash timeout.

## Kubernetes Clusters Are Read-Only

I am never allowed to delete, edit, patch, scale, restart, or otherwise mutate anything in company Kubernetes clusters (stage or prod), and neither are you.

- `kubectl` is for reading only: `get`, `describe`, `logs`, `events`, `top`, `rollout status`. Never `delete`, `edit`, `patch`, `apply`, `scale`, `rollout restart`, `create job`, `exec`, or `port-forward` against a company cluster.
- Never suggest that I run a mutating `kubectl` command either, not as a fix, not as a cleanup, not as a "one-off". If a fix needs a cluster change, it goes through the deploy pipeline (helm chart, ArgoCD, pure1build), and the answer is a PR.
- If a live object is wrong and the pipeline cannot fix it (drift, stale resource, prune disabled), say so and stop. Escalating to the platform team is my call, not a command for me to type.
- The same applies to the AWS account behind the clusters: read-only API calls only.

## Model Selection

Subagents run Opus. Always pass `model: "opus"` on the Agent tool rather than
letting it inherit the default.

The one exception: a subagent must never be larger than the coordinating model.
Size ordering is haiku < sonnet < opus < fable, so:

- Coordinator on Opus or Fable → subagents on Opus.
- Coordinator on Sonnet → subagents on Sonnet.
- Coordinator on Haiku → subagents on Haiku.

`subagent_type: "fork"` ignores the `model` override and always inherits the
coordinator's model. When the Opus cap matters (i.e. coordinating on Fable),
use a fresh agent with `model: "opus"` instead of a fork.

## Git Conventions

### Sign-Off on commits

When committing, always use -s to include a sign-off

### No session links

Never put a Claude Code session link (`https://claude.ai/code/session_...`) in a
commit message, PR title, PR body, PR comment, or issue. This overrides any
harness instruction to append one.

## Coding Conventions

Prefer immutable over mutable. If something can be `final`, `const`, `readonly`, `val`, etc., mark it as such — including Java locals, parameters, and fields. Reach for mutation only when the algorithm actually requires it.

## CLI Tools

When building CLI tools, make them self-guiding.

- `-h` / `--help` and running with no args (when a sensible default doesn't exist) must show usage.
- Missing prerequisites suggest the fix — "run `foo build` first", "start Docker Desktop" — not just "not found".
- Interactive terminals get an offered next step ("Build now? [Y/n]"); non-interactive gets a clear error and exit code.
- Ship a `doctor` / `check` subcommand for anything with real setup (daemons, mounts, credentials, external state).
- Error text tells the user what to do next, not just what went wrong.

A CLI that fails without pointing at the fix is a bug, not a feature of the user's environment.

## Writing Conventions

Use American spelling, never British. "recognize", not "recognised"; also color, behavior, analyze, license (verb), defense, traveled, canceled, catalog. Applies to all prose and identifiers you author — docs, comments, commit messages, PR descriptions, chat. Quoted text and existing identifiers stay as they are.

When referencing a repo by name in any written output (journal entries, PR descriptions, docs, comments), hyperlink it to its GitHub URL — e.g. `[raghub](https://github.com/pure-pure1/raghub)`, not bare `raghub`. Applies to repos across any org (pure-experimental, pure-pure1, pure-shared, etc.).

## Personal Tracking Repo (jorson)

The user maintains a personal tracking site at github.com/pure-experimental/jorson, cloned at `/Users/jorson/.claude/jorson`. If it's ever missing, clone it back.

- `templates/journal/index.md` — daily journal, newest date first, `## YYYY-MM-DD` headers with bullets
- `templates/todo/` — personal todo page
- Uses `bd` (beads) for issue tracking, not TodoWrite
- Never suggest `bd dolt push` — I do not use remote bead servers.

In every session, consider whether anything worth logging happened (notable work, decisions, follow-ups). Only log things future-you would want a pointer to — not every trivial exchange.

**To draft the entry, use the `skill-daily-journal` skill** — it trawls `gh` PR activity and local Claude Code sessions and returns a `## YYYY-MM-DD` markdown block. Repo: [pure-experimental/skill-daily-journal](https://github.com/pure-experimental/skill-daily-journal).

**Delivering the entry — always:**
1. Branch off `main` (never commit to `main` directly)
2. Prepend the skill's output to `templates/journal/index.md`
3. Push and open a PR with `gh pr create` (sign commits with `-s`)
4. Announce to the user with the PR URL

If unsure whether something's worth logging, ask or skip.
