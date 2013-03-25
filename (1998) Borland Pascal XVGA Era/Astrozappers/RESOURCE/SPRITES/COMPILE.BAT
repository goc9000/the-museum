@ECHO OFF
if exist astrozap.idx del astrozap.idx
makegrp.exe
lipifis.exe astrozap.nam astrozap.pos
ren rezultat.fis astrozap.idx
del astrozap.nam
del astrozap.pos