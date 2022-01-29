FROM node:16-alpine

WORKDIR /app
COPY package*.json .

RUN npm ci --production

COPY . .
CMD ["npm", "start"]