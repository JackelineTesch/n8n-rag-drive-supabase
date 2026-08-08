-- 1. Habilita a extensão pgvector no PostgreSQL
create extension if not exists vector;

-- 2. Cria a tabela para armazenar os documentos e os embeddings (3072 dimensões)
drop table if exists rag_documents cascade;

create table rag_documents (
  id uuid primary key default gen_random_uuid(),
  content text,
  metadata jsonb,        -- Armazena file_id, file_name e outros metadados do arquivo
  embedding vector(3072) -- Dimensão correspondente ao modelo gemini-embedding-2
);

-- 3. Cria a função RPC para busca por similaridade de cosseno (RAG)
create or replace function match_documents (
  query_embedding vector(3072),
  match_count int default 5,
  filter jsonb default '{}'
)
returns table (
  id uuid,
  content text,
  metadata jsonb,
  similarity float
)
language plpgsql
as $$
begin
  return query
  select
    rag_documents.id,
    rag_documents.content,
    rag_documents.metadata,
    1 - (rag_documents.embedding <=> query_embedding) as similarity
  from rag_documents
  where rag_documents.metadata @> filter
  order by rag_documents.embedding <=> query_embedding
  limit match_count;
end;
$$;