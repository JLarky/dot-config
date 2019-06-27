# https://hub.docker.com/r/rastasheep/ubuntu-sshd
docker cp ~/.ssh/id_ed25519.pub openconnect:/root/.ssh/authorized_keys
docker exec -it openconnect chown root:root /root/.ssh/authorized_keys

ssh root@localhost -Nf -p 14722 -D 14701 -L 14702:git.8x8.com:22
