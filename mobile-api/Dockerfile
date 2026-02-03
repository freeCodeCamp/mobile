FROM node:24-alpine AS builder
WORKDIR /build
COPY . .
RUN corepack enable && corepack prepare pnpm@latest --activate
RUN pnpm install --frozen-lockfile
RUN pnpm run build

FROM node:24-alpine AS dependencies
WORKDIR /build
COPY pnpm-lock.yaml package.json ./
RUN corepack enable && corepack prepare pnpm@latest --activate
RUN pnpm install --prod --frozen-lockfile

FROM node:24-alpine
WORKDIR /api
RUN corepack enable && corepack prepare pnpm@latest --activate
COPY --from=builder /build/package.json /build/pnpm-lock.yaml ./
COPY --from=builder /build/prod/  ./prod/
COPY --from=dependencies /build/node_modules ./node_modules/
CMD ["pnpm", "start"]
