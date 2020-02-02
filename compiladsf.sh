#!/bin/sh

echo ** Compilamos DSF a JSON **
drf x $1.dsf $1.json

echo ** AMSTRAD **
drb cpc es $1.json $1CPC.ddb

echo ** SPECTRUM **
drb zx es $1.json $1ZX.ddb

echo ** MSX **
drb msx es $1.json $1MSX.ddb

echo    ** MSX 2 **
drb MSX2 8_6 ES $1.json %1MSX2.DDB

echo ** C64 **
drb c64 es $1.json %1C64.ddb

echo ** AMSTRAD PCW **
drb pcw es $1.json $1PCW.ddb
mv $1PCW.ddb PARTE001.DDB
CPCDiskXP -File PARTE001.DDB -AddToNewDsk PCW/$1PCW.DSK
CPCDiskXP -File PARTE001.CHR -AddToExistingDsk PCW/$1PCW.DSK
CPCDiskXP -File PARTE001.DAT -AddToExistingDsk PCW/$1PCW.DSK
CPCDiskXP -File GAME.COM -AddToExistingDsk PCW/$1PCW.DSK

echo ** AMIGA **
drb amiga es $1.json $1AMI.ddb
cp $1AMI.ddb AMIGA

echo ** ATARI ST **
drb st es $1.json $1ST.ddb
cp $1ST.ddb ATARI

echo ** PC **
drb pc vga es $1.json $1PC.ddb
rm -rf PC/*.ddb
cp $1PC.ddb PC
mv PC/$1PC.ddb PC/part1.ddb

echo ** CREAMOS DISCO AMSTRAD CPC **
mcrf $1CPC.bin i.z80 $1CPC.ddb chr.gra
# CPCDiskXP -File $1CPC.bin -AddToExistingDsk CPC/$1CPC.DSK
wine CPCDiskXP.exe -File $1CPC.bin -AddToNewDsk CPC/$1CPC.DSK

echo ** CREAMOS DISCO COMMODORE .D64 EN CARPETA C64
cp $1C64.ddb C64
cd C64
rm -f C64/daad.bin
rm -f C64/daad.ddb
# del C64/daad.d64
mv C64/$1C64.ddb C64/DAAD.DDB
cp C64/c64header.bin C64/DAAD.BIN
cat C64/DAAD.DDB >> C64/DAAD.BIN
cp C64/c64header.bin C64/DAAD.DDB C64/DAAD.BIN
cp C64/new.d64 C64/$1c64.D64
c1541 -attach C64/$1c64.D64 -write C64/DAAD.BIN bpart1

echo ** CREAMOS TAP DE SPECTRUM EN CARPETA ZX
cp $1ZX.ddb ZX
cd ZX
wine tapcat.exe -N $1ZX.TAP drs ds48is.p3f $1ZX.ddb tospec1.tb
cd ..

echo Teclea "PC nombreddb" en DOSBOX para probar en PC VGA

echo ** COPIAMOS DDB A CARPETA MSX **
cp $1MSX.ddb MSX
cd MSX
rm DAAD.DDB
mv $1MSX.ddb DAAD.DDB
rm $1MSX.DSK
wine dsktool.exe a $1MSX.DSK AUTOEXEC.BAT COMMAND.COM DAAD.DDB DAAD.MDG DAAD.Z80 MSXDAAD.COM MSXDOS.SYS
cd ..

echo ** MSX2 **
cp $1MSX2.ddb MSX2
cd MSX2
rm $1MSX2.DSK
mv $1MSX2.ddb DAAD.DDB
wine dsktool.exe a $1MSX2.DSK DAAD.DDB AUTOEXEC.BAT COMMAND.COM FONT.IM8 MSX2DAAD.COM MSXDOS.SYS TEXTS.XDB
rm DAAD.DDB
cd ..

rm $1CPC.DDB
rm $1cpc.bin
rm $1ZX.DDB
rm $1c64.ddb
rm $1msx.ddb
rm $1pc.ddb
rm PARTE001.DDB
rm $1ami.ddb
rm $1st.ddb
rm $1msx2.ddb
