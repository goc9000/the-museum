uses TextFont,Dos,Crt;
begin
if ParamCount=0 then
begin
writeln('Schimba fontul - programat de D.C.M. Soft');
writeln('Sintaxa: SCHIMBFN (numefis.fnt)');
writeln;
halt;
end;
setfont(ParamStr(1));
end.