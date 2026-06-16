// Salvar opções no storage do Firefox
function salvarOpcoes() {
  const fullscreen = document.getElementById('fullscreen').checked;
  const closeTab = document.getElementById('closeTab').checked;

  browser.storage.local.set({
    harunaFullscreen: fullscreen,
    harunaCloseTab: closeTab
  }).then(() => {
    const status = document.getElementById('status');
    status.style.display = 'block';
    setTimeout(() => { status.style.display = 'none'; }, 1500);
  });
}

// Restaurar as opções salvas ao abrir a página
function restaurarOpcoes() {
  browser.storage.local.get({
    harunaFullscreen: false, // padrão desativado
    harunaCloseTab: false    // padrão desativado
  }).then((itens) => {
    document.getElementById('fullscreen').checked = itens.harunaFullscreen;
    document.getElementById('closeTab').checked = itens.harunaCloseTab;
  });
}

document.addEventListener('DOMContentLoaded', restaurarOpcoes);
document.getElementById('fullscreen').addEventListener('change', salvarOpcoes);
document.getElementById('closeTab').addEventListener('change', salvarOpcoes);