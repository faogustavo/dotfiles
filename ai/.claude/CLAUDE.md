@../.agents/AGENTS.md

## Subagent model selection

- Always pass an explicit `model` when spawning subagents (Agent tool, workflow `agent()` calls) — they inherit the session model by default, and that may be Fable.
- Never use `fable` for subagents. Fable is user-selected only and runs only in the main conversation.
- Development/implementation work: `opus`.
- Documentation and focused research: `opus` or `sonnet` — pick by task complexity.
- Review work done: `sonnet`
- Parallel fan-out (deep research, many small focused workers): `sonnet` or `haiku` for the workers, `opus` for synthesis.