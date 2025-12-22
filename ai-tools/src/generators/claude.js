const fs = require('fs-extra');
const path = require('path');
const ejs = require('ejs');
const yaml = require('js-yaml');

async function generateClaude(template, outputDir) {
  const content = ejs.render(template.prompt, { platform: 'claude', ...template });
  
  const frontmatter = {
    description: template.description,
  };

  if (template.args) {
    frontmatter['argument-hint'] = template.args;
  }
  
  if (template.claude_specific) {
    Object.assign(frontmatter, template.claude_specific);
  }

  // Create yaml string, trim the first line '---' if js-yaml adds it, or construct manually to be safe.
  // js-yaml dump usually creates clean yaml. We need to wrap it in --- ---.
  const yamlStr = yaml.dump(frontmatter).trim();
  
  const fileContent = `---
${yamlStr}
---
${content}`;
  
  let filename = `${template.name}.md`;
  if (template.fileName && template.fileName.claude) {
    filename = template.fileName.claude;
  }

  const filePath = path.join(outputDir, filename);
  await fs.ensureDir(path.dirname(filePath));
  await fs.writeFile(filePath, fileContent);
  return filename;
}

module.exports = generateClaude;
