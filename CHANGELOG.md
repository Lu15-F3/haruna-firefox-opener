# Changelog

Todo o histórico de alterações notáveis deste projeto será documentado neste arquivo.

O formato é baseado em [Keep a Changelog](https://keepachangelog.com/pt-BR/1.0.0/)
e este projeto adere ao [Versionamento Semântico](https://semver.org/lang/pt-BR/).

---

## [1.5.0] - 2026-06-19

### Adicionado

- **Controle de Resolução Máxima: Integração de um seletor de qualidade de vídeo (480p, 720p, 1080p, 4K ou Máxima) na interface de preferências, injetando o parâmetro correspondente via linha de comando no player.

- **Comportamento Dinâmico de Abas: Implementação de uma seção de controle na página de opções para gerenciar a aba do navegador após o envio do vídeo, incluindo a nova funcionalidade de pausar automaticamente o vídeo original no YouTube para evitar a duplicidade de áudio.

### Alterado

- Migração do Payload de Comunicação: Refatoração da API nativeMessaging no background.js para enviar um objeto JSON estruturado contendo metadados de configuração, em substituição ao envio de strings de URL puras.

- Modernização do Script Nativo (haruna_wrapper.py): Atualização completa do script Python para interpretar payloads complexos e executar o Haruna de forma assíncrona utilizando o argumento otimizado --ytdlfs.

- Interface de Preferências Polida: Ajuste e limpeza visual do arquivo options.html e options.js para remover campos obsoletos, melhorar o layout em temas escuros e exibir uma confirmação visual imediata ao salvar configurações.

---

## [1.4.0] - 2026-06-17

### Adicionado
- **Internacionalização Completa (i18n):** Estruturação do projeto para suportar múltiplos idiomas usando a API nativa `browser.i18n` do Firefox.
- **Suporte a 7 Idiomas:** Adicionadas traduções completas para:
  - Inglês (`en`) — Definido como o idioma padrão de segurança (*default_locale*).
  - Português Brasileiro (`pt_BR`).
  - Espanhol (`es`).
  - Alemão (`de`).
  - Francês (`fr`).
  - Chinês Simplificado (`zh_CN`).
  - Japonês (`ja`).
- **Página de Opções Dinâmica:** Atualização dos arquivos `options.html` e `options.js` para injetar os textos traduzidos em tempo de execução com base no idioma do navegador do usuário.

### Alterado
- Refatoração do `background.js` para exibir menus de contexto e notificações dinâmicas utilizando as chaves localizadas do arquivo `messages.json`.

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

[1.5.0]: https://github.com/Lu15-F3/haruna-firefox-opener/compare/v1.4.0...v1.5.0
[1.4.0]: https://github.com/Lu15-F3/haruna-firefox-opener/compare/v1.3.1...v1.4.0
[1.3.0]: https://github.com/Lu15-F3/haruna-firefox-opener/compare/v1.2.0...v1.3.0
[1.2.0]: https://github.com/Lu15-F3/haruna-firefox-opener/compare/v1.1.0...v1.2.0
[1.1.0]: https://github.com/Lu15-F3/haruna-firefox-opener/releases/tag/v1.1.0
