FROM node:24-alpine

RUN mkdir -p /home/app/config

WORKDIR /home/app

COPY ./package*.json  /home/app

RUN npm ci

COPY . .
COPY env.example .env

RUN mv env.example .env
CMD ["node", "--env-file=.env", "index.js"]
