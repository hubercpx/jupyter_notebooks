FROM python:3.11-slim

# Dependencias básicas
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential curl && \
    rm -rf /var/lib/apt/lists/*

# Paquetes Python necesarios (incluye 'notebook' para generar hash)
RUN pip install --no-cache-dir jupyterlab notebook pandas numpy matplotlib

WORKDIR /app
EXPOSE 8888
ENV PORT=8888

# Copia el script de arranque y dale permisos
COPY start.sh /app/start.sh
RUN chmod +x /app/start.sh

# Arranque: script que calcula hash y lanza Jupyter
CMD ["/app/start.sh"]
