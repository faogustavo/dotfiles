@../.agents/AGENTS.md

## Subagent model selection

- Always pass an explicit `model` when you spawn subagents. Subagents inherit the session model by default, and that model may be Sol.
- Planning work: `Sol`.
- Development and implementation work: `Terra`.
- Documentation and focused research: `Terra` or `Luna`. Pick by task complexity.
- Review of completed work: `Luna`.
- Parallel fan-out (deep research, many small focused workers): `Luna` or `Terra` for the workers, `Sol` for synthesis.
