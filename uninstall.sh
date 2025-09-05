#!/bin/bash
# ==============================
# OMEGA_PLR - uninstall.sh
# ==============================

USER_HOME="/home/mks"
KLIPPER_DIR="$USER_HOME/klipper/klippy/extras"
OMEGA_DIR="$USER_HOME/OMEGA_PLR"

echo "[OMEGA_PLR] Iniciando desinstalação..."

# Remove diretório principal
if [ -d "$OMEGA_DIR" ]; then
    rm -rf "$OMEGA_DIR"
    echo "[OK] Diretório $OMEGA_DIR removido."
else
    echo "[INFO] Diretório $OMEGA_DIR não encontrado."
fi

# Remove gcode_shell_command.py
if [ -f "$KLIPPER_DIR/gcode_shell_command.py" ]; then
    rm -f "$KLIPPER_DIR/gcode_shell_command.py"
    echo "[OK] gcode_shell_command.py removido de $KLIPPER_DIR"
else
    echo "[INFO] gcode_shell_command.py não encontrado em $KLIPPER_DIR"
fi

echo "============================================="
echo "[OMEGA_PLR] Desinstalação concluída!"
echo "⚠️ ATENÇÃO: Edite seu printer.cfg e remova a linha:"
echo "   [include plr_omega.cfg]"
echo "============================================="
