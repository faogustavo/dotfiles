# Subagents via Herdr

- Herdr (terminal multiplexer for coding agents) is installed. When running inside a Herdr-managed pane (`HERDR_ENV=1`), prefer launching subagents in Herdr panes instead of the Agent tool: load the `herdr` skill, split a sibling pane (`herdr pane split --current --no-focus`, preserving `$PWD`), then `herdr agent start` + `herdr agent prompt --wait`.
- **Herdr panes only for up to 3 extra chats at a time.** The pane preference applies to at most 3 concurrent subagents (e.g. an implementer + its reviewer). A fan-out needing more than 3 workers uses the Agent tool for all of them instead — a wall of tiny panes is unwatchable and each pane needs permission babysitting.
