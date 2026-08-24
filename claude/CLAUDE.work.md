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

## Git Conventions

### Sign-Off on commits

When committing, always use -s to include a sign-off

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
