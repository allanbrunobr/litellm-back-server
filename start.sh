#!/bin/bash

# Gera o cliente Prisma
echo "Generating Prisma client..."
prisma generate

# Aplica o schema com a coluna id opcional
echo "Applying schema with optional id column..."
prisma db push

# Executa o script de migração para atualizar os registros existentes
echo "Updating existing records with IDs..."
PGPASSWORD=$(echo $DATABASE_URL | sed -n 's/.*:\/\/[^:]*:\([^@]*\)@.*/\1/p') \
psql "$DATABASE_URL" -f /app/migrations/update_verification_tokens.sql

# Atualiza o schema para tornar a coluna id obrigatória
echo "Making id column required..."
sed -i 's/id         String\?   @id/id         String   @id/' /app/schema.prisma
prisma db push

# Inicia o servidor LiteLLM
echo "Starting LiteLLM server..."
exec litellm --config /app/config.yaml --port $PORT --host $HOST 