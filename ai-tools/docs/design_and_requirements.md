# AI Tools Configuration Generator - Design & Requirements

This document outlines the core requirements and design decisions for the `ai-tools` CLI application.

## 1. Project Goal
The primary goal is to manage AI assistant "slash commands" (prompts) using a **single source of truth**. This prevents the need to manually maintain duplicate prompt files for different AI tools (Claude Code and Gemini CLI) and ensures consistency across workflows.

## 2. Key Requirements

### 2.1. Master Templates
*   **Requirement:** Define a command once in a "master template" and generate tool-specific configurations from it.
*   **Implementation:**
    *   Templates are stored in the `templates/` directory as YAML files.
    *   They support EJS (Embedded JavaScript) templating to handle platform-specific logic within the prompt text (e.g., `<% if (platform === 'claude') { ... } %>`).

### 2.2. Multi-Target Output
The tool supports generating configurations for the following targets:

*   **Claude Code CLI:**
    *   Format: Markdown files (`.md`) with YAML frontmatter.
    *   Location: `~/.claude/commands/` (Global) or `./.claude/commands/` (Local).
*   **Gemini CLI:**
    *   Format: TOML files (`.toml`).
    *   Location: `~/.gemini/commands/` (Global) or `./.gemini/commands/` (Local).

### 2.3. Configurable Scope (Global vs. Local)
*   **Requirement:** Support both global user configuration (home directory) and project-specific configuration.
*   **Implementation:**
    *   **Default:** Updates global configuration in the user's home directory.
    *   **Flag:** The `--local` (or `-l`) flag switches the output target to the current working directory, allowing for project-specific command sets.

### 2.4. Smart State Management (Checkpoint Logic)
*   **Requirement:** The tool must be non-destructive to user-created files. It should only modify or delete files that *it* created.
*   **Implementation:**
    *   The tool maintains a "state file" (`state.json` or `.ai-tools-state.json` for local).
    *   This file tracks the list of commands currently managed by the tool.
    *   **Preservation:** If a user manually creates `manual-command.md` in the target folder, `ai-tools` will ignore it.
    *   **Cleanup:** If a template is removed from `templates/`, the tool detects this via the state file and removes the corresponding generated files only.

### 2.5. Ephemeral Output
*   **Requirement:** Generated files should not necessarily be committed to git. They are artifacts that can be regenerated on demand.
*   **Implementation:** The tool is designed to be run whenever templates are updated. Users are encouraged to git-ignore the generated output folders if they are local.

## 3. CLI Usage

To run the tool:

```bash
# Global update
ai-tools

# Local (project-specific) update
ai-tools --local
```

## 4. Template Format

Templates use YAML with EJS.

**Example `templates/review.yaml`:**

```yaml
name: review
description: "Review code for best practices"
args: "[files...]"
prompt: |
  Review the following code:
  
  <% if (platform === 'claude') { %>
  Files: $ARGUMENTS
  <% } else { %>
  Context provided in chat.
  <% } %>
```
