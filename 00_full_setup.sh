#!/bin/bash

set -e

LOGFILE="setup_$(date +%Y%m%d_%H%M%S).log"
exec > >(tee -a "$LOGFILE") 2>&1

echo "===================================================="
echo " Raspberry Pi AirPlay-to-Headphone Full Setup Start "
echo " Logging to: $LOGFILE"
echo "===================================================="

SCRIPTS=(
  01_install_shairport_sync.sh
  02_configure_shairport_sync.sh
  03_enable_shairport_service.sh
  04_test_audio_output.sh
  05_install_nqptp.sh
  06_set_volume.sh
)

for script in "${SCRIPTS[@]}"; do
  echo
  echo "----------------------------------------------------"
  echo " Running: $script"
  echo "----------------------------------------------------"
  if [[ -x "./$script" ]]; then
    ./"$script"
  else
    echo "ERROR: $script not found or not executable"
    exit 1
  fi
done

echo
echo "===================================================="
echo " ✅ Full Setup Complete. Log saved to: $LOGFILE"
echo "===================================================="
