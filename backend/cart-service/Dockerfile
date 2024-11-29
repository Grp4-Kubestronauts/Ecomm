FROM node:18-alpine

WORKDIR /app

# Install debugging tools
RUN apk add --no-cache curl

COPY package*.json ./
RUN npm install

COPY . .

# Add healthcheck
HEALTHCHECK --interval=30s --timeout=3s \
  CMD curl -f http://localhost:3001/health || exit 1

EXPOSE 3001

# Add environment variable check on startup
CMD ["node", "src/index.js"]