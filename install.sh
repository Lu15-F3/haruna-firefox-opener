#!/usr/bin/env bash

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}🎬 Iniciando a instalação inteligente do Haruna Firefox Opener...${NC}"

# 1. Criar pasta para o script Python
mkdir -p "$HOME/.local/bin"

# 2. Detectar onde o arquivo JSON deve ser instalado (Flatpak vs Nativo)
# Verifica se a pasta do Flatpak do Firefox existe
if [ -d "$HOME/.var/app/org.mozilla.firefox" ]; then
    TARGET_DIR="$HOME/.var/app/org.mozilla.firefox/.mozilla/native-messaging-hosts"
    echo -e "${YELLOW}📦 Firefox em Flatpak detectado!${NC}"
else
    TARGET_DIR="$HOME/.mozilla/native-messaging-hosts"
    echo -e "🦊 Firefox Nativo (RPM/DEB) detectado."
fi

mkdir -p "$TARGET_DIR"

# 3. Baixar os arquivos do GitHub do criador
echo "📥 Baixando arquivos necessários..."
curl -sSL "https://raw.githubusercontent.com/Lu15-F3/haruna-firefox-opener/main/haruna_wrapper.py" -o "$HOME/.local/bin/haruna_wrapper.py"
chmod +x "$HOME/.local/bin/haruna_wrapper.py"

curl -sSL "https://raw.githubusercontent.com/Lu15-F3/haruna-firefox-opener/main/org.custom.haruna.json" -o "$TARGET_DIR/org.custom.haruna.json"

# 4. Ajustar caminhos dinamicamente no JSON instalado
echo "⚙️ Configurando caminhos do sistema..."
sed -i "s|\"path\": \".*\"|\"path\": \"$HOME/.local/bin/haruna_wrapper.py\"|" "$TARGET_DIR/org.custom.haruna.json"

echo -e "${GREEN}✅ Configuração do sistema concluída com sucesso!${NC}"