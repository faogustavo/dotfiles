const fs = require('fs-extra');
const path = require('path');
const ejs = require('ejs');
const toml = require('@iarna/toml');

async function generateGemini(template, outputDir) {
  const content = ejs.render(template.prompt, { platform: 'gemini', ...template });
  
  const data = {
    description: template.description,
    prompt: content
  };

  if (template.gemini_specific) {
    Object.assign(data, template.gemini_specific);
  }

  const tomlStr = toml.stringify(data);
  
  let filename = `${template.name}.toml`;
  if (template.fileName && template.fileName.gemini) {
    filename = template.fileName.gemini;
  }

  const filePath = path.join(outputDir, filename);
  await fs.ensureDir(path.dirname(filePath));
  await fs.writeFile(filePath, tomlStr);
  return filename;
}

module.exports = generateGemini;
