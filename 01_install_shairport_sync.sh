#!/bin/bash

set -e

echo "---------------------------------------------"
echo "Step 1: Updating system package lists..."
sudo apt-get update -y
echo "Step 1 complete: Package lists updated."
echo "---------------------------------------------"

echo "Step 2: Upgrading installed packages..."
sudo apt-get upgrade -y
echo "Step 2 complete: Packages upgraded."
echo "---------------------------------------------"

echo "Step 3: Installing required packages for Shairport Sync and audio testing..."

PACKAGES=(
  build-essential
  git
  autoconf
  automake
  libtool
  xmltoman
  libdaemon-dev
  libasound2-dev
  libpopt-dev
  libconfig-dev
  libssl-dev
  libavahi-client-dev
  libpulse-dev
  libsoxr-dev
  libdbus-1-dev
  libpipewire-0.3-dev
  pkg-config
  sox
  libsox-fmt-all
  pulseaudio-utils
  vim-common
  xxd
  libplist-dev
  libsodium-dev
  libgcrypt-dev
  libavutil-dev
  libavcodec-dev
  libavformat-dev
  uuid-dev
  avahi-daemon
)

for pkg in "${PACKAGES[@]}"; do
  echo "Checking/installing: $pkg"
  sudo apt-get install -y "$pkg"
done

echo "Step 3 complete: All required packages installed."
echo "---------------------------------------------"

echo "Step 4: Cloning and building Shairport Sync from source..."

SHAIRPORT_DIR="$HOME/shairport-sync"

if [ ! -d "$SHAIRPORT_DIR" ]; then
  echo "Cloning fresh copy of Shairport Sync..."
  git clone https://github.com/mikebrady/shairport-sync.git "$SHAIRPORT_DIR"
else
  echo "Shairport Sync source already exists. Resetting and updating..."
  cd "$SHAIRPORT_DIR"
  git fetch
  git reset --hard origin/master
  git clean -fd
fi

cd "$SHAIRPORT_DIR"

echo "Running autoreconf..."
autoreconf -fi

echo "Configuring build with ./configure..."
./configure --sysconfdir=/etc \
  --with-alsa \
  --with-soxr \
  --with-avahi \
  --with-ssl=openssl \
  --with-systemd \
  --with-airplay-2

echo "Compiling..."
make

echo "Installing..."
sudo make install

echo "Step 4 complete: Shairport Sync built and installed."
echo "---------------------------------------------"

echo "Step 5: Enabling Shairport Sync service (if available)..."
sudo systemctl enable shairport-sync || true
echo "Step 5 complete: Service enable attempted."
echo "---------------------------------------------"

echo "✅ All steps in 01_install_shairport_sync.sh completed successfully."
