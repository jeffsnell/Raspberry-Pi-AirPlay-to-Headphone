#!/bin/bash

set -e

echo "---------------------------------------------"
echo "Step 1: Creating systemd service file for Shairport Sync..."

SERVICE_FILE="/etc/systemd/system/shairport-sync.service"

if [ -f "$SERVICE_FILE" ]; then
  echo "Service file already exists: $SERVICE_FILE"
else
  echo "Creating service file: $SERVICE_FILE"
  sudo bash -c "cat > $SERVICE_FILE" <<EOF
[Unit]
Description=Shairport Sync AirPlay Receiver
After=sound.target network.target

[Service]
ExecStart=/usr/local/bin/shairport-sync
Restart=on-failure
User=shairport-sync
Group=audio

[Install]
WantedBy=multi-user.target
EOF
  echo "Service file created."
fi
echo "Step 1 complete."
echo "---------------------------------------------"

echo "Step 2: Creating 'shairport-sync' user if needed..."
if ! id "shairport-sync" &>/dev/null; then
  sudo useradd -r -s /usr/sbin/nologin -g audio shairport-sync
  echo "User 'shairport-sync' created."
else
  echo "User 'shairport-sync' already exists."
fi
echo "Step 2 complete."
echo "---------------------------------------------"

echo "Step 3: Reloading systemd and enabling service..."
sudo systemctl daemon-reexec
sudo systemctl daemon-reload
sudo systemctl enable shairport-sync
echo "Step 3 complete: Service enabled to run at boot."
echo "---------------------------------------------"

echo "Step 4: Starting shairport-sync service..."
sudo systemctl start shairport-sync

echo "Step 4 complete: Service started."
echo "---------------------------------------------"

echo "Step 5: Checking service status..."
sudo systemctl status shairport-sync --no-pager || true
echo "Step 5 complete: Status shown."
echo "---------------------------------------------"

echo "✅ All steps in Increment 3 completed successfully."
