#!/bin/bash

# Install Docker
sudo apt-get update
sudo apt-get install docker.io -y
sudo systemctl start docker
sudo systemctl enable docker

# Create a directory for the project
mkdir ecommerce
cd ecommerce

# Create Dockerfiles
cat > Dockerfile.redis <<EOF
FROM redis
COPY redis.conf /usr/local/etc/redis/redis.conf
CMD ["redis-server", "/usr/local/etc/redis/redis.conf"]
EOF

cat > Dockerfile.frontend <<EOF
FROM node:14-alpine
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
EXPOSE 80
CMD ["npm", "start"]
EOF

cat > Dockerfile.backend <<EOF
FROM node:14-alpine
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
EXPOSE 8000
CMD ["npm", "start"]
EOF

cat > Dockerfile.database <<EOF
FROM mysql:8.0
COPY database.sql /docker-entrypoint-initdb.d/
EXPOSE 3306
EOF

cat > Dockerfile.application <<EOF
FROM node:14-alpine
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
EXPOSE 8000
CMD ["npm", "start"]
EOF

# Build and run Redis container
docker build -t redis -f Dockerfile.redis .
docker run -d --name redis-container -p 6379:6379 redis

# Build and run Front-end container - It will map the frontend 3000 to the container port 80
cd ..
docker build -t frontend -f ecommerce/Dockerfile.frontend .
docker run -d --name frontend-container -p 3000:80 frontend

# Build and run Back-end container
docker build -t backend -f ecommerce/Dockerfile.backend .
docker run -d --name backend-container -p 8000:8000 backend

# Build and run Database container
docker build -t database -f ecommerce/Dockerfile.database .
docker run -d --name database-container -p 3306:3306 -e MYSQL_ROOT_PASSWORD=<YOUR_ROOT_PASSWORD> database

# Build and run Application container
docker build -t application -f ecommerce/Dockerfile.application .
docker run -d --name application-container -p 8000:8000 --link database-container --link redis-container application

# Access the application in your browser: http://localhost:3000
