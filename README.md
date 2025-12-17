# MSFilesA

Projeto de skills do Claude Code para criacao de documentos (Word, Excel, PowerPoint e PDF).

## Requisitos

- **Node.js** (v18+) - https://nodejs.org/
- **Python** (3.8+) - https://python.org/
- **Claude Code** - https://claude.com/claude-code

## Instalacao

### Windows

```cmd
install-windows.bat
```

### Linux/macOS

```bash
chmod +x install-linux.sh
./install-linux.sh
```

## Como Usar

1. Abra o terminal na pasta do projeto
2. Execute `claude` para iniciar o Claude Code
3. Solicite a criacao de documentos:

**Exemplos de comandos:**

```
Crie um documento Word com um relatorio de vendas
Crie uma planilha Excel com dados financeiros
Crie uma apresentacao PowerPoint sobre o projeto
Crie um PDF com o contrato
```

## Estrutura do Projeto

```
MSFilesA/
├── .claude/
│   └── skills/          # Skills do Claude (docx, xlsx, pptx, pdf)
├── assets/              # Imagens e recursos
├── out/                 # Arquivos gerados
├── scripts/             # Scripts de geracao
│   ├── generate.docx.py
│   ├── generate.xlsx.js
│   ├── generate.pptx.js
│   └── generate.pdf.py
├── install-windows.bat  # Instalador Windows
├── install-linux.sh     # Instalador Linux
└── package.json
```

## Skills Disponiveis

| Skill | Descricao |
|-------|-----------|
| docx  | Criar/editar documentos Word |
| xlsx  | Criar/editar planilhas Excel |
| pptx  | Criar/editar apresentacoes PowerPoint |
| pdf   | Criar/manipular arquivos PDF |

## Suporte

Para reportar problemas: https://github.com/inematds/MSFilesA/issues
