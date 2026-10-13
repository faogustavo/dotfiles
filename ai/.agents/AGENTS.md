| File | When to read |
| :--- | :--- |
| [@./CODING_GUIDELINES.md](./CODING_GUIDELINES.md) | Read when writing, editing, or reviewing code to understand the coding standards and how to avoid common mistakes. |
| [@./CONVERSATION.md](./CONVERSATION.md) | Read when generating responses to understand communication style preferences (e.g., concise, no emojis). |
| [@./DOCS_GUIDELINES.md](./DOCS_GUIDELINES.md) | Read when writing documentation, markdown files, commit messages, or updating task statuses. |
| [@./SUBAGENTS.md](./SUBAGENTS.md) | Read when you need to spawn subagents, parallelize work, or use Herdr. |
| [@./TOKEN_REDUCTION.md](./TOKEN_REDUCTION.md) | Read when running shell commands, builds, or anything that produces large output. |

## Background tasks and long-running commands

- Always set an explicit timeout on background and waiting commands. The default timeout is 60 seconds. Never wait indefinitely.
- If a task may take longer than the timeout, make the task write progress logs to a file. Then check the file instead of blocking.
- Never end a live pipeline with a bare `| tail`. A bare `| tail` buffers the output, and the pipeline looks stuck. Use `stdbuf -oL` on the pipeline stages and redirect the output to a file. Then read the file.
- Before you start a local server, kill the stale listeners on its port (`lsof -ti:PORT | xargs kill -9`).

## Commits

- Never use `git add -A` or `git add .`. Stage the specific files that you touched, by path.
- Always ask before you commit. I gate commits even when a project ritual says "commit per item".
- Exception: `/task:run --loop` commits automatically per step and does not ask. The loop has explicit authorization to skip the gate for its whole run. The completion-tail commits after the loop still gate normally.
- Use AskUserQuestion for the commit ask, never a prose "shall I commit?". First, print the proposed commit message and the exact file list as message text. Then offer options such as `Commit (Recommended)` / `Don't commit yet` / `Adjust message or files`.

## IDE integration

- The JetBrains IDEA MCP is available when the IDE is open. Prefer the MCP over asking me to run something or paste output:
  - `mcp__idea__execute_run_configuration` runs apps and tests and captures their output.
  - `mcp__idea__get_file_problems` gives inspection results.
  - `mcp__idea__build_project` does IDE builds.
- If I paste a stacktrace, first check whether you can reproduce it yourself with a run configuration.
