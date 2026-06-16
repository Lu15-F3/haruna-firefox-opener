// Inicializar os menus de contexto
browser.runtime.onInstalled.addListener(() => {
  // Menu padrão para vídeos/páginas
  browser.contextMenus.create({
    id: "abrir-video-haruna",
    title: "Abrir Vídeo no Haruna",
    contexts: ["link", "page", "video"]
  });

  // Menu extra exclusivo para playlists reais do YouTube (PL...)
  browser.contextMenus.create({
    id: "abrir-playlist-haruna",
    title: "Abrir Playlist Completa no Haruna",
    contexts: ["link", "page"],
    targetUrlPatterns: ["*://*.youtube.com/*list=PL*", "*://youtube.com/*list=PL*"]
  });
});

// Função universal para notificações
function enviarNotificacao(titulo, mensagem) {
  browser.notifications.create({
    type: "basic",
    iconUrl: browser.runtime.getURL("icone-48.png"),
    title: titulo,
    message: mensagem || ""
  });
}

// Trata o clique nos menus
browser.contextMenus.onClicked.addListener(async (info, tab) => {
  let videoUrl = info.linkUrl || info.pageUrl;
  if (!videoUrl) return;

  // Carrega as preferências salvas pelo usuário na página de opções
  const configuracoes = await browser.storage.local.get({
    harunaFullscreen: false,
    harunaCloseTab: false
  });

  // SE O USUÁRIO CLICOU EM "ABRIR VÍDEO" (Filtra os Mixes automáticos list=RD)
  if (info.menuItemId === "abrir-video-haruna") {
    if (videoUrl.includes("youtube.com") && videoUrl.includes("list=RD")) {
      try {
        const urlObj = new URL(videoUrl);
        urlObj.searchParams.delete("list");
        urlObj.searchParams.delete("index");
        videoUrl = urlObj.toString();
      } catch (e) {
        console.error("Erro ao limpar URL do Mix:", e);
      }
    }
    // Se clicou em "Abrir Vídeo" mas era uma playlist real, limpa a playlist para tocar só o vídeo atual
    else if (videoUrl.includes("youtube.com") && videoUrl.includes("list=PL")) {
      try {
        const urlObj = new URL(videoUrl);
        urlObj.searchParams.delete("list");
        urlObj.searchParams.delete("index");
        videoUrl = urlObj.toString();
      } catch (e) {
        console.error("Erro ao limpar playlist do vídeo:", e);
      }
    }
  }

  // Envia os dados para o Python local
  enviarNotificacao("Haruna Player", "Enviando para o player...");

  // Prepara o objeto de mensagem. Se a opção de tela cheia estiver ativa, mandamos uma flag extra
  const dadosMensagem = { url: videoUrl };
  if (configuracoes.harunaFullscreen) {
    dadosMensagem.fullscreen = true; // O wrapper Python precisará ler isso se você quiser tratar no player
  }

  browser.runtime.sendNativeMessage("org.custom.haruna", dadosMensagem)
    .then(() => {
      // Se o usuário ativou a opção de fechar a aba, fecha ela agora que deu certo
      if (configuracoes.harunaCloseTab && tab && tab.id) {
        browser.tabs.remove(tab.id);
      }
    })
    .catch((error) => {
      console.error("Erro no Native Messaging:", error);
      enviarNotificacao("Erro no Haruna", "Não foi possível abrir o player. Verifique o script local.");
    });
});