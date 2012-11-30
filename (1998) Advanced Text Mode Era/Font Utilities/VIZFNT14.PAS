uses TextFont,Dos,Crt;
var i,j:integer;
begin
if ParamCount=0 then
begin
writeln('Vizualizare font 8x14 - programat de D.C.M. Soft');
writeln('Sintaxa: VIZFNT14 (numefis.fnt)');
writeln;
halt;
end;
setlines(1);
textmode(13);
clrscr;
setfont(ParamStr(1));
blasttextcursor;
writeln('Tabela ASCII:');
for i:=0 to 255 do Mem[$b800:160+(i*2)]:=i;
gotoxy(1,7);
writeln('Text scris:');
writeln(' Un inginer moare si apare in fata portilor Raiului. Sfantul Petru ii verifica');
writeln('dosarul, si vazand ca e inginer tipu'', il trimite in Iad. Dupa putina vreme,');
writeln('lu'' omu'' nostru incepe sa nu-i prea placa nivelul de trai de pe-acolo, asa ca');
writeln('se gandeste el ce se gandeste, si le face la astia toalete, aer conditionat si');
writeln('lifturi ... Intr-o zi, Dumnezeu ii telefoneaza lu'' Satana, ranjind ironic:');
writeln('- Ei, cum mai e pe-acolo prin Iad, he, he, he ... ?');
writeln('Satana ii raspunde cu acelasi ranjet:');
write('- Foaaarte bine, ne-a facut inginerul asta toalete, aer conditionat, lifturi, si');
writeln('  cine stie ce-o sa mai inventeze baiatul asta !');
write('- CUM ?! Aveti un inginer acolo ? Trebuie sa fie vreo greseala. Trimite-l inapoi');
writeln('  aici sus !');
writeln('- Nici gand ! Imi trebuie si nu ti-l dau sub nici un chip !!');
writeln('- Trimite-l aici sus sau te dau in judecata !');
writeln('- HUHUHUHOHOHOHAHAHAHA ! Daa, sigur ... Si de unde iei TU un avocat ??!');
readkey;
clrscr;
setlines(2);
textmode(13);
clrscr;
end.