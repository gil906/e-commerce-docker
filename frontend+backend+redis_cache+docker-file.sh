#!/bin/bash

# Create Redis container
mkdir redis
cd redis
cat > Dockerfile.redis << EOF
# Use a lightweight Redis image with ARM64 architecture
FROM arm64v8/redis:latest

# Copy the Redis configuration file
COPY redis.conf /usr/local/etc/redis/redis.conf

# Expose port 6379
EXPOSE 6379

# Run Redis with the custom configuration
CMD ["redis-server", "/usr/local/etc/redis/redis.conf"]
EOF

cat > redis.conf << EOF
bind 0.0.0.0
protected-mode no
EOF

docker build -t redis -f Dockerfile.redis .
docker run -d --name redis-container -p 6379:6379 redis

# Create Front-end container
cd ..
mkdir frontend
cd frontend
cat > Dockerfile.frontend << EOF
# Use a lightweight Node.js image with ARM64 architecture
FROM node:14-bullseye-slim as build

# Set the working directory
WORKDIR /app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependencies
RUN npm ci

# Copy the built React app
COPY build/ ./

# Expose port 80
EXPOSE 80

# Start the server
CMD ["npx", "serve", "-s", ".", "-l", "80"]
EOF

# Build and run Front-end container
npm install -g create-react-app
npx create-react-app .
npm run build
docker build -t frontend -f Dockerfile.frontend .
docker run -d --name frontend-container -p 3000:80 frontend

# Create Back-end container
cd ..
mkdir backend
cd backend
cat > Dockerfile.backend << EOF
# Use a lightweight Node.js image with ARM64 architecture
FROM node:14-bullseye-slim

# Set the working directory
WORKDIR /app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependencies
RUN npm ci

# Copy the back-end code
COPY . .

# Expose port 8000
EXPOSE 8000

# Start the server
CMD ["node", "app.js"]
EOF

# Build and run Back-end container
# Update the Dockerfile.backend as per your back-end setup
docker build -t backend -f Dockerfile.backend .
docker run -d --name backend-container -p 8000:8000 backend

# Create Database container
cd ..
mkdir database
cd database
cat > Dockerfile.database << EOF
# Use the official MySQL image
FROM mysql:latest

# Set the root password and create a database
ENV MYSQL_ROOT_PASSWORD=mysecretpassword
ENV MYSQL_DATABASE=mydatabase

# Copy the SQL initialization script
COPY ./database.sql /docker-entrypoint-initdb.d/

# Expose port 3306
EXPOSE 3306
EOF

# Place your database initialization script as database.sql in the database directory
docker build -t database -f Dockerfile.database .
docker run -d --name database-container -p 3306:3306 database

# Create Application container
cd ..
mkdir application
cd application
cat > Dockerfile.application << EOF
# Use a lightweight Node.js image with ARM64 architecture
FROM node:14-bullseye-slim

# Set the working directory
WORKDIR /app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependencies
RUN npm ci

# Copy the application code
COPY .



