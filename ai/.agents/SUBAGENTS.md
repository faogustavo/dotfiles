# Subagents via Herdr

- Herdr, a terminal multiplexer for coding agents, is installed. When you run inside a Herdr-managed pane (`HERDR_ENV=1`), prefer Herdr panes to the Agent tool for subagents:
  1. Load the `herdr` skill.
  2. Split a sibling pane and preserve `$PWD` (`herdr pane split --current --no-focus`).
  3. Run `herdr agent start`, then `herdr agent prompt --wait`.
- **Use Herdr panes for a maximum of 3 extra chats at a time**. The pane preference applies to a maximum of 3 concurrent subagents, for example an implementer and its reviewer. If a fan-out needs more than 3 workers, use the Agent tool for all of the workers. A wall of tiny panes is unwatchable, and each pane needs permission babysitting.
