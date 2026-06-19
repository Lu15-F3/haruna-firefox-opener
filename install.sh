#!/usr/bin/env bash

# CONFIGURAÇÃO: Altere aqui para o SEU usuário e repositório do GitHub
GITHUB_USER="Lu15-F3"
REPO_NAME="haruna-firefox-opener"
BRANCH="main" # altere se a sua branch principal for 'master'

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}🎬 Iniciando a instalação inteligente do Haruna Firefox Opener...${NC}"

# 1. Criar pasta para o script Python
mkdir -p "$HOME/.local/bin"

# 2. Detectar onde o arquivo JSON deve ser instalado (Flatpak vs Nativo)
if [ -d "$HOME/.var/app/org.mozilla.firefox" ]; then
    TARGET_DIR="$HOME/.var/app/org.mozilla.firefox/.mozilla/native-messaging-hosts"
    echo -e "${YELLOW}📦 Firefox em Flatpak detectado!${NC}"
else
    TARGET_DIR="$HOME/.mozilla/native-messaging-hosts"
    echo -e "🦊 Firefox Nativo (RPM/DEB) detectado."
fi

# Garante que a pasta de destino do JSON existe
mkdir -p "$TARGET_DIR"

# URL Base para os seus arquivos no GitHub
BASE_URL="https://raw.githubusercontent.com/$GITHUB_USER/$REPO_NAME/$BRANCH"

# 3. Baixar os arquivos do SEU GitHub
echo "📥 Baixando arquivos necessários..."

# Baixa o script Python
if curl -sSL "$BASE_URL/haruna_wrapper.py" -o "$HOME/.local/bin/haruna_wrapper.py"; then
    chmod +x "$HOME/.local/bin/haruna_wrapper.py"
    echo -e "${GREEN}• haruna_wrapper.py baixado com sucesso.${NC}"
else
    echo -e "${RED}❌ Erro ao baixar haruna_wrapper.py. Verifique o nome do repositório/usuário.${NC}"
    exit 1
fi

# Baixa o JSON de manifesto
if curl -sSL "$BASE_URL/org.custom.haruna.json" -o "$TARGET_DIR/org.custom.haruna.json"; then
    echo -e "${GREEN}• org.custom.haruna.json baixado com sucesso em: $TARGET_DIR${NC}"
else
    echo -e "${RED}❌ Erro ao baixar org.custom.haruna.json.${NC}"
    exit 1
fi

# 4. Ajustar caminhos dinamicamente no JSON instalado
echo "⚙️ Configurando caminhos do sistema..."

# Substituição robusta usando o próprio comando sed com delimitadores alternativos (|)
# Note que expandimos o $HOME dentro do JSON para o caminho absoluto real
sed -i "s|\"path\": *\"[^\"]*\"|\"path\": \"$HOME/.local/bin/haruna_wrapper.py\"|" "$TARGET_DIR/org.custom.haruna.json"

echo -e "${GREEN}✅ Configuração do sistema concluída com sucesso!${NC}"
