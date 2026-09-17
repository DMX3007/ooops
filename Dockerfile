FROM node:24-alpine

WORKDIR /home/app

COPY package*.json ./

RUN npm ci --omit=dev && npm cache clean --force

COPY . .

RUN chown -R node:node /home/app

USER node

EXPOSE 8080

CMD ["node", "index.js"]