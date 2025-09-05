#!/bin/bash
# =========================================
# OMEGA_PLR - omega_save.sh
# -----------------------------------------
# Salva informacoeµes essenciais da impressao
# em um arquivo redundante, para sobreviver
# a resets/limpezas do saved_variables.cfg
# =========================================

# Caminho do arquivo de backup
LOG_FILE="/home/mks/OMEGA_PLR/omega_resume.log"

# Primeiro argumento = altura Z
Z_HEIGHT="$1"
shift

# Todos os argumentos restantes = caminho do G-code (pode ter espacos)
GCODE_FILE="$*"

# Timestamp para auditoria
TS=$(date +"%Y-%m-%d_%H:%M:%S")

# Se valores naoo foram passados, aborta com aviso
if [ -z "$GCODE_FILE" ]; then
  echo "[$TS] Nenhum arquivo informado, nao ha o que salvar." >> "$LOG_FILE"
  exit 1
fi

# Grava no arquivo de log (sobrescrevendo o antigo)
cat <<EOF > "$LOG_FILE"
# OMEGA_PLR - estado salvo
timestamp=$TS
last_file=$(basename "$GCODE_FILE")
filepath=$GCODE_FILE
z_height=$Z_HEIGHT
EOF

echo "[$TS] Dados salvos em $LOG_FILE" >> "$LOG_FILE"
exit 0
