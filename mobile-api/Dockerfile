FROM node:18-alpine AS builder
WORKDIR /build
COPY . .
RUN npm ci
RUN npm run build

FROM node:18-alpine AS dependencies
WORKDIR /build
COPY package-lock.json package.json ./
RUN npm ci --production

FROM node:18-alpine
WORKDIR /api
COPY --from=builder /build/package.json /build/package-lock.json ./
COPY --from=builder /build/prod/  ./prod/
COPY --from=dependencies /build/node_modules ./node_modules/
CMD ["npm", "start"]
