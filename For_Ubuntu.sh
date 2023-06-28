#!/bin/bash

# Install Docker
sudo apt-get update
sudo apt-get install docker.io -y
sudo systemctl start docker
sudo systemctl enable docker

# Build and run Redis container
mkdir redis
cd redis
cat > Dockerfile.redis <<EOF
FROM redis
COPY redis.conf /usr/local/etc/redis/redis.conf
CMD ["redis-server", "/usr/local/etc/redis/redis.conf"]
EOF
cat > redis.conf <<EOF
# Redis configuration goes here
EOF
sudo docker build -t redis -f Dockerfile.redis .
sudo docker run -d --name redis-container -p 6379:6379 redis

# Build and run Front-end container
cd ..
mkdir frontend
cd frontend
cat > Dockerfile.frontend <<EOF
FROM node:14-alpine
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
EXPOSE 80
CMD ["npm", "start"]
EOF
# Copy your front-end code into the frontend directory
sudo docker build -t frontend -f Dockerfile.frontend .
sudo docker run -d --name frontend-container -p 3000:80 frontend

# Build and run Back-end container
cd ..
mkdir backend
cd backend
# Place your back-end code in this directory
cat > Dockerfile.backend <<EOF
FROM node:14-alpine
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
EXPOSE 8000
CMD ["npm", "start"]
EOF
sudo docker build -t backend -f Dockerfile.backend .
sudo docker run -d --name backend-container -p 8000:8000 backend

# Build and run Database container
cd ..
mkdir database
cd database
# Place your database initialization script as `database.sql` in this directory
cat > Dockerfile.database <<EOF
FROM mysql:8.0
COPY database.sql /docker-entrypoint-initdb.d/
EXPOSE 3306
EOF
sudo docker build -t database -f Dockerfile.database .
sudo docker run -d --name database-container -p 3306:3306 -e MYSQL_ROOT_PASSWORD=<YOUR_ROOT_PASSWORD> database

# Build and run Application container
cd ..
mkdir application
cd application
# Place your application code in this directory
cat > Dockerfile.application <<EOF
FROM node:14-alpine
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
EXPOSE 8000
CMD ["npm", "start"]
EOF
sudo docker build -t application -f Dockerfile.application .
sudo docker run -d --name application-container -p 8000:8000 --link database-container --link redis-container application

# Access the application in your browser: http://localhost:3000
