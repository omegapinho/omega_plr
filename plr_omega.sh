#!/bin/bash
# =========================================
# OMEGA_PLR - plr_omega.sh
# -----------------------------------------
# Reconstrucao um G-code de retomada
# usando dados salvos no Klipper
# ou no backup redundante (omega_resume.log).
# =========================================

PLR_PATH="/home/mks/OMEGA_PLR/plr"
SAVE_FILE="/home/mks/printer_data/config/saved_variables.cfg"
BACKUP_FILE="/home/mks/OMEGA_PLR/omega_resume.log"

# Garante que a pasta exista
if [ ! -d "$PLR_PATH" ]; then
  mkdir -p "$PLR_PATH"
  echo "[OMEGA_PLR] Pasta criada: $PLR_PATH"
fi

# Try Klipper saved variables first
filepath=$(sed -n "s/.*filepath *= *'\([^']*\)'.*/\1/p" "$SAVE_FILE")
last_file=$(sed -n "s/.*last_file *= *'\([^']*\)'.*/\1/p" "$SAVE_FILE")
z_height="$1"

# Fallback to OMEGA backup if needed
if [ -z "$filepath" ] || [ -z "$last_file" ]; then
  echo "[OMEGA_PLR] Using backup file: $BACKUP_FILE"
  filepath=$(awk -F= '/^filepath=/{print substr($0, index($0,$2))}' "$BACKUP_FILE")
  last_file=$(awk -F= '/^last_file=/{print substr($0, index($0,$2))}' "$BACKUP_FILE")
  if [ -z "$z_height" ]; then
    z_height=$(awk -F= '/^z_height=/{print $2}' "$BACKUP_FILE")
  fi
fi

if [ -z "$filepath" ] || [ -z "$last_file" ] || [ -z "$z_height" ]; then
  echo "[OMEGA_PLR] ERROR: missing data (filepath=$filepath, last_file=$last_file, z=$z_height)"
  exit 1
fi

OUTPUT_GENERIC="$PLR_PATH/_RESUME_OMEGA.gcode"
OUTPUT_NAMED="$PLR_PATH/$last_file"

cat "$filepath" > /home/mks/plrtmpA.$$

# Build resume gcode (use the logged z_height directly)
# 1) Fix the kinematic Z to the last known layer height
awk -v z="$z_height" 'BEGIN{printf "SET_KINEMATIC_POSITION Z=%.3f\n", z}' > "$OUTPUT_GENERIC"

# 2) Reapply temps seen before the target Z (optional but kept)
echo 'M118 START_TEMPS...' >> "$OUTPUT_GENERIC"
sed "/ Z$z_height/q" /home/mks/plrtmpA.$$ | sed -ne '/\(M104\|M140\|M109\|M190\|M106\)/p' >> "$OUTPUT_GENERIC"

# 3) Safe sequence: lift slightly, home XY, move back near target Z
echo 'G91'       >> "$OUTPUT_GENERIC"
echo 'G1 Z2'     >> "$OUTPUT_GENERIC"   # small lift up
echo 'G90'       >> "$OUTPUT_GENERIC"
echo 'G28 X Y'   >> "$OUTPUT_GENERIC"
awk -v z="$z_height" 'BEGIN{printf "G0 Z%.3f\n", z+0.20}' >> "$OUTPUT_GENERIC"
echo 'M106 S204' >> "$OUTPUT_GENERIC"

# 4) Append everything AFTER the target Z
awk -v z="$z_height" '
  {
    if ($0 ~ / Z/) {
      # Extrai o valor de Z manualmente
      zval = $0
      sub(/.*Z/, "", zval)
      sub(/ .*/, "", zval)
      if (zval+0 >= z && !started) {
        started=1
      }
    }
    if (started) print
  }
' /home/mks/plrtmpA.$$ >> "$OUTPUT_GENERIC"

rm /home/mks/plrtmpA.$$

# Also keep a copy named after original file (optional)
cp -f "$OUTPUT_GENERIC" "$OUTPUT_NAMED"

echo "[OMEGA_PLR] Resume file: $OUTPUT_GENERIC"
echo "[OMEGA_PLR] Copy (named): $OUTPUT_NAMED"

# =========================================
# NOVO BLOCO - Verificação e cópia p/ gcodes/plr
# =========================================
GCODES_PLR="/home/mks/printer_data/gcodes/plr"
DEST_FILE="$GCODES_PLR/_RESUME_OMEGA.gcode"

# 1. Verifica origem
if [ ! -f "$OUTPUT_GENERIC" ]; then
  echo "[OMEGA_PLR] ERRO: Arquivo de retomada não encontrado em $OUTPUT_GENERIC"
  exit 1
fi

# 2. Garante pasta de destino limpa
mkdir -p "$GCODES_PLR"
rm -f "$GCODES_PLR"/*

# 3. Copia
cp -f "$OUTPUT_GENERIC" "$DEST_FILE"
echo "[OMEGA_PLR] Arquivo copiado para $DEST_FILE"

# 4. Confirma se realmente chegou
for i in {1..5}; do
  if [ -f "$DEST_FILE" ]; then
    echo "[OMEGA_PLR] Arquivo confirmado no destino."
    exit 0
  fi
  echo "[OMEGA_PLR] Aguardando cópia... ($i/5)"
  sleep 1
done

echo "[OMEGA_PLR] ERRO: Arquivo não confirmado no destino após 5s."
exit 1
