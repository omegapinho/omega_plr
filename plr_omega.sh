# ==============================
# OMEGA_PLR - plr_omega.sh
# ==============================
#!/bin/bash
# Script que reconstrói um G-code de retomada baseado no arquivo salvo.
# Adaptação do plr.sh do YUMI_PLR, corrigido para ambiente mks.

mkdir -p /home/mks/printer_data/gcodes/plr/
filepath=$(sed -n "s/.*filepath *= *'\([^']*\)'.*/\1/p" /home/mks/printer_data/config/saved_variables.cfg)
filepath=$(printf "$filepath")
last_file=$(sed -n "s/.*last_file *= *'\([^']*\)'.*/\1/p" /home/mks/printer_data/config/saved_variables.cfg)
last_file=$(printf "$last_file")

plr=$last_file
PLR_PATH=/home/mks/printer_data/gcodes/plr/

cat "${filepath}" > /home/mks/plrtmpA.$$

# Extrai comandos necessários para retomada (temperaturas, posição Z, etc)
cat /home/mks/plrtmpA.$$ | sed -e '1,/Z'$1'/ d' | sed -ne '/ Z/,$ p' | grep -m 1 ' Z' | sed -ne 's/.* Z\([^ ]*\).*/SET_KINEMATIC_POSITION Z=\1/p' > ${PLR_PATH}/"${plr}"
echo 'M118 START_TEMPS...' >> ${PLR_PATH}/"${plr}"

# Recupera temperaturas e adiciona comandos obrigatórios
cat /home/mks/plrtmpA.$$ | sed '/ Z'$1'/q' | sed -ne '/\(M104\|M140\|M109\|M190\|M106\)/p' >> ${PLR_PATH}/"${plr}"

# Ajustes no extrusor e movimentação de segurança
echo 'G91' >> ${PLR_PATH}/"${plr}"
echo 'G1 Z10' >> ${PLR_PATH}/"${plr}"
echo 'G90' >> ${PLR_PATH}/"${plr}"
echo 'G28 X Y' >> ${PLR_PATH}/"${plr}"
echo 'G91' >> ${PLR_PATH}/"${plr}"
echo 'G1 Z-5' >> ${PLR_PATH}/"${plr}"
echo 'G90' >> ${PLR_PATH}/"${plr}"
echo 'M106 S204' >> ${PLR_PATH}/"${plr}"

# Junta o restante do G-code a partir da altura de retomada
tac /home/mks/plrtmpA.$$ | sed -e '/ Z'$1'[^0-9]*$/q' | tac | tail -n+2 | sed -ne '/ Z/,$ p' >> ${PLR_PATH}/"${plr}"
rm /home/mks/plrtmpA.$$
