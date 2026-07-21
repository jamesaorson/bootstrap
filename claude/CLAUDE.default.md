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
