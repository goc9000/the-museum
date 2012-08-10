
uses Dos;
var
 DirInfo: SearchRec;
 m:file of byte;
 f:file of char;
 g:file of char;
 d:char;
 l,i,j,k:integer;
 nm:string[12];
 x:byte;
 kh:char;
 kl:char;
 calc:word;
begin
 Assign(f,'img.grp');
 Rewrite(f);
 Assign(g,'img.ndx');
 Rewrite(g);
 FindFirst('*.SPR', AnyFile, DirInfo); { Same as DIR *.PAS }
 while DosError = 0 do
 begin
   for l:=1 to 12 do nm[l]:=chr(32);
   nm:=(DirInfo.Name);
   Assign(m,nm);
   for l:=1 to 12 do write(g,nm[l]);
   kh:=chr(Hi(FilePos(f)));
   kl:=chr(Lo(FilePos(f)));
   write(g,kh);
   write(g,kl);
   calc:=ord(kh);
   calc:=swap(calc);
   calc:=calc+ord(kl);
   writeln('Introduc ',nm,'   ',calc,'/65000');
   reset(m);
   while not eof(m) do
   begin
   read (m,x);
   d:=chr(x);
   write (f,d);
   end;
   close(m);
   FindNext(DirInfo);
 end;
 close(f);
writeln ('Ok.');
end.
