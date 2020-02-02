#!/bin/sh

if [ "$#" -eq 0 ]
then
    echo "\n$0 <nombre>\n"
    exit 1
elif [ ! -f "$1.dsf" ]
then
    echo "\nEl archivo $1.dsf no existe.\n"
    exit 2
fi

echo "** Compilamos DSF a JSON **"
./drf x $1.dsf $1.json

echo "\n** AMSTRAD **"
php drb.php cpc es $1.json $1CPC.ddb

echo "\n** SPECTRUM **"
php drb.php zx es $1.json $1ZX.ddb

echo "\n** MSX **"
php drb.php msx es $1.json $1MSX.ddb

echo "\n** MSX 2 **"
php drb.php MSX2 8_6 ES $1.json $1MSX2.ddb

echo "\n** C64 **"
php drb.php c64 es $1.json $1C64.ddb

echo "\n** AMSTRAD PCW **"
php drb.php pcw es $1.json $1PCW.ddb
mv $1PCW.ddb PARTE001.DDB
wine CPCDiskXP.exe -File PARTE001.DDB -AddToNewDsk PCW/$1PCW.DSK
wine CPCDiskXP.exe -File PARTE001.CHR -AddToExistingDsk PCW/$1PCW.DSK
wine CPCDiskXP.exe -File PARTE001.DAT -AddToExistingDsk PCW/$1PCW.DSK
wine CPCDiskXP.exe -File GAME.COM -AddToExistingDsk PCW/$1PCW.DSK

echo "\n** AMIGA **"
php drb.php amiga es $1.json $1AMI.ddb
cp $1AMI.ddb AMIGA

echo "\n** ATARI ST **"
php drb.php st es $1.json $1ST.ddb
cp $1ST.ddb ATARI

echo "\n** PC **"
php drb.php pc vga es $1.json $1PC.ddb
rm -rf PC/*.ddb
cp $1PC.ddb PC
mv PC/$1PC.ddb PC/PART1.ddb

echo "\n** CREAMOS DISCO AMSTRAD CPC **"
./mcrf $1CPC.bin I.Z80 $1CPC.ddb CHR.GRA
# CPCDiskXP -File $1CPC.bin -AddToExistingDsk CPC/$1CPC.DSK
wine CPCDiskXP.exe -File $1CPC.bin -AddToNewDsk CPC/$1CPC.DSK

echo "\n** CREAMOS DISCO COMMODORE .D64 EN CARPETA C64"
cp $1C64.ddb C64
rm -f C64/daad.bin
rm -f C64/DAAD.DDB
# del C64/daad.d64
mv C64/$1C64.ddb C64/DAAD.DDB
cp -f C64/c64header.bin C64/daad.bin
cat C64/DAAD.DDB >> C64/daad.bin
cp C64/new.d64 C64/$1C64.D64
c1541 -attach C64/$1C64.D64 -write C64/daad.bin bpart1

echo "\n** CREAMOS TAP DE SPECTRUM EN CARPETA ZX"
cp $1ZX.ddb ZX
cd ZX
wine tapcat.exe -N $1ZX.TAP drs ds48is.p3f $1ZX.ddb TOSPEC1.TB
cd ..

echo "\n**** Teclea 'PC nombreddb' en DOSBOX para probar en PC VGA ****\n"

echo "\n** COPIAMOS DDB A CARPETA MSX **"
cp $1MSX.ddb MSX
cd MSX
rm DAAD.DDB
mv $1MSX.ddb DAAD.DDB
rm $1MSX.DSK
wine dsktool.exe a $1MSX.DSK AUTOEXEC.BAT COMMAND.COM DAAD.DDB DAAD.MDG DAAD.Z80 MSXDAAD.COM MSXDOS.SYS
cd ..

echo "\n** MSX2 **"
cp $1MSX2.ddb MSX2
cd MSX2
rm $1MSX2.DSK
mv $1MSX2.ddb DAAD.DDB
wine dsktool.exe a $1MSX2.DSK DAAD.DDB AUTOEXEC.BAT COMMAND.COM FONT.IM8 MSX2DAAD.COM MSXDOS.SYS TEXTS.XDB
rm DAAD.DDB
cd ..

rm $1CPC.ddb
rm $1CPC.bin
rm $1ZX.ddb
rm $1C64.ddb
rm $1MSX.ddb
rm $1PC.ddb
rm PARTE001.DDB
rm $1AMI.ddb
rm $1ST.ddb
rm $1MSX2.ddb
