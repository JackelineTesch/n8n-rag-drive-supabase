# Pipeline RAG Automático com n8n, Google Drive e Supabase

Este projeto realiza a ingestão e vetorização automática de documentos armazenados no Google Drive para alimentar um banco de dados vetorial no Supabase (PostgreSQL + pgvector). O objetivo é fornecer contexto estruturado para um agente de IA realizar consultas RAG (Retrieval-Augmented Generation).

## 🛠️ Tecnologias Utilizadas

* **n8n Cloud**: Orquestração do fluxo de trabalho e automação.
* **Google Drive API**: Monitoramento e download automático de novos documentos.
* **Google Gemini API**: Modelo `gemini-embedding-2` para geração de vetores (3072 dimensões).
* **Supabase (PostgreSQL)**: Armazenamento vetorial com a extensão `pgvector`.

---

## 📐 Arquitetura do Fluxo

1. **Google Drive Trigger**: Monitora uma pasta específica por eventos de inclusão de arquivos.
2. **Google Drive (Download)**: Realiza o download do arquivo em formato binário.
3. **Default Data Loader & Text Splitter**: Extrai o texto do PDF e realiza a divisão em *chunks*.
4. **Embeddings Google Gemini**: Converte cada fragmento de texto em um vetor numérico de 3072 dimensões.
5. **PGVector Store (Supabase)**: Salva o conteúdo, os metadados do arquivo (`file_id`, `file_name`) e o vetor de similaridade.

---

## ⚙️ Configuração do Projeto

### 1. Banco de Dados (Supabase)
1. Acesse o **SQL Editor** do seu projeto no Supabase.
2. Execute o script contido em `sql/setup_supabase.sql` para criar a extensão `vector`, a tabela `rag_documents` e a função RPC `match_documents`.

### 2. Automação no n8n
1. Crie um novo workflow no n8n.
2. Acesse o menu superior (`...`) > **Import from file...** e selecione o arquivo `workflows/rag_ingestao_drive.json`.
3. Configure as credenciais necessárias:
   * **Google Drive OAuth2**: Acesso à pasta monitorada.
   * **Google Gemini API**: Chave obtida no Google AI Studio.
   * **Postgres / Supabase**: Dados de conexão com a porta `5432` ou `6543`.

---

## 📄 Estrutura do Repositório

```text
├── workflows/
│   └── rag_ingestao_drive.json  # Workflow exportado do n8n
├── sql/
│   └── setup_supabase.sql       # Script SQL para tabela e função vetorial
├── .gitignore                   # Proteção de arquivos sensíveis
└── README.md                    # Documentação do projeto