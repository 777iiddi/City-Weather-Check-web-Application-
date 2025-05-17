# syntax=docker/dockerfile:1

# Étape 1 : Utiliser Node pour builder l'application
FROM node:16-alpine as build


# Définir le dossier de travail
WORKDIR /app

# Copier les fichiers de dépendances
COPY package.json package-lock.json ./

# Installer les dépendances
RUN npm ci

# Copier le reste de l'application
COPY . .

# Builder l'application React
RUN npm run build

# Étape 2 : Utiliser Nginx pour servir l'application statique
FROM nginx:alpine

# Copier les fichiers de build dans le dossier public de Nginx
COPY --from=build /app/build /usr/share/nginx/html

# Exposer le port 80
EXPOSE 80

# Démarrer Nginx
CMD ["nginx", "-g", "daemon off;"]
