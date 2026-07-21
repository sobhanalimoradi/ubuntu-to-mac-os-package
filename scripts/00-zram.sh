#!/bin/bash
# Compressed RAM-backed swap (zram), on top of whatever disk swap already
# exists. On a RAM-constrained machine, disk swap causes real stalls when hit;
# zram is checked first (higher priority) and is fast enough that hitting it
# barely registers. Independent of the theme — safe to run standalone.
set -e

echo "==> Installing systemd-zram-generator..."
sudo apt-get install -y systemd-zram-generator

echo "==> Configuring zram0 (half of RAM, capped at 4G, zstd, checked before disk swap)..."
sudo tee /etc/systemd/zram-generator.conf > /dev/null <<'EOF'
[zram0]
zram-size = min(ram / 2, 4096)
compression-algorithm = zstd
swap-priority = 100
fs-type = swap
EOF

sudo systemctl daemon-reload
sudo systemctl start systemd-zram-setup@zram0.service

echo "00-zram.sh done."
swapon --show
