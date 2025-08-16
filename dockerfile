FROM python:3.9

# Instalar Jupyter
RUN pip install jupyter pandas numpy matplotlib

# Crear carpeta de trabajo
WORKDIR /app

# Puerto de Jupyter
EXPOSE 8888

# Ejecutar Jupyter Notebook sin token
CMD ["jupyter", "notebook", "--ip=0.0.0.0", "--port=8888", "--allow-root", "--no-browser", "--NotebookApp.token=''"]
