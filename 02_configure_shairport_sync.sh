#!/bin/bash

set -e

echo "---------------------------------------------"
echo "Step 1: Ensure /etc directory exists..."
if [ ! -d /etc ]; then
  echo "ERROR: /etc directory is missing. This system may be broken. Exiting."
  exit 1
fi
echo "Step 1 complete: /etc directory exists."
echo "---------------------------------------------"

echo "Step 2: Detecting available audio sinks..."

mapfile -t SINK_LIST < <(pactl list short sinks | awk '{print $2}')

if [ "${#SINK_LIST[@]}" -eq 0 ]; then
  echo "ERROR: No audio sinks found. Make sure PulseAudio or PipeWire is running."
  exit 1
fi

echo "Available audio sinks:"
for i in "${!SINK_LIST[@]}"; do
  echo "  [$i] ${SINK_LIST[$i]}"
done

echo ""
read -p "Enter the number of the sink to use for headphone output, or 'x' to exit: " SELECTION

if [[ "$SELECTION" == "x" || "$SELECTION" == "X" ]]; then
  echo "User exited. No changes made."
  exit 0
fi

if ! [[ "$SELECTION" =~ ^[0-9]+$ ]] || [ "$SELECTION" -ge "${#SINK_LIST[@]}" ]; then
  echo "Invalid selection. Exiting."
  exit 1
fi

SINK_NAME="${SINK_LIST[$SELECTION]}"
echo "Selected sink: $SINK_NAME"
echo "---------------------------------------------"

echo "Step 3: Creating or updating /etc/shairport-sync.conf..."

CONFIG_FILE="/etc/shairport-sync.conf"
HOSTNAME=$(hostname)

if [ ! -f "$CONFIG_FILE" ]; then
  echo "Creating $CONFIG_FILE..."
  sudo touch "$CONFIG_FILE"
fi

sudo bash -c "cat > $CONFIG_FILE" <<EOF
general = {
  name = "${HOSTNAME}";
};

audio_backend = "pa";

pa = {
  sink = "${SINK_NAME}";
};
EOF

echo "Step 3 complete: Configuration file written."
echo "---------------------------------------------"

echo "Step 4: Restarting shairport-sync service (if installed)..."

if systemctl list-unit-files | grep -q "^shairport-sync.service"; then
  sudo systemctl restart shairport-sync
  echo "Step 4 complete: Service restarted."
else
  echo "NOTICE: shairport-sync.service not found yet. It will be installed in the next step."
fi

echo "---------------------------------------------"
echo "✅ All steps in Increment 2 completed successfully."
