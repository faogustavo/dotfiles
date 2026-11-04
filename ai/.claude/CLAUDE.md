@../.agents/AGENTS.md

## Subagent model selection

- Always pass an explicit `model` when you spawn subagents (Agent tool, workflow `agent()` calls). Subagents inherit the session model by default, and that model may be Fable.
- Never use `fable` for subagents. Only the user selects Fable, and Fable runs only in the main conversation.
- Development and implementation work: `opus`.
- Documentation and focused research: `opus` or `sonnet`. Pick by task complexity.
- Review of completed work: `sonnet`.
- Parallel fan-out (deep research, many small focused workers): `sonnet` or `haiku` for the workers, `opus` for synthesis.

## Subagent concurrency

- Run a maximum of 2 subagents at the same time. This limit applies to every kind of subagent (Agent tool, workflow `agent()` calls, Herdr panes) and overrides any skill that asks for maximum concurrency.
- When more work is ready, queue it. Start the next subagent only when a running one finishes.
