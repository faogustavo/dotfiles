# AI Agents Configuration & Tooling

At this time, I use these AI agents:

- Claude Code
- Codex
- Antigravity (CLI and IDE)
- Junie (CLI and IDE)
- Copilot (IDE Integration)

To support all of them, a default `~/.agents/AGENTS.md` file gives every agent the same base set of instructions.

Each agent also has an additional file. Each agent configuration lives in its own home folder and links the common `.agents/AGENTS.md` for the shared blocks.

To configure it, link the configs to the appropriate folder:

```bash
mkdir -p ~/.agents ~/.claude-faogustavo ~/.codex ~/.junie ~/.copilot ~/.gemini

for file in ~/Developer/github.com/faogustavo/dotfiles/ai/.agents/*; do ln -s "$file" ~/.agents/; done
for file in ~/Developer/github.com/faogustavo/dotfiles/ai/.claude/*; do ln -s "$file" ~/.claude-faogustavo/; done
for file in ~/Developer/github.com/faogustavo/dotfiles/ai/.codex/*; do ln -s "$file" ~/.codex/; done
for file in ~/Developer/github.com/faogustavo/dotfiles/ai/.junie/*; do ln -s "$file" ~/.junie/; done
for file in ~/Developer/github.com/faogustavo/dotfiles/ai/.copilot/*; do ln -s "$file" ~/.copilot/; done
for file in ~/Developer/github.com/faogustavo/dotfiles/ai/.gemini/*; do ln -s "$file" ~/.gemini/; done
```

## Herdr

To use agents better, I am experimenting with herdr: https://herdr.dev/

Install herdr with the instructions on that site. Include all the integrations that you need: https://herdr.dev/docs/integrations/

```bash
herdr integration install claude
herdr integration install codex
herdr integration install copilot
herdr integration install antigravity-cli
```

> Note that Junie has no herdr integration yet.

Also install the herdr skills for the agents, for the best support.
See the Skills section for more details.

## RTK

Rust Token Killer (RTK) decreases token usage in agents.
It filters the output of commands and keeps only the relevant information.
For the installation steps, refer to https://github.com/rtk-ai/rtk.

This folder has an RTK config. Link it to `~/Library/Application Support/rtk/config.toml`:

```bash
ln -s ~/Developer/github.com/faogustavo/dotfiles/ai/rtk/config.toml ~/Library/Application\ Support/rtk/config.toml
```

The agents files already contain the RTK rules. I also recommend that you run the init script to include the hook calls.

```bash
rtk init -g                     # Claude Code / Copilot (default)
rtk init -g --gemini            # Gemini CLI
rtk init -g --codex             # Codex (OpenAI)
```

## Skills

At this time, these are the only skills/plugins:

- android-cli skills
- herdr skills

To install the Android CLI skills:
```bash
android skills add android-cli
android skills add navigation-3
```

To install the herdr skills:
```bash
npx skills add herdrdev/herdr --skill herdr -g
```

## Personal vs Work accounts

At this time, Claude Code is the only agent for which I have different accounts for work and personal projects.
All the other agents stay the same. Only Claude Code needs an additional folder in the user home.

### Claude Code

To have different Claude Code environments per project, I use direnv to set `CLAUDE_CONFIG_DIR`.

At this time, the root folder is for work, because I use it the most. The secondary folder is for personal information.

- `export CLAUDE_CONFIG_DIR=~/.claude-faogustavo`

direnv loads the .env in my personal projects and changes the configuration folder when needed.
