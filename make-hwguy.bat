@echo off
mkdir hwguy
preqcc -file preprogs-hwguy.src
ren preprogs.src -preprogs.src
frikqcc.exe /Of /Oc /Ol  -nopause
del *.pqc
pause
exit