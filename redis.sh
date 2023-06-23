# Run Redis with the custom configuration
CMD ["redis-server", "/usr/local/etc/redis/redis.conf"]
EOF

# Create Redis container
mkdir redis
cd redis
cat > redis.conf << EOF
bind 0.0.0.0
protected-mode no
EOF

docker build -t redis -f redis.Dockerfile .
docker run -d --name redis-container -p 6379:6379 redis


