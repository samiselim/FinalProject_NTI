# Stage 1: Build the Node.js application
FROM node:14 as build

WORKDIR /app

COPY package*.json ./
RUN  npm install cors
RUN npm install

COPY . .

FROM nginx:alpine

COPY --from=build /app /app

COPY default.conf /etc/nginx/conf.d/default.conf
# COPY nginx.conf /etc/nginx/nginx.conf

RUN apk add --no-cache nodejs npm

EXPOSE 80

CMD ["sh", "-c", "node /app/server.js & nginx -g 'daemon off;'"]
