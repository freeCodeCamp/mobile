FROM node:16-alpine AS builder
WORKDIR /app
COPY . .
RUN npm ci
RUN npm run build

FROM node:16-alpine
WORKDIR /api
COPY --from=builder /app/package.json /app/package-lock.json ./
COPY --from=builder /app/prod/  ./src/
RUN npm ci --production
CMD ["npm", "start"]