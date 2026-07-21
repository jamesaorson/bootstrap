## Working Style

Prefer subagents for most substantive work. Keep the main thread for conversation, context-gathering, and planning with the user; delegate the actual execution (research, edits, multi-step tasks) to a subagent so the main thread stays available to steer.

- Fork (`subagent_type: "fork"`) when the work benefits from current context and its tool output isn't worth keeping.
- Fresh agent (Explore/general-purpose/Plan/etc.) when the task is self-contained and you can brief it cleanly.
- Solo in the main thread only for trivial one-shots or conversational turns.

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

@RTK.md

## Writing Conventions

When referencing a repo by name in any written output (journal entries, PR descriptions, docs, comments), hyperlink it to its GitHub URL — e.g. `[raghub](https://github.com/pure-pure1/raghub)`, not bare `raghub`. Applies to repos across any org (pure-experimental, pure-pure1, pure-shared, etc.).

## Personal Tracking Repo (jorson)

The user maintains a personal tracking site at github.com/pure-experimental/jorson, cloned at `/Users/jorson/.claude/jorson`. If it's ever missing, clone it back.

- `templates/journal/index.md` — daily journal, newest date first, `## YYYY-MM-DD` headers with bullets
- `templates/todo/` — personal todo page
- Uses `bd` (beads) for issue tracking, not TodoWrite

In every session, consider whether anything worth logging happened (notable work, decisions, follow-ups). Only log things future-you would want a pointer to — not every trivial exchange.

**To draft the entry, use the `skill-daily-journal` skill** — it trawls `gh` PR activity and local Claude Code sessions and returns a `## YYYY-MM-DD` markdown block. Repo: [pure-experimental/skill-daily-journal](https://github.com/pure-experimental/skill-daily-journal).

**Delivering the entry — always:**
1. Branch off `main` (never commit to `main` directly)
2. Prepend the skill's output to `templates/journal/index.md`
3. Push and open a PR with `gh pr create` (sign commits with `-s`)
4. Announce to the user with the PR URL

If unsure whether something's worth logging, ask or skip.
