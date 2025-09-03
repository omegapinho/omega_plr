 ==============================
 OMEGA_PLR - README.md
 ==============================
 Projeto OMEGA_PLR

 Baseado em YUMI_PLR, adaptado para Sovol SV07+ rodando Klipper.
 Permite recuperação de impressão após queda de energia.

 Principais diferenças:
 - Diretório base: /home/mks/OMEGA_PLR
 - Macros renomeadas para evitar conflito com arquivos originais da Sovol
 - Inclusões no `printer.cfg` são manuais

  Instalação
 1. Copie a pasta OMEGA_PLR para `/home/mks/`
 2. Inclua no seu `printer.cfg` a linha:
#--------- ini
 [include /home/mks/OMEGA_PLR/plr_omega.cfg]
#--------- 
 3. Reinicie o Klipper

  Configuração no Orca Slicer
 Para que o OMEGA_PLR funcione corretamente, configure os blocos de G-code no Orca Slicer:

  Start G-code:
 G31_OMEGA
 save_last_file_omega
 SAVE_VARIABLE VARIABLE=was_interrupted VALUE=True

  End G-code:
#--------- gcode
 SAVE_VARIABLE VARIABLE=was_interrupted VALUE=False
 clear_last_file_omega
 G31_OMEGA
#--------- 

  Before layer change G-code:
#--------- gcode
 LOG_Z_OMEGA
#--------- 

  Recuperação manual
 - Caso haja queda de energia, ao religar a impressora vá até a interface (Mainsail/Fluidd)
 - Execute a macro:
#--------- gcode
 RESUME_INTERRUPTED_OMEGA
#--------- 
 - A impressão será retomada a partir da camada salva.

  Avisos Importantes
 - O Z não pode ter sido movido manualmente durante a queda de energia.
 - Pode haver pequenas falhas visuais no ponto de retomada.
 - Nem sempre a pré-visualização do G-code será reconstruída.

 ---

 "A excelência não está no que temos, mas no que fazemos com o que temos." — Aristóteles

