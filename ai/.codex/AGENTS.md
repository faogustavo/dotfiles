@../.agents/AGENTS.md

## Subagent model selection

- Always pass an explicit `model` when spawning subagents — they inherit the session model by default, and that may be Sol.
- Planning work: `Sol`.
- Development/implementation work: `Terra`.
- Documentation and focused research: `Terra` or `Luna` — pick by task complexity.
- Review work done: `Luna`
- Parallel fan-out (deep research, many small focused workers): `Luna` or `Terra` for the workers, `Sol` for synthesis.