#!/bin/bash

sox BLAD.VOC BOOM.VOC MINE.VOC PROT.VOC SHLD.VOC SLIM.VOC ZAPS.VOC _temp.voc

echo -n 'QAZWSXEDCRFVTGBYHNJ' > ASTROZAP.SFX
dd bs=1 if=_temp.voc skip=19 conv=notrunc oflag=append of=ASTROZAP.SFX
rm _temp.voc
