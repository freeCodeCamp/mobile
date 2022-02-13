FROM node:16-alpine

WORKDIR /app
COPY . .

RUN npm ci --production
CMD ["npm", "start"]