#!/bin/bash

echo "Installing 3proxy ULTRA PRO MODE..."

apt update -y
apt install -y git build-essential

# build 3proxy
git clone https://github.com/3proxy/3proxy.git
cd 3proxy
make -f Makefile.Linux

cp src/3proxy /usr/local/bin/
chmod +x /usr/local/bin/3proxy

# config (locked basic)
mkdir -p /etc/3proxy

cat > /etc/3proxy/3proxy.cfg <<EOF
daemon
nserver 8.8.8.8
nserver 1.1.1.1

auth none
allow *

proxy -p1080
socks -p1080

maxconn 1000
timeouts 1 5 30 60 180 1800 15 60
EOF

# SYSTEMD (AUTO START + AUTO RESTART + HARD STABILITY)
cat > /etc/systemd/system/3proxy.service <<EOF
[Unit]
Description=3Proxy Ultra Service
After=network.target
Wants=network.target

[Service]
Type=simple
ExecStart=/usr/local/bin/3proxy /etc/3proxy/3proxy.cfg
Restart=always
RestartSec=2
LimitNOFILE=65535
KillMode=process

# extra stability
Nice=-10

[Install]
WantedBy=multi-user.target
EOF

# enable + lock service
systemctl daemon-reload
systemctl enable 3proxy
systemctl restart 3proxy

echo "DONE ✔ ULTRA PRO MODE ACTIVE"
