const os = require('os');
const path = require('path');

const HOME = os.homedir();

module.exports = {
  paths: {
    home: HOME,
    configDir: path.join(HOME, '.config', 'ai-tools'),
    stateFile: path.join(HOME, '.config', 'ai-tools', 'state.json'),
    claude: {
      global: path.join(HOME, '.claude', 'commands'),
      local: path.join(process.cwd(), '.claude', 'commands')
    },
    gemini: {
      global: path.join(HOME, '.gemini', 'commands'),
      local: path.join(process.cwd(), '.gemini', 'commands')
    }
  }
};
