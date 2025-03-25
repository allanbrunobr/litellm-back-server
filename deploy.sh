#!/bin/bash

# Set variables
PROJECT_ID="vpn-chatbot-dev"
REGION="us-central1"
IMAGE_NAME="litellm-server"
REPOSITORY="litellm-repo"

# String de conexão do banco de dados PostgreSQL do Neon.tech
DB_URL="postgresql://neondb_owner:npg_vK83YqplgezT@ep-floral-unit-a53d3jyc-pooler.us-east-2.aws.neon.tech/neondb?sslmode=require"

# Build the Docker image
echo "Building Docker image..."
docker build -t $REGION-docker.pkg.dev/$PROJECT_ID/$REPOSITORY/$IMAGE_NAME:latest .

# Push the image to Google Container Registry
echo "Pushing Docker image to Google Container Registry..."
docker push $REGION-docker.pkg.dev/$PROJECT_ID/$REPOSITORY/$IMAGE_NAME:latest

# Deploy to Cloud Run
echo "Deploying to Cloud Run..."
gcloud run deploy $IMAGE_NAME \
  --image $REGION-docker.pkg.dev/$PROJECT_ID/$REPOSITORY/$IMAGE_NAME:latest \
  --platform managed \
  --region $REGION \
  --memory 2048Mi \
  --cpu 1 \
  --max-instances 10 \
  --allow-unauthenticated \
  --service-account "749879354562-compute@developer.gserviceaccount.com" \
  --update-env-vars "OPENAI_API_KEY=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,ANTHROPIC_API_KEY=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,GEMINI_API_KEY=AIzaSyCasbpoNBkmZfuu9IEGhOGc8wxBEJ5Th5c,GROK_API_KEY=xai-syU4GduOod5hAhF8cU0SsolMZjmYuLqoQH2UkOwpWouLfaq9chNY8IaYQthRoTOeJAoqsCDWH090q6Yu,DEEPSEEK_API_KEY=sk-58e53e589fb54751a2cf557f671197f2,LITELLM_MASTER_KEY=metatron123,DATABASE_URL=${DB_URL},LITELLM_PRISMA_SCHEMA_FORCE_RESET=true"

echo "Deployment completed!" 