const { Command } = require('commander');
const registerCleanCommand = require('./commands/clean');
const registerMigrateCommand = require('./commands/migrate');

const program = new Command();

program
  .name('ai-tools')
  .description('Generate AI assistant configurations from master templates');

// Register Commands
registerCleanCommand(program);
registerMigrateCommand(program);

// Show help if no subcommand is provided
if (!process.argv.slice(2).length) {
  program.outputHelp();
}

program.parse();