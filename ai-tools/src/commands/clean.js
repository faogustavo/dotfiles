const fs = require('fs-extra');
const path = require('path');
const chalk = require('chalk');
const readline = require('readline');
const { paths } = require('../config');
const { loadState, saveState } = require('../utils/state');

function registerCleanCommand(program) {
  program
    .command('clean')
    .description('Remove all generated configuration files and reset state')
    .option('-l, --local', 'Clean configurations in the current directory (project-specific)', false)
    .action(async (options) => {
      try {
        const statePath = options.local
          ? path.join(process.cwd(), '.ai-tools-state.json')
          : null;

        const state = await loadState(statePath);
        const claudeDir = options.local ? paths.claude.local : paths.claude.global;
        const geminiDir = options.local ? paths.gemini.local : paths.gemini.global;

        const claudeFiles = (state.managed.claude || []).map(f => path.join(claudeDir, f.includes('.') ? f : `${f}.md`));
        const geminiFiles = (state.managed.gemini || []).map(f => path.join(geminiDir, f.includes('.') ? f : `${f}.toml`));
        const allFiles = [...claudeFiles, ...geminiFiles];

        if (allFiles.length === 0) {
          console.log(chalk.yellow('No managed files found to clean.'));
          return;
        }

        console.log(chalk.yellow('The following files will be deleted:'));
        allFiles.forEach(f => console.log(chalk.gray(` - ${f}`)));

        const rl = readline.createInterface({
          input: process.stdin,
          output: process.stdout
        });

        rl.question(chalk.red('\nAre you sure you want to delete these files and reset the state? (y/N) '),
        async (answer) => {
          rl.close();
          if (answer.toLowerCase() !== 'y') {
            console.log(chalk.blue('Operation cancelled.'));
            return;
          }

          for (const file of allFiles) {
            if (await fs.pathExists(file)) {
              await fs.remove(file);
              console.log(chalk.green(`Removed: ${file}`));
            } else {
              console.log(chalk.gray(`Skipped (not found): ${file}`));
            }
          }

          state.managed = { claude: [], gemini: [] };
          await saveState(state, statePath);
          console.log(chalk.blue('State reset successfully.'));
        });

      } catch (err) {
        console.error(chalk.red('Fatal Error:'), err);
        process.exit(1);
      }
    });
}

module.exports = registerCleanCommand;
