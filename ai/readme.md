# AI Agents Configuration & Tooling

As of now, those are the AI agents that I'm using:

- Claude Code
- Codex
- Antigravity (CLI and IDE)
- Junie (CLI and IDE)
- Copilot (IDE Integration)

To ensure that all of them gets supported, a default ~/.agents/AGENTS.md file will be created so every agent get the same base set of instructions.

Then, per agent, an additional file will be created. Each agent configuration will live in their own home folder, and link the common .agents/AGENTS.md for the shared blocks.

To configure it, link the configs to the appropiate folder:

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

For a better usage of agents, I'm experimenting with herdr: https://herdr.dev/
Install following the instructions, and include all integrations that you need: https://herdr.dev/docs/integrations/

```bash
herdr integration install claude
herdr integration install codex
herdr integration install copilot
herdr integration install antigravity-cli
```

> Note that Junie has not herdr integration yet.

The skills should also be installed for them, to ensure the optimal support. 
Check the Skill section for more details.

## RTK

Rust Token Killer (aka RTK) is a way to improve token usage in agents.
It filter the output of commands to keep only relevant information. 
For installation steps, refer to https://github.com/rtk-ai/rtk.

There is a pre-created rtk config and it should be linked in the `~/Library/Application Support/rtk/config.toml`.

```bash
ln -s ~/Developer/github.com/faogustavo/dotfiles/ai/rtk/config.toml ~/Library/Application\ Support/rtk/config.toml
```

The RTK rules are pre-built/configured in the agents file, but we also recommend running the init script to include the hook calls.

```bash
rtk init -g                     # Claude Code / Copilot (default)
rtk init -g --gemini            # Gemini CLI
rtk init -g --codex             # Codex (OpenAI)
```

## Skills

As of now, the only skills/plugins

- android-cli skills
- herdr skills

To install the Android CLI skills:
```bash
android skills add android-cli
android skills add navigation-3
```

To install herdr skills:
```bash
npx skills add herdrdev/herdr --skill herdr -g
```

## Personal vs Work accounts

As of now, the only agent that I have different accounts to work and personal projects is claude.
All others remain the same, only claude code needs an additional folder created at the user home.

### Claude Code

To ensure that we can have different Claude Code environment in the project, we use direnv to set the `CLAUDE_CONFIG_DIR`.

As of now, the root file is for work, as that's used the most, and the secondary folder used for personal information.

- `CLAUDE_CONFIG_DIR=~/.claude-faogustavo

I'm using direnv to load the .env in my personal projects and swap the configuration folder when needed.
