uses Dos,Crt,Logic;
var
 DirInfo: SearchRec;
 long:longint;
 sprfile:file of byte;
 grpfile:file of char;
 ix1file:file of char;
 ix2file:file of longint;
 d:char;
 l,i,j,k:integer;
 nm:string[12];
 x:byte;
begin
 write('CPU...');
 Assign(grpfile,'astrozap.gfx');
 Rewrite(grpfile);
 Assign(ix1file,'astrozap.nam');
 Rewrite(ix1file);
 Assign(ix2file,'astrozap.pos');
 Rewrite(ix2file);
 FindFirst('*.SPR', AnyFile, DirInfo);
 while DosError = 0 do
 begin
   for l:=1 to 12 do nm[l]:=chr(32);
   nm:=(DirInfo.Name);
   for l:=1 to 12 do write(ix1file,nm[l]);
   long:=filepos(grpfile);
   writeln(long);
   write(ix2file,long);
   Assign(sprfile,nm);
   reset(sprfile);
   x:=round(sqrt(filesize(sprfile)));
   d:=chr(x);
   write(ix1file,d);
   while not eof(sprfile) do
   begin
   read (sprfile,x);
   d:=chr(x);
   write (grpfile,d);
   end;
   close(sprfile);
   FindNext(DirInfo);
 end;
 d:='L';
 write(ix1file,d);
 d:='E';
 write(ix1file,d);
 d:='U';
 write(ix1file,d);
 d:='C';
 write(ix1file,d);
 d:='O';
 write(ix1file,d);
 d:='P';
 write(ix1file,d);
 d:='L';
 write(ix1file,d);
 d:='A';
 write(ix1file,d);
 d:='S';
 write(ix1file,d);
 d:='T';
 write(ix1file,d);
 d:=' ';
 write(ix1file,d);
 d:='!';
 write(ix1file,d);
 d:='!';
 write(ix1file,d);
 close(grpfile);
 close(ix1file);
 close(ix2file);
writeln ('Ok!');
end.
