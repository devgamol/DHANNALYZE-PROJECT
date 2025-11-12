# 1. Base Image
FROM node:22-alpine AS builder

# Set working directory
WORKDIR /app

# Copy package files first (for layer caching)
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy all source code
COPY . .

# 2. Production Image
FROM node:22-alpine

WORKDIR /app

# Copy only what’s needed from builder
COPY --from=builder /app ./

# Expose the port your app runs on
EXPOSE 3000

# Define environment variables (use .env on Render, not here)
ENV NODE_ENV=production

# Start the application
CMD ["npm", "start"]
