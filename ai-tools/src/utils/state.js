const fs = require('fs-extra');
const path = require('path');
const { paths } = require('../config');

async function loadState(customPath = null) {
  const targetPath = customPath || paths.stateFile;
  try {
    if (await fs.pathExists(targetPath)) {
      return await fs.readJson(targetPath);
    }
  } catch (err) {
    console.error('Error reading state file:', err);
  }
  return { managed: { claude: [], gemini: [] }, lastUpdated: null };
}

async function saveState(state, customPath = null) {
  const targetPath = customPath || paths.stateFile;
  try {
    state.lastUpdated = new Date().toISOString();
    await fs.ensureDir(path.dirname(targetPath));
    await fs.writeJson(targetPath, state, { spaces: 2 });
  } catch (err) {
    console.error('Error saving state file:', err);
  }
}

module.exports = {
  loadState,
  saveState
};