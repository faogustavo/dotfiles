# Template Conditions and Variables

This guide details the variables and conditionals available when writing `ai-tools` templates.

## Available Variables

The following variables are available within the EJS scope when a template is rendered.

### `platform`
The target platform for the current generation process. Use this to create platform-specific instructions or syntax.
- **Values**: `'claude'`, `'gemini'`

### Template Fields
All fields defined in your YAML template are available as variables. For example, if your YAML contains:

```yaml
name: my-tool
description: A useful tool
fileName:
  claude: tool.md
  gemini: tool.toml
```

You can access:
- `<%= name %>` -> "my-tool"
- `<%= description %>` -> "A useful tool"
- `<%= fileName.claude %>` -> "tool.md"

## Using Conditionals (EJS)

The system uses [EJS (Embedded JavaScript)](https://ejs.co/) for templating.

### Syntax
- **Control Flow** (if/else, loops): `<% ... %>`
  - Use `<% ... -%>` to trim the following newline (useful for keeping output clean).
- **Output Value** (escaped): `<%= ... %>`
- **Output Value** (unescaped): `<%- ... %>`

### Examples

#### Platform-Specific Instructions

Commonly used to handle differences in tool invocations or syntax.

```yaml
<% if (platform === 'claude') { -%>
You are running in Claude. Use the `SlashCommand` tool: `/run-prompt 001`
<% } else { -%>
You are running in Gemini. Use the command: `!{/run-prompt 001}`
<% } -%>
```

#### Adjusting Context or Paths

```yaml
Check the directory:
<% if (platform === 'claude') { -%>
./prompts/*.md (use Glob tool)
<% } else { -%>
./prompts/ (check file system)
<% } -%>
```

#### Using Metadata in Prompt

You can inject metadata directly into the prompt text to ensure the AI knows its own configuration.

```yaml
prompt: |
  <meta>
  Command Name: <%= name %>
  Description: <%= description %>
  </meta>

  Your instructions...
```

## Best Practices

1.  **Trim Whitespace**: Use the dash syntax (`<% ... -%>`) at the end of tags to prevent blank lines from cluttering the generated prompt.
2.  **Simple Logic**: Keep logic simple (mostly `if/else`). Complex logic should be handled in the generator code (`src/generators/*.js`).
3.  **Cross-Platform Compatibility**: Always provide an `else` block or ensure the default text works for all platforms if you are targeting multiple AIs.
