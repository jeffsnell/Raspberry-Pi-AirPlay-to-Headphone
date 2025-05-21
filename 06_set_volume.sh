#!/bin/bash
set -e

echo "---------------------------------------------"
echo "Step 1: Setting Master volume to 100%..."
amixer sset 'Master' 100%
amixer sset 'Master' unmute
echo "Step 1 complete: Volume set and unmuted."
echo "---------------------------------------------"

echo "Step 2: Attempting to save ALSA volume state..."
if sudo alsactl store; then
  echo "Step 2 complete: ALSA state saved."
else
  echo "⚠️  WARNING: ALSA state could not be saved. System may be using PulseAudio or PipeWire."
  echo "    You may need to set volume manually after reboot."
fi
echo "---------------------------------------------"

echo "✅ 06_set_volume.sh completed."
