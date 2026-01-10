# Imagen base
FROM python:3.11-slim

ENV DEBIAN_FRONTEND=noninteractive \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        build-essential \
        cmake \
        swig \
        git \
        curl \
        ca-certificates \
        libgomp1 \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# 1) Dependencias Python
COPY requirements.txt /app/requirements.txt
RUN pip install --upgrade pip && \
    pip install -r /app/requirements.txt

# 2) Código y artefactos (RAG)
COPY server.py /app/server.py
COPY embeddings_meta_min.pkl /app/embeddings_meta_min.pkl
COPY faiss_index_ip.bin /app/faiss_index_ip.bin
COPY scopusdata.csv /app/scopusdata.csv
COPY lid.176.ftz /app/lid.176.ftz

# 3) Variables de entorno (ajusta si aplica)
ENV PKL_MIN_PATH=/app/embeddings_meta_min.pkl \
    FAISS_PATH=/app/faiss_index_ip.bin \
    SCOPUS_CSV=/app/scopusdata.csv \
    SCOPUS_SEP="|" \
    LID_MODEL_PATH=/app/lid.176.ftz \
    RAG_TEMPERATURE=0.2 \
    RAG_MAX_NEW_TOKENS=768 \
    RAG_TOP_CONTEXT=6 \
    RAG_MAX_INPUT_CHARS=7000 \
    RAG_MAX_CHUNK_CHARS=900 \
    RAG_TRIM_ABSTRACT=1 \
    API_TOPK=100 \
    RAG_HTTP_TIMEOUT_SECS=300 \
    CROSS_ENCODER_MODEL=cross-encoder/ms-marco-MiniLM-L-6-v2 \
    OLLAMA_HOST=http://host.docker.internal:11434 \
    OLLAMA_MODEL=gemma3:4b \
    PORT=8181

# Puerto FastAPI
EXPOSE 8181

# Uvicorn como server (más estándar que __main__ en contenedores)
CMD ["uvicorn", "server:app", "--host", "0.0.0.0", "--port", "8181"]
