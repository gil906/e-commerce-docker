docker build -t frontend -f Dockerfile.frontend .
docker build -t backend -f Dockerfile.backend .
docker build -t database -f Dockerfile.database .
docker build -t application -f Dockerfile.application .
