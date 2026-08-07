| File | When to read |
| :--- | :--- |
| [@./CODING_GUIDELINES.md](./CODING_GUIDELINES.md) | Read when writing, editing, or reviewing code to understand the coding standards and how to avoid common mistakes. |
| [@./CONVERSATION.md](./CONVERSATION.md) | Read when generating responses to understand communication style preferences (e.g., concise, no emojis). |
| [@./DOCS_GUIDELINES.md](./DOCS_GUIDELINES.md) | Read when writing documentation, markdown files, commit messages, or updating task statuses. |
| [@./SUBAGENTS.md](./SUBAGENTS.md) | Read when you need to spawn subagents, parallelize work, or use Herdr. |
| [@./TOKEN_REDUCTION.md](./TOKEN_REDUCTION.md) | Load this when running shell commands, builds, or anything that produces large output. |

## Background tasks and long-running commands

- Always set an explicit timeout on background/waiting commands — 60 seconds by default. Never wait indefinitely.
- If a task may take longer than the timeout, make it emit progress logs to a file so it can be inspected, and check the file instead of blocking.
- Never end a live pipeline with a bare `| tail` (it buffers and looks stuck). Use `stdbuf -oL` on pipeline stages and redirect to a file, then read the file.
- Before starting any local server, kill stale listeners on its port first (`lsof -ti:PORT | xargs kill -9`).

## Commits

- Never `git add -A` or `git add .` — stage the specific files you touched, by path.
- Always ask before committing; I gate commits even when a project ritual says "commit per item". Exception: `/task:run --loop` commits automatically per step without asking — the loop is explicitly authorized to skip the gate for its whole run (the completion-tail commits after the loop still gate normally).
- The commit ask uses AskUserQuestion, never a prose "shall I commit?": first print the proposed commit message and the exact file list as message text, then offer options like `Commit (Recommended)` / `Don't commit yet` / `Adjust message or files`.

## IDE integration

- The JetBrains IDEA MCP is available when the IDE is open. Prefer it over asking me to run/paste: `mcp__idea__execute_run_configuration` to run apps/tests and capture their output, `mcp__idea__get_file_problems` for inspection results, `mcp__idea__build_project` for IDE builds. If I paste a stacktrace, first check whether you can reproduce it yourself via a run configuration.


