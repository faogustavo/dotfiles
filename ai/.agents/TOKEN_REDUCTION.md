# CLI tooling — token efficiency

## RTK (Rust Token Killer)

Run common CLI tools through **RTK** (https://github.com/rtk-ai/rtk). RTK filters and summarizes noisy output to save context. **Default to `rtk` for every command that has an equivalent.** A `rtk discover` audit showed that only ~1.4% of commands used RTK, which leaked ~135K tokens/week. Never call these highest-impact commands bare:

```bash
rtk read hot-reloading/server/build/reports/tests/test/index.html   # NOT cat — truncates huge files smartly
rtk find . -name "*BuiltIns.kt"                  # NOT find
rtk grep "evaluateExpression" -r interpreter/    # NOT grep — summarized, deduped matches
rtk git status / diff / log / add               # NOT git (see below)
rtk ls -la                                       # NOT ls -la
rtk gradlew :app:jvm:build                       # NOT ./gradlew — collapses progress/log spam
rtk gh pr list                                   # NOT gh pr list
```

RTK also wraps these commands: `rtk wc`, `rtk ps`, `rtk curl`, `rtk gh`, `rtk swift`, `rtk shellcheck`. Rule of thumb: if you are about to type a common read, search, or build tool, prefix it with `rtk`.

**RTK does not (yet) handle these tools.** They have no `rtk` wrapper, so quiet them yourself:

- `xcodebuild`: pipe the output through `xcpretty` (see below).
- `ktlint` and `swiftlint`: use `--quiet`.
- `javap`, `nm`, `jar tf`, and `objdump`: pipe the output through `rtk grep` or `grep` to filter it. Never dump whole disassembly or archive listings.

**Git operations must always go through `rtk`**: `rtk git status`, `rtk git diff`, `rtk git log`, etc. Git output is verbose and RTK consistently saves tokens on it. Never call bare `git`.

If you do not have all the information you need, do not repeat the command. Get the complete output from the RTK directory: `~/Library/Application Support/rtk/tee/`. Usually, the last line of the RTK output contains the full path, like this: `[full output: ~/Library/Application Support/rtk/tee/1707753600_cargo_test.log]`.

To disable RTK truncation for one call, use `rtk proxy`. It runs the command and gives you the full output. It still tracks token consumption metrics:

```bash
rtk proxy <cmd>     # e.g. rtk proxy ./gradlew :interpreter:jvmTest --info  — runs the command verbatim, no filtering
```

Do not call binaries manually (for example, `/bin/cat long_file.txt`). If you do, I cannot track where the token consumption is high.

## Xcode / iOS builds

Pipe `xcodebuild` through `xcpretty` to make the output much smaller:

```bash
xcodebuild -scheme <scheme> ... | xcpretty   # add `--simple` for even less
```
