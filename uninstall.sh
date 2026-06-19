#!/usr/bin/env bash

# Cores para o terminal
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}🗑️ Iniciando a desinstalação do Haruna Firefox Opener...${NC}"

# 1. Caminhos dos arquivos instalados
PYTHON_SCRIPT="$HOME/.local/bin/haruna_wrapper.py"
DIR_NATV="$HOME/.mozilla/native-messaging-hosts"
DIR_FLAT="$HOME/.var/app/org.mozilla.firefox/.mozilla/native-messaging-hosts"
FILE_JSON="org.custom.haruna.json"

echo "🧹 Removendo arquivos do sistema..."

# ==========================================
# 2. Remover o script Python
# ==========================================
if [ -f "$PYTHON_SCRIPT" ]; then
    rm -f "$PYTHON_SCRIPT"
    echo -e "${GREEN}• Script Python removido com sucesso.${NC}"
else
    echo "• Script Python não encontrado (já removido)."
fi

# ==========================================
# 3. Remover o JSON do diretório Nativo
# ==========================================
if [ -f "$DIR_NATV/$FILE_JSON" ]; then
    rm -f "$DIR_NATV/$FILE_JSON"
    echo -e "${GREEN}• Manifesto JSON removido do diretório nativo.${NC}"
    
    # Se a pasta native-messaging-hosts estiver vazia após remover o JSON, apaga a pasta também
    if [ -d "$DIR_NATV" ] && [ -z "$(ls -A "$DIR_NATV")" ]; then
        rmdir "$DIR_NATV"
        echo "• Pasta native-messaging-hosts vazia limpa do diretório nativo."
    fi
else
    echo "• Manifesto JSON não encontrado no diretório nativo."
fi

# ==========================================
# 4. Remover o JSON do diretório Flatpak
# ==========================================
if [ -f "$DIR_FLAT/$FILE_JSON" ]; then
    rm -f "$DIR_FLAT/$FILE_JSON"
    echo -e "${GREEN}• Manifesto JSON removido do diretório Flatpak.${NC}"
    
    # Se a pasta do Flatpak estiver vazia após remover o JSON, apaga a pasta também
    if [ -d "$DIR_FLAT" ] && [ -z "$(ls -A "$DIR_FLAT")" ]; then
        rmdir "$DIR_FLAT"
        echo "• Pasta native-messaging-hosts vazia limpa do diretório Flatpak."
    fi
else
    echo "• Manifesto JSON não encontrado no diretório Flatpak."
fi

echo -e "${GREEN}✅ Desinstalação concluída com sucesso!${NC}"
