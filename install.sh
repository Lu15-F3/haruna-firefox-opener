#!/usr/bin/env bash

# CONFIGURAÇÃO: Mantido com os seus dados do GitHub
GITHUB_USER="Lu15-F3"
REPO_NAME="haruna-firefox-opener"
BRANCH="main"

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}🎬 Iniciando a instalação inteligente do Haruna Firefox Opener...${NC}"

# 1. Criar pasta para o script Python
mkdir -p "$HOME/.local/bin"

# 2. Configurar diretórios de destino (Abordagem Híbrida)
# Diretório padrão (Nativo e compatível com Flatpak no Fedora)
TARGET_DIR="$HOME/.mozilla/native-messaging-hosts"
mkdir -p "$TARGET_DIR"

# Diretório secundário isolado (Para outras distribuições com Flatpak estrito)
FLATPAK_DIR="$HOME/.var/app/org.mozilla.firefox/.mozilla/native-messaging-hosts"
HAS_FLATPAK=false

if [ -d "$HOME/.var/app/org.mozilla.firefox" ]; then
    mkdir -p "$FLATPAK_DIR"
    HAS_FLATPAK=true
    echo -e "${YELLOW}📦 Firefox em Flatpak detectado! O manifesto será espelhado para máxima compatibilidade.${NC}"
else
    echo -e "🦊 Firefox Nativo (RPM/DEB) detectado."
fi

# URL Base para os seus arquivos no GitHub
BASE_URL="https://raw.githubusercontent.com/$GITHUB_USER/$REPO_NAME/$BRANCH"

# 3. Baixar os arquivos do seu GitHub
echo "📥 Baixando arquivos necessários..."

# Baixa o script Python
if curl -sSL "$BASE_URL/haruna_wrapper.py" -o "$HOME/.local/bin/haruna_wrapper.py"; then
    chmod +x "$HOME/.local/bin/haruna_wrapper.py"
    echo -e "${GREEN}• haruna_wrapper.py baixado com sucesso.${NC}"
else
    echo -e "${RED}❌ Erro ao baixar haruna_wrapper.py. Verifique o nome do repositório/usuário.${NC}"
    exit 1
fi

# Baixa o JSON de manifesto no diretório padrão
if curl -sSL "$BASE_URL/org.custom.haruna.json" -o "$TARGET_DIR/org.custom.haruna.json"; then
    echo -e "${GREEN}• org.custom.haruna.json baixado no diretório padrão.${NC}"
else
    echo -e "${RED}❌ Erro ao baixar org.custom.haruna.json.${NC}"
    exit 1
fi

# Se o Flatpak foi detectado, espelha o arquivo baixado para a pasta isolada
if [ "$HAS_FLATPAK" = true ]; then
    cp "$TARGET_DIR/org.custom.haruna.json" "$FLATPAK_DIR/org.custom.haruna.json"
    echo -e "${GREEN}• org.custom.haruna.json espelhado na pasta Flatpak.${NC}"
fi

# 4. Ajustar caminhos dinamicamente nos arquivos JSON instalados
echo "⚙️ Configurando caminhos do sistema..."

# Ajusta o JSON do diretório padrão
sed -i "s|\"path\": *\"[^\"]*\"|\"path\": \"$HOME/.local/bin/haruna_wrapper.py\"|" "$TARGET_DIR/org.custom.haruna.json"

# Ajusta o JSON do diretório Flatpak (se existir)
if [ "$HAS_FLATPAK" = true ]; then
    sed -i "s|\"path\": *\"[^\"]*\"|\"path\": \"$HOME/.local/bin/haruna_wrapper.py\"|" "$FLATPAK_DIR/org.custom.haruna.json"
fi

echo -e "${GREEN}✅ Configuração do sistema concluída com sucesso!${NC}"
