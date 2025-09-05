<<<<<<< HEAD
 ==============================
 OMEGA_PLR - README.md
 ==============================
 Projeto OMEGA_PLR

 Baseado em YUMI_PLR, adaptado para Sovol SV07+ rodando Klipper.
 Permite recuperacaoo de impressao apos queda de energia.

 Principais diferencas:
 - Diretorio base: /home/mks/OMEGA_PLR
 - Macros renomeadas para evitar conflito com arquivos originais da Sovol
 - Inclusoes no `printer.cfg` sao manuais

  Instalacao Manual
 1.1 Copie a pasta OMEGA_PLR para `/home/mks/`

 1.2 Instalação Automática

Execute os comandos abaixo via SSH na sua impressora:

```bash
cd ~
git clone https://github.com/omegapinho/OMEGA_PLR.git
cd OMEGA_PLR
./install.sh


 2. Inclua no arquivo de sua maquina printer.cfg a linha baixo:
#--------- ini
 [include /home/mks/OMEGA_PLR/plr_omega.cfg]
#--------- 
 3. Reinicie o Klipper

  Configuracao no Orca Slicer
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

  Recuperacao manual
 - Caso haja queda de energia, ao religar a impressora:
   a) - Cancele a opção de resume Original da Sovol
   b) - Va ate a interface (Mainsail/Fluidd) e Execute a macro abaixo:
#--------- gcode
 RESUME_INTERRUPTED_OMEGA
#--------- 
 - A impressao sera retomada a partir da camada salva.

  Avisos Importantes
 - O Z nao pode ter sido movido manualmente durante a queda de energia.
 - Pode haver pequenas falhas visuais no ponto de retomada.
 - Nem sempre a prÃ©-visualizacaoo do G-code sera reconstruÃida.

 ---

 "A excelencia nao esta no que temos, mas no que fazemos com o que temos." Aristoteles

=======
# omega_plr
Baseado em YUMI_PLR, adaptado para Sovol SV07+ rodando Klipper.
>>>>>>> 593bf67f6d83cb8e327988f012f5417e8ee70808
