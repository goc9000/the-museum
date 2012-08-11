{************************************************}
{                                                }
{   BGI Demo Program                             }
{   Copyright (c) 1992 by Borland International  }
{                                                }
{************************************************}

unit BGIDriv;
interface
procedure EgaVgaDriverProc;
implementation
procedure EgaVgaDriverProc; external;
{$L EGAVGA.OBJ }
end.
