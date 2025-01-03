#eval $(ssh-agent -s)
#ssh-add /home/pau_galindo/.ssh/id_ed25519
docker build --ssh default=$SSH_AUTH_SOCK --build-arg environ=$1 -f dist_conf/app.Dockerfile -t app .