#!/usr/bin/env bash

# Cores para o terminal parecer profissional
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # Sem cor

echo -e "${BLUE}🎬 Iniciando a instalação do Haruna Firefox Opener...${NC}"

# 1. Criar os diretórios necessários caso não existam
echo "📁 Criando pastas de configuração..."
mkdir -p "$HOME/.mozilla/native-messaging-hosts"
mkdir -p "$HOME/.local/bin"

# 2. Baixar o script Python do seu GitHub
echo "📥 Baixando o script Python..."
curl -sSL "https://raw.githubusercontent.com/Lu15-F3/haruna-firefox-opener/main/haruna_wrapper.py" -o "$HOME/.local/bin/haruna_wrapper.py"
chmod +x "$HOME/.local/bin/haruna_wrapper.py"

# 3. Baixar o arquivo JSON do manifesto nativo
echo "📥 Baixando o manifesto de comunicação nativa..."
curl -sSL "https://raw.githubusercontent.com/Lu15-F3/haruna-firefox-opener/main/org.custom.haruna.json" -o "$HOME/.mozilla/native-messaging-hosts/org.custom.haruna.json"

# 4. Ajustar dinamicamente o caminho da Home do usuário dentro do JSON
echo "⚙️ Configurando caminhos do sistema..."
# Substitui o caminho genérico ou do criador pelo caminho real do usuário atual
sed -i "s|\"path\": \".*\"|\"path\": \"$HOME/.local/bin/haruna_wrapper.py\"|" "$HOME/.mozilla/native-messaging-hosts/org.custom.haruna.json"

echo -e "${GREEN}✅ Instalação local concluída com sucesso!${NC}"
echo -e "🦊 Agora, certifique-se de instalar a extensão no seu Firefox."
