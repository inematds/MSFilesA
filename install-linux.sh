#!/bin/bash

echo "============================================"
echo "  MSFilesA - Instalacao para Linux"
echo "============================================"
echo ""

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# Verificar se Node.js esta instalado
if ! command -v node &> /dev/null; then
    echo -e "${RED}[ERRO] Node.js nao encontrado!${NC}"
    echo "Instale com: sudo apt install nodejs npm"
    echo "Ou via nvm: https://github.com/nvm-sh/nvm"
    exit 1
fi

# Verificar se Python esta instalado
if ! command -v python3 &> /dev/null; then
    echo -e "${RED}[ERRO] Python3 nao encontrado!${NC}"
    echo "Instale com: sudo apt install python3 python3-pip"
    exit 1
fi

echo -e "${GREEN}[OK]${NC} Node.js encontrado: $(node --version)"
echo -e "${GREEN}[OK]${NC} Python encontrado: $(python3 --version)"

echo ""
echo "Instalando dependencias Node.js..."
npm install

echo ""
echo "Instalando dependencias Python..."
pip3 install python-docx reportlab openpyxl python-pptx PyPDF2

echo ""
echo "============================================"
echo -e "${GREEN}  Instalacao concluida com sucesso!${NC}"
echo "============================================"
echo ""
echo "Para usar com Claude Code, execute:"
echo "  claude"
echo ""
