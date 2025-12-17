# Plano: MSFilesA como Aplicacao Dockerizada

## Visao Geral

Transformar o MSFilesA em uma aplicacao web completa com:
- API REST para integracao
- Interface Web simplificada para usuarios
- Painel de Configuracao para APIs e integracoes
- Suporte a multiplos provedores de LLM (Claude, OpenAI, OpenRouter)
- Suporte a multiplos provedores de imagens (NanoBanana, Kie.ai)
- Canais de comunicacao: Email e Telegram
- Deploy via Docker

## Arquitetura Proposta

```
┌─────────────────────────────────────────────────────────────────────┐
│                          Docker Compose                              │
├─────────────────────────────────────────────────────────────────────┤
│                                                                      │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐  ┌────────────┐  │
│  │  Frontend   │  │   Backend   │  │   Workers   │  │  Bot/Email │  │
│  │  (React)    │──│  (FastAPI)  │──│  (Node.js)  │  │  Service   │  │
│  │  Port 3000  │  │  Port 8000  │  │  PPTX/XLSX  │  │            │  │
│  └─────────────┘  └─────────────┘  └─────────────┘  └────────────┘  │
│         │                │                │               │          │
│         │          ┌─────┴─────┐          │               │          │
│         │          │  SQLite   │          │               │          │
│         │          │  Config   │──────────┴───────────────┘          │
│         │          └───────────┘                                     │
│         │                │                                           │
│         └────────────────┼───────────────────────────────────────    │
│                          │                                           │
│                    ┌─────┴─────┐                                     │
│                    │  Storage  │                                     │
│                    │  /output  │                                     │
│                    └───────────┘                                     │
└─────────────────────────────────────────────────────────────────────┘
            │              │              │              │
            ▼              ▼              ▼              ▼
     ┌──────────┐   ┌──────────┐   ┌──────────┐   ┌──────────┐
     │ Claude   │   │ OpenRouter│   │ Kie.ai   │   │ Telegram │
     │ OpenAI   │   │  (LLMs)   │   │NanoBanana│   │  Email   │
     └──────────┘   └──────────┘   └──────────┘   └──────────┘
```

## Estrutura de Pastas (Nova)

```
MSFilesA/
├── app/                      # NOVA PASTA - Aplicacao
│   ├── backend/
│   │   ├── main.py           # FastAPI principal
│   │   ├── database.py       # SQLite para configuracoes
│   │   ├── routers/
│   │   │   ├── documents.py  # Endpoints de documentos
│   │   │   ├── images.py     # Endpoints de imagens
│   │   │   ├── ai.py         # Endpoints de IA
│   │   │   └── config.py     # Endpoints de configuracao
│   │   ├── services/
│   │   │   ├── llm/
│   │   │   │   ├── base.py       # Interface base LLM
│   │   │   │   ├── claude.py     # Claude API
│   │   │   │   ├── openai.py     # OpenAI API
│   │   │   │   └── openrouter.py # OpenRouter (acesso a varios LLMs)
│   │   │   ├── images/
│   │   │   │   ├── base.py       # Interface base imagens
│   │   │   │   ├── nanobanana.py # NanoBanana API
│   │   │   │   └── kieai.py      # Kie.ai API
│   │   │   ├── channels/
│   │   │   │   ├── telegram.py   # Bot Telegram
│   │   │   │   └── email.py      # Servico de Email
│   │   │   └── documents.py  # Geracao de documentos
│   │   ├── requirements.txt
│   │   └── Dockerfile
│   │
│   ├── frontend/
│   │   ├── src/
│   │   │   ├── App.jsx
│   │   │   ├── components/
│   │   │   └── pages/
│   │   │       ├── Home.jsx       # Interface simplificada
│   │   │       ├── Config.jsx     # Painel de configuracao
│   │   │       └── History.jsx    # Historico de documentos
│   │   ├── package.json
│   │   └── Dockerfile
│   │
│   ├── workers/
│   │   ├── pptx-worker.js    # Worker Node.js para PPTX
│   │   ├── xlsx-worker.js    # Worker Node.js para XLSX
│   │   ├── package.json
│   │   └── Dockerfile
│   │
│   ├── data/
│   │   └── config.db         # SQLite com configuracoes
│   │
│   └── docker-compose.yml
│
├── .claude/                  # MANTEM - Skills existentes
├── scripts/                  # MANTEM - Scripts existentes
├── assets/                   # MANTEM
└── out/                      # MANTEM
```

## Painel de Configuracao

### Tela de Configuracoes (Config.jsx)

```
┌─────────────────────────────────────────────────────────┐
│  ⚙️ Configuracoes                                       │
├─────────────────────────────────────────────────────────┤
│                                                         │
│  📝 PROVEDORES DE LLM                                   │
│  ┌─────────────────────────────────────────────────┐   │
│  │ ○ Claude API                                     │   │
│  │   API Key: [sk-ant-•••••••••••] [Testar]        │   │
│  │                                                  │   │
│  │ ○ OpenAI                                         │   │
│  │   API Key: [sk-•••••••••••••••] [Testar]        │   │
│  │                                                  │   │
│  │ ● OpenRouter (Recomendado)                       │   │
│  │   API Key: [or-•••••••••••••••] [Testar]        │   │
│  │   Modelo: [claude-3-sonnet ▼]                   │   │
│  └─────────────────────────────────────────────────┘   │
│                                                         │
│  🖼️ PROVEDORES DE IMAGENS                              │
│  ┌─────────────────────────────────────────────────┐   │
│  │ ○ NanoBanana                                     │   │
│  │   API Key: [nb-•••••••••••••••] [Testar]        │   │
│  │                                                  │   │
│  │ ● Kie.ai                                         │   │
│  │   API Key: [kie-•••••••••••••] [Testar]         │   │
│  └─────────────────────────────────────────────────┘   │
│                                                         │
│  📬 CANAIS DE COMUNICACAO                              │
│  ┌─────────────────────────────────────────────────┐   │
│  │ ☑ Telegram                                       │   │
│  │   Bot Token: [123456:ABC-•••••••] [Testar]      │   │
│  │   Chat ID: [opcional, para notificacoes]        │   │
│  │                                                  │   │
│  │ ☑ Email                                          │   │
│  │   SMTP Host: [smtp.gmail.com]                   │   │
│  │   SMTP Port: [587]                              │   │
│  │   Email: [seu@email.com]                        │   │
│  │   Senha App: [••••••••••••••••]                 │   │
│  └─────────────────────────────────────────────────┘   │
│                                                         │
│           [Salvar Configuracoes]                        │
└─────────────────────────────────────────────────────────┘
```

### Interface Simplificada (Home.jsx)

```
┌─────────────────────────────────────────────────────────┐
│  📄 MSFilesA - Gerador de Documentos        [⚙️ Config] │
├─────────────────────────────────────────────────────────┤
│                                                         │
│  O que voce precisa?                                    │
│  ┌─────────────────────────────────────────────────┐   │
│  │ Crie um relatorio de vendas do Q4 2024 com      │   │
│  │ graficos comparativos e tabela de metas...      │   │
│  │                                                  │   │
│  └─────────────────────────────────────────────────┘   │
│                                                         │
│  Tipo de documento:                                     │
│  [📝 Word] [📊 Excel] [📽️ PowerPoint] [📄 PDF]         │
│                                                         │
│  ☑ Incluir imagens geradas por IA                      │
│                                                         │
│  Enviar resultado para:                                 │
│  ☑ Download   ☐ Email   ☐ Telegram                     │
│                                                         │
│              [🚀 Gerar Documento]                       │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

## Endpoints da API REST

### Documentos
```
POST /api/documents/generate → Gerar qualquer documento
  Body: {
    type: "docx"|"xlsx"|"pptx"|"pdf",
    prompt: "descricao do documento",
    include_images: true|false,
    delivery: ["download", "email", "telegram"]
  }
GET  /api/documents/{id}     → Baixar documento gerado
GET  /api/documents/history  → Listar documentos gerados
```

### IA
```
POST /api/ai/generate        → Gerar conteudo com IA
  Body: { prompt: "..." }
  (usa provedor configurado no painel)
```

### Imagens
```
POST /api/images/generate    → Gerar imagem
  Body: { prompt: "...", style: "..." }
  (usa provedor configurado no painel)
```

### Configuracoes
```
GET  /api/config             → Obter configuracoes atuais
POST /api/config             → Salvar configuracoes
POST /api/config/test/{provider} → Testar conexao com provedor
  Providers: claude, openai, openrouter, nanobanana, kieai, telegram, email
```

### Canais (Telegram/Email)
```
POST /api/channels/telegram/webhook → Receber mensagens do Telegram
POST /api/channels/email/receive    → Receber emails (webhook)
```

## Configuracao de APIs (Variaveis de Ambiente)

```env
# .env (valores iniciais, depois configura pelo painel)

# LLMs
CLAUDE_API_KEY=sk-ant-...
OPENAI_API_KEY=sk-...
OPENROUTER_API_KEY=or-...

# Imagens
NANOBANANA_API_KEY=nb-...
KIEAI_API_KEY=kie-...

# Telegram
TELEGRAM_BOT_TOKEN=123456:ABC...
TELEGRAM_CHAT_ID=opcional

# Email
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_USER=seu@email.com
SMTP_PASSWORD=senha-de-app

# App
SECRET_KEY=chave-secreta-para-db
```

## Fluxo de Geracao de Documento

```
ENTRADA VIA WEB:
1. Usuario acessa interface web
2. Descreve o que quer no documento
3. Seleciona tipo (DOCX, XLSX, PPTX, PDF)
4. Escolhe destino (Download, Email, Telegram)
5. Clica em "Gerar"

ENTRADA VIA TELEGRAM:
1. Usuario envia mensagem para o bot
   Exemplo: "/docx Crie um relatorio de vendas Q4"
2. Bot processa e gera documento
3. Bot envia documento de volta no chat

ENTRADA VIA EMAIL:
1. Usuario envia email para endereco configurado
   Assunto: "DOCX: Relatorio de vendas"
   Corpo: descricao do documento
2. Sistema processa e gera documento
3. Sistema responde email com documento anexo

PROCESSAMENTO (todos os canais):
1. Backend recebe solicitacao
2. Busca configuracoes do SQLite (qual LLM, qual API de imagem)
3. Envia prompt para LLM configurado
4. LLM retorna conteudo estruturado
5. Se PPTX/XLSX → Worker Node.js
6. Se DOCX/PDF → Python
7. Se incluir imagens → API de imagem configurada
8. Documento salvo em /output
9. Entrega conforme solicitado (download/email/telegram)
```

## Docker Compose

```yaml
version: '3.8'

services:
  backend:
    build: ./backend
    ports:
      - "8000:8000"
    env_file:
      - .env
    volumes:
      - ./output:/app/output
      - ./data:/app/data
      - ../scripts:/app/scripts
    depends_on:
      - workers

  frontend:
    build: ./frontend
    ports:
      - "3000:3000"
    depends_on:
      - backend

  workers:
    build: ./workers
    volumes:
      - ./output:/app/output

volumes:
  output:
  data:
```

## Etapas de Implementacao

### Fase 1: Backend FastAPI (Base)
1. Criar estrutura `app/backend/`
2. Configurar FastAPI com routers
3. Configurar SQLite para armazenar configuracoes
4. Criar endpoints de configuracao (GET/POST /api/config)
5. Criar endpoint de teste de conexao

### Fase 2: Servicos de LLM
1. Criar interface base para LLMs (`services/llm/base.py`)
2. Implementar Claude API
3. Implementar OpenAI API
4. Implementar OpenRouter API
5. Factory pattern para selecionar provedor

### Fase 3: Servicos de Imagens
1. Criar interface base para imagens (`services/images/base.py`)
2. Implementar NanoBanana API
3. Implementar Kie.ai API
4. Factory pattern para selecionar provedor

### Fase 4: Workers Node.js
1. Criar estrutura `app/workers/`
2. Criar worker para PPTX
3. Criar worker para XLSX
4. Configurar comunicacao HTTP com backend

### Fase 5: Geracao de Documentos
1. Integrar scripts existentes (Python/Node)
2. Criar endpoint `/api/documents/generate`
3. Integrar com LLM e imagens configurados

### Fase 6: Canais de Comunicacao
1. Implementar bot Telegram (`services/channels/telegram.py`)
2. Implementar servico de Email (`services/channels/email.py`)
3. Criar webhooks para receber mensagens
4. Logica de parsing de comandos

### Fase 7: Frontend React
1. Criar estrutura `app/frontend/`
2. Pagina Home (interface simplificada)
3. Pagina Config (painel de configuracao)
4. Pagina History (historico de documentos)
5. Componentes reutilizaveis

### Fase 8: Docker
1. Criar Dockerfile para cada servico
2. Criar docker-compose.yml
3. Configurar volumes e redes
4. Criar .env.example
5. Testar build e deploy

### Fase 9: Documentacao e Testes
1. Atualizar README com instrucoes Docker
2. Documentar API (Swagger automatico do FastAPI)
3. Exemplos de uso via Telegram
4. Exemplos de uso via Email

## Custos Estimados das APIs

| API | Modelo | Custo Aproximado |
|-----|--------|------------------|
| Claude | claude-3-sonnet | ~$3/1M tokens |
| OpenAI | gpt-4o | ~$5/1M tokens |
| OpenRouter | varios | varia por modelo |
| NanoBanana | - | verificar pricing |
| Kie.ai | - | verificar pricing |

## Vantagem do OpenRouter

OpenRouter permite acessar **varios modelos** com uma unica API Key:
- Claude (Anthropic)
- GPT-4 (OpenAI)
- Llama (Meta)
- Mistral
- E muitos outros

Isso simplifica a configuracao e permite trocar de modelo facilmente.

## Resumo do Plano

```
┌─────────────────────────────────────────────────────────┐
│                    MSFilesA App                         │
├─────────────────────────────────────────────────────────┤
│                                                         │
│  ENTRADA:           PROCESSAMENTO:      SAIDA:          │
│  ┌─────────┐       ┌─────────────┐     ┌─────────┐     │
│  │   Web   │──┐    │   FastAPI   │     │Download │     │
│  └─────────┘  │    │  + Workers  │  ┌──│  .docx  │     │
│  ┌─────────┐  │    │             │  │  │  .xlsx  │     │
│  │Telegram │──┼───▶│ LLM + Image │──┤  │  .pptx  │     │
│  └─────────┘  │    │   APIs      │  │  │  .pdf   │     │
│  ┌─────────┐  │    │             │  │  └─────────┘     │
│  │  Email  │──┘    └─────────────┘  │  ┌─────────┐     │
│  └─────────┘              │         ├──│  Email  │     │
│                     ┌─────┴─────┐   │  └─────────┘     │
│                     │  Painel   │   │  ┌─────────┐     │
│                     │  Config   │   └──│Telegram │     │
│                     └───────────┘      └─────────┘     │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

## Proximos Passos

Apos aprovacao deste plano, implementar na ordem:
1. Backend base + SQLite + Config
2. Integracao com LLMs (Claude/OpenAI/OpenRouter)
3. Integracao com Imagens (NanoBanana/Kie.ai)
4. Workers Node.js
5. Canais (Telegram/Email)
6. Frontend React
7. Docker
8. Documentacao
