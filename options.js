// Função para traduzir a interface da página de opções
function aplicarTraducoes() {
  document.getElementById('optionsTitle').textContent = browser.i18n.getMessage("optionsTitle");
  document.getElementById('optFullscreen').textContent = browser.i18n.getMessage("optFullscreen");
  document.getElementById('optCloseTab').textContent = browser.i18n.getMessage("optCloseTab");
}

function salvarOpcoes() {
  const fullscreen = document.getElementById('fullscreen').checked;
  const closeTab = document.getElementById('closeTab').checked;

  browser.storage.local.set({
    harunaFullscreen: fullscreen,
    harunaCloseTab: closeTab
  }).then(() => {
    const status = document.getElementById('status');
    status.textContent = browser.i18n.getMessage("statusSaved"); // Status traduzido
    status.style.display = 'block';
    setTimeout(() => { status.style.display = 'none'; }, 1500);
  });
}

function restaurarOpcoes() {
  aplicarTraducoes(); // Carrega as traduções na tela
  
  browser.storage.local.get({
    harunaFullscreen: false,
    harunaCloseTab: false
  }).then((itens) => {
    document.getElementById('fullscreen').checked = itens.harunaFullscreen;
    document.getElementById('closeTab').checked = itens.harunaCloseTab;
  });
}

document.addEventListener('DOMContentLoaded', restaurarOpcoes);
document.getElementById('fullscreen').addEventListener('change', salvarOpcoes);
document.getElementById('closeTab').addEventListener('change', salvarOpcoes);