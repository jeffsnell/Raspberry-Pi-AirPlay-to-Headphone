#!/bin/bash

set -e

echo "---------------------------------------------"
echo "Step 1: Load selected sink from /etc/shairport-sync.conf..."

CONFIG_FILE="/etc/shairport-sync.conf"
if [ ! -f "$CONFIG_FILE" ]; then
  echo "ERROR: Cannot find $CONFIG_FILE. Please run previous steps first."
  exit 1
fi

SINK=$(grep 'sink' "$CONFIG_FILE" | sed -E 's/.*sink\s*=\s*"([^"]+)".*/\1/')
if [ -z "$SINK" ]; then
  echo "ERROR: Could not extract sink from config file."
  exit 1
fi

echo "Configured sink: $SINK"
echo "---------------------------------------------"

echo "Step 2: Checking if sink is available..."
if ! pactl list short sinks | grep -q "$SINK"; then
  echo "ERROR: Sink $SINK is not available. Check PulseAudio or PipeWire."
  exit 1
fi
echo "Sink $SINK is available."
echo "---------------------------------------------"

echo "Step 3: Playing test sound through $SINK..."

# Generate a short sine wave test tone (1s, 440 Hz)
TEST_WAV="/tmp/test_sine.wav"
sox -n -r 48000 -c 2 "$TEST_WAV" synth 1 sine 440

# Play it through the sink
paplay --device="$SINK" "$TEST_WAV"

echo "Step 3 complete: Test sound played. Did you hear it from the headphone jack?"
echo "---------------------------------------------"

echo "✅ Audio test complete. If no sound was heard, check mixer levels (use 'alsamixer')."
