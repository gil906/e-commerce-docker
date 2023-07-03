# E-Commerce Application with Docker

This repository contains the Docker setup for an e-commerce application consisting of front-end, back-end, and application layers, along with a Redis layer for caching. This setup allows you to easily deploy and run the application using Docker containers.

## Prerequisites

Make sure you have the following dependencies installed:

- Docker
- Node.js (for front-end and back-end layers)

## Layers

The e-commerce application is divided into the following layers, each running within its own Docker container:

1. **Front-end Layer**: Responsible for the user interface and rendering the website's components.
2. **Back-end Layer**: Handles the server-side logic and provides APIs for interacting with the database.
3. **Database Layer**: Manages the storage and retrieval of data required by the application.
4. **Application Layer**: Contains the main application logic and API endpoints, connecting the front-end and back-end layers.
5. **Redis Layer**: Provides caching functionality for improved performance.

## Setup Instructions

Follow these steps to set up and run the e-commerce application using Docker:

1. **Redis Layer**:
   - Create a directory for Redis: `mkdir redis`
   - Navigate to the Redis directory: `cd redis`
   - Create a file named `redis.conf` with the Redis configuration.
   - Build the Redis Docker image: `docker build -t redis -f Dockerfile.redis .`
   - Start the Redis container: `docker run -d --name redis-container -p 6379:6379 redis`

2. **Front-end Layer**:
   - Create a directory for the front-end: `mkdir frontend`
   - Navigate to the frontend directory: `cd frontend`
   - Create a React application using Create React App: `npx create-react-app .`
   - Build the front-end Docker image: `docker build -t frontend -f Dockerfile.frontend .`
   - Start the front-end container: `docker run -d --name frontend-container -p 3000:80 frontend`

3. **Back-end Layer**:
   - Create a directory for the back-end: `mkdir backend`
   - Navigate to the backend directory: `cd backend`
   - Place your back-end code in this directory.
   - Build the back-end Docker image: `docker build -t backend -f Dockerfile.backend .`
   - Start the back-end container: `docker run -d --name backend-container -p 8000:8000 backend`

4. **Database Layer**:
   - Create a directory for the database: `mkdir database`
   - Navigate to the database directory: `cd database`
   - Place your database initialization script as `database.sql` in this directory.
   - Build the database Docker image: `docker build -t database -f Dockerfile.database .`
   - Start the database container: `docker run -d --name database-container -p 3306:3306 database`

5. **Application Layer**:
   - Create a directory for the application: `mkdir application`
   - Navigate to the application directory: `cd application`
   - Place your application code in this directory.
   - Build the application Docker image: `docker build -t application -f Dockerfile.application .`
   - Start the application container: `docker run -d --name application-container -p 8000:8000 application`

6. Access the application in your browser: `http://localhost:3000`

Note: Make sure your Raspberry Pi is running Ubuntu Server with Docker installed.

## Topology

                                    +------------------+
                                    |   User's        |
                                    |   Browser       |
                                    +------------------+
                                             |
                                     HTTP Requests
                                             |
                                             v
                                    +------------------+
                                    |   Front-end      |
                                    |   Container      |
                                    +------------------+
                                             |
                                             | Views
                                             |
                                             v
                                    +------------------+
                                    |   Back-end       |
                                    |   Container      |
                                    +------------------+
                                             |
                                     API Requests
                                             |
                                             v
                                    +------------------+
                                    |   Database       |
                                    |   Container      |
                                    +------------------+
                                             |
                                    Database Queries
                                             |
                                             v
                                    +------------------+
                                    |   Redis          |
                                    |   Container      |
                                    +------------------+
                                             |
                                    Caching Data
                                             |
                                             v
                                    +------------------+
                                    |   Front-end      |
                                    |   Container      |
                                    +------------------+
                                             |
                                 Front-end Updates
                                             |
                                             v
                                    +------------------+
                                    |   Front-end      |
                                    |   Container      |
                                    +------------------+
                                             |
                                        Rendered Views
                                             |
                                             v
                                    +------------------+
                                    |   User's        |
                                    |   Browser       |
                                    +------------------+



### I'm still fixing this topology 😋


## Customization

- Update the Docker
