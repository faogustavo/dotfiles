const fs = require('fs-extra');
const path = require('path');
const yaml = require('js-yaml');
const chalk = require('chalk');
const { paths } = require('../config');
const { loadState, saveState } = require('../utils/state');
const generateClaude = require('../generators/claude');
const generateGemini = require('../generators/gemini');

function registerMigrateCommand(program) {
  program
    .command('migrate')
    .description('Generate configurations in the current directory (project-specific)')
    .option('-l, --local', 'Generate configurations in the current directory (project-specific)', false)
    .option('-p, --platform <platforms>', 'Specify platforms to run (e.g., "claude,gemini")', 'claude,gemini')
    .action(async (options) => {
      try {
        console.log(chalk.blue('Starting AI Tools Configuration Generator...'));

        const statePath = options.local 
          ? path.join(process.cwd(), '.ai-tools-state.json') 
          : null;

        const platformsToRun = options.platform.split(',').map(p => p.trim());
        const runClaude = platformsToRun.includes('claude');
        const runGemini = platformsToRun.includes('gemini');

        const state = await loadState(statePath);
        // Adjusted path: src/commands -> src -> root -> templates
        const templatesDir = path.join(__dirname, '../../templates');
        
        if (!await fs.pathExists(templatesDir)) {
          console.error(chalk.red(`Templates directory not found at ${templatesDir}`));
          process.exit(1);
        }

        const files = await fs.readdir(templatesDir);
        const templateFiles = files.filter(f => f.endsWith('.yaml') || f.endsWith('.yml'));

        const claudeDir = options.local ? paths.claude.local : paths.claude.global;
        const geminiDir = options.local ? paths.gemini.local : paths.gemini.global;

        console.log(chalk.gray(`Targets:\n  Claude: ${claudeDir}\n  Gemini: ${geminiDir}`));

        const newManaged = {
          claude: [],
          gemini: []
        };

        // Generate Loop
        for (const file of templateFiles) {
          const templatePath = path.join(templatesDir, file);
          const raw = await fs.readFile(templatePath, 'utf8');
          const template = yaml.load(raw);

          if (!template.name) {
            console.warn(chalk.yellow(`Skipping ${file}: Missing 'name' property.`));
            continue;
          }

          // Generate Claude
          if (runClaude) {
            try {
              const name = await generateClaude(template, claudeDir);
              newManaged.claude.push(name);
              console.log(chalk.green(`✓ [Claude] Generated ${name}`));
            } catch (err) {
              console.error(chalk.red(`x [Claude] Failed ${template.name}:`), err.message);
            }
          }

          // Generate Gemini
          if (runGemini) {
            try {
              const name = await generateGemini(template, geminiDir);
              newManaged.gemini.push(name);
              console.log(chalk.green(`✓ [Gemini] Generated ${name}`));
            } catch (err) {
              console.error(chalk.red(`x [Gemini] Failed ${template.name}:`), err.message);
            }
          }
        }

        // Cleanup (Delete files we managed before but didn't generate this time)
        const cleanup = async (platform, oldList, newList, dir, ext) => {
          if (!oldList) return;
          const toDelete = oldList.filter(name => !newList.includes(name));
          for (const name of toDelete) {
            // Determine if name is legacy (no extension) or new (with extension/path)
            // We assume if it has a dot, it's a full filename.
            const isLegacy = !name.includes('.');
            const relativePath = isLegacy ? `${name}.${ext}` : name;
            
            // Safety check: if the resolved relative path is actually in the new list,
            // it means we migrated from legacy format to new format for the same file.
            // Don't delete it.
            if (newList.includes(relativePath)) {
              continue;
            }

            const filePath = path.join(dir, relativePath);
            if (await fs.pathExists(filePath)) {
              await fs.remove(filePath);
              console.log(chalk.yellow(`- [${platform}] Removed obsolete command: ${relativePath}`));
            }
          }
        };

        if (runClaude) {
          await cleanup('Claude', state.managed.claude, newManaged.claude, claudeDir, 'md');
        }
        if (runGemini) {
          await cleanup('Gemini', state.managed.gemini, newManaged.gemini, geminiDir, 'toml');
        }

        // Save new state
        state.managed = newManaged;
        await saveState(state, statePath);
        
        console.log(chalk.blue('Done.'));

      } catch (err) {
        console.error(chalk.red('Fatal Error:'), err);
        process.exit(1);
      }
    });
}

module.exports = registerMigrateCommand;
