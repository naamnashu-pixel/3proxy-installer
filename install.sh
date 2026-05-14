#!/bin/bash

echo "Installing 3proxy..."

apt update -y
apt install -y git build-essential

git clone https://github.com/3proxy/3proxy.git
cd 3proxy

make -f Makefile.Linux

cp src/3proxy /usr/local/bin/

mkdir -p /etc/3proxy

cat > /etc/3proxy/3proxy.cfg <<EOF
daemon
nserver 8.8.8.8
nserver 1.1.1.1
auth none
allow *
proxy -p1080
socks -p1080
EOF

nohup 3proxy /etc/3proxy/3proxy.cfg > /dev/null 2>&1 &

echo "DONE ✔"
