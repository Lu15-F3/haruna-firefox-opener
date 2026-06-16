# Changelog

Todo o histórico de alterações notáveis deste projeto será documentado neste arquivo.

O formato é baseado em [Keep a Changelog](https://keepachangelog.com/pt-BR/1.0.0/)
e este projeto adere ao [Versionamento Semântico](https://semver.org/lang/pt-BR/).

---

## [1.3.0] - 2026-06-16

### Adicionado
- **Página de Opções (Preferences):** Nova interface escura integrada ao Firefox (`options.html` / `options.js`) que permite ao usuário personalizar o comportamento da extensão.
- **Opção de Fechamento Automático:** Adicionada preferência para fechar a aba ativa do navegador automaticamente após enviar o vídeo com sucesso para o player.
- **Suporte Nativo a Playlists:** Nova opção dedicada no menu de contexto ("Abrir Playlist Completa no Haruna") que aparece de forma inteligente apenas para playlists reais do YouTube (`list=PL...`).
- **Instalador Inteligente:** O script `install.sh` agora detecta automaticamente se o Firefox está instalado de forma nativa ou via **Flatpak**, configurando os caminhos de comunicação (`native-messaging-hosts`) no diretório correto sem intervenção do usuário.
- Permissão `"storage"` no `manifest.json` para salvar as preferências do usuário localmente.

### Alterado
- Tratamento de URLs aprimorado no `background.js` para diferenciar cliques em vídeos comuns de cliques em playlists completas.

---

## [1.2.0] - 2026-06-15

### Adicionado
- **Notificações Nativas do Sistema:** Feedback visual imediato na tela do usuário usando a API `browser.notifications.create` do Firefox para avisar quando o vídeo está sendo enviado ou se houve algum erro de comunicação local.
- Permissão `"notifications"` adicionada ao `manifest.json`.

### Corrigido
- **Filtro de Mixes do YouTube:** Adicionado um tratamento inteligente na URL que remove os parâmetros `list=RD` e `index`. Isso evita que o Haruna tente carregar as playlists automáticas (rádios) geradas pelo algoritmo do YouTube, as quais são bloqueadas para players externos e causavam travamentos e erros de reprodução.
- Correção de erro de sintaxe JavaScript (`ReferenceError: mensaje is not defined`) na exibição de mensagens.

---

## [1.1.0] - 2026-06-14

### Adicionado
- Publicação oficial e homologação da extensão na loja de Add-ons da Mozilla (**AMO**).
- Correção estrita do `manifest.json` removendo coletas de dados desnecessárias (`"data_collection_permissions": {"required": ["none"]}`) atendendo aos critérios de segurança da Mozilla.
- Implementação inicial estável do menu de contexto enviado via Native Messaging para o script Python local (`haruna_wrapper.py`).

---

[1.3.0]: https://github.com/Lu15-F3/haruna-firefox-opener/compare/v1.2.0...v1.3.0
[1.2.0]: https://github.com/Lu15-F3/haruna-firefox-opener/compare/v1.1.0...v1.2.0
[1.1.0]: https://github.com/Lu15-F3/haruna-firefox-opener/releases/tag/v1.1.0
