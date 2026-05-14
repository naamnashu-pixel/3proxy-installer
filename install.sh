#!/bin/bash

set -e

echo "Installing 3proxy PRO FIX..."

apt update -y
apt install -y git build-essential

cd /root

# clean old
rm -rf 3proxy

# clone fresh
git clone https://github.com/3proxy/3proxy.git
cd 3proxy

# build
make -f Makefile.Linux

# verify build
if [ ! -f src/3proxy ]; then
    echo "BUILD FAILED ❌"
    exit 1
fi

# install binary
cp src/3proxy /usr/local/bin/3proxy
chmod +x /usr/local/bin/3proxy

# config
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

# systemd
cat > /etc/systemd/system/3proxy.service <<EOF
[Unit]
Description=3Proxy Service
After=network.target

[Service]
ExecStart=/usr/local/bin/3proxy /etc/3proxy/3proxy.cfg
Restart=always
RestartSec=2

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable 3proxy
systemctl restart 3proxy

echo "DONE ✔ PRO MODE ACTIVE"
