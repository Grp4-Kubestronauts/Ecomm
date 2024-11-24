# Stage 1: Build the React application using Node.js
FROM node:18-alpine as build

# Set npm configuration options to avoid timeout issues
RUN npm config set fetch-timeout 600000  # Set timeout to 10 minutes
RUN npm config set fetch-retries 5       # Retry 5 times if network request fails
RUN npm config set registry https://registry.npm.taobao.org  # Use a CDN registry mirror
RUN npm cache clean --force  # Clean the npm cache

# Set the working directory in the container
WORKDIR /app

# Copy package.json and package-lock.json (or npm-shrinkwrap.json) into the container
COPY package*.json ./

# Install dependencies in a clean environment using npm ci (recommended for CI/CD)
RUN npm ci

# Copy the rest of the application files into the container
COPY . .

# Build the application (you can specify the build command depending on your setup)
RUN npm run build

# Stage 2: Serve the built application using Nginx
FROM nginx:alpine

# Copy the build folder from the build stage to Nginx's HTML directory
COPY --from=build /app/build /usr/share/nginx/html

# Expose port 80 so Nginx can serve the application
EXPOSE 80

# Start Nginx in the foreground
CMD ["nginx", "-g", "daemon off;"]
