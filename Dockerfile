FROM node:24-alpine

WORKDIR /home/app

COPY ./package*.json  /home/app

RUN npm ci && npm cache clean --force

COPY . .

RUN cp env.example .env && mkdir -p config

RUN chown -R node:node /home/app

USER node

CMD ["node", "--env-file=.env", "index.js"]
