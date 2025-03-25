# Use uma imagem base Python
FROM python:3.11-slim

# Instale o Prisma CLI e o cliente PostgreSQL
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    postgresql-client \
    curl \
    gnupg2 \
    dos2unix \
    && rm -rf /var/lib/apt/lists/* \
    && pip install --no-cache-dir prisma

# Configure o diretório de trabalho
WORKDIR /app

# Copie os arquivos necessários
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY schema.prisma .
COPY config.yaml .
COPY migrations/ ./migrations/

# Script de inicialização
COPY start.sh .
RUN dos2unix start.sh && \
    chmod +x start.sh

# Exponha a porta
EXPOSE 8080

# Define variáveis de ambiente padrão
ENV PORT=8080
ENV HOST=0.0.0.0

# Comando para iniciar a aplicação
CMD ["./start.sh"]