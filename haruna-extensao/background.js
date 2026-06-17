// Inicializar os menus de contexto usando traduções
browser.runtime.onInstalled.addListener(() => {
  browser.contextMenus.create({
    id: "abrir-video-haruna",
    title: browser.i18n.getMessage("menuOpenVideo"), // <-- Dinâmico
    contexts: ["link", "page", "video"]
  });

  browser.contextMenus.create({
    id: "abrir-playlist-haruna",
    title: browser.i18n.getMessage("menuOpenPlaylist"), // <-- Dinâmico
    contexts: ["link", "page"],
    targetUrlPatterns: ["*://*.youtube.com/*list=PL*", "*://youtube.com/*list=PL*"]
  });
});

function enviarNotificacao(titulo, mensagem) {
  browser.notifications.create({
    type: "basic",
    iconUrl: browser.runtime.getURL("icone-48.png"),
    title: titulo,
    message: mensagem || ""
  });
}

browser.contextMenus.onClicked.addListener(async (info, tab) => {
  let videoUrl = info.linkUrl || info.pageUrl;
  if (!videoUrl) return;

  const configuracoes = await browser.storage.local.get({
    harunaFullscreen: false,
    harunaCloseTab: false
  });

  if (info.menuItemId === "abrir-video-haruna") {
    if (videoUrl.includes("youtube.com") && videoUrl.includes("list=RD")) {
      try {
        const urlObj = new URL(videoUrl);
        urlObj.searchParams.delete("list");
        urlObj.searchParams.delete("index");
        videoUrl = urlObj.toString();
      } catch (e) {
        console.error("Error parsing Mix URL:", e);
      }
    }
    else if (videoUrl.includes("youtube.com") && videoUrl.includes("list=PL")) {
      try {
        const urlObj = new URL(videoUrl);
        urlObj.searchParams.delete("list");
        urlObj.searchParams.delete("index");
        videoUrl = urlObj.toString();
      } catch (e) {
        console.error("Error parsing Playlist URL:", e);
      }
    }
  }

  // Notificações usando o sistema internacionalizado
  enviarNotificacao(
    browser.i18n.getMessage("notifTitle"), 
    browser.i18n.getMessage("notifSending")
  );

  browser.runtime.sendNativeMessage("org.custom.haruna", { url: videoUrl })
    .then(() => {
      if (configuracoes.harunaCloseTab && tab && tab.id) {
        browser.tabs.remove(tab.id);
      }
    })
    .catch((error) => {
      console.error("Native Messaging Error:", error);
      // Notificação de erro internacionalizada
      enviarNotificacao(
        browser.i18n.getMessage("notifErrorTitle"), 
        browser.i18n.getMessage("notifErrorDesc")
      );
    });
});