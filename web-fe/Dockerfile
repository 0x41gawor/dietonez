# ─────────────────────────────────────────
# 1) BUILD STAGE
# ─────────────────────────────────────────
FROM node:20-alpine AS build

WORKDIR /app

# Instalacja zależności (deterministyczna)
COPY web-fe/package.json web-fe/package-lock.json ./
RUN npm ci

# Kod źródłowy Vue
COPY web-fe/ ./

# Build Vite (dist/)
RUN npm run build


# ─────────────────────────────────────────
# 2) RUNTIME STAGE (nginx)
# ─────────────────────────────────────────
FROM nginx:alpine

# Usuwamy domyślną konfigurację
RUN rm /etc/nginx/conf.d/default.conf

# Flutter Web (execution)
COPY mobile-fe/build/web /usr/share/nginx/html/execution

# Konfiguracja SPA
COPY web-fe/nginx.conf /etc/nginx/conf.d/vue.conf

# Statyczne pliki Vue (dist/)
COPY --from=build /app/dist /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]