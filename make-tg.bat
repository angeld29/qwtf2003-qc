@echo off
mkdir tg
preqcc  -file preprogs-tf2003tg.src
frikqcc.exe /Of /Oc /Ol  -nopause
del *.pqc
pause
exit
