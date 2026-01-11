# Instrucciones

# 1) Ejecutar Docker Compose
docker compose up -d

# 2) Entrar al contenedor de Ollama
docker exec -it ollama bash

# 3) Descargar el modelo Gemma 3 (4B)
ollama pull gemma3:4b
