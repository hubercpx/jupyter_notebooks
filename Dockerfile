FROM python:3.11-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential curl && \
    rm -rf /var/lib/apt/lists/*

# Asegura pip moderno y versiones compatibles de Jupyter
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir \
      "notebook>=7.1,<8" \
      "jupyterlab>=4.2,<5" \
      "jupyter-server>=2.13,<3" \
      "jupyter_scheduler>=2.11,<3" \
      pandas numpy matplotlib

WORKDIR /app
COPY start.sh /app/start.sh
RUN chmod +x /app/start.sh

EXPOSE 8888
ENV PORT=8888

CMD ["/app/start.sh"]
