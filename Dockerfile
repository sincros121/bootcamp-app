FROM node:14.19.1-alpine

WORKDIR /bootcamp-app

COPY ["package.json", "package-lock.json*", "./"]

RUN npm install

COPY . .

EXPOSE 8080

ENTRYPOINT [ "node", "src/index.js"]


