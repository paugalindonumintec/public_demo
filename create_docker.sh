mkdir ssh
cp /home/pau_galindo/.ssh/id_ed25519 ./ssh/id_rsa
docker build --build-arg environ=$1 -f dist_conf/app.Dockerfile -t app .
rm -r ssh/