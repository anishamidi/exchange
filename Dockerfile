# ===============================
# Stage 1: Build environment
# ===============================
FROM python:3.13-slim AS builder

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

RUN apt-get update && apt-get install -y \
    build-essential \
    libpq-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY requirements.txt ./

RUN pip install --upgrade pip && \
    pip install --prefix=/install -r requirements.txt

# ===============================
# Stage 2: Runtime environment
# ===============================
FROM python:3.13-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

RUN apt-get update && apt-get install -y \
    libpq-dev \
    && rm -rf /var/lib/apt/lists/*

COPY --from=builder /install /usr/local


COPY . /app
WORKDIR /app/Exchange

ENV RUN_MODE=prod \
    DJANGO_SETTINGS_MODULE=Exchange.settings

RUN python manage.py collectstatic --noinput || echo "Static files skipped"

CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]

