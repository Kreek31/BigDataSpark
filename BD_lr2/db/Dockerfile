# db/Dockerfile
FROM postgres:15

# ставим dos2unix
RUN apt-get update     \
 && apt-get install -y dos2unix \
 && rm -rf /var/lib/apt/lists/*

# копируем init-скрипты внутрь образа
COPY init/ /docker-entrypoint-initdb.d/

# конвертируем все шельф-скрипты
RUN find /docker-entrypoint-initdb.d -name '*.sh' -exec dos2unix {} \;