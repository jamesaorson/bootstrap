## Working Style

Prefer subagents for most substantive work. Keep the main thread for conversation, context-gathering, and planning with the user; delegate the actual execution (research, edits, multi-step tasks) to a subagent so the main thread stays available to steer.

- Fork (`subagent_type: "fork"`) when the work benefits from current context and its tool output isn't worth keeping.
- Fresh agent (Explore/general-purpose/Plan/etc.) when the task is self-contained and you can brief it cleanly.
- Solo in the main thread only for trivial one-shots or conversational turns.

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

@RTK.md
