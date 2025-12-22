# How to Convert Markdown Prompts to Templates

This guide explains how to convert standalone Markdown prompt files into the `ai-tools` template system.

## Template System Overview

The `ai-tools` project generates platform-specific configurations (Claude `.md` prompts and Gemini `.toml` configs) from a single "master" YAML template located in the `templates/` directory.

### Why convert?
*   **Single Source of Truth**: Maintain one template for multiple AI platforms.
*   **Dynamic Content**: Use EJS templating to inject platform-specific context.
*   **Centralized Management**: Easily update descriptions, tools, and arguments in one place.

## Template Structure

Templates are YAML files stored in `templates/`.

```yaml
name: my-command          # Required: Base name of the output file (e.g., my-command.md)
description: "Do stuff"   # Required: Short description
args: "[arg1] [arg2]"     # Optional: Argument hints
claude_specific:          # Optional: Fields specific to Claude frontmatter
  allowed-tools: ["Read"]
gemini_specific:          # Optional: Fields specific to Gemini TOML output
  # key: value            # (e.g. custom fields supported by your specific CLI version)
prompt: |                 # Required: The actual prompt content
  Your prompt text here...

  <% if (platform === 'claude') { %>
  Use the files in: $ARGUMENTS
  <% } else { %>
  Use the provided context.
  <% } %>
```

## Step-by-Step Conversion

Follow these steps to convert an existing `.md` file (e.g., `sample/generate-prompt-slash.md`) into a template.

### 1. Create the YAML File
Create a new file in `templates/` with a descriptive name, e.g., `templates/generate-prompt.yaml`.

### 2. Extract Metadata (Frontmatter)
Look at the frontmatter (the YAML block at the top) of your source Markdown file.

**Source (`sample/generate-prompt-slash.md`):**
```yaml
---
description: Create a new prompt that another Claude can execute
argument-hint: [task description]
allowed-tools: [Read, Write, Glob, SlashCommand, AskUserQuestion]
---
```

**Target (`templates/generate-prompt.yaml`):**
Map these fields to the template structure:

*   `description` -> `description`
*   `argument-hint` -> `args`
*   `allowed-tools` -> `claude_specific.allowed-tools` (since this is a Claude-specific feature)

```yaml
name: generate-prompt
description: "Create a new prompt that another Claude can execute"
args: "[task description]"
claude_specific:
  allowed-tools: ["Read", "Write", "Glob", "SlashCommand", "AskUserQuestion"]
```

### 3. Extract Prompt Content
Copy the body of the Markdown file (everything after the second `---`) into the `prompt` field using a YAML block scalar (`|`).

**Important**: Ensure proper indentation. The content inside `prompt: |` must be indented relative to `prompt:`.

```yaml
prompt: |
  <context>
  Before generating prompts, use the Glob tool...
  </context>
  
  ... rest of the file ...
```

### 4. Add Platform Logic (Optional)
If the prompt refers to variables like `$ARGUMENTS` which might differ between platforms, or if you want to give specific instructions for Gemini vs Claude, use EJS tags:

*   `<% if (platform === 'claude') { %> ... <% } %>`
*   `<% if (platform === 'gemini') { %> ... <% } %>`

### Handling Claude-Specific Tools
Some tools like `SlashCommand` and `AskUserQuestion` are specific to Claude. Use conditionals to provide alternatives for other platforms (like Gemini).

**SlashCommand:**
Claude uses `/command args` via the SlashCommand tool. Gemini typically uses `!{/command args}` syntax or instructions to the user.

```yaml
<% if (platform === 'claude') { -%>
Use the SlashCommand tool to run: `/run-prompt 001`
<% } else { -%>
Run the command: `!{/run-prompt 001}`
<% } -%>
```

**AskUserQuestion:**
Claude has a structured `AskUserQuestion` tool. For other platforms, instruct the agent to ask the user directly.

```yaml
<% if (platform === 'claude') { -%>
Use AskUserQuestion to get the user's preference.
<% } else { -%>
Ask the user for their preference.
<% } -%>
```

### 5. Verify
Run the generator tool to verify the output:
```bash
npm start -- --local
```
This will generate the output files in your local `ai-tools` configuration (or where configured). Check the generated `claude/*.md` and `gemini/*.toml` files to ensure they look correct.

## Example: Converting `generate-prompt-slash.md`

**`templates/generate-prompt.yaml`**

```yaml
name: generate-prompt
description: Create a new prompt that another Claude can execute
args: "[task description]"
claude_specific:
  allowed-tools: 
    - Read
    - Write
    - Glob
    - SlashCommand
    - AskUserQuestion
prompt: |
  <context>
  Before generating prompts, use the Glob tool to check `./prompts/*.md` to:
  1. Determine if the prompts directory exists
  2. Find the highest numbered prompt to determine next sequence number
  </context>
  
  <objective>
  Act as an expert prompt engineer for Claude Code...
  ...
  (paste the rest of the markdown content here)
```
