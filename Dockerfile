# Stage 1: Build Stage
FROM node:18-alpine AS builder

# Set the working directory
WORKDIR /app

# Install dependencies
COPY package.json package-lock.json ./
RUN npm ci

# Copy the rest of the source code
COPY . .

# Build the project
RUN npm run build

# Stage 2: Runtime Stage
FROM busybox:1.35.0-uclibc

# Copy built files from the builder stage
COPY --from=builder /app/dist /var/www

# Expose port 80 to the outside world
EXPOSE 80

# Command to serve static files
CMD ["httpd", "-f", "-v", "-p", "80", "-h", "/var/www"]
