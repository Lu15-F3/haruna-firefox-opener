// Cria o item no menu de contexto quando a extensão é instalada
browser.runtime.onInstalled.addListener(() => {
  browser.contextMenus.create({
    id: "open-in-haruna",
    title: "Abrir no Haruna",
    contexts: ["link", "video", "page"]
  });
});

// Escuta os cliques no menu de contexto
browser.contextMenus.onClicked.addListener((info, tab) => {
  if (info.menuItemId === "open-in-haruna") {
    // Tenta pegar a URL do link, se não, pega a URL da página atual
    let url = info.linkUrl || info.srcUrl || info.pageUrl;
    
    if (url) {
      console.log("Enviando URL para o script nativo:", url);
      // Envia uma mensagem para o script nativo em Python
      browser.runtime.sendNativeMessage(
        "org.custom.haruna", 
        { url: url }
      ).then(
        response => console.log("Resposta do script nativo:", response),
        error => console.error("Erro ao comunicar com o script nativo:", error)
      );
    }
  }
});
