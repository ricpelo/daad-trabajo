ECHO OFF
cls

echo.
echo	** Compilamos DSF a JSON **
drf32.exe x %1.dsf %1.json
cd..

echo	** AMSTRAD **
php temp/drb.php cpc es temp/%1.json temp/%1CPC.ddb

echo	** SPECTRUM **
php temp/drb.php zx es temp/%1.json temp/%1ZX.ddb

echo	** MSX **
php temp/drb.php msx es temp/%1.json temp/%1MSX.ddb

echo    ** MSX 2 **
php TEMP/drb.php MSX2 8_6 ES temp/%1.json temp/%1MSX2.DDB

echo	** C64 **
php temp/drb.php c64 es temp/%1.json temp/%1C64.ddb

echo	** AMSTRAD PCW **
php temp/drb.php pcw es temp/%1.json temp/%1PCW.ddb
cd temp
ren %1pcw.ddb PARTE001.DDB
CPCDiskXP -File PARTE001.DDB -AddToNewDsk PCW/%1PCW.DSK
CPCDiskXP -File PARTE001.CHR -AddToExistingDsk PCW/%1PCW.DSK
CPCDiskXP -File PARTE001.DAT -AddToExistingDsk PCW/%1PCW.DSK
CPCDiskXP -File GAME.COM -AddToExistingDsk PCW/%1PCW.DSK
cd..

echo	** AMIGA **
php temp/drb.php amiga es temp/%1.json temp/%1AMI.ddb
cd temp
copy %1ami.ddb AMIGA
cd..

echo	** ATARI ST **
php temp/drb.php st es temp/%1.json temp/%1ST.ddb
cd temp
copy %1st.ddb ATARI
cd..

echo	** PC **
php temp/drb.php pc vga es temp/%1.json temp/%1PC.ddb
cd temp
cd pc
del *.DDB
cd..
COPY %1PC.ddb PC
cd pc
ren %1PC.ddb part1.ddb
cd..

echo	** CREAMOS DISCO AMSTRAD CPC **
mcrf32 %1CPC.bin i.z80 %1CPC.ddb chr.gra
rem CPCDiskXP -File %1CPC.bin -AddToExistingDsk CPC/CPC.DSK
CPCDiskXP -File %1CPC.bin -AddToNewDsk CPC/%1CPC.DSK
echo.

echo.
echo	** CREAMOS DISCO COMMODORE .D64 EN CARPETA C64
copy %1C64.ddb C64
cd C64
del daad.bin
del daad.ddb
rem del daad.d64
ren %1C64.ddb DAAD.DDB
copy /b c64header.BIN+DAAD.DDB DAAD.BIN
copy new.d64 %1c64.D64
c1541 -attach %1c64.D64 -write DAAD.BIN bpart1
cd..

echo.
echo	** CREAMOS TAP DE SPECTRUM EN CARPETA ZX
echo.
COPY %1ZX.ddb ZX
cd zx
tapcat -N %1ZX.TAP drs ds48is.p3f %1ZX.ddb tospec1.tb
cd..
echo.
echo	Teclea "PC nombreddb" en DOSBOX para probar en PC VGA
echo.
echo	** COPIAMOS DDB A CARPETA MSX
copy %1MSX.ddb MSX
cd msx
del daad.ddb
ren %1MSX.ddb DAAD.DDB
DEL %1MSX.DSK
dsktool a %1MSX.DSK autoexec.bat command.com daad.ddb daad.mdg daad.z80 msxdaad.com msxdos.sys
cd..

REM ** MSX2 **
copy %1msx2.ddb msx2
cd msx2
del %1msx2.dsk
ren %1msx2.ddb daad.ddb
dsktool a %1MSX2.DSK daad.ddb autoexec.bat command.com font.im8 msx2daad.com msxdos.sys texts.xdb
del daad.ddb
cd..


del %1CPC.DDB
del %1cpc.bin
del %1ZX.DDB
del %1c64.ddb
del %1msx.ddb
del %1pc.ddb
del PARTE001.DDB
del %1ami.ddb
del %1st.ddb
del %1msx2.ddb
