@echo off
preqcc  -file preprogs-tf2003.src
frikqcc.exe /Of /Oc /Ol  -nopause
del *.pqc
pause
exit