# CLI tooling — token efficiency

## RTK (Rust Token Killer)

Run common CLI tools through **RTK** (https://github.com/rtk-ai/rtk), which filters/summarizes noisy output to save context. **Default to `rtk` for every command that has an equivalent** — a `rtk discover` audit showed only ~1.4% of commands were using it, leaking ~135K tokens/week. Highest-impact ones to never call bare:

```bash
rtk read hot-reloading/server/build/reports/tests/test/index.html   # NOT cat — truncates huge files smartly
rtk find . -name "*BuiltIns.kt"                  # NOT find
rtk grep "evaluateExpression" -r interpreter/    # NOT grep — summarized, deduped matches
rtk git status / diff / log / add               # NOT git (see below)
rtk ls -la                                       # NOT ls -la
rtk gradlew :app:jvm:build                       # NOT ./gradlew — collapses progress/log spam
rtk gh pr list                                   # NOT gh pr list
```

Also wrapped: `rtk wc`, `rtk ps`, `rtk curl`, `rtk gh`, `rtk swift`, `rtk shellcheck`. Rule of thumb: if you're about to type a common read/search/build tool, prefix it with `rtk`.

**Not (yet) handled by RTK** — these have no `rtk` wrapper, so quiet them yourself: `xcodebuild` (→ `| xcpretty`, below), `ktlint`/`swiftlint` (use `--quiet`), `javap`/`nm`/`jar tf`/`objdump` (pipe through `rtk grep`/`grep` to filter, never dump whole disassembly/archive listings).

**Git operations must always go through `rtk`** — `rtk git status`, `rtk git diff`, `rtk git log`, etc. Git output is verbose and RTK consistently saves tokens on it; never call bare `git`.

If you don't have all information you need, don't repeat the command. You can grab the complete output from RTK dir: `~/Library/Application Support/rtk/tee/`. Usually the last line from the RTK call will contain the full path for it, like this: `[full output: ~/Library/Application Support/rtk/tee/1707753600_cargo_test.log]`.

If you want to disable the RTK truncating for a call, use the `rtk proxy`. It will run the command and give you the full output, while still tracking token consumption metrics:

```bash
rtk proxy <cmd>     # e.g. rtk proxy ./gradlew :interpreter:jvmTest --info  — runs the command verbatim, no filtering
```

Avoid calling binaries manually as I won't be able to track where the token consuption is high. Avoid things such as calling `/bin/cat long_file.txt`.

## Xcode / iOS builds

Pipe `xcodebuild` through `xcpretty` to cut the output way down:

```bash
xcodebuild -scheme <scheme> ... | xcpretty   # add `--simple` for even less
```