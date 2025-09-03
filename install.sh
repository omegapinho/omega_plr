# ==============================
# OMEGA_PLR - install.sh
# ==============================
#!/bin/bash

USER_HOME="/home/mks"
PROJECT_DIR="$PWD"
KLIPPER_DIR="$USER_HOME/klipper"

# Cria pasta destino, se não existir
mkdir -p $USER_HOME/OMEGA_PLR

# Copia os arquivos principais
cp -f $PROJECT_DIR/plr_omega.cfg $USER_HOME/OMEGA_PLR/
cp -f $PROJECT_DIR/plr_omega.sh $USER_HOME/OMEGA_PLR/
cp -f $PROJECT_DIR/clear_plr.sh $USER_HOME/OMEGA_PLR/
cp -f $PROJECT_DIR/gcode_shell_command.py $KLIPPER_DIR/klippy/extras/

# Arquivo de variáveis
if [ ! -f $USER_HOME/printer_data/config/saved_variables.cfg ]; then
    touch $USER_HOME/printer_data/config/saved_variables.cfg
    echo "saved_variables.cfg criado com sucesso."
fi

echo "\nInstalação concluída. Inclua no seu printer.cfg a linha:"
echo "[include /home/mks/OMEGA_PLR/plr_omega.cfg]"


