# AI Tools Configuration Generator

A CLI tool to manage and generate configuration files for AI assistants (Claude Code and Gemini CLI) from a single set of master templates.

## Documentation

*   [Design & Requirements](docs/design_and_requirements.md): Details on the architectural decisions and implemented features.

## Quick Start

1.  **Install Dependencies:**
    ```bash
    npm install
    ```

2.  **Define Templates:**
    Add `.yaml` files to the `templates/` directory.

3.  **Run Generator:**
    ```bash
    # Update global configs (~/.claude, ~/.gemini)
    ./bin/ai-tools

    # Update local configs (./.claude, ./.gemini)
    ./bin/ai-tools --local
    ```
