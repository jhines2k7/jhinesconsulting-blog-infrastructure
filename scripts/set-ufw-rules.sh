#!/usr/bin/expect

# set ufw rules for node

echo "======> setting up firewall rules for $1 ..."

docker-machine ssh $1 \
echo '"y" | sudo ufw --force enable \
&& sudo ufw default deny incoming \
&& sudo ufw allow 22/tcp \
&& sudo ufw allow 2376/tcp \
&& sudo ufw allow 2377/tcp \
&& sudo ufw allow 7946/tcp \
&& sudo ufw allow 7946/udp \
&& sudo ufw allow 4789/udp \
&& sudo ufw allow 80/tcp \
&& sudo ufw reload \
&& sudo systemctl restart docker'
