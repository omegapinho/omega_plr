#!/bin/bash
# =========================================
# OMEGA_PLR - install.sh
# -----------------------------------------
# Instalação do sistema de recuperação
# baseado em OMEGA_PLR para Klipper
# =========================================

USER_HOME="/home/mks"
KLIPPER_DIR="$USER_HOME/klipper"
PRINTER_CONFIG_DIR="$USER_HOME/printer_data/config"
OMEGA_DIR="$USER_HOME/OMEGA_PLR"
PLR_DIR="$OMEGA_DIR/plr"

echo "[OMEGA_PLR] Iniciando instalação..."

# Garante que pastas existam
mkdir -p "$PLR_DIR"
mkdir -p "$PRINTER_CONFIG_DIR"

# Copia arquivos principais
cp -f plr_omega.cfg "$PRINTER_CONFIG_DIR/" && echo "[OK] plr_omega.cfg instalado"
cp -f plr_omega.sh "$OMEGA_DIR/" && echo "[OK] plr_omega.sh instalado"
cp -f omega_save.sh "$OMEGA_DIR/" && echo "[OK] omega_save.sh instalado"
cp -f clear_plr_omega.sh "$OMEGA_DIR/" && echo "[OK] clear_plr_omega.sh instalado"
cp -f gcode_shell_command.py "$KLIPPER_DIR/klippy/extras/" && echo "[OK] gcode_shell_command.py instalado"

# Permissões
chmod +x "$OMEGA_DIR/"*.sh
chmod -R 775 "$PLR_DIR"
chmod 664 "$PRINTER_CONFIG_DIR/plr_omega.cfg"
chown -R mks:mks "$OMEGA_DIR" "$PRINTER_CONFIG_DIR"

# Avisos finais
echo "============================================="
echo "[OMEGA_PLR] Instalação concluída!"
echo "1. Inclua a seguinte linha no seu printer.cfg:"
echo "   [include plr_omega.cfg]"
echo "2. Reinicie o Klipper com o comando: RESTART"
echo "3. Configure seu slicer para usar os macros:"
echo "   - Início: G31_OMEGA ; save_last_file_omega ; SAVE_VARIABLE VARIABLE=was_interrupted VALUE=True"
echo "   - Fim: clear_last_file_omega ; G31_OMEGA ; SAVE_VARIABLE VARIABLE=was_interrupted VALUE=False"
echo "============================================="
