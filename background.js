// Criar o menu de contexto ao instalar a extensão
browser.runtime.onInstalled.addListener(() => {
  browser.contextMenus.create({
    id: "abrir-no-haruna",
    title: "Abrir no Haruna",
    contexts: ["link", "page", "video"]
  });
});

// Função para exibir a notificação nativa
function enviarNotificacao(titulo, mensagem) {
  browser.notifications.create({
    type: "basic",
    iconUrl: browser.runtime.getURL("icone-48.png"),
    title: titulo,
    message: mensagem || ""
  });
}

// Escutar o clique no menu de contexto
browser.contextMenus.onClicked.addListener((info, tab) => {
  if (info.menuItemId === "abrir-no-haruna") {
    let videoUrl = info.linkUrl || info.pageUrl;

    if (videoUrl) {
      // 🛠️ FILTRO INTELIGENTE: Se for um Mix do YouTube (list=RD...), removemos a playlist para não quebrar o Haruna
      if (videoUrl.includes("youtube.com") && videoUrl.includes("list=RD")) {
        try {
          const urlObj = new URL(videoUrl);
          urlObj.searchParams.delete("list"); // Remove o parâmetro da playlist problemática
          urlObj.searchParams.delete("index"); // Remove o índice da playlist se houver
          videoUrl = urlObj.toString();
        } catch (e) {
          console.error("Erro ao tratar URL do YouTube:", e);
        }
      }

      // Dispara a notificação de início imediatamente
      enviarNotificacao("Haruna Player", "Enviando vídeo para o player...");

      // Envia a URL filtrada para o script Python local
      browser.runtime.sendNativeMessage("org.custom.haruna", { url: videoUrl })
        .then((response) => {
          console.log("Resposta do script nativo:", response);
        })
        .catch((error) => {
          console.error("Erro ao comunicar com o script nativo:", error);
          enviarNotificacao("Erro no Haruna", "Não foi possível abrir o player. Verifique o script local.");
        });
    }
  }
});