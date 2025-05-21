#!/bin/bash

set -e

echo "---------------------------------------------"
echo "Step 1: Installing build tools for nqptp..."
sudo apt-get update
sudo apt-get install -y autoconf automake libtool
echo "Step 1 complete."
echo "---------------------------------------------"

echo "Step 2: Cloning nqptp repository..."
NQPTP_DIR="$HOME/nqptp"
rm -rf "$NQPTP_DIR"
git clone https://github.com/mikebrady/nqptp.git "$NQPTP_DIR"
cd "$NQPTP_DIR"
echo "Repository cloned."
echo "---------------------------------------------"

echo "Step 3: Building nqptp..."
autoreconf -fi
./configure --with-systemd-startup
make
sudo make install
echo "Step 3 complete: nqptp installed."
echo "---------------------------------------------"

echo "Step 4: Enabling and starting nqptp.service..."
sudo systemctl daemon-reexec
sudo systemctl daemon-reload
sudo systemctl enable nqptp
sudo systemctl start nqptp
echo "Step 4 complete: nqptp service running."
echo "---------------------------------------------"

echo "✅ 05_install_nqptp.sh completed successfully."
