# Etapa 1: Construir el frontend en Node.js
FROM node:20-alpine AS frontend-builder
WORKDIR /app/frontend

# Copiar archivos de configuración e instalar dependencias
COPY frontend/package.json ./
# Si existe package-lock.json se copiará, si no, fallará silenciosamente si usamos un wildcard
COPY frontend/package*.json ./
RUN npm install

# Copiar el resto del código y construir
COPY frontend/ ./
RUN npm run build

# Etapa 2: Configurar el backend en Python y servir todo
FROM python:3.11-slim
WORKDIR /app

# Instalar uv para gestionar dependencias rápidamente
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

# Copiar archivos de dependencias
COPY pyproject.toml uv.lock ./

# Instalar las dependencias (creará un entorno virtual en /app/.venv)
RUN uv sync --frozen --no-dev

# Copiar el código del backend
COPY backend/ ./backend/

# Copiar los archivos estáticos construidos en la etapa 1
COPY --from=frontend-builder /app/frontend/dist ./frontend/dist

# Añadir el entorno virtual al PATH
ENV PATH="/app/.venv/bin:$PATH"

# Exponer el puerto donde corre FastAPI
EXPOSE 8001

# Iniciar la aplicación
CMD ["python", "-m", "backend.main"]
