# ─────────────────────────────────────────
# 1) BUILD STAGE
# ─────────────────────────────────────────
FROM node:20-alpine AS build

WORKDIR /app

# Instalacja zależności (deterministyczna)
COPY package.json package-lock.json ./
RUN npm ci

# Kod źródłowy
COPY . .

# Build Vite (dist/)
RUN npm run build


# ─────────────────────────────────────────
# 2) RUNTIME STAGE (nginx)
# ─────────────────────────────────────────
FROM nginx:alpine

# Usuwamy domyślną konfigurację
RUN rm /etc/nginx/conf.d/default.conf

# Konfiguracja SPA
COPY nginx.conf /etc/nginx/conf.d/vue.conf

# Statyczne pliki z Vite
COPY --from=build /app/dist /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]