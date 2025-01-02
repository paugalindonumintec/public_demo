docker stop $(docker ps -a -q)
docker rm -f $(docker ps -a -q)

docker rmi -f $(docker images -a -q)
docker builder prune -a
