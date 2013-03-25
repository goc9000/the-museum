{$R-,Q-,S-,D-}
Unit XVGA;

Interface

Const
	Scaler		= 16;

Type
	PTable	= ^TTable;
	TTable	= Array[0..16383] Of Integer;

	PSortRec32	= ^TSortRec32;
	TSortRec32	= Record
		ID			: Word;
		SortValue	: LongInt;
	End;

	TRGB	= Array[0..767] Of Byte;

Type
	TLine32	= Record
		X1,Y1	: Integer;
		X2,Y2	: Integer;
		IX,GX	: LongInt;
	End;

	TFace	= Array[1..7] Of Word;
		{ 1..3 = Point indices
		  4..6 = Normal indices
		  7    = Base color }

Var
	_S,_C		: PTable;
		{ Ranges from -256 to +256 }
	TableMask	: Word;
		{ if you calculate _S^[Index], then use
			Index:=(Index And TableMask) before to make sure that Index is
		  in a legal range }

Type
	PPoint32	= ^TPoint32;
	TPoint32	= Array[1..3] Of LongInt;

	PPointArray32	= ^TPointArray32;
	TPointArray32	= Array[1..5400] Of TPoint32;

	PSortArray32	= ^TSortArray32;
	TSortArray32	= Array[1..10240] Of TSortRec32;

Function Visible(X1,Y1,X2,Y2,X3,Y3 : Integer) : Integer;
	{ Returns >=0 when visible, face should be declare in a clock-wise
	  direction when viewed from visible side }
Procedure Normal(X1,Y1,Z1,X2,Y2,Z2,X3,Y3,Z3 : Integer; Var X,Y,Z : Integer);
	{ Calculates the normal vector for the plane }
Function NormalR(X1,Y1,Z1,X2,Y2,Z2,X3,Y3,Z3 : Integer; Var X,Y,Z : Integer) : Real;
	{ Returns the same vector as Normal (uses Normal), but returns also
	  a normalized z-value. The normalized z-valus ranges from -1 to 1 }

Procedure XTetra(X1,Y1,X2,Y2,X3,Y3 : Integer; Color : Byte; VideoSeg : Word);
Procedure XTetraClip(X1,Y1,X2,Y2,X3,Y3,ClipX1,ClipY1,ClipX2,ClipY2 : Integer;
	Color : Byte; VideoSeg : Word);
Procedure XTetraGlenzADD(X1,Y1,X2,Y2,X3,Y3 : Integer; Color : Byte; VideoSeg : Word);
Procedure XTetraGlenzADDClip(X1,Y1,X2,Y2,X3,Y3,ClipX1,ClipY1,ClipX2,ClipY2 : Integer;
	Color : Byte; VideoSeg : Word);
Procedure XTetraGlenzSUB(X1,Y1,X2,Y2,X3,Y3 : Integer; Color : Byte; VideoSeg : Word);
Procedure XTetraGlenzSUBClip(X1,Y1,X2,Y2,X3,Y3,ClipX1,ClipY1,ClipX2,ClipY2 : Integer;
	Color : Byte; VideoSeg : Word);
Procedure XTetraGlenzOR(X1,Y1,X2,Y2,X3,Y3 : Integer; Color : Byte; VideoSeg : Word);
Procedure XTetraGlenzORClip(X1,Y1,X2,Y2,X3,Y3,ClipX1,ClipY1,ClipX2,ClipY2 : Integer;
	Color : Byte; VideoSeg : Word);
Procedure XTetraGlenzAND(X1,Y1,X2,Y2,X3,Y3 : Integer; Color : Byte; VideoSeg : Word);
Procedure XTetraGlenzANDClip(X1,Y1,X2,Y2,X3,Y3,ClipX1,ClipY1,ClipX2,ClipY2 : Integer;
	Color : Byte; VideoSeg : Word);
Procedure XTetraGlenzXOR(X1,Y1,X2,Y2,X3,Y3 : Integer; Color : Byte; VideoSeg : Word);
Procedure XTetraGlenzXORClip(X1,Y1,X2,Y2,X3,Y3,ClipX1,ClipY1,ClipX2,ClipY2 : Integer;
	Color : Byte; VideoSeg : Word);
Procedure XTetraCopy(X1,Y1,X2,Y2,X3,Y3 : Integer; FromSeg,VideoSeg : Word);
Procedure XTetraCopyClip(X1,Y1,X2,Y2,X3,Y3,ClipX1,ClipY1,ClipX2,ClipY2 : Integer;
	FromSeg,VideoSeg : Word);

	{ The differences between the XTetra...( and the XTetra...Clip( functions
	  is that the XTetra...( clips to the screen edges, but XTetra...Clip(
	  clips to the coordinates given. The XTetra...( is faster if the screen
	  edge is to be used }

Procedure AsmRotate32(Var SourcePoints,DestPoints : Array Of TPoint32;
	PointCount : Word; RX,RY,RZ	: Integer);
Procedure MovePoints32(Var Points : Array Of TPoint32; PointCount : Word;
	_DX,_DY,_DZ : LongInt);
	{ Moves all the points in the array accordingly to the delta-values }
Procedure AddPerspective32(Var Points : Array Of TPoint32; PointCount : Word;
	ShiftFactor : Byte; ZDelta : LongInt);
	{ Formulas used:
		NewX := (OldX SHL ShiftFactor) Div (OldZ+ZDelta);
		NewY := (OldY SHL ShiftFactor) Div (OldZ+ZDelta); }

Procedure InitSinCos(BitSize : Byte);
	{ The number of values in the arrays are:
		1 SHL BitSize }
Procedure VRet;
Procedure TestCPU;
Procedure TestCPULine;
Procedure ClearFake(FakeSeg : Word);
Procedure ClearFakePart(FakeSeg : Word; X1,Y1,X2,Y2 : Word);
Procedure ClearFake2Color(FakeSeg : Word; Color : Byte);
Procedure ClearFakePart2Color(FakeSeg : Word; X1,Y1,X2,Y2 : Word; Color : Byte);
Procedure ShowFake(FakeSeg : Word);
Procedure ShowFakePart(FakeSeg : Word; X1,Y1,X2,Y2 : Word);
Procedure QSort32(Var SortList : Array Of TSortRec32; SortCount : Word);

Procedure XQuadra(X1,Y1,X2,Y2,X3,Y3,X4,Y4 : Integer; Color : Byte; VideoSeg : Word);
Procedure XQuadraClip(X1,Y1,X2,Y2,X3,Y3,X4,Y4,ClipX1,ClipY1,ClipX2,ClipY2 : Integer;
	Color : Byte; VideoSeg : Word);
Procedure XQuadraCopy(X1,Y1,X2,Y2,X3,Y3,X4,Y4 : Integer; FromSeg,VideoSeg : Word);
Procedure XQuadraCopyClip(X1,Y1,X2,Y2,X3,Y3,X4,Y4,ClipX1,ClipY1,ClipX2,ClipY2 : Integer;
	FromSeg,VideoSeg : Word);
Procedure XQuadraGlenzADD(X1,Y1,X2,Y2,X3,Y3,X4,Y4 : Integer; Color : Byte;
	VideoSeg : Word);
Procedure XQuadraGlenzADDClip(X1,Y1,X2,Y2,X3,Y3,X4,Y4,ClipX1,ClipY1,ClipX2,ClipY2 : Integer;
	Color : Byte; VideoSeg : Word);
Procedure XQuadraGlenzSUB(X1,Y1,X2,Y2,X3,Y3,X4,Y4 : Integer; Color : Byte;
	VideoSeg : Word);
Procedure XQuadraGlenzSUBClip(X1,Y1,X2,Y2,X3,Y3,X4,Y4,ClipX1,ClipY1,ClipX2,ClipY2 : Integer;
	Color : Byte; VideoSeg : Word);
Procedure XQuadraGlenzOR(X1,Y1,X2,Y2,X3,Y3,X4,Y4 : Integer; Color : Byte;
	VideoSeg : Word);
Procedure XQuadraGlenzORClip(X1,Y1,X2,Y2,X3,Y3,X4,Y4,ClipX1,ClipY1,ClipX2,ClipY2 : Integer;
	Color : Byte; VideoSeg : Word);
Procedure XQuadraGlenzAND(X1,Y1,X2,Y2,X3,Y3,X4,Y4 : Integer; Color : Byte;
	VideoSeg : Word);
Procedure XQuadraGlenzANDClip(X1,Y1,X2,Y2,X3,Y3,X4,Y4,ClipX1,ClipY1,ClipX2,ClipY2 : Integer;
	Color : Byte; VideoSeg : Word);
Procedure XQuadraGlenzXOR(X1,Y1,X2,Y2,X3,Y3,X4,Y4 : Integer; Color : Byte;
	VideoSeg : Word);
Procedure XQuadraGlenzXORClip(X1,Y1,X2,Y2,X3,Y3,X4,Y4,ClipX1,ClipY1,ClipX2,ClipY2 : Integer;
	Color : Byte; VideoSeg : Word);

Procedure XPlot(X,Y : Integer; Color : Byte; VideoSeg : Word);
Procedure XPlotClip(X,Y,ClipX1,ClipY1,ClipX2,ClipY2 : Integer; Color : Byte; VideoSeg : Word);
Procedure XPlotXOR(X,Y : Integer; Color : Byte; VideoSeg : Word);
Procedure XPlotXORClip(X,Y,ClipX1,ClipY1,ClipX2,ClipY2 : Integer; Color : Byte; VideoSeg : Word);

Procedure XVZoomLine(X,Y1,Y2 : Integer; Texture : PChar; TextureHeight,VideoSeg : Word);
Procedure XVZoomLineClip(X,Y1,Y2,ClipY1,ClipY2 : Integer; Texture : PChar; TextureHeight,VideoSeg : Word);
Procedure XHZoomLine(Y,X1,X2 : Integer; Texture : PChar; TextureWidth,VideoSeg : Word);
Procedure XHZoomLineClip(Y,X1,X2,ClipX1,ClipX2 : Integer; Texture : PChar; TextureWidth,VideoSeg : Word);

Procedure XTetraTexture320(X1,Y1,X2,Y2,X3,Y3,TX1,TY1,TX2,TY2,TX3,TY3 : Integer;
	Texture : PChar; VideoSeg : Word);
Procedure XTetraTexture320Clip(X1,Y1,X2,Y2,X3,Y3,TX1,TY1,TX2,TY2,TX3,TY3,ClipX1,ClipY1,ClipX2,ClipY2 : Integer;
	Texture : PChar; VideoSeg : Word);
Procedure XTetraTexture320SpaceCutZBufferClip(X1,Y1,Z1,X2,Y2,Z2,X3,Y3,Z3,TX1,TY1,TX2,TY2,TX3,TY3,
	ClipX1,ClipY1,ClipX2,ClipY2 : Integer;
	Texture : PChar; ZSeg,VideoSeg : Word);

Procedure XTetraGourad(X1,Y1,C1,X2,Y2,C2,X3,Y3,C3 : Integer; VideoSeg : Word);
Procedure XTetraGouradClip(X1,Y1,C1,X2,Y2,C2,X3,Y3,C3,ClipX1,ClipY1,ClipX2,ClipY2 : Integer; VideoSeg : Word);

Procedure XTetraGouradSpaceCut(X1,Y1,C1,X2,Y2,C2,X3,Y3,C3 : Integer; VideoSeg : Word; CutMask : Byte);
Procedure XTetraGouradSpaceCutClip(X1,Y1,C1,X2,Y2,C2,X3,Y3,C3,ClipX1,ClipY1,ClipX2,ClipY2 : Integer;
	VideoSeg : Word; CutMask : Byte);
Procedure XTetraGouradSpaceCutZBuffer(X1,Y1,Z1,C1,X2,Y2,Z2,C2,X3,Y3,Z3,C3 : Integer;
	VideoSeg,ZSeg : Word);
Procedure XTetraGouradGlenzADDSpaceCutZBuffer(X1,Y1,Z1,C1,X2,Y2,Z2,C2,X3,Y3,Z3,C3 : Integer;
	VideoSeg,ZSeg : Word);
Procedure XTetraGouradGlenzORSpaceCutZBuffer(X1,Y1,Z1,C1,X2,Y2,Z2,C2,X3,Y3,Z3,C3 : Integer;
	VideoSeg,ZSeg : Word);
Procedure XTetraGouradSpaceCutZBufferClip(X1,Y1,Z1,C1,X2,Y2,Z2,C2,X3,Y3,Z3,C3,ClipX1,ClipY1,ClipX2,ClipY2 : Integer;
	VideoSeg,ZSeg : Word);
Procedure XTetraGouradGlenzADDSpaceCutZBufferClip(X1,Y1,Z1,C1,X2,Y2,Z2,C2,X3,Y3,Z3,C3,ClipX1,ClipY1,ClipX2,ClipY2 : Integer;
	VideoSeg,ZSeg : Word);
Procedure XTetraGouradGlenzORSpaceCutZBufferClip(X1,Y1,Z1,C1,X2,Y2,Z2,C2,X3,Y3,Z3,C3,ClipX1,ClipY1,ClipX2,ClipY2 : Integer;
	VideoSeg,ZSeg : Word);

Procedure XVGourad(X,Y1,Y2 : Integer; C1,C2 : Byte; VideoSeg : Word);
Procedure XHGourad(Y,X1,X2 : Integer; C1,C2 : Byte; VideoSeg : Word);
Procedure XVWideGourad(X1,Y1,X2,Y2 : Integer; C1,C2 : Byte; VideoSeg : Word);

Procedure XHLine(Y,X1,X2 : Integer; Color : Byte; VideoSeg : Word);
Procedure XVLine(X,Y1,Y2 : Integer; Color : Byte; VideoSeg : Word);

Procedure XLine(X1,Y1,X2,Y2 : Integer; Color : Byte; VideoSeg : Word);
Procedure XLineClip(X1,Y1,X2,Y2,ClipX1,ClipY1,ClipX2,ClipY2 : Integer; Color : Byte; VideoSeg : Word);

Procedure XLineGlenzXOR(X1,Y1,X2,Y2 : Integer; Color : Byte; VideoSeg : Word);
Procedure XLineGlenzXORClip(X1,Y1,X2,Y2,ClipX1,ClipY1,ClipX2,ClipY2 : Integer; Color : Byte; VideoSeg : Word);

Procedure XLineGlenzSUB(X1,Y1,X2,Y2 : Integer; Color : Byte; VideoSeg : Word);
Procedure XLineGlenzSUBClip(X1,Y1,X2,Y2,ClipX1,ClipY1,ClipX2,ClipY2 : Integer; Color : Byte; VideoSeg : Word);

Procedure XBox(X1,Y1,X2,Y2 : Integer; Color : Byte; VideoSeg : Word);
Procedure XBoxClip(X1,Y1,X2,Y2,ClipX1,ClipY1,ClipX2,ClipY2 : Integer; Color : Byte; VideoSeg : Word);

Procedure XBoxGlenzXOR(X1,Y1,X2,Y2 : Integer; Color : Byte; VideoSeg : Word);
Procedure XBoxGlenzXORClip(X1,Y1,X2,Y2,ClipX1,ClipY1,ClipX2,ClipY2 : Integer; Color : Byte; VideoSeg : Word);

Procedure XTetraLine(X1,Y1,X2,Y2,X3,Y3 : Integer; Color : Byte; VideoSeg : Word);
Procedure XQuadraLine(X1,Y1,X2,Y2,X3,Y3,X4,Y4 : Integer; Color : Byte; VideoSeg : Word);
Procedure XTetraLineClip(X1,Y1,X2,Y2,X3,Y3,ClipX1,ClipY1,ClipX2,ClipY2 : Integer; Color : Byte; VideoSeg : Word);
Procedure XQuadraLineClip(X1,Y1,X2,Y2,X3,Y3,X4,Y4,ClipX1,ClipY1,ClipX2,ClipY2 : Integer; Color : Byte; VideoSeg : Word);

Procedure XRectangle(X1,Y1,X2,Y2 : Integer; Color : Byte; VideoSeg : Word);
Procedure XRectangleGlenzXOR(X1,Y1,X2,Y2 : Integer; Color : Byte; VideoSeg : Word);
Procedure XRectangleClip(X1,Y1,X2,Y2,ClipX1,ClipY1,ClipX2,ClipY2 : Integer; Color : Byte; VideoSeg : Word);
Procedure XRectangleGlenzXORClip(X1,Y1,X2,Y2,ClipX1,ClipY1,ClipX2,ClipY2 : Integer; Color : Byte; VideoSeg : Word);

Function XGetPixel(X,Y : Integer; VideoSeg : Word) : Byte;
Function XGetPixelClip(X,Y,ClipX1,ClipY1,ClipX2,ClipY2 : Integer; VideoSeg : Word) : Byte;
	{ Returns 0 outside }

Procedure XMode(XVGAMode : Boolean);
Procedure XSetRGB(Index,R,G,B :	Byte);
Procedure XSetRGBMany(StartIndex : Byte; ColorCount : Word; Var	RGBData);
Procedure XGetRGB(Index : Byte; Var R,G,B : Byte);
Procedure XGetRGBMany(StartIndex : Byte; ColorCount : Word; Var RGBData);

Function XLoadPCX320x200SetPalette(FileName : String; VideoSeg : Word) : Integer;
Function XLoadPCX(FileName : String; Var Width,Height : Word; Var RGB; VideoSeg : Word) : Integer;
{ Returns:
	0 = Success
	1 = Unable to find/open file
	2 = Unable to read header from file
	3 = Invalid format (color/size/format/... (image too large))
	4 = Unable to read image
	5 = Not enough memory for buffers
	6 = Unable to read palette (image should be ok though)
}

Procedure XScaleBitMap(X1,Y1,X2,Y2 : Integer;
	Var BitMap; BitMapWidth,BitMapHeight : Word; VideoSeg : Word);
Procedure XScaleBitMapClip(X1,Y1,X2,Y2,ClipX1,ClipY1,ClipX2,ClipY2 : Integer;
	Var BitMap; BitMapWidth,BitMapHeight : Word; VideoSeg : Word);

Procedure XScaleTransparentBitMap(X1,Y1,X2,Y2 : Integer;
	Var BitMap; BitMapWidth,BitMapHeight : Word; TranspColor : Byte; VideoSeg : Word);
Procedure XScaleTransparentBitMapClip(X1,Y1,X2,Y2,ClipX1,ClipY1,ClipX2,ClipY2 : Integer;
	Var BitMap; BitMapWidth,BitMapHeight : Word; TranspColor : Byte; VideoSeg : Word);

Procedure XPutBitMap(X,Y,Width,Height : Integer; BitMap : PChar; VideoSeg : Word);
Procedure XPutBitMapClip(X,Y,Width,Height,ClipX1,ClipY1,ClipX2,ClipY2 : Integer;
	BitMap : PChar; VideoSeg : Word);

Procedure XPutTransparentBitMap(X,Y,Width,Height : Integer; BitMap : PChar;
	TranspColor : Byte; VideoSeg : Word);
Procedure XPutTransparentBitMapClip(X,Y,Width,Height,ClipX1,ClipY1,ClipX2,
	ClipY2 : Integer; BitMap : PChar; TranspColor : Byte; VideoSeg : Word);

Procedure XPutBitMapTranslate(X,Y,Width,Height : Integer; BitMap : PChar;
	VideoSeg : Word; Var Translate);
Procedure XPutBitMapClipTranslate(X,Y,Width,Height,ClipX1,ClipY1,ClipX2,ClipY2 : Integer;
	BitMap : PChar; VideoSeg : Word; Var Translate);

Procedure XPutTransparentBitMapTranslate(X,Y,Width,Height : Integer; BitMap : PChar;
	TranspColor : Byte; VideoSeg : Word; Var Translate);
Procedure XPutTransparentBitMapClipTranslate(X,Y,Width,Height,ClipX1,ClipY1,ClipX2,
	ClipY2 : Integer; BitMap : PChar; TranspColor : Byte; VideoSeg : Word;
	Var Translate);

Procedure XGetBitMap(X1,Y1,X2,Y2 : Integer; Var BitMap; VideoSeg : Word);

Procedure XFillPoly(Var Lines : Array Of TLine32; LineCount : Word; Color : Byte; VideoSeg : Word);
Procedure XSirds(SourceSeg,DestSeg : Word; Levels : Byte; Color1,Color2 : Byte);

Implementation

Uses
	Dos;

Procedure XVZoomLine(X,Y1,Y2 : Integer; Texture : PChar; TextureHeight,VideoSeg : Word); Assembler;
Var
	Y		: Integer;
	DY		: LongInt;
Asm
			CLD
			PUSH	DS
			MOV		AX,[X]
			CMP		AX,0
			JL		@@EXIT
			CMP		AX,319
			JG		@@EXIT

			MOV		AX,[Y1]
			CMP		AX,[Y2]
			JE		@@ISEQUAL
			JL		@@OK1
			XCHG	AX,[Y2]
			MOV		[Y1],AX
			DEC		[TextureHeight]
@@OK1:
	DB $66;	DB $0F, $BF, $46, OFFSET TextureHeight
	DB $66;	SHL		AX,Scaler

	DB $66;	CWD
	DB $66;	DB $0F, $BF, $5E, OFFSET Y2
	DB $66;	DB $0F, $BF, $4E, OFFSET Y1
	DB $66;	SUB		BX,CX
	DB $66;	DIV		BX
			JMP		@@DOIT
@@ISEQUAL:
	DB $66;	XOR		AX,AX
@@DOIT:
	DB $66;	MOV		[WORD PTR DY],AX

			MOV		AX,[Y1]
			MOV		[Y],AX
			MOV		ES,[VideoSeg]
			LDS		SI,[DWORD PTR TEXTURE]
			CMP		AX,0
			JGE		@@ONSCREEN
			XOR		AX,AX
@@ONSCREEN:
			CMP		AX,199
			JG		@@EXIT
			MOV		DI,AX
			SHL		DI,6
			SHL		AX,8
			ADD		DI,AX
			ADD		DI,[X]
	DB $66;	XOR		CX,CX
@@LOOP1:
			MOV		AX,[Y]
			CMP		AX,0
			JL		@@NEXTLINE
			CMP		AX,199
			JG		@@EXIT
			CMP		AX,[Y2]
			JG		@@EXIT

	DB $66;	MOV		BX,CX
	DB $66;	SHR		BX,Scaler
			MOV		AL,[DS:SI+BX]
			MOV		[ES:DI],AL
			ADD		DI,320
@@NEXTLINE:
			INC		[Y]
	DB $66;	ADD		CX,[WORD PTR DY]
			JMP		@@LOOP1
@@EXIT:
			POP		DS
End;

Procedure XVZoomLineClip(X,Y1,Y2,ClipY1,ClipY2 : Integer; Texture : PChar; TextureHeight,VideoSeg : Word); Assembler;
Var
	Y		: Integer;
	DY		: LongInt;
Asm
			CLD
			PUSH	DS
			MOV		AX,[X]
			CMP		AX,0
			JL		@@EXIT
			CMP		AX,319
			JG		@@EXIT

			MOV		AX,[Y1]
			CMP		AX,[Y2]
			JE		@@ISEQUAL
			JL		@@OK1
			XCHG	AX,[Y2]
			MOV		[Y1],AX
			DEC		[TextureHeight]
@@OK1:
	DB $66;	DB $0F, $BF, $46, OFFSET TextureHeight
	DB $66;	SHL		AX,Scaler

	DB $66;	CWD
	DB $66;	DB $0F, $BF, $5E, OFFSET Y2
	DB $66;	DB $0F, $BF, $4E, OFFSET Y1
	DB $66;	SUB		BX,CX
	DB $66;	DIV		BX
			JMP		@@DOIT
@@ISEQUAL:
	DB $66;	XOR		AX,AX
@@DOIT:
	DB $66;	MOV		[WORD PTR DY],AX

			MOV		AX,[Y1]
			MOV		[Y],AX
			MOV		ES,[VideoSeg]
			LDS		SI,[DWORD PTR TEXTURE]
			CMP		AX,[ClipY1]
			JGE		@@ONSCREEN
			MOV		AX,[ClipY1]
@@ONSCREEN:
			CMP		AX,[ClipY2]
			JG		@@EXIT
			MOV		DI,AX
			SHL		DI,6
			SHL		AX,8
			ADD		DI,AX
			ADD		DI,[X]
	DB $66;	XOR		CX,CX
@@LOOP1:
			MOV		AX,[Y]
			CMP		AX,[ClipY1]
			JL		@@NEXTLINE
			CMP		AX,[ClipY2]
			JG		@@EXIT
			CMP		AX,[Y2]
			JG		@@EXIT

	DB $66;	MOV		BX,CX
	DB $66;	SHR		BX,Scaler
			MOV		AL,[DS:SI+BX]
			MOV		[ES:DI],AL
			ADD		DI,320
@@NEXTLINE:
			INC		[Y]
	DB $66;	ADD		CX,[WORD PTR DY]
			JMP		@@LOOP1
@@EXIT:
			POP		DS
End;

Procedure XHZoomLine(Y,X1,X2 : Integer; Texture : PChar; TextureWidth,VideoSeg : Word); Assembler;
Var
	X		: Integer;
	_DX		: LongInt;
Asm
			CLD
			PUSH	DS
			MOV		AX,[Y]
			CMP		AX,0
			JL		@@EXIT
			CMP		AX,199
			JG		@@EXIT

			MOV		AX,[X1]
			CMP		AX,[X2]
			JE		@@ISEQUAL
			JL		@@OK1
			XCHG	AX,[X2]
			MOV		[X1],AX
			DEC		[TextureWidth]
@@OK1:
	DB $66;	DB $0F, $BF, $46, OFFSET TextureWidth
	DB $66;	SHL		AX,Scaler

	DB $66;	CWD
	DB $66;	DB $0F, $BF, $5E, OFFSET X2
	DB $66;	DB $0F, $BF, $4E, OFFSET X1
	DB $66;	SUB		BX,CX
	DB $66;	DIV		BX
			JMP		@@DOIT
@@ISEQUAL:
	DB $66;	XOR		AX,AX
@@DOIT:
	DB $66;	MOV		[WORD PTR _DX],AX

			MOV		AX,[X1]
			MOV		[X],AX
			MOV		ES,[VideoSeg]
			LDS		SI,[DWORD PTR TEXTURE]
			CMP		AX,0
			JGE		@@ONSCREEN
			XOR		AX,AX
@@ONSCREEN:
			CMP		AX,319
			JG		@@EXIT
			MOV		BX,[Y]
			MOV		DI,BX
			SHL		DI,6
			SHL		BX,8
			ADD		DI,BX
			ADD		DI,AX
	DB $66;	XOR		CX,CX
@@LOOP1:
			MOV		AX,[X]
			CMP		AX,0
			JL		@@NEXTLINE
			CMP		AX,319
			JG		@@EXIT
			CMP		AX,[X2]
			JG		@@EXIT

	DB $66;	MOV		BX,CX
	DB $66;	SHR		BX,Scaler
			MOV		AL,[DS:SI+BX]
			MOV		[ES:DI],AL
			INC		DI
@@NEXTLINE:
			INC		[X]
	DB $66;	ADD		CX,[WORD PTR _DX]
			JMP		@@LOOP1
@@EXIT:
			POP		DS
End;

Procedure XHZoomLineClip(Y,X1,X2,ClipX1,ClipX2 : Integer; Texture : PChar; TextureWidth,VideoSeg : Word); Assembler;
Var
	X		: Integer;
	_DX		: LongInt;
Asm
			CLD
			PUSH	DS
			MOV		AX,[Y]
			CMP		AX,0
			JL		@@EXIT
			CMP		AX,199
			JG		@@EXIT

			MOV		AX,[X1]
			CMP		AX,[X2]
			JE		@@ISEQUAL
			JL		@@OK1
			XCHG	AX,[X2]
			MOV		[X1],AX
			DEC		[TextureWidth]
@@OK1:
	DB $66;	DB $0F, $BF, $46, OFFSET TextureWidth
	DB $66;	SHL		AX,Scaler

	DB $66;	CWD
	DB $66;	DB $0F, $BF, $5E, OFFSET X2
	DB $66;	DB $0F, $BF, $4E, OFFSET X1
	DB $66;	SUB		BX,CX
	DB $66;	DIV		BX
			JMP		@@DOIT
@@ISEQUAL:
	DB $66;	XOR		AX,AX
@@DOIT:
	DB $66;	MOV		[WORD PTR _DX],AX

			MOV		AX,[X1]
			MOV		[X],AX
			MOV		ES,[VideoSeg]
			LDS		SI,[DWORD PTR TEXTURE]
			CMP		AX,[ClipX1]
			JGE		@@ONSCREEN
			MOV		AX,[ClipX1]
@@ONSCREEN:
			CMP		AX,[ClipX2]
			JG		@@EXIT
			MOV		BX,[Y]
			MOV		DI,BX
			SHL		DI,6
			SHL		BX,8
			ADD		DI,BX
			ADD		DI,AX
	DB $66;	XOR		CX,CX
@@LOOP1:
			MOV		AX,[X]
			CMP		AX,[ClipX1]
			JL		@@NEXTLINE
			CMP		AX,[ClipX2]
			JG		@@EXIT
			CMP		AX,[X2]
			JG		@@EXIT

	DB $66;	MOV		BX,CX
	DB $66;	SHR		BX,Scaler
			MOV		AL,[DS:SI+BX]
			MOV		[ES:DI],AL
			INC		DI
@@NEXTLINE:
			INC		[X]
	DB $66;	ADD		CX,[WORD PTR _DX]
			JMP		@@LOOP1
@@EXIT:
			POP		DS
End;

Procedure XTetra(X1,Y1,X2,Y2,X3,Y3 : Integer; Color : Byte; VideoSeg : Word); Assembler;
Var
	XX1		: LongInt;
	XX2		: LongInt;
	XX3		: LongInt;
	DX1		: LongInt;
	DX2		: LongInt;
	DX3		: LongInt;
	Y		: Integer;
	CX1,CX2	: LongInt;
	CDWord	: LongInt;
Asm
			CLD
			MOV		AL,[Color]
			MOV		AH,AL
			MOV		BX,AX
	DB $66;	SHL		AX,16
			MOV		AX,BX
	DB $66;	MOV		[WORD PTR CDWord],AX

			MOV		AX,[X1]				{ Initialize registers	}
			MOV		BX,[Y1]
			MOV		CX,[X2]
			MOV		DX,[Y2]
			MOV		SI,[X3]
			MOV		DI,[Y3]

			CMP		BX,DX				{ Calculate min of y1/y2 }
			JLE		@@OK_FIRST_1
			XCHG	AX,CX
			XCHG	BX,DX
@@OK_FIRST_1:
			CMP		BX,DI				{ Calculate min of y2/y3 }
			JLE		@@OK_FIRST_2
			XCHG	AX,SI
			XCHG	BX,DI
@@OK_FIRST_2:
			CMP		DX,DI				{ Calculate min of y1/y3 }
			JLE		@@OK_FIRST_3
			XCHG	CX,SI
			XCHG	DX,DI
@@OK_FIRST_3:
			MOV		[X1],AX				{ Store back in variables }
			MOV		[Y1],BX
			MOV		[X2],CX
			MOV		[Y2],DX
			MOV		[X3],SI
			MOV		[Y3],DI

			CMP		BX,DI
			JNE		@@NONFLAT

			TEST	BX,BX
			JL		@@ALLLINES
			CMP		BX,199
			JG		@@ALLLINES
			MOV		DI,BX
			SHL		DI,6
			SHL		BX,8
			ADD		DI,BX
			MOV		ES,[VideoSeg]
			MOV		AX,[X1]
			CMP		AX,[X2]
			JLE		@@FL1
			MOV		AX,[X2]
@@FL1:
			CMP		AX,[X3]
			JLE		@@FL2
			MOV		AX,[X3]
@@FL2:
			MOV		BX,[X1]
			CMP		BX,[X2]
			JGE		@@FL3
			MOV		BX,[X2]
@@FL3:
			CMP		BX,[X3]
			JGE		@@FL4
			MOV		BX,[X3]
@@FL4:
			TEST	AX,AX
			JGE		@@FL5
			TEST	BX,BX
			JGE		@@FL5
			JMP		@@ALLLINES
@@FL5:
			CMP		AX,319
			JLE		@@FL6
			CMP		BX,319
			JLE		@@FL6
			JMP		@@ALLLINES
@@FL6:
			TEST	AX,AX
			JGE		@@FL7
			SUB		AX,AX
@@FL7:
			CMP		BX,319
			JLE		@@FL8
			MOV		BX,319
@@FL8:
			ADD		DI,AX
			MOV		CX,BX
			SUB		CX,AX
			INC		CX
			CLD
	DB $66;	MOV		AX,[WORD PTR CDWord]
			JCXZ	@@FL10
			TEST	DI,$0001
			JZ		@@NOTONE_1
			MOV		[ES:DI],AL
			INC		DI
			DEC		CX
			JZ		@@FL10
@@NOTONE_1:
			CMP		CX,2
			JB		@@NOTTWO_1
			TEST	DI,$0002
			JZ		@@NOTTWO_1
			MOV		[ES:DI],AX
			ADD		DI,2
			SUB		CX,2
			JZ		@@FL10
@@NOTTWO_1:
			SHR		CX,1
			DB $0F, $92, $C3
			SHR		CX,1
	DB $66;	REP		STOSW
			JNC		@@FL9
			MOV		[ES:DI],AX
			ADD		DI,2
@@FL9:
			OR		BL,BL
			JZ		@@FL10
			MOV		[ES:DI],AL
			INC		DI
@@FL10:
			JMP		@@ALLLINES
@@NONFLAT:
			DB $66, $0F, $BF, $46, OFFSET X1	{ MOVSX EAX,[X1] }
			DB $66, $0F, $BF, $5E, OFFSET X2	{ MOVSX EBX,[X2] }
			DB $66, $0F, $BF, $4E, OFFSET X3	{ MOVSX ECX,[X3] }

	DB $66;	SAL		AX,Scaler
	DB $66;	SAL		BX,Scaler
	DB $66;	SAL		CX,Scaler

	DB $66;	MOV		[WORD PTR XX1],AX
	DB $66;	MOV		[WORD PTR XX2],BX
	DB $66;	MOV		[WORD PTR XX3],CX

			MOV		AX,[Y1]
			CMP		AX,[Y2]
			JE		@@EQ1

	DB $66;	MOV		AX,[WORD PTR XX2]
	DB $66;	MOV		BX,[WORD PTR XX1]
	DB $66;	SUB		AX,BX

	DB $66;	CWD
			MOV     BX,[Y2]
			SUB		BX,[Y1]
			DB $66, $0F, $BF, $CB				{ MOVSX ECX,BX }
	DB $66;	IDIV	CX
	DB $66;	MOV		[WORD PTR DX1],AX
			JMP		@@DO2
@@EQ1:
	DB $66;	XOR		AX,AX
	DB $66;	MOV		[WORD PTR DX1],AX
@@DO2:
			MOV		AX,[Y2]
			CMP		AX,[Y3]
			JE		@@EQ2

	DB $66;	MOV		AX,[WORD PTR XX3]
	DB $66;	MOV		BX,[WORD PTR XX2]
	DB $66;	SUB		AX,BX

	DB $66;	CWD
			MOV     BX,[Y3]
			SUB		BX,[Y2]
			DB $66, $0F, $BF, $CB				{ MOVSX ECX,BX }
	DB $66;	IDIV	CX
	DB $66;	MOV		[WORD PTR DX2],AX
			JMP		@@DO3
@@EQ2:
	DB $66;	XOR		AX,AX
	DB $66;	MOV		[WORD PTR DX2],AX
@@DO3:
			MOV		AX,[Y3]
			CMP		AX,[Y1]
			JE		@@EQ3

	DB $66;	MOV		AX,[WORD PTR XX3]
	DB $66;	MOV		BX,[WORD PTR XX1]
	DB $66;	SUB		AX,BX

	DB $66;	CWD
			MOV     BX,[Y3]
			SUB		BX,[Y1]
			DB $66, $0F, $BF, $CB				{ MOVSX ECX,BX }
	DB $66;	IDIV	CX
	DB $66;	MOV		[WORD PTR DX3],AX
			JMP		@@DOFILL
@@EQ3:
	DB $66;	XOR		AX,AX
	DB $66;	MOV		[WORD PTR DX3],AX
@@DOFILL:
			MOV		AX,[Y1]
			CMP		AX,[Y2]
			JNE		@@DIFF

	DB $66;	MOV		AX,[WORD PTR XX1]
	DB $66;	MOV		BX,[WORD PTR XX2]
	DB $66;	MOV		CX,[WORD PTR DX1]
	DB $66;	MOV		DX,[WORD PTR DX1]
	DB $66;	CMP		CX,DX
			JGE		@@OK11
	DB $66;	XCHG	AX,BX
@@OK11:
	DB $66;	MOV		[WORD PTR CX1],AX
	DB $66;	MOV		[WORD PTR CX2],BX
			JMP		@@DONE
@@DIFF:
	DB $66;	MOV		AX,[WORD PTR XX1]
	DB $66;	MOV		[WORD PTR CX1],AX
	DB $66;	MOV		[WORD PTR CX2],AX
@@DONE:
			MOV		AX,[Y1]
			MOV		[Y],AX

			TEST	AX,AX
			JGE		@@OKLINE
			SUB		AX,AX
@@OKLINE:
			MOV		DI,AX
			SHL		AX,6
			SHL		DI,8
			ADD		DI,AX
@@GO_ON:
			MOV		ES,[VideoSeg]
			CLD
@@LINELOOP:
			MOV		AX,[Y]
			CMP		AX,0
			JL		@@NEXTLINE
			CMP		AX,199
			JG		@@ALLLINES

	DB $66;	MOV		AX,[WORD PTR CX1]
	DB $66;	MOV		BX,[WORD PTR CX2]
	DB $66;	CMP		AX,BX
	DB $66;	JLE		@@OK
	DB $66;	XCHG	AX,BX
@@OK:
	DB $66;	XOR		CX,CX
	DB $66;	SAR		AX,Scaler
	DB $66;	ADC		AX,CX
	DB $66;	SAR		BX,Scaler
	DB $66;	ADC		BX,CX
			CMP		AX,0
			JGE		@@OK1_1
			CMP		BX,0
			JGE		@@OK1_1
			JMP		@@NEXTLINE
@@OK1_1:
			CMP		AX,319
			JLE		@@OK1_2
			CMP		BX,319
			JLE		@@OK1_2
			JMP		@@NEXTLINE
@@OK1_2:
			TEST	AX,AX
			JGE		@@OK1
			SUB		AX,AX
@@OK1:
			CMP		AX,319
			JLE		@@OK2
			MOV		AX,319
@@OK2:
			TEST	BX,BX
			JGE		@@OK3
			SUB		BX,BX
@@OK3:
			CMP		BX,319
			JLE		@@OK4
			MOV		BX,319
@@OK4:
			MOV		CX,BX
			SUB		CX,AX
			INC		CX
			MOV		SI,DI
			ADD		DI,AX

	DB $66;	MOV		AX,[WORD PTR CDWord]
			JCXZ	@@SKIP2
			TEST	DI,$0001
			JZ		@@NOTONE
			MOV		[ES:DI],AL
			INC		DI
			DEC		CX
			JZ		@@SKIP2
@@NOTONE:
			CMP		CX,2
			JB		@@NOTTWO
			TEST	DI,$0002
			JZ		@@NOTTWO
			MOV		[ES:DI],AX
			ADD		DI,2
			SUB		CX,2
			JZ		@@SKIP2
@@NOTTWO:
			SHR		CX,1
			DB $0F, $92, $C3			{ SETC BL }
			SHR		CX,1
	DB $66;	REP		STOSW
			JNC		@@SKIP1
			MOV		[ES:DI],AX
			ADD		DI,2
@@SKIP1:
			OR		BL,BL
			JZ		@@SKIP2
			MOV		[ES:DI],AL
			INC		DI
@@SKIP2:
			MOV		DI,SI
@@NEXTLINE:
			MOV		AX,[Y]
			TEST	AX,AX
			JL		@@NEXTLINE_2
			ADD		DI,320
@@NEXTLINE_2:
			CMP		AX,[Y1]
			JL		@@LINE2
			CMP		AX,[Y2]
			JGE		@@LINE2
	DB $66;	MOV		AX,[WORD PTR DX1]
	DB $66;	ADD		[WORD PTR CX2],AX
@@LINE2:
			MOV		AX,[Y]
			CMP		AX,[Y1]
			JL		@@LINE3
			CMP		AX,[Y3]
			JGE		@@LINE3
	DB $66;	MOV		AX,[WORD PTR DX3]
	DB $66;	ADD		[WORD PTR CX1],AX
@@LINE3:
			MOV		AX,[Y]
			CMP		AX,[Y2]
			JL		@@EXIT
			CMP		AX,[Y3]
			JG		@@EXIT
	DB $66;	MOV		AX,[WORD PTR DX2]
	DB $66;	ADD		[WORD PTR CX2],AX
@@EXIT:
			INC		[Y]
			MOV		AX,[Y]
			CMP		AX,[Y3]
			JLE		@@LINELOOP
@@ALLLINES:
End;

Procedure XTetraClip(X1,Y1,X2,Y2,X3,Y3,ClipX1,ClipY1,ClipX2,ClipY2 : Integer;
	Color : Byte; VideoSeg : Word); Assembler;
Var
	XX1		: LongInt;
	XX2		: LongInt;
	XX3		: LongInt;
	DX1		: LongInt;
	DX2		: LongInt;
	DX3		: LongInt;
	Y		: Integer;
	CX1,CX2	: LongInt;
	CDWord	: LongInt;
Asm
			CLD
			MOV		AL,[Color]
			MOV		AH,AL
			MOV		BX,AX
	DB $66;	SHL		AX,16
			MOV		AX,BX
	DB $66;	MOV		[WORD PTR CDWord],AX

			MOV		AX,[X1]				{ Initialize registers	}
			MOV		BX,[Y1]
			MOV		CX,[X2]
			MOV		DX,[Y2]
			MOV		SI,[X3]
			MOV		DI,[Y3]

			CMP		BX,DX				{ Calculate min of y1/y2 }
			JLE		@@OK_FIRST_1
			XCHG	AX,CX
			XCHG	BX,DX
@@OK_FIRST_1:
			CMP		BX,DI				{ Calculate min of y2/y3 }
			JLE		@@OK_FIRST_2
			XCHG	AX,SI
			XCHG	BX,DI
@@OK_FIRST_2:
			CMP		DX,DI				{ Calculate min of y1/y3 }
			JLE		@@OK_FIRST_3
			XCHG	CX,SI
			XCHG	DX,DI
@@OK_FIRST_3:
			MOV		[X1],AX				{ Store back in variables }
			MOV		[Y1],BX
			MOV		[X2],CX
			MOV		[Y2],DX
			MOV		[X3],SI
			MOV		[Y3],DI

			CMP		BX,DI
			JNE		@@NONFLAT

			CMP		BX,[[ClipY1]]
			JL		@@ALLLINES
			CMP		BX,[ClipY2]
			JG		@@ALLLINES
			MOV		DI,BX
			SHL		DI,6
			SHL		BX,8
			ADD		DI,BX
			MOV		ES,[VideoSeg]
			MOV		AX,[X1]
			CMP		AX,[X2]
			JLE		@@FL1
			MOV		AX,[X2]
@@FL1:
			CMP		AX,[X3]
			JLE		@@FL2
			MOV		AX,[X3]
@@FL2:
			MOV		BX,[X1]
			CMP		BX,[X2]
			JGE		@@FL3
			MOV		BX,[X2]
@@FL3:
			CMP		BX,[X3]
			JGE		@@FL4
			MOV		BX,[X3]
@@FL4:
			CMP		AX,[ClipX1]
			JGE		@@FL5
			CMP		BX,[ClipX1]
			JGE		@@FL5
			JMP		@@ALLLINES
@@FL5:
			CMP		AX,[ClipX2]
			JLE		@@FL6
			CMP		BX,[ClipX2]
			JLE		@@FL6
			JMP		@@ALLLINES
@@FL6:
			CMP		AX,[ClipX1]
			JGE		@@FL7
			MOV		AX,[ClipX1]
@@FL7:
			CMP		BX,[ClipX2]
			JLE		@@FL8
			MOV		BX,[ClipX2]
@@FL8:
			ADD		DI,AX
			MOV		CX,BX
			SUB		CX,AX
			INC		CX
			CLD
	DB $66;	MOV		AX,[WORD PTR CDWord]
			JCXZ	@@FL10
			TEST	DI,$0001
			JZ		@@NOTONE_1
			MOV		[ES:DI],AL
			INC		DI
			DEC		CX
			JZ		@@FL10
@@NOTONE_1:
			CMP		CX,2
			JB		@@NOTTWO_1
			TEST	DI,$0002
			JZ		@@NOTTWO_1
			MOV		[ES:DI],AX
			ADD		DI,2
			SUB		CX,2
			JZ		@@FL10
@@NOTTWO_1:
			SHR		CX,1
			DB $0F, $92, $C3
			SHR		CX,1
	DB $66;	REP		STOSW
			JNC		@@FL9
			MOV		[ES:DI],AX
			ADD		DI,2
@@FL9:
			OR		BL,BL
			JZ		@@FL10
			MOV		[ES:DI],AL
			INC		DI
@@FL10:
			JMP		@@ALLLINES
@@NONFLAT:
			DB $66, $0F, $BF, $46, OFFSET X1	{ MOVSX EAX,[X1] }
			DB $66, $0F, $BF, $5E, OFFSET X2	{ MOVSX EBX,[X2] }
			DB $66, $0F, $BF, $4E, OFFSET X3	{ MOVSX EBX,[X3] }

	DB $66;	SAL		AX,Scaler
	DB $66;	SAL		BX,Scaler
	DB $66;	SAL		CX,Scaler

	DB $66;	MOV		[WORD PTR XX1],AX
	DB $66;	MOV		[WORD PTR XX2],BX
	DB $66;	MOV		[WORD PTR XX3],CX

			MOV		AX,[Y1]
			CMP		AX,[Y2]
			JE		@@EQ1

	DB $66;	MOV		AX,[WORD PTR XX2]
	DB $66;	MOV		BX,[WORD PTR XX1]
	DB $66;	SUB		AX,BX

	DB $66;	CWD
			MOV     BX,[Y2]
			SUB		BX,[Y1]
			DB $66, $0F, $BF, $CB				{ MOVSX ECX,BX }
	DB $66;	IDIV	CX
	DB $66;	MOV		[WORD PTR DX1],AX
			JMP		@@DO2
@@EQ1:
	DB $66;	XOR		AX,AX
	DB $66;	MOV		[WORD PTR DX1],AX
@@DO2:
			MOV		AX,[Y2]
			CMP		AX,[Y3]
			JE		@@EQ2

	DB $66;	MOV		AX,[WORD PTR XX3]
	DB $66;	MOV		BX,[WORD PTR XX2]
	DB $66;	SUB		AX,BX

	DB $66;	CWD
			MOV     BX,[Y3]
			SUB		BX,[Y2]
			DB $66, $0F, $BF, $CB				{ MOVSX ECX,BX }
	DB $66;	IDIV	CX
	DB $66;	MOV		[WORD PTR DX2],AX
			JMP		@@DO3
@@EQ2:
	DB $66;	XOR		AX,AX
	DB $66;	MOV		[WORD PTR DX2],AX
@@DO3:
			MOV		AX,[Y3]
			CMP		AX,[Y1]
			JE		@@EQ3

	DB $66;	MOV		AX,[WORD PTR XX3]
	DB $66;	MOV		BX,[WORD PTR XX1]
	DB $66;	SUB		AX,BX

	DB $66;	CWD
			MOV     BX,[Y3]
			SUB		BX,[Y1]
			DB $66, $0F, $BF, $CB				{ MOVSX ECX,BX }
	DB $66;	IDIV	CX
	DB $66;	MOV		[WORD PTR DX3],AX
			JMP		@@DOFILL
@@EQ3:
	DB $66;	XOR		AX,AX
	DB $66;	MOV		[WORD PTR DX3],AX
@@DOFILL:
			MOV		AX,[Y1]
			CMP		AX,[Y2]
			JNE		@@DIFF

	DB $66;	MOV		AX,[WORD PTR XX1]
	DB $66;	MOV		BX,[WORD PTR XX2]
	DB $66;	MOV		CX,[WORD PTR DX1]
	DB $66;	MOV		DX,[WORD PTR DX1]
	DB $66;	CMP		CX,DX
			JGE		@@OK11
	DB $66;	XCHG	AX,BX
@@OK11:
	DB $66;	MOV		[WORD PTR CX1],AX
	DB $66;	MOV		[WORD PTR CX2],BX
			JMP		@@DONE
@@DIFF:
	DB $66;	MOV		AX,[WORD PTR XX1]
	DB $66;	MOV		[WORD PTR CX1],AX
	DB $66;	MOV		[WORD PTR CX2],AX
@@DONE:
			MOV		AX,[Y1]
			MOV		[Y],AX

			CMP		AX,[ClipY1]
			JGE		@@OKLINE
			MOV		AX,[ClipY1]
@@OKLINE:
			MOV		DI,AX
			SHL		AX,6
			SHL		DI,8
			ADD		DI,AX
@@GO_ON:
			MOV		ES,[VideoSeg]

@@LINELOOP:
			MOV		AX,[Y]
			CMP		AX,[[ClipY1]]
			JL		@@NEXTLINE
			CMP		AX,[[ClipY2]]
			JG		@@ALLLINES

	DB $66;	MOV		AX,[WORD PTR CX1]
	DB $66;	MOV		BX,[WORD PTR CX2]
	DB $66;	CMP		AX,BX
	DB $66;	JLE		@@OK
	DB $66;	XCHG	AX,BX
@@OK:
	DB $66;	XOR		CX,CX
	DB $66;	SAR		AX,Scaler
	DB $66;	ADC		AX,CX
	DB $66;	SAR		BX,Scaler
	DB $66;	ADC		BX,CX
			CMP		AX,[ClipX1]
			JGE		@@OK1_1
			CMP		BX,[ClipX1]
			JGE		@@OK1_1
			JMP		@@NEXTLINE
@@OK1_1:
			CMP		AX,[ClipX2]
			JLE		@@OK1_2
			CMP		BX,[ClipX2]
			JLE		@@OK1_2
			JMP		@@NEXTLINE
@@OK1_2:
			CMP		AX,[ClipX1]
			JGE		@@OK1
			MOV		AX,[ClipX1]
@@OK1:
			CMP		AX,[ClipX2]
			JLE		@@OK2
			MOV		AX,[ClipX2]
@@OK2:
			CMP		BX,[ClipX1]
			JGE		@@OK3
			MOV		BX,[ClipX1]
@@OK3:
			CMP		BX,[ClipX2]
			JLE		@@OK4
			MOV		BX,[ClipX2]
@@OK4:
			MOV		CX,BX
			SUB		CX,AX
			INC		CX
			CLD
			MOV		SI,DI
			ADD		DI,AX
	DB $66;	MOV		AX,[WORD PTR CDWord]
			JCXZ	@@SKIP2
			TEST	DI,$0001
			JZ		@@NOTONE
			MOV		[ES:DI],AL
			INC		DI
			DEC		CX
			JZ		@@SKIP2
@@NOTONE:
			CMP		CX,2
			JB		@@NOTTWO
			TEST	DI,$0002
			JZ		@@NOTTWO
			MOV		[ES:DI],AX
			ADD		DI,2
			SUB		CX,2
			JZ		@@SKIP2
@@NOTTWO:
			SHR		CX,1
			DB $0F, $92, $C3
			SHR		CX,1
	DB $66;	REP		STOSW
			JNC		@@SKIP1
			MOV		[ES:DI],AX
			ADD		DI,2
@@SKIP1:
			OR		BL,BL
			JZ		@@SKIP2
			MOV		[ES:DI],AL
			INC		DI
@@SKIP2:
			MOV		DI,SI
@@NEXTLINE:
			MOV		AX,[Y]
			CMP		AX,[ClipY1]
			JL		@@NEXTLINE_2
			ADD		DI,320
@@NEXTLINE_2:
			CMP		AX,[Y1]
			JL		@@LINE2
			CMP		AX,[Y2]
			JGE		@@LINE2
	DB $66;	MOV		AX,[WORD PTR DX1]
	DB $66;	ADD		[WORD PTR CX2],AX
@@LINE2:
			MOV		AX,[Y]
			CMP		AX,[Y1]
			JL		@@LINE3
			CMP		AX,[Y3]
			JGE		@@LINE3
	DB $66;	MOV		AX,[WORD PTR DX3]
	DB $66;	ADD		[WORD PTR CX1],AX
@@LINE3:
			MOV		AX,[Y]
			CMP		AX,[Y2]
			JL		@@EXIT
			CMP		AX,[Y3]
			JG		@@EXIT
	DB $66;	MOV		AX,[WORD PTR DX2]
	DB $66;	ADD		[WORD PTR CX2],AX
@@EXIT:
			INC		[Y]
			MOV		AX,[Y]
			CMP		AX,[Y3]
			JLE		@@LINELOOP
@@ALLLINES:
End;

Procedure XTetraGlenzADD(X1,Y1,X2,Y2,X3,Y3 : Integer; Color : Byte; VideoSeg : Word); Assembler;
Var
	XX1		: LongInt;
	XX2		: LongInt;
	XX3		: LongInt;
	DX1		: LongInt;
	DX2		: LongInt;
	DX3		: LongInt;
	Y		: Integer;
	CX1,CX2	: LongInt;
	CDWord	: LongInt;
Asm
			CLD
			MOV		AL,[Color]
			MOV		AH,AL
			MOV		BX,AX
	DB $66;	SHL		AX,16
			MOV		AX,BX
	DB $66;	MOV		[WORD PTR CDWord],AX

			CMP		[Color],0
			JE		@@ALLLINES
			MOV		AX,[X1]				{ Initialize registers	}
			MOV		BX,[Y1]
			MOV		CX,[X2]
			MOV		DX,[Y2]
			MOV		SI,[X3]
			MOV		DI,[Y3]

			CMP		BX,DX				{ Calculate min of y1/y2 }
			JLE		@@OK_FIRST_1
			XCHG	AX,CX
			XCHG	BX,DX
@@OK_FIRST_1:
			CMP		BX,DI				{ Calculate min of y2/y3 }
			JLE		@@OK_FIRST_2
			XCHG	AX,SI
			XCHG	BX,DI
@@OK_FIRST_2:
			CMP		DX,DI				{ Calculate min of y1/y3 }
			JLE		@@OK_FIRST_3
			XCHG	CX,SI
			XCHG	DX,DI
@@OK_FIRST_3:
			MOV		[X1],AX				{ Store back in variables }
			MOV		[Y1],BX
			MOV		[X2],CX
			MOV		[Y2],DX
			MOV		[X3],SI
			MOV		[Y3],DI

			CMP		BX,DI
			JNE		@@NONFLAT

			CMP		BX,0
			JL		@@ALLLINES
			CMP		BX,199
			JG		@@ALLLINES
			MOV		DI,BX
			SHL		DI,6
			SHL		BX,8
			ADD		DI,BX
			MOV		ES,[VideoSeg]
			MOV		AX,[X1]
			CMP		AX,[X2]
			JLE		@@FL1
			MOV		AX,[X2]
@@FL1:
			CMP		AX,[X3]
			JLE		@@FL2
			MOV		AX,[X3]
@@FL2:
			MOV		BX,[X1]
			CMP		BX,[X2]
			JGE		@@FL3
			MOV		BX,[X2]
@@FL3:
			CMP		BX,[X3]
			JGE		@@FL4
			MOV		BX,[X3]
@@FL4:
			CMP		AX,0
			JGE		@@FL5
			CMP		BX,0
			JGE		@@FL5
			JMP		@@ALLLINES
@@FL5:
			CMP		AX,319
			JLE		@@FL6
			CMP		BX,319
			JLE		@@FL6
			JMP		@@ALLLINES
@@FL6:
			CMP		AX,0
			JGE		@@FL7
			SUB		AX,AX
@@FL7:
			CMP		BX,319
			JLE		@@FL8
			MOV		BX,319
@@FL8:
			ADD		DI,AX
			MOV		CX,BX
			SUB		CX,AX
			INC		CX
			CLD
	DB $66;	MOV		AX,[WORD PTR CDWord]
			JCXZ	@@FL10
			TEST	DI,$0001
			JZ		@@NOTONE_1
			ADD		[ES:DI],AL
			INC		DI
			DEC		CX
			JZ		@@FL10
@@NOTONE_1:
			CMP		CX,2
			JB		@@NOTTWO_1
			TEST	DI,$0002
			JZ		@@NOTTWO_1
			ADD		[ES:DI],AX
			ADD		DI,2
			SUB		CX,2
			JZ		@@FL10
@@NOTTWO_1:
			SHR		CX,1
			DB $0F, $92, $C3
			SHR		CX,1
			DB $0F, $92, $C7
			JCXZ	@@FL9_2
@@FL9:
	DB $66;	ADD		[WORD PTR ES:DI],AX
			ADD		DI,4
			DEC		CX
			JNZ		@@FL9
@@FL9_2:
			OR		BH,BH
			JZ		@@FL9_3
			ADD		[WORD PTR ES:DI],AX
			ADD		DI,2
@@FL9_3:
			OR		BL,BL
			JZ		@@FL10
			ADD		[BYTE PTR ES:DI],AL
			INC		DI
@@FL10:
			JMP		@@ALLLINES
@@NONFLAT:
			DB $66, $0F, $BF, $46, OFFSET X1	{ MOVSX EAX,[X1] }
			DB $66, $0F, $BF, $5E, OFFSET X2	{ MOVSX EBX,[X2] }
			DB $66, $0F, $BF, $4E, OFFSET X3	{ MOVSX EBX,[X3] }

	DB $66;	SAL		AX,Scaler
	DB $66;	SAL		BX,Scaler
	DB $66;	SAL		CX,Scaler

	DB $66;	MOV		[WORD PTR XX1],AX
	DB $66;	MOV		[WORD PTR XX2],BX
	DB $66;	MOV		[WORD PTR XX3],CX

			MOV		AX,[Y1]
			CMP		AX,[Y2]
			JE		@@EQ1

	DB $66;	MOV		AX,[WORD PTR XX2]
	DB $66;	MOV		BX,[WORD PTR XX1]
	DB $66;	SUB		AX,BX

	DB $66;	CWD
			MOV     BX,[Y2]
			SUB		BX,[Y1]
			DB $66, $0F, $BF, $CB				{ MOVSX ECX,BX }
	DB $66;	IDIV	CX
	DB $66;	MOV		[WORD PTR DX1],AX
			JMP		@@DO2
@@EQ1:
	DB $66;	XOR		AX,AX
	DB $66;	MOV		[WORD PTR DX1],AX
@@DO2:
			MOV		AX,[Y2]
			CMP		AX,[Y3]
			JE		@@EQ2

	DB $66;	MOV		AX,[WORD PTR XX3]
	DB $66;	MOV		BX,[WORD PTR XX2]
	DB $66;	SUB		AX,BX

	DB $66;	CWD
			MOV     BX,[Y3]
			SUB		BX,[Y2]
			DB $66, $0F, $BF, $CB				{ MOVSX ECX,BX }
	DB $66;	IDIV	CX
	DB $66;	MOV		[WORD PTR DX2],AX
			JMP		@@DO3
@@EQ2:
	DB $66;	XOR		AX,AX
	DB $66;	MOV		[WORD PTR DX2],AX
@@DO3:
			MOV		AX,[Y3]
			CMP		AX,[Y1]
			JE		@@EQ3

	DB $66;	MOV		AX,[WORD PTR XX3]
	DB $66;	MOV		BX,[WORD PTR XX1]
	DB $66;	SUB		AX,BX

	DB $66;	CWD
			MOV     BX,[Y3]
			SUB		BX,[Y1]
			DB $66, $0F, $BF, $CB				{ MOVSX ECX,BX }
	DB $66;	IDIV	CX
	DB $66;	MOV		[WORD PTR DX3],AX
			JMP		@@DOFILL
@@EQ3:
	DB $66;	XOR		AX,AX
	DB $66;	MOV		[WORD PTR DX3],AX
@@DOFILL:
			MOV		AX,[Y1]
			CMP		AX,[Y2]
			JNE		@@DIFF

	DB $66;	MOV		AX,[WORD PTR XX1]
	DB $66;	MOV		BX,[WORD PTR XX2]
	DB $66;	MOV		CX,[WORD PTR DX1]
	DB $66;	MOV		DX,[WORD PTR DX1]
	DB $66;	CMP		CX,DX
			JGE		@@OK11
	DB $66;	XCHG	AX,BX
@@OK11:
	DB $66;	MOV		[WORD PTR CX1],AX
	DB $66;	MOV		[WORD PTR CX2],BX
			JMP		@@DONE
@@DIFF:
	DB $66;	MOV		AX,[WORD PTR XX1]
	DB $66;	MOV		[WORD PTR CX1],AX
	DB $66;	MOV		[WORD PTR CX2],AX
@@DONE:
			MOV		AX,[Y1]
			MOV		[Y],AX

			CMP		AX,0
			JGE		@@OKLINE
			SUB		AX,AX
@@OKLINE:
			MOV		DI,AX
			SHL		AX,6
			SHL		DI,8
			ADD		DI,AX
@@GO_ON:
			MOV		ES,[VideoSeg]

@@LINELOOP:
			MOV		AX,[Y]
			CMP		AX,0
			JL		@@NEXTLINE
			CMP		AX,199
			JG		@@ALLLINES

	DB $66;	MOV		AX,[WORD PTR CX1]
	DB $66;	MOV		BX,[WORD PTR CX2]
	DB $66;	CMP		AX,BX
	DB $66;	JLE		@@OK
	DB $66;	XCHG	AX,BX
@@OK:
	DB $66;	XOR		CX,CX
	DB $66;	SAR		AX,Scaler
	DB $66;	ADC		AX,CX
	DB $66;	SAR		BX,Scaler
	DB $66;	ADC		BX,CX
			CMP		AX,0
			JGE		@@OK1_1
			CMP		BX,0
			JGE		@@OK1_1
			JMP		@@NEXTLINE
@@OK1_1:
			CMP		AX,319
			JLE		@@OK1_2
			CMP		BX,319
			JLE		@@OK1_2
			JMP		@@NEXTLINE
@@OK1_2:
			CMP		AX,0
			JGE		@@OK1
			SUB		AX,AX
@@OK1:
			CMP		AX,319
			JLE		@@OK2
			MOV		AX,319
@@OK2:
			CMP		BX,0
			JGE		@@OK3
			SUB		BX,BX
@@OK3:
			CMP		BX,319
			JLE		@@OK4
			MOV		BX,319
@@OK4:
			MOV		CX,BX
			SUB		CX,AX
			INC		CX
			CLD
			MOV		SI,DI
			ADD		DI,AX
	DB $66;	MOV		AX,[WORD PTR CDWord]
			JCXZ	@@SKIP2
			TEST	DI,$0001
			JZ		@@NOTONE
			ADD		[BYTE PTR ES:DI],AL
			INC		DI
			DEC		CX
			JZ		@@SKIP2
@@NOTONE:
			CMP		CX,2
			JB		@@NOTTWO
			TEST	DI,$0002
			JZ		@@NOTTWO
			ADD		[WORD PTR ES:DI],AX
			ADD		DI,2
			SUB		CX,2
			JZ		@@SKIP2
@@NOTTWO:
			SHR		CX,1
			DB $0F, $92, $C3
			SHR		CX,1
			DB $0F, $92, $C7
			JCXZ	@@SKIP0
@@STOSLOOP:
	DB $66;	ADD		[WORD PTR ES:DI],AX
			ADD		DI,4
			DEC		CX
			JNZ		@@STOSLOOP
@@SKIP0:
			OR		BH,BH
			JZ		@@SKIP1
			ADD		[WORD PTR ES:DI],AX
			ADD		DI,2
@@SKIP1:
			OR		BL,BL
			JZ		@@SKIP2
			ADD		[BYTE PTR ES:DI],AL
			INC		DI
@@SKIP2:
			MOV		DI,SI
@@NEXTLINE:
			MOV		AX,[Y]
			CMP		AX,0
			JL		@@NEXTLINE_2
			ADD		DI,320
@@NEXTLINE_2:
			CMP		AX,[Y1]
			JL		@@LINE2
			CMP		AX,[Y2]
			JGE		@@LINE2
	DB $66;	MOV		AX,[WORD PTR DX1]
	DB $66;	ADD		[WORD PTR CX2],AX
@@LINE2:
			MOV		AX,[Y]
			CMP		AX,[Y1]
			JL		@@LINE3
			CMP		AX,[Y3]
			JGE		@@LINE3
	DB $66;	MOV		AX,[WORD PTR DX3]
	DB $66;	ADD		[WORD PTR CX1],AX
@@LINE3:
			MOV		AX,[Y]
			CMP		AX,[Y2]
			JL		@@EXIT
			CMP		AX,[Y3]
			JG		@@EXIT
	DB $66;	MOV		AX,[WORD PTR DX2]
	DB $66;	ADD		[WORD PTR CX2],AX
@@EXIT:
			INC		[Y]
			MOV		AX,[Y]
			CMP		AX,[Y3]
			JLE		@@LINELOOP
@@ALLLINES:
End;

Procedure XTetraGlenzSUB(X1,Y1,X2,Y2,X3,Y3 : Integer; Color : Byte; VideoSeg : Word); Assembler;
Var
	XX1		: LongInt;
	XX2		: LongInt;
	XX3		: LongInt;
	DX1		: LongInt;
	DX2		: LongInt;
	DX3		: LongInt;
	Y		: Integer;
	CX1,CX2	: LongInt;
	CDWord	: LongInt;
Asm
			CLD
			MOV		AL,[Color]
			MOV		AH,AL
			MOV		BX,AX
	DB $66;	SHL		AX,16
			MOV		AX,BX
	DB $66;	MOV		[WORD PTR CDWord],AX

			CMP		[Color],0
			JE		@@ALLLINES
			MOV		AX,[X1]				{ Initialize registers	}
			MOV		BX,[Y1]
			MOV		CX,[X2]
			MOV		DX,[Y2]
			MOV		SI,[X3]
			MOV		DI,[Y3]

			CMP		BX,DX				{ Calculate min of y1/y2 }
			JLE		@@OK_FIRST_1
			XCHG	AX,CX
			XCHG	BX,DX
@@OK_FIRST_1:
			CMP		BX,DI				{ Calculate min of y2/y3 }
			JLE		@@OK_FIRST_2
			XCHG	AX,SI
			XCHG	BX,DI
@@OK_FIRST_2:
			CMP		DX,DI				{ Calculate min of y1/y3 }
			JLE		@@OK_FIRST_3
			XCHG	CX,SI
			XCHG	DX,DI
@@OK_FIRST_3:
			MOV		[X1],AX				{ Store back in variables }
			MOV		[Y1],BX
			MOV		[X2],CX
			MOV		[Y2],DX
			MOV		[X3],SI
			MOV		[Y3],DI

			CMP		BX,DI
			JNE		@@NONFLAT

			CMP		BX,0
			JL		@@ALLLINES
			CMP		BX,199
			JG		@@ALLLINES
			MOV		DI,BX
			SHL		DI,6
			SHL		BX,8
			ADD		DI,BX
			MOV		ES,[VideoSeg]
			MOV		AX,[X1]
			CMP		AX,[X2]
			JLE		@@FL1
			MOV		AX,[X2]
@@FL1:
			CMP		AX,[X3]
			JLE		@@FL2
			MOV		AX,[X3]
@@FL2:
			MOV		BX,[X1]
			CMP		BX,[X2]
			JGE		@@FL3
			MOV		BX,[X2]
@@FL3:
			CMP		BX,[X3]
			JGE		@@FL4
			MOV		BX,[X3]
@@FL4:
			CMP		AX,0
			JGE		@@FL5
			CMP		BX,0
			JGE		@@FL5
			JMP		@@ALLLINES
@@FL5:
			CMP		AX,319
			JLE		@@FL6
			CMP		BX,319
			JLE		@@FL6
			JMP		@@ALLLINES
@@FL6:
			CMP		AX,0
			JGE		@@FL7
			SUB		AX,AX
@@FL7:
			CMP		BX,319
			JLE		@@FL8
			MOV		BX,319
@@FL8:
			ADD		DI,AX
			MOV		CX,BX
			SUB		CX,AX
			INC		CX
			CLD
	DB $66;	MOV		AX,[WORD PTR CDWord]
			JCXZ	@@FL10
			TEST	DI,$0001
			JZ		@@NOTONE_1
			SUB		[ES:DI],AL
			INC		DI
			DEC		CX
			JZ		@@FL10
@@NOTONE_1:
			CMP		CX,2
			JB		@@NOTTWO_1
			TEST	DI,$0002
			JZ		@@NOTTWO_1
			SUB		[ES:DI],AX
			ADD		DI,2
			SUB		CX,2
			JZ		@@FL10
@@NOTTWO_1:
			SHR		CX,1
			DB $0F, $92, $C3
			SHR		CX,1
			DB $0F, $92, $C7
			JCXZ	@@FL9_2
@@FL9:
	DB $66;	SUB		[WORD PTR ES:DI],AX
			ADD		DI,4
			DEC		CX
			JNZ		@@FL9
@@FL9_2:
			OR		BH,BH
			JZ		@@FL9_3
			SUB		[WORD PTR ES:DI],AX
			ADD		DI,2
@@FL9_3:
			OR		BL,BL
			JZ		@@FL10
			SUB		[BYTE PTR ES:DI],AL
			INC		DI
@@FL10:
			JMP		@@ALLLINES
@@NONFLAT:
			DB $66, $0F, $BF, $46, OFFSET X1	{ MOVSX EAX,[X1] }
			DB $66, $0F, $BF, $5E, OFFSET X2	{ MOVSX EBX,[X2] }
			DB $66, $0F, $BF, $4E, OFFSET X3	{ MOVSX EBX,[X3] }

	DB $66;	SAL		AX,Scaler
	DB $66;	SAL		BX,Scaler
	DB $66;	SAL		CX,Scaler

	DB $66;	MOV		[WORD PTR XX1],AX
	DB $66;	MOV		[WORD PTR XX2],BX
	DB $66;	MOV		[WORD PTR XX3],CX

			MOV		AX,[Y1]
			CMP		AX,[Y2]
			JE		@@EQ1

	DB $66;	MOV		AX,[WORD PTR XX2]
	DB $66;	MOV		BX,[WORD PTR XX1]
	DB $66;	SUB		AX,BX

	DB $66;	CWD
			MOV     BX,[Y2]
			SUB		BX,[Y1]
			DB $66, $0F, $BF, $CB				{ MOVSX ECX,BX }
	DB $66;	IDIV	CX
	DB $66;	MOV		[WORD PTR DX1],AX
			JMP		@@DO2
@@EQ1:
	DB $66;	XOR		AX,AX
	DB $66;	MOV		[WORD PTR DX1],AX
@@DO2:
			MOV		AX,[Y2]
			CMP		AX,[Y3]
			JE		@@EQ2

	DB $66;	MOV		AX,[WORD PTR XX3]
	DB $66;	MOV		BX,[WORD PTR XX2]
	DB $66;	SUB		AX,BX

	DB $66;	CWD
			MOV     BX,[Y3]
			SUB		BX,[Y2]
			DB $66, $0F, $BF, $CB				{ MOVSX ECX,BX }
	DB $66;	IDIV	CX
	DB $66;	MOV		[WORD PTR DX2],AX
			JMP		@@DO3
@@EQ2:
	DB $66;	XOR		AX,AX
	DB $66;	MOV		[WORD PTR DX2],AX
@@DO3:
			MOV		AX,[Y3]
			CMP		AX,[Y1]
			JE		@@EQ3

	DB $66;	MOV		AX,[WORD PTR XX3]
	DB $66;	MOV		BX,[WORD PTR XX1]
	DB $66;	SUB		AX,BX

	DB $66;	CWD
			MOV     BX,[Y3]
			SUB		BX,[Y1]
			DB $66, $0F, $BF, $CB				{ MOVSX ECX,BX }
	DB $66;	IDIV	CX
	DB $66;	MOV		[WORD PTR DX3],AX
			JMP		@@DOFILL
@@EQ3:
	DB $66;	XOR		AX,AX
	DB $66;	MOV		[WORD PTR DX3],AX
@@DOFILL:
			MOV		AX,[Y1]
			CMP		AX,[Y2]
			JNE		@@DIFF

	DB $66;	MOV		AX,[WORD PTR XX1]
	DB $66;	MOV		BX,[WORD PTR XX2]
	DB $66;	MOV		CX,[WORD PTR DX1]
	DB $66;	MOV		DX,[WORD PTR DX1]
	DB $66;	CMP		CX,DX
			JGE		@@OK11
	DB $66;	XCHG	AX,BX
@@OK11:
	DB $66;	MOV		[WORD PTR CX1],AX
	DB $66;	MOV		[WORD PTR CX2],BX
			JMP		@@DONE
@@DIFF:
	DB $66;	MOV		AX,[WORD PTR XX1]
	DB $66;	MOV		[WORD PTR CX1],AX
	DB $66;	MOV		[WORD PTR CX2],AX
@@DONE:
			MOV		AX,[Y1]
			MOV		[Y],AX

			CMP		AX,0
			JGE		@@OKLINE
			SUB		AX,AX
@@OKLINE:
			MOV		DI,AX
			SHL		AX,6
			SHL		DI,8
			ADD		DI,AX
@@GO_ON:
			MOV		ES,[VideoSeg]

@@LINELOOP:
			MOV		AX,[Y]
			CMP		AX,0
			JL		@@NEXTLINE
			CMP		AX,199
			JG		@@ALLLINES

	DB $66;	MOV		AX,[WORD PTR CX1]
	DB $66;	MOV		BX,[WORD PTR CX2]
	DB $66;	CMP		AX,BX
	DB $66;	JLE		@@OK
	DB $66;	XCHG	AX,BX
@@OK:
	DB $66;	XOR		CX,CX
	DB $66;	SAR		AX,Scaler
	DB $66;	ADC		AX,CX
	DB $66;	SAR		BX,Scaler
	DB $66;	ADC		BX,CX
			CMP		AX,0
			JGE		@@OK1_1
			CMP		BX,0
			JGE		@@OK1_1
			JMP		@@NEXTLINE
@@OK1_1:
			CMP		AX,319
			JLE		@@OK1_2
			CMP		BX,319
			JLE		@@OK1_2
			JMP		@@NEXTLINE
@@OK1_2:
			CMP		AX,0
			JGE		@@OK1
			SUB		AX,AX
@@OK1:
			CMP		AX,319
			JLE		@@OK2
			MOV		AX,319
@@OK2:
			CMP		BX,0
			JGE		@@OK3
			SUB		BX,BX
@@OK3:
			CMP		BX,319
			JLE		@@OK4
			MOV		BX,319
@@OK4:
			MOV		CX,BX
			SUB		CX,AX
			INC		CX
			CLD
			MOV		SI,DI
			ADD		DI,AX
	DB $66;	MOV		AX,[WORD PTR CDWord]
			JCXZ	@@SKIP2
			TEST	DI,$0001
			JZ		@@NOTONE
			SUB		[BYTE PTR ES:DI],AL
			INC		DI
			DEC		CX
			JZ		@@SKIP2
@@NOTONE:
			CMP		CX,2
			JB		@@NOTTWO
			TEST	DI,$0002
			JZ		@@NOTTWO
			SUB		[WORD PTR ES:DI],AX
			ADD		DI,2
			SUB		CX,2
			JZ		@@SKIP2
@@NOTTWO:
			SHR		CX,1
			DB $0F, $92, $C3
			SHR		CX,1
			DB $0F, $92, $C7
			JCXZ	@@SKIP0
@@STOSLOOP:
	DB $66;	SUB		[WORD PTR ES:DI],AX
			ADD		DI,4
			DEC		CX
			JNZ		@@STOSLOOP
@@SKIP0:
			OR		BH,BH
			JZ		@@SKIP1
			SUB		[WORD PTR ES:DI],AX
			ADD		DI,2
@@SKIP1:
			OR		BL,BL
			JZ		@@SKIP2
			SUB		[BYTE PTR ES:DI],AL
			INC		DI
@@SKIP2:
			MOV		DI,SI
@@NEXTLINE:
			MOV		AX,[Y]
			CMP		AX,0
			JL		@@NEXTLINE_2
			ADD		DI,320
@@NEXTLINE_2:
			CMP		AX,[Y1]
			JL		@@LINE2
			CMP		AX,[Y2]
			JGE		@@LINE2
	DB $66;	MOV		AX,[WORD PTR DX1]
	DB $66;	ADD		[WORD PTR CX2],AX
@@LINE2:
			MOV		AX,[Y]
			CMP		AX,[Y1]
			JL		@@LINE3
			CMP		AX,[Y3]
			JGE		@@LINE3
	DB $66;	MOV		AX,[WORD PTR DX3]
	DB $66;	ADD		[WORD PTR CX1],AX
@@LINE3:
			MOV		AX,[Y]
			CMP		AX,[Y2]
			JL		@@EXIT
			CMP		AX,[Y3]
			JG		@@EXIT
	DB $66;	MOV		AX,[WORD PTR DX2]
	DB $66;	ADD		[WORD PTR CX2],AX
@@EXIT:
			INC		[Y]
			MOV		AX,[Y]
			CMP		AX,[Y3]
			JLE		@@LINELOOP
@@ALLLINES:
End;

Procedure XTetraGlenzADDClip(X1,Y1,X2,Y2,X3,Y3,ClipX1,ClipY1,ClipX2,ClipY2 : Integer;
	Color : Byte; VideoSeg : Word); Assembler;
Var
	XX1		: LongInt;
	XX2		: LongInt;
	XX3		: LongInt;
	DX1		: LongInt;
	DX2		: LongInt;
	DX3		: LongInt;
	Y		: Integer;
	CX1,CX2	: LongInt;
	CDWord	: LongInt;
Asm
			CLD
			MOV		AL,[Color]
			MOV		AH,AL
			MOV		BX,AX
	DB $66;	SHL		AX,16
			MOV		AX,BX
	DB $66;	MOV		[WORD PTR CDWord],AX

			CMP		[Color],0
			JE		@@ALLLINES
			MOV		AX,[X1]				{ Initialize registers	}
			MOV		BX,[Y1]
			MOV		CX,[X2]
			MOV		DX,[Y2]
			MOV		SI,[X3]
			MOV		DI,[Y3]

			CMP		BX,DX				{ Calculate min of y1/y2 }
			JLE		@@OK_FIRST_1
			XCHG	AX,CX
			XCHG	BX,DX
@@OK_FIRST_1:
			CMP		BX,DI				{ Calculate min of y2/y3 }
			JLE		@@OK_FIRST_2
			XCHG	AX,SI
			XCHG	BX,DI
@@OK_FIRST_2:
			CMP		DX,DI				{ Calculate min of y1/y3 }
			JLE		@@OK_FIRST_3
			XCHG	CX,SI
			XCHG	DX,DI
@@OK_FIRST_3:
			MOV		[X1],AX				{ Store back in variables }
			MOV		[Y1],BX
			MOV		[X2],CX
			MOV		[Y2],DX
			MOV		[X3],SI
			MOV		[Y3],DI

			CMP		BX,DI
			JNE		@@NONFLAT

			CMP		BX,[[ClipY1]]
			JL		@@ALLLINES
			CMP		BX,[[ClipY2]]
			JG		@@ALLLINES
			MOV		DI,BX
			SHL		DI,6
			SHL		BX,8
			ADD		DI,BX
			MOV		ES,[VideoSeg]
			MOV		AX,[X1]
			CMP		AX,[X2]
			JLE		@@FL1
			MOV		AX,[X2]
@@FL1:
			CMP		AX,[X3]
			JLE		@@FL2
			MOV		AX,[X3]
@@FL2:
			MOV		BX,[X1]
			CMP		BX,[X2]
			JGE		@@FL3
			MOV		BX,[X2]
@@FL3:
			CMP		BX,[X3]
			JGE		@@FL4
			MOV		BX,[X3]
@@FL4:
			CMP		AX,[ClipX1]
			JGE		@@FL5
			CMP		BX,[ClipX1]
			JGE		@@FL5
			JMP		@@ALLLINES
@@FL5:
			CMP		AX,[ClipX2]
			JLE		@@FL6
			CMP		BX,[ClipX2]
			JLE		@@FL6
			JMP		@@ALLLINES
@@FL6:
			CMP		AX,[ClipX1]
			JGE		@@FL7
			MOV		AX,[ClipX1]
@@FL7:
			CMP		BX,[ClipX2]
			JLE		@@FL8
			MOV		BX,[ClipX2]
@@FL8:
			ADD		DI,AX
			MOV		CX,BX
			SUB		CX,AX
			INC		CX
			CLD
	DB $66;	MOV		AX,[WORD PTR CDWord]
			JCXZ	@@FL10
			TEST	DI,$0001
			JZ		@@NOTONE_1
			ADD		[ES:DI],AL
			INC		DI
			DEC		CX
			JZ		@@FL10
@@NOTONE_1:
			CMP		CX,2
			JB		@@NOTTWO_1
			TEST	DI,$0002
			JZ		@@NOTTWO_1
			ADD		[ES:DI],AX
			ADD		DI,2
			SUB		CX,2
			JZ		@@FL10
@@NOTTWO_1:
			SHR		CX,1
			DB $0F, $92, $C3
			SHR		CX,1
			DB $0F, $92, $C7
			JCXZ	@@FL9_2
@@FL9:
	DB $66;	ADD		[WORD PTR ES:DI],AX
			ADD		DI,4
			DEC		CX
			JNZ		@@FL9
@@FL9_2:
			OR		BH,BH
			JZ		@@FL9_3
			ADD		[WORD PTR ES:DI],AX
			ADD		DI,2
@@FL9_3:
			OR		BL,BL
			JZ		@@FL10
			ADD		[BYTE PTR ES:DI],AL
			INC		DI
@@FL10:
			JMP		@@ALLLINES
@@NONFLAT:
			DB $66, $0F, $BF, $46, OFFSET X1	{ MOVSX EAX,[X1] }
			DB $66, $0F, $BF, $5E, OFFSET X2	{ MOVSX EBX,[X2] }
			DB $66, $0F, $BF, $4E, OFFSET X3	{ MOVSX EBX,[X3] }

	DB $66;	SAL		AX,Scaler
	DB $66;	SAL		BX,Scaler
	DB $66;	SAL		CX,Scaler

	DB $66;	MOV		[WORD PTR XX1],AX
	DB $66;	MOV		[WORD PTR XX2],BX
	DB $66;	MOV		[WORD PTR XX3],CX

			MOV		AX,[Y1]
			CMP		AX,[Y2]
			JE		@@EQ1

	DB $66;	MOV		AX,[WORD PTR XX2]
	DB $66;	MOV		BX,[WORD PTR XX1]
	DB $66;	SUB		AX,BX

	DB $66;	CWD
			MOV     BX,[Y2]
			SUB		BX,[Y1]
			DB $66, $0F, $BF, $CB				{ MOVSX ECX,BX }
	DB $66;	IDIV	CX
	DB $66;	MOV		[WORD PTR DX1],AX
			JMP		@@DO2
@@EQ1:
	DB $66;	XOR		AX,AX
	DB $66;	MOV		[WORD PTR DX1],AX
@@DO2:
			MOV		AX,[Y2]
			CMP		AX,[Y3]
			JE		@@EQ2

	DB $66;	MOV		AX,[WORD PTR XX3]
	DB $66;	MOV		BX,[WORD PTR XX2]
	DB $66;	SUB		AX,BX

	DB $66;	CWD
			MOV     BX,[Y3]
			SUB		BX,[Y2]
			DB $66, $0F, $BF, $CB				{ MOVSX ECX,BX }
	DB $66;	IDIV	CX
	DB $66;	MOV		[WORD PTR DX2],AX
			JMP		@@DO3
@@EQ2:
	DB $66;	XOR		AX,AX
	DB $66;	MOV		[WORD PTR DX2],AX
@@DO3:
			MOV		AX,[Y3]
			CMP		AX,[Y1]
			JE		@@EQ3

	DB $66;	MOV		AX,[WORD PTR XX3]
	DB $66;	MOV		BX,[WORD PTR XX1]
	DB $66;	SUB		AX,BX

	DB $66;	CWD
			MOV     BX,[Y3]
			SUB		BX,[Y1]
			DB $66, $0F, $BF, $CB				{ MOVSX ECX,BX }
	DB $66;	IDIV	CX
	DB $66;	MOV		[WORD PTR DX3],AX
			JMP		@@DOFILL
@@EQ3:
	DB $66;	XOR		AX,AX
	DB $66;	MOV		[WORD PTR DX3],AX
@@DOFILL:
			MOV		AX,[Y1]
			CMP		AX,[Y2]
			JNE		@@DIFF

	DB $66;	MOV		AX,[WORD PTR XX1]
	DB $66;	MOV		BX,[WORD PTR XX2]
	DB $66;	MOV		CX,[WORD PTR DX1]
	DB $66;	MOV		DX,[WORD PTR DX1]
	DB $66;	CMP		CX,DX
			JGE		@@OK11
	DB $66;	XCHG	AX,BX
@@OK11:
	DB $66;	MOV		[WORD PTR CX1],AX
	DB $66;	MOV		[WORD PTR CX2],BX
			JMP		@@DONE
@@DIFF:
	DB $66;	MOV		AX,[WORD PTR XX1]
	DB $66;	MOV		[WORD PTR CX1],AX
	DB $66;	MOV		[WORD PTR CX2],AX
@@DONE:
			MOV		AX,[Y1]
			MOV		[Y],AX

			CMP		AX,[[ClipY1]]
			JGE		@@OKLINE
			MOV		AX,[[ClipY1]]
@@OKLINE:
			MOV		DI,AX
			SHL		AX,6
			SHL		DI,8
			ADD		DI,AX
@@GO_ON:
			MOV		ES,[VideoSeg]

@@LINELOOP:
			MOV		AX,[Y]
			CMP		AX,[[ClipY1]]
			JL		@@NEXTLINE
			CMP		AX,[[ClipY2]]
			JG		@@ALLLINES

	DB $66;	MOV		AX,[WORD PTR CX1]
	DB $66;	MOV		BX,[WORD PTR CX2]
	DB $66;	CMP		AX,BX
	DB $66;	JLE		@@OK
	DB $66;	XCHG	AX,BX
@@OK:
	DB $66;	XOR		CX,CX
	DB $66;	SAR		AX,Scaler
	DB $66;	ADC		AX,CX
	DB $66;	SAR		BX,Scaler
	DB $66;	ADC		BX,CX
			CMP		AX,[ClipX1]
			JGE		@@OK1_1
			CMP		BX,[ClipX1]
			JGE		@@OK1_1
			JMP		@@NEXTLINE
@@OK1_1:
			CMP		AX,[ClipX2]
			JLE		@@OK1_2
			CMP		BX,[ClipX2]
			JLE		@@OK1_2
			JMP		@@NEXTLINE
@@OK1_2:
			CMP		AX,[ClipX1]
			JGE		@@OK1
			MOV		AX,[ClipX1]
@@OK1:
			CMP		AX,[ClipX2]
			JLE		@@OK2
			MOV		AX,[ClipX2]
@@OK2:
			CMP		BX,[ClipX1]
			JGE		@@OK3
			MOV		BX,[ClipX1]
@@OK3:
			CMP		BX,[ClipX2]
			JLE		@@OK4
			MOV		BX,[ClipX2]
@@OK4:
			MOV		CX,BX
			SUB		CX,AX
			INC		CX
			CLD
			MOV		SI,DI
			ADD		DI,AX
	DB $66;	MOV		AX,[WORD PTR CDWord]
			JCXZ	@@SKIP2
			TEST	DI,$0001
			JZ		@@NOTONE
			ADD		[BYTE PTR ES:DI],AL
			INC		DI
			DEC		CX
			JZ		@@SKIP2
@@NOTONE:
			CMP		CX,2
			JB		@@NOTTWO
			TEST	DI,$0002
			JZ		@@NOTTWO
			ADD		[WORD PTR ES:DI],AX
			ADD		DI,2
			SUB		CX,2
			JZ		@@SKIP2
@@NOTTWO:
			SHR		CX,1
			DB $0F, $92, $C3
			SHR		CX,1
			DB $0F, $92, $C7
			JCXZ	@@SKIP0
@@STOSLOOP:
	DB $66;	ADD		[WORD PTR ES:DI],AX
			ADD		DI,4
			DEC		CX
			JNZ		@@STOSLOOP
@@SKIP0:
			OR		BH,BH
			JZ		@@SKIP1
			ADD		[WORD PTR ES:DI],AX
			ADD		DI,2
@@SKIP1:
			OR		BL,BL
			JZ		@@SKIP2
			ADD		[BYTE PTR ES:DI],AL
			INC		DI
@@SKIP2:
			MOV		DI,SI
@@NEXTLINE:
			MOV		AX,[Y]
			CMP		AX,[ClipY1]
			JL		@@NEXTLINE_2
			ADD		DI,320
@@NEXTLINE_2:
			CMP		AX,[Y1]
			JL		@@LINE2
			CMP		AX,[Y2]
			JGE		@@LINE2
	DB $66;	MOV		AX,[WORD PTR DX1]
	DB $66;	ADD		[WORD PTR CX2],AX
@@LINE2:
			MOV		AX,[Y]
			CMP		AX,[Y1]
			JL		@@LINE3
			CMP		AX,[Y3]
			JGE		@@LINE3
	DB $66;	MOV		AX,[WORD PTR DX3]
	DB $66;	ADD		[WORD PTR CX1],AX
@@LINE3:
			MOV		AX,[Y]
			CMP		AX,[Y2]
			JL		@@EXIT
			CMP		AX,[Y3]
			JG		@@EXIT
	DB $66;	MOV		AX,[WORD PTR DX2]
	DB $66;	ADD		[WORD PTR CX2],AX
@@EXIT:
			INC		[Y]
			MOV		AX,[Y]
			CMP		AX,[Y3]
			JLE		@@LINELOOP
@@ALLLINES:
End;

Procedure XTetraGlenzSUBClip(X1,Y1,X2,Y2,X3,Y3,ClipX1,ClipY1,ClipX2,ClipY2 : Integer;
	Color : Byte; VideoSeg : Word); Assembler;
Var
	XX1		: LongInt;
	XX2		: LongInt;
	XX3		: LongInt;
	DX1		: LongInt;
	DX2		: LongInt;
	DX3		: LongInt;
	Y		: Integer;
	CX1,CX2	: LongInt;
	CDWord	: LongInt;
Asm
			CLD
			MOV		AL,[Color]
			MOV		AH,AL
			MOV		BX,AX
	DB $66;	SHL		AX,16
			MOV		AX,BX
	DB $66;	MOV		[WORD PTR CDWord],AX

			CMP		[Color],0
			JE		@@ALLLINES
			MOV		AX,[X1]				{ Initialize registers	}
			MOV		BX,[Y1]
			MOV		CX,[X2]
			MOV		DX,[Y2]
			MOV		SI,[X3]
			MOV		DI,[Y3]

			CMP		BX,DX				{ Calculate min of y1/y2 }
			JLE		@@OK_FIRST_1
			XCHG	AX,CX
			XCHG	BX,DX
@@OK_FIRST_1:
			CMP		BX,DI				{ Calculate min of y2/y3 }
			JLE		@@OK_FIRST_2
			XCHG	AX,SI
			XCHG	BX,DI
@@OK_FIRST_2:
			CMP		DX,DI				{ Calculate min of y1/y3 }
			JLE		@@OK_FIRST_3
			XCHG	CX,SI
			XCHG	DX,DI
@@OK_FIRST_3:
			MOV		[X1],AX				{ Store back in variables }
			MOV		[Y1],BX
			MOV		[X2],CX
			MOV		[Y2],DX
			MOV		[X3],SI
			MOV		[Y3],DI

			CMP		BX,DI
			JNE		@@NONFLAT

			CMP		BX,[[ClipY1]]
			JL		@@ALLLINES
			CMP		BX,[[ClipY2]]
			JG		@@ALLLINES
			MOV		DI,BX
			SHL		DI,6
			SHL		BX,8
			ADD		DI,BX
			MOV		ES,[VideoSeg]
			MOV		AX,[X1]
			CMP		AX,[X2]
			JLE		@@FL1
			MOV		AX,[X2]
@@FL1:
			CMP		AX,[X3]
			JLE		@@FL2
			MOV		AX,[X3]
@@FL2:
			MOV		BX,[X1]
			CMP		BX,[X2]
			JGE		@@FL3
			MOV		BX,[X2]
@@FL3:
			CMP		BX,[X3]
			JGE		@@FL4
			MOV		BX,[X3]
@@FL4:
			CMP		AX,[ClipX1]
			JGE		@@FL5
			CMP		BX,[ClipX1]
			JGE		@@FL5
			JMP		@@ALLLINES
@@FL5:
			CMP		AX,[ClipX2]
			JLE		@@FL6
			CMP		BX,[ClipX2]
			JLE		@@FL6
			JMP		@@ALLLINES
@@FL6:
			CMP		AX,[ClipX1]
			JGE		@@FL7
			MOV		AX,[ClipX1]
@@FL7:
			CMP		BX,[ClipX2]
			JLE		@@FL8
			MOV		BX,[ClipX2]
@@FL8:
			ADD		DI,AX
			MOV		CX,BX
			SUB		CX,AX
			INC		CX
			CLD
	DB $66;	MOV		AX,[WORD PTR CDWord]
			JCXZ	@@FL10
			TEST	DI,$0001
			JZ		@@NOTONE_1
			SUB		[ES:DI],AL
			INC		DI
			DEC		CX
			JZ		@@FL10
@@NOTONE_1:
			CMP		CX,2
			JB		@@NOTTWO_1
			TEST	DI,$0002
			JZ		@@NOTTWO_1
			SUB		[ES:DI],AX
			ADD		DI,2
			SUB		CX,2
			JZ		@@FL10
@@NOTTWO_1:
			SHR		CX,1
			DB $0F, $92, $C3
			SHR		CX,1
			DB $0F, $92, $C7
			JCXZ	@@FL9_2
@@FL9:
	DB $66;	SUB		[WORD PTR ES:DI],AX
			ADD		DI,4
			DEC		CX
			JNZ		@@FL9
@@FL9_2:
			OR		BH,BH
			JZ		@@FL9_3
			SUB		[WORD PTR ES:DI],AX
			ADD		DI,2
@@FL9_3:
			OR		BL,BL
			JZ		@@FL10
			SUB		[BYTE PTR ES:DI],AL
			INC		DI
@@FL10:
			JMP		@@ALLLINES
@@NONFLAT:
			DB $66, $0F, $BF, $46, OFFSET X1	{ MOVSX EAX,[X1] }
			DB $66, $0F, $BF, $5E, OFFSET X2	{ MOVSX EBX,[X2] }
			DB $66, $0F, $BF, $4E, OFFSET X3	{ MOVSX EBX,[X3] }

	DB $66;	SAL		AX,Scaler
	DB $66;	SAL		BX,Scaler
	DB $66;	SAL		CX,Scaler

	DB $66;	MOV		[WORD PTR XX1],AX
	DB $66;	MOV		[WORD PTR XX2],BX
	DB $66;	MOV		[WORD PTR XX3],CX

			MOV		AX,[Y1]
			CMP		AX,[Y2]
			JE		@@EQ1

	DB $66;	MOV		AX,[WORD PTR XX2]
	DB $66;	MOV		BX,[WORD PTR XX1]
	DB $66;	SUB		AX,BX

	DB $66;	CWD
			MOV     BX,[Y2]
			SUB		BX,[Y1]
			DB $66, $0F, $BF, $CB				{ MOVSX ECX,BX }
	DB $66;	IDIV	CX
	DB $66;	MOV		[WORD PTR DX1],AX
			JMP		@@DO2
@@EQ1:
	DB $66;	XOR		AX,AX
	DB $66;	MOV		[WORD PTR DX1],AX
@@DO2:
			MOV		AX,[Y2]
			CMP		AX,[Y3]
			JE		@@EQ2

	DB $66;	MOV		AX,[WORD PTR XX3]
	DB $66;	MOV		BX,[WORD PTR XX2]
	DB $66;	SUB		AX,BX

	DB $66;	CWD
			MOV     BX,[Y3]
			SUB		BX,[Y2]
			DB $66, $0F, $BF, $CB				{ MOVSX ECX,BX }
	DB $66;	IDIV	CX
	DB $66;	MOV		[WORD PTR DX2],AX
			JMP		@@DO3
@@EQ2:
	DB $66;	XOR		AX,AX
	DB $66;	MOV		[WORD PTR DX2],AX
@@DO3:
			MOV		AX,[Y3]
			CMP		AX,[Y1]
			JE		@@EQ3

	DB $66;	MOV		AX,[WORD PTR XX3]
	DB $66;	MOV		BX,[WORD PTR XX1]
	DB $66;	SUB		AX,BX

	DB $66;	CWD
			MOV     BX,[Y3]
			SUB		BX,[Y1]
			DB $66, $0F, $BF, $CB				{ MOVSX ECX,BX }
	DB $66;	IDIV	CX
	DB $66;	MOV		[WORD PTR DX3],AX
			JMP		@@DOFILL
@@EQ3:
	DB $66;	XOR		AX,AX
	DB $66;	MOV		[WORD PTR DX3],AX
@@DOFILL:
			MOV		AX,[Y1]
			CMP		AX,[Y2]
			JNE		@@DIFF

	DB $66;	MOV		AX,[WORD PTR XX1]
	DB $66;	MOV		BX,[WORD PTR XX2]
	DB $66;	MOV		CX,[WORD PTR DX1]
	DB $66;	MOV		DX,[WORD PTR DX1]
	DB $66;	CMP		CX,DX
			JGE		@@OK11
	DB $66;	XCHG	AX,BX
@@OK11:
	DB $66;	MOV		[WORD PTR CX1],AX
	DB $66;	MOV		[WORD PTR CX2],BX
			JMP		@@DONE
@@DIFF:
	DB $66;	MOV		AX,[WORD PTR XX1]
	DB $66;	MOV		[WORD PTR CX1],AX
	DB $66;	MOV		[WORD PTR CX2],AX
@@DONE:
			MOV		AX,[Y1]
			MOV		[Y],AX

			CMP		AX,[[ClipY1]]
			JGE		@@OKLINE
			MOV		AX,[[ClipY1]]
@@OKLINE:
			MOV		DI,AX
			SHL		AX,6
			SHL		DI,8
			ADD		DI,AX
@@GO_ON:
			MOV		ES,[VideoSeg]

@@LINELOOP:
			MOV		AX,[Y]
			CMP		AX,[[ClipY1]]
			JL		@@NEXTLINE
			CMP		AX,[[ClipY2]]
			JG		@@ALLLINES

	DB $66;	MOV		AX,[WORD PTR CX1]
	DB $66;	MOV		BX,[WORD PTR CX2]
	DB $66;	CMP		AX,BX
	DB $66;	JLE		@@OK
	DB $66;	XCHG	AX,BX
@@OK:
	DB $66;	XOR		CX,CX
	DB $66;	SAR		AX,Scaler
	DB $66;	ADC		AX,CX
	DB $66;	SAR		BX,Scaler
	DB $66;	ADC		BX,CX
			CMP		AX,[ClipX1]
			JGE		@@OK1_1
			CMP		BX,[ClipX1]
			JGE		@@OK1_1
			JMP		@@NEXTLINE
@@OK1_1:
			CMP		AX,[ClipX2]
			JLE		@@OK1_2
			CMP		BX,[ClipX2]
			JLE		@@OK1_2
			JMP		@@NEXTLINE
@@OK1_2:
			CMP		AX,[ClipX1]
			JGE		@@OK1
			MOV		AX,[ClipX1]
@@OK1:
			CMP		AX,[ClipX2]
			JLE		@@OK2
			MOV		AX,[ClipX2]
@@OK2:
			CMP		BX,[ClipX1]
			JGE		@@OK3
			MOV		BX,[ClipX1]
@@OK3:
			CMP		BX,[ClipX2]
			JLE		@@OK4
			MOV		BX,[ClipX2]
@@OK4:
			MOV		CX,BX
			SUB		CX,AX
			INC		CX
			CLD
			MOV		SI,DI
			ADD		DI,AX
	DB $66;	MOV		AX,[WORD PTR CDWord]
			JCXZ	@@SKIP2
			TEST	DI,$0001
			JZ		@@NOTONE
			SUB		[BYTE PTR ES:DI],AL
			INC		DI
			DEC		CX
			JZ		@@SKIP2
@@NOTONE:
			CMP		CX,2
			JB		@@NOTTWO
			TEST	DI,$0002
			JZ		@@NOTTWO
			SUB		[WORD PTR ES:DI],AX
			ADD		DI,2
			SUB		CX,2
			JZ		@@SKIP2
@@NOTTWO:
			SHR		CX,1
			DB $0F, $92, $C3
			SHR		CX,1
			DB $0F, $92, $C7
			JCXZ	@@SKIP0
@@STOSLOOP:
	DB $66;	SUB		[WORD PTR ES:DI],AX
			ADD		DI,4
			DEC		CX
			JNZ		@@STOSLOOP
@@SKIP0:
			OR		BH,BH
			JZ		@@SKIP1
			SUB		[WORD PTR ES:DI],AX
			ADD		DI,2
@@SKIP1:
			OR		BL,BL
			JZ		@@SKIP2
			SUB		[BYTE PTR ES:DI],AL
			INC		DI
@@SKIP2:
			MOV		DI,SI
@@NEXTLINE:
			MOV		AX,[Y]
			CMP		AX,[ClipY1]
			JL		@@NEXTLINE_2
			ADD		DI,320
@@NEXTLINE_2:
			CMP		AX,[Y1]
			JL		@@LINE2
			CMP		AX,[Y2]
			JGE		@@LINE2
	DB $66;	MOV		AX,[WORD PTR DX1]
	DB $66;	ADD		[WORD PTR CX2],AX
@@LINE2:
			MOV		AX,[Y]
			CMP		AX,[Y1]
			JL		@@LINE3
			CMP		AX,[Y3]
			JGE		@@LINE3
	DB $66;	MOV		AX,[WORD PTR DX3]
	DB $66;	ADD		[WORD PTR CX1],AX
@@LINE3:
			MOV		AX,[Y]
			CMP		AX,[Y2]
			JL		@@EXIT
			CMP		AX,[Y3]
			JG		@@EXIT
	DB $66;	MOV		AX,[WORD PTR DX2]
	DB $66;	ADD		[WORD PTR CX2],AX
@@EXIT:
			INC		[Y]
			MOV		AX,[Y]
			CMP		AX,[Y3]
			JLE		@@LINELOOP
@@ALLLINES:
End;

Procedure XTetraCopy(X1,Y1,X2,Y2,X3,Y3 : Integer; FromSeg,VideoSeg : Word); Assembler;
Var
	XX1		: LongInt;
	XX2		: LongInt;
	XX3		: LongInt;
	DX1		: LongInt;
	DX2		: LongInt;
	DX3		: LongInt;
	Y		: Integer;
	CX1,CX2	: LongInt;
Asm
			CLD
			PUSH	DS
			MOV		DS,[FromSeg]
			MOV		AX,[X1]				{ Initialize registers	}
			MOV		BX,[Y1]
			MOV		CX,[X2]
			MOV		DX,[Y2]
			MOV		SI,[X3]
			MOV		DI,[Y3]

			CMP		BX,DX				{ Calculate min of y1/y2 }
			JLE		@@OK_FIRST_1
			XCHG	AX,CX
			XCHG	BX,DX
@@OK_FIRST_1:
			CMP		BX,DI				{ Calculate min of y2/y3 }
			JLE		@@OK_FIRST_2
			XCHG	AX,SI
			XCHG	BX,DI
@@OK_FIRST_2:
			CMP		DX,DI				{ Calculate min of y1/y3 }
			JLE		@@OK_FIRST_3
			XCHG	CX,SI
			XCHG	DX,DI
@@OK_FIRST_3:
			MOV		[X1],AX				{ Store back in variables }
			MOV		[Y1],BX
			MOV		[X2],CX
			MOV		[Y2],DX
			MOV		[X3],SI
			MOV		[Y3],DI

			CMP		BX,DI
			JNE		@@NONFLAT

			CMP		BX,0
			JL		@@ALLLINES
			CMP		BX,199
			JG		@@ALLLINES
			MOV		DI,BX
			SHL		DI,6
			SHL		BX,8
			ADD		DI,BX
			MOV		ES,[VideoSeg]
			MOV		AX,[X1]
			CMP		AX,[X2]
			JLE		@@FL1
			MOV		AX,[X2]
@@FL1:
			CMP		AX,[X3]
			JLE		@@FL2
			MOV		AX,[X3]
@@FL2:
			MOV		BX,[X1]
			CMP		BX,[X2]
			JGE		@@FL3
			MOV		BX,[X2]
@@FL3:
			CMP		BX,[X3]
			JGE		@@FL4
			MOV		BX,[X3]
@@FL4:
			CMP		AX,0
			JGE		@@FL5
			CMP		BX,0
			JGE		@@FL5
			JMP		@@ALLLINES
@@FL5:
			CMP		AX,319
			JLE		@@FL6
			CMP		BX,319
			JLE		@@FL6
			JMP		@@ALLLINES
@@FL6:
			CMP		AX,0
			JGE		@@FL7
			SUB		AX,AX
@@FL7:
			CMP		BX,319
			JLE		@@FL8
			MOV		BX,319
@@FL8:
			ADD		DI,AX
			MOV		CX,BX
			SUB		CX,AX
			INC		CX
			CLD
			JCXZ	@@FL10
			TEST	DI,$0001
			JZ		@@NOTONE_1
			MOV		AL,[DS:DI]
			MOV		[ES:DI],AL
			INC		DI
			DEC		CX
			JZ		@@FL10
@@NOTONE_1:
			CMP		CX,2
			JB		@@NOTTWO_1
			TEST	DI,$0002
			JZ		@@NOTTWO_1
			MOV		AX,[DS:DI]
			MOV		[ES:DI],AX
			ADD		DI,2
			SUB		CX,2
			JZ		@@FL10
@@NOTTWO_1:
			SHR		CX,1
			DB $0F, $92, $C3
			SHR		CX,1
			DB $0F, $92, $C7
			JCXZ	@@FL9_2
@@FL9:
	DB $66;	MOV		AX,[WORD PTR DS:DI]
	DB $66;	MOV		[WORD PTR ES:DI],AX
			ADD		DI,4
			DEC		CX
			JNZ		@@FL9
@@FL9_2:
			OR		BH,BH
			JZ		@@FL9_3
			MOV		AX,[WORD PTR DS:DI]
			MOV		[WORD PTR ES:DI],AX
			ADD		DI,2
@@FL9_3:
			OR		BL,BL
			JZ		@@FL10
			MOV		AL,[BYTE PTR DS:DI]
			MOV		[BYTE PTR ES:DI],AL
			INC		DI
@@FL10:
			JMP		@@ALLLINES
@@NONFLAT:
			DB $66, $0F, $BF, $46, OFFSET X1	{ MOVSX EAX,[X1] }
			DB $66, $0F, $BF, $5E, OFFSET X2	{ MOVSX EBX,[X2] }
			DB $66, $0F, $BF, $4E, OFFSET X3	{ MOVSX EBX,[X3] }

	DB $66;	SAL		AX,Scaler
	DB $66;	SAL		BX,Scaler
	DB $66;	SAL		CX,Scaler

	DB $66;	MOV		[WORD PTR XX1],AX
	DB $66;	MOV		[WORD PTR XX2],BX
	DB $66;	MOV		[WORD PTR XX3],CX

			MOV		AX,[Y1]
			CMP		AX,[Y2]
			JE		@@EQ1

	DB $66;	MOV		AX,[WORD PTR XX2]
	DB $66;	MOV		BX,[WORD PTR XX1]
	DB $66;	SUB		AX,BX

	DB $66;	CWD
			MOV     BX,[Y2]
			SUB		BX,[Y1]
			DB $66, $0F, $BF, $CB				{ MOVSX ECX,BX }
	DB $66;	IDIV	CX
	DB $66;	MOV		[WORD PTR DX1],AX
			JMP		@@DO2
@@EQ1:
	DB $66;	XOR		AX,AX
	DB $66;	MOV		[WORD PTR DX1],AX
@@DO2:
			MOV		AX,[Y2]
			CMP		AX,[Y3]
			JE		@@EQ2

	DB $66;	MOV		AX,[WORD PTR XX3]
	DB $66;	MOV		BX,[WORD PTR XX2]
	DB $66;	SUB		AX,BX

	DB $66;	CWD
			MOV     BX,[Y3]
			SUB		BX,[Y2]
			DB $66, $0F, $BF, $CB				{ MOVSX ECX,BX }
	DB $66;	IDIV	CX
	DB $66;	MOV		[WORD PTR DX2],AX
			JMP		@@DO3
@@EQ2:
	DB $66;	XOR		AX,AX
	DB $66;	MOV		[WORD PTR DX2],AX
@@DO3:
			MOV		AX,[Y3]
			CMP		AX,[Y1]
			JE		@@EQ3

	DB $66;	MOV		AX,[WORD PTR XX3]
	DB $66;	MOV		BX,[WORD PTR XX1]
	DB $66;	SUB		AX,BX

	DB $66;	CWD
			MOV     BX,[Y3]
			SUB		BX,[Y1]
			DB $66, $0F, $BF, $CB				{ MOVSX ECX,BX }
	DB $66;	IDIV	CX
	DB $66;	MOV		[WORD PTR DX3],AX
			JMP		@@DOFILL
@@EQ3:
	DB $66;	XOR		AX,AX
	DB $66;	MOV		[WORD PTR DX3],AX
@@DOFILL:
			MOV		AX,[Y1]
			CMP		AX,[Y2]
			JNE		@@DIFF

	DB $66;	MOV		AX,[WORD PTR XX1]
	DB $66;	MOV		BX,[WORD PTR XX2]
	DB $66;	MOV		CX,[WORD PTR DX1]
	DB $66;	MOV		DX,[WORD PTR DX1]
	DB $66;	CMP		CX,DX
			JGE		@@OK11
	DB $66;	XCHG	AX,BX
@@OK11:
	DB $66;	MOV		[WORD PTR CX1],AX
	DB $66;	MOV		[WORD PTR CX2],BX
			JMP		@@DONE
@@DIFF:
	DB $66;	MOV		AX,[WORD PTR XX1]
	DB $66;	MOV		[WORD PTR CX1],AX
	DB $66;	MOV		[WORD PTR CX2],AX
@@DONE:
			MOV		AX,[Y1]
			MOV		[Y],AX

			CMP		AX,0
			JGE		@@OKLINE
			SUB		AX,AX
@@OKLINE:
			MOV		DI,AX
			SHL		AX,6
			SHL		DI,8
			ADD		DI,AX
@@GO_ON:
			MOV		ES,[VideoSeg]

@@LINELOOP:
			MOV		AX,[Y]
			CMP		AX,0
			JL		@@NEXTLINE
			CMP		AX,199
			JG		@@ALLLINES

	DB $66;	MOV		AX,[WORD PTR CX1]
	DB $66;	MOV		BX,[WORD PTR CX2]
	DB $66;	CMP		AX,BX
	DB $66;	JLE		@@OK
	DB $66;	XCHG	AX,BX
@@OK:
	DB $66;	XOR		CX,CX
	DB $66;	SAR		AX,Scaler
	DB $66;	ADC		AX,CX
	DB $66;	SAR		BX,Scaler
	DB $66;	ADC		BX,CX
			CMP		AX,0
			JGE		@@OK1_1
			CMP		BX,0
			JGE		@@OK1_1
			JMP		@@NEXTLINE
@@OK1_1:
			CMP		AX,319
			JLE		@@OK1_2
			CMP		BX,319
			JLE		@@OK1_2
			JMP		@@NEXTLINE
@@OK1_2:
			CMP		AX,0
			JGE		@@OK1
			SUB		AX,AX
@@OK1:
			CMP		AX,319
			JLE		@@OK2
			MOV		AX,319
@@OK2:
			CMP		BX,0
			JGE		@@OK3
			SUB		BX,BX
@@OK3:
			CMP		BX,319
			JLE		@@OK4
			MOV		BX,319
@@OK4:
			MOV		CX,BX
			SUB		CX,AX
			INC		CX
			CLD
			MOV		SI,DI
			ADD		DI,AX
			JCXZ	@@SKIP2
			TEST	DI,$0001
			JZ		@@NOTONE
			MOV		AL,[BYTE PTR DS:DI]
			MOV		[BYTE PTR ES:DI],AL
			INC		DI
			DEC		CX
			JZ		@@SKIP2
@@NOTONE:
			CMP		CX,2
			JB		@@NOTTWO
			TEST	DI,$0002
			JZ		@@NOTTWO
			MOV		AX,[WORD PTR DS:DI]
			MOV		[WORD PTR ES:DI],AX
			ADD		DI,2
			SUB		CX,2
			JZ		@@SKIP2
@@NOTTWO:
			SHR		CX,1
			DB $0F, $92, $C3
			SHR		CX,1
			DB $0F, $92, $C7
			JCXZ	@@SKIP0
@@STOSLOOP:
	DB $66;	MOV		AX,[WORD PTR DS:DI]
	DB $66;	MOV		[WORD PTR ES:DI],AX
			ADD		DI,4
			DEC		CX
			JNZ		@@STOSLOOP
@@SKIP0:
			OR		BH,BH
			JZ		@@SKIP1
			MOV		AX,[WORD PTR DS:DI]
			MOV		[WORD PTR ES:DI],AX
			ADD		DI,2
@@SKIP1:
			OR		BL,BL
			JZ		@@SKIP2
			MOV		AL,[BYTE PTR DS:DI]
			MOV		[BYTE PTR ES:DI],AL
			INC		DI
@@SKIP2:
			MOV		DI,SI
@@NEXTLINE:
			MOV		AX,[Y]
			CMP		AX,0
			JL		@@NEXTLINE_2
			ADD		DI,320
@@NEXTLINE_2:
			CMP		AX,[Y1]
			JL		@@LINE2
			CMP		AX,[Y2]
			JGE		@@LINE2
	DB $66;	MOV		AX,[WORD PTR DX1]
	DB $66;	ADD		[WORD PTR CX2],AX
@@LINE2:
			MOV		AX,[Y]
			CMP		AX,[Y1]
			JL		@@LINE3
			CMP		AX,[Y3]
			JGE		@@LINE3
	DB $66;	MOV		AX,[WORD PTR DX3]
	DB $66;	ADD		[WORD PTR CX1],AX
@@LINE3:
			MOV		AX,[Y]
			CMP		AX,[Y2]
			JL		@@EXIT
			CMP		AX,[Y3]
			JG		@@EXIT
	DB $66;	MOV		AX,[WORD PTR DX2]
	DB $66;	ADD		[WORD PTR CX2],AX
@@EXIT:
			INC		[Y]
			MOV		AX,[Y]
			CMP		AX,[Y3]
			JLE		@@LINELOOP
@@ALLLINES:
			POP		DS
End;

Procedure XTetraCopyClip(X1,Y1,X2,Y2,X3,Y3,ClipX1,ClipY1,ClipX2,ClipY2 : Integer;
	FromSeg,VideoSeg : Word); Assembler;
Var
	XX1		: LongInt;
	XX2		: LongInt;
	XX3		: LongInt;
	DX1		: LongInt;
	DX2		: LongInt;
	DX3		: LongInt;
	Y		: Integer;
	CX1,CX2	: LongInt;
Asm
			CLD
			PUSH	DS
			MOV		DS,[FromSeg]
			MOV		AX,[X1]				{ Initialize registers	}
			MOV		BX,[Y1]
			MOV		CX,[X2]
			MOV		DX,[Y2]
			MOV		SI,[X3]
			MOV		DI,[Y3]

			CMP		BX,DX				{ Calculate min of y1/y2 }
			JLE		@@OK_FIRST_1
			XCHG	AX,CX
			XCHG	BX,DX
@@OK_FIRST_1:
			CMP		BX,DI				{ Calculate min of y2/y3 }
			JLE		@@OK_FIRST_2
			XCHG	AX,SI
			XCHG	BX,DI
@@OK_FIRST_2:
			CMP		DX,DI				{ Calculate min of y1/y3 }
			JLE		@@OK_FIRST_3
			XCHG	CX,SI
			XCHG	DX,DI
@@OK_FIRST_3:
			MOV		[X1],AX				{ Store back in variables }
			MOV		[Y1],BX
			MOV		[X2],CX
			MOV		[Y2],DX
			MOV		[X3],SI
			MOV		[Y3],DI

			CMP		BX,DI
			JNE		@@NONFLAT

			CMP		BX,[[ClipY1]]
			JL		@@ALLLINES
			CMP		BX,[[ClipY2]]
			JG		@@ALLLINES
			MOV		DI,BX
			SHL		DI,6
			SHL		BX,8
			ADD		DI,BX
			MOV		ES,[VideoSeg]
			MOV		AX,[X1]
			CMP		AX,[X2]
			JLE		@@FL1
			MOV		AX,[X2]
@@FL1:
			CMP		AX,[X3]
			JLE		@@FL2
			MOV		AX,[X3]
@@FL2:
			MOV		BX,[X1]
			CMP		BX,[X2]
			JGE		@@FL3
			MOV		BX,[X2]
@@FL3:
			CMP		BX,[X3]
			JGE		@@FL4
			MOV		BX,[X3]
@@FL4:
			CMP		AX,[ClipX1]
			JGE		@@FL5
			CMP		BX,[ClipX1]
			JGE		@@FL5
			JMP		@@ALLLINES
@@FL5:
			CMP		AX,[ClipX2]
			JLE		@@FL6
			CMP		BX,[ClipX2]
			JLE		@@FL6
			JMP		@@ALLLINES
@@FL6:
			CMP		AX,[ClipX1]
			JGE		@@FL7
			MOV		AX,[ClipX1]
@@FL7:
			CMP		BX,[ClipX2]
			JLE		@@FL8
			MOV		BX,[ClipX2]
@@FL8:
			ADD		DI,AX
			MOV		CX,BX
			SUB		CX,AX
			INC		CX
			CLD
			JCXZ	@@FL10
			TEST	DI,$0001
			JZ		@@NOTONE_1
			MOV		AL,[DS:DI]
			MOV		[ES:DI],AL
			INC		DI
			DEC		CX
			JZ		@@FL10
@@NOTONE_1:
			CMP		CX,2
			JB		@@NOTTWO_1
			TEST	DI,$0002
			JZ		@@NOTTWO_1
			MOV		AX,[DS:DI]
			MOV		[ES:DI],AX
			ADD		DI,2
			SUB		CX,2
			JZ		@@FL10
@@NOTTWO_1:
			SHR		CX,1
			DB $0F, $92, $C3
			SHR		CX,1
			DB $0F, $92, $C7
			JCXZ	@@FL9_2
@@FL9:
	DB $66;	MOV		AX,[DS:DI]
	DB $66;	MOV		[ES:DI],AX
			ADD		DI,4
			DEC		CX
			JNZ		@@FL9
@@FL9_2:
			OR		BH,BH
			JZ		@@FL9_3
			MOV		AX,[DS:DI]
			MOV		[ES:DI],AX
			ADD		DI,2
@@FL9_3:
			OR		BL,BL
			JZ		@@FL10
			MOV		AL,[DS:DI]
			MOV		[BYTE PTR ES:DI],AL
			INC		DI
@@FL10:
			JMP		@@ALLLINES
@@NONFLAT:
			DB $66, $0F, $BF, $46, OFFSET X1	{ MOVSX EAX,[X1] }
			DB $66, $0F, $BF, $5E, OFFSET X2	{ MOVSX EBX,[X2] }
			DB $66, $0F, $BF, $4E, OFFSET X3	{ MOVSX EBX,[X3] }

	DB $66;	SAL		AX,Scaler
	DB $66;	SAL		BX,Scaler
	DB $66;	SAL		CX,Scaler

	DB $66;	MOV		[WORD PTR XX1],AX
	DB $66;	MOV		[WORD PTR XX2],BX
	DB $66;	MOV		[WORD PTR XX3],CX

			MOV		AX,[Y1]
			CMP		AX,[Y2]
			JE		@@EQ1

	DB $66;	MOV		AX,[WORD PTR XX2]
	DB $66;	MOV		BX,[WORD PTR XX1]
	DB $66;	SUB		AX,BX

	DB $66;	CWD
			MOV     BX,[Y2]
			SUB		BX,[Y1]
			DB $66, $0F, $BF, $CB				{ MOVSX ECX,BX }
	DB $66;	IDIV	CX
	DB $66;	MOV		[WORD PTR DX1],AX
			JMP		@@DO2
@@EQ1:
	DB $66;	XOR		AX,AX
	DB $66;	MOV		[WORD PTR DX1],AX
@@DO2:
			MOV		AX,[Y2]
			CMP		AX,[Y3]
			JE		@@EQ2

	DB $66;	MOV		AX,[WORD PTR XX3]
	DB $66;	MOV		BX,[WORD PTR XX2]
	DB $66;	SUB		AX,BX

	DB $66;	CWD
			MOV     BX,[Y3]
			SUB		BX,[Y2]
			DB $66, $0F, $BF, $CB				{ MOVSX ECX,BX }
	DB $66;	IDIV	CX
	DB $66;	MOV		[WORD PTR DX2],AX
			JMP		@@DO3
@@EQ2:
	DB $66;	XOR		AX,AX
	DB $66;	MOV		[WORD PTR DX2],AX
@@DO3:
			MOV		AX,[Y3]
			CMP		AX,[Y1]
			JE		@@EQ3

	DB $66;	MOV		AX,[WORD PTR XX3]
	DB $66;	MOV		BX,[WORD PTR XX1]
	DB $66;	SUB		AX,BX

	DB $66;	CWD
			MOV     BX,[Y3]
			SUB		BX,[Y1]
			DB $66, $0F, $BF, $CB				{ MOVSX ECX,BX }
	DB $66;	IDIV	CX
	DB $66;	MOV		[WORD PTR DX3],AX
			JMP		@@DOFILL
@@EQ3:
	DB $66;	XOR		AX,AX
	DB $66;	MOV		[WORD PTR DX3],AX
@@DOFILL:
			MOV		AX,[Y1]
			CMP		AX,[Y2]
			JNE		@@DIFF

	DB $66;	MOV		AX,[WORD PTR XX1]
	DB $66;	MOV		BX,[WORD PTR XX2]
	DB $66;	MOV		CX,[WORD PTR DX1]
	DB $66;	MOV		DX,[WORD PTR DX1]
	DB $66;	CMP		CX,DX
			JGE		@@OK11
	DB $66;	XCHG	AX,BX
@@OK11:
	DB $66;	MOV		[WORD PTR CX1],AX
	DB $66;	MOV		[WORD PTR CX2],BX
			JMP		@@DONE
@@DIFF:
	DB $66;	MOV		AX,[WORD PTR XX1]
	DB $66;	MOV		[WORD PTR CX1],AX
	DB $66;	MOV		[WORD PTR CX2],AX
@@DONE:
			MOV		AX,[Y1]
			MOV		[Y],AX

			CMP		AX,[[ClipY1]]
			JGE		@@OKLINE
			MOV		AX,[[ClipY1]]
@@OKLINE:
			MOV		DI,AX
			SHL		AX,6
			SHL		DI,8
			ADD		DI,AX
@@GO_ON:
			MOV		ES,[VideoSeg]

@@LINELOOP:
			MOV		AX,[Y]
			CMP		AX,[[ClipY1]]
			JL		@@NEXTLINE
			CMP		AX,[[ClipY2]]
			JG		@@ALLLINES

	DB $66;	MOV		AX,[WORD PTR CX1]
	DB $66;	MOV		BX,[WORD PTR CX2]
	DB $66;	CMP		AX,BX
	DB $66;	JLE		@@OK
	DB $66;	XCHG	AX,BX
@@OK:
	DB $66;	XOR		CX,CX
	DB $66;	SAR		AX,Scaler
	DB $66;	ADC		AX,CX
	DB $66;	SAR		BX,Scaler
	DB $66;	ADC		BX,CX
			CMP		AX,[ClipX1]
			JGE		@@OK1_1
			CMP		BX,[ClipX1]
			JGE		@@OK1_1
			JMP		@@NEXTLINE
@@OK1_1:
			CMP		AX,[ClipX2]
			JLE		@@OK1_2
			CMP		BX,[ClipX2]
			JLE		@@OK1_2
			JMP		@@NEXTLINE
@@OK1_2:
			CMP		AX,[ClipX1]
			JGE		@@OK1
			MOV		AX,[ClipX1]
@@OK1:
			CMP		AX,[ClipX2]
			JLE		@@OK2
			MOV		AX,[ClipX2]
@@OK2:
			CMP		BX,[ClipX1]
			JGE		@@OK3
			MOV		BX,[ClipX1]
@@OK3:
			CMP		BX,[ClipX2]
			JLE		@@OK4
			MOV		BX,[ClipX2]
@@OK4:
			MOV		CX,BX
			SUB		CX,AX
			INC		CX
			CLD
			MOV		SI,DI
			ADD		DI,AX
			JCXZ	@@SKIP2
			TEST	DI,$0001
			JZ		@@NOTONE
			MOV		AL,[DS:DI]
			MOV		[ES:DI],AL
			INC		DI
			DEC		CX
			JZ		@@SKIP2
@@NOTONE:
			CMP		CX,2
			JB		@@NOTTWO
			TEST	DI,$0002
			JZ		@@NOTTWO
			MOV		AX,[DS:DI]
			MOV		[ES:DI],AX
			ADD		DI,2
			SUB		CX,2
			JZ		@@SKIP2
@@NOTTWO:
			SHR		CX,1
			DB $0F, $92, $C3
			SHR		CX,1
			DB $0F, $92, $C7
			JCXZ	@@SKIP0
@@STOSLOOP:
	DB $66;	MOV		AX,[DS:DI]
	DB $66;	MOV		[ES:DI],AX
			ADD		DI,4
			DEC		CX
			JNZ		@@STOSLOOP
@@SKIP0:
			OR		BH,BH
			JZ		@@SKIP1
			MOV		AX,[DS:DI]
			MOV		[ES:DI],AX
			ADD		DI,2
@@SKIP1:
			OR		BL,BL
			JZ		@@SKIP2
			MOV		AL,[DS:DI]
			MOV		[ES:DI],AL
			INC		DI
@@SKIP2:
			MOV		DI,SI
@@NEXTLINE:
			MOV		AX,[Y]
			CMP		AX,[ClipY1]
			JL		@@NEXTLINE_2
			ADD		DI,320
@@NEXTLINE_2:
			CMP		AX,[Y1]
			JL		@@LINE2
			CMP		AX,[Y2]
			JGE		@@LINE2
	DB $66;	MOV		AX,[WORD PTR DX1]
	DB $66;	ADD		[WORD PTR CX2],AX
@@LINE2:
			MOV		AX,[Y]
			CMP		AX,[Y1]
			JL		@@LINE3
			CMP		AX,[Y3]
			JGE		@@LINE3
	DB $66;	MOV		AX,[WORD PTR DX3]
	DB $66;	ADD		[WORD PTR CX1],AX
@@LINE3:
			MOV		AX,[Y]
			CMP		AX,[Y2]
			JL		@@EXIT
			CMP		AX,[Y3]
			JG		@@EXIT
	DB $66;	MOV		AX,[WORD PTR DX2]
	DB $66;	ADD		[WORD PTR CX2],AX
@@EXIT:
			INC		[Y]
			MOV		AX,[Y]
			CMP		AX,[Y3]
			JLE		@@LINELOOP
@@ALLLINES:
			POP		DS
End;

Procedure XTetraGlenzOR(X1,Y1,X2,Y2,X3,Y3 : Integer; Color : Byte; VideoSeg : Word); Assembler;
Var
	XX1		: LongInt;
	XX2		: LongInt;
	XX3		: LongInt;
	DX1		: LongInt;
	DX2		: LongInt;
	DX3		: LongInt;
	Y		: Integer;
	CX1,CX2	: LongInt;
	CDWord	: LongInt;
Asm
			CLD
			MOV		AL,[Color]
			MOV		AH,AL
			MOV		BX,AX
	DB $66;	SHL		AX,16
			MOV		AX,BX
	DB $66;	MOV		[WORD PTR CDWord],AX

			CMP		[Color],0
			JE		@@ALLLINES
			MOV		AX,[X1]				{ Initialize registers	}
			MOV		BX,[Y1]
			MOV		CX,[X2]
			MOV		DX,[Y2]
			MOV		SI,[X3]
			MOV		DI,[Y3]

			CMP		BX,DX				{ Calculate min of y1/y2 }
			JLE		@@OK_FIRST_1
			XCHG	AX,CX
			XCHG	BX,DX
@@OK_FIRST_1:
			CMP		BX,DI				{ Calculate min of y2/y3 }
			JLE		@@OK_FIRST_2
			XCHG	AX,SI
			XCHG	BX,DI
@@OK_FIRST_2:
			CMP		DX,DI				{ Calculate min of y1/y3 }
			JLE		@@OK_FIRST_3
			XCHG	CX,SI
			XCHG	DX,DI
@@OK_FIRST_3:
			MOV		[X1],AX				{ Store back in variables }
			MOV		[Y1],BX
			MOV		[X2],CX
			MOV		[Y2],DX
			MOV		[X3],SI
			MOV		[Y3],DI
			CMP		DI,BX
			JE		@@ALLLINES
			CMP		BX,DI
			JNE		@@NONFLAT

			CMP		BX,0
			JL		@@ALLLINES
			CMP		BX,199
			JG		@@ALLLINES
			MOV		DI,BX
			SHL		DI,6
			SHL		BX,8
			ADD		DI,BX
			MOV		ES,[VideoSeg]
			MOV		AX,[X1]
			CMP		AX,[X2]
			JLE		@@FL1
			MOV		AX,[X2]
@@FL1:
			CMP		AX,[X3]
			JLE		@@FL2
			MOV		AX,[X3]
@@FL2:
			MOV		BX,[X1]
			CMP		BX,[X2]
			JGE		@@FL3
			MOV		BX,[X2]
@@FL3:
			CMP		BX,[X3]
			JGE		@@FL4
			MOV		BX,[X3]
@@FL4:
			CMP		AX,0
			JGE		@@FL5
			CMP		BX,0
			JGE		@@FL5
			JMP		@@ALLLINES
@@FL5:
			CMP		AX,319
			JLE		@@FL6
			CMP		BX,319
			JLE		@@FL6
			JMP		@@ALLLINES
@@FL6:
			CMP		AX,0
			JGE		@@FL7
			SUB		AX,AX
@@FL7:
			CMP		BX,319
			JLE		@@FL8
			MOV		BX,319
@@FL8:
			ADD		DI,AX
			MOV		CX,BX
			SUB		CX,AX
			INC		CX
			CLD
	DB $66;	MOV		AX,[WORD PTR CDWord]
			JCXZ	@@FL10
			TEST	DI,$0001
			JZ		@@NOTONE_1
			OR		[ES:DI],AL
			INC		DI
			DEC		CX
			JZ		@@FL10
@@NOTONE_1:
			CMP		CX,2
			JB		@@NOTTWO_1
			TEST	DI,$0002
			JZ		@@NOTTWO_1
			OR		[ES:DI],AX
			ADD		DI,2
			SUB		CX,2
			JZ		@@FL10
@@NOTTWO_1:
			SHR		CX,1
			DB $0F, $92, $C3
			SHR		CX,1
			DB $0F, $92, $C7
			JCXZ	@@FL9_2
@@FL9:
	DB $66;	OR		[WORD PTR ES:DI],AX
			ADD		DI,4
			DEC		CX
			JNZ		@@FL9
@@FL9_2:
			OR		BH,BH
			JZ		@@FL9_3
			OR		[WORD PTR ES:DI],AX
			ADD		DI,2
@@FL9_3:
			OR		BL,BL
			JZ		@@FL10
			OR		[BYTE PTR ES:DI],AL
			INC		DI
@@FL10:
			JMP		@@ALLLINES
@@NONFLAT:
			DB $66, $0F, $BF, $46, OFFSET X1	{ MOVSX EAX,[X1] }
			DB $66, $0F, $BF, $5E, OFFSET X2	{ MOVSX EBX,[X2] }
			DB $66, $0F, $BF, $4E, OFFSET X3	{ MOVSX ECX,[X3] }

	DB $66;	SAL		AX,Scaler
	DB $66;	SAL		BX,Scaler
	DB $66;	SAL		CX,Scaler

	DB $66;	MOV		[WORD PTR XX1],AX
	DB $66;	MOV		[WORD PTR XX2],BX
	DB $66;	MOV		[WORD PTR XX3],CX

			MOV		AX,[Y1]
			CMP		AX,[Y2]
			JE		@@EQ1

	DB $66;	MOV		AX,[WORD PTR XX2]
	DB $66;	MOV		BX,[WORD PTR XX1]
	DB $66;	SUB		AX,BX

	DB $66;	CWD
			MOV     BX,[Y2]
			SUB		BX,[Y1]
			DB $66, $0F, $BF, $CB				{ MOVSX ECX,BX }
	DB $66;	IDIV	CX
	DB $66;	MOV		[WORD PTR DX1],AX
			JMP		@@DO2
@@EQ1:
	DB $66;	XOR		AX,AX
	DB $66;	MOV		[WORD PTR DX1],AX
@@DO2:
			MOV		AX,[Y2]
			CMP		AX,[Y3]
			JE		@@EQ2

	DB $66;	MOV		AX,[WORD PTR XX3]
	DB $66;	MOV		BX,[WORD PTR XX2]
	DB $66;	SUB		AX,BX

	DB $66;	CWD
			MOV     BX,[Y3]
			SUB		BX,[Y2]
			DB $66, $0F, $BF, $CB				{ MOVSX ECX,BX }
	DB $66;	IDIV	CX
	DB $66;	MOV		[WORD PTR DX2],AX
			JMP		@@DO3
@@EQ2:
	DB $66;	XOR		AX,AX
	DB $66;	MOV		[WORD PTR DX2],AX
@@DO3:
			MOV		AX,[Y3]
			CMP		AX,[Y1]
			JE		@@EQ3

	DB $66;	MOV		AX,[WORD PTR XX3]
	DB $66;	MOV		BX,[WORD PTR XX1]
	DB $66;	SUB		AX,BX

	DB $66;	CWD
			MOV     BX,[Y3]
			SUB		BX,[Y1]
			DB $66, $0F, $BF, $CB				{ MOVSX ECX,BX }
	DB $66;	IDIV	CX
	DB $66;	MOV		[WORD PTR DX3],AX
			JMP		@@DOFILL
@@EQ3:
	DB $66;	XOR		AX,AX
	DB $66;	MOV		[WORD PTR DX3],AX
@@DOFILL:
			MOV		AX,[Y1]
			CMP		AX,[Y2]
			JNE		@@DIFF

	DB $66;	MOV		AX,[WORD PTR XX1]
	DB $66;	MOV		BX,[WORD PTR XX2]
	DB $66;	MOV		CX,[WORD PTR DX1]
	DB $66;	MOV		DX,[WORD PTR DX1]
	DB $66;	CMP		CX,DX
			JGE		@@OK11
	DB $66;	XCHG	AX,BX
@@OK11:
	DB $66;	MOV		[WORD PTR CX1],AX
	DB $66;	MOV		[WORD PTR CX2],BX
			JMP		@@DONE
@@DIFF:
	DB $66;	MOV		AX,[WORD PTR XX1]
	DB $66;	MOV		[WORD PTR CX1],AX
	DB $66;	MOV		[WORD PTR CX2],AX
@@DONE:
			MOV		AX,[Y1]
			MOV		[Y],AX

			CMP		AX,0
			JGE		@@OKLINE
			SUB		AX,AX
@@OKLINE:
			MOV		DI,AX
			SHL		AX,6
			SHL		DI,8
			ADD		DI,AX
@@GO_ON:
			MOV		ES,[VideoSeg]

@@LINELOOP:
			MOV		AX,[Y]
			CMP		AX,0
			JL		@@NEXTLINE
			CMP		AX,199
			JG		@@ALLLINES

	DB $66;	MOV		AX,[WORD PTR CX1]
	DB $66;	MOV		BX,[WORD PTR CX2]
	DB $66;	CMP		AX,BX
	DB $66;	JLE		@@OK
	DB $66;	XCHG	AX,BX
@@OK:
	DB $66;	XOR		CX,CX
	DB $66;	SAR		AX,Scaler
	DB $66;	ADC		AX,CX
	DB $66;	SAR		BX,Scaler
	DB $66;	ADC		BX,CX
			CMP		AX,0
			JGE		@@OK1_1
			CMP		BX,0
			JGE		@@OK1_1
			JMP		@@NEXTLINE
@@OK1_1:
			CMP		AX,319
			JLE		@@OK1_2
			CMP		BX,319
			JLE		@@OK1_2
			JMP		@@NEXTLINE
@@OK1_2:
			CMP		AX,0
			JGE		@@OK1
			SUB		AX,AX
@@OK1:
			CMP		AX,319
			JLE		@@OK2
			MOV		AX,319
@@OK2:
			CMP		BX,0
			JGE		@@OK3
			SUB		BX,BX
@@OK3:
			CMP		BX,319
			JLE		@@OK4
			MOV		BX,319
@@OK4:
			MOV		CX,BX
			SUB		CX,AX
			INC		CX
			CLD
			MOV		SI,DI
			ADD		DI,AX
	DB $66;	MOV		AX,[WORD PTR CDWord]
			JCXZ	@@SKIP2
			TEST	DI,$0001
			JZ		@@NOTONE
			OR		[BYTE PTR ES:DI],AL
			INC		DI
			DEC		CX
			JZ		@@SKIP2
@@NOTONE:
			CMP		CX,2
			JB		@@NOTTWO
			TEST	DI,$0002
			JZ		@@NOTTWO
			OR		[WORD PTR ES:DI],AX
			ADD		DI,2
			SUB		CX,2
			JZ		@@SKIP2
@@NOTTWO:
			SHR		CX,1
			DB $0F, $92, $C3
			SHR		CX,1
			DB $0F, $92, $C7
			JCXZ	@@SKIP0
@@STOSLOOP:
	DB $66;	OR		[WORD PTR ES:DI],AX
			ADD		DI,4
			DEC		CX
			JNZ		@@STOSLOOP
@@SKIP0:
			OR		BH,BH
			JZ		@@SKIP1
			OR		[WORD PTR ES:DI],AX
			ADD		DI,2
@@SKIP1:
			OR		BL,BL
			JZ		@@SKIP2
			OR		[BYTE PTR ES:DI],AL
			INC		DI
@@SKIP2:
			MOV		DI,SI
@@NEXTLINE:
			MOV		AX,[Y]
			CMP		AX,0
			JL		@@NEXTLINE_2
			ADD		DI,320
@@NEXTLINE_2:
			CMP		AX,[Y1]
			JL		@@LINE2
			CMP		AX,[Y2]
			JGE		@@LINE2
	DB $66;	MOV		AX,[WORD PTR DX1]
	DB $66;	ADD		[WORD PTR CX2],AX
@@LINE2:
			MOV		AX,[Y]
			CMP		AX,[Y1]
			JL		@@LINE3
			CMP		AX,[Y3]
			JGE		@@LINE3
	DB $66;	MOV		AX,[WORD PTR DX3]
	DB $66;	ADD		[WORD PTR CX1],AX
@@LINE3:
			MOV		AX,[Y]
			CMP		AX,[Y2]
			JL		@@EXIT
			CMP		AX,[Y3]
			JG		@@EXIT
	DB $66;	MOV		AX,[WORD PTR DX2]
	DB $66;	ADD		[WORD PTR CX2],AX
@@EXIT:
			INC		[Y]
			MOV		AX,[Y]
			CMP		AX,[Y3]
			JLE		@@LINELOOP
@@ALLLINES:
End;

Procedure XTetraGlenzORClip(X1,Y1,X2,Y2,X3,Y3,ClipX1,ClipY1,ClipX2,ClipY2 : Integer;
	Color : Byte; VideoSeg : Word); Assembler;
Var
	XX1		: LongInt;
	XX2		: LongInt;
	XX3		: LongInt;
	DX1		: LongInt;
	DX2		: LongInt;
	DX3		: LongInt;
	Y		: Integer;
	CX1,CX2	: LongInt;
	CDWord	: LongInt;
Asm
			CLD
			MOV		AL,[Color]
			MOV		AH,AL
			MOV		BX,AX
	DB $66;	SHL		AX,16
			MOV		AX,BX
	DB $66;	MOV		[WORD PTR CDWord],AX

			CMP		[Color],0
			JE		@@ALLLINES
			MOV		AX,[X1]				{ Initialize registers	}
			MOV		BX,[Y1]
			MOV		CX,[X2]
			MOV		DX,[Y2]
			MOV		SI,[X3]
			MOV		DI,[Y3]

			CMP		BX,DX				{ Calculate min of y1/y2 }
			JLE		@@OK_FIRST_1
			XCHG	AX,CX
			XCHG	BX,DX
@@OK_FIRST_1:
			CMP		BX,DI				{ Calculate min of y2/y3 }
			JLE		@@OK_FIRST_2
			XCHG	AX,SI
			XCHG	BX,DI
@@OK_FIRST_2:
			CMP		DX,DI				{ Calculate min of y1/y3 }
			JLE		@@OK_FIRST_3
			XCHG	CX,SI
			XCHG	DX,DI
@@OK_FIRST_3:
			MOV		[X1],AX				{ Store back in variables }
			MOV		[Y1],BX
			MOV		[X2],CX
			MOV		[Y2],DX
			MOV		[X3],SI
			MOV		[Y3],DI
			CMP		DI,BX
			JE		@@ALLLINES
			CMP		BX,DI
			JNE		@@NONFLAT

			CMP		BX,[ClipY1]
			JL		@@ALLLINES
			CMP		BX,[ClipY2]
			JG		@@ALLLINES
			MOV		DI,BX
			SHL		DI,6
			SHL		BX,8
			ADD		DI,BX
			MOV		ES,[VideoSeg]
			MOV		AX,[X1]
			CMP		AX,[X2]
			JLE		@@FL1
			MOV		AX,[X2]
@@FL1:
			CMP		AX,[X3]
			JLE		@@FL2
			MOV		AX,[X3]
@@FL2:
			MOV		BX,[X1]
			CMP		BX,[X2]
			JGE		@@FL3
			MOV		BX,[X2]
@@FL3:
			CMP		BX,[X3]
			JGE		@@FL4
			MOV		BX,[X3]
@@FL4:
			CMP		AX,[ClipX1]
			JGE		@@FL5
			CMP		BX,[ClipX1]
			JGE		@@FL5
			JMP		@@ALLLINES
@@FL5:
			CMP		AX,[ClipX2]
			JLE		@@FL6
			CMP		BX,[ClipX2]
			JLE		@@FL6
			JMP		@@ALLLINES
@@FL6:
			CMP		AX,[ClipX1]
			JGE		@@FL7
			MOV		AX,[ClipX1]
@@FL7:
			CMP		BX,[ClipX2]
			JLE		@@FL8
			MOV		BX,[ClipX2]
@@FL8:
			ADD		DI,AX
			MOV		CX,BX
			SUB		CX,AX
			INC		CX
			CLD
	DB $66;	MOV		AX,[WORD PTR CDWord]
			JCXZ	@@FL10
			TEST	DI,$0001
			JZ		@@NOTONE_1
			OR		[ES:DI],AL
			INC		DI
			DEC		CX
			JZ		@@FL10
@@NOTONE_1:
			CMP		CX,2
			JB		@@NOTTWO_1
			TEST	DI,$0002
			JZ		@@NOTTWO_1
			OR		[ES:DI],AX
			ADD		DI,2
			SUB		CX,2
			JZ		@@FL10
@@NOTTWO_1:
			SHR		CX,1
			DB $0F, $92, $C3
			SHR		CX,1
			DB $0F, $92, $C7
			JCXZ	@@FL9_2
@@FL9:
	DB $66;	OR		[WORD PTR ES:DI],AX
			ADD		DI,4
			DEC		CX
			JNZ		@@FL9
@@FL9_2:
			OR		BH,BH
			JZ		@@FL9_3
			OR		[WORD PTR ES:DI],AX
			ADD		DI,2
@@FL9_3:
			OR		BL,BL
			JZ		@@FL10
			OR		[BYTE PTR ES:DI],AL
			INC		DI
@@FL10:
			JMP		@@ALLLINES
@@NONFLAT:
			DB $66, $0F, $BF, $46, OFFSET X1	{ MOVSX EAX,[X1] }
			DB $66, $0F, $BF, $5E, OFFSET X2	{ MOVSX EBX,[X2] }
			DB $66, $0F, $BF, $4E, OFFSET X3	{ MOVSX ECX,[X3] }

	DB $66;	SAL		AX,Scaler
	DB $66;	SAL		BX,Scaler
	DB $66;	SAL		CX,Scaler

	DB $66;	MOV		[WORD PTR XX1],AX
	DB $66;	MOV		[WORD PTR XX2],BX
	DB $66;	MOV		[WORD PTR XX3],CX

			MOV		AX,[Y1]
			CMP		AX,[Y2]
			JE		@@EQ1

	DB $66;	MOV		AX,[WORD PTR XX2]
	DB $66;	MOV		BX,[WORD PTR XX1]
	DB $66;	SUB		AX,BX

	DB $66;	CWD
			MOV     BX,[Y2]
			SUB		BX,[Y1]
			DB $66, $0F, $BF, $CB				{ MOVSX ECX,BX }
	DB $66;	IDIV	CX
	DB $66;	MOV		[WORD PTR DX1],AX
			JMP		@@DO2
@@EQ1:
	DB $66;	XOR		AX,AX
	DB $66;	MOV		[WORD PTR DX1],AX
@@DO2:
			MOV		AX,[Y2]
			CMP		AX,[Y3]
			JE		@@EQ2

	DB $66;	MOV		AX,[WORD PTR XX3]
	DB $66;	MOV		BX,[WORD PTR XX2]
	DB $66;	SUB		AX,BX

	DB $66;	CWD
			MOV     BX,[Y3]
			SUB		BX,[Y2]
			DB $66, $0F, $BF, $CB				{ MOVSX ECX,BX }
	DB $66;	IDIV	CX
	DB $66;	MOV		[WORD PTR DX2],AX
			JMP		@@DO3
@@EQ2:
	DB $66;	XOR		AX,AX
	DB $66;	MOV		[WORD PTR DX2],AX
@@DO3:
			MOV		AX,[Y3]
			CMP		AX,[Y1]
			JE		@@EQ3

	DB $66;	MOV		AX,[WORD PTR XX3]
	DB $66;	MOV		BX,[WORD PTR XX1]
	DB $66;	SUB		AX,BX

	DB $66;	CWD
			MOV     BX,[Y3]
			SUB		BX,[Y1]
			DB $66, $0F, $BF, $CB				{ MOVSX ECX,BX }
	DB $66;	IDIV	CX
	DB $66;	MOV		[WORD PTR DX3],AX
			JMP		@@DOFILL
@@EQ3:
	DB $66;	XOR		AX,AX
	DB $66;	MOV		[WORD PTR DX3],AX
@@DOFILL:
			MOV		AX,[Y1]
			CMP		AX,[Y2]
			JNE		@@DIFF

	DB $66;	MOV		AX,[WORD PTR XX1]
	DB $66;	MOV		BX,[WORD PTR XX2]
	DB $66;	MOV		CX,[WORD PTR DX1]
	DB $66;	MOV		DX,[WORD PTR DX1]
	DB $66;	CMP		CX,DX
			JGE		@@OK11
	DB $66;	XCHG	AX,BX
@@OK11:
	DB $66;	MOV		[WORD PTR CX1],AX
	DB $66;	MOV		[WORD PTR CX2],BX
			JMP		@@DONE
@@DIFF:
	DB $66;	MOV		AX,[WORD PTR XX1]
	DB $66;	MOV		[WORD PTR CX1],AX
	DB $66;	MOV		[WORD PTR CX2],AX
@@DONE:
			MOV		AX,[Y1]
			MOV		[Y],AX

			CMP		AX,[ClipY1]
			JGE		@@OKLINE
			MOV		AX,[ClipY1]
@@OKLINE:
			MOV		DI,AX
			SHL		AX,6
			SHL		DI,8
			ADD		DI,AX
@@GO_ON:
			MOV		ES,[VideoSeg]

@@LINELOOP:
			MOV		AX,[Y]
			CMP		AX,[[ClipY1]]
			JL		@@NEXTLINE
			CMP		AX,[[ClipY2]]
			JG		@@ALLLINES

	DB $66;	MOV		AX,[WORD PTR CX1]
	DB $66;	MOV		BX,[WORD PTR CX2]
	DB $66;	CMP		AX,BX
	DB $66;	JLE		@@OK
	DB $66;	XCHG	AX,BX
@@OK:
	DB $66;	XOR		CX,CX
	DB $66;	SAR		AX,Scaler
	DB $66;	ADC		AX,CX
	DB $66;	SAR		BX,Scaler
	DB $66;	ADC		BX,CX
			CMP		AX,[ClipX1]
			JGE		@@OK1_1
			CMP		BX,[ClipX1]
			JGE		@@OK1_1
			JMP		@@NEXTLINE
@@OK1_1:
			CMP		AX,[ClipX2]
			JLE		@@OK1_2
			CMP		BX,[ClipX2]
			JLE		@@OK1_2
			JMP		@@NEXTLINE
@@OK1_2:
			CMP		AX,[ClipX1]
			JGE		@@OK1
			MOV		AX,[ClipX1]
@@OK1:
			CMP		AX,[ClipX2]
			JLE		@@OK2
			MOV		AX,[ClipX2]
@@OK2:
			CMP		BX,[ClipX1]
			JGE		@@OK3
			MOV		BX,[ClipX1]
@@OK3:
			CMP		BX,[ClipX2]
			JLE		@@OK4
			MOV		BX,[ClipX2]
@@OK4:
			MOV		CX,BX
			SUB		CX,AX
			INC		CX
			CLD
			MOV		SI,DI
			ADD		DI,AX
	DB $66;	MOV		AX,[WORD PTR CDWord]
			JCXZ	@@SKIP2
			TEST	DI,$0001
			JZ		@@NOTONE
			OR		[BYTE PTR ES:DI],AL
			INC		DI
			DEC		CX
			JZ		@@SKIP2
@@NOTONE:
			CMP		CX,2
			JB		@@NOTTWO
			TEST	DI,$0002
			JZ		@@NOTTWO
			OR		[WORD PTR ES:DI],AX
			ADD		DI,2
			SUB		CX,2
			JZ		@@SKIP2
@@NOTTWO:
			SHR		CX,1
			DB $0F, $92, $C3
			SHR		CX,1
			DB $0F, $92, $C7
			JCXZ	@@SKIP0
@@STOSLOOP:
	DB $66;	OR		[WORD PTR ES:DI],AX
			ADD		DI,4
			DEC		CX
			JNZ		@@STOSLOOP
@@SKIP0:
			OR		BH,BH
			JZ		@@SKIP1
			OR		[WORD PTR ES:DI],AX
			ADD		DI,2
@@SKIP1:
			OR		BL,BL
			JZ		@@SKIP2
			OR		[BYTE PTR ES:DI],AL
			INC		DI
@@SKIP2:
			MOV		DI,SI
@@NEXTLINE:
			MOV		AX,[Y]
			CMP		AX,[ClipY1]
			JL		@@NEXTLINE_2
			ADD		DI,320
@@NEXTLINE_2:
			CMP		AX,[Y1]
			JL		@@LINE2
			CMP		AX,[Y2]
			JGE		@@LINE2
	DB $66;	MOV		AX,[WORD PTR DX1]
	DB $66;	ADD		[WORD PTR CX2],AX
@@LINE2:
			MOV		AX,[Y]
			CMP		AX,[Y1]
			JL		@@LINE3
			CMP		AX,[Y3]
			JGE		@@LINE3
	DB $66;	MOV		AX,[WORD PTR DX3]
	DB $66;	ADD		[WORD PTR CX1],AX
@@LINE3:
			MOV		AX,[Y]
			CMP		AX,[Y2]
			JL		@@EXIT
			CMP		AX,[Y3]
			JG		@@EXIT
	DB $66;	MOV		AX,[WORD PTR DX2]
	DB $66;	ADD		[WORD PTR CX2],AX
@@EXIT:
			INC		[Y]
			MOV		AX,[Y]
			CMP		AX,[Y3]
			JLE		@@LINELOOP
@@ALLLINES:
End;

Procedure XTetraGlenzAND(X1,Y1,X2,Y2,X3,Y3 : Integer; Color : Byte; VideoSeg : Word); Assembler;
Var
	XX1		: LongInt;
	XX2		: LongInt;
	XX3		: LongInt;
	DX1		: LongInt;
	DX2		: LongInt;
	DX3		: LongInt;
	Y		: Integer;
	CX1,CX2	: LongInt;
	CDWord	: LongInt;
Asm
			CLD
			MOV		AL,[Color]
			MOV		AH,AL
			MOV		BX,AX
	DB $66;	SHL		AX,16
			MOV		AX,BX
	DB $66;	MOV		[WORD PTR CDWord],AX

			CMP		[Color],0
			JE		@@ALLLINES
			MOV		AX,[X1]				{ Initialize registers	}
			MOV		BX,[Y1]
			MOV		CX,[X2]
			MOV		DX,[Y2]
			MOV		SI,[X3]
			MOV		DI,[Y3]

			CMP		BX,DX				{ Calculate min of y1/y2 }
			JLE		@@OK_FIRST_1
			XCHG	AX,CX
			XCHG	BX,DX
@@OK_FIRST_1:
			CMP		BX,DI				{ Calculate min of y2/y3 }
			JLE		@@OK_FIRST_2
			XCHG	AX,SI
			XCHG	BX,DI
@@OK_FIRST_2:
			CMP		DX,DI				{ Calculate min of y1/y3 }
			JLE		@@OK_FIRST_3
			XCHG	CX,SI
			XCHG	DX,DI
@@OK_FIRST_3:
			MOV		[X1],AX				{ Store back in variables }
			MOV		[Y1],BX
			MOV		[X2],CX
			MOV		[Y2],DX
			MOV		[X3],SI
			MOV		[Y3],DI

			CMP		BX,DI
			JNE		@@NONFLAT

			CMP		BX,0
			JL		@@ALLLINES
			CMP		BX,199
			JG		@@ALLLINES
			MOV		DI,BX
			SHL		DI,6
			SHL		BX,8
			ADD		DI,BX
			MOV		ES,[VideoSeg]
			MOV		AX,[X1]
			CMP		AX,[X2]
			JLE		@@FL1
			MOV		AX,[X2]
@@FL1:
			CMP		AX,[X3]
			JLE		@@FL2
			MOV		AX,[X3]
@@FL2:
			MOV		BX,[X1]
			CMP		BX,[X2]
			JGE		@@FL3
			MOV		BX,[X2]
@@FL3:
			CMP		BX,[X3]
			JGE		@@FL4
			MOV		BX,[X3]
@@FL4:
			CMP		AX,0
			JGE		@@FL5
			CMP		BX,0
			JGE		@@FL5
			JMP		@@ALLLINES
@@FL5:
			CMP		AX,319
			JLE		@@FL6
			CMP		BX,319
			JLE		@@FL6
			JMP		@@ALLLINES
@@FL6:
			CMP		AX,0
			JGE		@@FL7
			SUB		AX,AX
@@FL7:
			CMP		BX,319
			JLE		@@FL8
			MOV		BX,319
@@FL8:
			ADD		DI,AX
			MOV		CX,BX
			SUB		CX,AX
			INC		CX
			CLD
	DB $66;	MOV		AX,[WORD PTR CDWord]
			JCXZ	@@FL10
			TEST	DI,$0001
			JZ		@@NOTONE_1
			AND		[ES:DI],AL
			INC		DI
			DEC		CX
			JZ		@@FL10
@@NOTONE_1:
			CMP		CX,2
			JB		@@NOTTWO_1
			TEST	DI,$0002
			JZ		@@NOTTWO_1
			AND		[ES:DI],AX
			ADD		DI,2
			SUB		CX,2
			JZ		@@FL10
@@NOTTWO_1:
			SHR		CX,1
			DB $0F, $92, $C3
			SHR		CX,1
			DB $0F, $92, $C7
			JCXZ	@@FL9_2
@@FL9:
	DB $66;	AND		[WORD PTR ES:DI],AX
			ADD		DI,4
			DEC		CX
			JNZ		@@FL9
@@FL9_2:
			OR		BH,BH
			JZ		@@FL9_3
			AND		[WORD PTR ES:DI],AX
			ADD		DI,2
@@FL9_3:
			OR		BL,BL
			JZ		@@FL10
			AND		[BYTE PTR ES:DI],AL
			INC		DI
@@FL10:
			JMP		@@ALLLINES
@@NONFLAT:
			DB $66, $0F, $BF, $46, OFFSET X1	{ MOVSX EAX,[X1] }
			DB $66, $0F, $BF, $5E, OFFSET X2	{ MOVSX EBX,[X2] }
			DB $66, $0F, $BF, $4E, OFFSET X3	{ MOVSX EBX,[X3] }

	DB $66;	SAL		AX,Scaler
	DB $66;	SAL		BX,Scaler
	DB $66;	SAL		CX,Scaler

	DB $66;	MOV		[WORD PTR XX1],AX
	DB $66;	MOV		[WORD PTR XX2],BX
	DB $66;	MOV		[WORD PTR XX3],CX

			MOV		AX,[Y1]
			CMP		AX,[Y2]
			JE		@@EQ1

	DB $66;	MOV		AX,[WORD PTR XX2]
	DB $66;	MOV		BX,[WORD PTR XX1]
	DB $66;	SUB		AX,BX

	DB $66;	CWD
			MOV     BX,[Y2]
			SUB		BX,[Y1]
			DB $66, $0F, $BF, $CB				{ MOVSX ECX,BX }
	DB $66;	IDIV	CX
	DB $66;	MOV		[WORD PTR DX1],AX
			JMP		@@DO2
@@EQ1:
	DB $66;	XOR		AX,AX
	DB $66;	MOV		[WORD PTR DX1],AX
@@DO2:
			MOV		AX,[Y2]
			CMP		AX,[Y3]
			JE		@@EQ2

	DB $66;	MOV		AX,[WORD PTR XX3]
	DB $66;	MOV		BX,[WORD PTR XX2]
	DB $66;	SUB		AX,BX

	DB $66;	CWD
			MOV     BX,[Y3]
			SUB		BX,[Y2]
			DB $66, $0F, $BF, $CB				{ MOVSX ECX,BX }
	DB $66;	IDIV	CX
	DB $66;	MOV		[WORD PTR DX2],AX
			JMP		@@DO3
@@EQ2:
	DB $66;	XOR		AX,AX
	DB $66;	MOV		[WORD PTR DX2],AX
@@DO3:
			MOV		AX,[Y3]
			CMP		AX,[Y1]
			JE		@@EQ3

	DB $66;	MOV		AX,[WORD PTR XX3]
	DB $66;	MOV		BX,[WORD PTR XX1]
	DB $66;	SUB		AX,BX

	DB $66;	CWD
			MOV     BX,[Y3]
			SUB		BX,[Y1]
			DB $66, $0F, $BF, $CB				{ MOVSX ECX,BX }
	DB $66;	IDIV	CX
	DB $66;	MOV		[WORD PTR DX3],AX
			JMP		@@DOFILL
@@EQ3:
	DB $66;	XOR		AX,AX
	DB $66;	MOV		[WORD PTR DX3],AX
@@DOFILL:
			MOV		AX,[Y1]
			CMP		AX,[Y2]
			JNE		@@DIFF

	DB $66;	MOV		AX,[WORD PTR XX1]
	DB $66;	MOV		BX,[WORD PTR XX2]
	DB $66;	MOV		CX,[WORD PTR DX1]
	DB $66;	MOV		DX,[WORD PTR DX1]
	DB $66;	CMP		CX,DX
			JGE		@@OK11
	DB $66;	XCHG	AX,BX
@@OK11:
	DB $66;	MOV		[WORD PTR CX1],AX
	DB $66;	MOV		[WORD PTR CX2],BX
			JMP		@@DONE
@@DIFF:
	DB $66;	MOV		AX,[WORD PTR XX1]
	DB $66;	MOV		[WORD PTR CX1],AX
	DB $66;	MOV		[WORD PTR CX2],AX
@@DONE:
			MOV		AX,[Y1]
			MOV		[Y],AX

			CMP		AX,0
			JGE		@@OKLINE
			SUB		AX,AX
@@OKLINE:
			MOV		DI,AX
			SHL		AX,6
			SHL		DI,8
			ADD		DI,AX
@@GO_ON:
			MOV		ES,[VideoSeg]

@@LINELOOP:
			MOV		AX,[Y]
			CMP		AX,0
			JL		@@NEXTLINE
			CMP		AX,199
			JG		@@ALLLINES

	DB $66;	MOV		AX,[WORD PTR CX1]
	DB $66;	MOV		BX,[WORD PTR CX2]
	DB $66;	CMP		AX,BX
	DB $66;	JLE		@@OK
	DB $66;	XCHG	AX,BX
@@OK:
	DB $66;	XOR		CX,CX
	DB $66;	SAR		AX,Scaler
	DB $66;	ADC		AX,CX
	DB $66;	SAR		BX,Scaler
	DB $66;	ADC		BX,CX
			CMP		AX,0
			JGE		@@OK1_1
			CMP		BX,0
			JGE		@@OK1_1
			JMP		@@NEXTLINE
@@OK1_1:
			CMP		AX,319
			JLE		@@OK1_2
			CMP		BX,319
			JLE		@@OK1_2
			JMP		@@NEXTLINE
@@OK1_2:
			CMP		AX,0
			JGE		@@OK1
			SUB		AX,AX
@@OK1:
			CMP		AX,319
			JLE		@@OK2
			MOV		AX,319
@@OK2:
			CMP		BX,0
			JGE		@@OK3
			SUB		BX,BX
@@OK3:
			CMP		BX,319
			JLE		@@OK4
			MOV		BX,319
@@OK4:
			MOV		CX,BX
			SUB		CX,AX
			INC		CX
			CLD
			MOV		SI,DI
			ADD		DI,AX
	DB $66;	MOV		AX,[WORD PTR CDWord]
			JCXZ	@@SKIP2
			TEST	DI,$0001
			JZ		@@NOTONE
			AND		[BYTE PTR ES:DI],AL
			INC		DI
			DEC		CX
			JZ		@@SKIP2
@@NOTONE:
			CMP		CX,2
			JB		@@NOTTWO
			TEST	DI,$0002
			JZ		@@NOTTWO
			AND		[WORD PTR ES:DI],AX
			ADD		DI,2
			SUB		CX,2
			JZ		@@SKIP2
@@NOTTWO:
			SHR		CX,1
			DB $0F, $92, $C3
			SHR		CX,1
			DB $0F, $92, $C7
			JCXZ	@@SKIP0
@@STOSLOOP:
	DB $66;	AND		[WORD PTR ES:DI],AX
			ADD		DI,4
			DEC		CX
			JNZ		@@STOSLOOP
@@SKIP0:
			OR		BH,BH
			JZ		@@SKIP1
			AND		[WORD PTR ES:DI],AX
			ADD		DI,2
@@SKIP1:
			OR		BL,BL
			JZ		@@SKIP2
			AND		[BYTE PTR ES:DI],AL
			INC		DI
@@SKIP2:
			MOV		DI,SI
@@NEXTLINE:
			MOV		AX,[Y]
			CMP		AX,0
			JL		@@NEXTLINE_2
			ADD		DI,320
@@NEXTLINE_2:
			CMP		AX,[Y1]
			JL		@@LINE2
			CMP		AX,[Y2]
			JGE		@@LINE2
	DB $66;	MOV		AX,[WORD PTR DX1]
	DB $66;	ADD		[WORD PTR CX2],AX
@@LINE2:
			MOV		AX,[Y]
			CMP		AX,[Y1]
			JL		@@LINE3
			CMP		AX,[Y3]
			JGE		@@LINE3
	DB $66;	MOV		AX,[WORD PTR DX3]
	DB $66;	ADD		[WORD PTR CX1],AX
@@LINE3:
			MOV		AX,[Y]
			CMP		AX,[Y2]
			JL		@@EXIT
			CMP		AX,[Y3]
			JG		@@EXIT
	DB $66;	MOV		AX,[WORD PTR DX2]
	DB $66;	ADD		[WORD PTR CX2],AX
@@EXIT:
			INC		[Y]
			MOV		AX,[Y]
			CMP		AX,[Y3]
			JLE		@@LINELOOP
@@ALLLINES:
End;

Procedure XTetraGlenzANDClip(X1,Y1,X2,Y2,X3,Y3,ClipX1,ClipY1,ClipX2,ClipY2 : Integer;
	Color : Byte; VideoSeg : Word); Assembler;
Var
	XX1		: LongInt;
	XX2		: LongInt;
	XX3		: LongInt;
	DX1		: LongInt;
	DX2		: LongInt;
	DX3		: LongInt;
	Y		: Integer;
	CX1,CX2	: LongInt;
	CDWord	: LongInt;
Asm
			CLD
			MOV		AL,[Color]
			MOV		AH,AL
			MOV		BX,AX
	DB $66;	SHL		AX,16
			MOV		AX,BX
	DB $66;	MOV		[WORD PTR CDWord],AX

			CMP		[Color],0
			JE		@@ALLLINES
			MOV		AX,[X1]				{ Initialize registers	}
			MOV		BX,[Y1]
			MOV		CX,[X2]
			MOV		DX,[Y2]
			MOV		SI,[X3]
			MOV		DI,[Y3]

			CMP		BX,DX				{ Calculate min of y1/y2 }
			JLE		@@OK_FIRST_1
			XCHG	AX,CX
			XCHG	BX,DX
@@OK_FIRST_1:
			CMP		BX,DI				{ Calculate min of y2/y3 }
			JLE		@@OK_FIRST_2
			XCHG	AX,SI
			XCHG	BX,DI
@@OK_FIRST_2:
			CMP		DX,DI				{ Calculate min of y1/y3 }
			JLE		@@OK_FIRST_3
			XCHG	CX,SI
			XCHG	DX,DI
@@OK_FIRST_3:
			MOV		[X1],AX				{ Store back in variables }
			MOV		[Y1],BX
			MOV		[X2],CX
			MOV		[Y2],DX
			MOV		[X3],SI
			MOV		[Y3],DI

			CMP		BX,DI
			JNE		@@NONFLAT

			CMP		BX,[[ClipY1]]
			JL		@@ALLLINES
			CMP		BX,[[ClipY2]]
			JG		@@ALLLINES
			MOV		DI,BX
			SHL		DI,6
			SHL		BX,8
			ADD		DI,BX
			MOV		ES,[VideoSeg]
			MOV		AX,[X1]
			CMP		AX,[X2]
			JLE		@@FL1
			MOV		AX,[X2]
@@FL1:
			CMP		AX,[X3]
			JLE		@@FL2
			MOV		AX,[X3]
@@FL2:
			MOV		BX,[X1]
			CMP		BX,[X2]
			JGE		@@FL3
			MOV		BX,[X2]
@@FL3:
			CMP		BX,[X3]
			JGE		@@FL4
			MOV		BX,[X3]
@@FL4:
			CMP		AX,[ClipX1]
			JGE		@@FL5
			CMP		BX,[ClipX1]
			JGE		@@FL5
			JMP		@@ALLLINES
@@FL5:
			CMP		AX,[ClipX2]
			JLE		@@FL6
			CMP		BX,[ClipX2]
			JLE		@@FL6
			JMP		@@ALLLINES
@@FL6:
			CMP		AX,[ClipX1]
			JGE		@@FL7
			MOV		AX,[ClipX1]
@@FL7:
			CMP		BX,[ClipX2]
			JLE		@@FL8
			MOV		BX,[ClipX2]
@@FL8:
			ADD		DI,AX
			MOV		CX,BX
			SUB		CX,AX
			INC		CX
			CLD
	DB $66;	MOV		AX,[WORD PTR CDWord]
			JCXZ	@@FL10
			TEST	DI,$0001
			JZ		@@NOTONE_1
			AND		[ES:DI],AL
			INC		DI
			DEC		CX
			JZ		@@FL10
@@NOTONE_1:
			CMP		CX,2
			JB		@@NOTTWO_1
			TEST	DI,$0002
			JZ		@@NOTTWO_1
			AND		[ES:DI],AX
			ADD		DI,2
			SUB		CX,2
			JZ		@@FL10
@@NOTTWO_1:
			SHR		CX,1
			DB $0F, $92, $C3
			SHR		CX,1
			DB $0F, $92, $C7
			JCXZ	@@FL9_2
@@FL9:
	DB $66;	AND		[WORD PTR ES:DI],AX
			ADD		DI,4
			DEC		CX
			JNZ		@@FL9
@@FL9_2:
			OR		BH,BH
			JZ		@@FL9_3
			AND		[WORD PTR ES:DI],AX
			ADD		DI,2
@@FL9_3:
			OR		BL,BL
			JZ		@@FL10
			AND		[BYTE PTR ES:DI],AL
			INC		DI
@@FL10:
			JMP		@@ALLLINES
@@NONFLAT:
			DB $66, $0F, $BF, $46, OFFSET X1	{ MOVSX EAX,[X1] }
			DB $66, $0F, $BF, $5E, OFFSET X2	{ MOVSX EBX,[X2] }
			DB $66, $0F, $BF, $4E, OFFSET X3	{ MOVSX EBX,[X3] }

	DB $66;	SAL		AX,Scaler
	DB $66;	SAL		BX,Scaler
	DB $66;	SAL		CX,Scaler

	DB $66;	MOV		[WORD PTR XX1],AX
	DB $66;	MOV		[WORD PTR XX2],BX
	DB $66;	MOV		[WORD PTR XX3],CX

			MOV		AX,[Y1]
			CMP		AX,[Y2]
			JE		@@EQ1

	DB $66;	MOV		AX,[WORD PTR XX2]
	DB $66;	MOV		BX,[WORD PTR XX1]
	DB $66;	SUB		AX,BX

	DB $66;	CWD
			MOV     BX,[Y2]
			SUB		BX,[Y1]
			DB $66, $0F, $BF, $CB				{ MOVSX ECX,BX }
	DB $66;	IDIV	CX
	DB $66;	MOV		[WORD PTR DX1],AX
			JMP		@@DO2
@@EQ1:
	DB $66;	XOR		AX,AX
	DB $66;	MOV		[WORD PTR DX1],AX
@@DO2:
			MOV		AX,[Y2]
			CMP		AX,[Y3]
			JE		@@EQ2

	DB $66;	MOV		AX,[WORD PTR XX3]
	DB $66;	MOV		BX,[WORD PTR XX2]
	DB $66;	SUB		AX,BX

	DB $66;	CWD
			MOV     BX,[Y3]
			SUB		BX,[Y2]
			DB $66, $0F, $BF, $CB				{ MOVSX ECX,BX }
	DB $66;	IDIV	CX
	DB $66;	MOV		[WORD PTR DX2],AX
			JMP		@@DO3
@@EQ2:
	DB $66;	XOR		AX,AX
	DB $66;	MOV		[WORD PTR DX2],AX
@@DO3:
			MOV		AX,[Y3]
			CMP		AX,[Y1]
			JE		@@EQ3

	DB $66;	MOV		AX,[WORD PTR XX3]
	DB $66;	MOV		BX,[WORD PTR XX1]
	DB $66;	SUB		AX,BX

	DB $66;	CWD
			MOV     BX,[Y3]
			SUB		BX,[Y1]
			DB $66, $0F, $BF, $CB				{ MOVSX ECX,BX }
	DB $66;	IDIV	CX
	DB $66;	MOV		[WORD PTR DX3],AX
			JMP		@@DOFILL
@@EQ3:
	DB $66;	XOR		AX,AX
	DB $66;	MOV		[WORD PTR DX3],AX
@@DOFILL:
			MOV		AX,[Y1]
			CMP		AX,[Y2]
			JNE		@@DIFF

	DB $66;	MOV		AX,[WORD PTR XX1]
	DB $66;	MOV		BX,[WORD PTR XX2]
	DB $66;	MOV		CX,[WORD PTR DX1]
	DB $66;	MOV		DX,[WORD PTR DX1]
	DB $66;	CMP		CX,DX
			JGE		@@OK11
	DB $66;	XCHG	AX,BX
@@OK11:
	DB $66;	MOV		[WORD PTR CX1],AX
	DB $66;	MOV		[WORD PTR CX2],BX
			JMP		@@DONE
@@DIFF:
	DB $66;	MOV		AX,[WORD PTR XX1]
	DB $66;	MOV		[WORD PTR CX1],AX
	DB $66;	MOV		[WORD PTR CX2],AX
@@DONE:
			MOV		AX,[Y1]
			MOV		[Y],AX

			CMP		AX,[[ClipY1]]
			JGE		@@OKLINE
			MOV		AX,[[ClipY1]]
@@OKLINE:
			MOV		DI,AX
			SHL		AX,6
			SHL		DI,8
			ADD		DI,AX
@@GO_ON:
			MOV		ES,[VideoSeg]

@@LINELOOP:
			MOV		AX,[Y]
			CMP		AX,[[ClipY1]]
			JL		@@NEXTLINE
			CMP		AX,[[ClipY2]]
			JG		@@ALLLINES

	DB $66;	MOV		AX,[WORD PTR CX1]
	DB $66;	MOV		BX,[WORD PTR CX2]
	DB $66;	CMP		AX,BX
	DB $66;	JLE		@@OK
	DB $66;	XCHG	AX,BX
@@OK:
	DB $66;	XOR		CX,CX
	DB $66;	SAR		AX,Scaler
	DB $66;	ADC		AX,CX
	DB $66;	SAR		BX,Scaler
	DB $66;	ADC		BX,CX
			CMP		AX,[ClipX1]
			JGE		@@OK1_1
			CMP		BX,[ClipX1]
			JGE		@@OK1_1
			JMP		@@NEXTLINE
@@OK1_1:
			CMP		AX,[ClipX2]
			JLE		@@OK1_2
			CMP		BX,[ClipX2]
			JLE		@@OK1_2
			JMP		@@NEXTLINE
@@OK1_2:
			CMP		AX,[ClipX1]
			JGE		@@OK1
			MOV		AX,[ClipX1]
@@OK1:
			CMP		AX,[ClipX2]
			JLE		@@OK2
			MOV		AX,[ClipX2]
@@OK2:
			CMP		BX,[ClipX1]
			JGE		@@OK3
			MOV		BX,[ClipX1]
@@OK3:
			CMP		BX,[ClipX2]
			JLE		@@OK4
			MOV		BX,[ClipX2]
@@OK4:
			MOV		CX,BX
			SUB		CX,AX
			INC		CX
			CLD
			MOV		SI,DI
			ADD		DI,AX
	DB $66;	MOV		AX,[WORD PTR CDWord]
			JCXZ	@@SKIP2
			TEST	DI,$0001
			JZ		@@NOTONE
			AND		[BYTE PTR ES:DI],AL
			INC		DI
			DEC		CX
			JZ		@@SKIP2
@@NOTONE:
			CMP		CX,2
			JB		@@NOTTWO
			TEST	DI,$0002
			JZ		@@NOTTWO
			AND		[WORD PTR ES:DI],AX
			ADD		DI,2
			SUB		CX,2
			JZ		@@SKIP2
@@NOTTWO:
			SHR		CX,1
			DB $0F, $92, $C3
			SHR		CX,1
			DB $0F, $92, $C7
			JCXZ	@@SKIP0
@@STOSLOOP:
	DB $66;	AND		[WORD PTR ES:DI],AX
			ADD		DI,4
			DEC		CX
			JNZ		@@STOSLOOP
@@SKIP0:
			OR		BH,BH
			JZ		@@SKIP1
			AND		[WORD PTR ES:DI],AX
			ADD		DI,2
@@SKIP1:
			OR		BL,BL
			JZ		@@SKIP2
			AND		[BYTE PTR ES:DI],AL
			INC		DI
@@SKIP2:
			MOV		DI,SI
@@NEXTLINE:
			MOV		AX,[Y]
			CMP		AX,[ClipY1]
			JL		@@NEXTLINE_2
			ADD		DI,320
@@NEXTLINE_2:
			CMP		AX,[Y1]
			JL		@@LINE2
			CMP		AX,[Y2]
			JGE		@@LINE2
	DB $66;	MOV		AX,[WORD PTR DX1]
	DB $66;	ADD		[WORD PTR CX2],AX
@@LINE2:
			MOV		AX,[Y]
			CMP		AX,[Y1]
			JL		@@LINE3
			CMP		AX,[Y3]
			JGE		@@LINE3
	DB $66;	MOV		AX,[WORD PTR DX3]
	DB $66;	ADD		[WORD PTR CX1],AX
@@LINE3:
			MOV		AX,[Y]
			CMP		AX,[Y2]
			JL		@@EXIT
			CMP		AX,[Y3]
			JG		@@EXIT
	DB $66;	MOV		AX,[WORD PTR DX2]
	DB $66;	ADD		[WORD PTR CX2],AX
@@EXIT:
			INC		[Y]
			MOV		AX,[Y]
			CMP		AX,[Y3]
			JLE		@@LINELOOP
@@ALLLINES:
End;

Procedure XTetraGlenzXOR(X1,Y1,X2,Y2,X3,Y3 : Integer; Color : Byte; VideoSeg : Word); Assembler;
Var
	XX1		: LongInt;
	XX2		: LongInt;
	XX3		: LongInt;
	DX1		: LongInt;
	DX2		: LongInt;
	DX3		: LongInt;
	Y		: Integer;
	CX1,CX2	: LongInt;
	CDWord	: LongInt;
Asm
			CLD
			MOV		AL,[Color]
			MOV		AH,AL
			MOV		BX,AX
	DB $66;	SHL		AX,16
			MOV		AX,BX
	DB $66;	MOV		[WORD PTR CDWord],AX

			CMP		[Color],0
			JE		@@ALLLINES
			MOV		AX,[X1]				{ Initialize registers	}
			MOV		BX,[Y1]
			MOV		CX,[X2]
			MOV		DX,[Y2]
			MOV		SI,[X3]
			MOV		DI,[Y3]

			CMP		BX,DX				{ Calculate min of y1/y2 }
			JLE		@@OK_FIRST_1
			XCHG	AX,CX
			XCHG	BX,DX
@@OK_FIRST_1:
			CMP		BX,DI				{ Calculate min of y2/y3 }
			JLE		@@OK_FIRST_2
			XCHG	AX,SI
			XCHG	BX,DI
@@OK_FIRST_2:
			CMP		DX,DI				{ Calculate min of y1/y3 }
			JLE		@@OK_FIRST_3
			XCHG	CX,SI
			XCHG	DX,DI
@@OK_FIRST_3:
			MOV		[X1],AX				{ Store back in variables }
			MOV		[Y1],BX
			MOV		[X2],CX
			MOV		[Y2],DX
			MOV		[X3],SI
			MOV		[Y3],DI
			CMP		DI,BX
			JE		@@ALLLINES
			CMP		BX,DI
			JNE		@@NONFLAT

			CMP		BX,0
			JL		@@ALLLINES
			CMP		BX,199
			JG		@@ALLLINES
			MOV		DI,BX
			SHL		DI,6
			SHL		BX,8
			ADD		DI,BX
			MOV		ES,[VideoSeg]
			MOV		AX,[X1]
			CMP		AX,[X2]
			JLE		@@FL1
			MOV		AX,[X2]
@@FL1:
			CMP		AX,[X3]
			JLE		@@FL2
			MOV		AX,[X3]
@@FL2:
			MOV		BX,[X1]
			CMP		BX,[X2]
			JGE		@@FL3
			MOV		BX,[X2]
@@FL3:
			CMP		BX,[X3]
			JGE		@@FL4
			MOV		BX,[X3]
@@FL4:
			CMP		AX,0
			JGE		@@FL5
			CMP		BX,0
			JGE		@@FL5
			JMP		@@ALLLINES
@@FL5:
			CMP		AX,319
			JLE		@@FL6
			CMP		BX,319
			JLE		@@FL6
			JMP		@@ALLLINES
@@FL6:
			CMP		AX,0
			JGE		@@FL7
			SUB		AX,AX
@@FL7:
			CMP		BX,319
			JLE		@@FL8
			MOV		BX,319
@@FL8:
			ADD		DI,AX
			MOV		CX,BX
			SUB		CX,AX
			INC		CX
			CLD
	DB $66;	MOV		AX,[WORD PTR CDWord]
			JCXZ	@@FL10
			TEST	DI,$0001
			JZ		@@NOTONE_1
			XOR		[ES:DI],AL
			INC		DI
			DEC		CX
			JZ		@@FL10
@@NOTONE_1:
			CMP		CX,2
			JB		@@NOTTWO_1
			TEST	DI,$0002
			JZ		@@NOTTWO_1
			XOR		[ES:DI],AX
			ADD		DI,2
			SUB		CX,2
			JZ		@@FL10
@@NOTTWO_1:
			SHR		CX,1
			DB $0F, $92, $C3
			SHR		CX,1
			DB $0F, $92, $C7
			JCXZ	@@FL9_2
@@FL9:
	DB $66;	XOR		[WORD PTR ES:DI],AX
			ADD		DI,4
			DEC		CX
			JNZ		@@FL9
@@FL9_2:
			OR		BH,BH
			JZ		@@FL9_3
			XOR		[WORD PTR ES:DI],AX
			ADD		DI,2
@@FL9_3:
			OR		BL,BL
			JZ		@@FL10
			XOR		[BYTE PTR ES:DI],AL
			INC		DI
@@FL10:
			JMP		@@ALLLINES
@@NONFLAT:
			DB $66, $0F, $BF, $46, OFFSET X1	{ MOVSX EAX,[X1] }
			DB $66, $0F, $BF, $5E, OFFSET X2	{ MOVSX EBX,[X2] }
			DB $66, $0F, $BF, $4E, OFFSET X3	{ MOVSX ECX,[X3] }

	DB $66;	SAL		AX,Scaler
	DB $66;	SAL		BX,Scaler
	DB $66;	SAL		CX,Scaler

	DB $66;	MOV		[WORD PTR XX1],AX
	DB $66;	MOV		[WORD PTR XX2],BX
	DB $66;	MOV		[WORD PTR XX3],CX

			MOV		AX,[Y1]
			CMP		AX,[Y2]
			JE		@@EQ1

	DB $66;	MOV		AX,[WORD PTR XX2]
	DB $66;	MOV		BX,[WORD PTR XX1]
	DB $66;	SUB		AX,BX

	DB $66;	CWD
			MOV     BX,[Y2]
			SUB		BX,[Y1]
			DB $66, $0F, $BF, $CB				{ MOVSX ECX,BX }
	DB $66;	IDIV	CX
	DB $66;	MOV		[WORD PTR DX1],AX
			JMP		@@DO2
@@EQ1:
	DB $66;	XOR		AX,AX
	DB $66;	MOV		[WORD PTR DX1],AX
@@DO2:
			MOV		AX,[Y2]
			CMP		AX,[Y3]
			JE		@@EQ2

	DB $66;	MOV		AX,[WORD PTR XX3]
	DB $66;	MOV		BX,[WORD PTR XX2]
	DB $66;	SUB		AX,BX

	DB $66;	CWD
			MOV     BX,[Y3]
			SUB		BX,[Y2]
			DB $66, $0F, $BF, $CB				{ MOVSX ECX,BX }
	DB $66;	IDIV	CX
	DB $66;	MOV		[WORD PTR DX2],AX
			JMP		@@DO3
@@EQ2:
	DB $66;	XOR		AX,AX
	DB $66;	MOV		[WORD PTR DX2],AX
@@DO3:
			MOV		AX,[Y3]
			CMP		AX,[Y1]
			JE		@@EQ3

	DB $66;	MOV		AX,[WORD PTR XX3]
	DB $66;	MOV		BX,[WORD PTR XX1]
	DB $66;	SUB		AX,BX

	DB $66;	CWD
			MOV     BX,[Y3]
			SUB		BX,[Y1]
			DB $66, $0F, $BF, $CB				{ MOVSX ECX,BX }
	DB $66;	IDIV	CX
	DB $66;	MOV		[WORD PTR DX3],AX
			JMP		@@DOFILL
@@EQ3:
	DB $66;	XOR		AX,AX
	DB $66;	MOV		[WORD PTR DX3],AX
@@DOFILL:
			MOV		AX,[Y1]
			CMP		AX,[Y2]
			JNE		@@DIFF

	DB $66;	MOV		AX,[WORD PTR XX1]
	DB $66;	MOV		BX,[WORD PTR XX2]
	DB $66;	MOV		CX,[WORD PTR DX1]
	DB $66;	MOV		DX,[WORD PTR DX1]
	DB $66;	CMP		CX,DX
			JGE		@@OK11
	DB $66;	XCHG	AX,BX
@@OK11:
	DB $66;	MOV		[WORD PTR CX1],AX
	DB $66;	MOV		[WORD PTR CX2],BX
			JMP		@@DONE
@@DIFF:
	DB $66;	MOV		AX,[WORD PTR XX1]
	DB $66;	MOV		[WORD PTR CX1],AX
	DB $66;	MOV		[WORD PTR CX2],AX
@@DONE:
			MOV		AX,[Y1]
			MOV		[Y],AX

			CMP		AX,0
			JGE		@@OKLINE
			SUB		AX,AX
@@OKLINE:
			MOV		DI,AX
			SHL		AX,6
			SHL		DI,8
			ADD		DI,AX
@@GO_ON:
			MOV		ES,[VideoSeg]

@@LINELOOP:
			MOV		AX,[Y]
			CMP		AX,0
			JL		@@NEXTLINE
			CMP		AX,199
			JG		@@ALLLINES

	DB $66;	MOV		AX,[WORD PTR CX1]
	DB $66;	MOV		BX,[WORD PTR CX2]
	DB $66;	CMP		AX,BX
	DB $66;	JLE		@@OK
	DB $66;	XCHG	AX,BX
@@OK:
	DB $66;	XOR		CX,CX
	DB $66;	SAR		AX,Scaler
	DB $66;	ADC		AX,CX
	DB $66;	SAR		BX,Scaler
	DB $66;	ADC		BX,CX
			CMP		AX,0
			JGE		@@OK1_1
			CMP		BX,0
			JGE		@@OK1_1
			JMP		@@NEXTLINE
@@OK1_1:
			CMP		AX,319
			JLE		@@OK1_2
			CMP		BX,319
			JLE		@@OK1_2
			JMP		@@NEXTLINE
@@OK1_2:
			CMP		AX,0
			JGE		@@OK1
			SUB		AX,AX
@@OK1:
			CMP		AX,319
			JLE		@@OK2
			MOV		AX,319
@@OK2:
			CMP		BX,0
			JGE		@@OK3
			SUB		BX,BX
@@OK3:
			CMP		BX,319
			JLE		@@OK4
			MOV		BX,319
@@OK4:
			MOV		CX,BX
			SUB		CX,AX
			INC		CX
			CLD
			MOV		SI,DI
			ADD		DI,AX
	DB $66;	MOV		AX,[WORD PTR CDWord]
			JCXZ	@@SKIP2
			TEST	DI,$0001
			JZ		@@NOTONE
			XOR		[BYTE PTR ES:DI],AL
			INC		DI
			DEC		CX
			JZ		@@SKIP2
@@NOTONE:
			CMP		CX,2
			JB		@@NOTTWO
			TEST	DI,$0002
			JZ		@@NOTTWO
			XOR		[WORD PTR ES:DI],AX
			ADD		DI,2
			SUB		CX,2
			JZ		@@SKIP2
@@NOTTWO:
			SHR		CX,1
			DB $0F, $92, $C3
			SHR		CX,1
			DB $0F, $92, $C7
			JCXZ	@@SKIP0
@@STOSLOOP:
	DB $66;	XOR		[WORD PTR ES:DI],AX
			ADD		DI,4
			DEC		CX
			JNZ		@@STOSLOOP
@@SKIP0:
			OR		BH,BH
			JZ		@@SKIP1
			XOR		[WORD PTR ES:DI],AX
			ADD		DI,2
@@SKIP1:
			OR		BL,BL
			JZ		@@SKIP2
			XOR		[BYTE PTR ES:DI],AL
			INC		DI
@@SKIP2:
			MOV		DI,SI
@@NEXTLINE:
			MOV		AX,[Y]
			CMP		AX,0
			JL		@@NEXTLINE_2
			ADD		DI,320
@@NEXTLINE_2:
			CMP		AX,[Y1]
			JL		@@LINE2
			CMP		AX,[Y2]
			JGE		@@LINE2
	DB $66;	MOV		AX,[WORD PTR DX1]
	DB $66;	ADD		[WORD PTR CX2],AX
@@LINE2:
			MOV		AX,[Y]
			CMP		AX,[Y1]
			JL		@@LINE3
			CMP		AX,[Y3]
			JGE		@@LINE3
	DB $66;	MOV		AX,[WORD PTR DX3]
	DB $66;	ADD		[WORD PTR CX1],AX
@@LINE3:
			MOV		AX,[Y]
			CMP		AX,[Y2]
			JL		@@EXIT
			CMP		AX,[Y3]
			JG		@@EXIT
	DB $66;	MOV		AX,[WORD PTR DX2]
	DB $66;	ADD		[WORD PTR CX2],AX
@@EXIT:
			INC		[Y]
			MOV		AX,[Y]
			CMP		AX,[Y3]
			JLE		@@LINELOOP
@@ALLLINES:
End;

Procedure XTetraGlenzXORClip(X1,Y1,X2,Y2,X3,Y3,ClipX1,ClipY1,ClipX2,ClipY2 : Integer;
	Color : Byte; VideoSeg : Word); Assembler;
Var
	XX1		: LongInt;
	XX2		: LongInt;
	XX3		: LongInt;
	DX1		: LongInt;
	DX2		: LongInt;
	DX3		: LongInt;
	Y		: Integer;
	CX1,CX2	: LongInt;
	CDWord	: LongInt;
Asm
			CLD
			MOV		AL,[Color]
			MOV		AH,AL
			MOV		BX,AX
	DB $66;	SHL		AX,16
			MOV		AX,BX
	DB $66;	MOV		[WORD PTR CDWord],AX

			CMP		[Color],0
			JE		@@ALLLINES
			MOV		AX,[X1]				{ Initialize registers	}
			MOV		BX,[Y1]
			MOV		CX,[X2]
			MOV		DX,[Y2]
			MOV		SI,[X3]
			MOV		DI,[Y3]

			CMP		BX,DX				{ Calculate min of y1/y2 }
			JLE		@@OK_FIRST_1
			XCHG	AX,CX
			XCHG	BX,DX
@@OK_FIRST_1:
			CMP		BX,DI				{ Calculate min of y2/y3 }
			JLE		@@OK_FIRST_2
			XCHG	AX,SI
			XCHG	BX,DI
@@OK_FIRST_2:
			CMP		DX,DI				{ Calculate min of y1/y3 }
			JLE		@@OK_FIRST_3
			XCHG	CX,SI
			XCHG	DX,DI
@@OK_FIRST_3:
			MOV		[X1],AX				{ Store back in variables }
			MOV		[Y1],BX
			MOV		[X2],CX
			MOV		[Y2],DX
			MOV		[X3],SI
			MOV		[Y3],DI
			CMP		DI,BX
			JE		@@ALLLINES
			CMP		BX,DI
			JNE		@@NONFLAT

			CMP		BX,[ClipY1]
			JL		@@ALLLINES
			CMP		BX,[ClipY2]
			JG		@@ALLLINES
			MOV		DI,BX
			SHL		DI,6
			SHL		BX,8
			ADD		DI,BX
			MOV		ES,[VideoSeg]
			MOV		AX,[X1]
			CMP		AX,[X2]
			JLE		@@FL1
			MOV		AX,[X2]
@@FL1:
			CMP		AX,[X3]
			JLE		@@FL2
			MOV		AX,[X3]
@@FL2:
			MOV		BX,[X1]
			CMP		BX,[X2]
			JGE		@@FL3
			MOV		BX,[X2]
@@FL3:
			CMP		BX,[X3]
			JGE		@@FL4
			MOV		BX,[X3]
@@FL4:
			CMP		AX,[ClipX1]
			JGE		@@FL5
			CMP		BX,[ClipX1]
			JGE		@@FL5
			JMP		@@ALLLINES
@@FL5:
			CMP		AX,[ClipX2]
			JLE		@@FL6
			CMP		BX,[ClipX2]
			JLE		@@FL6
			JMP		@@ALLLINES
@@FL6:
			CMP		AX,[ClipX1]
			JGE		@@FL7
			MOV		AX,[ClipX1]
@@FL7:
			CMP		BX,[ClipX2]
			JLE		@@FL8
			MOV		BX,[ClipX2]
@@FL8:
			ADD		DI,AX
			MOV		CX,BX
			SUB		CX,AX
			INC		CX
			CLD
	DB $66;	MOV		AX,[WORD PTR CDWord]
			JCXZ	@@FL10
			TEST	DI,$0001
			JZ		@@NOTONE_1
			XOR		[ES:DI],AL
			INC		DI
			DEC		CX
			JZ		@@FL10
@@NOTONE_1:
			CMP		CX,2
			JB		@@NOTTWO_1
			TEST	DI,$0002
			JZ		@@NOTTWO_1
			XOR		[ES:DI],AX
			ADD		DI,2
			SUB		CX,2
			JZ		@@FL10
@@NOTTWO_1:
			SHR		CX,1
			DB $0F, $92, $C3
			SHR		CX,1
			DB $0F, $92, $C7
			JCXZ	@@FL9_2
@@FL9:
	DB $66;	XOR		[WORD PTR ES:DI],AX
			ADD		DI,4
			DEC		CX
			JNZ		@@FL9
@@FL9_2:
			OR		BH,BH
			JZ		@@FL9_3
			XOR		[WORD PTR ES:DI],AX
			ADD		DI,2
@@FL9_3:
			OR		BL,BL
			JZ		@@FL10
			XOR		[BYTE PTR ES:DI],AL
			INC		DI
@@FL10:
			JMP		@@ALLLINES
@@NONFLAT:
			DB $66, $0F, $BF, $46, OFFSET X1	{ MOVSX EAX,[X1] }
			DB $66, $0F, $BF, $5E, OFFSET X2	{ MOVSX EBX,[X2] }
			DB $66, $0F, $BF, $4E, OFFSET X3	{ MOVSX ECX,[X3] }

	DB $66;	SAL		AX,Scaler
	DB $66;	SAL		BX,Scaler
	DB $66;	SAL		CX,Scaler

	DB $66;	MOV		[WORD PTR XX1],AX
	DB $66;	MOV		[WORD PTR XX2],BX
	DB $66;	MOV		[WORD PTR XX3],CX

			MOV		AX,[Y1]
			CMP		AX,[Y2]
			JE		@@EQ1

	DB $66;	MOV		AX,[WORD PTR XX2]
	DB $66;	MOV		BX,[WORD PTR XX1]
	DB $66;	SUB		AX,BX

	DB $66;	CWD
			MOV     BX,[Y2]
			SUB		BX,[Y1]
			DB $66, $0F, $BF, $CB				{ MOVSX ECX,BX }
	DB $66;	IDIV	CX
	DB $66;	MOV		[WORD PTR DX1],AX
			JMP		@@DO2
@@EQ1:
	DB $66;	XOR		AX,AX
	DB $66;	MOV		[WORD PTR DX1],AX
@@DO2:
			MOV		AX,[Y2]
			CMP		AX,[Y3]
			JE		@@EQ2

	DB $66;	MOV		AX,[WORD PTR XX3]
	DB $66;	MOV		BX,[WORD PTR XX2]
	DB $66;	SUB		AX,BX

	DB $66;	CWD
			MOV     BX,[Y3]
			SUB		BX,[Y2]
			DB $66, $0F, $BF, $CB				{ MOVSX ECX,BX }
	DB $66;	IDIV	CX
	DB $66;	MOV		[WORD PTR DX2],AX
			JMP		@@DO3
@@EQ2:
	DB $66;	XOR		AX,AX
	DB $66;	MOV		[WORD PTR DX2],AX
@@DO3:
			MOV		AX,[Y3]
			CMP		AX,[Y1]
			JE		@@EQ3

	DB $66;	MOV		AX,[WORD PTR XX3]
	DB $66;	MOV		BX,[WORD PTR XX1]
	DB $66;	SUB		AX,BX

	DB $66;	CWD
			MOV     BX,[Y3]
			SUB		BX,[Y1]
			DB $66, $0F, $BF, $CB				{ MOVSX ECX,BX }
	DB $66;	IDIV	CX
	DB $66;	MOV		[WORD PTR DX3],AX
			JMP		@@DOFILL
@@EQ3:
	DB $66;	XOR		AX,AX
	DB $66;	MOV		[WORD PTR DX3],AX
@@DOFILL:
			MOV		AX,[Y1]
			CMP		AX,[Y2]
			JNE		@@DIFF

	DB $66;	MOV		AX,[WORD PTR XX1]
	DB $66;	MOV		BX,[WORD PTR XX2]
	DB $66;	MOV		CX,[WORD PTR DX1]
	DB $66;	MOV		DX,[WORD PTR DX1]
	DB $66;	CMP		CX,DX
			JGE		@@OK11
	DB $66;	XCHG	AX,BX
@@OK11:
	DB $66;	MOV		[WORD PTR CX1],AX
	DB $66;	MOV		[WORD PTR CX2],BX
			JMP		@@DONE
@@DIFF:
	DB $66;	MOV		AX,[WORD PTR XX1]
	DB $66;	MOV		[WORD PTR CX1],AX
	DB $66;	MOV		[WORD PTR CX2],AX
@@DONE:
			MOV		AX,[Y1]
			MOV		[Y],AX

			CMP		AX,[ClipY1]
			JGE		@@OKLINE
			MOV		AX,[ClipY1]
@@OKLINE:
			MOV		DI,AX
			SHL		AX,6
			SHL		DI,8
			ADD		DI,AX
@@GO_ON:
			MOV		ES,[VideoSeg]

@@LINELOOP:
			MOV		AX,[Y]
			CMP		AX,[[ClipY1]]
			JL		@@NEXTLINE
			CMP		AX,[[ClipY2]]
			JG		@@ALLLINES

	DB $66;	MOV		AX,[WORD PTR CX1]
	DB $66;	MOV		BX,[WORD PTR CX2]
	DB $66;	CMP		AX,BX
	DB $66;	JLE		@@OK
	DB $66;	XCHG	AX,BX
@@OK:
	DB $66;	XOR		CX,CX
	DB $66;	SAR		AX,Scaler
	DB $66;	ADC		AX,CX
	DB $66;	SAR		BX,Scaler
	DB $66;	ADC		BX,CX
			CMP		AX,[ClipX1]
			JGE		@@OK1_1
			CMP		BX,[ClipX1]
			JGE		@@OK1_1
			JMP		@@NEXTLINE
@@OK1_1:
			CMP		AX,[ClipX2]
			JLE		@@OK1_2
			CMP		BX,[ClipX2]
			JLE		@@OK1_2
			JMP		@@NEXTLINE
@@OK1_2:
			CMP		AX,[ClipX1]
			JGE		@@OK1
			MOV		AX,[ClipX1]
@@OK1:
			CMP		AX,[ClipX2]
			JLE		@@OK2
			MOV		AX,[ClipX2]
@@OK2:
			CMP		BX,[ClipX1]
			JGE		@@OK3
			MOV		BX,[ClipX1]
@@OK3:
			CMP		BX,[ClipX2]
			JLE		@@OK4
			MOV		BX,[ClipX2]
@@OK4:
			MOV		CX,BX
			SUB		CX,AX
			INC		CX
			CLD
			MOV		SI,DI
			ADD		DI,AX
	DB $66;	MOV		AX,[WORD PTR CDWord]
			JCXZ	@@SKIP2
			TEST	DI,$0001
			JZ		@@NOTONE
			XOR		[BYTE PTR ES:DI],AL
			INC		DI
			DEC		CX
			JZ		@@SKIP2
@@NOTONE:
			CMP		CX,2
			JB		@@NOTTWO
			TEST	DI,$0002
			JZ		@@NOTTWO
			XOR		[WORD PTR ES:DI],AX
			ADD		DI,2
			SUB		CX,2
			JZ		@@SKIP2
@@NOTTWO:
			SHR		CX,1
			DB $0F, $92, $C3
			SHR		CX,1
			DB $0F, $92, $C7
			JCXZ	@@SKIP0
@@STOSLOOP:
	DB $66;	XOR		[WORD PTR ES:DI],AX
			ADD		DI,4
			DEC		CX
			JNZ		@@STOSLOOP
@@SKIP0:
			OR		BH,BH
			JZ		@@SKIP1
			XOR		[WORD PTR ES:DI],AX
			ADD		DI,2
@@SKIP1:
			OR		BL,BL
			JZ		@@SKIP2
			XOR		[BYTE PTR ES:DI],AL
			INC		DI
@@SKIP2:
			MOV		DI,SI
@@NEXTLINE:
			MOV		AX,[Y]
			CMP		AX,[ClipY1]
			JL		@@NEXTLINE_2
			ADD		DI,320
@@NEXTLINE_2:
			CMP		AX,[Y1]
			JL		@@LINE2
			CMP		AX,[Y2]
			JGE		@@LINE2
	DB $66;	MOV		AX,[WORD PTR DX1]
	DB $66;	ADD		[WORD PTR CX2],AX
@@LINE2:
			MOV		AX,[Y]
			CMP		AX,[Y1]
			JL		@@LINE3
			CMP		AX,[Y3]
			JGE		@@LINE3
	DB $66;	MOV		AX,[WORD PTR DX3]
	DB $66;	ADD		[WORD PTR CX1],AX
@@LINE3:
			MOV		AX,[Y]
			CMP		AX,[Y2]
			JL		@@EXIT
			CMP		AX,[Y3]
			JG		@@EXIT
	DB $66;	MOV		AX,[WORD PTR DX2]
	DB $66;	ADD		[WORD PTR CX2],AX
@@EXIT:
			INC		[Y]
			MOV		AX,[Y]
			CMP		AX,[Y3]
			JLE		@@LINELOOP
@@ALLLINES:
End;

Procedure XQuadra(X1,Y1,X2,Y2,X3,Y3,X4,Y4 : Integer; Color : Byte; VideoSeg : Word); Assembler;
Var
	XX1,XX2		: LongInt;
	XX3,XX4		: LongInt;
	DX1,DX2		: LongInt;
	DX3,DX4		: LongInt;
	CX1,CX2		: LongInt;		{ Moves from 1 to 2, 2 to 3 }
	CX3,CX4		: LongInt;		{ Moves from 3 to 4, 1 to 4 }
	Min1,Min2	: Integer;
	Min3,Min4	: Integer;
	Max1,Max2	: Integer;
	Max3,Max4	: Integer;
	Y,YMin,YMax	: Integer;
	CDWord		: LongInt;
Asm
			CLD
			MOV		BL,[Color]
			MOV		BH,BL
			MOV		AX,BX
	DB $66;	SHL		AX,16
			MOV		AX,BX
	DB $66;	MOV		[WORD PTR CDWord],AX

			MOV		AX,[Y1]		{ AX = YMin }
			MOV		BX,AX		{ BX = YMax }
			CMP		AX,[Y2]
			JLE		@@OK1
			MOV		AX,[Y2]
@@OK1:
			CMP		AX,[Y3]
			JLE		@@OK2
			MOV		AX,[Y3]
@@OK2:
			CMP		AX,[Y4]
			JLE		@@OK3
			MOV		AX,[Y4]
@@OK3:
			CMP		BX,[Y2]
			JGE		@@OK4
			MOV		BX,[Y2]
@@OK4:
			CMP		BX,[Y3]
			JGE		@@OK5
			MOV		BX,[Y3]
@@OK5:
			CMP		BX,[Y4]
			JGE		@@OK6
			MOV		BX,[Y4]
@@OK6:
			MOV		[YMin],AX
			MOV		[YMax],BX

			DB $66, $0F, $BF, $46, OFFSET X1	{ MOVSX EAX,[X1] }
	DB $66;	SAL		AX,Scaler
	DB $66;	MOV		[WORD PTR XX1],AX
			DB $66, $0F, $BF, $46, OFFSET X2	{ MOVSX EAX,[X2] }
	DB $66;	SAL		AX,Scaler
	DB $66;	MOV		[WORD PTR XX2],AX
			DB $66, $0F, $BF, $46, OFFSET X3	{ MOVSX EAX,[X3] }
	DB $66;	SAL		AX,Scaler
	DB $66;	MOV		[WORD PTR XX3],AX
			DB $66, $0F, $BF, $46, OFFSET X4	{ MOVSX EAX,[X4] }
	DB $66;	SAL		AX,Scaler
	DB $66;	MOV		[WORD PTR XX4],AX

			MOV		AX,[Y1]
			CMP		AX,[Y2]
			JE		@@EQ1
	DB $66;	MOV		AX,[WORD PTR XX2]
	DB $66;	SUB		AX,[WORD PTR XX1]
	DB $66;	CWD
			MOV     BX,[Y2]
			SUB		BX,[Y1]
			DB $66, $0F, $BF, $CB				{ MOVSX ECX,BX }
	DB $66;	IDIV	CX
	DB $66;	MOV		[WORD PTR DX1],AX
			JMP		@@LINEISOK_1
@@EQ1:
	DB $66;	XOR		AX,AX
	DB $66;	MOV		[WORD PTR DX1],AX
@@LINEISOK_1:

			MOV		AX,[Y2]
			CMP		AX,[Y3]
			JE		@@EQ2
	DB $66;	MOV		AX,[WORD PTR XX3]
	DB $66;	SUB		AX,[WORD PTR XX2]
	DB $66;	CWD
			MOV     BX,[Y3]
			SUB		BX,[Y2]
			DB $66, $0F, $BF, $CB				{ MOVSX ECX,BX }
	DB $66;	IDIV	CX
	DB $66;	MOV		[WORD PTR DX2],AX
			JMP		@@LINEISOK_2
@@EQ2:
	DB $66;	XOR		AX,AX
	DB $66;	MOV		[WORD PTR DX2],AX
@@LINEISOK_2:

			MOV		AX,[Y3]
			CMP		AX,[Y4]
			JE		@@EQ3
	DB $66;	MOV		AX,[WORD PTR XX4]
	DB $66;	SUB		AX,[WORD PTR XX3]
	DB $66;	CWD
			MOV     BX,[Y4]
			SUB		BX,[Y3]
			DB $66, $0F, $BF, $CB				{ MOVSX ECX,BX }
	DB $66;	IDIV	CX
	DB $66;	MOV		[WORD PTR DX3],AX
			JMP		@@LINEISOK_3
@@EQ3:
	DB $66;	XOR		AX,AX
	DB $66;	MOV		[WORD PTR DX3],AX
@@LINEISOK_3:

			MOV		AX,[Y1]
			CMP		AX,[Y4]
			JE		@@EQ4
	DB $66;	MOV		AX,[WORD PTR XX4]
	DB $66;	SUB		AX,[WORD PTR XX1]
	DB $66;	CWD
			MOV     BX,[Y4]
			SUB		BX,[Y1]
			DB $66, $0F, $BF, $CB				{ MOVSX ECX,BX }
	DB $66;	IDIV	CX
	DB $66;	MOV		[WORD PTR DX4],AX
			JMP		@@LINEISOK_4
@@EQ4:
	DB $66;	XOR		AX,AX
	DB $66;	MOV		[WORD PTR DX4],AX
@@LINEISOK_4:

			MOV		BX,[Y1]
			CMP		BX,[Y2]
			JLE		@@DIR12
	DB $66;	MOV		AX,[WORD PTR XX2]
	DB $66;	MOV		[WORD PTR CX1],AX
			JMP		@@CHECKDIR2
@@DIR12:
	DB $66;	MOV		AX,[WORD PTR XX1]
	DB $66;	MOV		[WORD PTR CX1],AX

@@CHECKDIR2:
			MOV		BX,[Y2]
			CMP		BX,[Y3]
			JLE		@@DIR23
	DB $66;	MOV		AX,[WORD PTR XX3]
	DB $66;	MOV		[WORD PTR CX2],AX
			JMP		@@CHECKDIR3
@@DIR23:
	DB $66;	MOV		AX,[WORD PTR XX2]
	DB $66;	MOV		[WORD PTR CX2],AX

@@CHECKDIR3:
			MOV		BX,[Y3]
			CMP		BX,[Y4]
			JLE		@@DIR34
	DB $66;	MOV		AX,[WORD PTR XX4]
	DB $66;	MOV		[WORD PTR CX3],AX
			JMP		@@CHECKDIR4
@@DIR34:
	DB $66;	MOV		AX,[WORD PTR XX3]
	DB $66;	MOV		[WORD PTR CX3],AX

@@CHECKDIR4:
			MOV		BX,[Y1]
			CMP		BX,[Y4]
			JLE		@@DIR14
	DB $66;	MOV		AX,[WORD PTR XX4]
	DB $66;	MOV		[WORD PTR CX4],AX
			JMP		@@NODIRSLEFT
@@DIR14:
	DB $66;	MOV		AX,[WORD PTR XX1]
	DB $66;	MOV		[WORD PTR CX4],AX
@@NODIRSLEFT:
			MOV		AX,[Y1]
			MOV		BX,[Y2]
			CMP		AX,BX
			JLE		@@USELINE1
			XCHG	AX,BX
@@USELINE1:
			MOV		[Min1],AX
			MOV		[Max1],BX

			MOV		AX,[Y2]
			MOV		BX,[Y3]
			CMP		AX,BX
			JLE		@@USELINE2
			XCHG	AX,BX
@@USELINE2:
			MOV		[Min2],AX
			MOV		[Max2],BX

			MOV		AX,[Y3]
			MOV		BX,[Y4]
			CMP		AX,BX
			JLE		@@USELINE3
			XCHG	AX,BX
@@USELINE3:
			MOV		[Min3],AX
			MOV		[Max3],BX

			MOV		AX,[Y1]
			MOV		BX,[Y4]
			CMP		AX,BX
			JLE		@@USELINE4
			XCHG	AX,BX
@@USELINE4:
			MOV		[Min4],AX
			MOV		[Max4],BX

			MOV		AX,[YMin]
			MOV		[Y],AX
			TEST	AX,AX
			JGE		@@MOVEIT
			SUB		AX,AX
@@MOVEIT:
			MOV		DI,AX
			SHL		DI,6
			SHL		AX,8
			ADD		DI,AX
			MOV		ES,[VideoSeg]

@@LINELOOP:
			MOV		AX,[Y]
			CMP		AX,[YMax]
			JG		@@EXIT
			TEST	AX,AX
			JL		@@NEXTLINE
			CMP		AX,199
			JG		@@EXIT

	DB $66;	MOV		AX,$FFFF; DW $7FFF	{ MAX }
	DB $66;	MOV		BX,$0000; DW $8000	{ MIN }
			MOV		CX,[Y]

			CMP		CX,[Min1]
			JL		@@CHECK2
			CMP		CX,[Max1]
			JG		@@CHECK2
	DB $66;	CMP		AX,[WORD PTR CX1]
			JLE		@@CHECK1_2
	DB $66;	MOV		AX,[WORD PTR CX1]
@@CHECK1_2:
	DB $66;	CMP		BX,[WORD PTR CX1]
			JGE		@@CHECK2
	DB $66;	MOV		BX,[WORD PTR CX1]

@@CHECK2:
			CMP		CX,[Min2]
			JL		@@CHECK3
			CMP		CX,[Max2]
			JG		@@CHECK3
	DB $66;	CMP		AX,[WORD PTR CX2]
			JLE		@@CHECK2_2
	DB $66;	MOV		AX,[WORD PTR CX2]
@@CHECK2_2:
	DB $66;	CMP		BX,[WORD PTR CX2]
			JGE		@@CHECK3
	DB $66;	MOV		BX,[WORD PTR CX2]

@@CHECK3:
			CMP		CX,[Min3]
			JL		@@CHECK4
			CMP		CX,[Max3]
			JG		@@CHECK4
	DB $66;	CMP		AX,[WORD PTR CX3]
			JLE		@@CHECK3_2
	DB $66;	MOV		AX,[WORD PTR CX3]
@@CHECK3_2:
	DB $66;	CMP		BX,[WORD PTR CX3]
			JGE		@@CHECK4
	DB $66;	MOV		BX,[WORD PTR CX3]

@@CHECK4:
			CMP		CX,[Min4]
			JL		@@CHECK5
			CMP		CX,[Max4]
			JG		@@CHECK5
	DB $66;	CMP		AX,[WORD PTR CX4]
			JLE		@@CHECK4_2
	DB $66;	MOV		AX,[WORD PTR CX4]
@@CHECK4_2:
	DB $66;	CMP		BX,[WORD PTR CX4]
			JGE		@@CHECK5
	DB $66;	MOV		BX,[WORD PTR CX4]
@@CHECK5:

{	DB $66;	XOR		CX,CX}
	DB $66;	SAR		AX,Scaler
{	DB $66;	ADC		AX,CX}
	DB $66;	SAR		BX,Scaler
{	DB $66;	ADC		BX,CX}

			CMP		AX,319
			JG		@@NEXTLINE
			TEST	BX,BX
			JL		@@NEXTLINE

			CMP		BX,319
			JLE		@@MAXISOK
			MOV		BX,319
@@MAXISOK:
			TEST	AX,AX
			JGE		@@MINISOK
			SUB		AX,AX
@@MINISOK:
			MOV		SI,DI

			MOV		CX,BX
			SUB		CX,AX
			INC		CX
			ADD		DI,AX

	DB $66;	MOV		AX,[WORD PTR CDWord]
			JCXZ	@@SKIP2
			TEST	DI,$0001
			JZ		@@NOTONE
			MOV		[ES:DI],AL
			INC		DI
			DEC		CX
			JZ		@@SKIP2
@@NOTONE:
			CMP		CX,2
			JB		@@NOTTWO
			TEST	DI,$0002
			JZ		@@NOTTWO
			MOV		[ES:DI],AX
			ADD		DI,2
			SUB		CX,2
			JZ		@@SKIP2
@@NOTTWO:
			SHR		CX,1
			DB $0F, $92, $C3			{ SETC BL }
			SHR		CX,1
	DB $66;	REP		STOSW
			JNC		@@SKIP1
			MOV		[ES:DI],AX
			ADD		DI,2
@@SKIP1:
			OR		BL,BL
			JZ		@@SKIP2
			MOV		[ES:DI],AL
			INC		DI
@@SKIP2:
			MOV		DI,SI
@@NEXTLINE:
			MOV		AX,[Y]
			CMP		AX,[Min1]
			JL		@@ADJ2
			CMP		AX,[Max1]
			JG		@@ADJ2
	DB $66;	MOV		BX,[WORD PTR DX1]
	DB $66;	ADD		[WORD PTR CX1],BX
@@ADJ2:
			CMP		AX,[Min2]
			JL		@@ADJ3
			CMP		AX,[Max2]
			JG		@@ADJ3
	DB $66;	MOV		BX,[WORD PTR DX2]
	DB $66;	ADD		[WORD PTR CX2],BX
@@ADJ3:
			CMP		AX,[Min3]
			JL		@@ADJ4
			CMP		AX,[Max3]
			JG		@@ADJ4
	DB $66;	MOV		BX,[WORD PTR DX3]
	DB $66;	ADD		[WORD PTR CX3],BX
@@ADJ4:
			CMP		AX,[Min4]
			JL		@@ADJ5
			CMP		AX,[Max4]
			JG		@@ADJ5
	DB $66;	MOV		BX,[WORD PTR DX4]
	DB $66;	ADD		[WORD PTR CX4],BX
@@ADJ5:
			MOV		AX,[Y]
			CMP		AX,0
			JL		@@ONLY_Y
			ADD		DI,320
@@ONLY_Y:
			INC		[Y]
			JMP		@@LINELOOP
@@EXIT:
End;

Procedure XQuadraClip(X1,Y1,X2,Y2,X3,Y3,X4,Y4,ClipX1,ClipY1,ClipX2,ClipY2 : Integer;
	Color : Byte; VideoSeg : Word); Assembler;
Var
	XX1,XX2		: LongInt;
	XX3,XX4		: LongInt;
	DX1,DX2		: LongInt;
	DX3,DX4		: LongInt;
	CX1,CX2		: LongInt;		{ Moves from 1 to 2, 2 to 3 }
	CX3,CX4		: LongInt;		{ Moves from 3 to 4, 1 to 4 }
	Min1,Min2	: Integer;
	Min3,Min4	: Integer;
	Max1,Max2	: Integer;
	Max3,Max4	: Integer;
	Y,YMin,YMax	: Integer;
	CDWord		: LongInt;
Asm
			CLD
			MOV		BL,[Color]
			MOV		BH,BL
			MOV		AX,BX
	DB $66;	SHL		AX,16
			MOV		AX,BX
	DB $66;	MOV		[WORD PTR CDWord],AX

			MOV		AX,[Y1]		{ AX = YMin }
			MOV		BX,AX		{ BX = YMax }
			CMP		AX,[Y2]
			JLE		@@OK1
			MOV		AX,[Y2]
@@OK1:
			CMP		AX,[Y3]
			JLE		@@OK2
			MOV		AX,[Y3]
@@OK2:
			CMP		AX,[Y4]
			JLE		@@OK3
			MOV		AX,[Y4]
@@OK3:
			CMP		BX,[Y2]
			JGE		@@OK4
			MOV		BX,[Y2]
@@OK4:
			CMP		BX,[Y3]
			JGE		@@OK5
			MOV		BX,[Y3]
@@OK5:
			CMP		BX,[Y4]
			JGE		@@OK6
			MOV		BX,[Y4]
@@OK6:
			MOV		[YMin],AX
			MOV		[YMax],BX

			DB $66, $0F, $BF, $46, OFFSET X1	{ MOVSX EAX,[X1] }
	DB $66;	SAL		AX,Scaler
	DB $66;	MOV		[WORD PTR XX1],AX
			DB $66, $0F, $BF, $46, OFFSET X2	{ MOVSX EAX,[X2] }
	DB $66;	SAL		AX,Scaler
	DB $66;	MOV		[WORD PTR XX2],AX
			DB $66, $0F, $BF, $46, OFFSET X3	{ MOVSX EAX,[X3] }
	DB $66;	SAL		AX,Scaler
	DB $66;	MOV		[WORD PTR XX3],AX
			DB $66, $0F, $BF, $46, OFFSET X4	{ MOVSX EAX,[X4] }
	DB $66;	SAL		AX,Scaler
	DB $66;	MOV		[WORD PTR XX4],AX

			MOV		AX,[Y1]
			CMP		AX,[Y2]
			JE		@@EQ1
	DB $66;	MOV		AX,[WORD PTR XX2]
	DB $66;	SUB		AX,[WORD PTR XX1]
	DB $66;	CWD
			MOV     BX,[Y2]
			SUB		BX,[Y1]
			DB $66, $0F, $BF, $CB				{ MOVSX ECX,BX }
	DB $66;	IDIV	CX
	DB $66;	MOV		[WORD PTR DX1],AX
			JMP		@@LINEISOK_1
@@EQ1:
	DB $66;	XOR		AX,AX
	DB $66;	MOV		[WORD PTR DX1],AX
@@LINEISOK_1:

			MOV		AX,[Y2]
			CMP		AX,[Y3]
			JE		@@EQ2
	DB $66;	MOV		AX,[WORD PTR XX3]
	DB $66;	SUB		AX,[WORD PTR XX2]
	DB $66;	CWD
			MOV     BX,[Y3]
			SUB		BX,[Y2]
			DB $66, $0F, $BF, $CB				{ MOVSX ECX,BX }
	DB $66;	IDIV	CX
	DB $66;	MOV		[WORD PTR DX2],AX
			JMP		@@LINEISOK_2
@@EQ2:
	DB $66;	XOR		AX,AX
	DB $66;	MOV		[WORD PTR DX2],AX
@@LINEISOK_2:

			MOV		AX,[Y3]
			CMP		AX,[Y4]
			JE		@@EQ3
	DB $66;	MOV		AX,[WORD PTR XX4]
	DB $66;	SUB		AX,[WORD PTR XX3]
	DB $66;	CWD
			MOV     BX,[Y4]
			SUB		BX,[Y3]
			DB $66, $0F, $BF, $CB				{ MOVSX ECX,BX }
	DB $66;	IDIV	CX
	DB $66;	MOV		[WORD PTR DX3],AX
			JMP		@@LINEISOK_3
@@EQ3:
	DB $66;	XOR		AX,AX
	DB $66;	MOV		[WORD PTR DX3],AX
@@LINEISOK_3:

			MOV		AX,[Y1]
			CMP		AX,[Y4]
			JE		@@EQ4
	DB $66;	MOV		AX,[WORD PTR XX4]
	DB $66;	SUB		AX,[WORD PTR XX1]
	DB $66;	CWD
			MOV     BX,[Y4]
			SUB		BX,[Y1]
			DB $66, $0F, $BF, $CB				{ MOVSX ECX,BX }
	DB $66;	IDIV	CX
	DB $66;	MOV		[WORD PTR DX4],AX
			JMP		@@LINEISOK_4
@@EQ4:
	DB $66;	XOR		AX,AX
	DB $66;	MOV		[WORD PTR DX4],AX
@@LINEISOK_4:

			MOV		BX,[Y1]
			CMP		BX,[Y2]
			JLE		@@DIR12
	DB $66;	MOV		AX,[WORD PTR XX2]
	DB $66;	MOV		[WORD PTR CX1],AX
			JMP		@@CHECKDIR2
@@DIR12:
	DB $66;	MOV		AX,[WORD PTR XX1]
	DB $66;	MOV		[WORD PTR CX1],AX

@@CHECKDIR2:
			MOV		BX,[Y2]
			CMP		BX,[Y3]
			JLE		@@DIR23
	DB $66;	MOV		AX,[WORD PTR XX3]
	DB $66;	MOV		[WORD PTR CX2],AX
			JMP		@@CHECKDIR3
@@DIR23:
	DB $66;	MOV		AX,[WORD PTR XX2]
	DB $66;	MOV		[WORD PTR CX2],AX

@@CHECKDIR3:
			MOV		BX,[Y3]
			CMP		BX,[Y4]
			JLE		@@DIR34
	DB $66;	MOV		AX,[WORD PTR XX4]
	DB $66;	MOV		[WORD PTR CX3],AX
			JMP		@@CHECKDIR4
@@DIR34:
	DB $66;	MOV		AX,[WORD PTR XX3]
	DB $66;	MOV		[WORD PTR CX3],AX

@@CHECKDIR4:
			MOV		BX,[Y1]
			CMP		BX,[Y4]
			JLE		@@DIR14
	DB $66;	MOV		AX,[WORD PTR XX4]
	DB $66;	MOV		[WORD PTR CX4],AX
			JMP		@@NODIRSLEFT
@@DIR14:
	DB $66;	MOV		AX,[WORD PTR XX1]
	DB $66;	MOV		[WORD PTR CX4],AX
@@NODIRSLEFT:
			MOV		AX,[Y1]
			MOV		BX,[Y2]
			CMP		AX,BX
			JLE		@@USELINE1
			XCHG	AX,BX
@@USELINE1:
			MOV		[Min1],AX
			MOV		[Max1],BX

			MOV		AX,[Y2]
			MOV		BX,[Y3]
			CMP		AX,BX
			JLE		@@USELINE2
			XCHG	AX,BX
@@USELINE2:
			MOV		[Min2],AX
			MOV		[Max2],BX

			MOV		AX,[Y3]
			MOV		BX,[Y4]
			CMP		AX,BX
			JLE		@@USELINE3
			XCHG	AX,BX
@@USELINE3:
			MOV		[Min3],AX
			MOV		[Max3],BX

			MOV		AX,[Y1]
			MOV		BX,[Y4]
			CMP		AX,BX
			JLE		@@USELINE4
			XCHG	AX,BX
@@USELINE4:
			MOV		[Min4],AX
			MOV		[Max4],BX

			MOV		AX,[YMin]
			MOV		[Y],AX
			CMP		AX,[ClipY1]
			JGE		@@MOVEIT
			MOV		AX,[ClipY1]
@@MOVEIT:
			MOV		DI,AX
			SHL		DI,6
			SHL		AX,8
			ADD		DI,AX
			MOV		ES,[VideoSeg]
@@LINELOOP:
			MOV		AX,[Y]
			CMP		AX,[YMax]
			JG		@@EXIT
			CMP		AX,[ClipY1]
			JL		@@NEXTLINE
			CMP		AX,[ClipY2]
			JG		@@EXIT

	DB $66;	MOV		AX,$FFFF; DW $7FFF	{ MAX }
	DB $66;	MOV		BX,$0000; DW $8000	{ MIN }
			MOV		CX,[Y]

			CMP		CX,[Min1]
			JL		@@CHECK2
			CMP		CX,[Max1]
			JG		@@CHECK2
	DB $66;	CMP		AX,[WORD PTR CX1]
			JLE		@@CHECK1_2
	DB $66;	MOV		AX,[WORD PTR CX1]
@@CHECK1_2:
	DB $66;	CMP		BX,[WORD PTR CX1]
			JGE		@@CHECK2
	DB $66;	MOV		BX,[WORD PTR CX1]

@@CHECK2:
			CMP		CX,[Min2]
			JL		@@CHECK3
			CMP		CX,[Max2]
			JG		@@CHECK3
	DB $66;	CMP		AX,[WORD PTR CX2]
			JLE		@@CHECK2_2
	DB $66;	MOV		AX,[WORD PTR CX2]
@@CHECK2_2:
	DB $66;	CMP		BX,[WORD PTR CX2]
			JGE		@@CHECK3
	DB $66;	MOV		BX,[WORD PTR CX2]

@@CHECK3:
			CMP		CX,[Min3]
			JL		@@CHECK4
			CMP		CX,[Max3]
			JG		@@CHECK4
	DB $66;	CMP		AX,[WORD PTR CX3]
			JLE		@@CHECK3_2
	DB $66;	MOV		AX,[WORD PTR CX3]
@@CHECK3_2:
	DB $66;	CMP		BX,[WORD PTR CX3]
			JGE		@@CHECK4
	DB $66;	MOV		BX,[WORD PTR CX3]

@@CHECK4:
			CMP		CX,[Min4]
			JL		@@CHECK5
			CMP		CX,[Max4]
			JG		@@CHECK5
	DB $66;	CMP		AX,[WORD PTR CX4]
			JLE		@@CHECK4_2
	DB $66;	MOV		AX,[WORD PTR CX4]
@@CHECK4_2:
	DB $66;	CMP		BX,[WORD PTR CX4]
			JGE		@@CHECK5
	DB $66;	MOV		BX,[WORD PTR CX4]
@@CHECK5:

	DB $66;	XOR		CX,CX
	DB $66;	SAR		AX,Scaler
	DB $66;	ADC		AX,CX
	DB $66;	SAR		BX,Scaler
	DB $66;	ADC		BX,CX

			CMP		AX,[ClipX2]
			JG		@@NEXTLINE
			CMP		BX,[ClipX1]
			JL		@@NEXTLINE

			CMP		BX,[ClipX2]
			JLE		@@MAXISOK
			MOV		BX,[ClipX2]
@@MAXISOK:
			CMP		AX,[ClipX1]
			JGE		@@MINISOK
			MOV		AX,[ClipX1]
@@MINISOK:
			MOV		SI,DI

			MOV		CX,BX
			SUB		CX,AX
			INC		CX
			ADD		DI,AX

	DB $66;	MOV		AX,[WORD PTR CDWord]
{			JCXZ	@@SKIP2
			TEST	DI,$0001
			JZ		@@NOTONE
			MOV		[ES:DI],AL
			INC		DI
			DEC		CX
			JZ		@@SKIP2
@@NOTONE:
			CMP		CX,2
			JB		@@NOTTWO
			TEST	DI,$0002
			JZ		@@NOTTWO
			MOV		[ES:DI],AX
			ADD		DI,2
			SUB		CX,2
			JZ		@@SKIP2
@@NOTTWO: }
			SHR		CX,1
			DB $0F, $92, $C3			{ SETC BL }
			SHR		CX,1
	DB $66;	REP		STOSW
			JNC		@@SKIP1
			MOV		[ES:DI],AX
			ADD		DI,2
@@SKIP1:
			OR		BL,BL
			JZ		@@SKIP2
			MOV		[ES:DI],AL
			INC		DI
@@SKIP2:
			MOV		DI,SI
@@NEXTLINE:
			MOV		AX,[Y]
			CMP		AX,[Min1]
			JL		@@ADJ2
			CMP		AX,[Max1]
			JG		@@ADJ2
	DB $66;	MOV		BX,[WORD PTR DX1]
	DB $66;	ADD		[WORD PTR CX1],BX
@@ADJ2:
			CMP		AX,[Min2]
			JL		@@ADJ3
			CMP		AX,[Max2]
			JG		@@ADJ3
	DB $66;	MOV		BX,[WORD PTR DX2]
	DB $66;	ADD		[WORD PTR CX2],BX
@@ADJ3:
			CMP		AX,[Min3]
			JL		@@ADJ4
			CMP		AX,[Max3]
			JG		@@ADJ4
	DB $66;	MOV		BX,[WORD PTR DX3]
	DB $66;	ADD		[WORD PTR CX3],BX
@@ADJ4:
			CMP		AX,[Min4]
			JL		@@ADJ5
			CMP		AX,[Max4]
			JG		@@ADJ5
	DB $66;	MOV		BX,[WORD PTR DX4]
	DB $66;	ADD		[WORD PTR CX4],BX
@@ADJ5:
			MOV		AX,[Y]
			CMP		AX,[ClipY1]
			JL		@@ONLY_Y
			ADD		DI,320
@@ONLY_Y:
			INC		[Y]
			JMP		@@LINELOOP
@@EXIT:
End;

Procedure XQuadraGlenzADD(X1,Y1,X2,Y2,X3,Y3,X4,Y4 : Integer; Color : Byte; VideoSeg : Word); Assembler;
Var
	XX1,XX2		: LongInt;
	XX3,XX4		: LongInt;
	DX1,DX2		: LongInt;
	DX3,DX4		: LongInt;
	CX1,CX2		: LongInt;		{ Moves from 1 to 2, 2 to 3 }
	CX3,CX4		: LongInt;		{ Moves from 3 to 4, 1 to 4 }
	Min1,Min2	: Integer;
	Min3,Min4	: Integer;
	Max1,Max2	: Integer;
	Max3,Max4	: Integer;
	Y,YMin,YMax	: Integer;
	CDWord		: LongInt;
Asm
			CLD
			MOV		BL,[Color]
			MOV		BH,BL
			MOV		AX,BX
	DB $66;	SHL		AX,16
			MOV		AX,BX
	DB $66;	MOV		[WORD PTR CDWord],AX

			MOV		AX,[Y1]		{ AX = YMin }
			MOV		BX,AX		{ BX = YMax }
			CMP		AX,[Y2]
			JLE		@@OK1
			MOV		AX,[Y2]
@@OK1:
			CMP		AX,[Y3]
			JLE		@@OK2
			MOV		AX,[Y3]
@@OK2:
			CMP		AX,[Y4]
			JLE		@@OK3
			MOV		AX,[Y4]
@@OK3:
			CMP		BX,[Y2]
			JGE		@@OK4
			MOV		BX,[Y2]
@@OK4:
			CMP		BX,[Y3]
			JGE		@@OK5
			MOV		BX,[Y3]
@@OK5:
			CMP		BX,[Y4]
			JGE		@@OK6
			MOV		BX,[Y4]
@@OK6:
			MOV		[YMin],AX
			MOV		[YMax],BX

			DB $66, $0F, $BF, $46, OFFSET X1	{ MOVSX EAX,[X1] }
	DB $66;	SAL		AX,Scaler
	DB $66;	MOV		[WORD PTR XX1],AX
			DB $66, $0F, $BF, $46, OFFSET X2	{ MOVSX EAX,[X2] }
	DB $66;	SAL		AX,Scaler
	DB $66;	MOV		[WORD PTR XX2],AX
			DB $66, $0F, $BF, $46, OFFSET X3	{ MOVSX EAX,[X3] }
	DB $66;	SAL		AX,Scaler
	DB $66;	MOV		[WORD PTR XX3],AX
			DB $66, $0F, $BF, $46, OFFSET X4	{ MOVSX EAX,[X4] }
	DB $66;	SAL		AX,Scaler
	DB $66;	MOV		[WORD PTR XX4],AX

			MOV		AX,[Y1]
			CMP		AX,[Y2]
			JE		@@EQ1
	DB $66;	MOV		AX,[WORD PTR XX2]
	DB $66;	SUB		AX,[WORD PTR XX1]
	DB $66;	CWD
			MOV     BX,[Y2]
			SUB		BX,[Y1]
			DB $66, $0F, $BF, $CB				{ MOVSX ECX,BX }
	DB $66;	IDIV	CX
	DB $66;	MOV		[WORD PTR DX1],AX
			JMP		@@LINEISOK_1
@@EQ1:
	DB $66;	XOR		AX,AX
	DB $66;	MOV		[WORD PTR DX1],AX
@@LINEISOK_1:

			MOV		AX,[Y2]
			CMP		AX,[Y3]
			JE		@@EQ2
	DB $66;	MOV		AX,[WORD PTR XX3]
	DB $66;	SUB		AX,[WORD PTR XX2]
	DB $66;	CWD
			MOV     BX,[Y3]
			SUB		BX,[Y2]
			DB $66, $0F, $BF, $CB				{ MOVSX ECX,BX }
	DB $66;	IDIV	CX
	DB $66;	MOV		[WORD PTR DX2],AX
			JMP		@@LINEISOK_2
@@EQ2:
	DB $66;	XOR		AX,AX
	DB $66;	MOV		[WORD PTR DX2],AX
@@LINEISOK_2:

			MOV		AX,[Y3]
			CMP		AX,[Y4]
			JE		@@EQ3
	DB $66;	MOV		AX,[WORD PTR XX4]
	DB $66;	SUB		AX,[WORD PTR XX3]
	DB $66;	CWD
			MOV     BX,[Y4]
			SUB		BX,[Y3]
			DB $66, $0F, $BF, $CB				{ MOVSX ECX,BX }
	DB $66;	IDIV	CX
	DB $66;	MOV		[WORD PTR DX3],AX
			JMP		@@LINEISOK_3
@@EQ3:
	DB $66;	XOR		AX,AX
	DB $66;	MOV		[WORD PTR DX3],AX
@@LINEISOK_3:

			MOV		AX,[Y1]
			CMP		AX,[Y4]
			JE		@@EQ4
	DB $66;	MOV		AX,[WORD PTR XX4]
	DB $66;	SUB		AX,[WORD PTR XX1]
	DB $66;	CWD
			MOV     BX,[Y4]
			SUB		BX,[Y1]
			DB $66, $0F, $BF, $CB				{ MOVSX ECX,BX }
	DB $66;	IDIV	CX
	DB $66;	MOV		[WORD PTR DX4],AX
			JMP		@@LINEISOK_4
@@EQ4:
	DB $66;	XOR		AX,AX
	DB $66;	MOV		[WORD PTR DX4],AX
@@LINEISOK_4:

			MOV		BX,[Y1]
			CMP		BX,[Y2]
			JLE		@@DIR12
	DB $66;	MOV		AX,[WORD PTR XX2]
	DB $66;	MOV		[WORD PTR CX1],AX
			JMP		@@CHECKDIR2
@@DIR12:
	DB $66;	MOV		AX,[WORD PTR XX1]
	DB $66;	MOV		[WORD PTR CX1],AX

@@CHECKDIR2:
			MOV		BX,[Y2]
			CMP		BX,[Y3]
			JLE		@@DIR23
	DB $66;	MOV		AX,[WORD PTR XX3]
	DB $66;	MOV		[WORD PTR CX2],AX
			JMP		@@CHECKDIR3
@@DIR23:
	DB $66;	MOV		AX,[WORD PTR XX2]
	DB $66;	MOV		[WORD PTR CX2],AX

@@CHECKDIR3:
			MOV		BX,[Y3]
			CMP		BX,[Y4]
			JLE		@@DIR34
	DB $66;	MOV		AX,[WORD PTR XX4]
	DB $66;	MOV		[WORD PTR CX3],AX
			JMP		@@CHECKDIR4
@@DIR34:
	DB $66;	MOV		AX,[WORD PTR XX3]
	DB $66;	MOV		[WORD PTR CX3],AX

@@CHECKDIR4:
			MOV		BX,[Y1]
			CMP		BX,[Y4]
			JLE		@@DIR14
	DB $66;	MOV		AX,[WORD PTR XX4]
	DB $66;	MOV		[WORD PTR CX4],AX
			JMP		@@NODIRSLEFT
@@DIR14:
	DB $66;	MOV		AX,[WORD PTR XX1]
	DB $66;	MOV		[WORD PTR CX4],AX
@@NODIRSLEFT:
			MOV		AX,[Y1]
			MOV		BX,[Y2]
			CMP		AX,BX
			JLE		@@USELINE1
			XCHG	AX,BX
@@USELINE1:
			MOV		[Min1],AX
			MOV		[Max1],BX

			MOV		AX,[Y2]
			MOV		BX,[Y3]
			CMP		AX,BX
			JLE		@@USELINE2
			XCHG	AX,BX
@@USELINE2:
			MOV		[Min2],AX
			MOV		[Max2],BX

			MOV		AX,[Y3]
			MOV		BX,[Y4]
			CMP		AX,BX
			JLE		@@USELINE3
			XCHG	AX,BX
@@USELINE3:
			MOV		[Min3],AX
			MOV		[Max3],BX

			MOV		AX,[Y1]
			MOV		BX,[Y4]
			CMP		AX,BX
			JLE		@@USELINE4
			XCHG	AX,BX
@@USELINE4:
			MOV		[Min4],AX
			MOV		[Max4],BX

			MOV		AX,[YMin]
			MOV		[Y],AX
			TEST	AX,AX
			JGE		@@MOVEIT
			SUB		AX,AX
@@MOVEIT:
			MOV		DI,AX
			SHL		DI,6
			SHL		AX,8
			ADD		DI,AX
			MOV		ES,[VideoSeg]

@@LINELOOP:
			MOV		AX,[Y]
			CMP		AX,[YMax]
			JG		@@EXIT
			CMP		AX,0
			JL		@@NEXTLINE
			CMP		AX,199
			JG		@@EXIT

	DB $66;	MOV		AX,$FFFF; DW $7FFF	{ MAX }
	DB $66;	MOV		BX,$0000; DW $8000	{ MIN }
			MOV		CX,[Y]

			CMP		CX,[Min1]
			JL		@@CHECK2
			CMP		CX,[Max1]
			JG		@@CHECK2
	DB $66;	CMP		AX,[WORD PTR CX1]
			JLE		@@CHECK1_2
	DB $66;	MOV		AX,[WORD PTR CX1]
@@CHECK1_2:
	DB $66;	CMP		BX,[WORD PTR CX1]
			JGE		@@CHECK2
	DB $66;	MOV		BX,[WORD PTR CX1]

@@CHECK2:
			CMP		CX,[Min2]
			JL		@@CHECK3
			CMP		CX,[Max2]
			JG		@@CHECK3
	DB $66;	CMP		AX,[WORD PTR CX2]
			JLE		@@CHECK2_2
	DB $66;	MOV		AX,[WORD PTR CX2]
@@CHECK2_2:
	DB $66;	CMP		BX,[WORD PTR CX2]
			JGE		@@CHECK3
	DB $66;	MOV		BX,[WORD PTR CX2]

@@CHECK3:
			CMP		CX,[Min3]
			JL		@@CHECK4
			CMP		CX,[Max3]
			JG		@@CHECK4
	DB $66;	CMP		AX,[WORD PTR CX3]
			JLE		@@CHECK3_2
	DB $66;	MOV		AX,[WORD PTR CX3]
@@CHECK3_2:
	DB $66;	CMP		BX,[WORD PTR CX3]
			JGE		@@CHECK4
	DB $66;	MOV		BX,[WORD PTR CX3]

@@CHECK4:
			CMP		CX,[Min4]
			JL		@@CHECK5
			CMP		CX,[Max4]
			JG		@@CHECK5
	DB $66;	CMP		AX,[WORD PTR CX4]
			JLE		@@CHECK4_2
	DB $66;	MOV		AX,[WORD PTR CX4]
@@CHECK4_2:
	DB $66;	CMP		BX,[WORD PTR CX4]
			JGE		@@CHECK5
	DB $66;	MOV		BX,[WORD PTR CX4]
@@CHECK5:

	DB $66;	PUSH	CX
	DB $66;	XOR		CX,CX
	DB $66;	SAR		AX,Scaler
	DB $66;	ADC		AX,CX
	DB $66;	SAR		BX,Scaler
	DB $66;	ADC		BX,CX
	DB $66;	POP		CX

			CMP		AX,319
			JG		@@NEXTLINE
			TEST	BX,BX
			JL		@@NEXTLINE

			CMP		BX,319
			JLE		@@MAXISOK
			MOV		BX,319
@@MAXISOK:
			TEST	AX,AX
			JGE		@@MINISOK
			SUB		AX,AX
@@MINISOK:
			MOV		SI,DI

			MOV		CX,BX
			SUB		CX,AX
			INC		CX

			ADD		DI,AX
	DB $66;	MOV		AX,[WORD PTR CDWord]
			JCXZ	@@SKIP2
			TEST	DI,$0001
			JZ		@@NOTONE
			ADD		[BYTE PTR ES:DI],AL
			INC		DI
			DEC		CX
			JZ		@@SKIP2
@@NOTONE:
			CMP		CX,2
			JB		@@NOTTWO
			TEST	DI,$0002
			JZ		@@NOTTWO
			ADD		[WORD PTR ES:DI],AX
			ADD		DI,2
			SUB		CX,2
			JZ		@@SKIP2
@@NOTTWO:
			SHR		CX,1
			DB $0F, $92, $C3
			SHR		CX,1
			DB $0F, $92, $C7
			JCXZ	@@SKIP0
@@STOSLOOP:
	DB $66;	ADD		[WORD PTR ES:DI],AX
			ADD		DI,4
			DEC		CX
			JNZ		@@STOSLOOP
@@SKIP0:
			OR		BH,BH
			JZ		@@SKIP1
			ADD		[WORD PTR ES:DI],AX
			ADD		DI,2
@@SKIP1:
			OR		BL,BL
			JZ		@@SKIP2
			ADD		[BYTE PTR ES:DI],AL
			INC		DI
@@SKIP2:
			MOV		DI,SI
@@NEXTLINE:
			MOV		AX,[Y]
			CMP		AX,[Min1]
			JL		@@ADJ2
			CMP		AX,[Max1]
			JG		@@ADJ2
	DB $66;	MOV		BX,[WORD PTR DX1]
	DB $66;	ADD		[WORD PTR CX1],BX
@@ADJ2:
			CMP		AX,[Min2]
			JL		@@ADJ3
			CMP		AX,[Max2]
			JG		@@ADJ3
	DB $66;	MOV		BX,[WORD PTR DX2]
	DB $66;	ADD		[WORD PTR CX2],BX
@@ADJ3:
			CMP		AX,[Min3]
			JL		@@ADJ4
			CMP		AX,[Max3]
			JG		@@ADJ4
	DB $66;	MOV		BX,[WORD PTR DX3]
	DB $66;	ADD		[WORD PTR CX3],BX
@@ADJ4:
			CMP		AX,[Min4]
			JL		@@ADJ5
			CMP		AX,[Max4]
			JG		@@ADJ5
	DB $66;	MOV		BX,[WORD PTR DX4]
	DB $66;	ADD		[WORD PTR CX4],BX
@@ADJ5:
			MOV		AX,[Y]
			CMP		AX,0
			JL		@@ONLY_Y
			ADD		DI,320
@@ONLY_Y:
			INC		[Y]
			JMP		@@LINELOOP
@@EXIT:
End;

Procedure XQuadraGlenzADDClip(X1,Y1,X2,Y2,X3,Y3,X4,Y4,ClipX1,ClipY1,ClipX2,ClipY2 : Integer;
	Color : Byte; VideoSeg : Word); Assembler;
Var
	XX1,XX2		: LongInt;
	XX3,XX4		: LongInt;
	DX1,DX2		: LongInt;
	DX3,DX4		: LongInt;
	CX1,CX2		: LongInt;		{ Moves from 1 to 2, 2 to 3 }
	CX3,CX4		: LongInt;		{ Moves from 3 to 4, 1 to 4 }
	Min1,Min2	: Integer;
	Min3,Min4	: Integer;
	Max1,Max2	: Integer;
	Max3,Max4	: Integer;
	Y,YMin,YMax	: Integer;
	CDWord		: LongInt;
Asm
			CLD
			MOV		BL,[Color]
			MOV		BH,BL
			MOV		AX,BX
	DB $66;	SHL		AX,16
			MOV		AX,BX
	DB $66;	MOV		[WORD PTR CDWord],AX

			MOV		AX,[Y1]		{ AX = YMin }
			MOV		BX,AX		{ BX = YMax }
			CMP		AX,[Y2]
			JLE		@@OK1
			MOV		AX,[Y2]
@@OK1:
			CMP		AX,[Y3]
			JLE		@@OK2
			MOV		AX,[Y3]
@@OK2:
			CMP		AX,[Y4]
			JLE		@@OK3
			MOV		AX,[Y4]
@@OK3:
			CMP		BX,[Y2]
			JGE		@@OK4
			MOV		BX,[Y2]
@@OK4:
			CMP		BX,[Y3]
			JGE		@@OK5
			MOV		BX,[Y3]
@@OK5:
			CMP		BX,[Y4]
			JGE		@@OK6
			MOV		BX,[Y4]
@@OK6:
			MOV		[YMin],AX
			MOV		[YMax],BX

			DB $66, $0F, $BF, $46, OFFSET X1	{ MOVSX EAX,[X1] }
	DB $66;	SAL		AX,Scaler
	DB $66;	MOV		[WORD PTR XX1],AX
			DB $66, $0F, $BF, $46, OFFSET X2	{ MOVSX EAX,[X2] }
	DB $66;	SAL		AX,Scaler
	DB $66;	MOV		[WORD PTR XX2],AX
			DB $66, $0F, $BF, $46, OFFSET X3	{ MOVSX EAX,[X3] }
	DB $66;	SAL		AX,Scaler
	DB $66;	MOV		[WORD PTR XX3],AX
			DB $66, $0F, $BF, $46, OFFSET X4	{ MOVSX EAX,[X4] }
	DB $66;	SAL		AX,Scaler
	DB $66;	MOV		[WORD PTR XX4],AX

			MOV		AX,[Y1]
			CMP		AX,[Y2]
			JE		@@EQ1
	DB $66;	MOV		AX,[WORD PTR XX2]
	DB $66;	SUB		AX,[WORD PTR XX1]
	DB $66;	CWD
			MOV     BX,[Y2]
			SUB		BX,[Y1]
			DB $66, $0F, $BF, $CB				{ MOVSX ECX,BX }
	DB $66;	IDIV	CX
	DB $66;	MOV		[WORD PTR DX1],AX
			JMP		@@LINEISOK_1
@@EQ1:
	DB $66;	XOR		AX,AX
	DB $66;	MOV		[WORD PTR DX1],AX
@@LINEISOK_1:

			MOV		AX,[Y2]
			CMP		AX,[Y3]
			JE		@@EQ2
	DB $66;	MOV		AX,[WORD PTR XX3]
	DB $66;	SUB		AX,[WORD PTR XX2]
	DB $66;	CWD
			MOV     BX,[Y3]
			SUB		BX,[Y2]
			DB $66, $0F, $BF, $CB				{ MOVSX ECX,BX }
	DB $66;	IDIV	CX
	DB $66;	MOV		[WORD PTR DX2],AX
			JMP		@@LINEISOK_2
@@EQ2:
	DB $66;	XOR		AX,AX
	DB $66;	MOV		[WORD PTR DX2],AX
@@LINEISOK_2:

			MOV		AX,[Y3]
			CMP		AX,[Y4]
			JE		@@EQ3
	DB $66;	MOV		AX,[WORD PTR XX4]
	DB $66;	SUB		AX,[WORD PTR XX3]
	DB $66;	CWD
			MOV     BX,[Y4]
			SUB		BX,[Y3]
			DB $66, $0F, $BF, $CB				{ MOVSX ECX,BX }
	DB $66;	IDIV	CX
	DB $66;	MOV		[WORD PTR DX3],AX
			JMP		@@LINEISOK_3
@@EQ3:
	DB $66;	XOR		AX,AX
	DB $66;	MOV		[WORD PTR DX3],AX
@@LINEISOK_3:

			MOV		AX,[Y1]
			CMP		AX,[Y4]
			JE		@@EQ4
	DB $66;	MOV		AX,[WORD PTR XX4]
	DB $66;	SUB		AX,[WORD PTR XX1]
	DB $66;	CWD
			MOV     BX,[Y4]
			SUB		BX,[Y1]
			DB $66, $0F, $BF, $CB				{ MOVSX ECX,BX }
	DB $66;	IDIV	CX
	DB $66;	MOV		[WORD PTR DX4],AX
			JMP		@@LINEISOK_4
@@EQ4:
	DB $66;	XOR		AX,AX
	DB $66;	MOV		[WORD PTR DX4],AX
@@LINEISOK_4:

			MOV		BX,[Y1]
			CMP		BX,[Y2]
			JLE		@@DIR12
	DB $66;	MOV		AX,[WORD PTR XX2]
	DB $66;	MOV		[WORD PTR CX1],AX
			JMP		@@CHECKDIR2
@@DIR12:
	DB $66;	MOV		AX,[WORD PTR XX1]
	DB $66;	MOV		[WORD PTR CX1],AX

@@CHECKDIR2:
			MOV		BX,[Y2]
			CMP		BX,[Y3]
			JLE		@@DIR23
	DB $66;	MOV		AX,[WORD PTR XX3]
	DB $66;	MOV		[WORD PTR CX2],AX
			JMP		@@CHECKDIR3
@@DIR23:
	DB $66;	MOV		AX,[WORD PTR XX2]
	DB $66;	MOV		[WORD PTR CX2],AX

@@CHECKDIR3:
			MOV		BX,[Y3]
			CMP		BX,[Y4]
			JLE		@@DIR34
	DB $66;	MOV		AX,[WORD PTR XX4]
	DB $66;	MOV		[WORD PTR CX3],AX
			JMP		@@CHECKDIR4
@@DIR34:
	DB $66;	MOV		AX,[WORD PTR XX3]
	DB $66;	MOV		[WORD PTR CX3],AX

@@CHECKDIR4:
			MOV		BX,[Y1]
			CMP		BX,[Y4]
			JLE		@@DIR14
	DB $66;	MOV		AX,[WORD PTR XX4]
	DB $66;	MOV		[WORD PTR CX4],AX
			JMP		@@NODIRSLEFT
@@DIR14:
	DB $66;	MOV		AX,[WORD PTR XX1]
	DB $66;	MOV		[WORD PTR CX4],AX
@@NODIRSLEFT:
			MOV		AX,[Y1]
			MOV		BX,[Y2]
			CMP		AX,BX
			JLE		@@USELINE1
			XCHG	AX,BX
@@USELINE1:
			MOV		[Min1],AX
			MOV		[Max1],BX

			MOV		AX,[Y2]
			MOV		BX,[Y3]
			CMP		AX,BX
			JLE		@@USELINE2
			XCHG	AX,BX
@@USELINE2:
			MOV		[Min2],AX
			MOV		[Max2],BX

			MOV		AX,[Y3]
			MOV		BX,[Y4]
			CMP		AX,BX
			JLE		@@USELINE3
			XCHG	AX,BX
@@USELINE3:
			MOV		[Min3],AX
			MOV		[Max3],BX

			MOV		AX,[Y1]
			MOV		BX,[Y4]
			CMP		AX,BX
			JLE		@@USELINE4
			XCHG	AX,BX
@@USELINE4:
			MOV		[Min4],AX
			MOV		[Max4],BX

			MOV		AX,[YMin]
			MOV		[Y],AX
			CMP		AX,[ClipY1]
			JGE		@@MOVEIT
			MOV		AX,[ClipY1]
@@MOVEIT:
			MOV		DI,AX
			SHL		DI,6
			SHL		AX,8
			ADD		DI,AX
			MOV		ES,[VideoSeg]
@@LINELOOP:
			MOV		AX,[Y]
			CMP		AX,[YMax]
			JG		@@EXIT
			CMP		AX,[ClipY1]
			JL		@@NEXTLINE
			CMP		AX,[ClipY2]
			JG		@@EXIT

	DB $66;	MOV		AX,$FFFF; DW $7FFF	{ MAX }
	DB $66;	MOV		BX,$0000; DW $8000	{ MIN }
			MOV		CX,[Y]

			CMP		CX,[Min1]
			JL		@@CHECK2
			CMP		CX,[Max1]
			JG		@@CHECK2
	DB $66;	CMP		AX,[WORD PTR CX1]
			JLE		@@CHECK1_2
	DB $66;	MOV		AX,[WORD PTR CX1]
@@CHECK1_2:
	DB $66;	CMP		BX,[WORD PTR CX1]
			JGE		@@CHECK2
	DB $66;	MOV		BX,[WORD PTR CX1]

@@CHECK2:
			CMP		CX,[Min2]
			JL		@@CHECK3
			CMP		CX,[Max2]
			JG		@@CHECK3
	DB $66;	CMP		AX,[WORD PTR CX2]
			JLE		@@CHECK2_2
	DB $66;	MOV		AX,[WORD PTR CX2]
@@CHECK2_2:
	DB $66;	CMP		BX,[WORD PTR CX2]
			JGE		@@CHECK3
	DB $66;	MOV		BX,[WORD PTR CX2]

@@CHECK3:
			CMP		CX,[Min3]
			JL		@@CHECK4
			CMP		CX,[Max3]
			JG		@@CHECK4
	DB $66;	CMP		AX,[WORD PTR CX3]
			JLE		@@CHECK3_2
	DB $66;	MOV		AX,[WORD PTR CX3]
@@CHECK3_2:
	DB $66;	CMP		BX,[WORD PTR CX3]
			JGE		@@CHECK4
	DB $66;	MOV		BX,[WORD PTR CX3]

@@CHECK4:
			CMP		CX,[Min4]
			JL		@@CHECK5
			CMP		CX,[Max4]
			JG		@@CHECK5
	DB $66;	CMP		AX,[WORD PTR CX4]
			JLE		@@CHECK4_2
	DB $66;	MOV		AX,[WORD PTR CX4]
@@CHECK4_2:
	DB $66;	CMP		BX,[WORD PTR CX4]
			JGE		@@CHECK5
	DB $66;	MOV		BX,[WORD PTR CX4]
@@CHECK5:

	DB $66;	PUSH	CX
	DB $66;	XOR		CX,CX
	DB $66;	SAR		AX,Scaler
	DB $66;	ADC		AX,CX
	DB $66;	SAR		BX,Scaler
	DB $66;	ADC		BX,CX
	DB $66;	POP		CX

			CMP		AX,[ClipX2]
			JG		@@NEXTLINE
			CMP		BX,[ClipX1]
			JL		@@NEXTLINE

			CMP		BX,[ClipX2]
			JLE		@@MAXISOK
			MOV		BX,[ClipX2]
@@MAXISOK:
			CMP		AX,[ClipX1]
			JGE		@@MINISOK
			MOV		AX,[ClipX1]
@@MINISOK:
			MOV		SI,DI

			MOV		CX,BX
			SUB		CX,AX
			INC		CX

			ADD		DI,AX
	DB $66;	MOV		AX,[WORD PTR CDWord]
			JCXZ	@@SKIP2
			TEST	DI,$0001
			JZ		@@NOTONE
			ADD		[BYTE PTR ES:DI],AL
			INC		DI
			DEC		CX
			JZ		@@SKIP2
@@NOTONE:
			CMP		CX,2
			JB		@@NOTTWO
			TEST	DI,$0002
			JZ		@@NOTTWO
			ADD		[WORD PTR ES:DI],AX
			ADD		DI,2
			SUB		CX,2
			JZ		@@SKIP2
@@NOTTWO:
			SHR		CX,1
			DB $0F, $92, $C3
			SHR		CX,1
			DB $0F, $92, $C7
			JCXZ	@@SKIP0
@@STOSLOOP:
	DB $66;	ADD		[WORD PTR ES:DI],AX
			ADD		DI,4
			DEC		CX
			JNZ		@@STOSLOOP
@@SKIP0:
			OR		BH,BH
			JZ		@@SKIP1
			ADD		[WORD PTR ES:DI],AX
			ADD		DI,2
@@SKIP1:
			OR		BL,BL
			JZ		@@SKIP2
			ADD		[BYTE PTR ES:DI],AL
			INC		DI
@@SKIP2:
			MOV		DI,SI
@@NEXTLINE:
			MOV		AX,[Y]
			CMP		AX,[Min1]
			JL		@@ADJ2
			CMP		AX,[Max1]
			JG		@@ADJ2
	DB $66;	MOV		BX,[WORD PTR DX1]
	DB $66;	ADD		[WORD PTR CX1],BX
@@ADJ2:
			CMP		AX,[Min2]
			JL		@@ADJ3
			CMP		AX,[Max2]
			JG		@@ADJ3
	DB $66;	MOV		BX,[WORD PTR DX2]
	DB $66;	ADD		[WORD PTR CX2],BX
@@ADJ3:
			CMP		AX,[Min3]
			JL		@@ADJ4
			CMP		AX,[Max3]
			JG		@@ADJ4
	DB $66;	MOV		BX,[WORD PTR DX3]
	DB $66;	ADD		[WORD PTR CX3],BX
@@ADJ4:
			CMP		AX,[Min4]
			JL		@@ADJ5
			CMP		AX,[Max4]
			JG		@@ADJ5
	DB $66;	MOV		BX,[WORD PTR DX4]
	DB $66;	ADD		[WORD PTR CX4],BX
@@ADJ5:
			MOV		AX,[Y]
			CMP		AX,[ClipY1]
			JL		@@ONLY_Y
			ADD		DI,320
@@ONLY_Y:
			INC		[Y]
			JMP		@@LINELOOP
@@EXIT:
End;

Procedure XQuadraGlenzSUB(X1,Y1,X2,Y2,X3,Y3,X4,Y4 : Integer; Color : Byte; VideoSeg : Word); Assembler;
Var
	XX1,XX2		: LongInt;
	XX3,XX4		: LongInt;
	DX1,DX2		: LongInt;
	DX3,DX4		: LongInt;
	CX1,CX2		: LongInt;		{ Moves from 1 to 2, 2 to 3 }
	CX3,CX4		: LongInt;		{ Moves from 3 to 4, 1 to 4 }
	Min1,Min2	: Integer;
	Min3,Min4	: Integer;
	Max1,Max2	: Integer;
	Max3,Max4	: Integer;
	Y,YMin,YMax	: Integer;
	CDWord		: LongInt;
Asm
			CLD
			MOV		BL,[Color]
			MOV		BH,BL
			MOV		AX,BX
	DB $66;	SHL		AX,16
			MOV		AX,BX
	DB $66;	MOV		[WORD PTR CDWord],AX

			MOV		AX,[Y1]		{ AX = YMin }
			MOV		BX,AX		{ BX = YMax }
			CMP		AX,[Y2]
			JLE		@@OK1
			MOV		AX,[Y2]
@@OK1:
			CMP		AX,[Y3]
			JLE		@@OK2
			MOV		AX,[Y3]
@@OK2:
			CMP		AX,[Y4]
			JLE		@@OK3
			MOV		AX,[Y4]
@@OK3:
			CMP		BX,[Y2]
			JGE		@@OK4
			MOV		BX,[Y2]
@@OK4:
			CMP		BX,[Y3]
			JGE		@@OK5
			MOV		BX,[Y3]
@@OK5:
			CMP		BX,[Y4]
			JGE		@@OK6
			MOV		BX,[Y4]
@@OK6:
			MOV		[YMin],AX
			MOV		[YMax],BX

			DB $66, $0F, $BF, $46, OFFSET X1	{ MOVSX EAX,[X1] }
	DB $66;	SAL		AX,Scaler
	DB $66;	MOV		[WORD PTR XX1],AX
			DB $66, $0F, $BF, $46, OFFSET X2	{ MOVSX EAX,[X2] }
	DB $66;	SAL		AX,Scaler
	DB $66;	MOV		[WORD PTR XX2],AX
			DB $66, $0F, $BF, $46, OFFSET X3	{ MOVSX EAX,[X3] }
	DB $66;	SAL		AX,Scaler
	DB $66;	MOV		[WORD PTR XX3],AX
			DB $66, $0F, $BF, $46, OFFSET X4	{ MOVSX EAX,[X4] }
	DB $66;	SAL		AX,Scaler
	DB $66;	MOV		[WORD PTR XX4],AX

			MOV		AX,[Y1]
			CMP		AX,[Y2]
			JE		@@EQ1
	DB $66;	MOV		AX,[WORD PTR XX2]
	DB $66;	SUB		AX,[WORD PTR XX1]
	DB $66;	CWD
			MOV     BX,[Y2]
			SUB		BX,[Y1]
			DB $66, $0F, $BF, $CB				{ MOVSX ECX,BX }
	DB $66;	IDIV	CX
	DB $66;	MOV		[WORD PTR DX1],AX
			JMP		@@LINEISOK_1
@@EQ1:
	DB $66;	XOR		AX,AX
	DB $66;	MOV		[WORD PTR DX1],AX
@@LINEISOK_1:

			MOV		AX,[Y2]
			CMP		AX,[Y3]
			JE		@@EQ2
	DB $66;	MOV		AX,[WORD PTR XX3]
	DB $66;	SUB		AX,[WORD PTR XX2]
	DB $66;	CWD
			MOV     BX,[Y3]
			SUB		BX,[Y2]
			DB $66, $0F, $BF, $CB				{ MOVSX ECX,BX }
	DB $66;	IDIV	CX
	DB $66;	MOV		[WORD PTR DX2],AX
			JMP		@@LINEISOK_2
@@EQ2:
	DB $66;	XOR		AX,AX
	DB $66;	MOV		[WORD PTR DX2],AX
@@LINEISOK_2:

			MOV		AX,[Y3]
			CMP		AX,[Y4]
			JE		@@EQ3
	DB $66;	MOV		AX,[WORD PTR XX4]
	DB $66;	SUB		AX,[WORD PTR XX3]
	DB $66;	CWD
			MOV     BX,[Y4]
			SUB		BX,[Y3]
			DB $66, $0F, $BF, $CB				{ MOVSX ECX,BX }
	DB $66;	IDIV	CX
	DB $66;	MOV		[WORD PTR DX3],AX
			JMP		@@LINEISOK_3
@@EQ3:
	DB $66;	XOR		AX,AX
	DB $66;	MOV		[WORD PTR DX3],AX
@@LINEISOK_3:

			MOV		AX,[Y1]
			CMP		AX,[Y4]
			JE		@@EQ4
	DB $66;	MOV		AX,[WORD PTR XX4]
	DB $66;	SUB		AX,[WORD PTR XX1]
	DB $66;	CWD
			MOV     BX,[Y4]
			SUB		BX,[Y1]
			DB $66, $0F, $BF, $CB				{ MOVSX ECX,BX }
	DB $66;	IDIV	CX
	DB $66;	MOV		[WORD PTR DX4],AX
			JMP		@@LINEISOK_4
@@EQ4:
	DB $66;	XOR		AX,AX
	DB $66;	MOV		[WORD PTR DX4],AX
@@LINEISOK_4:

			MOV		BX,[Y1]
			CMP		BX,[Y2]
			JLE		@@DIR12
	DB $66;	MOV		AX,[WORD PTR XX2]
	DB $66;	MOV		[WORD PTR CX1],AX
			JMP		@@CHECKDIR2
@@DIR12:
	DB $66;	MOV		AX,[WORD PTR XX1]
	DB $66;	MOV		[WORD PTR CX1],AX

@@CHECKDIR2:
			MOV		BX,[Y2]
			CMP		BX,[Y3]
			JLE		@@DIR23
	DB $66;	MOV		AX,[WORD PTR XX3]
	DB $66;	MOV		[WORD PTR CX2],AX
			JMP		@@CHECKDIR3
@@DIR23:
	DB $66;	MOV		AX,[WORD PTR XX2]
	DB $66;	MOV		[WORD PTR CX2],AX

@@CHECKDIR3:
			MOV		BX,[Y3]
			CMP		BX,[Y4]
			JLE		@@DIR34
	DB $66;	MOV		AX,[WORD PTR XX4]
	DB $66;	MOV		[WORD PTR CX3],AX
			JMP		@@CHECKDIR4
@@DIR34:
	DB $66;	MOV		AX,[WORD PTR XX3]
	DB $66;	MOV		[WORD PTR CX3],AX

@@CHECKDIR4:
			MOV		BX,[Y1]
			CMP		BX,[Y4]
			JLE		@@DIR14
	DB $66;	MOV		AX,[WORD PTR XX4]
	DB $66;	MOV		[WORD PTR CX4],AX
			JMP		@@NODIRSLEFT
@@DIR14:
	DB $66;	MOV		AX,[WORD PTR XX1]
	DB $66;	MOV		[WORD PTR CX4],AX
@@NODIRSLEFT:
			MOV		AX,[Y1]
			MOV		BX,[Y2]
			CMP		AX,BX
			JLE		@@USELINE1
			XCHG	AX,BX
@@USELINE1:
			MOV		[Min1],AX
			MOV		[Max1],BX

			MOV		AX,[Y2]
			MOV		BX,[Y3]
			CMP		AX,BX
			JLE		@@USELINE2
			XCHG	AX,BX
@@USELINE2:
			MOV		[Min2],AX
			MOV		[Max2],BX

			MOV		AX,[Y3]
			MOV		BX,[Y4]
			CMP		AX,BX
			JLE		@@USELINE3
			XCHG	AX,BX
@@USELINE3:
			MOV		[Min3],AX
			MOV		[Max3],BX

			MOV		AX,[Y1]
			MOV		BX,[Y4]
			CMP		AX,BX
			JLE		@@USELINE4
			XCHG	AX,BX
@@USELINE4:
			MOV		[Min4],AX
			MOV		[Max4],BX

			MOV		AX,[YMin]
			MOV		[Y],AX
			TEST	AX,AX
			JGE		@@MOVEIT
			SUB		AX,AX
@@MOVEIT:
			MOV		DI,AX
			SHL		DI,6
			SHL		AX,8
			ADD		DI,AX
			MOV		ES,[VideoSeg]

@@LINELOOP:
			MOV		AX,[Y]
			CMP		AX,[YMax]
			JG		@@EXIT
			CMP		AX,0
			JL		@@NEXTLINE
			CMP		AX,199
			JG		@@EXIT

	DB $66;	MOV		AX,$FFFF; DW $7FFF	{ MAX }
	DB $66;	MOV		BX,$0000; DW $8000	{ MIN }
			MOV		CX,[Y]

			CMP		CX,[Min1]
			JL		@@CHECK2
			CMP		CX,[Max1]
			JG		@@CHECK2
	DB $66;	CMP		AX,[WORD PTR CX1]
			JLE		@@CHECK1_2
	DB $66;	MOV		AX,[WORD PTR CX1]
@@CHECK1_2:
	DB $66;	CMP		BX,[WORD PTR CX1]
			JGE		@@CHECK2
	DB $66;	MOV		BX,[WORD PTR CX1]

@@CHECK2:
			CMP		CX,[Min2]
			JL		@@CHECK3
			CMP		CX,[Max2]
			JG		@@CHECK3
	DB $66;	CMP		AX,[WORD PTR CX2]
			JLE		@@CHECK2_2
	DB $66;	MOV		AX,[WORD PTR CX2]
@@CHECK2_2:
	DB $66;	CMP		BX,[WORD PTR CX2]
			JGE		@@CHECK3
	DB $66;	MOV		BX,[WORD PTR CX2]

@@CHECK3:
			CMP		CX,[Min3]
			JL		@@CHECK4
			CMP		CX,[Max3]
			JG		@@CHECK4
	DB $66;	CMP		AX,[WORD PTR CX3]
			JLE		@@CHECK3_2
	DB $66;	MOV		AX,[WORD PTR CX3]
@@CHECK3_2:
	DB $66;	CMP		BX,[WORD PTR CX3]
			JGE		@@CHECK4
	DB $66;	MOV		BX,[WORD PTR CX3]

@@CHECK4:
			CMP		CX,[Min4]
			JL		@@CHECK5
			CMP		CX,[Max4]
			JG		@@CHECK5
	DB $66;	CMP		AX,[WORD PTR CX4]
			JLE		@@CHECK4_2
	DB $66;	MOV		AX,[WORD PTR CX4]
@@CHECK4_2:
	DB $66;	CMP		BX,[WORD PTR CX4]
			JGE		@@CHECK5
	DB $66;	MOV		BX,[WORD PTR CX4]
@@CHECK5:

	DB $66;	PUSH	CX
	DB $66;	XOR		CX,CX
	DB $66;	SAR		AX,Scaler
	DB $66;	ADC		AX,CX
	DB $66;	SAR		BX,Scaler
	DB $66;	ADC		BX,CX
	DB $66;	POP		CX

			CMP		AX,319
			JG		@@NEXTLINE
			TEST	BX,BX
			JL		@@NEXTLINE

			CMP		BX,319
			JLE		@@MAXISOK
			MOV		BX,319
@@MAXISOK:
			TEST	AX,AX
			JGE		@@MINISOK
			SUB		AX,AX
@@MINISOK:
			MOV		SI,DI

			MOV		CX,BX
			SUB		CX,AX
			INC		CX

			ADD		DI,AX
	DB $66;	MOV		AX,[WORD PTR CDWord]
			JCXZ	@@SKIP2
			TEST	DI,$0001
			JZ		@@NOTONE
			SUB		[BYTE PTR ES:DI],AL
			INC		DI
			DEC		CX
			JZ		@@SKIP2
@@NOTONE:
			CMP		CX,2
			JB		@@NOTTWO
			TEST	DI,$0002
			JZ		@@NOTTWO
			SUB		[WORD PTR ES:DI],AX
			ADD		DI,2
			SUB		CX,2
			JZ		@@SKIP2
@@NOTTWO:
			SHR		CX,1
			DB $0F, $92, $C3
			SHR		CX,1
			DB $0F, $92, $C7
			JCXZ	@@SKIP0
@@STOSLOOP:
	DB $66;	SUB		[WORD PTR ES:DI],AX
			ADD		DI,4
			DEC		CX
			JNZ		@@STOSLOOP
@@SKIP0:
			OR		BH,BH
			JZ		@@SKIP1
			SUB		[WORD PTR ES:DI],AX
			ADD		DI,2
@@SKIP1:
			OR		BL,BL
			JZ		@@SKIP2
			SUB		[BYTE PTR ES:DI],AL
			INC		DI
@@SKIP2:
			MOV		DI,SI
@@NEXTLINE:
			MOV		AX,[Y]
			CMP		AX,[Min1]
			JL		@@ADJ2
			CMP		AX,[Max1]
			JG		@@ADJ2
	DB $66;	MOV		BX,[WORD PTR DX1]
	DB $66;	ADD		[WORD PTR CX1],BX
@@ADJ2:
			CMP		AX,[Min2]
			JL		@@ADJ3
			CMP		AX,[Max2]
			JG		@@ADJ3
	DB $66;	MOV		BX,[WORD PTR DX2]
	DB $66;	ADD		[WORD PTR CX2],BX
@@ADJ3:
			CMP		AX,[Min3]
			JL		@@ADJ4
			CMP		AX,[Max3]
			JG		@@ADJ4
	DB $66;	MOV		BX,[WORD PTR DX3]
	DB $66;	ADD		[WORD PTR CX3],BX
@@ADJ4:
			CMP		AX,[Min4]
			JL		@@ADJ5
			CMP		AX,[Max4]
			JG		@@ADJ5
	DB $66;	MOV		BX,[WORD PTR DX4]
	DB $66;	ADD		[WORD PTR CX4],BX
@@ADJ5:
			MOV		AX,[Y]
			CMP		AX,0
			JL		@@ONLY_Y
			ADD		DI,320
@@ONLY_Y:
			INC		[Y]
			JMP		@@LINELOOP
@@EXIT:
End;

Procedure XQuadraGlenzSUBClip(X1,Y1,X2,Y2,X3,Y3,X4,Y4,ClipX1,ClipY1,ClipX2,ClipY2 : Integer;
	Color : Byte; VideoSeg : Word); Assembler;
Var
	XX1,XX2		: LongInt;
	XX3,XX4		: LongInt;
	DX1,DX2		: LongInt;
	DX3,DX4		: LongInt;
	CX1,CX2		: LongInt;		{ Moves from 1 to 2, 2 to 3 }
	CX3,CX4		: LongInt;		{ Moves from 3 to 4, 1 to 4 }
	Min1,Min2	: Integer;
	Min3,Min4	: Integer;
	Max1,Max2	: Integer;
	Max3,Max4	: Integer;
	Y,YMin,YMax	: Integer;
	CDWord		: LongInt;
Asm
			CLD
			MOV		BL,[Color]
			MOV		BH,BL
			MOV		AX,BX
	DB $66;	SHL		AX,16
			MOV		AX,BX
	DB $66;	MOV		[WORD PTR CDWord],AX

			MOV		AX,[Y1]		{ AX = YMin }
			MOV		BX,AX		{ BX = YMax }
			CMP		AX,[Y2]
			JLE		@@OK1
			MOV		AX,[Y2]
@@OK1:
			CMP		AX,[Y3]
			JLE		@@OK2
			MOV		AX,[Y3]
@@OK2:
			CMP		AX,[Y4]
			JLE		@@OK3
			MOV		AX,[Y4]
@@OK3:
			CMP		BX,[Y2]
			JGE		@@OK4
			MOV		BX,[Y2]
@@OK4:
			CMP		BX,[Y3]
			JGE		@@OK5
			MOV		BX,[Y3]
@@OK5:
			CMP		BX,[Y4]
			JGE		@@OK6
			MOV		BX,[Y4]
@@OK6:
			MOV		[YMin],AX
			MOV		[YMax],BX

			DB $66, $0F, $BF, $46, OFFSET X1	{ MOVSX EAX,[X1] }
	DB $66;	SAL		AX,Scaler
	DB $66;	MOV		[WORD PTR XX1],AX
			DB $66, $0F, $BF, $46, OFFSET X2	{ MOVSX EAX,[X2] }
	DB $66;	SAL		AX,Scaler
	DB $66;	MOV		[WORD PTR XX2],AX
			DB $66, $0F, $BF, $46, OFFSET X3	{ MOVSX EAX,[X3] }
	DB $66;	SAL		AX,Scaler
	DB $66;	MOV		[WORD PTR XX3],AX
			DB $66, $0F, $BF, $46, OFFSET X4	{ MOVSX EAX,[X4] }
	DB $66;	SAL		AX,Scaler
	DB $66;	MOV		[WORD PTR XX4],AX

			MOV		AX,[Y1]
			CMP		AX,[Y2]
			JE		@@EQ1
	DB $66;	MOV		AX,[WORD PTR XX2]
	DB $66;	SUB		AX,[WORD PTR XX1]
	DB $66;	CWD
			MOV     BX,[Y2]
			SUB		BX,[Y1]
			DB $66, $0F, $BF, $CB				{ MOVSX ECX,BX }
	DB $66;	IDIV	CX
	DB $66;	MOV		[WORD PTR DX1],AX
			JMP		@@LINEISOK_1
@@EQ1:
	DB $66;	XOR		AX,AX
	DB $66;	MOV		[WORD PTR DX1],AX
@@LINEISOK_1:

			MOV		AX,[Y2]
			CMP		AX,[Y3]
			JE		@@EQ2
	DB $66;	MOV		AX,[WORD PTR XX3]
	DB $66;	SUB		AX,[WORD PTR XX2]
	DB $66;	CWD
			MOV     BX,[Y3]
			SUB		BX,[Y2]
			DB $66, $0F, $BF, $CB				{ MOVSX ECX,BX }
	DB $66;	IDIV	CX
	DB $66;	MOV		[WORD PTR DX2],AX
			JMP		@@LINEISOK_2
@@EQ2:
	DB $66;	XOR		AX,AX
	DB $66;	MOV		[WORD PTR DX2],AX
@@LINEISOK_2:

			MOV		AX,[Y3]
			CMP		AX,[Y4]
			JE		@@EQ3
	DB $66;	MOV		AX,[WORD PTR XX4]
	DB $66;	SUB		AX,[WORD PTR XX3]
	DB $66;	CWD
			MOV     BX,[Y4]
			SUB		BX,[Y3]
			DB $66, $0F, $BF, $CB				{ MOVSX ECX,BX }
	DB $66;	IDIV	CX
	DB $66;	MOV		[WORD PTR DX3],AX
			JMP		@@LINEISOK_3
@@EQ3:
	DB $66;	XOR		AX,AX
	DB $66;	MOV		[WORD PTR DX3],AX
@@LINEISOK_3:

			MOV		AX,[Y1]
			CMP		AX,[Y4]
			JE		@@EQ4
	DB $66;	MOV		AX,[WORD PTR XX4]
	DB $66;	SUB		AX,[WORD PTR XX1]
	DB $66;	CWD
			MOV     BX,[Y4]
			SUB		BX,[Y1]
			DB $66, $0F, $BF, $CB				{ MOVSX ECX,BX }
	DB $66;	IDIV	CX
	DB $66;	MOV		[WORD PTR DX4],AX
			JMP		@@LINEISOK_4
@@EQ4:
	DB $66;	XOR		AX,AX
	DB $66;	MOV		[WORD PTR DX4],AX
@@LINEISOK_4:

			MOV		BX,[Y1]
			CMP		BX,[Y2]
			JLE		@@DIR12
	DB $66;	MOV		AX,[WORD PTR XX2]
	DB $66;	MOV		[WORD PTR CX1],AX
			JMP		@@CHECKDIR2
@@DIR12:
	DB $66;	MOV		AX,[WORD PTR XX1]
	DB $66;	MOV		[WORD PTR CX1],AX

@@CHECKDIR2:
			MOV		BX,[Y2]
			CMP		BX,[Y3]
			JLE		@@DIR23
	DB $66;	MOV		AX,[WORD PTR XX3]
	DB $66;	MOV		[WORD PTR CX2],AX
			JMP		@@CHECKDIR3
@@DIR23:
	DB $66;	MOV		AX,[WORD PTR XX2]
	DB $66;	MOV		[WORD PTR CX2],AX

@@CHECKDIR3:
			MOV		BX,[Y3]
			CMP		BX,[Y4]
			JLE		@@DIR34
	DB $66;	MOV		AX,[WORD PTR XX4]
	DB $66;	MOV		[WORD PTR CX3],AX
			JMP		@@CHECKDIR4
@@DIR34:
	DB $66;	MOV		AX,[WORD PTR XX3]
	DB $66;	MOV		[WORD PTR CX3],AX

@@CHECKDIR4:
			MOV		BX,[Y1]
			CMP		BX,[Y4]
			JLE		@@DIR14
	DB $66;	MOV		AX,[WORD PTR XX4]
	DB $66;	MOV		[WORD PTR CX4],AX
			JMP		@@NODIRSLEFT
@@DIR14:
	DB $66;	MOV		AX,[WORD PTR XX1]
	DB $66;	MOV		[WORD PTR CX4],AX
@@NODIRSLEFT:
			MOV		AX,[Y1]
			MOV		BX,[Y2]
			CMP		AX,BX
			JLE		@@USELINE1
			XCHG	AX,BX
@@USELINE1:
			MOV		[Min1],AX
			MOV		[Max1],BX

			MOV		AX,[Y2]
			MOV		BX,[Y3]
			CMP		AX,BX
			JLE		@@USELINE2
			XCHG	AX,BX
@@USELINE2:
			MOV		[Min2],AX
			MOV		[Max2],BX

			MOV		AX,[Y3]
			MOV		BX,[Y4]
			CMP		AX,BX
			JLE		@@USELINE3
			XCHG	AX,BX
@@USELINE3:
			MOV		[Min3],AX
			MOV		[Max3],BX

			MOV		AX,[Y1]
			MOV		BX,[Y4]
			CMP		AX,BX
			JLE		@@USELINE4
			XCHG	AX,BX
@@USELINE4:
			MOV		[Min4],AX
			MOV		[Max4],BX

			MOV		AX,[YMin]
			MOV		[Y],AX
			CMP		AX,[ClipY1]
			JGE		@@MOVEIT
			MOV		AX,[ClipY1]
@@MOVEIT:
			MOV		DI,AX
			SHL		DI,6
			SHL		AX,8
			ADD		DI,AX
			MOV		ES,[VideoSeg]
@@LINELOOP:
			MOV		AX,[Y]
			CMP		AX,[YMax]
			JG		@@EXIT
			CMP		AX,[ClipY1]
			JL		@@NEXTLINE
			CMP		AX,[ClipY2]
			JG		@@EXIT

	DB $66;	MOV		AX,$FFFF; DW $7FFF	{ MAX }
	DB $66;	MOV		BX,$0000; DW $8000	{ MIN }
			MOV		CX,[Y]

			CMP		CX,[Min1]
			JL		@@CHECK2
			CMP		CX,[Max1]
			JG		@@CHECK2
	DB $66;	CMP		AX,[WORD PTR CX1]
			JLE		@@CHECK1_2
	DB $66;	MOV		AX,[WORD PTR CX1]
@@CHECK1_2:
	DB $66;	CMP		BX,[WORD PTR CX1]
			JGE		@@CHECK2
	DB $66;	MOV		BX,[WORD PTR CX1]

@@CHECK2:
			CMP		CX,[Min2]
			JL		@@CHECK3
			CMP		CX,[Max2]
			JG		@@CHECK3
	DB $66;	CMP		AX,[WORD PTR CX2]
			JLE		@@CHECK2_2
	DB $66;	MOV		AX,[WORD PTR CX2]
@@CHECK2_2:
	DB $66;	CMP		BX,[WORD PTR CX2]
			JGE		@@CHECK3
	DB $66;	MOV		BX,[WORD PTR CX2]

@@CHECK3:
			CMP		CX,[Min3]
			JL		@@CHECK4
			CMP		CX,[Max3]
			JG		@@CHECK4
	DB $66;	CMP		AX,[WORD PTR CX3]
			JLE		@@CHECK3_2
	DB $66;	MOV		AX,[WORD PTR CX3]
@@CHECK3_2:
	DB $66;	CMP		BX,[WORD PTR CX3]
			JGE		@@CHECK4
	DB $66;	MOV		BX,[WORD PTR CX3]

@@CHECK4:
			CMP		CX,[Min4]
			JL		@@CHECK5
			CMP		CX,[Max4]
			JG		@@CHECK5
	DB $66;	CMP		AX,[WORD PTR CX4]
			JLE		@@CHECK4_2
	DB $66;	MOV		AX,[WORD PTR CX4]
@@CHECK4_2:
	DB $66;	CMP		BX,[WORD PTR CX4]
			JGE		@@CHECK5
	DB $66;	MOV		BX,[WORD PTR CX4]
@@CHECK5:

	DB $66;	PUSH	CX
	DB $66;	XOR		CX,CX
	DB $66;	SAR		AX,Scaler
	DB $66;	ADC		AX,CX
	DB $66;	SAR		BX,Scaler
	DB $66;	ADC		BX,CX
	DB $66;	POP		CX

			CMP		AX,[ClipX2]
			JG		@@NEXTLINE
			CMP		BX,[ClipX1]
			JL		@@NEXTLINE

			CMP		BX,[ClipX2]
			JLE		@@MAXISOK
			MOV		BX,[ClipX2]
@@MAXISOK:
			CMP		AX,[ClipX1]
			JGE		@@MINISOK
			MOV		AX,[ClipX1]
@@MINISOK:
			MOV		SI,DI

			MOV		CX,BX
			SUB		CX,AX
			INC		CX

			ADD		DI,AX
	DB $66;	MOV		AX,[WORD PTR CDWord]
			JCXZ	@@SKIP2
			TEST	DI,$0001
			JZ		@@NOTONE
			SUB		[BYTE PTR ES:DI],AL
			INC		DI
			DEC		CX
			JZ		@@SKIP2
@@NOTONE:
			CMP		CX,2
			JB		@@NOTTWO
			TEST	DI,$0002
			JZ		@@NOTTWO
			SUB		[WORD PTR ES:DI],AX
			ADD		DI,2
			SUB		CX,2
			JZ		@@SKIP2
@@NOTTWO:
			SHR		CX,1
			DB $0F, $92, $C3
			SHR		CX,1
			DB $0F, $92, $C7
			JCXZ	@@SKIP0
@@STOSLOOP:
	DB $66;	SUB		[WORD PTR ES:DI],AX
			ADD		DI,4
			DEC		CX
			JNZ		@@STOSLOOP
@@SKIP0:
			OR		BH,BH
			JZ		@@SKIP1
			SUB		[WORD PTR ES:DI],AX
			ADD		DI,2
@@SKIP1:
			OR		BL,BL
			JZ		@@SKIP2
			SUB		[BYTE PTR ES:DI],AL
			INC		DI
@@SKIP2:
			MOV		DI,SI
@@NEXTLINE:
			MOV		AX,[Y]
			CMP		AX,[Min1]
			JL		@@ADJ2
			CMP		AX,[Max1]
			JG		@@ADJ2
	DB $66;	MOV		BX,[WORD PTR DX1]
	DB $66;	ADD		[WORD PTR CX1],BX
@@ADJ2:
			CMP		AX,[Min2]
			JL		@@ADJ3
			CMP		AX,[Max2]
			JG		@@ADJ3
	DB $66;	MOV		BX,[WORD PTR DX2]
	DB $66;	ADD		[WORD PTR CX2],BX
@@ADJ3:
			CMP		AX,[Min3]
			JL		@@ADJ4
			CMP		AX,[Max3]
			JG		@@ADJ4
	DB $66;	MOV		BX,[WORD PTR DX3]
	DB $66;	ADD		[WORD PTR CX3],BX
@@ADJ4:
			CMP		AX,[Min4]
			JL		@@ADJ5
			CMP		AX,[Max4]
			JG		@@ADJ5
	DB $66;	MOV		BX,[WORD PTR DX4]
	DB $66;	ADD		[WORD PTR CX4],BX
@@ADJ5:
			MOV		AX,[Y]
			CMP		AX,[ClipY1]
			JL		@@ONLY_Y
			ADD		DI,320
@@ONLY_Y:
			INC		[Y]
			JMP		@@LINELOOP
@@EXIT:
End;

Procedure XQuadraCopy(X1,Y1,X2,Y2,X3,Y3,X4,Y4 : Integer; FromSeg,VideoSeg : Word); Assembler;
Var
	XX1,XX2		: LongInt;
	XX3,XX4		: LongInt;
	DX1,DX2		: LongInt;
	DX3,DX4		: LongInt;
	CX1,CX2		: LongInt;		{ Moves from 1 to 2, 2 to 3 }
	CX3,CX4		: LongInt;		{ Moves from 3 to 4, 1 to 4 }
	Min1,Min2	: Integer;
	Min3,Min4	: Integer;
	Max1,Max2	: Integer;
	Max3,Max4	: Integer;
	Y,YMin,YMax	: Integer;
Asm
			CLD
			PUSH	DS
			MOV		DS,[FromSeg]
			MOV		AX,[Y1]		{ AX = YMin }
			MOV		BX,AX		{ BX = YMax }
			CMP		AX,[Y2]
			JLE		@@OK1
			MOV		AX,[Y2]
@@OK1:
			CMP		AX,[Y3]
			JLE		@@OK2
			MOV		AX,[Y3]
@@OK2:
			CMP		AX,[Y4]
			JLE		@@OK3
			MOV		AX,[Y4]
@@OK3:
			CMP		BX,[Y2]
			JGE		@@OK4
			MOV		BX,[Y2]
@@OK4:
			CMP		BX,[Y3]
			JGE		@@OK5
			MOV		BX,[Y3]
@@OK5:
			CMP		BX,[Y4]
			JGE		@@OK6
			MOV		BX,[Y4]
@@OK6:
			MOV		[YMin],AX
			MOV		[YMax],BX

			DB $66, $0F, $BF, $46, OFFSET X1	{ MOVSX EAX,[X1] }
	DB $66;	SAL		AX,Scaler
	DB $66;	MOV		[WORD PTR XX1],AX
			DB $66, $0F, $BF, $46, OFFSET X2	{ MOVSX EAX,[X2] }
	DB $66;	SAL		AX,Scaler
	DB $66;	MOV		[WORD PTR XX2],AX
			DB $66, $0F, $BF, $46, OFFSET X3	{ MOVSX EAX,[X3] }
	DB $66;	SAL		AX,Scaler
	DB $66;	MOV		[WORD PTR XX3],AX
			DB $66, $0F, $BF, $46, OFFSET X4	{ MOVSX EAX,[X4] }
	DB $66;	SAL		AX,Scaler
	DB $66;	MOV		[WORD PTR XX4],AX

			MOV		AX,[Y1]
			CMP		AX,[Y2]
			JE		@@EQ1
	DB $66;	MOV		AX,[WORD PTR XX2]
	DB $66;	SUB		AX,[WORD PTR XX1]
	DB $66;	CWD
			MOV     BX,[Y2]
			SUB		BX,[Y1]
			DB $66, $0F, $BF, $CB				{ MOVSX ECX,BX }
	DB $66;	IDIV	CX
	DB $66;	MOV		[WORD PTR DX1],AX
			JMP		@@LINEISOK_1
@@EQ1:
	DB $66;	XOR		AX,AX
	DB $66;	MOV		[WORD PTR DX1],AX
@@LINEISOK_1:

			MOV		AX,[Y2]
			CMP		AX,[Y3]
			JE		@@EQ2
	DB $66;	MOV		AX,[WORD PTR XX3]
	DB $66;	SUB		AX,[WORD PTR XX2]
	DB $66;	CWD
			MOV     BX,[Y3]
			SUB		BX,[Y2]
			DB $66, $0F, $BF, $CB				{ MOVSX ECX,BX }
	DB $66;	IDIV	CX
	DB $66;	MOV		[WORD PTR DX2],AX
			JMP		@@LINEISOK_2
@@EQ2:
	DB $66;	XOR		AX,AX
	DB $66;	MOV		[WORD PTR DX2],AX
@@LINEISOK_2:

			MOV		AX,[Y3]
			CMP		AX,[Y4]
			JE		@@EQ3
	DB $66;	MOV		AX,[WORD PTR XX4]
	DB $66;	SUB		AX,[WORD PTR XX3]
	DB $66;	CWD
			MOV     BX,[Y4]
			SUB		BX,[Y3]
			DB $66, $0F, $BF, $CB				{ MOVSX ECX,BX }
	DB $66;	IDIV	CX
	DB $66;	MOV		[WORD PTR DX3],AX
			JMP		@@LINEISOK_3
@@EQ3:
	DB $66;	XOR		AX,AX
	DB $66;	MOV		[WORD PTR DX3],AX
@@LINEISOK_3:

			MOV		AX,[Y1]
			CMP		AX,[Y4]
			JE		@@EQ4
	DB $66;	MOV		AX,[WORD PTR XX4]
	DB $66;	SUB		AX,[WORD PTR XX1]
	DB $66;	CWD
			MOV     BX,[Y4]
			SUB		BX,[Y1]
			DB $66, $0F, $BF, $CB				{ MOVSX ECX,BX }
	DB $66;	IDIV	CX
	DB $66;	MOV		[WORD PTR DX4],AX
			JMP		@@LINEISOK_4
@@EQ4:
	DB $66;	XOR		AX,AX
	DB $66;	MOV		[WORD PTR DX4],AX
@@LINEISOK_4:

			MOV		BX,[Y1]
			CMP		BX,[Y2]
			JLE		@@DIR12
	DB $66;	MOV		AX,[WORD PTR XX2]
	DB $66;	MOV		[WORD PTR CX1],AX
			JMP		@@CHECKDIR2
@@DIR12:
	DB $66;	MOV		AX,[WORD PTR XX1]
	DB $66;	MOV		[WORD PTR CX1],AX

@@CHECKDIR2:
			MOV		BX,[Y2]
			CMP		BX,[Y3]
			JLE		@@DIR23
	DB $66;	MOV		AX,[WORD PTR XX3]
	DB $66;	MOV		[WORD PTR CX2],AX
			JMP		@@CHECKDIR3
@@DIR23:
	DB $66;	MOV		AX,[WORD PTR XX2]
	DB $66;	MOV		[WORD PTR CX2],AX

@@CHECKDIR3:
			MOV		BX,[Y3]
			CMP		BX,[Y4]
			JLE		@@DIR34
	DB $66;	MOV		AX,[WORD PTR XX4]
	DB $66;	MOV		[WORD PTR CX3],AX
			JMP		@@CHECKDIR4
@@DIR34:
	DB $66;	MOV		AX,[WORD PTR XX3]
	DB $66;	MOV		[WORD PTR CX3],AX

@@CHECKDIR4:
			MOV		BX,[Y1]
			CMP		BX,[Y4]
			JLE		@@DIR14
	DB $66;	MOV		AX,[WORD PTR XX4]
	DB $66;	MOV		[WORD PTR CX4],AX
			JMP		@@NODIRSLEFT
@@DIR14:
	DB $66;	MOV		AX,[WORD PTR XX1]
	DB $66;	MOV		[WORD PTR CX4],AX
@@NODIRSLEFT:
			MOV		AX,[Y1]
			MOV		BX,[Y2]
			CMP		AX,BX
			JLE		@@USELINE1
			XCHG	AX,BX
@@USELINE1:
			MOV		[Min1],AX
			MOV		[Max1],BX

			MOV		AX,[Y2]
			MOV		BX,[Y3]
			CMP		AX,BX
			JLE		@@USELINE2
			XCHG	AX,BX
@@USELINE2:
			MOV		[Min2],AX
			MOV		[Max2],BX

			MOV		AX,[Y3]
			MOV		BX,[Y4]
			CMP		AX,BX
			JLE		@@USELINE3
			XCHG	AX,BX
@@USELINE3:
			MOV		[Min3],AX
			MOV		[Max3],BX

			MOV		AX,[Y1]
			MOV		BX,[Y4]
			CMP		AX,BX
			JLE		@@USELINE4
			XCHG	AX,BX
@@USELINE4:
			MOV		[Min4],AX
			MOV		[Max4],BX

			MOV		AX,[YMin]
			MOV		[Y],AX
			TEST	AX,AX
			JGE		@@MOVEIT
			SUB		AX,AX
@@MOVEIT:
			MOV		DI,AX
			SHL		DI,6
			SHL		AX,8
			ADD		DI,AX
			MOV		ES,[VideoSeg]

@@LINELOOP:
			MOV		AX,[Y]
			CMP		AX,[YMax]
			JG		@@EXIT
			CMP		AX,0
			JL		@@NEXTLINE
			CMP		AX,199
			JG		@@EXIT

	DB $66;	MOV		AX,$FFFF; DW $7FFF	{ MAX }
	DB $66;	MOV		BX,$0000; DW $8000	{ MIN }
			MOV		CX,[Y]

			CMP		CX,[Min1]
			JL		@@CHECK2
			CMP		CX,[Max1]
			JG		@@CHECK2
	DB $66;	CMP		AX,[WORD PTR CX1]
			JLE		@@CHECK1_2
	DB $66;	MOV		AX,[WORD PTR CX1]
@@CHECK1_2:
	DB $66;	CMP		BX,[WORD PTR CX1]
			JGE		@@CHECK2
	DB $66;	MOV		BX,[WORD PTR CX1]

@@CHECK2:
			CMP		CX,[Min2]
			JL		@@CHECK3
			CMP		CX,[Max2]
			JG		@@CHECK3
	DB $66;	CMP		AX,[WORD PTR CX2]
			JLE		@@CHECK2_2
	DB $66;	MOV		AX,[WORD PTR CX2]
@@CHECK2_2:
	DB $66;	CMP		BX,[WORD PTR CX2]
			JGE		@@CHECK3
	DB $66;	MOV		BX,[WORD PTR CX2]

@@CHECK3:
			CMP		CX,[Min3]
			JL		@@CHECK4
			CMP		CX,[Max3]
			JG		@@CHECK4
	DB $66;	CMP		AX,[WORD PTR CX3]
			JLE		@@CHECK3_2
	DB $66;	MOV		AX,[WORD PTR CX3]
@@CHECK3_2:
	DB $66;	CMP		BX,[WORD PTR CX3]
			JGE		@@CHECK4
	DB $66;	MOV		BX,[WORD PTR CX3]

@@CHECK4:
			CMP		CX,[Min4]
			JL		@@CHECK5
			CMP		CX,[Max4]
			JG		@@CHECK5
	DB $66;	CMP		AX,[WORD PTR CX4]
			JLE		@@CHECK4_2
	DB $66;	MOV		AX,[WORD PTR CX4]
@@CHECK4_2:
	DB $66;	CMP		BX,[WORD PTR CX4]
			JGE		@@CHECK5
	DB $66;	MOV		BX,[WORD PTR CX4]
@@CHECK5:

	DB $66;	PUSH	CX
	DB $66;	XOR		CX,CX
	DB $66;	SAR		AX,Scaler
	DB $66;	ADC		AX,CX
	DB $66;	SAR		BX,Scaler
	DB $66;	ADC		BX,CX
	DB $66;	POP		CX

			CMP		AX,319
			JG		@@NEXTLINE
			TEST	BX,BX
			JL		@@NEXTLINE

			CMP		BX,319
			JLE		@@MAXISOK
			MOV		BX,319
@@MAXISOK:
			TEST	AX,AX
			JGE		@@MINISOK
			SUB		AX,AX
@@MINISOK:
			MOV		SI,DI

			MOV		CX,BX
			SUB		CX,AX
			INC		CX
			ADD		DI,AX

			JCXZ	@@SKIP2
			TEST	DI,$0001
			JZ		@@NOTONE
			MOV		AL,[DS:DI]
			MOV		[BYTE PTR ES:DI],AL
			INC		DI
			DEC		CX
			JZ		@@SKIP2
@@NOTONE:
			CMP		CX,2
			JB		@@NOTTWO
			TEST	DI,$0002
			JZ		@@NOTTWO
			MOV		AX,[DS:DI]
			MOV		[WORD PTR ES:DI],AX
			ADD		DI,2
			SUB		CX,2
			JZ		@@SKIP2
@@NOTTWO:
			SHR		CX,1
			DB $0F, $92, $C3
			SHR		CX,1
			DB $0F, $92, $C7
			JCXZ	@@SKIP0
@@STOSLOOP:
	DB $66;	MOV		AX,[DS:DI]
	DB $66;	MOV		[ES:DI],AX
			ADD		DI,4
			DEC		CX
			JNZ		@@STOSLOOP
@@SKIP0:
			OR		BH,BH
			JZ		@@SKIP1
			MOV		AX,[DS:DI]
			MOV		[WORD PTR ES:DI],AX
			ADD		DI,2
@@SKIP1:
			OR		BL,BL
			JZ		@@SKIP2
			MOV		AL,[DS:DI]
			MOV		[BYTE PTR ES:DI],AL
			INC		DI
@@SKIP2:
			MOV		DI,SI
@@NEXTLINE:
			MOV		AX,[Y]
			CMP		AX,[Min1]
			JL		@@ADJ2
			CMP		AX,[Max1]
			JG		@@ADJ2
	DB $66;	MOV		BX,[WORD PTR DX1]
	DB $66;	ADD		[WORD PTR CX1],BX
@@ADJ2:
			CMP		AX,[Min2]
			JL		@@ADJ3
			CMP		AX,[Max2]
			JG		@@ADJ3
	DB $66;	MOV		BX,[WORD PTR DX2]
	DB $66;	ADD		[WORD PTR CX2],BX
@@ADJ3:
			CMP		AX,[Min3]
			JL		@@ADJ4
			CMP		AX,[Max3]
			JG		@@ADJ4
	DB $66;	MOV		BX,[WORD PTR DX3]
	DB $66;	ADD		[WORD PTR CX3],BX
@@ADJ4:
			CMP		AX,[Min4]
			JL		@@ADJ5
			CMP		AX,[Max4]
			JG		@@ADJ5
	DB $66;	MOV		BX,[WORD PTR DX4]
	DB $66;	ADD		[WORD PTR CX4],BX
@@ADJ5:
			MOV		AX,[Y]
			CMP		AX,0
			JL		@@ONLY_Y
			ADD		DI,320
@@ONLY_Y:
			INC		[Y]
			JMP		@@LINELOOP
@@EXIT:
			POP		DS
End;

Procedure XQuadraCopyClip(X1,Y1,X2,Y2,X3,Y3,X4,Y4,ClipX1,ClipY1,ClipX2,ClipY2 : Integer;
	FromSeg,VideoSeg : Word); Assembler;
Var
	XX1,XX2		: LongInt;
	XX3,XX4		: LongInt;
	DX1,DX2		: LongInt;
	DX3,DX4		: LongInt;
	CX1,CX2		: LongInt;		{ Moves from 1 to 2, 2 to 3 }
	CX3,CX4		: LongInt;		{ Moves from 3 to 4, 1 to 4 }
	Min1,Min2	: Integer;
	Min3,Min4	: Integer;
	Max1,Max2	: Integer;
	Max3,Max4	: Integer;
	Y,YMin,YMax	: Integer;
Asm
			CLD
			PUSH	DS
			MOV		DS,[FromSeg]
			MOV		AX,[Y1]		{ AX = YMin }
			MOV		BX,AX		{ BX = YMax }
			CMP		AX,[Y2]
			JLE		@@OK1
			MOV		AX,[Y2]
@@OK1:
			CMP		AX,[Y3]
			JLE		@@OK2
			MOV		AX,[Y3]
@@OK2:
			CMP		AX,[Y4]
			JLE		@@OK3
			MOV		AX,[Y4]
@@OK3:
			CMP		BX,[Y2]
			JGE		@@OK4
			MOV		BX,[Y2]
@@OK4:
			CMP		BX,[Y3]
			JGE		@@OK5
			MOV		BX,[Y3]
@@OK5:
			CMP		BX,[Y4]
			JGE		@@OK6
			MOV		BX,[Y4]
@@OK6:
			MOV		[YMin],AX
			MOV		[YMax],BX

			DB $66, $0F, $BF, $46, OFFSET X1	{ MOVSX EAX,[X1] }
	DB $66;	SAL		AX,Scaler
	DB $66;	MOV		[WORD PTR XX1],AX
			DB $66, $0F, $BF, $46, OFFSET X2	{ MOVSX EAX,[X2] }
	DB $66;	SAL		AX,Scaler
	DB $66;	MOV		[WORD PTR XX2],AX
			DB $66, $0F, $BF, $46, OFFSET X3	{ MOVSX EAX,[X3] }
	DB $66;	SAL		AX,Scaler
	DB $66;	MOV		[WORD PTR XX3],AX
			DB $66, $0F, $BF, $46, OFFSET X4	{ MOVSX EAX,[X4] }
	DB $66;	SAL		AX,Scaler
	DB $66;	MOV		[WORD PTR XX4],AX

			MOV		AX,[Y1]
			CMP		AX,[Y2]
			JE		@@EQ1
	DB $66;	MOV		AX,[WORD PTR XX2]
	DB $66;	SUB		AX,[WORD PTR XX1]
	DB $66;	CWD
			MOV     BX,[Y2]
			SUB		BX,[Y1]
			DB $66, $0F, $BF, $CB				{ MOVSX ECX,BX }
	DB $66;	IDIV	CX
	DB $66;	MOV		[WORD PTR DX1],AX
			JMP		@@LINEISOK_1
@@EQ1:
	DB $66;	XOR		AX,AX
	DB $66;	MOV		[WORD PTR DX1],AX
@@LINEISOK_1:

			MOV		AX,[Y2]
			CMP		AX,[Y3]
			JE		@@EQ2
	DB $66;	MOV		AX,[WORD PTR XX3]
	DB $66;	SUB		AX,[WORD PTR XX2]
	DB $66;	CWD
			MOV     BX,[Y3]
			SUB		BX,[Y2]
			DB $66, $0F, $BF, $CB				{ MOVSX ECX,BX }
	DB $66;	IDIV	CX
	DB $66;	MOV		[WORD PTR DX2],AX
			JMP		@@LINEISOK_2
@@EQ2:
	DB $66;	XOR		AX,AX
	DB $66;	MOV		[WORD PTR DX2],AX
@@LINEISOK_2:

			MOV		AX,[Y3]
			CMP		AX,[Y4]
			JE		@@EQ3
	DB $66;	MOV		AX,[WORD PTR XX4]
	DB $66;	SUB		AX,[WORD PTR XX3]
	DB $66;	CWD
			MOV     BX,[Y4]
			SUB		BX,[Y3]
			DB $66, $0F, $BF, $CB				{ MOVSX ECX,BX }
	DB $66;	IDIV	CX
	DB $66;	MOV		[WORD PTR DX3],AX
			JMP		@@LINEISOK_3
@@EQ3:
	DB $66;	XOR		AX,AX
	DB $66;	MOV		[WORD PTR DX3],AX
@@LINEISOK_3:

			MOV		AX,[Y1]
			CMP		AX,[Y4]
			JE		@@EQ4
	DB $66;	MOV		AX,[WORD PTR XX4]
	DB $66;	SUB		AX,[WORD PTR XX1]
	DB $66;	CWD
			MOV     BX,[Y4]
			SUB		BX,[Y1]
			DB $66, $0F, $BF, $CB				{ MOVSX ECX,BX }
	DB $66;	IDIV	CX
	DB $66;	MOV		[WORD PTR DX4],AX
			JMP		@@LINEISOK_4
@@EQ4:
	DB $66;	XOR		AX,AX
	DB $66;	MOV		[WORD PTR DX4],AX
@@LINEISOK_4:

			MOV		BX,[Y1]
			CMP		BX,[Y2]
			JLE		@@DIR12
	DB $66;	MOV		AX,[WORD PTR XX2]
	DB $66;	MOV		[WORD PTR CX1],AX
			JMP		@@CHECKDIR2
@@DIR12:
	DB $66;	MOV		AX,[WORD PTR XX1]
	DB $66;	MOV		[WORD PTR CX1],AX

@@CHECKDIR2:
			MOV		BX,[Y2]
			CMP		BX,[Y3]
			JLE		@@DIR23
	DB $66;	MOV		AX,[WORD PTR XX3]
	DB $66;	MOV		[WORD PTR CX2],AX
			JMP		@@CHECKDIR3
@@DIR23:
	DB $66;	MOV		AX,[WORD PTR XX2]
	DB $66;	MOV		[WORD PTR CX2],AX

@@CHECKDIR3:
			MOV		BX,[Y3]
			CMP		BX,[Y4]
			JLE		@@DIR34
	DB $66;	MOV		AX,[WORD PTR XX4]
	DB $66;	MOV		[WORD PTR CX3],AX
			JMP		@@CHECKDIR4
@@DIR34:
	DB $66;	MOV		AX,[WORD PTR XX3]
	DB $66;	MOV		[WORD PTR CX3],AX

@@CHECKDIR4:
			MOV		BX,[Y1]
			CMP		BX,[Y4]
			JLE		@@DIR14
	DB $66;	MOV		AX,[WORD PTR XX4]
	DB $66;	MOV		[WORD PTR CX4],AX
			JMP		@@NODIRSLEFT
@@DIR14:
	DB $66;	MOV		AX,[WORD PTR XX1]
	DB $66;	MOV		[WORD PTR CX4],AX
@@NODIRSLEFT:
			MOV		AX,[Y1]
			MOV		BX,[Y2]
			CMP		AX,BX
			JLE		@@USELINE1
			XCHG	AX,BX
@@USELINE1:
			MOV		[Min1],AX
			MOV		[Max1],BX

			MOV		AX,[Y2]
			MOV		BX,[Y3]
			CMP		AX,BX
			JLE		@@USELINE2
			XCHG	AX,BX
@@USELINE2:
			MOV		[Min2],AX
			MOV		[Max2],BX

			MOV		AX,[Y3]
			MOV		BX,[Y4]
			CMP		AX,BX
			JLE		@@USELINE3
			XCHG	AX,BX
@@USELINE3:
			MOV		[Min3],AX
			MOV		[Max3],BX

			MOV		AX,[Y1]
			MOV		BX,[Y4]
			CMP		AX,BX
			JLE		@@USELINE4
			XCHG	AX,BX
@@USELINE4:
			MOV		[Min4],AX
			MOV		[Max4],BX

			MOV		AX,[YMin]
			MOV		[Y],AX
			CMP		AX,[ClipY1]
			JGE		@@MOVEIT
			MOV		AX,[ClipY1]
@@MOVEIT:
			MOV		DI,AX
			SHL		DI,6
			SHL		AX,8
			ADD		DI,AX
			MOV		ES,[VideoSeg]
@@LINELOOP:
			MOV		AX,[Y]
			CMP		AX,[YMax]
			JG		@@EXIT
			CMP		AX,[ClipY1]
			JL		@@NEXTLINE
			CMP		AX,[ClipY2]
			JG		@@EXIT

	DB $66;	MOV		AX,$FFFF; DW $7FFF	{ MAX }
	DB $66;	MOV		BX,$0000; DW $8000	{ MIN }
			MOV		CX,[Y]

			CMP		CX,[Min1]
			JL		@@CHECK2
			CMP		CX,[Max1]
			JG		@@CHECK2
	DB $66;	CMP		AX,[WORD PTR CX1]
			JLE		@@CHECK1_2
	DB $66;	MOV		AX,[WORD PTR CX1]
@@CHECK1_2:
	DB $66;	CMP		BX,[WORD PTR CX1]
			JGE		@@CHECK2
	DB $66;	MOV		BX,[WORD PTR CX1]

@@CHECK2:
			CMP		CX,[Min2]
			JL		@@CHECK3
			CMP		CX,[Max2]
			JG		@@CHECK3
	DB $66;	CMP		AX,[WORD PTR CX2]
			JLE		@@CHECK2_2
	DB $66;	MOV		AX,[WORD PTR CX2]
@@CHECK2_2:
	DB $66;	CMP		BX,[WORD PTR CX2]
			JGE		@@CHECK3
	DB $66;	MOV		BX,[WORD PTR CX2]

@@CHECK3:
			CMP		CX,[Min3]
			JL		@@CHECK4
			CMP		CX,[Max3]
			JG		@@CHECK4
	DB $66;	CMP		AX,[WORD PTR CX3]
			JLE		@@CHECK3_2
	DB $66;	MOV		AX,[WORD PTR CX3]
@@CHECK3_2:
	DB $66;	CMP		BX,[WORD PTR CX3]
			JGE		@@CHECK4
	DB $66;	MOV		BX,[WORD PTR CX3]

@@CHECK4:
			CMP		CX,[Min4]
			JL		@@CHECK5
			CMP		CX,[Max4]
			JG		@@CHECK5
	DB $66;	CMP		AX,[WORD PTR CX4]
			JLE		@@CHECK4_2
	DB $66;	MOV		AX,[WORD PTR CX4]
@@CHECK4_2:
	DB $66;	CMP		BX,[WORD PTR CX4]
			JGE		@@CHECK5
	DB $66;	MOV		BX,[WORD PTR CX4]
@@CHECK5:

	DB $66;	PUSH	CX
	DB $66;	XOR		CX,CX
	DB $66;	SAR		AX,Scaler
	DB $66;	ADC		AX,CX
	DB $66;	SAR		BX,Scaler
	DB $66;	ADC		BX,CX
	DB $66;	POP		CX

			CMP		AX,[ClipX2]
			JG		@@NEXTLINE
			CMP		BX,[ClipX1]
			JL		@@NEXTLINE

			CMP		BX,[ClipX2]
			JLE		@@MAXISOK
			MOV		BX,[ClipX2]
@@MAXISOK:
			CMP		AX,[ClipX1]
			JGE		@@MINISOK
			MOV		AX,[ClipX1]
@@MINISOK:
			MOV		SI,DI

			MOV		CX,BX
			SUB		CX,AX
			INC		CX

			ADD		DI,AX
			JCXZ	@@SKIP2
			TEST	DI,$0001
			JZ		@@NOTONE
			MOV		AL,[DS:DI]
			MOV		[BYTE PTR ES:DI],AL
			INC		DI
			DEC		CX
			JZ		@@SKIP2
@@NOTONE:
			CMP		CX,2
			JB		@@NOTTWO
			TEST	DI,$0002
			JZ		@@NOTTWO
			MOV		AX,[DS:DI]
			MOV		[WORD PTR ES:DI],AX
			ADD		DI,2
			SUB		CX,2
			JZ		@@SKIP2
@@NOTTWO:
			SHR		CX,1
			DB $0F, $92, $C3
			SHR		CX,1
			DB $0F, $92, $C7
			JCXZ	@@SKIP0
@@STOSLOOP:
	DB $66;	MOV		AX,[DS:DI]
	DB $66;	MOV		[ES:DI],AX
			ADD		DI,4
			DEC		CX
			JNZ		@@STOSLOOP
@@SKIP0:
			OR		BH,BH
			JZ		@@SKIP1
			MOV		AX,[DS:DI]
			MOV		[WORD PTR ES:DI],AX
			ADD		DI,2
@@SKIP1:
			OR		BL,BL
			JZ		@@SKIP2
			MOV		AL,[DS:DI]
			MOV		[BYTE PTR ES:DI],AL
			INC		DI
@@SKIP2:
			MOV		DI,SI
@@NEXTLINE:
			MOV		AX,[Y]
			CMP		AX,[Min1]
			JL		@@ADJ2
			CMP		AX,[Max1]
			JG		@@ADJ2
	DB $66;	MOV		BX,[WORD PTR DX1]
	DB $66;	ADD		[WORD PTR CX1],BX
@@ADJ2:
			CMP		AX,[Min2]
			JL		@@ADJ3
			CMP		AX,[Max2]
			JG		@@ADJ3
	DB $66;	MOV		BX,[WORD PTR DX2]
	DB $66;	ADD		[WORD PTR CX2],BX
@@ADJ3:
			CMP		AX,[Min3]
			JL		@@ADJ4
			CMP		AX,[Max3]
			JG		@@ADJ4
	DB $66;	MOV		BX,[WORD PTR DX3]
	DB $66;	ADD		[WORD PTR CX3],BX
@@ADJ4:
			CMP		AX,[Min4]
			JL		@@ADJ5
			CMP		AX,[Max4]
			JG		@@ADJ5
	DB $66;	MOV		BX,[WORD PTR DX4]
	DB $66;	ADD		[WORD PTR CX4],BX
@@ADJ5:
			MOV		AX,[Y]
			CMP		AX,[ClipY1]
			JL		@@ONLY_Y
			ADD		DI,320
@@ONLY_Y:
			INC		[Y]
			JMP		@@LINELOOP
@@EXIT:
			POP		DS
End;

Procedure XQuadraGlenzOR(X1,Y1,X2,Y2,X3,Y3,X4,Y4 : Integer; Color : Byte; VideoSeg : Word); Assembler;
Var
	XX1,XX2		: LongInt;
	XX3,XX4		: LongInt;
	DX1,DX2		: LongInt;
	DX3,DX4		: LongInt;
	CX1,CX2		: LongInt;		{ Moves from 1 to 2, 2 to 3 }
	CX3,CX4		: LongInt;		{ Moves from 3 to 4, 1 to 4 }
	Min1,Min2	: Integer;
	Min3,Min4	: Integer;
	Max1,Max2	: Integer;
	Max3,Max4	: Integer;
	Y,YMin,YMax	: Integer;
	CDWord		: LongInt;
Asm
			CLD
			MOV		BL,[Color]
			MOV		BH,BL
			MOV		AX,BX
	DB $66;	SHL		AX,16
			MOV		AX,BX
	DB $66;	MOV		[WORD PTR CDWord],AX

			MOV		AX,[Y1]		{ AX = YMin }
			MOV		BX,AX		{ BX = YMax }
			CMP		AX,[Y2]
			JLE		@@OK1
			MOV		AX,[Y2]
@@OK1:
			CMP		AX,[Y3]
			JLE		@@OK2
			MOV		AX,[Y3]
@@OK2:
			CMP		AX,[Y4]
			JLE		@@OK3
			MOV		AX,[Y4]
@@OK3:
			CMP		BX,[Y2]
			JGE		@@OK4
			MOV		BX,[Y2]
@@OK4:
			CMP		BX,[Y3]
			JGE		@@OK5
			MOV		BX,[Y3]
@@OK5:
			CMP		BX,[Y4]
			JGE		@@OK6
			MOV		BX,[Y4]
@@OK6:
			MOV		[YMin],AX
			MOV		[YMax],BX

			DB $66, $0F, $BF, $46, OFFSET X1	{ MOVSX EAX,[X1] }
	DB $66;	SAL		AX,Scaler
	DB $66;	MOV		[WORD PTR XX1],AX
			DB $66, $0F, $BF, $46, OFFSET X2	{ MOVSX EAX,[X2] }
	DB $66;	SAL		AX,Scaler
	DB $66;	MOV		[WORD PTR XX2],AX
			DB $66, $0F, $BF, $46, OFFSET X3	{ MOVSX EAX,[X3] }
	DB $66;	SAL		AX,Scaler
	DB $66;	MOV		[WORD PTR XX3],AX
			DB $66, $0F, $BF, $46, OFFSET X4	{ MOVSX EAX,[X4] }
	DB $66;	SAL		AX,Scaler
	DB $66;	MOV		[WORD PTR XX4],AX

			MOV		AX,[Y1]
			CMP		AX,[Y2]
			JE		@@EQ1
	DB $66;	MOV		AX,[WORD PTR XX2]
	DB $66;	SUB		AX,[WORD PTR XX1]
	DB $66;	CWD
			MOV     BX,[Y2]
			SUB		BX,[Y1]
			DB $66, $0F, $BF, $CB				{ MOVSX ECX,BX }
	DB $66;	IDIV	CX
	DB $66;	MOV		[WORD PTR DX1],AX
			JMP		@@LINEISOK_1
@@EQ1:
	DB $66;	XOR		AX,AX
	DB $66;	MOV		[WORD PTR DX1],AX
@@LINEISOK_1:

			MOV		AX,[Y2]
			CMP		AX,[Y3]
			JE		@@EQ2
	DB $66;	MOV		AX,[WORD PTR XX3]
	DB $66;	SUB		AX,[WORD PTR XX2]
	DB $66;	CWD
			MOV     BX,[Y3]
			SUB		BX,[Y2]
			DB $66, $0F, $BF, $CB				{ MOVSX ECX,BX }
	DB $66;	IDIV	CX
	DB $66;	MOV		[WORD PTR DX2],AX
			JMP		@@LINEISOK_2
@@EQ2:
	DB $66;	XOR		AX,AX
	DB $66;	MOV		[WORD PTR DX2],AX
@@LINEISOK_2:

			MOV		AX,[Y3]
			CMP		AX,[Y4]
			JE		@@EQ3
	DB $66;	MOV		AX,[WORD PTR XX4]
	DB $66;	SUB		AX,[WORD PTR XX3]
	DB $66;	CWD
			MOV     BX,[Y4]
			SUB		BX,[Y3]
			DB $66, $0F, $BF, $CB				{ MOVSX ECX,BX }
	DB $66;	IDIV	CX
	DB $66;	MOV		[WORD PTR DX3],AX
			JMP		@@LINEISOK_3
@@EQ3:
	DB $66;	XOR		AX,AX
	DB $66;	MOV		[WORD PTR DX3],AX
@@LINEISOK_3:

			MOV		AX,[Y1]
			CMP		AX,[Y4]
			JE		@@EQ4
	DB $66;	MOV		AX,[WORD PTR XX4]
	DB $66;	SUB		AX,[WORD PTR XX1]
	DB $66;	CWD
			MOV     BX,[Y4]
			SUB		BX,[Y1]
			DB $66, $0F, $BF, $CB				{ MOVSX ECX,BX }
	DB $66;	IDIV	CX
	DB $66;	MOV		[WORD PTR DX4],AX
			JMP		@@LINEISOK_4
@@EQ4:
	DB $66;	XOR		AX,AX
	DB $66;	MOV		[WORD PTR DX4],AX
@@LINEISOK_4:

			MOV		BX,[Y1]
			CMP		BX,[Y2]
			JLE		@@DIR12
	DB $66;	MOV		AX,[WORD PTR XX2]
	DB $66;	MOV		[WORD PTR CX1],AX
			JMP		@@CHECKDIR2
@@DIR12:
	DB $66;	MOV		AX,[WORD PTR XX1]
	DB $66;	MOV		[WORD PTR CX1],AX

@@CHECKDIR2:
			MOV		BX,[Y2]
			CMP		BX,[Y3]
			JLE		@@DIR23
	DB $66;	MOV		AX,[WORD PTR XX3]
	DB $66;	MOV		[WORD PTR CX2],AX
			JMP		@@CHECKDIR3
@@DIR23:
	DB $66;	MOV		AX,[WORD PTR XX2]
	DB $66;	MOV		[WORD PTR CX2],AX

@@CHECKDIR3:
			MOV		BX,[Y3]
			CMP		BX,[Y4]
			JLE		@@DIR34
	DB $66;	MOV		AX,[WORD PTR XX4]
	DB $66;	MOV		[WORD PTR CX3],AX
			JMP		@@CHECKDIR4
@@DIR34:
	DB $66;	MOV		AX,[WORD PTR XX3]
	DB $66;	MOV		[WORD PTR CX3],AX

@@CHECKDIR4:
			MOV		BX,[Y1]
			CMP		BX,[Y4]
			JLE		@@DIR14
	DB $66;	MOV		AX,[WORD PTR XX4]
	DB $66;	MOV		[WORD PTR CX4],AX
			JMP		@@NODIRSLEFT
@@DIR14:
	DB $66;	MOV		AX,[WORD PTR XX1]
	DB $66;	MOV		[WORD PTR CX4],AX
@@NODIRSLEFT:
			MOV		AX,[Y1]
			MOV		BX,[Y2]
			CMP		AX,BX
			JLE		@@USELINE1
			XCHG	AX,BX
@@USELINE1:
			MOV		[Min1],AX
			MOV		[Max1],BX

			MOV		AX,[Y2]
			MOV		BX,[Y3]
			CMP		AX,BX
			JLE		@@USELINE2
			XCHG	AX,BX
@@USELINE2:
			MOV		[Min2],AX
			MOV		[Max2],BX

			MOV		AX,[Y3]
			MOV		BX,[Y4]
			CMP		AX,BX
			JLE		@@USELINE3
			XCHG	AX,BX
@@USELINE3:
			MOV		[Min3],AX
			MOV		[Max3],BX

			MOV		AX,[Y1]
			MOV		BX,[Y4]
			CMP		AX,BX
			JLE		@@USELINE4
			XCHG	AX,BX
@@USELINE4:
			MOV		[Min4],AX
			MOV		[Max4],BX

			MOV		AX,[YMin]
			MOV		[Y],AX
			TEST	AX,AX
			JGE		@@MOVEIT
			SUB		AX,AX
@@MOVEIT:
			MOV		DI,AX
			SHL		DI,6
			SHL		AX,8
			ADD		DI,AX
			MOV		ES,[VideoSeg]

@@LINELOOP:
			MOV		AX,[Y]
			CMP		AX,[YMax]
			JG		@@EXIT
			CMP		AX,0
			JL		@@NEXTLINE
			CMP		AX,199
			JG		@@EXIT

	DB $66;	MOV		AX,$FFFF; DW $7FFF	{ MAX }
	DB $66;	MOV		BX,$0000; DW $8000	{ MIN }
			MOV		CX,[Y]

			CMP		CX,[Min1]
			JL		@@CHECK2
			CMP		CX,[Max1]
			JG		@@CHECK2
	DB $66;	CMP		AX,[WORD PTR CX1]
			JLE		@@CHECK1_2
	DB $66;	MOV		AX,[WORD PTR CX1]
@@CHECK1_2:
	DB $66;	CMP		BX,[WORD PTR CX1]
			JGE		@@CHECK2
	DB $66;	MOV		BX,[WORD PTR CX1]

@@CHECK2:
			CMP		CX,[Min2]
			JL		@@CHECK3
			CMP		CX,[Max2]
			JG		@@CHECK3
	DB $66;	CMP		AX,[WORD PTR CX2]
			JLE		@@CHECK2_2
	DB $66;	MOV		AX,[WORD PTR CX2]
@@CHECK2_2:
	DB $66;	CMP		BX,[WORD PTR CX2]
			JGE		@@CHECK3
	DB $66;	MOV		BX,[WORD PTR CX2]

@@CHECK3:
			CMP		CX,[Min3]
			JL		@@CHECK4
			CMP		CX,[Max3]
			JG		@@CHECK4
	DB $66;	CMP		AX,[WORD PTR CX3]
			JLE		@@CHECK3_2
	DB $66;	MOV		AX,[WORD PTR CX3]
@@CHECK3_2:
	DB $66;	CMP		BX,[WORD PTR CX3]
			JGE		@@CHECK4
	DB $66;	MOV		BX,[WORD PTR CX3]

@@CHECK4:
			CMP		CX,[Min4]
			JL		@@CHECK5
			CMP		CX,[Max4]
			JG		@@CHECK5
	DB $66;	CMP		AX,[WORD PTR CX4]
			JLE		@@CHECK4_2
	DB $66;	MOV		AX,[WORD PTR CX4]
@@CHECK4_2:
	DB $66;	CMP		BX,[WORD PTR CX4]
			JGE		@@CHECK5
	DB $66;	MOV		BX,[WORD PTR CX4]
@@CHECK5:

	DB $66;	PUSH	CX
	DB $66;	XOR		CX,CX
	DB $66;	SAR		AX,Scaler
	DB $66;	ADC		AX,CX
	DB $66;	SAR		BX,Scaler
	DB $66;	ADC		BX,CX
	DB $66;	POP		CX

			CMP		AX,319
			JG		@@NEXTLINE
			TEST	BX,BX
			JL		@@NEXTLINE

			CMP		BX,319
			JLE		@@MAXISOK
			MOV		BX,319
@@MAXISOK:
			TEST	AX,AX
			JGE		@@MINISOK
			SUB		AX,AX
@@MINISOK:
			MOV		SI,DI

			MOV		CX,BX
			SUB		CX,AX
			INC		CX

			ADD		DI,AX
	DB $66;	MOV		AX,[WORD PTR CDWord]
			JCXZ	@@SKIP2
			TEST	DI,$0001
			JZ		@@NOTONE
			OR		[BYTE PTR ES:DI],AL
			INC		DI
			DEC		CX
			JZ		@@SKIP2
@@NOTONE:
			CMP		CX,2
			JB		@@NOTTWO
			TEST	DI,$0002
			JZ		@@NOTTWO
			OR		[WORD PTR ES:DI],AX
			ADD		DI,2
			SUB		CX,2
			JZ		@@SKIP2
@@NOTTWO:
			SHR		CX,1
			DB $0F, $92, $C3
			SHR		CX,1
			DB $0F, $92, $C7
			JCXZ	@@SKIP0
@@STOSLOOP:
	DB $66;	OR		[WORD PTR ES:DI],AX
			ADD		DI,4
			DEC		CX
			JNZ		@@STOSLOOP
@@SKIP0:
			OR		BH,BH
			JZ		@@SKIP1
			OR		[WORD PTR ES:DI],AX
			ADD		DI,2
@@SKIP1:
			OR		BL,BL
			JZ		@@SKIP2
			OR		[BYTE PTR ES:DI],AL
			INC		DI
@@SKIP2:
			MOV		DI,SI
@@NEXTLINE:
			MOV		AX,[Y]
			CMP		AX,[Min1]
			JL		@@ADJ2
			CMP		AX,[Max1]
			JG		@@ADJ2
	DB $66;	MOV		BX,[WORD PTR DX1]
	DB $66;	ADD		[WORD PTR CX1],BX
@@ADJ2:
			CMP		AX,[Min2]
			JL		@@ADJ3
			CMP		AX,[Max2]
			JG		@@ADJ3
	DB $66;	MOV		BX,[WORD PTR DX2]
	DB $66;	ADD		[WORD PTR CX2],BX
@@ADJ3:
			CMP		AX,[Min3]
			JL		@@ADJ4
			CMP		AX,[Max3]
			JG		@@ADJ4
	DB $66;	MOV		BX,[WORD PTR DX3]
	DB $66;	ADD		[WORD PTR CX3],BX
@@ADJ4:
			CMP		AX,[Min4]
			JL		@@ADJ5
			CMP		AX,[Max4]
			JG		@@ADJ5
	DB $66;	MOV		BX,[WORD PTR DX4]
	DB $66;	ADD		[WORD PTR CX4],BX
@@ADJ5:
			MOV		AX,[Y]
			CMP		AX,0
			JL		@@ONLY_Y
			ADD		DI,320
@@ONLY_Y:
			INC		[Y]
			JMP		@@LINELOOP
@@EXIT:
End;

Procedure XQuadraGlenzORClip(X1,Y1,X2,Y2,X3,Y3,X4,Y4,ClipX1,ClipY1,ClipX2,ClipY2 : Integer;
	Color : Byte; VideoSeg : Word); Assembler;
Var
	XX1,XX2		: LongInt;
	XX3,XX4		: LongInt;
	DX1,DX2		: LongInt;
	DX3,DX4		: LongInt;
	CX1,CX2		: LongInt;		{ Moves from 1 to 2, 2 to 3 }
	CX3,CX4		: LongInt;		{ Moves from 3 to 4, 1 to 4 }
	Min1,Min2	: Integer;
	Min3,Min4	: Integer;
	Max1,Max2	: Integer;
	Max3,Max4	: Integer;
	Y,YMin,YMax	: Integer;
	CDWord		: LongInt;
Asm
			CLD
			MOV		BL,[Color]
			MOV		BH,BL
			MOV		AX,BX
	DB $66;	SHL		AX,16
			MOV		AX,BX
	DB $66;	MOV		[WORD PTR CDWord],AX

			MOV		AX,[Y1]		{ AX = YMin }
			MOV		BX,AX		{ BX = YMax }
			CMP		AX,[Y2]
			JLE		@@OK1
			MOV		AX,[Y2]
@@OK1:
			CMP		AX,[Y3]
			JLE		@@OK2
			MOV		AX,[Y3]
@@OK2:
			CMP		AX,[Y4]
			JLE		@@OK3
			MOV		AX,[Y4]
@@OK3:
			CMP		BX,[Y2]
			JGE		@@OK4
			MOV		BX,[Y2]
@@OK4:
			CMP		BX,[Y3]
			JGE		@@OK5
			MOV		BX,[Y3]
@@OK5:
			CMP		BX,[Y4]
			JGE		@@OK6
			MOV		BX,[Y4]
@@OK6:
			MOV		[YMin],AX
			MOV		[YMax],BX

			DB $66, $0F, $BF, $46, OFFSET X1	{ MOVSX EAX,[X1] }
	DB $66;	SAL		AX,Scaler
	DB $66;	MOV		[WORD PTR XX1],AX
			DB $66, $0F, $BF, $46, OFFSET X2	{ MOVSX EAX,[X2] }
	DB $66;	SAL		AX,Scaler
	DB $66;	MOV		[WORD PTR XX2],AX
			DB $66, $0F, $BF, $46, OFFSET X3	{ MOVSX EAX,[X3] }
	DB $66;	SAL		AX,Scaler
	DB $66;	MOV		[WORD PTR XX3],AX
			DB $66, $0F, $BF, $46, OFFSET X4	{ MOVSX EAX,[X4] }
	DB $66;	SAL		AX,Scaler
	DB $66;	MOV		[WORD PTR XX4],AX

			MOV		AX,[Y1]
			CMP		AX,[Y2]
			JE		@@EQ1
	DB $66;	MOV		AX,[WORD PTR XX2]
	DB $66;	SUB		AX,[WORD PTR XX1]
	DB $66;	CWD
			MOV     BX,[Y2]
			SUB		BX,[Y1]
			DB $66, $0F, $BF, $CB				{ MOVSX ECX,BX }
	DB $66;	IDIV	CX
	DB $66;	MOV		[WORD PTR DX1],AX
			JMP		@@LINEISOK_1
@@EQ1:
	DB $66;	XOR		AX,AX
	DB $66;	MOV		[WORD PTR DX1],AX
@@LINEISOK_1:

			MOV		AX,[Y2]
			CMP		AX,[Y3]
			JE		@@EQ2
	DB $66;	MOV		AX,[WORD PTR XX3]
	DB $66;	SUB		AX,[WORD PTR XX2]
	DB $66;	CWD
			MOV     BX,[Y3]
			SUB		BX,[Y2]
			DB $66, $0F, $BF, $CB				{ MOVSX ECX,BX }
	DB $66;	IDIV	CX
	DB $66;	MOV		[WORD PTR DX2],AX
			JMP		@@LINEISOK_2
@@EQ2:
	DB $66;	XOR		AX,AX
	DB $66;	MOV		[WORD PTR DX2],AX
@@LINEISOK_2:

			MOV		AX,[Y3]
			CMP		AX,[Y4]
			JE		@@EQ3
	DB $66;	MOV		AX,[WORD PTR XX4]
	DB $66;	SUB		AX,[WORD PTR XX3]
	DB $66;	CWD
			MOV     BX,[Y4]
			SUB		BX,[Y3]
			DB $66, $0F, $BF, $CB				{ MOVSX ECX,BX }
	DB $66;	IDIV	CX
	DB $66;	MOV		[WORD PTR DX3],AX
			JMP		@@LINEISOK_3
@@EQ3:
	DB $66;	XOR		AX,AX
	DB $66;	MOV		[WORD PTR DX3],AX
@@LINEISOK_3:

			MOV		AX,[Y1]
			CMP		AX,[Y4]
			JE		@@EQ4
	DB $66;	MOV		AX,[WORD PTR XX4]
	DB $66;	SUB		AX,[WORD PTR XX1]
	DB $66;	CWD
			MOV     BX,[Y4]
			SUB		BX,[Y1]
			DB $66, $0F, $BF, $CB				{ MOVSX ECX,BX }
	DB $66;	IDIV	CX
	DB $66;	MOV		[WORD PTR DX4],AX
			JMP		@@LINEISOK_4
@@EQ4:
	DB $66;	XOR		AX,AX
	DB $66;	MOV		[WORD PTR DX4],AX
@@LINEISOK_4:

			MOV		BX,[Y1]
			CMP		BX,[Y2]
			JLE		@@DIR12
	DB $66;	MOV		AX,[WORD PTR XX2]
	DB $66;	MOV		[WORD PTR CX1],AX
			JMP		@@CHECKDIR2
@@DIR12:
	DB $66;	MOV		AX,[WORD PTR XX1]
	DB $66;	MOV		[WORD PTR CX1],AX

@@CHECKDIR2:
			MOV		BX,[Y2]
			CMP		BX,[Y3]
			JLE		@@DIR23
	DB $66;	MOV		AX,[WORD PTR XX3]
	DB $66;	MOV		[WORD PTR CX2],AX
			JMP		@@CHECKDIR3
@@DIR23:
	DB $66;	MOV		AX,[WORD PTR XX2]
	DB $66;	MOV		[WORD PTR CX2],AX

@@CHECKDIR3:
			MOV		BX,[Y3]
			CMP		BX,[Y4]
			JLE		@@DIR34
	DB $66;	MOV		AX,[WORD PTR XX4]
	DB $66;	MOV		[WORD PTR CX3],AX
			JMP		@@CHECKDIR4
@@DIR34:
	DB $66;	MOV		AX,[WORD PTR XX3]
	DB $66;	MOV		[WORD PTR CX3],AX

@@CHECKDIR4:
			MOV		BX,[Y1]
			CMP		BX,[Y4]
			JLE		@@DIR14
	DB $66;	MOV		AX,[WORD PTR XX4]
	DB $66;	MOV		[WORD PTR CX4],AX
			JMP		@@NODIRSLEFT
@@DIR14:
	DB $66;	MOV		AX,[WORD PTR XX1]
	DB $66;	MOV		[WORD PTR CX4],AX
@@NODIRSLEFT:
			MOV		AX,[Y1]
			MOV		BX,[Y2]
			CMP		AX,BX
			JLE		@@USELINE1
			XCHG	AX,BX
@@USELINE1:
			MOV		[Min1],AX
			MOV		[Max1],BX

			MOV		AX,[Y2]
			MOV		BX,[Y3]
			CMP		AX,BX
			JLE		@@USELINE2
			XCHG	AX,BX
@@USELINE2:
			MOV		[Min2],AX
			MOV		[Max2],BX

			MOV		AX,[Y3]
			MOV		BX,[Y4]
			CMP		AX,BX
			JLE		@@USELINE3
			XCHG	AX,BX
@@USELINE3:
			MOV		[Min3],AX
			MOV		[Max3],BX

			MOV		AX,[Y1]
			MOV		BX,[Y4]
			CMP		AX,BX
			JLE		@@USELINE4
			XCHG	AX,BX
@@USELINE4:
			MOV		[Min4],AX
			MOV		[Max4],BX

			MOV		AX,[YMin]
			MOV		[Y],AX
			CMP		AX,[ClipY1]
			JGE		@@MOVEIT
			MOV		AX,[ClipY1]
@@MOVEIT:
			MOV		DI,AX
			SHL		DI,6
			SHL		AX,8
			ADD		DI,AX
			MOV		ES,[VideoSeg]
@@LINELOOP:
			MOV		AX,[Y]
			CMP		AX,[YMax]
			JG		@@EXIT
			CMP		AX,[ClipY1]
			JL		@@NEXTLINE
			CMP		AX,[ClipY2]
			JG		@@EXIT

	DB $66;	MOV		AX,$FFFF; DW $7FFF	{ MAX }
	DB $66;	MOV		BX,$0000; DW $8000	{ MIN }
			MOV		CX,[Y]

			CMP		CX,[Min1]
			JL		@@CHECK2
			CMP		CX,[Max1]
			JG		@@CHECK2
	DB $66;	CMP		AX,[WORD PTR CX1]
			JLE		@@CHECK1_2
	DB $66;	MOV		AX,[WORD PTR CX1]
@@CHECK1_2:
	DB $66;	CMP		BX,[WORD PTR CX1]
			JGE		@@CHECK2
	DB $66;	MOV		BX,[WORD PTR CX1]

@@CHECK2:
			CMP		CX,[Min2]
			JL		@@CHECK3
			CMP		CX,[Max2]
			JG		@@CHECK3
	DB $66;	CMP		AX,[WORD PTR CX2]
			JLE		@@CHECK2_2
	DB $66;	MOV		AX,[WORD PTR CX2]
@@CHECK2_2:
	DB $66;	CMP		BX,[WORD PTR CX2]
			JGE		@@CHECK3
	DB $66;	MOV		BX,[WORD PTR CX2]

@@CHECK3:
			CMP		CX,[Min3]
			JL		@@CHECK4
			CMP		CX,[Max3]
			JG		@@CHECK4
	DB $66;	CMP		AX,[WORD PTR CX3]
			JLE		@@CHECK3_2
	DB $66;	MOV		AX,[WORD PTR CX3]
@@CHECK3_2:
	DB $66;	CMP		BX,[WORD PTR CX3]
			JGE		@@CHECK4
	DB $66;	MOV		BX,[WORD PTR CX3]

@@CHECK4:
			CMP		CX,[Min4]
			JL		@@CHECK5
			CMP		CX,[Max4]
			JG		@@CHECK5
	DB $66;	CMP		AX,[WORD PTR CX4]
			JLE		@@CHECK4_2
	DB $66;	MOV		AX,[WORD PTR CX4]
@@CHECK4_2:
	DB $66;	CMP		BX,[WORD PTR CX4]
			JGE		@@CHECK5
	DB $66;	MOV		BX,[WORD PTR CX4]
@@CHECK5:

	DB $66;	PUSH	CX
	DB $66;	XOR		CX,CX
	DB $66;	SAR		AX,Scaler
	DB $66;	ADC		AX,CX
	DB $66;	SAR		BX,Scaler
	DB $66;	ADC		BX,CX
	DB $66;	POP		CX

			CMP		AX,[ClipX2]
			JG		@@NEXTLINE
			CMP		BX,[ClipX1]
			JL		@@NEXTLINE

			CMP		BX,[ClipX2]
			JLE		@@MAXISOK
			MOV		BX,[ClipX2]
@@MAXISOK:
			CMP		AX,[ClipX1]
			JGE		@@MINISOK
			MOV		AX,[ClipX1]
@@MINISOK:
			MOV		SI,DI

			MOV		CX,BX
			SUB		CX,AX
			INC		CX

			ADD		DI,AX
	DB $66;	MOV		AX,[WORD PTR CDWord]
			JCXZ	@@SKIP2
			TEST	DI,$0001
			JZ		@@NOTONE
			OR		[BYTE PTR ES:DI],AL
			INC		DI
			DEC		CX
			JZ		@@SKIP2
@@NOTONE:
			CMP		CX,2
			JB		@@NOTTWO
			TEST	DI,$0002
			JZ		@@NOTTWO
			OR		[WORD PTR ES:DI],AX
			ADD		DI,2
			SUB		CX,2
			JZ		@@SKIP2
@@NOTTWO:
			SHR		CX,1
			DB $0F, $92, $C3
			SHR		CX,1
			DB $0F, $92, $C7
			JCXZ	@@SKIP0
@@STOSLOOP:
	DB $66;	OR		[WORD PTR ES:DI],AX
			ADD		DI,4
			DEC		CX
			JNZ		@@STOSLOOP
@@SKIP0:
			OR		BH,BH
			JZ		@@SKIP1
			OR		[WORD PTR ES:DI],AX
			ADD		DI,2
@@SKIP1:
			OR		BL,BL
			JZ		@@SKIP2
			OR		[BYTE PTR ES:DI],AL
			INC		DI
@@SKIP2:
			MOV		DI,SI
@@NEXTLINE:
			MOV		AX,[Y]
			CMP		AX,[Min1]
			JL		@@ADJ2
			CMP		AX,[Max1]
			JG		@@ADJ2
	DB $66;	MOV		BX,[WORD PTR DX1]
	DB $66;	ADD		[WORD PTR CX1],BX
@@ADJ2:
			CMP		AX,[Min2]
			JL		@@ADJ3
			CMP		AX,[Max2]
			JG		@@ADJ3
	DB $66;	MOV		BX,[WORD PTR DX2]
	DB $66;	ADD		[WORD PTR CX2],BX
@@ADJ3:
			CMP		AX,[Min3]
			JL		@@ADJ4
			CMP		AX,[Max3]
			JG		@@ADJ4
	DB $66;	MOV		BX,[WORD PTR DX3]
	DB $66;	ADD		[WORD PTR CX3],BX
@@ADJ4:
			CMP		AX,[Min4]
			JL		@@ADJ5
			CMP		AX,[Max4]
			JG		@@ADJ5
	DB $66;	MOV		BX,[WORD PTR DX4]
	DB $66;	ADD		[WORD PTR CX4],BX
@@ADJ5:
			MOV		AX,[Y]
			CMP		AX,[ClipY1]
			JL		@@ONLY_Y
			ADD		DI,320
@@ONLY_Y:
			INC		[Y]
			JMP		@@LINELOOP
@@EXIT:
End;

Procedure XQuadraGlenzXOR(X1,Y1,X2,Y2,X3,Y3,X4,Y4 : Integer; Color : Byte; VideoSeg : Word); Assembler;
Var
	XX1,XX2		: LongInt;
	XX3,XX4		: LongInt;
	DX1,DX2		: LongInt;
	DX3,DX4		: LongInt;
	CX1,CX2		: LongInt;		{ Moves from 1 to 2, 2 to 3 }
	CX3,CX4		: LongInt;		{ Moves from 3 to 4, 1 to 4 }
	Min1,Min2	: Integer;
	Min3,Min4	: Integer;
	Max1,Max2	: Integer;
	Max3,Max4	: Integer;
	Y,YMin,YMax	: Integer;
	CDWord		: LongInt;
Asm
			CLD
			MOV		BL,[Color]
			MOV		BH,BL
			MOV		AX,BX
	DB $66;	SHL		AX,16
			MOV		AX,BX
	DB $66;	MOV		[WORD PTR CDWord],AX

			MOV		AX,[Y1]		{ AX = YMin }
			MOV		BX,AX		{ BX = YMax }
			CMP		AX,[Y2]
			JLE		@@OK1
			MOV		AX,[Y2]
@@OK1:
			CMP		AX,[Y3]
			JLE		@@OK2
			MOV		AX,[Y3]
@@OK2:
			CMP		AX,[Y4]
			JLE		@@OK3
			MOV		AX,[Y4]
@@OK3:
			CMP		BX,[Y2]
			JGE		@@OK4
			MOV		BX,[Y2]
@@OK4:
			CMP		BX,[Y3]
			JGE		@@OK5
			MOV		BX,[Y3]
@@OK5:
			CMP		BX,[Y4]
			JGE		@@OK6
			MOV		BX,[Y4]
@@OK6:
			MOV		[YMin],AX
			MOV		[YMax],BX

			DB $66, $0F, $BF, $46, OFFSET X1	{ MOVSX EAX,[X1] }
	DB $66;	SAL		AX,Scaler
	DB $66;	MOV		[WORD PTR XX1],AX
			DB $66, $0F, $BF, $46, OFFSET X2	{ MOVSX EAX,[X2] }
	DB $66;	SAL		AX,Scaler
	DB $66;	MOV		[WORD PTR XX2],AX
			DB $66, $0F, $BF, $46, OFFSET X3	{ MOVSX EAX,[X3] }
	DB $66;	SAL		AX,Scaler
	DB $66;	MOV		[WORD PTR XX3],AX
			DB $66, $0F, $BF, $46, OFFSET X4	{ MOVSX EAX,[X4] }
	DB $66;	SAL		AX,Scaler
	DB $66;	MOV		[WORD PTR XX4],AX

			MOV		AX,[Y1]
			CMP		AX,[Y2]
			JE		@@EQ1
	DB $66;	MOV		AX,[WORD PTR XX2]
	DB $66;	SUB		AX,[WORD PTR XX1]
	DB $66;	CWD
			MOV     BX,[Y2]
			SUB		BX,[Y1]
			DB $66, $0F, $BF, $CB				{ MOVSX ECX,BX }
	DB $66;	IDIV	CX
	DB $66;	MOV		[WORD PTR DX1],AX
			JMP		@@LINEISOK_1
@@EQ1:
	DB $66;	XOR		AX,AX
	DB $66;	MOV		[WORD PTR DX1],AX
@@LINEISOK_1:

			MOV		AX,[Y2]
			CMP		AX,[Y3]
			JE		@@EQ2
	DB $66;	MOV		AX,[WORD PTR XX3]
	DB $66;	SUB		AX,[WORD PTR XX2]
	DB $66;	CWD
			MOV     BX,[Y3]
			SUB		BX,[Y2]
			DB $66, $0F, $BF, $CB				{ MOVSX ECX,BX }
	DB $66;	IDIV	CX
	DB $66;	MOV		[WORD PTR DX2],AX
			JMP		@@LINEISOK_2
@@EQ2:
	DB $66;	XOR		AX,AX
	DB $66;	MOV		[WORD PTR DX2],AX
@@LINEISOK_2:

			MOV		AX,[Y3]
			CMP		AX,[Y4]
			JE		@@EQ3
	DB $66;	MOV		AX,[WORD PTR XX4]
	DB $66;	SUB		AX,[WORD PTR XX3]
	DB $66;	CWD
			MOV     BX,[Y4]
			SUB		BX,[Y3]
			DB $66, $0F, $BF, $CB				{ MOVSX ECX,BX }
	DB $66;	IDIV	CX
	DB $66;	MOV		[WORD PTR DX3],AX
			JMP		@@LINEISOK_3
@@EQ3:
	DB $66;	XOR		AX,AX
	DB $66;	MOV		[WORD PTR DX3],AX
@@LINEISOK_3:

			MOV		AX,[Y1]
			CMP		AX,[Y4]
			JE		@@EQ4
	DB $66;	MOV		AX,[WORD PTR XX4]
	DB $66;	SUB		AX,[WORD PTR XX1]
	DB $66;	CWD
			MOV     BX,[Y4]
			SUB		BX,[Y1]
			DB $66, $0F, $BF, $CB				{ MOVSX ECX,BX }
	DB $66;	IDIV	CX
	DB $66;	MOV		[WORD PTR DX4],AX
			JMP		@@LINEISOK_4
@@EQ4:
	DB $66;	XOR		AX,AX
	DB $66;	MOV		[WORD PTR DX4],AX
@@LINEISOK_4:

			MOV		BX,[Y1]
			CMP		BX,[Y2]
			JLE		@@DIR12
	DB $66;	MOV		AX,[WORD PTR XX2]
	DB $66;	MOV		[WORD PTR CX1],AX
			JMP		@@CHECKDIR2
@@DIR12:
	DB $66;	MOV		AX,[WORD PTR XX1]
	DB $66;	MOV		[WORD PTR CX1],AX

@@CHECKDIR2:
			MOV		BX,[Y2]
			CMP		BX,[Y3]
			JLE		@@DIR23
	DB $66;	MOV		AX,[WORD PTR XX3]
	DB $66;	MOV		[WORD PTR CX2],AX
			JMP		@@CHECKDIR3
@@DIR23:
	DB $66;	MOV		AX,[WORD PTR XX2]
	DB $66;	MOV		[WORD PTR CX2],AX

@@CHECKDIR3:
			MOV		BX,[Y3]
			CMP		BX,[Y4]
			JLE		@@DIR34
	DB $66;	MOV		AX,[WORD PTR XX4]
	DB $66;	MOV		[WORD PTR CX3],AX
			JMP		@@CHECKDIR4
@@DIR34:
	DB $66;	MOV		AX,[WORD PTR XX3]
	DB $66;	MOV		[WORD PTR CX3],AX

@@CHECKDIR4:
			MOV		BX,[Y1]
			CMP		BX,[Y4]
			JLE		@@DIR14
	DB $66;	MOV		AX,[WORD PTR XX4]
	DB $66;	MOV		[WORD PTR CX4],AX
			JMP		@@NODIRSLEFT
@@DIR14:
	DB $66;	MOV		AX,[WORD PTR XX1]
	DB $66;	MOV		[WORD PTR CX4],AX
@@NODIRSLEFT:
			MOV		AX,[Y1]
			MOV		BX,[Y2]
			CMP		AX,BX
			JLE		@@USELINE1
			XCHG	AX,BX
@@USELINE1:
			MOV		[Min1],AX
			MOV		[Max1],BX

			MOV		AX,[Y2]
			MOV		BX,[Y3]
			CMP		AX,BX
			JLE		@@USELINE2
			XCHG	AX,BX
@@USELINE2:
			MOV		[Min2],AX
			MOV		[Max2],BX

			MOV		AX,[Y3]
			MOV		BX,[Y4]
			CMP		AX,BX
			JLE		@@USELINE3
			XCHG	AX,BX
@@USELINE3:
			MOV		[Min3],AX
			MOV		[Max3],BX

			MOV		AX,[Y1]
			MOV		BX,[Y4]
			CMP		AX,BX
			JLE		@@USELINE4
			XCHG	AX,BX
@@USELINE4:
			MOV		[Min4],AX
			MOV		[Max4],BX

			MOV		AX,[YMin]
			MOV		[Y],AX
			TEST	AX,AX
			JGE		@@MOVEIT
			SUB		AX,AX
@@MOVEIT:
			MOV		DI,AX
			SHL		DI,6
			SHL		AX,8
			ADD		DI,AX
			MOV		ES,[VideoSeg]

@@LINELOOP:
			MOV		AX,[Y]
			CMP		AX,[YMax]
			JG		@@EXIT
			CMP		AX,0
			JL		@@NEXTLINE
			CMP		AX,199
			JG		@@EXIT

	DB $66;	MOV		AX,$FFFF; DW $7FFF	{ MAX }
	DB $66;	MOV		BX,$0000; DW $8000	{ MIN }
			MOV		CX,[Y]

			CMP		CX,[Min1]
			JL		@@CHECK2
			CMP		CX,[Max1]
			JG		@@CHECK2
	DB $66;	CMP		AX,[WORD PTR CX1]
			JLE		@@CHECK1_2
	DB $66;	MOV		AX,[WORD PTR CX1]
@@CHECK1_2:
	DB $66;	CMP		BX,[WORD PTR CX1]
			JGE		@@CHECK2
	DB $66;	MOV		BX,[WORD PTR CX1]

@@CHECK2:
			CMP		CX,[Min2]
			JL		@@CHECK3
			CMP		CX,[Max2]
			JG		@@CHECK3
	DB $66;	CMP		AX,[WORD PTR CX2]
			JLE		@@CHECK2_2
	DB $66;	MOV		AX,[WORD PTR CX2]
@@CHECK2_2:
	DB $66;	CMP		BX,[WORD PTR CX2]
			JGE		@@CHECK3
	DB $66;	MOV		BX,[WORD PTR CX2]

@@CHECK3:
			CMP		CX,[Min3]
			JL		@@CHECK4
			CMP		CX,[Max3]
			JG		@@CHECK4
	DB $66;	CMP		AX,[WORD PTR CX3]
			JLE		@@CHECK3_2
	DB $66;	MOV		AX,[WORD PTR CX3]
@@CHECK3_2:
	DB $66;	CMP		BX,[WORD PTR CX3]
			JGE		@@CHECK4
	DB $66;	MOV		BX,[WORD PTR CX3]

@@CHECK4:
			CMP		CX,[Min4]
			JL		@@CHECK5
			CMP		CX,[Max4]
			JG		@@CHECK5
	DB $66;	CMP		AX,[WORD PTR CX4]
			JLE		@@CHECK4_2
	DB $66;	MOV		AX,[WORD PTR CX4]
@@CHECK4_2:
	DB $66;	CMP		BX,[WORD PTR CX4]
			JGE		@@CHECK5
	DB $66;	MOV		BX,[WORD PTR CX4]
@@CHECK5:

	DB $66;	PUSH	CX
	DB $66;	XOR		CX,CX
	DB $66;	SAR		AX,Scaler
	DB $66;	ADC		AX,CX
	DB $66;	SAR		BX,Scaler
	DB $66;	ADC		BX,CX
	DB $66;	POP		CX

			CMP		AX,319
			JG		@@NEXTLINE
			TEST	BX,BX
			JL		@@NEXTLINE

			CMP		BX,319
			JLE		@@MAXISOK
			MOV		BX,319
@@MAXISOK:
			TEST	AX,AX
			JGE		@@MINISOK
			SUB		AX,AX
@@MINISOK:
			MOV		SI,DI

			MOV		CX,BX
			SUB		CX,AX
			INC		CX

			ADD		DI,AX
	DB $66;	MOV		AX,[WORD PTR CDWord]
			JCXZ	@@SKIP2
			TEST	DI,$0001
			JZ		@@NOTONE
			XOR		[BYTE PTR ES:DI],AL
			INC		DI
			DEC		CX
			JZ		@@SKIP2
@@NOTONE:
			CMP		CX,2
			JB		@@NOTTWO
			TEST	DI,$0002
			JZ		@@NOTTWO
			XOR		[WORD PTR ES:DI],AX
			ADD		DI,2
			SUB		CX,2
			JZ		@@SKIP2
@@NOTTWO:
			SHR		CX,1
			DB $0F, $92, $C3
			SHR		CX,1
			DB $0F, $92, $C7
			JCXZ	@@SKIP0
@@STOSLOOP:
	DB $66;	XOR		[WORD PTR ES:DI],AX
			ADD		DI,4
			DEC		CX
			JNZ		@@STOSLOOP
@@SKIP0:
			OR		BH,BH
			JZ		@@SKIP1
			XOR		[WORD PTR ES:DI],AX
			ADD		DI,2
@@SKIP1:
			OR		BL,BL
			JZ		@@SKIP2
			XOR		[BYTE PTR ES:DI],AL
			INC		DI
@@SKIP2:
			MOV		DI,SI
@@NEXTLINE:
			MOV		AX,[Y]
			CMP		AX,[Min1]
			JL		@@ADJ2
			CMP		AX,[Max1]
			JG		@@ADJ2
	DB $66;	MOV		BX,[WORD PTR DX1]
	DB $66;	ADD		[WORD PTR CX1],BX
@@ADJ2:
			CMP		AX,[Min2]
			JL		@@ADJ3
			CMP		AX,[Max2]
			JG		@@ADJ3
	DB $66;	MOV		BX,[WORD PTR DX2]
	DB $66;	ADD		[WORD PTR CX2],BX
@@ADJ3:
			CMP		AX,[Min3]
			JL		@@ADJ4
			CMP		AX,[Max3]
			JG		@@ADJ4
	DB $66;	MOV		BX,[WORD PTR DX3]
	DB $66;	ADD		[WORD PTR CX3],BX
@@ADJ4:
			CMP		AX,[Min4]
			JL		@@ADJ5
			CMP		AX,[Max4]
			JG		@@ADJ5
	DB $66;	MOV		BX,[WORD PTR DX4]
	DB $66;	ADD		[WORD PTR CX4],BX
@@ADJ5:
			MOV		AX,[Y]
			CMP		AX,0
			JL		@@ONLY_Y
			ADD		DI,320
@@ONLY_Y:
			INC		[Y]
			JMP		@@LINELOOP
@@EXIT:
End;

Procedure XQuadraGlenzXORClip(X1,Y1,X2,Y2,X3,Y3,X4,Y4,ClipX1,ClipY1,ClipX2,ClipY2 : Integer;
	Color : Byte; VideoSeg : Word); Assembler;
Var
	XX1,XX2		: LongInt;
	XX3,XX4		: LongInt;
	DX1,DX2		: LongInt;
	DX3,DX4		: LongInt;
	CX1,CX2		: LongInt;		{ Moves from 1 to 2, 2 to 3 }
	CX3,CX4		: LongInt;		{ Moves from 3 to 4, 1 to 4 }
	Min1,Min2	: Integer;
	Min3,Min4	: Integer;
	Max1,Max2	: Integer;
	Max3,Max4	: Integer;
	Y,YMin,YMax	: Integer;
	CDWord		: LongInt;
Asm
			CLD
			MOV		BL,[Color]
			MOV		BH,BL
			MOV		AX,BX
	DB $66;	SHL		AX,16
			MOV		AX,BX
	DB $66;	MOV		[WORD PTR CDWord],AX

			MOV		AX,[Y1]		{ AX = YMin }
			MOV		BX,AX		{ BX = YMax }
			CMP		AX,[Y2]
			JLE		@@OK1
			MOV		AX,[Y2]
@@OK1:
			CMP		AX,[Y3]
			JLE		@@OK2
			MOV		AX,[Y3]
@@OK2:
			CMP		AX,[Y4]
			JLE		@@OK3
			MOV		AX,[Y4]
@@OK3:
			CMP		BX,[Y2]
			JGE		@@OK4
			MOV		BX,[Y2]
@@OK4:
			CMP		BX,[Y3]
			JGE		@@OK5
			MOV		BX,[Y3]
@@OK5:
			CMP		BX,[Y4]
			JGE		@@OK6
			MOV		BX,[Y4]
@@OK6:
			MOV		[YMin],AX
			MOV		[YMax],BX

			DB $66, $0F, $BF, $46, OFFSET X1	{ MOVSX EAX,[X1] }
	DB $66;	SAL		AX,Scaler
	DB $66;	MOV		[WORD PTR XX1],AX
			DB $66, $0F, $BF, $46, OFFSET X2	{ MOVSX EAX,[X2] }
	DB $66;	SAL		AX,Scaler
	DB $66;	MOV		[WORD PTR XX2],AX
			DB $66, $0F, $BF, $46, OFFSET X3	{ MOVSX EAX,[X3] }
	DB $66;	SAL		AX,Scaler
	DB $66;	MOV		[WORD PTR XX3],AX
			DB $66, $0F, $BF, $46, OFFSET X4	{ MOVSX EAX,[X4] }
	DB $66;	SAL		AX,Scaler
	DB $66;	MOV		[WORD PTR XX4],AX

			MOV		AX,[Y1]
			CMP		AX,[Y2]
			JE		@@EQ1
	DB $66;	MOV		AX,[WORD PTR XX2]
	DB $66;	SUB		AX,[WORD PTR XX1]
	DB $66;	CWD
			MOV     BX,[Y2]
			SUB		BX,[Y1]
			DB $66, $0F, $BF, $CB				{ MOVSX ECX,BX }
	DB $66;	IDIV	CX
	DB $66;	MOV		[WORD PTR DX1],AX
			JMP		@@LINEISOK_1
@@EQ1:
	DB $66;	XOR		AX,AX
	DB $66;	MOV		[WORD PTR DX1],AX
@@LINEISOK_1:

			MOV		AX,[Y2]
			CMP		AX,[Y3]
			JE		@@EQ2
	DB $66;	MOV		AX,[WORD PTR XX3]
	DB $66;	SUB		AX,[WORD PTR XX2]
	DB $66;	CWD
			MOV     BX,[Y3]
			SUB		BX,[Y2]
			DB $66, $0F, $BF, $CB				{ MOVSX ECX,BX }
	DB $66;	IDIV	CX
	DB $66;	MOV		[WORD PTR DX2],AX
			JMP		@@LINEISOK_2
@@EQ2:
	DB $66;	XOR		AX,AX
	DB $66;	MOV		[WORD PTR DX2],AX
@@LINEISOK_2:

			MOV		AX,[Y3]
			CMP		AX,[Y4]
			JE		@@EQ3
	DB $66;	MOV		AX,[WORD PTR XX4]
	DB $66;	SUB		AX,[WORD PTR XX3]
	DB $66;	CWD
			MOV     BX,[Y4]
			SUB		BX,[Y3]
			DB $66, $0F, $BF, $CB				{ MOVSX ECX,BX }
	DB $66;	IDIV	CX
	DB $66;	MOV		[WORD PTR DX3],AX
			JMP		@@LINEISOK_3
@@EQ3:
	DB $66;	XOR		AX,AX
	DB $66;	MOV		[WORD PTR DX3],AX
@@LINEISOK_3:

			MOV		AX,[Y1]
			CMP		AX,[Y4]
			JE		@@EQ4
	DB $66;	MOV		AX,[WORD PTR XX4]
	DB $66;	SUB		AX,[WORD PTR XX1]
	DB $66;	CWD
			MOV     BX,[Y4]
			SUB		BX,[Y1]
			DB $66, $0F, $BF, $CB				{ MOVSX ECX,BX }
	DB $66;	IDIV	CX
	DB $66;	MOV		[WORD PTR DX4],AX
			JMP		@@LINEISOK_4
@@EQ4:
	DB $66;	XOR		AX,AX
	DB $66;	MOV		[WORD PTR DX4],AX
@@LINEISOK_4:

			MOV		BX,[Y1]
			CMP		BX,[Y2]
			JLE		@@DIR12
	DB $66;	MOV		AX,[WORD PTR XX2]
	DB $66;	MOV		[WORD PTR CX1],AX
			JMP		@@CHECKDIR2
@@DIR12:
	DB $66;	MOV		AX,[WORD PTR XX1]
	DB $66;	MOV		[WORD PTR CX1],AX

@@CHECKDIR2:
			MOV		BX,[Y2]
			CMP		BX,[Y3]
			JLE		@@DIR23
	DB $66;	MOV		AX,[WORD PTR XX3]
	DB $66;	MOV		[WORD PTR CX2],AX
			JMP		@@CHECKDIR3
@@DIR23:
	DB $66;	MOV		AX,[WORD PTR XX2]
	DB $66;	MOV		[WORD PTR CX2],AX

@@CHECKDIR3:
			MOV		BX,[Y3]
			CMP		BX,[Y4]
			JLE		@@DIR34
	DB $66;	MOV		AX,[WORD PTR XX4]
	DB $66;	MOV		[WORD PTR CX3],AX
			JMP		@@CHECKDIR4
@@DIR34:
	DB $66;	MOV		AX,[WORD PTR XX3]
	DB $66;	MOV		[WORD PTR CX3],AX

@@CHECKDIR4:
			MOV		BX,[Y1]
			CMP		BX,[Y4]
			JLE		@@DIR14
	DB $66;	MOV		AX,[WORD PTR XX4]
	DB $66;	MOV		[WORD PTR CX4],AX
			JMP		@@NODIRSLEFT
@@DIR14:
	DB $66;	MOV		AX,[WORD PTR XX1]
	DB $66;	MOV		[WORD PTR CX4],AX
@@NODIRSLEFT:
			MOV		AX,[Y1]
			MOV		BX,[Y2]
			CMP		AX,BX
			JLE		@@USELINE1
			XCHG	AX,BX
@@USELINE1:
			MOV		[Min1],AX
			MOV		[Max1],BX

			MOV		AX,[Y2]
			MOV		BX,[Y3]
			CMP		AX,BX
			JLE		@@USELINE2
			XCHG	AX,BX
@@USELINE2:
			MOV		[Min2],AX
			MOV		[Max2],BX

			MOV		AX,[Y3]
			MOV		BX,[Y4]
			CMP		AX,BX
			JLE		@@USELINE3
			XCHG	AX,BX
@@USELINE3:
			MOV		[Min3],AX
			MOV		[Max3],BX

			MOV		AX,[Y1]
			MOV		BX,[Y4]
			CMP		AX,BX
			JLE		@@USELINE4
			XCHG	AX,BX
@@USELINE4:
			MOV		[Min4],AX
			MOV		[Max4],BX

			MOV		AX,[YMin]
			MOV		[Y],AX
			CMP		AX,[ClipY1]
			JGE		@@MOVEIT
			MOV		AX,[ClipY1]
@@MOVEIT:
			MOV		DI,AX
			SHL		DI,6
			SHL		AX,8
			ADD		DI,AX
			MOV		ES,[VideoSeg]
@@LINELOOP:
			MOV		AX,[Y]
			CMP		AX,[YMax]
			JG		@@EXIT
			CMP		AX,[ClipY1]
			JL		@@NEXTLINE
			CMP		AX,[ClipY2]
			JG		@@EXIT

	DB $66;	MOV		AX,$FFFF; DW $7FFF	{ MAX }
	DB $66;	MOV		BX,$0000; DW $8000	{ MIN }
			MOV		CX,[Y]

			CMP		CX,[Min1]
			JL		@@CHECK2
			CMP		CX,[Max1]
			JG		@@CHECK2
	DB $66;	CMP		AX,[WORD PTR CX1]
			JLE		@@CHECK1_2
	DB $66;	MOV		AX,[WORD PTR CX1]
@@CHECK1_2:
	DB $66;	CMP		BX,[WORD PTR CX1]
			JGE		@@CHECK2
	DB $66;	MOV		BX,[WORD PTR CX1]

@@CHECK2:
			CMP		CX,[Min2]
			JL		@@CHECK3
			CMP		CX,[Max2]
			JG		@@CHECK3
	DB $66;	CMP		AX,[WORD PTR CX2]
			JLE		@@CHECK2_2
	DB $66;	MOV		AX,[WORD PTR CX2]
@@CHECK2_2:
	DB $66;	CMP		BX,[WORD PTR CX2]
			JGE		@@CHECK3
	DB $66;	MOV		BX,[WORD PTR CX2]

@@CHECK3:
			CMP		CX,[Min3]
			JL		@@CHECK4
			CMP		CX,[Max3]
			JG		@@CHECK4
	DB $66;	CMP		AX,[WORD PTR CX3]
			JLE		@@CHECK3_2
	DB $66;	MOV		AX,[WORD PTR CX3]
@@CHECK3_2:
	DB $66;	CMP		BX,[WORD PTR CX3]
			JGE		@@CHECK4
	DB $66;	MOV		BX,[WORD PTR CX3]

@@CHECK4:
			CMP		CX,[Min4]
			JL		@@CHECK5
			CMP		CX,[Max4]
			JG		@@CHECK5
	DB $66;	CMP		AX,[WORD PTR CX4]
			JLE		@@CHECK4_2
	DB $66;	MOV		AX,[WORD PTR CX4]
@@CHECK4_2:
	DB $66;	CMP		BX,[WORD PTR CX4]
			JGE		@@CHECK5
	DB $66;	MOV		BX,[WORD PTR CX4]
@@CHECK5:

	DB $66;	PUSH	CX
	DB $66;	XOR		CX,CX
	DB $66;	SAR		AX,Scaler
	DB $66;	ADC		AX,CX
	DB $66;	SAR		BX,Scaler
	DB $66;	ADC		BX,CX
	DB $66;	POP		CX

			CMP		AX,[ClipX2]
			JG		@@NEXTLINE
			CMP		BX,[ClipX1]
			JL		@@NEXTLINE

			CMP		BX,[ClipX2]
			JLE		@@MAXISOK
			MOV		BX,[ClipX2]
@@MAXISOK:
			CMP		AX,[ClipX1]
			JGE		@@MINISOK
			MOV		AX,[ClipX1]
@@MINISOK:
			MOV		SI,DI

			MOV		CX,BX
			SUB		CX,AX
			INC		CX

			ADD		DI,AX
	DB $66;	MOV		AX,[WORD PTR CDWord]
			JCXZ	@@SKIP2
			TEST	DI,$0001
			JZ		@@NOTONE
			XOR		[BYTE PTR ES:DI],AL
			INC		DI
			DEC		CX
			JZ		@@SKIP2
@@NOTONE:
			CMP		CX,2
			JB		@@NOTTWO
			TEST	DI,$0002
			JZ		@@NOTTWO
			XOR		[WORD PTR ES:DI],AX
			ADD		DI,2
			SUB		CX,2
			JZ		@@SKIP2
@@NOTTWO:
			SHR		CX,1
			DB $0F, $92, $C3
			SHR		CX,1
			DB $0F, $92, $C7
			JCXZ	@@SKIP0
@@STOSLOOP:
	DB $66;	XOR		[WORD PTR ES:DI],AX
			ADD		DI,4
			DEC		CX
			JNZ		@@STOSLOOP
@@SKIP0:
			OR		BH,BH
			JZ		@@SKIP1
			XOR		[WORD PTR ES:DI],AX
			ADD		DI,2
@@SKIP1:
			OR		BL,BL
			JZ		@@SKIP2
			XOR		[BYTE PTR ES:DI],AL
			INC		DI
@@SKIP2:
			MOV		DI,SI
@@NEXTLINE:
			MOV		AX,[Y]
			CMP		AX,[Min1]
			JL		@@ADJ2
			CMP		AX,[Max1]
			JG		@@ADJ2
	DB $66;	MOV		BX,[WORD PTR DX1]
	DB $66;	ADD		[WORD PTR CX1],BX
@@ADJ2:
			CMP		AX,[Min2]
			JL		@@ADJ3
			CMP		AX,[Max2]
			JG		@@ADJ3
	DB $66;	MOV		BX,[WORD PTR DX2]
	DB $66;	ADD		[WORD PTR CX2],BX
@@ADJ3:
			CMP		AX,[Min3]
			JL		@@ADJ4
			CMP		AX,[Max3]
			JG		@@ADJ4
	DB $66;	MOV		BX,[WORD PTR DX3]
	DB $66;	ADD		[WORD PTR CX3],BX
@@ADJ4:
			CMP		AX,[Min4]
			JL		@@ADJ5
			CMP		AX,[Max4]
			JG		@@ADJ5
	DB $66;	MOV		BX,[WORD PTR DX4]
	DB $66;	ADD		[WORD PTR CX4],BX
@@ADJ5:
			MOV		AX,[Y]
			CMP		AX,[ClipY1]
			JL		@@ONLY_Y
			ADD		DI,320
@@ONLY_Y:
			INC		[Y]
			JMP		@@LINELOOP
@@EXIT:
End;

Procedure XQuadraGlenzAND(X1,Y1,X2,Y2,X3,Y3,X4,Y4 : Integer; Color : Byte; VideoSeg : Word); Assembler;
Var
	XX1,XX2		: LongInt;
	XX3,XX4		: LongInt;
	DX1,DX2		: LongInt;
	DX3,DX4		: LongInt;
	CX1,CX2		: LongInt;		{ Moves from 1 to 2, 2 to 3 }
	CX3,CX4		: LongInt;		{ Moves from 3 to 4, 1 to 4 }
	Min1,Min2	: Integer;
	Min3,Min4	: Integer;
	Max1,Max2	: Integer;
	Max3,Max4	: Integer;
	Y,YMin,YMax	: Integer;
	CDWord		: LongInt;
Asm
			CLD
			MOV		BL,[Color]
			MOV		BH,BL
			MOV		AX,BX
	DB $66;	SHL		AX,16
			MOV		AX,BX
	DB $66;	MOV		[WORD PTR CDWord],AX

			MOV		AX,[Y1]		{ AX = YMin }
			MOV		BX,AX		{ BX = YMax }
			CMP		AX,[Y2]
			JLE		@@OK1
			MOV		AX,[Y2]
@@OK1:
			CMP		AX,[Y3]
			JLE		@@OK2
			MOV		AX,[Y3]
@@OK2:
			CMP		AX,[Y4]
			JLE		@@OK3
			MOV		AX,[Y4]
@@OK3:
			CMP		BX,[Y2]
			JGE		@@OK4
			MOV		BX,[Y2]
@@OK4:
			CMP		BX,[Y3]
			JGE		@@OK5
			MOV		BX,[Y3]
@@OK5:
			CMP		BX,[Y4]
			JGE		@@OK6
			MOV		BX,[Y4]
@@OK6:
			MOV		[YMin],AX
			MOV		[YMax],BX

			DB $66, $0F, $BF, $46, OFFSET X1	{ MOVSX EAX,[X1] }
	DB $66;	SAL		AX,Scaler
	DB $66;	MOV		[WORD PTR XX1],AX
			DB $66, $0F, $BF, $46, OFFSET X2	{ MOVSX EAX,[X2] }
	DB $66;	SAL		AX,Scaler
	DB $66;	MOV		[WORD PTR XX2],AX
			DB $66, $0F, $BF, $46, OFFSET X3	{ MOVSX EAX,[X3] }
	DB $66;	SAL		AX,Scaler
	DB $66;	MOV		[WORD PTR XX3],AX
			DB $66, $0F, $BF, $46, OFFSET X4	{ MOVSX EAX,[X4] }
	DB $66;	SAL		AX,Scaler
	DB $66;	MOV		[WORD PTR XX4],AX

			MOV		AX,[Y1]
			CMP		AX,[Y2]
			JE		@@EQ1
	DB $66;	MOV		AX,[WORD PTR XX2]
	DB $66;	SUB		AX,[WORD PTR XX1]
	DB $66;	CWD
			MOV     BX,[Y2]
			SUB		BX,[Y1]
			DB $66, $0F, $BF, $CB				{ MOVSX ECX,BX }
	DB $66;	IDIV	CX
	DB $66;	MOV		[WORD PTR DX1],AX
			JMP		@@LINEISOK_1
@@EQ1:
	DB $66;	XOR		AX,AX
	DB $66;	MOV		[WORD PTR DX1],AX
@@LINEISOK_1:

			MOV		AX,[Y2]
			CMP		AX,[Y3]
			JE		@@EQ2
	DB $66;	MOV		AX,[WORD PTR XX3]
	DB $66;	SUB		AX,[WORD PTR XX2]
	DB $66;	CWD
			MOV     BX,[Y3]
			SUB		BX,[Y2]
			DB $66, $0F, $BF, $CB				{ MOVSX ECX,BX }
	DB $66;	IDIV	CX
	DB $66;	MOV		[WORD PTR DX2],AX
			JMP		@@LINEISOK_2
@@EQ2:
	DB $66;	XOR		AX,AX
	DB $66;	MOV		[WORD PTR DX2],AX
@@LINEISOK_2:

			MOV		AX,[Y3]
			CMP		AX,[Y4]
			JE		@@EQ3
	DB $66;	MOV		AX,[WORD PTR XX4]
	DB $66;	SUB		AX,[WORD PTR XX3]
	DB $66;	CWD
			MOV     BX,[Y4]
			SUB		BX,[Y3]
			DB $66, $0F, $BF, $CB				{ MOVSX ECX,BX }
	DB $66;	IDIV	CX
	DB $66;	MOV		[WORD PTR DX3],AX
			JMP		@@LINEISOK_3
@@EQ3:
	DB $66;	XOR		AX,AX
	DB $66;	MOV		[WORD PTR DX3],AX
@@LINEISOK_3:

			MOV		AX,[Y1]
			CMP		AX,[Y4]
			JE		@@EQ4
	DB $66;	MOV		AX,[WORD PTR XX4]
	DB $66;	SUB		AX,[WORD PTR XX1]
	DB $66;	CWD
			MOV     BX,[Y4]
			SUB		BX,[Y1]
			DB $66, $0F, $BF, $CB				{ MOVSX ECX,BX }
	DB $66;	IDIV	CX
	DB $66;	MOV		[WORD PTR DX4],AX
			JMP		@@LINEISOK_4
@@EQ4:
	DB $66;	XOR		AX,AX
	DB $66;	MOV		[WORD PTR DX4],AX
@@LINEISOK_4:

			MOV		BX,[Y1]
			CMP		BX,[Y2]
			JLE		@@DIR12
	DB $66;	MOV		AX,[WORD PTR XX2]
	DB $66;	MOV		[WORD PTR CX1],AX
			JMP		@@CHECKDIR2
@@DIR12:
	DB $66;	MOV		AX,[WORD PTR XX1]
	DB $66;	MOV		[WORD PTR CX1],AX

@@CHECKDIR2:
			MOV		BX,[Y2]
			CMP		BX,[Y3]
			JLE		@@DIR23
	DB $66;	MOV		AX,[WORD PTR XX3]
	DB $66;	MOV		[WORD PTR CX2],AX
			JMP		@@CHECKDIR3
@@DIR23:
	DB $66;	MOV		AX,[WORD PTR XX2]
	DB $66;	MOV		[WORD PTR CX2],AX

@@CHECKDIR3:
			MOV		BX,[Y3]
			CMP		BX,[Y4]
			JLE		@@DIR34
	DB $66;	MOV		AX,[WORD PTR XX4]
	DB $66;	MOV		[WORD PTR CX3],AX
			JMP		@@CHECKDIR4
@@DIR34:
	DB $66;	MOV		AX,[WORD PTR XX3]
	DB $66;	MOV		[WORD PTR CX3],AX

@@CHECKDIR4:
			MOV		BX,[Y1]
			CMP		BX,[Y4]
			JLE		@@DIR14
	DB $66;	MOV		AX,[WORD PTR XX4]
	DB $66;	MOV		[WORD PTR CX4],AX
			JMP		@@NODIRSLEFT
@@DIR14:
	DB $66;	MOV		AX,[WORD PTR XX1]
	DB $66;	MOV		[WORD PTR CX4],AX
@@NODIRSLEFT:
			MOV		AX,[Y1]
			MOV		BX,[Y2]
			CMP		AX,BX
			JLE		@@USELINE1
			XCHG	AX,BX
@@USELINE1:
			MOV		[Min1],AX
			MOV		[Max1],BX

			MOV		AX,[Y2]
			MOV		BX,[Y3]
			CMP		AX,BX
			JLE		@@USELINE2
			XCHG	AX,BX
@@USELINE2:
			MOV		[Min2],AX
			MOV		[Max2],BX

			MOV		AX,[Y3]
			MOV		BX,[Y4]
			CMP		AX,BX
			JLE		@@USELINE3
			XCHG	AX,BX
@@USELINE3:
			MOV		[Min3],AX
			MOV		[Max3],BX

			MOV		AX,[Y1]
			MOV		BX,[Y4]
			CMP		AX,BX
			JLE		@@USELINE4
			XCHG	AX,BX
@@USELINE4:
			MOV		[Min4],AX
			MOV		[Max4],BX

			MOV		AX,[YMin]
			MOV		[Y],AX
			TEST	AX,AX
			JGE		@@MOVEIT
			SUB		AX,AX
@@MOVEIT:
			MOV		DI,AX
			SHL		DI,6
			SHL		AX,8
			ADD		DI,AX
			MOV		ES,[VideoSeg]

@@LINELOOP:
			MOV		AX,[Y]
			CMP		AX,[YMax]
			JG		@@EXIT
			CMP		AX,0
			JL		@@NEXTLINE
			CMP		AX,199
			JG		@@EXIT

	DB $66;	MOV		AX,$FFFF; DW $7FFF	{ MAX }
	DB $66;	MOV		BX,$0000; DW $8000	{ MIN }
			MOV		CX,[Y]

			CMP		CX,[Min1]
			JL		@@CHECK2
			CMP		CX,[Max1]
			JG		@@CHECK2
	DB $66;	CMP		AX,[WORD PTR CX1]
			JLE		@@CHECK1_2
	DB $66;	MOV		AX,[WORD PTR CX1]
@@CHECK1_2:
	DB $66;	CMP		BX,[WORD PTR CX1]
			JGE		@@CHECK2
	DB $66;	MOV		BX,[WORD PTR CX1]

@@CHECK2:
			CMP		CX,[Min2]
			JL		@@CHECK3
			CMP		CX,[Max2]
			JG		@@CHECK3
	DB $66;	CMP		AX,[WORD PTR CX2]
			JLE		@@CHECK2_2
	DB $66;	MOV		AX,[WORD PTR CX2]
@@CHECK2_2:
	DB $66;	CMP		BX,[WORD PTR CX2]
			JGE		@@CHECK3
	DB $66;	MOV		BX,[WORD PTR CX2]

@@CHECK3:
			CMP		CX,[Min3]
			JL		@@CHECK4
			CMP		CX,[Max3]
			JG		@@CHECK4
	DB $66;	CMP		AX,[WORD PTR CX3]
			JLE		@@CHECK3_2
	DB $66;	MOV		AX,[WORD PTR CX3]
@@CHECK3_2:
	DB $66;	CMP		BX,[WORD PTR CX3]
			JGE		@@CHECK4
	DB $66;	MOV		BX,[WORD PTR CX3]

@@CHECK4:
			CMP		CX,[Min4]
			JL		@@CHECK5
			CMP		CX,[Max4]
			JG		@@CHECK5
	DB $66;	CMP		AX,[WORD PTR CX4]
			JLE		@@CHECK4_2
	DB $66;	MOV		AX,[WORD PTR CX4]
@@CHECK4_2:
	DB $66;	CMP		BX,[WORD PTR CX4]
			JGE		@@CHECK5
	DB $66;	MOV		BX,[WORD PTR CX4]
@@CHECK5:

	DB $66;	PUSH	CX
	DB $66;	XOR		CX,CX
	DB $66;	SAR		AX,Scaler
	DB $66;	ADC		AX,CX
	DB $66;	SAR		BX,Scaler
	DB $66;	ADC		BX,CX
	DB $66;	POP		CX

			CMP		AX,319
			JG		@@NEXTLINE
			TEST	BX,BX
			JL		@@NEXTLINE

			CMP		BX,319
			JLE		@@MAXISOK
			MOV		BX,319
@@MAXISOK:
			TEST	AX,AX
			JGE		@@MINISOK
			SUB		AX,AX
@@MINISOK:
			MOV		SI,DI

			MOV		CX,BX
			SUB		CX,AX
			INC		CX

			ADD		DI,AX
	DB $66;	MOV		AX,[WORD PTR CDWord]
			JCXZ	@@SKIP2
			TEST	DI,$0001
			JZ		@@NOTONE
			AND		[BYTE PTR ES:DI],AL
			INC		DI
			DEC		CX
			JZ		@@SKIP2
@@NOTONE:
			CMP		CX,2
			JB		@@NOTTWO
			TEST	DI,$0002
			JZ		@@NOTTWO
			AND		[WORD PTR ES:DI],AX
			ADD		DI,2
			SUB		CX,2
			JZ		@@SKIP2
@@NOTTWO:
			SHR		CX,1
			DB $0F, $92, $C3
			SHR		CX,1
			DB $0F, $92, $C7
			JCXZ	@@SKIP0
@@STOSLOOP:
	DB $66;	AND		[WORD PTR ES:DI],AX
			ADD		DI,4
			DEC		CX
			JNZ		@@STOSLOOP
@@SKIP0:
			OR		BH,BH
			JZ		@@SKIP1
			AND		[WORD PTR ES:DI],AX
			ADD		DI,2
@@SKIP1:
			OR		BL,BL
			JZ		@@SKIP2
			AND		[BYTE PTR ES:DI],AL
			INC		DI
@@SKIP2:
			MOV		DI,SI
@@NEXTLINE:
			MOV		AX,[Y]
			CMP		AX,[Min1]
			JL		@@ADJ2
			CMP		AX,[Max1]
			JG		@@ADJ2
	DB $66;	MOV		BX,[WORD PTR DX1]
	DB $66;	ADD		[WORD PTR CX1],BX
@@ADJ2:
			CMP		AX,[Min2]
			JL		@@ADJ3
			CMP		AX,[Max2]
			JG		@@ADJ3
	DB $66;	MOV		BX,[WORD PTR DX2]
	DB $66;	ADD		[WORD PTR CX2],BX
@@ADJ3:
			CMP		AX,[Min3]
			JL		@@ADJ4
			CMP		AX,[Max3]
			JG		@@ADJ4
	DB $66;	MOV		BX,[WORD PTR DX3]
	DB $66;	ADD		[WORD PTR CX3],BX
@@ADJ4:
			CMP		AX,[Min4]
			JL		@@ADJ5
			CMP		AX,[Max4]
			JG		@@ADJ5
	DB $66;	MOV		BX,[WORD PTR DX4]
	DB $66;	ADD		[WORD PTR CX4],BX
@@ADJ5:
			MOV		AX,[Y]
			CMP		AX,0
			JL		@@ONLY_Y
			ADD		DI,320
@@ONLY_Y:
			INC		[Y]
			JMP		@@LINELOOP
@@EXIT:
End;

Procedure XQuadraGlenzANDClip(X1,Y1,X2,Y2,X3,Y3,X4,Y4,ClipX1,ClipY1,ClipX2,ClipY2 : Integer;
	Color : Byte; VideoSeg : Word); Assembler;
Var
	XX1,XX2		: LongInt;
	XX3,XX4		: LongInt;
	DX1,DX2		: LongInt;
	DX3,DX4		: LongInt;
	CX1,CX2		: LongInt;		{ Moves from 1 to 2, 2 to 3 }
	CX3,CX4		: LongInt;		{ Moves from 3 to 4, 1 to 4 }
	Min1,Min2	: Integer;
	Min3,Min4	: Integer;
	Max1,Max2	: Integer;
	Max3,Max4	: Integer;
	Y,YMin,YMax	: Integer;
	CDWord		: LongInt;
Asm
			CLD
			MOV		BL,[Color]
			MOV		BH,BL
			MOV		AX,BX
	DB $66;	SHL		AX,16
			MOV		AX,BX
	DB $66;	MOV		[WORD PTR CDWord],AX

			MOV		AX,[Y1]		{ AX = YMin }
			MOV		BX,AX		{ BX = YMax }
			CMP		AX,[Y2]
			JLE		@@OK1
			MOV		AX,[Y2]
@@OK1:
			CMP		AX,[Y3]
			JLE		@@OK2
			MOV		AX,[Y3]
@@OK2:
			CMP		AX,[Y4]
			JLE		@@OK3
			MOV		AX,[Y4]
@@OK3:
			CMP		BX,[Y2]
			JGE		@@OK4
			MOV		BX,[Y2]
@@OK4:
			CMP		BX,[Y3]
			JGE		@@OK5
			MOV		BX,[Y3]
@@OK5:
			CMP		BX,[Y4]
			JGE		@@OK6
			MOV		BX,[Y4]
@@OK6:
			MOV		[YMin],AX
			MOV		[YMax],BX

			DB $66, $0F, $BF, $46, OFFSET X1	{ MOVSX EAX,[X1] }
	DB $66;	SAL		AX,Scaler
	DB $66;	MOV		[WORD PTR XX1],AX
			DB $66, $0F, $BF, $46, OFFSET X2	{ MOVSX EAX,[X2] }
	DB $66;	SAL		AX,Scaler
	DB $66;	MOV		[WORD PTR XX2],AX
			DB $66, $0F, $BF, $46, OFFSET X3	{ MOVSX EAX,[X3] }
	DB $66;	SAL		AX,Scaler
	DB $66;	MOV		[WORD PTR XX3],AX
			DB $66, $0F, $BF, $46, OFFSET X4	{ MOVSX EAX,[X4] }
	DB $66;	SAL		AX,Scaler
	DB $66;	MOV		[WORD PTR XX4],AX

			MOV		AX,[Y1]
			CMP		AX,[Y2]
			JE		@@EQ1
	DB $66;	MOV		AX,[WORD PTR XX2]
	DB $66;	SUB		AX,[WORD PTR XX1]
	DB $66;	CWD
			MOV     BX,[Y2]
			SUB		BX,[Y1]
			DB $66, $0F, $BF, $CB				{ MOVSX ECX,BX }
	DB $66;	IDIV	CX
	DB $66;	MOV		[WORD PTR DX1],AX
			JMP		@@LINEISOK_1
@@EQ1:
	DB $66;	XOR		AX,AX
	DB $66;	MOV		[WORD PTR DX1],AX
@@LINEISOK_1:

			MOV		AX,[Y2]
			CMP		AX,[Y3]
			JE		@@EQ2
	DB $66;	MOV		AX,[WORD PTR XX3]
	DB $66;	SUB		AX,[WORD PTR XX2]
	DB $66;	CWD
			MOV     BX,[Y3]
			SUB		BX,[Y2]
			DB $66, $0F, $BF, $CB				{ MOVSX ECX,BX }
	DB $66;	IDIV	CX
	DB $66;	MOV		[WORD PTR DX2],AX
			JMP		@@LINEISOK_2
@@EQ2:
	DB $66;	XOR		AX,AX
	DB $66;	MOV		[WORD PTR DX2],AX
@@LINEISOK_2:

			MOV		AX,[Y3]
			CMP		AX,[Y4]
			JE		@@EQ3
	DB $66;	MOV		AX,[WORD PTR XX4]
	DB $66;	SUB		AX,[WORD PTR XX3]
	DB $66;	CWD
			MOV     BX,[Y4]
			SUB		BX,[Y3]
			DB $66, $0F, $BF, $CB				{ MOVSX ECX,BX }
	DB $66;	IDIV	CX
	DB $66;	MOV		[WORD PTR DX3],AX
			JMP		@@LINEISOK_3
@@EQ3:
	DB $66;	XOR		AX,AX
	DB $66;	MOV		[WORD PTR DX3],AX
@@LINEISOK_3:

			MOV		AX,[Y1]
			CMP		AX,[Y4]
			JE		@@EQ4
	DB $66;	MOV		AX,[WORD PTR XX4]
	DB $66;	SUB		AX,[WORD PTR XX1]
	DB $66;	CWD
			MOV     BX,[Y4]
			SUB		BX,[Y1]
			DB $66, $0F, $BF, $CB				{ MOVSX ECX,BX }
	DB $66;	IDIV	CX
	DB $66;	MOV		[WORD PTR DX4],AX
			JMP		@@LINEISOK_4
@@EQ4:
	DB $66;	XOR		AX,AX
	DB $66;	MOV		[WORD PTR DX4],AX
@@LINEISOK_4:

			MOV		BX,[Y1]
			CMP		BX,[Y2]
			JLE		@@DIR12
	DB $66;	MOV		AX,[WORD PTR XX2]
	DB $66;	MOV		[WORD PTR CX1],AX
			JMP		@@CHECKDIR2
@@DIR12:
	DB $66;	MOV		AX,[WORD PTR XX1]
	DB $66;	MOV		[WORD PTR CX1],AX

@@CHECKDIR2:
			MOV		BX,[Y2]
			CMP		BX,[Y3]
			JLE		@@DIR23
	DB $66;	MOV		AX,[WORD PTR XX3]
	DB $66;	MOV		[WORD PTR CX2],AX
			JMP		@@CHECKDIR3
@@DIR23:
	DB $66;	MOV		AX,[WORD PTR XX2]
	DB $66;	MOV		[WORD PTR CX2],AX

@@CHECKDIR3:
			MOV		BX,[Y3]
			CMP		BX,[Y4]
			JLE		@@DIR34
	DB $66;	MOV		AX,[WORD PTR XX4]
	DB $66;	MOV		[WORD PTR CX3],AX
			JMP		@@CHECKDIR4
@@DIR34:
	DB $66;	MOV		AX,[WORD PTR XX3]
	DB $66;	MOV		[WORD PTR CX3],AX

@@CHECKDIR4:
			MOV		BX,[Y1]
			CMP		BX,[Y4]
			JLE		@@DIR14
	DB $66;	MOV		AX,[WORD PTR XX4]
	DB $66;	MOV		[WORD PTR CX4],AX
			JMP		@@NODIRSLEFT
@@DIR14:
	DB $66;	MOV		AX,[WORD PTR XX1]
	DB $66;	MOV		[WORD PTR CX4],AX
@@NODIRSLEFT:
			MOV		AX,[Y1]
			MOV		BX,[Y2]
			CMP		AX,BX
			JLE		@@USELINE1
			XCHG	AX,BX
@@USELINE1:
			MOV		[Min1],AX
			MOV		[Max1],BX

			MOV		AX,[Y2]
			MOV		BX,[Y3]
			CMP		AX,BX
			JLE		@@USELINE2
			XCHG	AX,BX
@@USELINE2:
			MOV		[Min2],AX
			MOV		[Max2],BX

			MOV		AX,[Y3]
			MOV		BX,[Y4]
			CMP		AX,BX
			JLE		@@USELINE3
			XCHG	AX,BX
@@USELINE3:
			MOV		[Min3],AX
			MOV		[Max3],BX

			MOV		AX,[Y1]
			MOV		BX,[Y4]
			CMP		AX,BX
			JLE		@@USELINE4
			XCHG	AX,BX
@@USELINE4:
			MOV		[Min4],AX
			MOV		[Max4],BX

			MOV		AX,[YMin]
			MOV		[Y],AX
			CMP		AX,[ClipY1]
			JGE		@@MOVEIT
			MOV		AX,[ClipY1]
@@MOVEIT:
			MOV		DI,AX
			SHL		DI,6
			SHL		AX,8
			ADD		DI,AX
			MOV		ES,[VideoSeg]
@@LINELOOP:
			MOV		AX,[Y]
			CMP		AX,[YMax]
			JG		@@EXIT
			CMP		AX,[ClipY1]
			JL		@@NEXTLINE
			CMP		AX,[ClipY2]
			JG		@@EXIT

	DB $66;	MOV		AX,$FFFF; DW $7FFF	{ MAX }
	DB $66;	MOV		BX,$0000; DW $8000	{ MIN }
			MOV		CX,[Y]

			CMP		CX,[Min1]
			JL		@@CHECK2
			CMP		CX,[Max1]
			JG		@@CHECK2
	DB $66;	CMP		AX,[WORD PTR CX1]
			JLE		@@CHECK1_2
	DB $66;	MOV		AX,[WORD PTR CX1]
@@CHECK1_2:
	DB $66;	CMP		BX,[WORD PTR CX1]
			JGE		@@CHECK2
	DB $66;	MOV		BX,[WORD PTR CX1]

@@CHECK2:
			CMP		CX,[Min2]
			JL		@@CHECK3
			CMP		CX,[Max2]
			JG		@@CHECK3
	DB $66;	CMP		AX,[WORD PTR CX2]
			JLE		@@CHECK2_2
	DB $66;	MOV		AX,[WORD PTR CX2]
@@CHECK2_2:
	DB $66;	CMP		BX,[WORD PTR CX2]
			JGE		@@CHECK3
	DB $66;	MOV		BX,[WORD PTR CX2]

@@CHECK3:
			CMP		CX,[Min3]
			JL		@@CHECK4
			CMP		CX,[Max3]
			JG		@@CHECK4
	DB $66;	CMP		AX,[WORD PTR CX3]
			JLE		@@CHECK3_2
	DB $66;	MOV		AX,[WORD PTR CX3]
@@CHECK3_2:
	DB $66;	CMP		BX,[WORD PTR CX3]
			JGE		@@CHECK4
	DB $66;	MOV		BX,[WORD PTR CX3]

@@CHECK4:
			CMP		CX,[Min4]
			JL		@@CHECK5
			CMP		CX,[Max4]
			JG		@@CHECK5
	DB $66;	CMP		AX,[WORD PTR CX4]
			JLE		@@CHECK4_2
	DB $66;	MOV		AX,[WORD PTR CX4]
@@CHECK4_2:
	DB $66;	CMP		BX,[WORD PTR CX4]
			JGE		@@CHECK5
	DB $66;	MOV		BX,[WORD PTR CX4]
@@CHECK5:

	DB $66;	PUSH	CX
	DB $66;	XOR		CX,CX
	DB $66;	SAR		AX,Scaler
	DB $66;	ADC		AX,CX
	DB $66;	SAR		BX,Scaler
	DB $66;	ADC		BX,CX
	DB $66;	POP		CX

			CMP		AX,[ClipX2]
			JG		@@NEXTLINE
			CMP		BX,[ClipX1]
			JL		@@NEXTLINE

			CMP		BX,[ClipX2]
			JLE		@@MAXISOK
			MOV		BX,[ClipX2]
@@MAXISOK:
			CMP		AX,[ClipX1]
			JGE		@@MINISOK
			MOV		AX,[ClipX1]
@@MINISOK:
			MOV		SI,DI

			MOV		CX,BX
			SUB		CX,AX
			INC		CX

			ADD		DI,AX
	DB $66;	MOV		AX,[WORD PTR CDWord]
			JCXZ	@@SKIP2
			TEST	DI,$0001
			JZ		@@NOTONE
			AND		[BYTE PTR ES:DI],AL
			INC		DI
			DEC		CX
			JZ		@@SKIP2
@@NOTONE:
			CMP		CX,2
			JB		@@NOTTWO
			TEST	DI,$0002
			JZ		@@NOTTWO
			AND		[WORD PTR ES:DI],AX
			ADD		DI,2
			SUB		CX,2
			JZ		@@SKIP2
@@NOTTWO:
			SHR		CX,1
			DB $0F, $92, $C3
			SHR		CX,1
			DB $0F, $92, $C7
			JCXZ	@@SKIP0
@@STOSLOOP:
	DB $66;	AND		[WORD PTR ES:DI],AX
			ADD		DI,4
			DEC		CX
			JNZ		@@STOSLOOP
@@SKIP0:
			OR		BH,BH
			JZ		@@SKIP1
			AND		[WORD PTR ES:DI],AX
			ADD		DI,2
@@SKIP1:
			OR		BL,BL
			JZ		@@SKIP2
			AND		[BYTE PTR ES:DI],AL
			INC		DI
@@SKIP2:
			MOV		DI,SI
@@NEXTLINE:
			MOV		AX,[Y]
			CMP		AX,[Min1]
			JL		@@ADJ2
			CMP		AX,[Max1]
			JG		@@ADJ2
	DB $66;	MOV		BX,[WORD PTR DX1]
	DB $66;	ADD		[WORD PTR CX1],BX
@@ADJ2:
			CMP		AX,[Min2]
			JL		@@ADJ3
			CMP		AX,[Max2]
			JG		@@ADJ3
	DB $66;	MOV		BX,[WORD PTR DX2]
	DB $66;	ADD		[WORD PTR CX2],BX
@@ADJ3:
			CMP		AX,[Min3]
			JL		@@ADJ4
			CMP		AX,[Max3]
			JG		@@ADJ4
	DB $66;	MOV		BX,[WORD PTR DX3]
	DB $66;	ADD		[WORD PTR CX3],BX
@@ADJ4:
			CMP		AX,[Min4]
			JL		@@ADJ5
			CMP		AX,[Max4]
			JG		@@ADJ5
	DB $66;	MOV		BX,[WORD PTR DX4]
	DB $66;	ADD		[WORD PTR CX4],BX
@@ADJ5:
			MOV		AX,[Y]
			CMP		AX,[ClipY1]
			JL		@@ONLY_Y
			ADD		DI,320
@@ONLY_Y:
			INC		[Y]
			JMP		@@LINELOOP
@@EXIT:
End;


Function Visible(X1,Y1,X2,Y2,X3,Y3 : Integer) : Integer; Assembler;
Asm
	MOV		AX,[Y2]
	SUB		AX,[Y1]
	MOV		BX,[X3]
	SUB		BX,[X1]
	IMUL	BX
	MOV		CX,AX
	MOV		AX,[Y3]
	SUB		AX,[Y1]
	MOV		BX,[X2]
	SUB		BX,[X1]
	IMUL	BX
	SUB		CX,AX
	MOV		AX,CX
	NEG		AX
End;

Procedure Normal(X1,Y1,Z1,X2,Y2,Z2,X3,Y3,Z3 : Integer; Var X,Y,Z : Integer); Assembler;
Asm
	MOV		AX,[Y2]
	SUB		AX,[Y1]
	MOV		BX,[Z3]
	SUB		BX,[Z1]
	IMUL	BX
	MOV		CX,AX
	MOV		AX,[Y3]
	SUB		AX,[Y1]
	MOV		BX,[Z2]
	SUB		BX,[Z1]
	IMUL	BX
	SUB		CX,AX
	NEG		CX
	LES		DI,[DWORD PTR X]
	MOV		[ES:DI],CX

	MOV		AX,[X2]
	SUB		AX,[X1]
	MOV		BX,[Z3]
	SUB		BX,[Z1]
	IMUL	BX
	MOV		CX,AX
	MOV		AX,[X3]
	SUB		AX,[X1]
	MOV		BX,[Z2]
	SUB		BX,[Z1]
	IMUL	BX
	SUB		CX,AX
	LES		DI,[DWORD PTR Y]
	MOV		[ES:DI],CX

	MOV		AX,[Y2]
	SUB		AX,[Y1]
	MOV		BX,[X3]
	SUB		BX,[X1]
	IMUL	BX
	MOV		CX,AX
	MOV		AX,[Y3]
	SUB		AX,[Y1]
	MOV		BX,[X2]
	SUB		BX,[X1]
	IMUL	BX
	SUB		CX,AX
	NEG		CX
	LES		DI,[DWORD PTR Z]
	MOV		[ES:DI],CX
End;

Procedure MovePoints32(Var Points : Array Of TPoint32; PointCount : Word; _DX,_DY,_DZ : LongInt); Assembler;
Asm
			LES		DI,[DWORD PTR Points]
			MOV		CX,[PointCount]
	DB $66;	MOV		AX,[WORD PTR _DX]
	DB $66;	MOV		BX,[WORD PTR _DY]
	DB $66;	MOV		DX,[WORD PTR _DZ]
@@POINTLOOP:
	DB $66;	ADD		[ES:DI],AX
	DB $66;	ADD		[ES:DI+4],BX
	DB $66;	ADD		[ES:DI+8],DX
			ADD		DI,12
			DEC		CX
			JNZ		@@POINTLOOP
End;

Procedure AddPerspective32(Var Points : Array Of TPoint32; PointCount : Word;
	ShiftFactor : Byte; ZDelta : LongInt); Assembler;
Asm
			LES		DI,[DWORD PTR Points]
			MOV		BX,[PointCount]
			MOV		CL,[ShiftFactor]
@@POINTLOOP:
			PUSH	BX

	DB $66;	MOV		BX,[ES:DI+8]
	DB $66;	ADD		BX,[WORD PTR ZDelta]{ BX := Z+ZDelta }
	DB $66;	TEST	BX,BX
			JZ		@@NEXTPOINT

	DB $66;	MOV		AX,[ES:DI]			{ AX := X }
	DB $66;	SAL		AX,CL				{ AX := X SHL ShiftFactor }
	DB $66;	MOV		DX,AX
	DB $66;	SAR		DX,31
	DB $66;	IDIV	BX					{ AX := (X SHL ShiftFactor) DIV (Z+ZDelta) }
	DB $66;	MOV		[ES:DI],AX			{ X := AX }

	DB $66;	MOV		AX,[ES:DI+4]
	DB $66;	SAL		AX,CL
	DB $66;	MOV		DX,AX
	DB $66;	SAR		DX,31
	DB $66;	IDIV	BX
	DB $66;	MOV		[ES:DI+4],AX

@@NEXTPOINT:
			ADD		DI,12
			POP		BX
			DEC		BX
			JNZ		@@POINTLOOP
End;

Procedure InitSinCos(BitSize : Byte);
Var
	I		: Word;
	Period	: Real;
Begin
	If BitSize<1 Then
		BitSize:=1
	Else If BitSize>14 Then
		BitSize:=14;
	TableMask:=(1 SHL BitSize)-1;
	GetMem(_S,(TableMask+1)*2);
	GetMem(_C,(TableMask+1)*2);
	If (_S=NIL) Or (_C=NIL) Then
		RunError(203);
	Period:=(TableMask+1)/2;
	For I:=0 To TableMask Do Begin
		_S^[I]:=Round(256*Sin(I*Pi/Period));
		_C^[I]:=Round(256*Cos(I*Pi/Period));
	End;
End;

Procedure VRet; Assembler;
Asm
	MOV		DX,$3DA
@@1:
	IN		AL,DX
	TEST	AL,$08
	JNZ		@@1
@@2:
	IN		AL,DX
	TEST	AL,$08
	JZ		@@2
End;

Procedure TestCPULine; Assembler;
Asm
	MOV		DX,$03DA
@WAIT1:
	IN		AL,DX
	TEST	AL,$01
	JNZ		@WAIT1
@WAIT2:
	IN		AL,DX
	TEST	AL,$01
	JZ		@WAIT2
	MOV		DX,$3C8
	MOV		AL,$00
	OUT		DX,AL
	INC		DX
	MOV		AL,$20
	OUT		DX,AL
	OUT		DX,AL
	OUT		DX,AL
	MOV		DX,$03DA
@WAIT3:
	IN		AL,DX
	TEST	AL,$01
	JNZ		@WAIT3
@WAIT4:
	IN		AL,DX
	TEST	AL,$01
	JZ		@WAIT4
	MOV		DX,$3C8
	MOV		AL,$00
	OUT		DX,AL
	INC		DX
	OUT		DX,AL
	OUT		DX,AL
	OUT		DX,AL
	MOV		DX,$3DA
@@1:
	IN		AL,DX
	TEST	AL,$08
	JNZ		@@1
@@2:
	IN		AL,DX
	TEST	AL,$08
	JZ		@@2
End;

Procedure TestCPU; Assembler;
Asm
	MOV		DX,$3C8
	MOV		AL,$00
	OUT		DX,AL
	INC		DX
	MOV		AL,$20
	OUT		DX,AL
	OUT		DX,AL
	OUT		DX,AL
	MOV		DX,$3DA
@@1:
	IN		AL,DX
	TEST	AL,$08
	JNZ		@@1
@@2:
	IN		AL,DX
	TEST	AL,$08
	JZ		@@2
	MOV		DX,$3C8
	MOV		AL,$00
	OUT		DX,AL
	INC		DX
	OUT		DX,AL
	OUT		DX,AL
	OUT		DX,AL
End;

Procedure ClearFake(FakeSeg : Word); Assembler;
Asm
	DB $66;	XOR		AX,AX
			MOV		CX,16000
			MOV		ES,[FakeSeg]
			XOR		DI,DI
			CLD
	DB $66;	REP		STOSW
End;

Procedure ClearFake2Color(FakeSeg : Word; Color : Byte); Assembler;
Asm
			MOV		AL,[Color]
			MOV		AH,[Color]
			PUSH	AX
	DB $66;	SHL		AX,16
			POP		AX
			MOV		CX,16000
			MOV		ES,[FakeSeg]
			XOR		DI,DI
			CLD
	DB $66;	REP		STOSW
End;

Procedure ShowFake(FakeSeg : Word); Assembler;
Asm
			PUSH	[SegA000]
			POP		ES
			PUSH	DS
			MOV		DS,[FakeSeg]
			XOR		SI,SI
			XOR		DI,DI
			MOV		CX,16000
			CLD
	DB $66;	REP		MOVSW
			POP		DS
End;

Procedure ShowFakePart(FakeSeg : Word; X1,Y1,X2,Y2 : Word); Assembler;
Asm
			PUSH	[SegA000]
			POP		ES
			PUSH	DS
			MOV		DS,[FakeSeg]
			MOV		CX,[X2]
			SUB		CX,[X1]
			INC		CX
			MOV		AX,[Y1]
			MOV		DI,AX
			SHL		DI,6
			SHL		AX,8
			ADD		DI,AX
			ADD		DI,[X1]
			MOV		SI,DI
			MOV		DX,320
			SUB		DX,CX
			CLD
			MOV		AX,Y2
			SUB		AX,Y1
			INC		AX
@@LOOP1:
			PUSH	CX
			SHR		CX,1
			DB $0F, $92, $C3
			SHR		CX,1
	DB $66;	REP		MOVSW
			JNC		@@SKIP1
			MOVSW
@@SKIP1:
			OR		BL,BL
			JZ		@@SKIP2
			MOVSB
@@SKIP2:
			ADD		SI,DX
			ADD		DI,DX
			POP		CX
			DEC		AX
			JNZ		@@LOOP1
			POP		DS
End;

Procedure ClearFakePart(FakeSeg : Word; X1,Y1,X2,Y2 : Word); Assembler;
Asm
			MOV		ES,[FakeSeg]
			MOV		CX,[X2]
			SUB		CX,[X1]
			INC		CX
			MOV		AX,[Y1]
			MOV		DI,AX
			SHL		DI,6
			SHL		AX,8
			ADD		DI,AX
			ADD		DI,[X1]
			MOV		DX,320
			SUB		DX,CX
			CLD
			MOV		AX,Y2
			SUB		AX,Y1
			INC		AX
			MOV		[Y2],AX
	DB $66;	XOR		AX,AX
@@LOOP1:
			PUSH	CX
			SHR		CX,1
			DB $0F, $92, $C3
			SHR		CX,1
	DB $66;	REP		STOSW
			JNC		@@SKIP1
			STOSW
@@SKIP1:
			OR		BL,BL
			JZ		@@SKIP2
			STOSB
@@SKIP2:
			ADD		SI,DX
			ADD		DI,DX
			POP		CX
			DEC		[Y2]
			JNZ		@@LOOP1
End;

Procedure ClearFakePart2Color(FakeSeg : Word; X1,Y1,X2,Y2 : Word; Color : Byte); Assembler;
Asm
			MOV		ES,[FakeSeg]
			MOV		CX,[X2]
			SUB		CX,[X1]
			INC		CX
			MOV		AX,[Y1]
			MOV		DI,AX
			SHL		DI,6
			SHL		AX,8
			ADD		DI,AX
			ADD		DI,[X1]
			MOV		DX,320
			SUB		DX,CX
			CLD
			MOV		AX,Y2
			SUB		AX,Y1
			INC		AX
			MOV		[Y2],AX
			MOV		AL,[Color]
			MOV		AH,[Color]
			PUSH	AX
	DB $66;	SHL		AX,16
			POP		AX
@@LOOP1:
			PUSH	CX
			SHR		CX,1
			DB $0F, $92, $C3
			SHR		CX,1
	DB $66;	REP		STOSW
			JNC		@@SKIP1
			STOSW
@@SKIP1:
			OR		BL,BL
			JZ		@@SKIP2
			STOSB
@@SKIP2:
			ADD		SI,DX
			ADD		DI,DX
			POP		CX
			DEC		[Y2]
			JNZ		@@LOOP1
End;

Procedure QSort32(Var SortList : Array Of TSortRec32; SortCount : Word);

	Procedure QSortLocal(I1,I2 : Integer);
	Var
		J1,J2	: Integer;
		P		: Pointer;
	Begin
		If I1=I2 Then
			Exit;
		P:=@SortList;
		Asm
					LES		DI,[DWORD PTR P]
					MOV		BX,[I1]
					MOV		CX,BX
					SHL		BX,2
					SHL		CX,1
					ADD		BX,CX
			DB $66;	MOV		DX,[ES:DI+BX+2]

					MOV		AX,[I1]
					MOV		[J1],AX
					MOV		AX,[I2]
					MOV		[J2],AX

		@@LOOP1:
					MOV		AX,[J1]
		@@MORE_1:
					CMP		AX,[I2]
					JG		@@EXIT_1
					MOV		BX,AX
					MOV		CX,BX
					SHL		BX,2
					SHL		CX,1
					ADD		BX,CX
			DB $66;	CMP		[ES:DI+BX+2],DX
					JLE		@@EXIT_1
					INC		AX
					JMP		@@MORE_1
		@@EXIT_1:
					MOV		[J1],AX

					MOV		AX,[J2]
		@@MORE_2:
					CMP		AX,[I1]
					JL		@@EXIT_2
					MOV		BX,AX
					MOV		CX,BX
					SHL		BX,2
					SHL		CX,1
					ADD		BX,CX
			DB $66;	CMP		[ES:DI+BX+2],DX
					JGE		@@EXIT_2
					DEC		AX
					JMP		@@MORE_2
		@@EXIT_2:
					MOV		[J2],AX

					MOV		AX,[J1]
					MOV		BX,[J2]
					CMP		AX,BX
					JG		@@EXIT_3
					MOV		SI,DI
					MOV		CX,AX
					SHL		AX,2
					SHL		CX,1
					ADD		SI,CX
					ADD		SI,AX
					MOV		CX,BX
					SHL		BX,2
					SHL		CX,1
					ADD		BX,CX
					MOV		AX,[ES:SI]
					XCHG	AX,[ES:DI+BX]
					MOV		[ES:SI],AX
			DB $66;	MOV		AX,[ES:SI+2]
			DB $66;	XCHG	AX,[ES:DI+BX+2]
			DB $66;	MOV		[ES:SI+2],AX
					INC		[J1]
					DEC		[J2]
		@@EXIT_3:
					MOV		AX,[J1]
					CMP		AX,[J2]
					JLE		@@LOOP1
		End;
		If J1<I2 Then
			QSortLocal(J1,I2);
		If J2>I1 Then
			QSortLocal(I1,J2);
	End;

Begin
	QSortLocal(0,SortCount-1);
End;

Function NormalR(X1,Y1,Z1,X2,Y2,Z2,X3,Y3,Z3 : Integer; Var X,Y,Z : Integer) : Real;
Var
	L	: Real;
Begin
	Normal(X1,Y1,Z1,X2,Y2,Z2,X3,Y3,Z3,X,Y,Z);
	L:=Sqrt((X+0.0)*(X+0.0)+(Y+0.0)*(Y+0.0)+(Z+0.0)*(Z+0.0));
	If L=0 Then
		NormalR:=0
	Else
		NormalR:=Z/L;
End;

Procedure XPlot(X,Y : Integer; Color : Byte; VideoSeg : Word); Assembler;
Asm
	MOV		AX,[Y]
	CMP		AX,0
	JL		@@EXIT
	CMP		AX,199
	JG		@@EXIT
	MOV		BX,[X]
	CMP		BX,0
	JL		@@EXIT
	CMP		BX,319
	JG		@@EXIT
	MOV		DI,AX
	SHL		AX,6
	SHL		DI,8
	ADD		DI,AX
	ADD		DI,BX
	MOV		AL,[Color]
	MOV		ES,[VideoSeg]
	MOV		[ES:DI],AL
@@EXIT:
End;

Function XGetPixel(X,Y : Integer; VideoSeg : Word) : Byte; Assembler;
Asm
	MOV		AX,[Y]
	CMP		AX,0
	JL		@@EXIT
	CMP		AX,199
	JG		@@EXIT
	MOV		BX,[X]
	CMP		BX,0
	JL		@@EXIT
	CMP		BX,319
	JG		@@EXIT
	MOV		DI,AX
	SHL		AX,6
	SHL		DI,8
	ADD		DI,AX
	ADD		DI,BX
	MOV		ES,[VideoSeg]
	MOV		AL,[ES:DI]
@@EXIT:
End;

Procedure XPlotXOR(X,Y : Integer; Color : Byte; VideoSeg : Word); Assembler;
Asm
	MOV		AX,[Y]
	CMP		AX,0
	JL		@@EXIT
	CMP		AX,199
	JG		@@EXIT
	MOV		BX,[X]
	CMP		BX,0
	JL		@@EXIT
	CMP		BX,319
	JG		@@EXIT
	MOV		DI,AX
	SHL		AX,6
	SHL		DI,8
	ADD		DI,AX
	ADD		DI,BX
	MOV		AL,[Color]
	MOV		ES,[VideoSeg]
	XOR		[ES:DI],AL
@@EXIT:
End;

Procedure XPlotClip(X,Y,ClipX1,ClipY1,ClipX2,ClipY2 : Integer; Color : Byte; VideoSeg : Word); Assembler;
Asm
	MOV		AX,[Y]
	CMP		AX,[ClipY1]
	JL		@@EXIT
	CMP		AX,[ClipY2]
	JG		@@EXIT
	MOV		BX,[X]
	CMP		BX,[ClipX1]
	JL		@@EXIT
	CMP		BX,[ClipX2]
	JG		@@EXIT
	MOV		DI,AX
	SHL		AX,6
	SHL		DI,8
	ADD		DI,AX
	ADD		DI,BX
	MOV		AL,[Color]
	MOV		ES,[VideoSeg]
	MOV		[ES:DI],AL
@@EXIT:
End;

Function XGetPixelClip(X,Y,ClipX1,ClipY1,ClipX2,ClipY2 : Integer; VideoSeg : Word) : Byte; Assembler;
Asm
	MOV		AX,[Y]
	CMP		AX,[ClipY1]
	JL		@@OUTSIDE
	CMP		AX,[ClipY2]
	JG		@@OUTSIDE
	MOV		BX,[X]
	CMP		BX,[ClipX1]
	JL		@@OUTSIDE
	CMP		BX,[ClipX2]
	JG		@@OUTSIDE
	MOV		DI,AX
	SHL		AX,6
	SHL		DI,8
	ADD		DI,AX
	ADD		DI,BX
	MOV		ES,[VideoSeg]
	MOV		AL,[ES:DI]
	JMP		@@EXIT
@@OUTSIDE:
	XOR		AL,AL
@@EXIT:
End;

Procedure XPlotXORClip(X,Y,ClipX1,ClipY1,ClipX2,ClipY2 : Integer; Color : Byte; VideoSeg : Word); Assembler;
Asm
	MOV		AX,[Y]
	CMP		AX,[ClipY1]
	JL		@@EXIT
	CMP		AX,[ClipY2]
	JG		@@EXIT
	MOV		BX,[X]
	CMP		BX,[ClipX1]
	JL		@@EXIT
	CMP		BX,[ClipX2]
	JG		@@EXIT
	MOV		DI,AX
	SHL		AX,6
	SHL		DI,8
	ADD		DI,AX
	ADD		DI,BX
	MOV		AL,[Color]
	MOV		ES,[VideoSeg]
	XOR		[ES:DI],AL
@@EXIT:
End;

Procedure XTetraTexture320(X1,Y1,X2,Y2,X3,Y3,TX1,TY1,TX2,TY2,TX3,TY3 : Integer;
	Texture : PChar; VideoSeg : Word); Assembler;
Var
	X,Y				: Integer;
	XX1,XX2,XX3		: LongInt;
	DX1,DX2,DX3		: LongInt;
	TXX1,TXX2,TXX3	: LongInt;
	TYY1,TYY2,TYY3	: LongInt;
	TDX1,TDX2,TDX3	: LongInt;
	TDY1,TDY2,TDY3	: LongInt;
	CX1,CX2			: LongInt;
	MX1,MX2			: LongInt;
	TCX1,TCY1		: LongInt;
	TCX2,TCY2		: LongInt;
	MTX1,MTY1		: LongInt;
	MTX2,MTY2		: LongInt;
	MDX1,MDY1		: LongInt;
	TEMPDI          : Word;
	TEMPDS          : Word;
Asm
			CLD
			MOV     [TEMPDS],DS
			LDS		SI,[DWORD PTR Texture]
			MOV		ES,[VideoSeg]

			MOV		AX,[Y1]
			CMP		AX,[Y2]
			JLE		@@OK1
			XCHG	AX,[Y2]
			MOV		[Y1],AX					{ SWAPPED Y1:Y2 }
			MOV		AX,[X1]
			XCHG	AX,[X2]
			MOV		[X1],AX					{ SWAPPED X1:X2 }
			MOV		AX,[TX1]
			XCHG	AX,[TX2]
			MOV		[TX1],AX				{ SWAPPED TX1:TX2 }
			MOV		AX,[TY1]
			XCHG	AX,[TY2]
			MOV		[TY1],AX				{ SWAPPED TY1:TY2 }
@@OK1:

			MOV		AX,[Y1]
			CMP		AX,[Y3]
			JLE		@@OK2
			XCHG	AX,[Y3]
			MOV		[Y1],AX					{ SWAPPED Y1:Y3 }
			MOV		AX,[X1]
			XCHG	AX,[X3]
			MOV		[X1],AX					{ SWAPPED X1:X3 }
			MOV		AX,[TX1]
			XCHG	AX,[TX3]
			MOV		[TX1],AX				{ SWAPPED TX1:TX3 }
			MOV		AX,[TY1]
			XCHG	AX,[TY3]
			MOV		[TY1],AX				{ SWAPPED TY1:TY3 }
@@OK2:

			MOV		AX,[Y2]
			CMP		AX,[Y3]
			JLE		@@OK3
			XCHG	AX,[Y3]
			MOV		[Y2],AX					{ SWAPPED Y2:Y3 }
			MOV		AX,[X2]
			XCHG	AX,[X3]
			MOV		[X2],AX					{ SWAPPED X2:X3 }
			MOV		AX,[TX2]
			XCHG	AX,[TX3]
			MOV		[TX2],AX				{ SWAPPED TX2:TX3 }
			MOV		AX,[TY2]
			XCHG	AX,[TY3]
			MOV		[TY2],AX				{ SWAPPED TY2:TY3 }
@@OK3:
			CMP		[Y1],199
			JG		@@EXIT
			CMP		[Y3],0
			JL		@@EXIT
			CMP		[X1],0
			JGE		@@OK22
			CMP		[X2],0
			JGE		@@OK22
			CMP		[X3],0
			JGE		@@OK22
			JMP		@@EXIT
@@OK22:
			CMP		[X1],319
			JLE		@@OK23
			CMP		[X2],319
			JLE		@@OK23
			CMP		[X3],319
			JLE		@@OK23
			JMP		@@EXIT
@@OK23:

	DB $66;	DB $0F, $BF, $46, OFFSET X1		{ MOVSX EAX,[X1] }
	DB $66;	SHL		AX,Scaler
	DB $66;	MOV		[WORD PTR XX1],AX
	DB $66;	DB $0F, $BF, $46, OFFSET X2		{ MOVSX EAX,[X2] }
	DB $66;	SHL		AX,Scaler
	DB $66;	MOV		[WORD PTR XX2],AX
	DB $66;	DB $0F, $BF, $46, OFFSET X3		{ MOVSX EAX,[X3] }
	DB $66;	SHL		AX,Scaler
	DB $66;	MOV		[WORD PTR XX3],AX

	DB $66;	DB $0F, $BF, $46, OFFSET TX1	{ MOVSX EAX,[TX1] }
	DB $66;	SHL		AX,Scaler
	DB $66;	MOV		[WORD PTR TXX1],AX
	DB $66;	DB $0F, $BF, $46, OFFSET TX2	{ MOVSX EAX,[TX2] }
	DB $66;	SHL		AX,Scaler
	DB $66;	MOV		[WORD PTR TXX2],AX
	DB $66;	DB $0F, $BF, $46, OFFSET TX3	{ MOVSX EAX,[TX3]			}
	DB $66;	SHL		AX,Scaler
	DB $66;	MOV		[WORD PTR TXX3],AX

	DB $66;	DB $0F, $BF, $46, OFFSET TY1	{ MOVSX EAX,[TY1]			}
	DB $66;	SHL		AX,Scaler
	DB $66;	MOV		[WORD PTR TYY1],AX
	DB $66;	DB $0F, $BF, $46, OFFSET TY2	{ MOVSX EAX,[TY2]			}
	DB $66;	SHL		AX,Scaler
	DB $66;	MOV		[WORD PTR TYY2],AX
	DB $66;	DB $0F, $BF, $46, OFFSET TY3	{ MOVSX EAX,[TY3]			}
	DB $66;	SHL		AX,Scaler
	DB $66;	MOV		[WORD PTR TYY3],AX

			MOV		AX,[Y1]
			CMP		AX,[Y2]
			JNE		@@NONFLAT1
	DB $66;	XOR		AX,AX
	DB $66;	MOV		[WORD PTR DX1],AX
	DB $66;	MOV		[WORD PTR TDX1],AX
	DB $66;	MOV		[WORD PTR TDY1],AX
			JMP		@@OK7
@@NONFLAT1:
	DB $66;	DB $0F, $BF, $5E, OFFSET Y2		{ MOVSX EBX,[Y2]			}
	DB $66;	DB $0F, $BF, $4E, OFFSET Y1		{ MOVSX ECX,[Y1]			}
	DB $66;	SUB		BX,CX					{ SUB EBX,ECX				}

	DB $66;	MOV		AX,[WORD PTR XX2]
	DB $66;	SUB		AX,[WORD PTR XX1]
	DB $66;	CWD
	DB $66;	IDIV	BX
	DB $66;	MOV		[WORD PTR DX1],AX

	DB $66;	MOV		AX,[WORD PTR TXX2]
	DB $66;	SUB		AX,[WORD PTR TXX1]
	DB $66;	CWD
	DB $66;	IDIV	BX
	DB $66;	MOV		[WORD PTR TDX1],AX

	DB $66;	MOV		AX,[WORD PTR TYY2]
	DB $66;	SUB		AX,[WORD PTR TYY1]
	DB $66;	CWD
	DB $66;	IDIV	BX
	DB $66;	MOV		[WORD PTR TDY1],AX

@@OK7:
			MOV		AX,[Y2]
			CMP		AX,[Y3]
			JNE		@@NONFLAT2
	DB $66;	XOR		AX,AX
	DB $66;	MOV		[WORD PTR DX2],AX
	DB $66;	MOV		[WORD PTR TDX2],AX
	DB $66;	MOV		[WORD PTR TDY2],AX
			JMP		@@OK11
@@NONFLAT2:
	DB $66;	DB $0F, $BF, $5E, OFFSET Y3		{ MOVSX EBX,[Y3]			}
	DB $66;	DB $0F, $BF, $4E, OFFSET Y2		{ MOVSX ECX,[Y2]			}
	DB $66;	SUB		BX,CX					{ SUB EBX,ECX				}

	DB $66;	MOV		AX,[WORD PTR XX3]
	DB $66;	SUB		AX,[WORD PTR XX2]
	DB $66;	CWD
	DB $66;	IDIV	BX
	DB $66;	MOV		[WORD PTR DX2],AX

	DB $66;	MOV		AX,[WORD PTR TXX3]
	DB $66;	SUB		AX,[WORD PTR TXX2]
	DB $66;	CWD
	DB $66;	IDIV	BX
	DB $66;	MOV		[WORD PTR TDX2],AX

	DB $66;	MOV		AX,[WORD PTR TYY3]
	DB $66;	SUB		AX,[WORD PTR TYY2]
	DB $66;	CWD
	DB $66;	IDIV	BX
	DB $66;	MOV		[WORD PTR TDY2],AX

@@OK11:

			MOV		AX,[Y1]
			CMP		AX,[Y3]
			JNE		@@NONFLAT3
	DB $66;	XOR		AX,AX
	DB $66;	MOV		[WORD PTR DX3],AX
	DB $66;	MOV		[WORD PTR TDX3],AX
	DB $66;	MOV		[WORD PTR TDY3],AX
			JMP		@@OK15
@@NONFLAT3:
	DB $66;	DB $0F, $BF, $5E, OFFSET Y3		{ MOVSX EBX,[Y3]			}
	DB $66;	DB $0F, $BF, $4E, OFFSET Y1		{ MOVSX ECX,[Y2]			}
	DB $66;	SUB		BX,CX					{ SUB EBX,ECX				}

	DB $66;	MOV		AX,[WORD PTR XX3]
	DB $66;	SUB		AX,[WORD PTR XX1]
	DB $66;	CWD
	DB $66;	IDIV	BX
	DB $66;	MOV		[WORD PTR DX3],AX

	DB $66;	MOV		AX,[WORD PTR TXX3]
	DB $66;	SUB		AX,[WORD PTR TXX1]
	DB $66;	CWD
	DB $66;	IDIV	BX
	DB $66;	MOV		[WORD PTR TDX3],AX

	DB $66;	MOV		AX,[WORD PTR TYY3]
	DB $66;	SUB		AX,[WORD PTR TYY1]
	DB $66;	CWD
	DB $66;	IDIV	BX
	DB $66;	MOV		[WORD PTR TDY3],AX

@@OK15:

	DB $66;	MOV		AX,[WORD PTR XX1]
	DB $66;	MOV		[WORD PTR CX1],AX
	DB $66;	MOV		AX,[WORD PTR TXX1]
	DB $66;	MOV		[WORD PTR TCX1],AX
	DB $66;	MOV		AX,[WORD PTR TYY1]
	DB $66;	MOV		[WORD PTR TCY1],AX

			MOV		AX,[Y1]
			CMP		AX,[Y2]
			JNE		@@NONFLAT4
	DB $66;	MOV		AX,[WORD PTR XX2]
	DB $66;	MOV		[WORD PTR CX2],AX
	DB $66;	MOV		AX,[WORD PTR TXX2]
	DB $66;	MOV		[WORD PTR TCX2],AX
	DB $66;	MOV		AX,[WORD PTR TYY2]
	DB $66;	MOV		[WORD PTR TCY2],AX
			JMP		@@OK16
@@NONFLAT4:
	DB $66;	MOV		AX,[WORD PTR XX1]
	DB $66;	MOV		[WORD PTR CX2],AX
	DB $66;	MOV		AX,[WORD PTR TXX1]
	DB $66;	MOV		[WORD PTR TCX2],AX
	DB $66;	MOV		AX,[WORD PTR TYY1]
	DB $66;	MOV		[WORD PTR TCY2],AX
@@OK16:
			MOV		AX,[Y1]
			MOV		[Y],AX
			MOV		AX,[Y]
			TEST	AX,AX
			JGE		@@MOVEDOWN
			XOR		AX,AX
@@MOVEDOWN:
			MOV		DI,AX
			SHL		DI,6
			SHL		AX,8
			ADD		DI,AX
@@LINELOOP:
			MOV		AX,[Y]
			CMP		AX,0
			JL		@@NEXTLINE
			CMP		AX,199
			JG		@@EXIT

	DB $66;	MOV		AX,[WORD PTR CX1]
	DB $66;	CMP		AX,[WORD PTR CX2]
			JGE		@@MUSTSWAP
	DB $66;	MOV		[WORD PTR MX1],AX
	DB $66;	MOV		AX,[WORD PTR CX2]
	DB $66;	MOV		[WORD PTR MX2],AX
	DB $66;	MOV		AX,[WORD PTR TCX1]
	DB $66;	MOV		[WORD PTR MTX1],AX
	DB $66;	MOV		AX,[WORD PTR TCY1]
	DB $66;	MOV		[WORD PTR MTY1],AX
	DB $66;	MOV		AX,[WORD PTR TCX2]
	DB $66;	MOV		[WORD PTR MTX2],AX
	DB $66;	MOV		AX,[WORD PTR TCY2]
	DB $66;	MOV		[WORD PTR MTY2],AX
			JMP		@@OK17
@@MUSTSWAP:
	DB $66;	MOV		[WORD PTR MX2],AX
	DB $66;	MOV		AX,[WORD PTR CX2]
	DB $66;	MOV		[WORD PTR MX1],AX
	DB $66;	MOV		AX,[WORD PTR TCX1]
	DB $66;	MOV		[WORD PTR MTX2],AX
	DB $66;	MOV		AX,[WORD PTR TCY1]
	DB $66;	MOV		[WORD PTR MTY2],AX
	DB $66;	MOV		AX,[WORD PTR TCX2]
	DB $66;	MOV		[WORD PTR MTX1],AX
	DB $66;	MOV		AX,[WORD PTR TCY2]
	DB $66;	MOV		[WORD PTR MTY1],AX
@@OK17:
	DB $66;	XOR		CX,CX
	DB $66;	SAR		[WORD PTR MX1],Scaler
	DB $66;	ADC		[WORD PTR MX1],CX
	DB $66;	SAR		[WORD PTR MX2],Scaler
	DB $66;	ADC		[WORD PTR MX2],CX

	DB $66;	MOV		BX,[WORD PTR MX2]
	DB $66;	SUB		BX,[WORD PTR MX1]
	DB $66;	INC		BX

	DB $66;	MOV		AX,[WORD PTR MTX2]
	DB $66;	SUB		AX,[WORD PTR MTX1]
	DB $66;	CWD
	DB $66;	IDIV	BX
	DB $66;	MOV		[WORD PTR MDX1],AX

	DB $66;	MOV		AX,[WORD PTR MTY2]
	DB $66;	SUB		AX,[WORD PTR MTY1]
	DB $66;	CWD
	DB $66;	IDIV	BX
	DB $66;	MOV		[WORD PTR MDY1],AX

			CMP		[WORD PTR MX2],319
			JLE		@@OK20
			MOV		[WORD PTR MX2],319
@@OK20:

			MOV     [TEMPDI],DI
			CMP		[WORD PTR MX1],0
			JL		@@LOOP1
			ADD		DI,[WORD PTR MX1]
@@LOOP1:
			MOV		AX,[WORD PTR MX1]
			CMP		AX,0
			JL		@@NEXTPIXEL
			CMP		AX,[WORD PTR MX2]
			JG		@@ENDOFLINE
	DB $66;	MOV		AX,[WORD PTR MTY1]
	DB $66;	XOR		CX,CX
	DB $66;	SAR		AX,Scaler
	DB $66;	ADC		AX,CX
			MOV		BX,AX
			SHL		AX,6
			SHL		BX,8
			ADD		BX,AX
	DB $66;	MOV		AX,[WORD PTR MTX1]
	DB $66;	SAR		AX,Scaler
			ADC		BX,AX
			MOV		AL,[DS:SI+BX]
			MOV		[ES:DI],AL
			INC		DI
@@NEXTPIXEL:
			INC		[WORD PTR MX1]
	DB $66;	MOV		AX,[WORD PTR MDX1]
	DB $66;	ADD		[WORD PTR MTX1],AX
	DB $66;	MOV		AX,[WORD PTR MDY1]
	DB $66;	ADD		[WORD PTR MTY1],AX
			JMP		@@LOOP1
@@ENDOFLINE:
			MOV     DI,[TEMPDI]
			ADD		DI,320
@@NEXTLINE:
	DB $66;	MOV		AX,[WORD PTR DX3]
	DB $66;	ADD		[WORD PTR CX1],AX
	DB $66;	MOV		AX,[WORD PTR TDX3]
	DB $66;	ADD		[WORD PTR TCX1],AX
	DB $66;	MOV		AX,[WORD PTR TDY3]
	DB $66;	ADD		[WORD PTR TCY1],AX
			MOV		AX,[Y]
			CMP		AX,[Y2]
			JL		@@TOPPART
	DB $66;	MOV		AX,[WORD PTR DX2]
	DB $66;	ADD		[WORD PTR CX2],AX
	DB $66;	MOV		AX,[WORD PTR TDX2]
	DB $66;	ADD		[WORD PTR TCX2],AX
	DB $66;	MOV		AX,[WORD PTR TDY2]
	DB $66;	ADD		[WORD PTR TCY2],AX
			JMP		@@OK21
@@TOPPART:
	DB $66;	MOV		AX,[WORD PTR DX1]
	DB $66;	ADD		[WORD PTR CX2],AX
	DB $66;	MOV		AX,[WORD PTR TDX1]
	DB $66;	ADD		[WORD PTR TCX2],AX
	DB $66;	MOV		AX,[WORD PTR TDY1]
	DB $66;	ADD		[WORD PTR TCY2],AX
@@OK21:
			INC		[Y]
			MOV		AX,[Y]
			CMP		AX,199
			JG		@@EXIT
			CMP		AX,[Y3]
			JLE		@@LINELOOP
@@EXIT:
			MOV     DS,[TEMPDS]
End;

Procedure XTetraTexture320Clip(X1,Y1,X2,Y2,X3,Y3,TX1,TY1,TX2,TY2,TX3,TY3,ClipX1,ClipY1,ClipX2,ClipY2 : Integer;
	Texture : PChar; VideoSeg : Word); Assembler;
Var
	X,Y				: Integer;
	XX1,XX2,XX3		: LongInt;
	DX1,DX2,DX3		: LongInt;
	TXX1,TXX2,TXX3	: LongInt;
	TYY1,TYY2,TYY3	: LongInt;
	TDX1,TDX2,TDX3	: LongInt;
	TDY1,TDY2,TDY3	: LongInt;
	CX1,CX2			: LongInt;
	MX1,MX2			: LongInt;
	TCX1,TCY1		: LongInt;
	TCX2,TCY2		: LongInt;
	MTX1,MTY1		: LongInt;
	MTX2,MTY2		: LongInt;
	MDX1,MDY1		: LongInt;
Asm
			CLD
			PUSH	DS
			LDS		SI,[DWORD PTR Texture]
			MOV		ES,[VideoSeg]

			MOV		AX,[Y1]
			CMP		AX,[Y2]
			JLE		@@OK1
			XCHG	AX,[Y2]
			MOV		[Y1],AX					{ SWAPPED Y1:Y2 }
			MOV		AX,[X1]
			XCHG	AX,[X2]
			MOV		[X1],AX					{ SWAPPED X1:X2 }
			MOV		AX,[TX1]
			XCHG	AX,[TX2]
			MOV		[TX1],AX				{ SWAPPED TX1:TX2 }
			MOV		AX,[TY1]
			XCHG	AX,[TY2]
			MOV		[TY1],AX				{ SWAPPED TY1:TY2 }
@@OK1:

			MOV		AX,[Y1]
			CMP		AX,[Y3]
			JLE		@@OK2
			XCHG	AX,[Y3]
			MOV		[Y1],AX					{ SWAPPED Y1:Y3 }
			MOV		AX,[X1]
			XCHG	AX,[X3]
			MOV		[X1],AX					{ SWAPPED X1:X3 }
			MOV		AX,[TX1]
			XCHG	AX,[TX3]
			MOV		[TX1],AX				{ SWAPPED TX1:TX3 }
			MOV		AX,[TY1]
			XCHG	AX,[TY3]
			MOV		[TY1],AX				{ SWAPPED TY1:TY3 }
@@OK2:

			MOV		AX,[Y2]
			CMP		AX,[Y3]
			JLE		@@OK3
			XCHG	AX,[Y3]
			MOV		[Y2],AX					{ SWAPPED Y2:Y3 }
			MOV		AX,[X2]
			XCHG	AX,[X3]
			MOV		[X2],AX					{ SWAPPED X2:X3 }
			MOV		AX,[TX2]
			XCHG	AX,[TX3]
			MOV		[TX2],AX				{ SWAPPED TX2:TX3 }
			MOV		AX,[TY2]
			XCHG	AX,[TY3]
			MOV		[TY2],AX				{ SWAPPED TY2:TY3 }
@@OK3:
			MOV		AX,[Y1]
			CMP		AX,[ClipY2]
			JG		@@EXIT
			MOV		AX,[Y3]
			CMP		AX,[ClipY1]
			JL		@@EXIT
			MOV		AX,[X1]
			CMP		AX,[ClipX1]
			JGE		@@OK22
			MOV		AX,[X2]
			CMP		AX,[ClipX1]
			JGE		@@OK22
			MOV		AX,[X3]
			CMP		AX,[ClipX1]
			JGE		@@OK22
			JMP		@@EXIT
@@OK22:
			MOV		AX,[ClipX2]
			CMP		[X1],AX
			JLE		@@OK23
			CMP		[X2],AX
			JLE		@@OK23
			CMP		[X3],AX
			JLE		@@OK23
			JMP		@@EXIT
@@OK23:

	DB $66;	DB $0F, $BF, $46, OFFSET X1		{ MOVSX EAX,[X1] }
	DB $66;	SHL		AX,Scaler
	DB $66;	MOV		[WORD PTR XX1],AX
	DB $66;	DB $0F, $BF, $46, OFFSET X2		{ MOVSX EAX,[X2] }
	DB $66;	SHL		AX,Scaler
	DB $66;	MOV		[WORD PTR XX2],AX
	DB $66;	DB $0F, $BF, $46, OFFSET X3		{ MOVSX EAX,[X3] }
	DB $66;	SHL		AX,Scaler
	DB $66;	MOV		[WORD PTR XX3],AX

	DB $66;	DB $0F, $BF, $46, OFFSET TX1	{ MOVSX EAX,[TX1] }
	DB $66;	SHL		AX,Scaler
	DB $66;	MOV		[WORD PTR TXX1],AX
	DB $66;	DB $0F, $BF, $46, OFFSET TX2	{ MOVSX EAX,[TX2] }
	DB $66;	SHL		AX,Scaler
	DB $66;	MOV		[WORD PTR TXX2],AX
	DB $66;	DB $0F, $BF, $46, OFFSET TX3	{ MOVSX EAX,[TX3]			}
	DB $66;	SHL		AX,Scaler
	DB $66;	MOV		[WORD PTR TXX3],AX

	DB $66;	DB $0F, $BF, $46, OFFSET TY1	{ MOVSX EAX,[TY1]			}
	DB $66;	SHL		AX,Scaler
	DB $66;	MOV		[WORD PTR TYY1],AX
	DB $66;	DB $0F, $BF, $46, OFFSET TY2	{ MOVSX EAX,[TY2]			}
	DB $66;	SHL		AX,Scaler
	DB $66;	MOV		[WORD PTR TYY2],AX
	DB $66;	DB $0F, $BF, $46, OFFSET TY3	{ MOVSX EAX,[TY3]			}
	DB $66;	SHL		AX,Scaler
	DB $66;	MOV		[WORD PTR TYY3],AX

			MOV		AX,[Y1]
			CMP		AX,[Y2]
			JNE		@@NONFLAT1
	DB $66;	XOR		AX,AX
	DB $66;	MOV		[WORD PTR DX1],AX
	DB $66;	MOV		[WORD PTR TDX1],AX
	DB $66;	MOV		[WORD PTR TDY1],AX
			JMP		@@OK7
@@NONFLAT1:
	DB $66;	DB $0F, $BF, $5E, OFFSET Y2		{ MOVSX EBX,[Y2]			}
	DB $66;	DB $0F, $BF, $4E, OFFSET Y1		{ MOVSX ECX,[Y1]			}
	DB $66;	SUB		BX,CX					{ SUB EBX,ECX				}

	DB $66;	MOV		AX,[WORD PTR XX2]
	DB $66;	SUB		AX,[WORD PTR XX1]
	DB $66;	CWD
	DB $66;	IDIV	BX
	DB $66;	MOV		[WORD PTR DX1],AX

	DB $66;	MOV		AX,[WORD PTR TXX2]
	DB $66;	SUB		AX,[WORD PTR TXX1]
	DB $66;	CWD
	DB $66;	IDIV	BX
	DB $66;	MOV		[WORD PTR TDX1],AX

	DB $66;	MOV		AX,[WORD PTR TYY2]
	DB $66;	SUB		AX,[WORD PTR TYY1]
	DB $66;	CWD
	DB $66;	IDIV	BX
	DB $66;	MOV		[WORD PTR TDY1],AX

@@OK7:
			MOV		AX,[Y2]
			CMP		AX,[Y3]
			JNE		@@NONFLAT2
	DB $66;	XOR		AX,AX
	DB $66;	MOV		[WORD PTR DX2],AX
	DB $66;	MOV		[WORD PTR TDX2],AX
	DB $66;	MOV		[WORD PTR TDY2],AX
			JMP		@@OK11
@@NONFLAT2:
	DB $66;	DB $0F, $BF, $5E, OFFSET Y3		{ MOVSX EBX,[Y3]			}
	DB $66;	DB $0F, $BF, $4E, OFFSET Y2		{ MOVSX ECX,[Y2]			}
	DB $66;	SUB		BX,CX					{ SUB EBX,ECX				}

	DB $66;	MOV		AX,[WORD PTR XX3]
	DB $66;	SUB		AX,[WORD PTR XX2]
	DB $66;	CWD
	DB $66;	IDIV	BX
	DB $66;	MOV		[WORD PTR DX2],AX

	DB $66;	MOV		AX,[WORD PTR TXX3]
	DB $66;	SUB		AX,[WORD PTR TXX2]
	DB $66;	CWD
	DB $66;	IDIV	BX
	DB $66;	MOV		[WORD PTR TDX2],AX

	DB $66;	MOV		AX,[WORD PTR TYY3]
	DB $66;	SUB		AX,[WORD PTR TYY2]
	DB $66;	CWD
	DB $66;	IDIV	BX
	DB $66;	MOV		[WORD PTR TDY2],AX

@@OK11:

			MOV		AX,[Y1]
			CMP		AX,[Y3]
			JNE		@@NONFLAT3
	DB $66;	XOR		AX,AX
	DB $66;	MOV		[WORD PTR DX3],AX
	DB $66;	MOV		[WORD PTR TDX3],AX
	DB $66;	MOV		[WORD PTR TDY3],AX
			JMP		@@OK15
@@NONFLAT3:
	DB $66;	DB $0F, $BF, $5E, OFFSET Y3		{ MOVSX EBX,[Y3]			}
	DB $66;	DB $0F, $BF, $4E, OFFSET Y1		{ MOVSX ECX,[Y2]			}
	DB $66;	SUB		BX,CX					{ SUB EBX,ECX				}

	DB $66;	MOV		AX,[WORD PTR XX3]
	DB $66;	SUB		AX,[WORD PTR XX1]
	DB $66;	CWD
	DB $66;	IDIV	BX
	DB $66;	MOV		[WORD PTR DX3],AX

	DB $66;	MOV		AX,[WORD PTR TXX3]
	DB $66;	SUB		AX,[WORD PTR TXX1]
	DB $66;	CWD
	DB $66;	IDIV	BX
	DB $66;	MOV		[WORD PTR TDX3],AX

	DB $66;	MOV		AX,[WORD PTR TYY3]
	DB $66;	SUB		AX,[WORD PTR TYY1]
	DB $66;	CWD
	DB $66;	IDIV	BX
	DB $66;	MOV		[WORD PTR TDY3],AX

@@OK15:

	DB $66;	MOV		AX,[WORD PTR XX1]
	DB $66;	MOV		[WORD PTR CX1],AX
	DB $66;	MOV		AX,[WORD PTR TXX1]
	DB $66;	MOV		[WORD PTR TCX1],AX
	DB $66;	MOV		AX,[WORD PTR TYY1]
	DB $66;	MOV		[WORD PTR TCY1],AX

			MOV		AX,[Y1]
			CMP		AX,[Y2]
			JNE		@@NONFLAT4
	DB $66;	MOV		AX,[WORD PTR XX2]
	DB $66;	MOV		[WORD PTR CX2],AX
	DB $66;	MOV		AX,[WORD PTR TXX2]
	DB $66;	MOV		[WORD PTR TCX2],AX
	DB $66;	MOV		AX,[WORD PTR TYY2]
	DB $66;	MOV		[WORD PTR TCY2],AX
			JMP		@@OK16
@@NONFLAT4:
	DB $66;	MOV		AX,[WORD PTR XX1]
	DB $66;	MOV		[WORD PTR CX2],AX
	DB $66;	MOV		AX,[WORD PTR TXX1]
	DB $66;	MOV		[WORD PTR TCX2],AX
	DB $66;	MOV		AX,[WORD PTR TYY1]
	DB $66;	MOV		[WORD PTR TCY2],AX
@@OK16:
			MOV		AX,[Y1]
			MOV		[Y],AX
			MOV		AX,[Y]
			CMP		AX,[ClipY1]
			JGE		@@MOVEDOWN
			MOV		AX,[ClipY1]
@@MOVEDOWN:
			MOV		DI,AX
			SHL		DI,6
			SHL		AX,8
			ADD		DI,AX
@@LINELOOP:
			MOV		AX,[Y]
			CMP		AX,[ClipY1]
			JL		@@NEXTLINE
			CMP		AX,[ClipY2]
			JG		@@EXIT

	DB $66;	MOV		AX,[WORD PTR CX1]
	DB $66;	CMP		AX,[WORD PTR CX2]
			JGE		@@MUSTSWAP
	DB $66;	MOV		[WORD PTR MX1],AX
	DB $66;	MOV		AX,[WORD PTR CX2]
	DB $66;	MOV		[WORD PTR MX2],AX
	DB $66;	MOV		AX,[WORD PTR TCX1]
	DB $66;	MOV		[WORD PTR MTX1],AX
	DB $66;	MOV		AX,[WORD PTR TCY1]
	DB $66;	MOV		[WORD PTR MTY1],AX
	DB $66;	MOV		AX,[WORD PTR TCX2]
	DB $66;	MOV		[WORD PTR MTX2],AX
	DB $66;	MOV		AX,[WORD PTR TCY2]
	DB $66;	MOV		[WORD PTR MTY2],AX
			JMP		@@OK17
@@MUSTSWAP:
	DB $66;	MOV		[WORD PTR MX2],AX
	DB $66;	MOV		AX,[WORD PTR CX2]
	DB $66;	MOV		[WORD PTR MX1],AX
	DB $66;	MOV		AX,[WORD PTR TCX1]
	DB $66;	MOV		[WORD PTR MTX2],AX
	DB $66;	MOV		AX,[WORD PTR TCY1]
	DB $66;	MOV		[WORD PTR MTY2],AX
	DB $66;	MOV		AX,[WORD PTR TCX2]
	DB $66;	MOV		[WORD PTR MTX1],AX
	DB $66;	MOV		AX,[WORD PTR TCY2]
	DB $66;	MOV		[WORD PTR MTY1],AX
@@OK17:
	DB $66;	XOR		CX,CX
	DB $66;	SAR		[WORD PTR MX1],Scaler
	DB $66;	ADC		[WORD PTR MX1],CX
	DB $66;	SAR		[WORD PTR MX2],Scaler
	DB $66;	ADC		[WORD PTR MX2],CX

	DB $66;	MOV		BX,[WORD PTR MX2]
	DB $66;	SUB		BX,[WORD PTR MX1]
	DB $66;	INC		BX

	DB $66;	MOV		AX,[WORD PTR MTX2]
	DB $66;	SUB		AX,[WORD PTR MTX1]
	DB $66;	CWD
	DB $66;	IDIV	BX
	DB $66;	MOV		[WORD PTR MDX1],AX

	DB $66;	MOV		AX,[WORD PTR MTY2]
	DB $66;	SUB		AX,[WORD PTR MTY1]
	DB $66;	CWD
	DB $66;	IDIV	BX
	DB $66;	MOV		[WORD PTR MDY1],AX

			MOV		AX,[WORD PTR MX2]
			CMP		AX,[ClipX2]
			JLE		@@OK20
			MOV		AX,[ClipX2]
			MOV		[WORD PTR MX2],AX
@@OK20:

			PUSH	DI
			MOV		AX,[WORD PTR MX1]
			CMP		AX,[ClipX1]
			JGE		@@OK20_2
			MOV		AX,[ClipX1]
@@OK20_2:
			ADD		DI,AX
@@LOOP1:
			MOV		AX,[WORD PTR MX1]
			CMP		AX,[ClipX1]
			JL		@@NEXTPIXEL
			CMP		AX,[WORD PTR MX2]
			JG		@@ENDOFLINE
	DB $66;	MOV		AX,[WORD PTR MTY1]
	DB $66;	XOR		CX,CX
	DB $66;	SAR		AX,Scaler
	DB $66;	ADC		AX,CX
			MOV		BX,AX
			SHL		AX,6
			SHL		BX,8
			ADD		BX,AX
	DB $66;	MOV		AX,[WORD PTR MTX1]
	DB $66;	SAR		AX,Scaler
			ADC		BX,AX
			MOV		AL,[DS:SI+BX]
			MOV		[ES:DI],AL
			INC		DI
@@NEXTPIXEL:
			INC		[WORD PTR MX1]
	DB $66;	MOV		AX,[WORD PTR MDX1]
	DB $66;	ADD		[WORD PTR MTX1],AX
	DB $66;	MOV		AX,[WORD PTR MDY1]
	DB $66;	ADD		[WORD PTR MTY1],AX
			JMP		@@LOOP1
@@ENDOFLINE:
			POP		DI
			ADD		DI,320
@@NEXTLINE:
	DB $66;	MOV		AX,[WORD PTR DX3]
	DB $66;	ADD		[WORD PTR CX1],AX
	DB $66;	MOV		AX,[WORD PTR TDX3]
	DB $66;	ADD		[WORD PTR TCX1],AX
	DB $66;	MOV		AX,[WORD PTR TDY3]
	DB $66;	ADD		[WORD PTR TCY1],AX
			MOV		AX,[Y]
			CMP		AX,[Y2]
			JL		@@TOPPART
	DB $66;	MOV		AX,[WORD PTR DX2]
	DB $66;	ADD		[WORD PTR CX2],AX
	DB $66;	MOV		AX,[WORD PTR TDX2]
	DB $66;	ADD		[WORD PTR TCX2],AX
	DB $66;	MOV		AX,[WORD PTR TDY2]
	DB $66;	ADD		[WORD PTR TCY2],AX
			JMP		@@OK21
@@TOPPART:
	DB $66;	MOV		AX,[WORD PTR DX1]
	DB $66;	ADD		[WORD PTR CX2],AX
	DB $66;	MOV		AX,[WORD PTR TDX1]
	DB $66;	ADD		[WORD PTR TCX2],AX
	DB $66;	MOV		AX,[WORD PTR TDY1]
	DB $66;	ADD		[WORD PTR TCY2],AX
@@OK21:
			INC		[Y]
			MOV		AX,[Y]
			CMP		AX,[ClipY2]
			JG		@@EXIT
			CMP		AX,[Y3]
			JLE		@@LINELOOP
@@EXIT:
			POP		DS
End;

Procedure XTetraTexture320SpaceCutZBufferClip(X1,Y1,Z1,X2,Y2,Z2,X3,Y3,Z3,TX1,TY1,TX2,TY2,TX3,TY3,
	ClipX1,ClipY1,ClipX2,ClipY2 : Integer;
	Texture : PChar; ZSeg,VideoSeg : Word); Assembler;
Var
	X,Y				: Integer;
	XX1,XX2,XX3		: LongInt;
	DX1,DX2,DX3		: LongInt;
	TXX1,TXX2,TXX3	: LongInt;
	TYY1,TYY2,TYY3	: LongInt;
	TDX1,TDX2,TDX3	: LongInt;
	TDY1,TDY2,TDY3	: LongInt;
	CX1,CX2			: LongInt;
	MX1,MX2			: LongInt;
	TCX1,TCY1		: LongInt;
	TCX2,TCY2		: LongInt;
	MTX1,MTY1		: LongInt;
	MTX2,MTY2		: LongInt;
	MDX1,MDY1		: LongInt;

	ZZ1,ZZ2,ZZ3	: LongInt;
	DZ1,DZ2,DZ3	: LongInt;
	MZ1,MZ2		: LongInt;
	PZ1,PZ2		: LongInt;
	DZZ1		: LongInt;
Asm
			CLD
			PUSH	DS
			LDS		SI,[DWORD PTR Texture]
			MOV		ES,[VideoSeg]

			MOV		AX,[Y1]
			CMP		AX,[Y2]
			JLE		@@OK1
			XCHG	AX,[Y2]
			MOV		[Y1],AX					{ SWAPPED Y1:Y2 }
			MOV		AX,[X1]
			XCHG	AX,[X2]
			MOV		[X1],AX					{ SWAPPED X1:X2 }
			MOV		AX,[TX1]
			XCHG	AX,[TX2]
			MOV		[TX1],AX				{ SWAPPED TX1:TX2 }
			MOV		AX,[TY1]
			XCHG	AX,[TY2]
			MOV		[TY1],AX				{ SWAPPED TY1:TY2 }
			MOV		AX,[Z1]
			XCHG	AX,[Z2]
			MOV		[Z1],AX
@@OK1:

			MOV		AX,[Y1]
			CMP		AX,[Y3]
			JLE		@@OK2
			XCHG	AX,[Y3]
			MOV		[Y1],AX					{ SWAPPED Y1:Y3 }
			MOV		AX,[X1]
			XCHG	AX,[X3]
			MOV		[X1],AX					{ SWAPPED X1:X3 }
			MOV		AX,[TX1]
			XCHG	AX,[TX3]
			MOV		[TX1],AX				{ SWAPPED TX1:TX3 }
			MOV		AX,[TY1]
			XCHG	AX,[TY3]
			MOV		[TY1],AX				{ SWAPPED TY1:TY3 }
			MOV		AX,[Z1]
			XCHG	AX,[Z3]
			MOV		[Z1],AX
@@OK2:

			MOV		AX,[Y2]
			CMP		AX,[Y3]
			JLE		@@OK3
			XCHG	AX,[Y3]
			MOV		[Y2],AX					{ SWAPPED Y2:Y3 }
			MOV		AX,[X2]
			XCHG	AX,[X3]
			MOV		[X2],AX					{ SWAPPED X2:X3 }
			MOV		AX,[TX2]
			XCHG	AX,[TX3]
			MOV		[TX2],AX				{ SWAPPED TX2:TX3 }
			MOV		AX,[TY2]
			XCHG	AX,[TY3]
			MOV		[TY2],AX				{ SWAPPED TY2:TY3 }
			MOV		AX,[Z2]
			XCHG	AX,[Z3]
			MOV		[Z2],AX
@@OK3:
			MOV		AX,[Y1]
			CMP		AX,[ClipY2]
			JG		@@EXIT
			MOV		AX,[Y3]
			CMP		AX,[ClipY1]
			JL		@@EXIT
			MOV		AX,[X1]
			CMP		AX,[ClipX1]
			JGE		@@OK22
			MOV		AX,[X2]
			CMP		AX,[ClipX1]
			JGE		@@OK22
			MOV		AX,[X3]
			CMP		AX,[ClipX1]
			JGE		@@OK22
			JMP		@@EXIT
@@OK22:
			MOV		AX,[ClipX2]
			CMP		[X1],AX
			JLE		@@OK23
			CMP		[X2],AX
			JLE		@@OK23
			CMP		[X3],AX
			JLE		@@OK23
			JMP		@@EXIT
@@OK23:

	DB $66;	DB $0F, $BF, $46, OFFSET X1		{ MOVSX EAX,[X1] }
	DB $66;	SHL		AX,Scaler
	DB $66;	MOV		[WORD PTR XX1],AX
	DB $66;	DB $0F, $BF, $46, OFFSET X2		{ MOVSX EAX,[X2] }
	DB $66;	SHL		AX,Scaler
	DB $66;	MOV		[WORD PTR XX2],AX
	DB $66;	DB $0F, $BF, $46, OFFSET X3		{ MOVSX EAX,[X3] }
	DB $66;	SHL		AX,Scaler
	DB $66;	MOV		[WORD PTR XX3],AX

	DB $66;	DB $0F, $BF, $46, OFFSET TX1	{ MOVSX EAX,[TX1] }
	DB $66;	SHL		AX,Scaler
	DB $66;	MOV		[WORD PTR TXX1],AX
	DB $66;	DB $0F, $BF, $46, OFFSET TX2	{ MOVSX EAX,[TX2] }
	DB $66;	SHL		AX,Scaler
	DB $66;	MOV		[WORD PTR TXX2],AX
	DB $66;	DB $0F, $BF, $46, OFFSET TX3	{ MOVSX EAX,[TX3]			}
	DB $66;	SHL		AX,Scaler
	DB $66;	MOV		[WORD PTR TXX3],AX

	DB $66;	DB $0F, $BF, $46, OFFSET TY1	{ MOVSX EAX,[TY1]			}
	DB $66;	SHL		AX,Scaler
	DB $66;	MOV		[WORD PTR TYY1],AX
	DB $66;	DB $0F, $BF, $46, OFFSET TY2	{ MOVSX EAX,[TY2]			}
	DB $66;	SHL		AX,Scaler
	DB $66;	MOV		[WORD PTR TYY2],AX
	DB $66;	DB $0F, $BF, $46, OFFSET TY3	{ MOVSX EAX,[TY3]			}
	DB $66;	SHL		AX,Scaler
	DB $66;	MOV		[WORD PTR TYY3],AX

	DB $66;	DB $0F, $BF, $46, OFFSET Z1		{ MOVSX EAX,[Z1]			}
	DB $66;	SHL		AX,Scaler
	DB $66;	MOV		[WORD PTR ZZ1],AX
	DB $66;	DB $0F, $BF, $46, OFFSET Z2		{ MOVSX EAX,[Z2]			}
	DB $66;	SHL		AX,Scaler
	DB $66;	MOV		[WORD PTR ZZ2],AX
	DB $66;	DB $0F, $BF, $46, OFFSET Z3		{ MOVSX EAX,[Z3]			}
	DB $66;	SHL		AX,Scaler
	DB $66;	MOV		[WORD PTR ZZ3],AX

			MOV		AX,[Y1]
			CMP		AX,[Y2]
			JNE		@@NONFLAT1
	DB $66;	XOR		AX,AX
	DB $66;	MOV		[WORD PTR DX1],AX
	DB $66;	MOV		[WORD PTR TDX1],AX
	DB $66;	MOV		[WORD PTR TDY1],AX
	DB $66;	MOV		[WORD PTR DZ1],AX
			JMP		@@OK7
@@NONFLAT1:
	DB $66;	DB $0F, $BF, $5E, OFFSET Y2		{ MOVSX EBX,[Y2]			}
	DB $66;	DB $0F, $BF, $4E, OFFSET Y1		{ MOVSX ECX,[Y1]			}
	DB $66;	SUB		BX,CX					{ SUB EBX,ECX				}

	DB $66;	MOV		AX,[WORD PTR XX2]
	DB $66;	SUB		AX,[WORD PTR XX1]
	DB $66;	CWD
	DB $66;	IDIV	BX
	DB $66;	MOV		[WORD PTR DX1],AX

	DB $66;	MOV		AX,[WORD PTR TXX2]
	DB $66;	SUB		AX,[WORD PTR TXX1]
	DB $66;	CWD
	DB $66;	IDIV	BX
	DB $66;	MOV		[WORD PTR TDX1],AX

	DB $66;	MOV		AX,[WORD PTR TYY2]
	DB $66;	SUB		AX,[WORD PTR TYY1]
	DB $66;	CWD
	DB $66;	IDIV	BX
	DB $66;	MOV		[WORD PTR TDY1],AX

	DB $66;	MOV		AX,[WORD PTR ZZ2]
	DB $66;	SUB		AX,[WORD PTR ZZ1]
	DB $66;	CWD
	DB $66;	IDIV	BX
	DB $66;	MOV		[WORD PTR DZ1],AX

@@OK7:
			MOV		AX,[Y2]
			CMP		AX,[Y3]
			JNE		@@NONFLAT2
	DB $66;	XOR		AX,AX
	DB $66;	MOV		[WORD PTR DX2],AX
	DB $66;	MOV		[WORD PTR TDX2],AX
	DB $66;	MOV		[WORD PTR TDY2],AX
	DB $66;	MOV		[WORD PTR DZ2],AX
			JMP		@@OK11
@@NONFLAT2:
	DB $66;	DB $0F, $BF, $5E, OFFSET Y3		{ MOVSX EBX,[Y3]			}
	DB $66;	DB $0F, $BF, $4E, OFFSET Y2		{ MOVSX ECX,[Y2]			}
	DB $66;	SUB		BX,CX					{ SUB EBX,ECX				}

	DB $66;	MOV		AX,[WORD PTR XX3]
	DB $66;	SUB		AX,[WORD PTR XX2]
	DB $66;	CWD
	DB $66;	IDIV	BX
	DB $66;	MOV		[WORD PTR DX2],AX

	DB $66;	MOV		AX,[WORD PTR TXX3]
	DB $66;	SUB		AX,[WORD PTR TXX2]
	DB $66;	CWD
	DB $66;	IDIV	BX
	DB $66;	MOV		[WORD PTR TDX2],AX

	DB $66;	MOV		AX,[WORD PTR TYY3]
	DB $66;	SUB		AX,[WORD PTR TYY2]
	DB $66;	CWD
	DB $66;	IDIV	BX
	DB $66;	MOV		[WORD PTR TDY2],AX

	DB $66;	MOV		AX,[WORD PTR ZZ3]
	DB $66;	SUB		AX,[WORD PTR ZZ2]
	DB $66;	CWD
	DB $66;	IDIV	BX
	DB $66;	MOV		[WORD PTR DZ2],AX


@@OK11:

			MOV		AX,[Y1]
			CMP		AX,[Y3]
			JNE		@@NONFLAT3
	DB $66;	XOR		AX,AX
	DB $66;	MOV		[WORD PTR DX3],AX
	DB $66;	MOV		[WORD PTR TDX3],AX
	DB $66;	MOV		[WORD PTR TDY3],AX
	DB $66;	MOV		[WORD PTR DZ3],AX
			JMP		@@OK15
@@NONFLAT3:
	DB $66;	DB $0F, $BF, $5E, OFFSET Y3		{ MOVSX EBX,[Y3]			}
	DB $66;	DB $0F, $BF, $4E, OFFSET Y1		{ MOVSX ECX,[Y2]			}
	DB $66;	SUB		BX,CX					{ SUB EBX,ECX				}

	DB $66;	MOV		AX,[WORD PTR XX3]
	DB $66;	SUB		AX,[WORD PTR XX1]
	DB $66;	CWD
	DB $66;	IDIV	BX
	DB $66;	MOV		[WORD PTR DX3],AX

	DB $66;	MOV		AX,[WORD PTR TXX3]
	DB $66;	SUB		AX,[WORD PTR TXX1]
	DB $66;	CWD
	DB $66;	IDIV	BX
	DB $66;	MOV		[WORD PTR TDX3],AX

	DB $66;	MOV		AX,[WORD PTR TYY3]
	DB $66;	SUB		AX,[WORD PTR TYY1]
	DB $66;	CWD
	DB $66;	IDIV	BX
	DB $66;	MOV		[WORD PTR TDY3],AX

	DB $66;	MOV		AX,[WORD PTR ZZ3]
	DB $66;	SUB		AX,[WORD PTR ZZ1]
	DB $66;	CWD
	DB $66;	IDIV	BX
	DB $66;	MOV		[WORD PTR DZ3],AX

@@OK15:

	DB $66;	MOV		AX,[WORD PTR XX1]
	DB $66;	MOV		[WORD PTR CX1],AX
	DB $66;	MOV		AX,[WORD PTR TXX1]
	DB $66;	MOV		[WORD PTR TCX1],AX
	DB $66;	MOV		AX,[WORD PTR TYY1]
	DB $66;	MOV		[WORD PTR TCY1],AX
	DB $66;	MOV		AX,[WORD PTR ZZ1]
	DB $66;	MOV		[WORD PTR PZ1],AX

			MOV		AX,[Y1]
			CMP		AX,[Y2]
			JNE		@@NONFLAT4
	DB $66;	MOV		AX,[WORD PTR XX2]
	DB $66;	MOV		[WORD PTR CX2],AX
	DB $66;	MOV		AX,[WORD PTR TXX2]
	DB $66;	MOV		[WORD PTR TCX2],AX
	DB $66;	MOV		AX,[WORD PTR TYY2]
	DB $66;	MOV		[WORD PTR TCY2],AX
	DB $66;	MOV		AX,[WORD PTR ZZ2]
	DB $66;	MOV		[WORD PTR PZ2],AX
			JMP		@@OK16
@@NONFLAT4:
	DB $66;	MOV		AX,[WORD PTR XX1]
	DB $66;	MOV		[WORD PTR CX2],AX
	DB $66;	MOV		AX,[WORD PTR TXX1]
	DB $66;	MOV		[WORD PTR TCX2],AX
	DB $66;	MOV		AX,[WORD PTR TYY1]
	DB $66;	MOV		[WORD PTR TCY2],AX
	DB $66;	MOV		AX,[WORD PTR ZZ1]
	DB $66;	MOV		[WORD PTR PZ2],AX
@@OK16:
			MOV		AX,[Y1]
			MOV		[Y],AX
			MOV		AX,[Y]
			CMP		AX,[ClipY1]
			JGE		@@MOVEDOWN
			MOV		AX,[ClipY1]
@@MOVEDOWN:
			MOV		DI,AX
			SHL		DI,6
			SHL		AX,8
			ADD		DI,AX
@@LINELOOP:
			MOV		AX,[Y]
			CMP		AX,[ClipY1]
			JL		@@NEXTLINE
			CMP		AX,[ClipY2]
			JG		@@EXIT

	DB $66;	MOV		AX,[WORD PTR CX1]
	DB $66;	CMP		AX,[WORD PTR CX2]
			JGE		@@MUSTSWAP
	DB $66;	MOV		[WORD PTR MX1],AX
	DB $66;	MOV		AX,[WORD PTR CX2]
	DB $66;	MOV		[WORD PTR MX2],AX
	DB $66;	MOV		AX,[WORD PTR TCX1]
	DB $66;	MOV		[WORD PTR MTX1],AX
	DB $66;	MOV		AX,[WORD PTR TCY1]
	DB $66;	MOV		[WORD PTR MTY1],AX
	DB $66;	MOV		AX,[WORD PTR TCX2]
	DB $66;	MOV		[WORD PTR MTX2],AX
	DB $66;	MOV		AX,[WORD PTR TCY2]
	DB $66;	MOV		[WORD PTR MTY2],AX
	DB $66;	MOV		AX,[WORD PTR PZ1]
	DB $66;	MOV		[WORD PTR MZ1],AX
	DB $66;	MOV		AX,[WORD PTR PZ2]
	DB $66;	MOV		[WORD PTR MZ2],AX
			JMP		@@OK17
@@MUSTSWAP:
	DB $66;	MOV		[WORD PTR MX2],AX
	DB $66;	MOV		AX,[WORD PTR CX2]
	DB $66;	MOV		[WORD PTR MX1],AX
	DB $66;	MOV		AX,[WORD PTR TCX1]
	DB $66;	MOV		[WORD PTR MTX2],AX
	DB $66;	MOV		AX,[WORD PTR TCY1]
	DB $66;	MOV		[WORD PTR MTY2],AX
	DB $66;	MOV		AX,[WORD PTR TCX2]
	DB $66;	MOV		[WORD PTR MTX1],AX
	DB $66;	MOV		AX,[WORD PTR TCY2]
	DB $66;	MOV		[WORD PTR MTY1],AX
	DB $66;	MOV		AX,[WORD PTR PZ1]
	DB $66;	MOV		[WORD PTR MZ2],AX
	DB $66;	MOV		AX,[WORD PTR PZ2]
	DB $66;	MOV		[WORD PTR MZ1],AX
@@OK17:
	DB $66;	XOR		CX,CX
	DB $66;	SAR		[WORD PTR MX1],Scaler
	DB $66;	ADC		[WORD PTR MX1],CX
	DB $66;	SAR		[WORD PTR MX2],Scaler
	DB $66;	ADC		[WORD PTR MX2],CX

	DB $66;	MOV		BX,[WORD PTR MX2]
	DB $66;	SUB		BX,[WORD PTR MX1]
	DB $66;	INC		BX

	DB $66;	MOV		AX,[WORD PTR MTX2]
	DB $66;	SUB		AX,[WORD PTR MTX1]
	DB $66;	CWD
	DB $66;	IDIV	BX
	DB $66;	MOV		[WORD PTR MDX1],AX

	DB $66;	MOV		AX,[WORD PTR MZ2]
	DB $66;	SUB		AX,[WORD PTR MZ1]
	DB $66;	CWD
	DB $66;	IDIV	BX
	DB $66;	MOV		[WORD PTR DZZ1],AX

	DB $66;	MOV		AX,[WORD PTR MTY2]
	DB $66;	SUB		AX,[WORD PTR MTY1]
	DB $66;	XOR		DX,DX
	DB $66;	TEST	AX,AX
			JGE		@@OK19
	DB $66;	DEC		DX
@@OK19:
	DB $66;	IDIV	BX
	DB $66;	MOV		[WORD PTR MDY1],AX

			MOV		AX,[WORD PTR MX2]
			CMP		AX,[ClipX2]
			JLE		@@OK20
			MOV		AX,[ClipX2]
			MOV		[WORD PTR MX2],AX
@@OK20:

			PUSH	DI
			MOV		AX,[WORD PTR MX1]
			CMP		AX,[ClipX1]
			JGE		@@OK20_2
			MOV		AX,[ClipX1]
@@OK20_2:
			ADD		DI,AX
@@LOOP1:
			MOV		AX,[WORD PTR MX1]
			CMP		AX,[ClipX1]
			JL		@@NEXTPIXEL
			CMP		AX,[WORD PTR MX2]
			JG		@@ENDOFLINE
	DB $66;	MOV		AX,[WORD PTR MTY1]
	DB $66;	XOR		CX,CX
	DB $66;	SAR		AX,Scaler
	DB $66;	ADC		AX,CX
			MOV		BX,AX
			SHL		AX,6
			SHL		BX,8
			ADD		BX,AX
	DB $66;	MOV		AX,[WORD PTR MTX1]
	DB $66;	XOR		CX,CX
	DB $66;	SAR		AX,Scaler
	DB $66;	ADC		AX,CX
			ADD		BX,AX
			MOV		AL,[DS:SI+BX]
	DB $66;	MOV		BX,[WORD PTR MZ1]
	DB $66;	XOR		CX,CX
	DB $66;	SAR		BX,Scaler
	DB $66;	ADC		BX,CX

			PUSH	DS
			MOV		DS,[ZSeg]
			CMP		BL,[DS:DI]
			JBE		@@NOTPLOT

			MOV		[ES:DI],AL
			MOV		[DS:DI],BL
@@NOTPLOT:
			POP		DS
			INC		DI
@@NEXTPIXEL:
			INC		[WORD PTR MX1]
	DB $66;	MOV		AX,[WORD PTR MDX1]
	DB $66;	ADD		[WORD PTR MTX1],AX
	DB $66;	MOV		AX,[WORD PTR MDY1]
	DB $66;	ADD		[WORD PTR MTY1],AX
	DB $66;	MOV		AX,[WORD PTR DZZ1]
	DB $66;	ADD		[WORD PTR MZ1],AX
			JMP		@@LOOP1
@@ENDOFLINE:
			POP		DI
			ADD		DI,320
@@NEXTLINE:
	DB $66;	MOV		AX,[WORD PTR DX3]
	DB $66;	ADD		[WORD PTR CX1],AX
	DB $66;	MOV		AX,[WORD PTR TDX3]
	DB $66;	ADD		[WORD PTR TCX1],AX
	DB $66;	MOV		AX,[WORD PTR TDY3]
	DB $66;	ADD		[WORD PTR TCY1],AX
	DB $66;	MOV		AX,[WORD PTR DZ3]
	DB $66;	ADD		[WORD PTR PZ1],AX
			MOV		AX,[Y]
			CMP		AX,[Y2]
			JL		@@TOPPART
	DB $66;	MOV		AX,[WORD PTR DX2]
	DB $66;	ADD		[WORD PTR CX2],AX
	DB $66;	MOV		AX,[WORD PTR TDX2]
	DB $66;	ADD		[WORD PTR TCX2],AX
	DB $66;	MOV		AX,[WORD PTR TDY2]
	DB $66;	ADD		[WORD PTR TCY2],AX
	DB $66;	MOV		AX,[WORD PTR DZ2]
	DB $66;	ADD		[WORD PTR PZ2],AX
			JMP		@@OK21
@@TOPPART:
	DB $66;	MOV		AX,[WORD PTR DX1]
	DB $66;	ADD		[WORD PTR CX2],AX
	DB $66;	MOV		AX,[WORD PTR TDX1]
	DB $66;	ADD		[WORD PTR TCX2],AX
	DB $66;	MOV		AX,[WORD PTR TDY1]
	DB $66;	ADD		[WORD PTR TCY2],AX
	DB $66;	MOV		AX,[WORD PTR DZ1]
	DB $66;	ADD		[WORD PTR PZ2],AX
@@OK21:
			INC		[Y]
			MOV		AX,[Y]
			CMP		AX,[ClipY2]
			JG		@@EXIT
			CMP		AX,[Y3]
			JLE		@@LINELOOP
@@EXIT:
			POP		DS
End;

Procedure XTetraGourad(X1,Y1,C1,X2,Y2,C2,X3,Y3,C3 : Integer; VideoSeg : Word); Assembler;
Var
	X,Y			: Integer;
	XX1,XX2,XX3	: LongInt;
	CC1,CC2,CC3	: LongInt;
	DX1,DX2,DX3	: LongInt;
	DC1,DC2,DC3	: LongInt;
	MX1,MX2		: LongInt;
	MC1,MC2		: LongInt;
	PC1,PC2		: LongInt;
	CX1,CX2		: LongInt;
	DCC1		: LongInt;
Asm
			CLD
			MOV		AX,[X1]
			MOV		BX,[Y1]
			MOV		CX,[C1]
			MOV		DX,[X2]
			MOV		SI,[Y2]
			MOV		DI,[C2]

			CMP		BX,SI
			JLE		@@OK1
			XCHG	AX,DX
			XCHG	BX,SI
			XCHG	CX,DI
@@OK1:
			CMP		BX,[Y3]
			JLE		@@OK2
			XCHG	AX,[X3]
			XCHG	BX,[Y3]
			XCHG	CX,[C3]
@@OK2:
			CMP		SI,[Y3]
			JLE		@@OK3
			XCHG	DX,[X3]
			XCHG	SI,[Y3]
			XCHG	DI,[C3]
@@OK3:
			MOV		[X1],AX
			MOV		[Y1],BX
			MOV		[C1],CX
			MOV		[X2],DX
			MOV		[Y2],SI
			MOV		[C2],DI

	DB $66;	DB $0F, $BF, $46, OFFSET X1
	DB $66;	SAL		AX,Scaler
	DB $66;	MOV		[WORD PTR XX1],AX
	DB $66;	DB $0F, $BF, $46, OFFSET X2
	DB $66;	SAL		AX,Scaler
	DB $66;	MOV		[WORD PTR XX2],AX
	DB $66;	DB $0F, $BF, $46, OFFSET X3
	DB $66;	SAL		AX,Scaler
	DB $66;	MOV		[WORD PTR XX3],AX

	DB $66;	DB $0F, $BF, $46, OFFSET C1
	DB $66;	SAL		AX,Scaler
	DB $66;	MOV		[WORD PTR CC1],AX
	DB $66;	DB $0F, $BF, $46, OFFSET C2
	DB $66;	SAL		AX,Scaler
	DB $66;	MOV		[WORD PTR CC2],AX
	DB $66;	DB $0F, $BF, $46, OFFSET C3
	DB $66;	SAL		AX,Scaler
	DB $66;	MOV		[WORD PTR CC3],AX

			MOV		AX,[Y1]
			CMP		AX,[Y2]
			JNE		@@NONFLAT1
	DB $66;	XOR		AX,AX
	DB $66;	MOV		[WORD PTR DX1],AX
	DB $66;	MOV		[WORD PTR DC1],AX
			JMP		@@OK6
@@NONFLAT1:
	DB $66;	DB $0F, $BF, $5E, OFFSET Y2
	DB $66;	DB $0F, $BF, $4E, OFFSET Y1
	DB $66;	SUB		BX,CX

	DB $66;	MOV		AX,[WORD PTR XX2]
	DB $66;	SUB		AX,[WORD PTR XX1]
	DB $66;	CWD
	DB $66;	IDIV	BX
	DB $66;	MOV		[WORD PTR DX1],AX

	DB $66;	MOV		AX,[WORD PTR CC2]
	DB $66;	SUB		AX,[WORD PTR CC1]
	DB $66;	CWD
	DB $66;	IDIV	BX
	DB $66;	MOV		[WORD PTR DC1],AX
@@OK6:

			MOV		AX,[Y2]
			CMP		AX,[Y3]
			JNE		@@NONFLAT2
	DB $66;	XOR		AX,AX
	DB $66;	MOV		[WORD PTR DX2],AX
	DB $66;	MOV		[WORD PTR DC2],AX
			JMP		@@OK9
@@NONFLAT2:
	DB $66;	DB $0F, $BF, $5E, OFFSET Y3
	DB $66;	DB $0F, $BF, $4E, OFFSET Y2
	DB $66;	SUB		BX,CX

	DB $66;	MOV		AX,[WORD PTR XX3]
	DB $66;	SUB		AX,[WORD PTR XX2]
	DB $66;	CWD
	DB $66;	IDIV	BX
	DB $66;	MOV		[WORD PTR DX2],AX

	DB $66;	MOV		AX,[WORD PTR CC3]
	DB $66;	SUB		AX,[WORD PTR CC2]
	DB $66;	CWD
	DB $66;	IDIV	BX
	DB $66;	MOV		[WORD PTR DC2],AX
@@OK9:

			MOV		AX,[Y1]
			CMP		AX,[Y3]
			JNE		@@NONFLAT3
	DB $66;	XOR		AX,AX
	DB $66;	MOV		[WORD PTR DX3],AX
	DB $66;	MOV		[WORD PTR DC3],AX
			JMP		@@OK12
@@NONFLAT3:
	DB $66;	DB $0F, $BF, $5E, OFFSET Y3
	DB $66;	DB $0F, $BF, $4E, OFFSET Y1
	DB $66;	SUB		BX,CX

	DB $66;	MOV		AX,[WORD PTR XX3]
	DB $66;	SUB		AX,[WORD PTR XX1]
	DB $66;	CWD
	DB $66;	IDIV	BX
	DB $66;	MOV		[WORD PTR DX3],AX

	DB $66;	MOV		AX,[WORD PTR CC3]
	DB $66;	SUB		AX,[WORD PTR CC1]
	DB $66;	CWD
	DB $66;	IDIV	BX
	DB $66;	MOV		[WORD PTR DC3],AX
@@OK12:

	DB $66;	MOV		AX,[WORD PTR XX1]
	DB $66;	MOV		[WORD PTR CX1],AX
	DB $66;	MOV		AX,[WORD PTR CC1]
	DB $66;	MOV		[WORD PTR PC1],AX

			MOV		AX,[Y1]
			CMP		AX,[Y2]
			JNE		@@NONFLAT4
	DB $66;	MOV		AX,[WORD PTR XX2]
	DB $66;	MOV		[WORD PTR CX2],AX
	DB $66;	MOV		AX,[WORD PTR CC2]
	DB $66;	MOV		[WORD PTR PC2],AX
			JMP		@@OK13
@@NONFLAT4:
	DB $66;	MOV		AX,[WORD PTR XX1]
	DB $66;	MOV		[WORD PTR CX2],AX
	DB $66;	MOV		AX,[WORD PTR CC1]
	DB $66;	MOV		[WORD PTR PC2],AX
@@OK13:

			MOV		AX,[Y1]
			MOV		[Y],AX

			MOV		ES,[VideoSeg]
			CMP		AX,0
			JGE		@@OK13_2
			XOR		AX,AX
@@OK13_2:
			MOV		DI,AX
			SHL		AX,8
			SHL		DI,6
			ADD		DI,AX
@@LINELOOP:
			MOV		AX,[Y]
			TEST	AX,AX
			JL		@@NEXTLINE
			CMP		AX,199
			JG		@@EXIT
			CMP		AX,[Y3]
			JG		@@EXIT
	DB $66;	MOV		AX,[WORD PTR CX1]
	DB $66;	CMP		AX,[WORD PTR CX2]
			JLE		@@OK14
	DB $66;	MOV		[WORD PTR MX2],AX
	DB $66;	MOV		AX,[WORD PTR CX2]
	DB $66;	MOV		[WORD PTR MX1],AX
	DB $66;	MOV		AX,[WORD PTR PC1]
	DB $66;	MOV		[WORD PTR MC2],AX
	DB $66;	MOV		AX,[WORD PTR PC2]
	DB $66;	MOV		[WORD PTR MC1],AX
			JMP		@@OK15
@@OK14:
	DB $66;	MOV		[WORD PTR MX1],AX
	DB $66;	MOV		AX,[WORD PTR CX2]
	DB $66;	MOV		[WORD PTR MX2],AX
	DB $66;	MOV		AX,[WORD PTR PC1]
	DB $66;	MOV		[WORD PTR MC1],AX
	DB $66;	MOV		AX,[WORD PTR PC2]
	DB $66;	MOV		[WORD PTR MC2],AX
@@OK15:

	DB $66;	XOR		CX,CX
	DB $66;	SAR		[WORD PTR MX1],Scaler
	DB $66;	ADC		[WORD PTR MX1],CX
	DB $66;	SAR		[WORD PTR MX2],Scaler
	DB $66;	ADC		[WORD PTR MX2],CX

	DB $66;	MOV		AX,[WORD PTR MX1]
	DB $66;	CMP		AX,[WORD PTR MX2]
			JNE		@@NONFLAT5
	DB $66;	XOR		AX,AX
	DB $66;	MOV		[WORD PTR DCC1],AX
			JMP		@@OK17
@@NONFLAT5:
	DB $66;	MOV		AX,[WORD PTR MC2]
	DB $66;	SUB		AX,[WORD PTR MC1]
	DB $66;	MOV		BX,[WORD PTR MX2]
	DB $66;	SUB		BX,[WORD PTR MX1]
	DB $66;	CWD
	DB $66;	IDIV	BX
	DB $66;	MOV		[WORD PTR DCC1],AX
@@OK17:
			MOV		SI,DI
			MOV		AX,[WORD PTR MX1]
			CMP		AX,0
			JL		@@LOOP1
			ADD		DI,AX
@@LOOP1:
			MOV		AX,[WORD PTR MX1]
			CMP		AX,0
			JL		@@NEXTPIXEL
			CMP		AX,319
			JG		@@ENDOFLINE
			CMP		AX,[WORD PTR MX2]
			JG		@@ENDOFLINE

	DB $66;	MOV		AX,[WORD PTR MC1]
	DB $66;	XOR		BX,BX
	DB $66;	SAR     AX,Scaler
	DB $66;	ADC		AX,BX

			MOV		[ES:DI],AL
			INC		DI
@@NEXTPIXEL:
			INC		[WORD PTR MX1]
	DB $66;	MOV		AX,[WORD PTR DCC1]
	DB $66;	ADD		[WORD PTR MC1],AX
			JMP		@@LOOP1
@@ENDOFLINE:
			MOV		DI,SI
			ADD		DI,320
@@NEXTLINE:

	DB $66;	MOV		AX,[WORD PTR DX3]
	DB $66;	ADD		[WORD PTR CX1],AX
	DB $66;	MOV		AX,[WORD PTR DC3]
	DB $66;	ADD		[WORD PTR PC1],AX

			MOV		AX,[Y]
			CMP		AX,[Y2]
			JL		@@TOPPART
	DB $66;	MOV		AX,[WORD PTR DX2]
	DB $66;	ADD		[WORD PTR CX2],AX
	DB $66;	MOV		AX,[WORD PTR DC2]
	DB $66;	ADD		[WORD PTR PC2],AX
			JMP		@@OK18
@@TOPPART:
	DB $66;	MOV		AX,[WORD PTR DX1]
	DB $66;	ADD		[WORD PTR CX2],AX
	DB $66;	MOV		AX,[WORD PTR DC1]
	DB $66;	ADD		[WORD PTR PC2],AX
@@OK18:
			INC		[Y]
			JMP		@@LINELOOP
@@EXIT:
End;

Procedure XTetraGouradClip(X1,Y1,C1,X2,Y2,C2,X3,Y3,C3,ClipX1,ClipY1,ClipX2,ClipY2 : Integer; VideoSeg : Word); Assembler;
Var
	X,Y			: Integer;
	XX1,XX2,XX3	: LongInt;
	CC1,CC2,CC3	: LongInt;
	DX1,DX2,DX3	: LongInt;
	DC1,DC2,DC3	: LongInt;
	MX1,MX2		: LongInt;
	MC1,MC2		: LongInt;
	PC1,PC2		: LongInt;
	CX1,CX2		: LongInt;
	DCC1		: LongInt;
Asm
			CLD
			MOV		AX,[X1]
			MOV		BX,[Y1]
			MOV		CX,[C1]
			MOV		DX,[X2]
			MOV		SI,[Y2]
			MOV		DI,[C2]

			CMP		BX,SI
			JLE		@@OK1
			XCHG	AX,DX
			XCHG	BX,SI
			XCHG	CX,DI
@@OK1:
			CMP		BX,[Y3]
			JLE		@@OK2
			XCHG	AX,[X3]
			XCHG	BX,[Y3]
			XCHG	CX,[C3]
@@OK2:
			CMP		SI,[Y3]
			JLE		@@OK3
			XCHG	DX,[X3]
			XCHG	SI,[Y3]
			XCHG	DI,[C3]
@@OK3:
			MOV		[X1],AX
			MOV		[Y1],BX
			MOV		[C1],CX
			MOV		[X2],DX
			MOV		[Y2],SI
			MOV		[C2],DI

	DB $66;	DB $0F, $BF, $46, OFFSET X1
	DB $66;	SAL		AX,Scaler
	DB $66;	MOV		[WORD PTR XX1],AX
	DB $66;	DB $0F, $BF, $46, OFFSET X2
	DB $66;	SAL		AX,Scaler
	DB $66;	MOV		[WORD PTR XX2],AX
	DB $66;	DB $0F, $BF, $46, OFFSET X3
	DB $66;	SAL		AX,Scaler
	DB $66;	MOV		[WORD PTR XX3],AX

	DB $66;	DB $0F, $BF, $46, OFFSET C1
	DB $66;	SAL		AX,Scaler
	DB $66;	MOV		[WORD PTR CC1],AX
	DB $66;	DB $0F, $BF, $46, OFFSET C2
	DB $66;	SAL		AX,Scaler
	DB $66;	MOV		[WORD PTR CC2],AX
	DB $66;	DB $0F, $BF, $46, OFFSET C3
	DB $66;	SAL		AX,Scaler
	DB $66;	MOV		[WORD PTR CC3],AX

			MOV		AX,[Y1]
			CMP		AX,[Y2]
			JNE		@@NONFLAT1
	DB $66;	XOR		AX,AX
	DB $66;	MOV		[WORD PTR DX1],AX
	DB $66;	MOV		[WORD PTR DC1],AX
			JMP		@@OK6
@@NONFLAT1:
	DB $66;	DB $0F, $BF, $5E, OFFSET Y2
	DB $66;	DB $0F, $BF, $4E, OFFSET Y1
	DB $66;	SUB		BX,CX

	DB $66;	MOV		AX,[WORD PTR XX2]
	DB $66;	SUB		AX,[WORD PTR XX1]
	DB $66;	CWD
	DB $66;	IDIV	BX
	DB $66;	MOV		[WORD PTR DX1],AX

	DB $66;	MOV		AX,[WORD PTR CC2]
	DB $66;	SUB		AX,[WORD PTR CC1]
	DB $66;	CWD
	DB $66;	IDIV	BX
	DB $66;	MOV		[WORD PTR DC1],AX
@@OK6:

			MOV		AX,[Y2]
			CMP		AX,[Y3]
			JNE		@@NONFLAT2
	DB $66;	XOR		AX,AX
	DB $66;	MOV		[WORD PTR DX2],AX
	DB $66;	MOV		[WORD PTR DC2],AX
			JMP		@@OK9
@@NONFLAT2:
	DB $66;	DB $0F, $BF, $5E, OFFSET Y3
	DB $66;	DB $0F, $BF, $4E, OFFSET Y2
	DB $66;	SUB		BX,CX

	DB $66;	MOV		AX,[WORD PTR XX3]
	DB $66;	SUB		AX,[WORD PTR XX2]
	DB $66;	CWD
	DB $66;	IDIV	BX
	DB $66;	MOV		[WORD PTR DX2],AX

	DB $66;	MOV		AX,[WORD PTR CC3]
	DB $66;	SUB		AX,[WORD PTR CC2]
	DB $66;	CWD
	DB $66;	IDIV	BX
	DB $66;	MOV		[WORD PTR DC2],AX
@@OK9:

			MOV		AX,[Y1]
			CMP		AX,[Y3]
			JNE		@@NONFLAT3
	DB $66;	XOR		AX,AX
	DB $66;	MOV		[WORD PTR DX3],AX
	DB $66;	MOV		[WORD PTR DC3],AX
			JMP		@@OK12
@@NONFLAT3:
	DB $66;	DB $0F, $BF, $5E, OFFSET Y3
	DB $66;	DB $0F, $BF, $4E, OFFSET Y1
	DB $66;	SUB		BX,CX

	DB $66;	MOV		AX,[WORD PTR XX3]
	DB $66;	SUB		AX,[WORD PTR XX1]
	DB $66;	CWD
	DB $66;	IDIV	BX
	DB $66;	MOV		[WORD PTR DX3],AX

	DB $66;	MOV		AX,[WORD PTR CC3]
	DB $66;	SUB		AX,[WORD PTR CC1]
	DB $66;	CWD
	DB $66;	IDIV	BX
	DB $66;	MOV		[WORD PTR DC3],AX
@@OK12:

	DB $66;	MOV		AX,[WORD PTR XX1]
	DB $66;	MOV		[WORD PTR CX1],AX
	DB $66;	MOV		AX,[WORD PTR CC1]
	DB $66;	MOV		[WORD PTR PC1],AX

			MOV		AX,[Y1]
			CMP		AX,[Y2]
			JNE		@@NONFLAT4
	DB $66;	MOV		AX,[WORD PTR XX2]
	DB $66;	MOV		[WORD PTR CX2],AX
	DB $66;	MOV		AX,[WORD PTR CC2]
	DB $66;	MOV		[WORD PTR PC2],AX
			JMP		@@OK13
@@NONFLAT4:
	DB $66;	MOV		AX,[WORD PTR XX1]
	DB $66;	MOV		[WORD PTR CX2],AX
	DB $66;	MOV		AX,[WORD PTR CC1]
	DB $66;	MOV		[WORD PTR PC2],AX
@@OK13:

			MOV		AX,[Y1]
			MOV		[Y],AX

			MOV		ES,[VideoSeg]
			CMP		AX,[ClipY1]
			JGE		@@OK13_2
			MOV		AX,[ClipY1]
@@OK13_2:
			MOV		DI,AX
			SHL		AX,8
			SHL		DI,6
			ADD		DI,AX
@@LINELOOP:
			MOV		AX,[Y]
			CMP		AX,[ClipY1]
			JL		@@NEXTLINE
			CMP		AX,[ClipY2]
			JG		@@EXIT
			CMP		AX,[Y3]
			JG		@@EXIT
	DB $66;	MOV		AX,[WORD PTR CX1]
	DB $66;	CMP		AX,[WORD PTR CX2]
			JLE		@@OK14
	DB $66;	MOV		[WORD PTR MX2],AX
	DB $66;	MOV		AX,[WORD PTR CX2]
	DB $66;	MOV		[WORD PTR MX1],AX
	DB $66;	MOV		AX,[WORD PTR PC1]
	DB $66;	MOV		[WORD PTR MC2],AX
	DB $66;	MOV		AX,[WORD PTR PC2]
	DB $66;	MOV		[WORD PTR MC1],AX
			JMP		@@OK15
@@OK14:
	DB $66;	MOV		[WORD PTR MX1],AX
	DB $66;	MOV		AX,[WORD PTR CX2]
	DB $66;	MOV		[WORD PTR MX2],AX
	DB $66;	MOV		AX,[WORD PTR PC1]
	DB $66;	MOV		[WORD PTR MC1],AX
	DB $66;	MOV		AX,[WORD PTR PC2]
	DB $66;	MOV		[WORD PTR MC2],AX
@@OK15:

	DB $66;	XOR		CX,CX
	DB $66;	SAR		[WORD PTR MX1],Scaler
	DB $66;	ADC		[WORD PTR MX1],CX
	DB $66;	SAR		[WORD PTR MX2],Scaler
	DB $66;	ADC		[WORD PTR MX2],CX

	DB $66;	MOV		AX,[WORD PTR MX1]
	DB $66;	CMP		AX,[WORD PTR MX2]
			JNE		@@NONFLAT5
	DB $66;	XOR		AX,AX
	DB $66;	MOV		[WORD PTR DCC1],AX
			JMP		@@OK17
@@NONFLAT5:
	DB $66;	MOV		AX,[WORD PTR MC2]
	DB $66;	SUB		AX,[WORD PTR MC1]
	DB $66;	MOV		BX,[WORD PTR MX2]
	DB $66;	SUB		BX,[WORD PTR MX1]
	DB $66;	CWD
	DB $66;	IDIV	BX
	DB $66;	MOV		[WORD PTR DCC1],AX
@@OK17:
			MOV		SI,DI
			MOV		AX,[WORD PTR MX1]
			CMP		AX,[ClipX1]
			JGE		@@OK17_2
			MOV		AX,[ClipX1]
@@OK17_2:
			ADD		DI,AX
@@LOOP1:
			MOV		AX,[WORD PTR MX1]
			CMP		AX,[ClipX1]
			JL		@@NEXTPIXEL
			CMP		AX,[ClipX2]
			JG		@@ENDOFLINE
			CMP		AX,[WORD PTR MX2]
			JG		@@ENDOFLINE

	DB $66;	MOV		AX,[WORD PTR MC1]
	DB $66;	XOR		BX,BX
	DB $66;	SAR     AX,Scaler
	DB $66;	ADC		AX,BX

			MOV		[ES:DI],AL
			INC		DI
@@NEXTPIXEL:
			INC		[WORD PTR MX1]
	DB $66;	MOV		AX,[WORD PTR DCC1]
	DB $66;	ADD		[WORD PTR MC1],AX
			JMP		@@LOOP1
@@ENDOFLINE:
			MOV		DI,SI
			ADD		DI,320
@@NEXTLINE:

	DB $66;	MOV		AX,[WORD PTR DX3]
	DB $66;	ADD		[WORD PTR CX1],AX
	DB $66;	MOV		AX,[WORD PTR DC3]
	DB $66;	ADD		[WORD PTR PC1],AX

			MOV		AX,[Y]
			CMP		AX,[Y2]
			JL		@@TOPPART
	DB $66;	MOV		AX,[WORD PTR DX2]
	DB $66;	ADD		[WORD PTR CX2],AX
	DB $66;	MOV		AX,[WORD PTR DC2]
	DB $66;	ADD		[WORD PTR PC2],AX
			JMP		@@OK18
@@TOPPART:
	DB $66;	MOV		AX,[WORD PTR DX1]
	DB $66;	ADD		[WORD PTR CX2],AX
	DB $66;	MOV		AX,[WORD PTR DC1]
	DB $66;	ADD		[WORD PTR PC2],AX
@@OK18:
			INC		[Y]
			JMP		@@LINELOOP
@@EXIT:
End;

Procedure XTetraGouradSpaceCut(X1,Y1,C1,X2,Y2,C2,X3,Y3,C3 : Integer; VideoSeg : Word; CutMask : Byte); Assembler;
Var
	X,Y			: Integer;
	XX1,XX2,XX3	: LongInt;
	CC1,CC2,CC3	: LongInt;
	DX1,DX2,DX3	: LongInt;
	DC1,DC2,DC3	: LongInt;
	MX1,MX2		: LongInt;
	MC1,MC2		: LongInt;
	PC1,PC2		: LongInt;
	CX1,CX2		: LongInt;
	DCC1		: LongInt;
Asm
			CLD
			MOV		AX,[X1]
			MOV		BX,[Y1]
			MOV		CX,[C1]
			MOV		DX,[X2]
			MOV		SI,[Y2]
			MOV		DI,[C2]

			CMP		BX,SI
			JLE		@@OK1
			XCHG	AX,DX
			XCHG	BX,SI
			XCHG	CX,DI
@@OK1:
			CMP		BX,[Y3]
			JLE		@@OK2
			XCHG	AX,[X3]
			XCHG	BX,[Y3]
			XCHG	CX,[C3]
@@OK2:
			CMP		SI,[Y3]
			JLE		@@OK3
			XCHG	DX,[X3]
			XCHG	SI,[Y3]
			XCHG	DI,[C3]
@@OK3:
			MOV		[X1],AX
			MOV		[Y1],BX
			MOV		[C1],CX
			MOV		[X2],DX
			MOV		[Y2],SI
			MOV		[C2],DI

	DB $66;	DB $0F, $BF, $46, OFFSET X1
	DB $66;	SAL		AX,Scaler
	DB $66;	MOV		[WORD PTR XX1],AX
	DB $66;	DB $0F, $BF, $46, OFFSET X2
	DB $66;	SAL		AX,Scaler
	DB $66;	MOV		[WORD PTR XX2],AX
	DB $66;	DB $0F, $BF, $46, OFFSET X3
	DB $66;	SAL		AX,Scaler
	DB $66;	MOV		[WORD PTR XX3],AX

	DB $66;	DB $0F, $BF, $46, OFFSET C1
	DB $66;	SAL		AX,Scaler
	DB $66;	MOV		[WORD PTR CC1],AX
	DB $66;	DB $0F, $BF, $46, OFFSET C2
	DB $66;	SAL		AX,Scaler
	DB $66;	MOV		[WORD PTR CC2],AX
	DB $66;	DB $0F, $BF, $46, OFFSET C3
	DB $66;	SAL		AX,Scaler
	DB $66;	MOV		[WORD PTR CC3],AX

			MOV		AX,[Y1]
			CMP		AX,[Y2]
			JNE		@@NONFLAT1
	DB $66;	XOR		AX,AX
	DB $66;	MOV		[WORD PTR DX1],AX
	DB $66;	MOV		[WORD PTR DC1],AX
			JMP		@@OK6
@@NONFLAT1:
	DB $66;	DB $0F, $BF, $5E, OFFSET Y2
	DB $66;	DB $0F, $BF, $4E, OFFSET Y1
	DB $66;	SUB		BX,CX

	DB $66;	MOV		AX,[WORD PTR XX2]
	DB $66;	SUB		AX,[WORD PTR XX1]
	DB $66;	CWD
	DB $66;	IDIV	BX
	DB $66;	MOV		[WORD PTR DX1],AX

	DB $66;	MOV		AX,[WORD PTR CC2]
	DB $66;	SUB		AX,[WORD PTR CC1]
	DB $66;	CWD
	DB $66;	IDIV	BX
	DB $66;	MOV		[WORD PTR DC1],AX
@@OK6:

			MOV		AX,[Y2]
			CMP		AX,[Y3]
			JNE		@@NONFLAT2
	DB $66;	XOR		AX,AX
	DB $66;	MOV		[WORD PTR DX2],AX
	DB $66;	MOV		[WORD PTR DC2],AX
			JMP		@@OK9
@@NONFLAT2:
	DB $66;	DB $0F, $BF, $5E, OFFSET Y3
	DB $66;	DB $0F, $BF, $4E, OFFSET Y2
	DB $66;	SUB		BX,CX

	DB $66;	MOV		AX,[WORD PTR XX3]
	DB $66;	SUB		AX,[WORD PTR XX2]
	DB $66;	CWD
	DB $66;	IDIV	BX
	DB $66;	MOV		[WORD PTR DX2],AX

	DB $66;	MOV		AX,[WORD PTR CC3]
	DB $66;	SUB		AX,[WORD PTR CC2]
	DB $66;	CWD
	DB $66;	IDIV	BX
	DB $66;	MOV		[WORD PTR DC2],AX
@@OK9:

			MOV		AX,[Y1]
			CMP		AX,[Y3]
			JNE		@@NONFLAT3
	DB $66;	XOR		AX,AX
	DB $66;	MOV		[WORD PTR DX3],AX
	DB $66;	MOV		[WORD PTR DC3],AX
			JMP		@@OK12
@@NONFLAT3:
	DB $66;	DB $0F, $BF, $5E, OFFSET Y3
	DB $66;	DB $0F, $BF, $4E, OFFSET Y1
	DB $66;	SUB		BX,CX

	DB $66;	MOV		AX,[WORD PTR XX3]
	DB $66;	SUB		AX,[WORD PTR XX1]
	DB $66;	CWD
	DB $66;	IDIV	BX
	DB $66;	MOV		[WORD PTR DX3],AX

	DB $66;	MOV		AX,[WORD PTR CC3]
	DB $66;	SUB		AX,[WORD PTR CC1]
	DB $66;	CWD
	DB $66;	IDIV	BX
	DB $66;	MOV		[WORD PTR DC3],AX
@@OK12:

	DB $66;	MOV		AX,[WORD PTR XX1]
	DB $66;	MOV		[WORD PTR CX1],AX
	DB $66;	MOV		AX,[WORD PTR CC1]
	DB $66;	MOV		[WORD PTR PC1],AX

			MOV		AX,[Y1]
			CMP		AX,[Y2]
			JNE		@@NONFLAT4
	DB $66;	MOV		AX,[WORD PTR XX2]
	DB $66;	MOV		[WORD PTR CX2],AX
	DB $66;	MOV		AX,[WORD PTR CC2]
	DB $66;	MOV		[WORD PTR PC2],AX
			JMP		@@OK13
@@NONFLAT4:
	DB $66;	MOV		AX,[WORD PTR XX1]
	DB $66;	MOV		[WORD PTR CX2],AX
	DB $66;	MOV		AX,[WORD PTR CC1]
	DB $66;	MOV		[WORD PTR PC2],AX
@@OK13:

			MOV		AX,[Y1]
			MOV		[Y],AX

			MOV		ES,[VideoSeg]
			CMP		AX,0
			JGE		@@OK13_2
			XOR		AX,AX
@@OK13_2:
			MOV		DI,AX
			SHL		AX,8
			SHL		DI,6
			ADD		DI,AX
@@LINELOOP:
			MOV		AX,[Y]
			TEST	AX,AX
			JL		@@NEXTLINE
			CMP		AX,199
			JG		@@EXIT
			CMP		AX,[Y3]
			JG		@@EXIT
	DB $66;	MOV		AX,[WORD PTR CX1]
	DB $66;	CMP		AX,[WORD PTR CX2]
			JLE		@@OK14
	DB $66;	MOV		[WORD PTR MX2],AX
	DB $66;	MOV		AX,[WORD PTR CX2]
	DB $66;	MOV		[WORD PTR MX1],AX
	DB $66;	MOV		AX,[WORD PTR PC1]
	DB $66;	MOV		[WORD PTR MC2],AX
	DB $66;	MOV		AX,[WORD PTR PC2]
	DB $66;	MOV		[WORD PTR MC1],AX
			JMP		@@OK15
@@OK14:
	DB $66;	MOV		[WORD PTR MX1],AX
	DB $66;	MOV		AX,[WORD PTR CX2]
	DB $66;	MOV		[WORD PTR MX2],AX
	DB $66;	MOV		AX,[WORD PTR PC1]
	DB $66;	MOV		[WORD PTR MC1],AX
	DB $66;	MOV		AX,[WORD PTR PC2]
	DB $66;	MOV		[WORD PTR MC2],AX
@@OK15:

	DB $66;	XOR		CX,CX
	DB $66;	SAR		[WORD PTR MX1],Scaler
	DB $66;	ADC		[WORD PTR MX1],CX
	DB $66;	SAR		[WORD PTR MX2],Scaler
	DB $66;	ADC		[WORD PTR MX2],CX

	DB $66;	MOV		AX,[WORD PTR MX1]
	DB $66;	CMP		AX,[WORD PTR MX2]
			JNE		@@NONFLAT5
	DB $66;	XOR		AX,AX
	DB $66;	MOV		[WORD PTR DCC1],AX
			JMP		@@OK17
@@NONFLAT5:
	DB $66;	MOV		AX,[WORD PTR MC2]
	DB $66;	SUB		AX,[WORD PTR MC1]
	DB $66;	MOV		BX,[WORD PTR MX2]
	DB $66;	SUB		BX,[WORD PTR MX1]
	DB $66;	CWD
	DB $66;	IDIV	BX
	DB $66;	MOV		[WORD PTR DCC1],AX
@@OK17:
			MOV		SI,DI
			MOV		AX,[WORD PTR MX1]
			CMP		AX,0
			JL		@@LOOP1
			ADD		DI,AX
@@LOOP1:
			MOV		AX,[WORD PTR MX1]
			CMP		AX,0
			JL		@@NEXTPIXEL
			CMP		AX,319
			JG		@@ENDOFLINE
			CMP		AX,[WORD PTR MX2]
			JG		@@ENDOFLINE

	DB $66;	MOV		AX,[WORD PTR MC1]
	DB $66;	XOR		BX,BX
	DB $66;	SAR     AX,Scaler
	DB $66;	ADC		AX,BX

			MOV		BH,[ES:DI]
			AND		BH,[CutMask]
			MOV		BL,AL
			AND		BL,[CutMask]
			CMP		BL,BH
			JBE		@@NOTPLOT
			MOV		[ES:DI],AL
@@NOTPLOT:
			INC		DI
@@NEXTPIXEL:
			INC		[WORD PTR MX1]
	DB $66;	MOV		AX,[WORD PTR DCC1]
	DB $66;	ADD		[WORD PTR MC1],AX
			JMP		@@LOOP1
@@ENDOFLINE:
			MOV		DI,SI
			ADD		DI,320
@@NEXTLINE:

	DB $66;	MOV		AX,[WORD PTR DX3]
	DB $66;	ADD		[WORD PTR CX1],AX
	DB $66;	MOV		AX,[WORD PTR DC3]
	DB $66;	ADD		[WORD PTR PC1],AX

			MOV		AX,[Y]
			CMP		AX,[Y2]
			JL		@@TOPPART
	DB $66;	MOV		AX,[WORD PTR DX2]
	DB $66;	ADD		[WORD PTR CX2],AX
	DB $66;	MOV		AX,[WORD PTR DC2]
	DB $66;	ADD		[WORD PTR PC2],AX
			JMP		@@OK18
@@TOPPART:
	DB $66;	MOV		AX,[WORD PTR DX1]
	DB $66;	ADD		[WORD PTR CX2],AX
	DB $66;	MOV		AX,[WORD PTR DC1]
	DB $66;	ADD		[WORD PTR PC2],AX
@@OK18:
			INC		[Y]
			JMP		@@LINELOOP
@@EXIT:
End;

Procedure XTetraGouradSpaceCutClip(X1,Y1,C1,X2,Y2,C2,X3,Y3,C3,ClipX1,ClipY1,ClipX2,ClipY2 : Integer;
	VideoSeg : Word; CutMask : Byte); Assembler;
Var
	X,Y			: Integer;
	XX1,XX2,XX3	: LongInt;
	CC1,CC2,CC3	: LongInt;
	DX1,DX2,DX3	: LongInt;
	DC1,DC2,DC3	: LongInt;
	MX1,MX2		: LongInt;
	MC1,MC2		: LongInt;
	PC1,PC2		: LongInt;
	CX1,CX2		: LongInt;
	DCC1		: LongInt;
Asm
			CLD
			MOV		AX,[X1]
			MOV		BX,[Y1]
			MOV		CX,[C1]
			MOV		DX,[X2]
			MOV		SI,[Y2]
			MOV		DI,[C2]

			CMP		BX,SI
			JLE		@@OK1
			XCHG	AX,DX
			XCHG	BX,SI
			XCHG	CX,DI
@@OK1:
			CMP		BX,[Y3]
			JLE		@@OK2
			XCHG	AX,[X3]
			XCHG	BX,[Y3]
			XCHG	CX,[C3]
@@OK2:
			CMP		SI,[Y3]
			JLE		@@OK3
			XCHG	DX,[X3]
			XCHG	SI,[Y3]
			XCHG	DI,[C3]
@@OK3:
			MOV		[X1],AX
			MOV		[Y1],BX
			MOV		[C1],CX
			MOV		[X2],DX
			MOV		[Y2],SI
			MOV		[C2],DI

	DB $66;	DB $0F, $BF, $46, OFFSET X1
	DB $66;	SAL		AX,Scaler
	DB $66;	MOV		[WORD PTR XX1],AX
	DB $66;	DB $0F, $BF, $46, OFFSET X2
	DB $66;	SAL		AX,Scaler
	DB $66;	MOV		[WORD PTR XX2],AX
	DB $66;	DB $0F, $BF, $46, OFFSET X3
	DB $66;	SAL		AX,Scaler
	DB $66;	MOV		[WORD PTR XX3],AX

	DB $66;	DB $0F, $BF, $46, OFFSET C1
	DB $66;	SAL		AX,Scaler
	DB $66;	MOV		[WORD PTR CC1],AX
	DB $66;	DB $0F, $BF, $46, OFFSET C2
	DB $66;	SAL		AX,Scaler
	DB $66;	MOV		[WORD PTR CC2],AX
	DB $66;	DB $0F, $BF, $46, OFFSET C3
	DB $66;	SAL		AX,Scaler
	DB $66;	MOV		[WORD PTR CC3],AX

			MOV		AX,[Y1]
			CMP		AX,[Y2]
			JNE		@@NONFLAT1
	DB $66;	XOR		AX,AX
	DB $66;	MOV		[WORD PTR DX1],AX
	DB $66;	MOV		[WORD PTR DC1],AX
			JMP		@@OK6
@@NONFLAT1:
	DB $66;	DB $0F, $BF, $5E, OFFSET Y2
	DB $66;	DB $0F, $BF, $4E, OFFSET Y1
	DB $66;	SUB		BX,CX

	DB $66;	MOV		AX,[WORD PTR XX2]
	DB $66;	SUB		AX,[WORD PTR XX1]
	DB $66;	CWD
	DB $66;	IDIV	BX
	DB $66;	MOV		[WORD PTR DX1],AX

	DB $66;	MOV		AX,[WORD PTR CC2]
	DB $66;	SUB		AX,[WORD PTR CC1]
	DB $66;	CWD
	DB $66;	IDIV	BX
	DB $66;	MOV		[WORD PTR DC1],AX
@@OK6:

			MOV		AX,[Y2]
			CMP		AX,[Y3]
			JNE		@@NONFLAT2
	DB $66;	XOR		AX,AX
	DB $66;	MOV		[WORD PTR DX2],AX
	DB $66;	MOV		[WORD PTR DC2],AX
			JMP		@@OK9
@@NONFLAT2:
	DB $66;	DB $0F, $BF, $5E, OFFSET Y3
	DB $66;	DB $0F, $BF, $4E, OFFSET Y2
	DB $66;	SUB		BX,CX

	DB $66;	MOV		AX,[WORD PTR XX3]
	DB $66;	SUB		AX,[WORD PTR XX2]
	DB $66;	IDIV	BX
	DB $66;	MOV		[WORD PTR DX2],AX

	DB $66;	MOV		AX,[WORD PTR CC3]
	DB $66;	SUB		AX,[WORD PTR CC2]
	DB $66;	CWD
	DB $66;	IDIV	BX
	DB $66;	MOV		[WORD PTR DC2],AX
@@OK9:

			MOV		AX,[Y1]
			CMP		AX,[Y3]
			JNE		@@NONFLAT3
	DB $66;	XOR		AX,AX
	DB $66;	MOV		[WORD PTR DX3],AX
	DB $66;	MOV		[WORD PTR DC3],AX
			JMP		@@OK12
@@NONFLAT3:
	DB $66;	DB $0F, $BF, $5E, OFFSET Y3
	DB $66;	DB $0F, $BF, $4E, OFFSET Y1
	DB $66;	SUB		BX,CX

	DB $66;	MOV		AX,[WORD PTR XX3]
	DB $66;	SUB		AX,[WORD PTR XX1]
	DB $66;	CWD
	DB $66;	IDIV	BX
	DB $66;	MOV		[WORD PTR DX3],AX

	DB $66;	MOV		AX,[WORD PTR CC3]
	DB $66;	SUB		AX,[WORD PTR CC1]
	DB $66;	CWD
	DB $66;	IDIV	BX
	DB $66;	MOV		[WORD PTR DC3],AX
@@OK12:

	DB $66;	MOV		AX,[WORD PTR XX1]
	DB $66;	MOV		[WORD PTR CX1],AX
	DB $66;	MOV		AX,[WORD PTR CC1]
	DB $66;	MOV		[WORD PTR PC1],AX

			MOV		AX,[Y1]
			CMP		AX,[Y2]
			JNE		@@NONFLAT4
	DB $66;	MOV		AX,[WORD PTR XX2]
	DB $66;	MOV		[WORD PTR CX2],AX
	DB $66;	MOV		AX,[WORD PTR CC2]
	DB $66;	MOV		[WORD PTR PC2],AX
			JMP		@@OK13
@@NONFLAT4:
	DB $66;	MOV		AX,[WORD PTR XX1]
	DB $66;	MOV		[WORD PTR CX2],AX
	DB $66;	MOV		AX,[WORD PTR CC1]
	DB $66;	MOV		[WORD PTR PC2],AX
@@OK13:

			MOV		AX,[Y1]
			MOV		[Y],AX

			MOV		ES,[VideoSeg]
			CMP		AX,[ClipY1]
			JGE		@@OK13_2
			MOV		AX,[ClipY1]
@@OK13_2:
			MOV		DI,AX
			SHL		AX,8
			SHL		DI,6
			ADD		DI,AX
@@LINELOOP:
			MOV		AX,[Y]
			CMP		AX,[ClipY1]
			JL		@@NEXTLINE
			CMP		AX,[ClipY2]
			JG		@@EXIT
			CMP		AX,[Y3]
			JG		@@EXIT
	DB $66;	MOV		AX,[WORD PTR CX1]
	DB $66;	CMP		AX,[WORD PTR CX2]
			JLE		@@OK14
	DB $66;	MOV		[WORD PTR MX2],AX
	DB $66;	MOV		AX,[WORD PTR CX2]
	DB $66;	MOV		[WORD PTR MX1],AX
	DB $66;	MOV		AX,[WORD PTR PC1]
	DB $66;	MOV		[WORD PTR MC2],AX
	DB $66;	MOV		AX,[WORD PTR PC2]
	DB $66;	MOV		[WORD PTR MC1],AX
			JMP		@@OK15
@@OK14:
	DB $66;	MOV		[WORD PTR MX1],AX
	DB $66;	MOV		AX,[WORD PTR CX2]
	DB $66;	MOV		[WORD PTR MX2],AX
	DB $66;	MOV		AX,[WORD PTR PC1]
	DB $66;	MOV		[WORD PTR MC1],AX
	DB $66;	MOV		AX,[WORD PTR PC2]
	DB $66;	MOV		[WORD PTR MC2],AX
@@OK15:

	DB $66;	XOR		CX,CX
	DB $66;	SAR		[WORD PTR MX1],Scaler
	DB $66;	ADC		[WORD PTR MX1],CX
	DB $66;	SAR		[WORD PTR MX2],Scaler
	DB $66;	ADC		[WORD PTR MX2],CX

	DB $66;	MOV		AX,[WORD PTR MX1]
	DB $66;	CMP		AX,[WORD PTR MX2]
			JNE		@@NONFLAT5
	DB $66;	XOR		AX,AX
	DB $66;	MOV		[WORD PTR DCC1],AX
			JMP		@@OK17
@@NONFLAT5:
	DB $66;	MOV		AX,[WORD PTR MC2]
	DB $66;	SUB		AX,[WORD PTR MC1]
	DB $66;	MOV		BX,[WORD PTR MX2]
	DB $66;	SUB		BX,[WORD PTR MX1]
	DB $66;	CWD
	DB $66;	IDIV	BX
	DB $66;	MOV		[WORD PTR DCC1],AX
@@OK17:
			MOV		SI,DI
			MOV		AX,[WORD PTR MX1]
			CMP		AX,[ClipX1]
			JGE		@@OK17_2
			MOV		AX,[ClipX1]
@@OK17_2:
			ADD		DI,AX
@@LOOP1:
			MOV		AX,[WORD PTR MX1]
			CMP		AX,[ClipX1]
			JL		@@NEXTPIXEL
			CMP		AX,[ClipX2]
			JG		@@ENDOFLINE
			CMP		AX,[WORD PTR MX2]
			JG		@@ENDOFLINE

	DB $66;	MOV		AX,[WORD PTR MC1]
	DB $66;	XOR		BX,BX
	DB $66;	SAR     AX,Scaler
	DB $66;	ADC		AX,BX

			MOV		BH,[ES:DI]
			AND		BH,[CutMask]
			MOV		BL,AL
			AND		BL,[CutMask]
			CMP		BL,BH
			JBE		@@NOTPLOT
			MOV		[ES:DI],AL
@@NOTPLOT:
			INC		DI
@@NEXTPIXEL:
			INC		[WORD PTR MX1]
	DB $66;	MOV		AX,[WORD PTR DCC1]
	DB $66;	ADD		[WORD PTR MC1],AX
			JMP		@@LOOP1
@@ENDOFLINE:
			MOV		DI,SI
			ADD		DI,320
@@NEXTLINE:

	DB $66;	MOV		AX,[WORD PTR DX3]
	DB $66;	ADD		[WORD PTR CX1],AX
	DB $66;	MOV		AX,[WORD PTR DC3]
	DB $66;	ADD		[WORD PTR PC1],AX

			MOV		AX,[Y]
			CMP		AX,[Y2]
			JL		@@TOPPART
	DB $66;	MOV		AX,[WORD PTR DX2]
	DB $66;	ADD		[WORD PTR CX2],AX
	DB $66;	MOV		AX,[WORD PTR DC2]
	DB $66;	ADD		[WORD PTR PC2],AX
			JMP		@@OK18
@@TOPPART:
	DB $66;	MOV		AX,[WORD PTR DX1]
	DB $66;	ADD		[WORD PTR CX2],AX
	DB $66;	MOV		AX,[WORD PTR DC1]
	DB $66;	ADD		[WORD PTR PC2],AX
@@OK18:
			INC		[Y]
			JMP		@@LINELOOP
@@EXIT:
End;

Procedure XTetraGouradSpaceCutZBuffer(X1,Y1,Z1,C1,X2,Y2,Z2,C2,X3,Y3,Z3,C3 : Integer;
	VideoSeg,ZSeg : Word); Assembler;
Var
	X,Y			: Integer;
	XX1,XX2,XX3	: LongInt;
	CC1,CC2,CC3	: LongInt;
	ZZ1,ZZ2,ZZ3	: LongInt;
	DX1,DX2,DX3	: LongInt;
	DZ1,DZ2,DZ3	: LongInt;
	DC1,DC2,DC3	: LongInt;
	MX1,MX2		: LongInt;
	MC1,MC2		: LongInt;
	MZ1,MZ2		: LongInt;
	PC1,PC2		: LongInt;
	PZ1,PZ2		: LongInt;
	CX1,CX2		: LongInt;
	DCC1		: LongInt;
	DZZ1		: LongInt;
Asm
			CLD
			PUSH	DS
			MOV		DS,[ZSeg]
			MOV		AX,[Y1]
			CMP		AX,[Y2]
			JLE		@@OK1
			XCHG	AX,[Y2]
			MOV		[Y1],AX
			MOV		AX,[X1]
			XCHG	AX,[X2]
			MOV		[X1],AX
			MOV		AX,[C1]
			XCHG	AX,[C2]
			MOV		[C1],AX
			MOV		AX,[Z1]
			XCHG	AX,[Z2]
			MOV		[Z1],AX
@@OK1:
			MOV		AX,[Y1]
			CMP		AX,[Y3]
			JLE		@@OK2
			XCHG	AX,[Y3]
			MOV		[Y1],AX
			MOV		AX,[X1]
			XCHG	AX,[X3]
			MOV		[X1],AX
			MOV		AX,[C1]
			XCHG	AX,[C3]
			MOV		[C1],AX
			MOV		AX,[Z1]
			XCHG	AX,[Z3]
			MOV		[Z1],AX
@@OK2:
			MOV		AX,[Y2]
			CMP		AX,[Y3]
			JLE		@@OK3
			XCHG	AX,[Y3]
			MOV		[Y2],AX
			MOV		AX,[X2]
			XCHG	AX,[X3]
			MOV		[X2],AX
			MOV		AX,[C2]
			XCHG	AX,[C3]
			MOV		[C2],AX
			MOV		AX,[Z2]
			XCHG	AX,[Z3]
			MOV		[Z2],AX
@@OK3:

	DB $66;	DB $0F, $BF, $46, OFFSET X1
	DB $66;	SAL		AX,Scaler
	DB $66;	MOV		[WORD PTR XX1],AX
	DB $66;	DB $0F, $BF, $46, OFFSET X2
	DB $66;	SAL		AX,Scaler
	DB $66;	MOV		[WORD PTR XX2],AX
	DB $66;	DB $0F, $BF, $46, OFFSET X3
	DB $66;	SAL		AX,Scaler
	DB $66;	MOV		[WORD PTR XX3],AX

	DB $66;	DB $0F, $BF, $46, OFFSET C1
	DB $66;	SAL		AX,Scaler
	DB $66;	MOV		[WORD PTR CC1],AX
	DB $66;	DB $0F, $BF, $46, OFFSET C2
	DB $66;	SAL		AX,Scaler
	DB $66;	MOV		[WORD PTR CC2],AX
	DB $66;	DB $0F, $BF, $46, OFFSET C3
	DB $66;	SAL		AX,Scaler
	DB $66;	MOV		[WORD PTR CC3],AX

	DB $66;	DB $0F, $BF, $46, OFFSET Z1
	DB $66;	SAL		AX,Scaler
	DB $66;	MOV		[WORD PTR ZZ1],AX
	DB $66;	DB $0F, $BF, $46, OFFSET Z2
	DB $66;	SAL		AX,Scaler
	DB $66;	MOV		[WORD PTR ZZ2],AX
	DB $66;	DB $0F, $BF, $46, OFFSET Z3
	DB $66;	SAL		AX,Scaler
	DB $66;	MOV		[WORD PTR ZZ3],AX

			MOV		AX,[Y1]
			CMP		AX,[Y2]
			JNE		@@NONFLAT1
	DB $66;	XOR		AX,AX
	DB $66;	MOV		[WORD PTR DX1],AX
	DB $66;	MOV		[WORD PTR DC1],AX
	DB $66;	MOV		[WORD PTR DZ1],AX
			JMP		@@OK6
@@NONFLAT1:
	DB $66;	DB $0F, $BF, $5E, OFFSET Y2
	DB $66;	DB $0F, $BF, $4E, OFFSET Y1
	DB $66;	SUB		BX,CX

	DB $66;	MOV		AX,[WORD PTR XX2]
	DB $66;	SUB		AX,[WORD PTR XX1]
	DB $66;	CWD
	DB $66;	IDIV	BX
	DB $66;	MOV		[WORD PTR DX1],AX

	DB $66;	MOV		AX,[WORD PTR CC2]
	DB $66;	SUB		AX,[WORD PTR CC1]
	DB $66;	CWD
	DB $66;	IDIV	BX
	DB $66;	MOV		[WORD PTR DC1],AX
	DB $66;	MOV		AX,[WORD PTR ZZ2]
	DB $66;	SUB		AX,[WORD PTR ZZ1]
	DB $66;	CWD
	DB $66;	IDIV	BX
	DB $66;	MOV		[WORD PTR DZ1],AX

@@OK6:

			MOV		AX,[Y2]
			CMP		AX,[Y3]
			JNE		@@NONFLAT2
	DB $66;	XOR		AX,AX
	DB $66;	MOV		[WORD PTR DX2],AX
	DB $66;	MOV		[WORD PTR DC2],AX
	DB $66;	MOV		[WORD PTR DZ2],AX
			JMP		@@OK9
@@NONFLAT2:
	DB $66;	DB $0F, $BF, $5E, OFFSET Y3
	DB $66;	DB $0F, $BF, $4E, OFFSET Y2
	DB $66;	SUB		BX,CX

	DB $66;	MOV		AX,[WORD PTR XX3]
	DB $66;	SUB		AX,[WORD PTR XX2]
	DB $66;	CWD
	DB $66;	IDIV	BX
	DB $66;	MOV		[WORD PTR DX2],AX

	DB $66;	MOV		AX,[WORD PTR CC3]
	DB $66;	SUB		AX,[WORD PTR CC2]
	DB $66;	CWD
	DB $66;	IDIV	BX
	DB $66;	MOV		[WORD PTR DC2],AX

	DB $66;	MOV		AX,[WORD PTR ZZ3]
	DB $66;	SUB		AX,[WORD PTR ZZ2]
	DB $66;	CWD
	DB $66;	IDIV	BX
	DB $66;	MOV		[WORD PTR DZ2],AX
@@OK9:

			MOV		AX,[Y1]
			CMP		AX,[Y3]
			JNE		@@NONFLAT3
	DB $66;	XOR		AX,AX
	DB $66;	MOV		[WORD PTR DX3],AX
	DB $66;	MOV		[WORD PTR DC3],AX
	DB $66;	MOV		[WORD PTR DZ3],AX
			JMP		@@OK12
@@NONFLAT3:
	DB $66;	DB $0F, $BF, $5E, OFFSET Y3
	DB $66;	DB $0F, $BF, $4E, OFFSET Y1
	DB $66;	SUB		BX,CX

	DB $66;	MOV		AX,[WORD PTR XX3]
	DB $66;	SUB		AX,[WORD PTR XX1]
	DB $66;	CWD
	DB $66;	IDIV	BX
	DB $66;	MOV		[WORD PTR DX3],AX

	DB $66;	MOV		AX,[WORD PTR CC3]
	DB $66;	SUB		AX,[WORD PTR CC1]
	DB $66;	CWD
	DB $66;	IDIV	BX
	DB $66;	MOV		[WORD PTR DC3],AX

	DB $66;	MOV		AX,[WORD PTR ZZ3]
	DB $66;	SUB		AX,[WORD PTR ZZ1]
	DB $66;	CWD
	DB $66;	IDIV	BX
	DB $66;	MOV		[WORD PTR DZ3],AX
@@OK12:

	DB $66;	MOV		AX,[WORD PTR XX1]
	DB $66;	MOV		[WORD PTR CX1],AX
	DB $66;	MOV		AX,[WORD PTR CC1]
	DB $66;	MOV		[WORD PTR PC1],AX
	DB $66;	MOV		AX,[WORD PTR ZZ1]
	DB $66;	MOV		[WORD PTR PZ1],AX

			MOV		AX,[Y1]
			CMP		AX,[Y2]
			JNE		@@NONFLAT4
	DB $66;	MOV		AX,[WORD PTR XX2]
	DB $66;	MOV		[WORD PTR CX2],AX
	DB $66;	MOV		AX,[WORD PTR CC2]
	DB $66;	MOV		[WORD PTR PC2],AX
	DB $66;	MOV		AX,[WORD PTR ZZ2]
	DB $66;	MOV		[WORD PTR PZ2],AX
			JMP		@@OK13
@@NONFLAT4:
	DB $66;	MOV		AX,[WORD PTR XX1]
	DB $66;	MOV		[WORD PTR CX2],AX
	DB $66;	MOV		AX,[WORD PTR CC1]
	DB $66;	MOV		[WORD PTR PC2],AX
	DB $66;	MOV		AX,[WORD PTR ZZ1]
	DB $66;	MOV		[WORD PTR PZ2],AX
@@OK13:

			MOV		AX,[Y1]
			MOV		[Y],AX

			MOV		ES,[VideoSeg]
			CMP		AX,0
			JGE		@@OK13_2
			XOR		AX,AX
@@OK13_2:
			MOV		DI,AX
			SHL		AX,8
			SHL		DI,6
			ADD		DI,AX
@@LINELOOP:
			MOV		AX,[Y]
			TEST	AX,AX
			JL		@@NEXTLINE
			CMP		AX,199
			JG		@@EXIT
			CMP		AX,[Y3]
			JG		@@EXIT
	DB $66;	MOV		AX,[WORD PTR CX1]
	DB $66;	CMP		AX,[WORD PTR CX2]
			JLE		@@OK14
	DB $66;	MOV		[WORD PTR MX2],AX
	DB $66;	MOV		AX,[WORD PTR CX2]
	DB $66;	MOV		[WORD PTR MX1],AX
	DB $66;	MOV		AX,[WORD PTR PC1]
	DB $66;	MOV		[WORD PTR MC2],AX
	DB $66;	MOV		AX,[WORD PTR PC2]
	DB $66;	MOV		[WORD PTR MC1],AX
	DB $66;	MOV		AX,[WORD PTR PZ1]
	DB $66;	MOV		[WORD PTR MZ2],AX
	DB $66;	MOV		AX,[WORD PTR PZ2]
	DB $66;	MOV		[WORD PTR MZ1],AX
			JMP		@@OK15
@@OK14:
	DB $66;	MOV		[WORD PTR MX1],AX
	DB $66;	MOV		AX,[WORD PTR CX2]
	DB $66;	MOV		[WORD PTR MX2],AX
	DB $66;	MOV		AX,[WORD PTR PC1]
	DB $66;	MOV		[WORD PTR MC1],AX
	DB $66;	MOV		AX,[WORD PTR PC2]
	DB $66;	MOV		[WORD PTR MC2],AX
	DB $66;	MOV		AX,[WORD PTR PZ1]
	DB $66;	MOV		[WORD PTR MZ1],AX
	DB $66;	MOV		AX,[WORD PTR PZ2]
	DB $66;	MOV		[WORD PTR MZ2],AX
@@OK15:

	DB $66;	XOR		CX,CX
	DB $66;	SAR		[WORD PTR MX1],Scaler
	DB $66;	ADC		[WORD PTR MX1],CX
	DB $66;	SAR		[WORD PTR MX2],Scaler
	DB $66;	ADC		[WORD PTR MX2],CX

	DB $66;	MOV		AX,[WORD PTR MX1]
	DB $66;	CMP		AX,[WORD PTR MX2]
			JNE		@@NONFLAT5
	DB $66;	XOR		AX,AX
	DB $66;	MOV		[WORD PTR DCC1],AX
	DB $66;	MOV		[WORD PTR DZZ1],AX
			JMP		@@OK17
@@NONFLAT5:
	DB $66;	MOV		BX,[WORD PTR MX2]
	DB $66;	SUB		BX,[WORD PTR MX1]
	DB $66;	MOV		AX,[WORD PTR MC2]
	DB $66;	SUB		AX,[WORD PTR MC1]
	DB $66;	CWD
	DB $66;	IDIV	BX
	DB $66;	MOV		[WORD PTR DCC1],AX

	DB $66;	MOV		AX,[WORD PTR MZ2]
	DB $66;	SUB		AX,[WORD PTR MZ1]
	DB $66;	CWD
	DB $66;	IDIV	BX
	DB $66;	MOV		[WORD PTR DZZ1],AX
@@OK17:
			MOV		SI,DI
			MOV		AX,[WORD PTR MX1]
			CMP		AX,0
			JL		@@LOOP1
			ADD		DI,AX
@@LOOP1:
			MOV		AX,[WORD PTR MX1]
			CMP		AX,0
			JL		@@NEXTPIXEL
			CMP		AX,319
			JG		@@ENDOFLINE
			CMP		AX,[WORD PTR MX2]
			JG		@@ENDOFLINE

	DB $66;	MOV		AX,[WORD PTR MC1]
	DB $66;	XOR		BX,BX
	DB $66;	SAR     AX,Scaler
	DB $66;	ADC		AX,BX

	DB $66;	MOV		CX,[WORD PTR MZ1]
	DB $66;	SAR		CX,Scaler
	DB $66;	ADC		CX,BX

			CMP		CL,[DS:DI]
			JBE		@@NOTPLOT

			MOV		[ES:DI],AL
			MOV		[DS:DI],CL
@@NOTPLOT:
			INC		DI
@@NEXTPIXEL:
			INC		[WORD PTR MX1]
	DB $66;	MOV		AX,[WORD PTR DCC1]
	DB $66;	ADD		[WORD PTR MC1],AX
	DB $66;	MOV		AX,[WORD PTR DZZ1]
	DB $66;	ADD		[WORD PTR MZ1],AX
			JMP		@@LOOP1
@@ENDOFLINE:
			MOV		DI,SI
			ADD		DI,320
@@NEXTLINE:

	DB $66;	MOV		AX,[WORD PTR DX3]
	DB $66;	ADD		[WORD PTR CX1],AX
	DB $66;	MOV		AX,[WORD PTR DC3]
	DB $66;	ADD		[WORD PTR PC1],AX
	DB $66;	MOV		AX,[WORD PTR DZ3]
	DB $66;	ADD		[WORD PTR PZ1],AX

			MOV		AX,[Y]
			CMP		AX,[Y2]
			JL		@@TOPPART
	DB $66;	MOV		AX,[WORD PTR DX2]
	DB $66;	ADD		[WORD PTR CX2],AX
	DB $66;	MOV		AX,[WORD PTR DC2]
	DB $66;	ADD		[WORD PTR PC2],AX
	DB $66;	MOV		AX,[WORD PTR DZ2]
	DB $66;	ADD		[WORD PTR PZ2],AX
			JMP		@@OK18
@@TOPPART:
	DB $66;	MOV		AX,[WORD PTR DX1]
	DB $66;	ADD		[WORD PTR CX2],AX
	DB $66;	MOV		AX,[WORD PTR DC1]
	DB $66;	ADD		[WORD PTR PC2],AX
	DB $66;	MOV		AX,[WORD PTR DZ1]
	DB $66;	ADD		[WORD PTR PZ2],AX
@@OK18:
			INC		[Y]
			JMP		@@LINELOOP
@@EXIT:
			POP		DS
End;

Procedure XTetraGouradGlenzADDSpaceCutZBuffer(X1,Y1,Z1,C1,X2,Y2,Z2,C2,X3,Y3,Z3,C3 : Integer;
	VideoSeg,ZSeg : Word); Assembler;
Var
	X,Y			: Integer;
	XX1,XX2,XX3	: LongInt;
	CC1,CC2,CC3	: LongInt;
	ZZ1,ZZ2,ZZ3	: LongInt;
	DX1,DX2,DX3	: LongInt;
	DZ1,DZ2,DZ3	: LongInt;
	DC1,DC2,DC3	: LongInt;
	MX1,MX2		: LongInt;
	MC1,MC2		: LongInt;
	MZ1,MZ2		: LongInt;
	PC1,PC2		: LongInt;
	PZ1,PZ2		: LongInt;
	CX1,CX2		: LongInt;
	DCC1		: LongInt;
	DZZ1		: LongInt;
Asm
			CLD
			PUSH	DS
			MOV		DS,[ZSeg]
			MOV		AX,[Y1]
			CMP		AX,[Y2]
			JLE		@@OK1
			XCHG	AX,[Y2]
			MOV		[Y1],AX
			MOV		AX,[X1]
			XCHG	AX,[X2]
			MOV		[X1],AX
			MOV		AX,[C1]
			XCHG	AX,[C2]
			MOV		[C1],AX
			MOV		AX,[Z1]
			XCHG	AX,[Z2]
			MOV		[Z1],AX
@@OK1:
			MOV		AX,[Y1]
			CMP		AX,[Y3]
			JLE		@@OK2
			XCHG	AX,[Y3]
			MOV		[Y1],AX
			MOV		AX,[X1]
			XCHG	AX,[X3]
			MOV		[X1],AX
			MOV		AX,[C1]
			XCHG	AX,[C3]
			MOV		[C1],AX
			MOV		AX,[Z1]
			XCHG	AX,[Z3]
			MOV		[Z1],AX
@@OK2:
			MOV		AX,[Y2]
			CMP		AX,[Y3]
			JLE		@@OK3
			XCHG	AX,[Y3]
			MOV		[Y2],AX
			MOV		AX,[X2]
			XCHG	AX,[X3]
			MOV		[X2],AX
			MOV		AX,[C2]
			XCHG	AX,[C3]
			MOV		[C2],AX
			MOV		AX,[Z2]
			XCHG	AX,[Z3]
			MOV		[Z2],AX
@@OK3:

	DB $66;	DB $0F, $BF, $46, OFFSET X1
	DB $66;	SAL		AX,Scaler
	DB $66;	MOV		[WORD PTR XX1],AX
	DB $66;	DB $0F, $BF, $46, OFFSET X2
	DB $66;	SAL		AX,Scaler
	DB $66;	MOV		[WORD PTR XX2],AX
	DB $66;	DB $0F, $BF, $46, OFFSET X3
	DB $66;	SAL		AX,Scaler
	DB $66;	MOV		[WORD PTR XX3],AX

	DB $66;	DB $0F, $BF, $46, OFFSET C1
	DB $66;	SAL		AX,Scaler
	DB $66;	MOV		[WORD PTR CC1],AX
	DB $66;	DB $0F, $BF, $46, OFFSET C2
	DB $66;	SAL		AX,Scaler
	DB $66;	MOV		[WORD PTR CC2],AX
	DB $66;	DB $0F, $BF, $46, OFFSET C3
	DB $66;	SAL		AX,Scaler
	DB $66;	MOV		[WORD PTR CC3],AX

	DB $66;	DB $0F, $BF, $46, OFFSET Z1
	DB $66;	SAL		AX,Scaler
	DB $66;	MOV		[WORD PTR ZZ1],AX
	DB $66;	DB $0F, $BF, $46, OFFSET Z2
	DB $66;	SAL		AX,Scaler
	DB $66;	MOV		[WORD PTR ZZ2],AX
	DB $66;	DB $0F, $BF, $46, OFFSET Z3
	DB $66;	SAL		AX,Scaler
	DB $66;	MOV		[WORD PTR ZZ3],AX

			MOV		AX,[Y1]
			CMP		AX,[Y2]
			JNE		@@NONFLAT1
	DB $66;	XOR		AX,AX
	DB $66;	MOV		[WORD PTR DX1],AX
	DB $66;	MOV		[WORD PTR DC1],AX
	DB $66;	MOV		[WORD PTR DZ1],AX
			JMP		@@OK6
@@NONFLAT1:
	DB $66;	DB $0F, $BF, $5E, OFFSET Y2
	DB $66;	DB $0F, $BF, $4E, OFFSET Y1
	DB $66;	SUB		BX,CX

	DB $66;	MOV		AX,[WORD PTR XX2]
	DB $66;	SUB		AX,[WORD PTR XX1]
	DB $66;	CWD
	DB $66;	IDIV	BX
	DB $66;	MOV		[WORD PTR DX1],AX

	DB $66;	MOV		AX,[WORD PTR CC2]
	DB $66;	SUB		AX,[WORD PTR CC1]
	DB $66;	CWD
	DB $66;	IDIV	BX
	DB $66;	MOV		[WORD PTR DC1],AX
	DB $66;	MOV		AX,[WORD PTR ZZ2]
	DB $66;	SUB		AX,[WORD PTR ZZ1]
	DB $66;	CWD
	DB $66;	IDIV	BX
	DB $66;	MOV		[WORD PTR DZ1],AX

@@OK6:

			MOV		AX,[Y2]
			CMP		AX,[Y3]
			JNE		@@NONFLAT2
	DB $66;	XOR		AX,AX
	DB $66;	MOV		[WORD PTR DX2],AX
	DB $66;	MOV		[WORD PTR DC2],AX
	DB $66;	MOV		[WORD PTR DZ2],AX
			JMP		@@OK9
@@NONFLAT2:
	DB $66;	DB $0F, $BF, $5E, OFFSET Y3
	DB $66;	DB $0F, $BF, $4E, OFFSET Y2
	DB $66;	SUB		BX,CX

	DB $66;	MOV		AX,[WORD PTR XX3]
	DB $66;	SUB		AX,[WORD PTR XX2]
	DB $66;	CWD
	DB $66;	IDIV	BX
	DB $66;	MOV		[WORD PTR DX2],AX

	DB $66;	MOV		AX,[WORD PTR CC3]
	DB $66;	SUB		AX,[WORD PTR CC2]
	DB $66;	CWD
	DB $66;	IDIV	BX
	DB $66;	MOV		[WORD PTR DC2],AX

	DB $66;	MOV		AX,[WORD PTR ZZ3]
	DB $66;	SUB		AX,[WORD PTR ZZ2]
	DB $66;	CWD
	DB $66;	IDIV	BX
	DB $66;	MOV		[WORD PTR DZ2],AX
@@OK9:

			MOV		AX,[Y1]
			CMP		AX,[Y3]
			JNE		@@NONFLAT3
	DB $66;	XOR		AX,AX
	DB $66;	MOV		[WORD PTR DX3],AX
	DB $66;	MOV		[WORD PTR DC3],AX
	DB $66;	MOV		[WORD PTR DZ3],AX
			JMP		@@OK12
@@NONFLAT3:
	DB $66;	DB $0F, $BF, $5E, OFFSET Y3
	DB $66;	DB $0F, $BF, $4E, OFFSET Y1
	DB $66;	SUB		BX,CX

	DB $66;	MOV		AX,[WORD PTR XX3]
	DB $66;	SUB		AX,[WORD PTR XX1]
	DB $66;	CWD
	DB $66;	IDIV	BX
	DB $66;	MOV		[WORD PTR DX3],AX

	DB $66;	MOV		AX,[WORD PTR CC3]
	DB $66;	SUB		AX,[WORD PTR CC1]
	DB $66;	CWD
	DB $66;	IDIV	BX
	DB $66;	MOV		[WORD PTR DC3],AX

	DB $66;	MOV		AX,[WORD PTR ZZ3]
	DB $66;	SUB		AX,[WORD PTR ZZ1]
	DB $66;	CWD
	DB $66;	IDIV	BX
	DB $66;	MOV		[WORD PTR DZ3],AX
@@OK12:

	DB $66;	MOV		AX,[WORD PTR XX1]
	DB $66;	MOV		[WORD PTR CX1],AX
	DB $66;	MOV		AX,[WORD PTR CC1]
	DB $66;	MOV		[WORD PTR PC1],AX
	DB $66;	MOV		AX,[WORD PTR ZZ1]
	DB $66;	MOV		[WORD PTR PZ1],AX

			MOV		AX,[Y1]
			CMP		AX,[Y2]
			JNE		@@NONFLAT4
	DB $66;	MOV		AX,[WORD PTR XX2]
	DB $66;	MOV		[WORD PTR CX2],AX
	DB $66;	MOV		AX,[WORD PTR CC2]
	DB $66;	MOV		[WORD PTR PC2],AX
	DB $66;	MOV		AX,[WORD PTR ZZ2]
	DB $66;	MOV		[WORD PTR PZ2],AX
			JMP		@@OK13
@@NONFLAT4:
	DB $66;	MOV		AX,[WORD PTR XX1]
	DB $66;	MOV		[WORD PTR CX2],AX
	DB $66;	MOV		AX,[WORD PTR CC1]
	DB $66;	MOV		[WORD PTR PC2],AX
	DB $66;	MOV		AX,[WORD PTR ZZ1]
	DB $66;	MOV		[WORD PTR PZ2],AX
@@OK13:

			MOV		AX,[Y1]
			MOV		[Y],AX

			MOV		ES,[VideoSeg]
			CMP		AX,0
			JGE		@@OK13_2
			XOR		AX,AX
@@OK13_2:
			MOV		DI,AX
			SHL		AX,8
			SHL		DI,6
			ADD		DI,AX
@@LINELOOP:
			MOV		AX,[Y]
			TEST	AX,AX
			JL		@@NEXTLINE
			CMP		AX,199
			JG		@@EXIT
			CMP		AX,[Y3]
			JG		@@EXIT
	DB $66;	MOV		AX,[WORD PTR CX1]
	DB $66;	CMP		AX,[WORD PTR CX2]
			JLE		@@OK14
	DB $66;	MOV		[WORD PTR MX2],AX
	DB $66;	MOV		AX,[WORD PTR CX2]
	DB $66;	MOV		[WORD PTR MX1],AX
	DB $66;	MOV		AX,[WORD PTR PC1]
	DB $66;	MOV		[WORD PTR MC2],AX
	DB $66;	MOV		AX,[WORD PTR PC2]
	DB $66;	MOV		[WORD PTR MC1],AX
	DB $66;	MOV		AX,[WORD PTR PZ1]
	DB $66;	MOV		[WORD PTR MZ2],AX
	DB $66;	MOV		AX,[WORD PTR PZ2]
	DB $66;	MOV		[WORD PTR MZ1],AX
			JMP		@@OK15
@@OK14:
	DB $66;	MOV		[WORD PTR MX1],AX
	DB $66;	MOV		AX,[WORD PTR CX2]
	DB $66;	MOV		[WORD PTR MX2],AX
	DB $66;	MOV		AX,[WORD PTR PC1]
	DB $66;	MOV		[WORD PTR MC1],AX
	DB $66;	MOV		AX,[WORD PTR PC2]
	DB $66;	MOV		[WORD PTR MC2],AX
	DB $66;	MOV		AX,[WORD PTR PZ1]
	DB $66;	MOV		[WORD PTR MZ1],AX
	DB $66;	MOV		AX,[WORD PTR PZ2]
	DB $66;	MOV		[WORD PTR MZ2],AX
@@OK15:

	DB $66;	XOR		CX,CX
	DB $66;	SAR		[WORD PTR MX1],Scaler
	DB $66;	ADC		[WORD PTR MX1],CX
	DB $66;	SAR		[WORD PTR MX2],Scaler
	DB $66;	ADC		[WORD PTR MX2],CX

	DB $66;	MOV		AX,[WORD PTR MX1]
	DB $66;	CMP		AX,[WORD PTR MX2]
			JNE		@@NONFLAT5
	DB $66;	XOR		AX,AX
	DB $66;	MOV		[WORD PTR DCC1],AX
	DB $66;	MOV		[WORD PTR DZZ1],AX
			JMP		@@OK17
@@NONFLAT5:
	DB $66;	MOV		BX,[WORD PTR MX2]
	DB $66;	SUB		BX,[WORD PTR MX1]
	DB $66;	MOV		AX,[WORD PTR MC2]
	DB $66;	SUB		AX,[WORD PTR MC1]
	DB $66;	CWD
	DB $66;	IDIV	BX
	DB $66;	MOV		[WORD PTR DCC1],AX

	DB $66;	MOV		AX,[WORD PTR MZ2]
	DB $66;	SUB		AX,[WORD PTR MZ1]
	DB $66;	CWD
	DB $66;	IDIV	BX
	DB $66;	MOV		[WORD PTR DZZ1],AX
@@OK17:
			MOV		SI,DI
			MOV		AX,[WORD PTR MX1]
			CMP		AX,0
			JL		@@LOOP1
			ADD		DI,AX
@@LOOP1:
			MOV		AX,[WORD PTR MX1]
			CMP		AX,0
			JL		@@NEXTPIXEL
			CMP		AX,319
			JG		@@ENDOFLINE
			CMP		AX,[WORD PTR MX2]
			JG		@@ENDOFLINE

	DB $66;	MOV		AX,[WORD PTR MC1]
	DB $66;	XOR		BX,BX
	DB $66;	SAR     AX,Scaler
	DB $66;	ADC		AX,BX

	DB $66;	MOV		CX,[WORD PTR MZ1]
	DB $66;	SAR		CX,Scaler
	DB $66;	ADC		CX,BX

			CMP		CL,[DS:DI]
			JBE		@@NOTPLOT

			ADD		[ES:DI],AL
			MOV		[DS:DI],CL
@@NOTPLOT:
			INC		DI
@@NEXTPIXEL:
			INC		[WORD PTR MX1]
	DB $66;	MOV		AX,[WORD PTR DCC1]
	DB $66;	ADD		[WORD PTR MC1],AX
	DB $66;	MOV		AX,[WORD PTR DZZ1]
	DB $66;	ADD		[WORD PTR MZ1],AX
			JMP		@@LOOP1
@@ENDOFLINE:
			MOV		DI,SI
			ADD		DI,320
@@NEXTLINE:

	DB $66;	MOV		AX,[WORD PTR DX3]
	DB $66;	ADD		[WORD PTR CX1],AX
	DB $66;	MOV		AX,[WORD PTR DC3]
	DB $66;	ADD		[WORD PTR PC1],AX
	DB $66;	MOV		AX,[WORD PTR DZ3]
	DB $66;	ADD		[WORD PTR PZ1],AX

			MOV		AX,[Y]
			CMP		AX,[Y2]
			JL		@@TOPPART
	DB $66;	MOV		AX,[WORD PTR DX2]
	DB $66;	ADD		[WORD PTR CX2],AX
	DB $66;	MOV		AX,[WORD PTR DC2]
	DB $66;	ADD		[WORD PTR PC2],AX
	DB $66;	MOV		AX,[WORD PTR DZ2]
	DB $66;	ADD		[WORD PTR PZ2],AX
			JMP		@@OK18
@@TOPPART:
	DB $66;	MOV		AX,[WORD PTR DX1]
	DB $66;	ADD		[WORD PTR CX2],AX
	DB $66;	MOV		AX,[WORD PTR DC1]
	DB $66;	ADD		[WORD PTR PC2],AX
	DB $66;	MOV		AX,[WORD PTR DZ1]
	DB $66;	ADD		[WORD PTR PZ2],AX
@@OK18:
			INC		[Y]
			JMP		@@LINELOOP
@@EXIT:
			POP		DS
End;

Procedure XTetraGouradGlenzORSpaceCutZBuffer(X1,Y1,Z1,C1,X2,Y2,Z2,C2,X3,Y3,Z3,C3 : Integer;
	VideoSeg,ZSeg : Word); Assembler;
Var
	X,Y			: Integer;
	XX1,XX2,XX3	: LongInt;
	CC1,CC2,CC3	: LongInt;
	ZZ1,ZZ2,ZZ3	: LongInt;
	DX1,DX2,DX3	: LongInt;
	DZ1,DZ2,DZ3	: LongInt;
	DC1,DC2,DC3	: LongInt;
	MX1,MX2		: LongInt;
	MC1,MC2		: LongInt;
	MZ1,MZ2		: LongInt;
	PC1,PC2		: LongInt;
	PZ1,PZ2		: LongInt;
	CX1,CX2		: LongInt;
	DCC1		: LongInt;
	DZZ1		: LongInt;
Asm
			CLD
			PUSH	DS
			MOV		DS,[ZSeg]
			MOV		AX,[Y1]
			CMP		AX,[Y2]
			JLE		@@OK1
			XCHG	AX,[Y2]
			MOV		[Y1],AX
			MOV		AX,[X1]
			XCHG	AX,[X2]
			MOV		[X1],AX
			MOV		AX,[C1]
			XCHG	AX,[C2]
			MOV		[C1],AX
			MOV		AX,[Z1]
			XCHG	AX,[Z2]
			MOV		[Z1],AX
@@OK1:
			MOV		AX,[Y1]
			CMP		AX,[Y3]
			JLE		@@OK2
			XCHG	AX,[Y3]
			MOV		[Y1],AX
			MOV		AX,[X1]
			XCHG	AX,[X3]
			MOV		[X1],AX
			MOV		AX,[C1]
			XCHG	AX,[C3]
			MOV		[C1],AX
			MOV		AX,[Z1]
			XCHG	AX,[Z3]
			MOV		[Z1],AX
@@OK2:
			MOV		AX,[Y2]
			CMP		AX,[Y3]
			JLE		@@OK3
			XCHG	AX,[Y3]
			MOV		[Y2],AX
			MOV		AX,[X2]
			XCHG	AX,[X3]
			MOV		[X2],AX
			MOV		AX,[C2]
			XCHG	AX,[C3]
			MOV		[C2],AX
			MOV		AX,[Z2]
			XCHG	AX,[Z3]
			MOV		[Z2],AX
@@OK3:

	DB $66;	DB $0F, $BF, $46, OFFSET X1
	DB $66;	SAL		AX,Scaler
	DB $66;	MOV		[WORD PTR XX1],AX
	DB $66;	DB $0F, $BF, $46, OFFSET X2
	DB $66;	SAL		AX,Scaler
	DB $66;	MOV		[WORD PTR XX2],AX
	DB $66;	DB $0F, $BF, $46, OFFSET X3
	DB $66;	SAL		AX,Scaler
	DB $66;	MOV		[WORD PTR XX3],AX

	DB $66;	DB $0F, $BF, $46, OFFSET C1
	DB $66;	SAL		AX,Scaler
	DB $66;	MOV		[WORD PTR CC1],AX
	DB $66;	DB $0F, $BF, $46, OFFSET C2
	DB $66;	SAL		AX,Scaler
	DB $66;	MOV		[WORD PTR CC2],AX
	DB $66;	DB $0F, $BF, $46, OFFSET C3
	DB $66;	SAL		AX,Scaler
	DB $66;	MOV		[WORD PTR CC3],AX

	DB $66;	DB $0F, $BF, $46, OFFSET Z1
	DB $66;	SAL		AX,Scaler
	DB $66;	MOV		[WORD PTR ZZ1],AX
	DB $66;	DB $0F, $BF, $46, OFFSET Z2
	DB $66;	SAL		AX,Scaler
	DB $66;	MOV		[WORD PTR ZZ2],AX
	DB $66;	DB $0F, $BF, $46, OFFSET Z3
	DB $66;	SAL		AX,Scaler
	DB $66;	MOV		[WORD PTR ZZ3],AX

			MOV		AX,[Y1]
			CMP		AX,[Y2]
			JNE		@@NONFLAT1
	DB $66;	XOR		AX,AX
	DB $66;	MOV		[WORD PTR DX1],AX
	DB $66;	MOV		[WORD PTR DC1],AX
	DB $66;	MOV		[WORD PTR DZ1],AX
			JMP		@@OK6
@@NONFLAT1:
	DB $66;	DB $0F, $BF, $5E, OFFSET Y2
	DB $66;	DB $0F, $BF, $4E, OFFSET Y1
	DB $66;	SUB		BX,CX

	DB $66;	MOV		AX,[WORD PTR XX2]
	DB $66;	SUB		AX,[WORD PTR XX1]
	DB $66;	CWD
	DB $66;	IDIV	BX
	DB $66;	MOV		[WORD PTR DX1],AX

	DB $66;	MOV		AX,[WORD PTR CC2]
	DB $66;	SUB		AX,[WORD PTR CC1]
	DB $66;	CWD
	DB $66;	IDIV	BX
	DB $66;	MOV		[WORD PTR DC1],AX
	DB $66;	MOV		AX,[WORD PTR ZZ2]
	DB $66;	SUB		AX,[WORD PTR ZZ1]
	DB $66;	CWD
	DB $66;	IDIV	BX
	DB $66;	MOV		[WORD PTR DZ1],AX

@@OK6:

			MOV		AX,[Y2]
			CMP		AX,[Y3]
			JNE		@@NONFLAT2
	DB $66;	XOR		AX,AX
	DB $66;	MOV		[WORD PTR DX2],AX
	DB $66;	MOV		[WORD PTR DC2],AX
	DB $66;	MOV		[WORD PTR DZ2],AX
			JMP		@@OK9
@@NONFLAT2:
	DB $66;	DB $0F, $BF, $5E, OFFSET Y3
	DB $66;	DB $0F, $BF, $4E, OFFSET Y2
	DB $66;	SUB		BX,CX

	DB $66;	MOV		AX,[WORD PTR XX3]
	DB $66;	SUB		AX,[WORD PTR XX2]
	DB $66;	CWD
	DB $66;	IDIV	BX
	DB $66;	MOV		[WORD PTR DX2],AX

	DB $66;	MOV		AX,[WORD PTR CC3]
	DB $66;	SUB		AX,[WORD PTR CC2]
	DB $66;	CWD
	DB $66;	IDIV	BX
	DB $66;	MOV		[WORD PTR DC2],AX

	DB $66;	MOV		AX,[WORD PTR ZZ3]
	DB $66;	SUB		AX,[WORD PTR ZZ2]
	DB $66;	CWD
	DB $66;	IDIV	BX
	DB $66;	MOV		[WORD PTR DZ2],AX
@@OK9:

			MOV		AX,[Y1]
			CMP		AX,[Y3]
			JNE		@@NONFLAT3
	DB $66;	XOR		AX,AX
	DB $66;	MOV		[WORD PTR DX3],AX
	DB $66;	MOV		[WORD PTR DC3],AX
	DB $66;	MOV		[WORD PTR DZ3],AX
			JMP		@@OK12
@@NONFLAT3:
	DB $66;	DB $0F, $BF, $5E, OFFSET Y3
	DB $66;	DB $0F, $BF, $4E, OFFSET Y1
	DB $66;	SUB		BX,CX

	DB $66;	MOV		AX,[WORD PTR XX3]
	DB $66;	SUB		AX,[WORD PTR XX1]
	DB $66;	CWD
	DB $66;	IDIV	BX
	DB $66;	MOV		[WORD PTR DX3],AX

	DB $66;	MOV		AX,[WORD PTR CC3]
	DB $66;	SUB		AX,[WORD PTR CC1]
	DB $66;	CWD
	DB $66;	IDIV	BX
	DB $66;	MOV		[WORD PTR DC3],AX

	DB $66;	MOV		AX,[WORD PTR ZZ3]
	DB $66;	SUB		AX,[WORD PTR ZZ1]
	DB $66;	CWD
	DB $66;	IDIV	BX
	DB $66;	MOV		[WORD PTR DZ3],AX
@@OK12:

	DB $66;	MOV		AX,[WORD PTR XX1]
	DB $66;	MOV		[WORD PTR CX1],AX
	DB $66;	MOV		AX,[WORD PTR CC1]
	DB $66;	MOV		[WORD PTR PC1],AX
	DB $66;	MOV		AX,[WORD PTR ZZ1]
	DB $66;	MOV		[WORD PTR PZ1],AX

			MOV		AX,[Y1]
			CMP		AX,[Y2]
			JNE		@@NONFLAT4
	DB $66;	MOV		AX,[WORD PTR XX2]
	DB $66;	MOV		[WORD PTR CX2],AX
	DB $66;	MOV		AX,[WORD PTR CC2]
	DB $66;	MOV		[WORD PTR PC2],AX
	DB $66;	MOV		AX,[WORD PTR ZZ2]
	DB $66;	MOV		[WORD PTR PZ2],AX
			JMP		@@OK13
@@NONFLAT4:
	DB $66;	MOV		AX,[WORD PTR XX1]
	DB $66;	MOV		[WORD PTR CX2],AX
	DB $66;	MOV		AX,[WORD PTR CC1]
	DB $66;	MOV		[WORD PTR PC2],AX
	DB $66;	MOV		AX,[WORD PTR ZZ1]
	DB $66;	MOV		[WORD PTR PZ2],AX
@@OK13:

			MOV		AX,[Y1]
			MOV		[Y],AX

			MOV		ES,[VideoSeg]
			CMP		AX,0
			JGE		@@OK13_2
			XOR		AX,AX
@@OK13_2:
			MOV		DI,AX
			SHL		AX,8
			SHL		DI,6
			ADD		DI,AX
@@LINELOOP:
			MOV		AX,[Y]
			TEST	AX,AX
			JL		@@NEXTLINE
			CMP		AX,199
			JG		@@EXIT
			CMP		AX,[Y3]
			JG		@@EXIT
	DB $66;	MOV		AX,[WORD PTR CX1]
	DB $66;	CMP		AX,[WORD PTR CX2]
			JLE		@@OK14
	DB $66;	MOV		[WORD PTR MX2],AX
	DB $66;	MOV		AX,[WORD PTR CX2]
	DB $66;	MOV		[WORD PTR MX1],AX
	DB $66;	MOV		AX,[WORD PTR PC1]
	DB $66;	MOV		[WORD PTR MC2],AX
	DB $66;	MOV		AX,[WORD PTR PC2]
	DB $66;	MOV		[WORD PTR MC1],AX
	DB $66;	MOV		AX,[WORD PTR PZ1]
	DB $66;	MOV		[WORD PTR MZ2],AX
	DB $66;	MOV		AX,[WORD PTR PZ2]
	DB $66;	MOV		[WORD PTR MZ1],AX
			JMP		@@OK15
@@OK14:
	DB $66;	MOV		[WORD PTR MX1],AX
	DB $66;	MOV		AX,[WORD PTR CX2]
	DB $66;	MOV		[WORD PTR MX2],AX
	DB $66;	MOV		AX,[WORD PTR PC1]
	DB $66;	MOV		[WORD PTR MC1],AX
	DB $66;	MOV		AX,[WORD PTR PC2]
	DB $66;	MOV		[WORD PTR MC2],AX
	DB $66;	MOV		AX,[WORD PTR PZ1]
	DB $66;	MOV		[WORD PTR MZ1],AX
	DB $66;	MOV		AX,[WORD PTR PZ2]
	DB $66;	MOV		[WORD PTR MZ2],AX
@@OK15:

	DB $66;	SAR		[WORD PTR MX1],Scaler
	DB $66;	SAR		[WORD PTR MX2],Scaler

	DB $66;	MOV		AX,[WORD PTR MX1]
	DB $66;	CMP		AX,[WORD PTR MX2]
			JNE		@@NONFLAT5
	DB $66;	XOR		AX,AX
	DB $66;	MOV		[WORD PTR DCC1],AX
	DB $66;	MOV		[WORD PTR DZZ1],AX
			JMP		@@OK17
@@NONFLAT5:
	DB $66;	MOV		BX,[WORD PTR MX2]
	DB $66;	SUB		BX,[WORD PTR MX1]
	DB $66;	MOV		AX,[WORD PTR MC2]
	DB $66;	SUB		AX,[WORD PTR MC1]
	DB $66;	CWD
	DB $66;	IDIV	BX
	DB $66;	MOV		[WORD PTR DCC1],AX

	DB $66;	MOV		AX,[WORD PTR MZ2]
	DB $66;	SUB		AX,[WORD PTR MZ1]
	DB $66;	CWD
	DB $66;	IDIV	BX
	DB $66;	MOV		[WORD PTR DZZ1],AX
@@OK17:
			MOV		SI,DI
			MOV		AX,[WORD PTR MX1]
			CMP		AX,0
			JL		@@LOOP1
			ADD		DI,AX
@@LOOP1:
			MOV		AX,[WORD PTR MX1]
			CMP		AX,0
			JL		@@NEXTPIXEL
			CMP		AX,319
			JG		@@ENDOFLINE
			CMP		AX,[WORD PTR MX2]
			JG		@@ENDOFLINE

	DB $66;	MOV		AX,[WORD PTR MC1]
	DB $66;	XOR		BX,BX
	DB $66;	SAR     AX,Scaler
	DB $66;	ADC		AX,BX

	DB $66;	MOV		CX,[WORD PTR MZ1]
	DB $66;	SAR		CX,Scaler
	DB $66;	ADC		CX,BX

			CMP		CL,[DS:DI]
			JBE		@@NOTPLOT

			OR		[ES:DI],AL
			MOV		[DS:DI],CL
@@NOTPLOT:
			INC		DI
@@NEXTPIXEL:
			INC		[WORD PTR MX1]
	DB $66;	MOV		AX,[WORD PTR DCC1]
	DB $66;	ADD		[WORD PTR MC1],AX
	DB $66;	MOV		AX,[WORD PTR DZZ1]
	DB $66;	ADD		[WORD PTR MZ1],AX
			JMP		@@LOOP1
@@ENDOFLINE:
			MOV		DI,SI
			ADD		DI,320
@@NEXTLINE:

	DB $66;	MOV		AX,[WORD PTR DX3]
	DB $66;	ADD		[WORD PTR CX1],AX
	DB $66;	MOV		AX,[WORD PTR DC3]
	DB $66;	ADD		[WORD PTR PC1],AX
	DB $66;	MOV		AX,[WORD PTR DZ3]
	DB $66;	ADD		[WORD PTR PZ1],AX

			MOV		AX,[Y]
			CMP		AX,[Y2]
			JL		@@TOPPART
	DB $66;	MOV		AX,[WORD PTR DX2]
	DB $66;	ADD		[WORD PTR CX2],AX
	DB $66;	MOV		AX,[WORD PTR DC2]
	DB $66;	ADD		[WORD PTR PC2],AX
	DB $66;	MOV		AX,[WORD PTR DZ2]
	DB $66;	ADD		[WORD PTR PZ2],AX
			JMP		@@OK18
@@TOPPART:
	DB $66;	MOV		AX,[WORD PTR DX1]
	DB $66;	ADD		[WORD PTR CX2],AX
	DB $66;	MOV		AX,[WORD PTR DC1]
	DB $66;	ADD		[WORD PTR PC2],AX
	DB $66;	MOV		AX,[WORD PTR DZ1]
	DB $66;	ADD		[WORD PTR PZ2],AX
@@OK18:
			INC		[Y]
			JMP		@@LINELOOP
@@EXIT:
			POP		DS
End;

Procedure XTetraGouradSpaceCutZBufferClip(X1,Y1,Z1,C1,X2,Y2,Z2,C2,X3,Y3,Z3,C3,ClipX1,ClipY1,ClipX2,ClipY2 : Integer;
	VideoSeg,ZSeg : Word); Assembler;
Var
	X,Y			: Integer;
	XX1,XX2,XX3	: LongInt;
	CC1,CC2,CC3	: LongInt;
	ZZ1,ZZ2,ZZ3	: LongInt;
	DX1,DX2,DX3	: LongInt;
	DZ1,DZ2,DZ3	: LongInt;
	DC1,DC2,DC3	: LongInt;
	MX1,MX2		: LongInt;
	MC1,MC2		: LongInt;
	MZ1,MZ2		: LongInt;
	PC1,PC2		: LongInt;
	PZ1,PZ2		: LongInt;
	CX1,CX2		: LongInt;
	DCC1		: LongInt;
	DZZ1		: LongInt;
Asm
			CLD
			PUSH	DS
			MOV		DS,[ZSeg]
			MOV		AX,[Y1]
			CMP		AX,[Y2]
			JLE		@@OK1
			XCHG	AX,[Y2]
			MOV		[Y1],AX
			MOV		AX,[X1]
			XCHG	AX,[X2]
			MOV		[X1],AX
			MOV		AX,[C1]
			XCHG	AX,[C2]
			MOV		[C1],AX
			MOV		AX,[Z1]
			XCHG	AX,[Z2]
			MOV		[Z1],AX
@@OK1:
			MOV		AX,[Y1]
			CMP		AX,[Y3]
			JLE		@@OK2
			XCHG	AX,[Y3]
			MOV		[Y1],AX
			MOV		AX,[X1]
			XCHG	AX,[X3]
			MOV		[X1],AX
			MOV		AX,[C1]
			XCHG	AX,[C3]
			MOV		[C1],AX
			MOV		AX,[Z1]
			XCHG	AX,[Z3]
			MOV		[Z1],AX
@@OK2:
			MOV		AX,[Y2]
			CMP		AX,[Y3]
			JLE		@@OK3
			XCHG	AX,[Y3]
			MOV		[Y2],AX
			MOV		AX,[X2]
			XCHG	AX,[X3]
			MOV		[X2],AX
			MOV		AX,[C2]
			XCHG	AX,[C3]
			MOV		[C2],AX
			MOV		AX,[Z2]
			XCHG	AX,[Z3]
			MOV		[Z2],AX
@@OK3:

	DB $66;	DB $0F, $BF, $46, OFFSET X1
	DB $66;	SAL		AX,Scaler
	DB $66;	MOV		[WORD PTR XX1],AX
	DB $66;	DB $0F, $BF, $46, OFFSET X2
	DB $66;	SAL		AX,Scaler
	DB $66;	MOV		[WORD PTR XX2],AX
	DB $66;	DB $0F, $BF, $46, OFFSET X3
	DB $66;	SAL		AX,Scaler
	DB $66;	MOV		[WORD PTR XX3],AX

	DB $66;	DB $0F, $BF, $46, OFFSET C1
	DB $66;	SAL		AX,Scaler
	DB $66;	MOV		[WORD PTR CC1],AX
	DB $66;	DB $0F, $BF, $46, OFFSET C2
	DB $66;	SAL		AX,Scaler
	DB $66;	MOV		[WORD PTR CC2],AX
	DB $66;	DB $0F, $BF, $46, OFFSET C3
	DB $66;	SAL		AX,Scaler
	DB $66;	MOV		[WORD PTR CC3],AX

	DB $66;	DB $0F, $BF, $46, OFFSET Z1
	DB $66;	SAL		AX,Scaler
	DB $66;	MOV		[WORD PTR ZZ1],AX
	DB $66;	DB $0F, $BF, $46, OFFSET Z2
	DB $66;	SAL		AX,Scaler
	DB $66;	MOV		[WORD PTR ZZ2],AX
	DB $66;	DB $0F, $BF, $46, OFFSET Z3
	DB $66;	SAL		AX,Scaler
	DB $66;	MOV		[WORD PTR ZZ3],AX

			MOV		AX,[Y1]
			CMP		AX,[Y2]
			JNE		@@NONFLAT1
	DB $66;	XOR		AX,AX
	DB $66;	MOV		[WORD PTR DX1],AX
	DB $66;	MOV		[WORD PTR DC1],AX
	DB $66;	MOV		[WORD PTR DZ1],AX
			JMP		@@OK6
@@NONFLAT1:
	DB $66;	DB $0F, $BF, $5E, OFFSET Y2
	DB $66;	DB $0F, $BF, $4E, OFFSET Y1
	DB $66;	SUB		BX,CX

	DB $66;	MOV		AX,[WORD PTR XX2]
	DB $66;	SUB		AX,[WORD PTR XX1]
	DB $66;	CWD
	DB $66;	IDIV	BX
	DB $66;	MOV		[WORD PTR DX1],AX

	DB $66;	MOV		AX,[WORD PTR CC2]
	DB $66;	SUB		AX,[WORD PTR CC1]
	DB $66;	CWD
	DB $66;	IDIV	BX
	DB $66;	MOV		[WORD PTR DC1],AX
	DB $66;	MOV		AX,[WORD PTR ZZ2]
	DB $66;	SUB		AX,[WORD PTR ZZ1]
	DB $66;	CWD
	DB $66;	IDIV	BX
	DB $66;	MOV		[WORD PTR DZ1],AX

@@OK6:

			MOV		AX,[Y2]
			CMP		AX,[Y3]
			JNE		@@NONFLAT2
	DB $66;	XOR		AX,AX
	DB $66;	MOV		[WORD PTR DX2],AX
	DB $66;	MOV		[WORD PTR DC2],AX
	DB $66;	MOV		[WORD PTR DZ2],AX
			JMP		@@OK9
@@NONFLAT2:
	DB $66;	DB $0F, $BF, $5E, OFFSET Y3
	DB $66;	DB $0F, $BF, $4E, OFFSET Y2
	DB $66;	SUB		BX,CX

	DB $66;	MOV		AX,[WORD PTR XX3]
	DB $66;	SUB		AX,[WORD PTR XX2]
	DB $66;	CWD
	DB $66;	IDIV	BX
	DB $66;	MOV		[WORD PTR DX2],AX

	DB $66;	MOV		AX,[WORD PTR CC3]
	DB $66;	SUB		AX,[WORD PTR CC2]
	DB $66;	CWD
	DB $66;	IDIV	BX
	DB $66;	MOV		[WORD PTR DC2],AX

	DB $66;	MOV		AX,[WORD PTR ZZ3]
	DB $66;	SUB		AX,[WORD PTR ZZ2]
	DB $66;	CWD
	DB $66;	IDIV	BX
	DB $66;	MOV		[WORD PTR DZ2],AX
@@OK9:

			MOV		AX,[Y1]
			CMP		AX,[Y3]
			JNE		@@NONFLAT3
	DB $66;	XOR		AX,AX
	DB $66;	MOV		[WORD PTR DX3],AX
	DB $66;	MOV		[WORD PTR DC3],AX
	DB $66;	MOV		[WORD PTR DZ3],AX
			JMP		@@OK12
@@NONFLAT3:
	DB $66;	DB $0F, $BF, $5E, OFFSET Y3
	DB $66;	DB $0F, $BF, $4E, OFFSET Y1
	DB $66;	SUB		BX,CX

	DB $66;	MOV		AX,[WORD PTR XX3]
	DB $66;	SUB		AX,[WORD PTR XX1]
	DB $66;	CWD
	DB $66;	IDIV	BX
	DB $66;	MOV		[WORD PTR DX3],AX

	DB $66;	MOV		AX,[WORD PTR CC3]
	DB $66;	SUB		AX,[WORD PTR CC1]
	DB $66;	CWD
	DB $66;	IDIV	BX
	DB $66;	MOV		[WORD PTR DC3],AX

	DB $66;	MOV		AX,[WORD PTR ZZ3]
	DB $66;	SUB		AX,[WORD PTR ZZ1]
	DB $66;	CWD
	DB $66;	IDIV	BX
	DB $66;	MOV		[WORD PTR DZ3],AX
@@OK12:

	DB $66;	MOV		AX,[WORD PTR XX1]
	DB $66;	MOV		[WORD PTR CX1],AX
	DB $66;	MOV		AX,[WORD PTR CC1]
	DB $66;	MOV		[WORD PTR PC1],AX
	DB $66;	MOV		AX,[WORD PTR ZZ1]
	DB $66;	MOV		[WORD PTR PZ1],AX

			MOV		AX,[Y1]
			CMP		AX,[Y2]
			JNE		@@NONFLAT4
	DB $66;	MOV		AX,[WORD PTR XX2]
	DB $66;	MOV		[WORD PTR CX2],AX
	DB $66;	MOV		AX,[WORD PTR CC2]
	DB $66;	MOV		[WORD PTR PC2],AX
	DB $66;	MOV		AX,[WORD PTR ZZ2]
	DB $66;	MOV		[WORD PTR PZ2],AX
			JMP		@@OK13
@@NONFLAT4:
	DB $66;	MOV		AX,[WORD PTR XX1]
	DB $66;	MOV		[WORD PTR CX2],AX
	DB $66;	MOV		AX,[WORD PTR CC1]
	DB $66;	MOV		[WORD PTR PC2],AX
	DB $66;	MOV		AX,[WORD PTR ZZ1]
	DB $66;	MOV		[WORD PTR PZ2],AX
@@OK13:

			MOV		AX,[Y1]
			MOV		[Y],AX

			MOV		ES,[VideoSeg]
			CMP		AX,[ClipY1]
			JGE		@@OK13_2
			MOV		AX,[ClipY1]
@@OK13_2:
			MOV		DI,AX
			SHL		AX,8
			SHL		DI,6
			ADD		DI,AX
@@LINELOOP:
			MOV		AX,[Y]
			CMP		AX,[ClipY1]
			JL		@@NEXTLINE
			CMP		AX,[ClipY2]
			JG		@@EXIT
			CMP		AX,[Y3]
			JG		@@EXIT
	DB $66;	MOV		AX,[WORD PTR CX1]
	DB $66;	CMP		AX,[WORD PTR CX2]
			JLE		@@OK14
	DB $66;	MOV		[WORD PTR MX2],AX
	DB $66;	MOV		AX,[WORD PTR CX2]
	DB $66;	MOV		[WORD PTR MX1],AX
	DB $66;	MOV		AX,[WORD PTR PC1]
	DB $66;	MOV		[WORD PTR MC2],AX
	DB $66;	MOV		AX,[WORD PTR PC2]
	DB $66;	MOV		[WORD PTR MC1],AX
	DB $66;	MOV		AX,[WORD PTR PZ1]
	DB $66;	MOV		[WORD PTR MZ2],AX
	DB $66;	MOV		AX,[WORD PTR PZ2]
	DB $66;	MOV		[WORD PTR MZ1],AX
			JMP		@@OK15
@@OK14:
	DB $66;	MOV		[WORD PTR MX1],AX
	DB $66;	MOV		AX,[WORD PTR CX2]
	DB $66;	MOV		[WORD PTR MX2],AX
	DB $66;	MOV		AX,[WORD PTR PC1]
	DB $66;	MOV		[WORD PTR MC1],AX
	DB $66;	MOV		AX,[WORD PTR PC2]
	DB $66;	MOV		[WORD PTR MC2],AX
	DB $66;	MOV		AX,[WORD PTR PZ1]
	DB $66;	MOV		[WORD PTR MZ1],AX
	DB $66;	MOV		AX,[WORD PTR PZ2]
	DB $66;	MOV		[WORD PTR MZ2],AX
@@OK15:

	DB $66;	XOR		CX,CX
	DB $66;	SAR		[WORD PTR MX1],Scaler
	DB $66;	ADC		[WORD PTR MX1],CX
	DB $66;	SAR		[WORD PTR MX2],Scaler
	DB $66;	ADC		[WORD PTR MX2],CX

	DB $66;	MOV		AX,[WORD PTR MX1]
	DB $66;	CMP		AX,[WORD PTR MX2]
			JNE		@@NONFLAT5
	DB $66;	XOR		AX,AX
	DB $66;	MOV		[WORD PTR DCC1],AX
	DB $66;	MOV		[WORD PTR DZZ1],AX
			JMP		@@OK17
@@NONFLAT5:
	DB $66;	MOV		BX,[WORD PTR MX2]
	DB $66;	SUB		BX,[WORD PTR MX1]
	DB $66;	MOV		AX,[WORD PTR MC2]
	DB $66;	SUB		AX,[WORD PTR MC1]
	DB $66;	CWD
	DB $66;	IDIV	BX
	DB $66;	MOV		[WORD PTR DCC1],AX

	DB $66;	MOV		AX,[WORD PTR MZ2]
	DB $66;	SUB		AX,[WORD PTR MZ1]
	DB $66;	CWD
	DB $66;	IDIV	BX
	DB $66;	MOV		[WORD PTR DZZ1],AX
@@OK17:
			MOV		SI,DI
			MOV		AX,[WORD PTR MX1]
			CMP		AX,[ClipX1]
			JGE		@@OK17_2
			MOV		AX,[ClipX1]
@@OK17_2:
			ADD		DI,AX
@@LOOP1:
			MOV		AX,[WORD PTR MX1]
			CMP		AX,[ClipX1]
			JL		@@NEXTPIXEL
			CMP		AX,[ClipX2]
			JG		@@ENDOFLINE
			CMP		AX,[WORD PTR MX2]
			JG		@@ENDOFLINE

	DB $66;	MOV		AX,[WORD PTR MC1]
	DB $66;	XOR		BX,BX
	DB $66;	SAR     AX,Scaler
	DB $66;	ADC		AX,BX

	DB $66;	MOV		CX,[WORD PTR MZ1]
	DB $66;	SAR		CX,Scaler
	DB $66;	ADC		CX,BX

			CMP		CL,[DS:DI]
			JBE		@@NOTPLOT

			MOV		[ES:DI],AL
			MOV		[DS:DI],CL
@@NOTPLOT:
			INC		DI
@@NEXTPIXEL:
			INC		[WORD PTR MX1]
	DB $66;	MOV		AX,[WORD PTR DCC1]
	DB $66;	ADD		[WORD PTR MC1],AX
	DB $66;	MOV		AX,[WORD PTR DZZ1]
	DB $66;	ADD		[WORD PTR MZ1],AX
			JMP		@@LOOP1
@@ENDOFLINE:
			MOV		DI,SI
			ADD		DI,320
@@NEXTLINE:

	DB $66;	MOV		AX,[WORD PTR DX3]
	DB $66;	ADD		[WORD PTR CX1],AX
	DB $66;	MOV		AX,[WORD PTR DC3]
	DB $66;	ADD		[WORD PTR PC1],AX
	DB $66;	MOV		AX,[WORD PTR DZ3]
	DB $66;	ADD		[WORD PTR PZ1],AX

			MOV		AX,[Y]
			CMP		AX,[Y2]
			JL		@@TOPPART
	DB $66;	MOV		AX,[WORD PTR DX2]
	DB $66;	ADD		[WORD PTR CX2],AX
	DB $66;	MOV		AX,[WORD PTR DC2]
	DB $66;	ADD		[WORD PTR PC2],AX
	DB $66;	MOV		AX,[WORD PTR DZ2]
	DB $66;	ADD		[WORD PTR PZ2],AX
			JMP		@@OK18
@@TOPPART:
	DB $66;	MOV		AX,[WORD PTR DX1]
	DB $66;	ADD		[WORD PTR CX2],AX
	DB $66;	MOV		AX,[WORD PTR DC1]
	DB $66;	ADD		[WORD PTR PC2],AX
	DB $66;	MOV		AX,[WORD PTR DZ1]
	DB $66;	ADD		[WORD PTR PZ2],AX
@@OK18:
			INC		[Y]
			JMP		@@LINELOOP
@@EXIT:
			POP		DS
End;

Procedure XTetraGouradGlenzADDSpaceCutZBufferClip(X1,Y1,Z1,C1,X2,Y2,Z2,C2,X3,Y3,Z3,C3,ClipX1,ClipY1,ClipX2,ClipY2 : Integer;
	VideoSeg,ZSeg : Word); Assembler;
Var
	X,Y			: Integer;
	XX1,XX2,XX3	: LongInt;
	CC1,CC2,CC3	: LongInt;
	ZZ1,ZZ2,ZZ3	: LongInt;
	DX1,DX2,DX3	: LongInt;
	DZ1,DZ2,DZ3	: LongInt;
	DC1,DC2,DC3	: LongInt;
	MX1,MX2		: LongInt;
	MC1,MC2		: LongInt;
	MZ1,MZ2		: LongInt;
	PC1,PC2		: LongInt;
	PZ1,PZ2		: LongInt;
	CX1,CX2		: LongInt;
	DCC1		: LongInt;
	DZZ1		: LongInt;
Asm
			CLD
			PUSH	DS
			MOV		DS,[ZSeg]
			MOV		AX,[Y1]
			CMP		AX,[Y2]
			JLE		@@OK1
			XCHG	AX,[Y2]
			MOV		[Y1],AX
			MOV		AX,[X1]
			XCHG	AX,[X2]
			MOV		[X1],AX
			MOV		AX,[C1]
			XCHG	AX,[C2]
			MOV		[C1],AX
			MOV		AX,[Z1]
			XCHG	AX,[Z2]
			MOV		[Z1],AX
@@OK1:
			MOV		AX,[Y1]
			CMP		AX,[Y3]
			JLE		@@OK2
			XCHG	AX,[Y3]
			MOV		[Y1],AX
			MOV		AX,[X1]
			XCHG	AX,[X3]
			MOV		[X1],AX
			MOV		AX,[C1]
			XCHG	AX,[C3]
			MOV		[C1],AX
			MOV		AX,[Z1]
			XCHG	AX,[Z3]
			MOV		[Z1],AX
@@OK2:
			MOV		AX,[Y2]
			CMP		AX,[Y3]
			JLE		@@OK3
			XCHG	AX,[Y3]
			MOV		[Y2],AX
			MOV		AX,[X2]
			XCHG	AX,[X3]
			MOV		[X2],AX
			MOV		AX,[C2]
			XCHG	AX,[C3]
			MOV		[C2],AX
			MOV		AX,[Z2]
			XCHG	AX,[Z3]
			MOV		[Z2],AX
@@OK3:

	DB $66;	DB $0F, $BF, $46, OFFSET X1
	DB $66;	SAL		AX,Scaler
	DB $66;	MOV		[WORD PTR XX1],AX
	DB $66;	DB $0F, $BF, $46, OFFSET X2
	DB $66;	SAL		AX,Scaler
	DB $66;	MOV		[WORD PTR XX2],AX
	DB $66;	DB $0F, $BF, $46, OFFSET X3
	DB $66;	SAL		AX,Scaler
	DB $66;	MOV		[WORD PTR XX3],AX

	DB $66;	DB $0F, $BF, $46, OFFSET C1
	DB $66;	SAL		AX,Scaler
	DB $66;	MOV		[WORD PTR CC1],AX
	DB $66;	DB $0F, $BF, $46, OFFSET C2
	DB $66;	SAL		AX,Scaler
	DB $66;	MOV		[WORD PTR CC2],AX
	DB $66;	DB $0F, $BF, $46, OFFSET C3
	DB $66;	SAL		AX,Scaler
	DB $66;	MOV		[WORD PTR CC3],AX

	DB $66;	DB $0F, $BF, $46, OFFSET Z1
	DB $66;	SAL		AX,Scaler
	DB $66;	MOV		[WORD PTR ZZ1],AX
	DB $66;	DB $0F, $BF, $46, OFFSET Z2
	DB $66;	SAL		AX,Scaler
	DB $66;	MOV		[WORD PTR ZZ2],AX
	DB $66;	DB $0F, $BF, $46, OFFSET Z3
	DB $66;	SAL		AX,Scaler
	DB $66;	MOV		[WORD PTR ZZ3],AX

			MOV		AX,[Y1]
			CMP		AX,[Y2]
			JNE		@@NONFLAT1
	DB $66;	XOR		AX,AX
	DB $66;	MOV		[WORD PTR DX1],AX
	DB $66;	MOV		[WORD PTR DC1],AX
	DB $66;	MOV		[WORD PTR DZ1],AX
			JMP		@@OK6
@@NONFLAT1:
	DB $66;	DB $0F, $BF, $5E, OFFSET Y2
	DB $66;	DB $0F, $BF, $4E, OFFSET Y1
	DB $66;	SUB		BX,CX

	DB $66;	MOV		AX,[WORD PTR XX2]
	DB $66;	SUB		AX,[WORD PTR XX1]
	DB $66;	CWD
	DB $66;	IDIV	BX
	DB $66;	MOV		[WORD PTR DX1],AX

	DB $66;	MOV		AX,[WORD PTR CC2]
	DB $66;	SUB		AX,[WORD PTR CC1]
	DB $66;	CWD
	DB $66;	IDIV	BX
	DB $66;	MOV		[WORD PTR DC1],AX
	DB $66;	MOV		AX,[WORD PTR ZZ2]
	DB $66;	SUB		AX,[WORD PTR ZZ1]
	DB $66;	CWD
	DB $66;	IDIV	BX
	DB $66;	MOV		[WORD PTR DZ1],AX

@@OK6:

			MOV		AX,[Y2]
			CMP		AX,[Y3]
			JNE		@@NONFLAT2
	DB $66;	XOR		AX,AX
	DB $66;	MOV		[WORD PTR DX2],AX
	DB $66;	MOV		[WORD PTR DC2],AX
	DB $66;	MOV		[WORD PTR DZ2],AX
			JMP		@@OK9
@@NONFLAT2:
	DB $66;	DB $0F, $BF, $5E, OFFSET Y3
	DB $66;	DB $0F, $BF, $4E, OFFSET Y2
	DB $66;	SUB		BX,CX

	DB $66;	MOV		AX,[WORD PTR XX3]
	DB $66;	SUB		AX,[WORD PTR XX2]
	DB $66;	CWD
	DB $66;	IDIV	BX
	DB $66;	MOV		[WORD PTR DX2],AX

	DB $66;	MOV		AX,[WORD PTR CC3]
	DB $66;	SUB		AX,[WORD PTR CC2]
	DB $66;	CWD
	DB $66;	IDIV	BX
	DB $66;	MOV		[WORD PTR DC2],AX

	DB $66;	MOV		AX,[WORD PTR ZZ3]
	DB $66;	SUB		AX,[WORD PTR ZZ2]
	DB $66;	CWD
	DB $66;	IDIV	BX
	DB $66;	MOV		[WORD PTR DZ2],AX
@@OK9:

			MOV		AX,[Y1]
			CMP		AX,[Y3]
			JNE		@@NONFLAT3
	DB $66;	XOR		AX,AX
	DB $66;	MOV		[WORD PTR DX3],AX
	DB $66;	MOV		[WORD PTR DC3],AX
	DB $66;	MOV		[WORD PTR DZ3],AX
			JMP		@@OK12
@@NONFLAT3:
	DB $66;	DB $0F, $BF, $5E, OFFSET Y3
	DB $66;	DB $0F, $BF, $4E, OFFSET Y1
	DB $66;	SUB		BX,CX

	DB $66;	MOV		AX,[WORD PTR XX3]
	DB $66;	SUB		AX,[WORD PTR XX1]
	DB $66;	CWD
	DB $66;	IDIV	BX
	DB $66;	MOV		[WORD PTR DX3],AX

	DB $66;	MOV		AX,[WORD PTR CC3]
	DB $66;	SUB		AX,[WORD PTR CC1]
	DB $66;	CWD
	DB $66;	IDIV	BX
	DB $66;	MOV		[WORD PTR DC3],AX

	DB $66;	MOV		AX,[WORD PTR ZZ3]
	DB $66;	SUB		AX,[WORD PTR ZZ1]
	DB $66;	CWD
	DB $66;	IDIV	BX
	DB $66;	MOV		[WORD PTR DZ3],AX
@@OK12:

	DB $66;	MOV		AX,[WORD PTR XX1]
	DB $66;	MOV		[WORD PTR CX1],AX
	DB $66;	MOV		AX,[WORD PTR CC1]
	DB $66;	MOV		[WORD PTR PC1],AX
	DB $66;	MOV		AX,[WORD PTR ZZ1]
	DB $66;	MOV		[WORD PTR PZ1],AX

			MOV		AX,[Y1]
			CMP		AX,[Y2]
			JNE		@@NONFLAT4
	DB $66;	MOV		AX,[WORD PTR XX2]
	DB $66;	MOV		[WORD PTR CX2],AX
	DB $66;	MOV		AX,[WORD PTR CC2]
	DB $66;	MOV		[WORD PTR PC2],AX
	DB $66;	MOV		AX,[WORD PTR ZZ2]
	DB $66;	MOV		[WORD PTR PZ2],AX
			JMP		@@OK13
@@NONFLAT4:
	DB $66;	MOV		AX,[WORD PTR XX1]
	DB $66;	MOV		[WORD PTR CX2],AX
	DB $66;	MOV		AX,[WORD PTR CC1]
	DB $66;	MOV		[WORD PTR PC2],AX
	DB $66;	MOV		AX,[WORD PTR ZZ1]
	DB $66;	MOV		[WORD PTR PZ2],AX
@@OK13:

			MOV		AX,[Y1]
			MOV		[Y],AX

			MOV		ES,[VideoSeg]
			CMP		AX,[ClipY1]
			JGE		@@OK13_2
			MOV		AX,[ClipY1]
@@OK13_2:
			MOV		DI,AX
			SHL		AX,8
			SHL		DI,6
			ADD		DI,AX
@@LINELOOP:
			MOV		AX,[Y]
			CMP		AX,[ClipY1]
			JL		@@NEXTLINE
			CMP		AX,[ClipY2]
			JG		@@EXIT
			CMP		AX,[Y3]
			JG		@@EXIT
	DB $66;	MOV		AX,[WORD PTR CX1]
	DB $66;	CMP		AX,[WORD PTR CX2]
			JLE		@@OK14
	DB $66;	MOV		[WORD PTR MX2],AX
	DB $66;	MOV		AX,[WORD PTR CX2]
	DB $66;	MOV		[WORD PTR MX1],AX
	DB $66;	MOV		AX,[WORD PTR PC1]
	DB $66;	MOV		[WORD PTR MC2],AX
	DB $66;	MOV		AX,[WORD PTR PC2]
	DB $66;	MOV		[WORD PTR MC1],AX
	DB $66;	MOV		AX,[WORD PTR PZ1]
	DB $66;	MOV		[WORD PTR MZ2],AX
	DB $66;	MOV		AX,[WORD PTR PZ2]
	DB $66;	MOV		[WORD PTR MZ1],AX
			JMP		@@OK15
@@OK14:
	DB $66;	MOV		[WORD PTR MX1],AX
	DB $66;	MOV		AX,[WORD PTR CX2]
	DB $66;	MOV		[WORD PTR MX2],AX
	DB $66;	MOV		AX,[WORD PTR PC1]
	DB $66;	MOV		[WORD PTR MC1],AX
	DB $66;	MOV		AX,[WORD PTR PC2]
	DB $66;	MOV		[WORD PTR MC2],AX
	DB $66;	MOV		AX,[WORD PTR PZ1]
	DB $66;	MOV		[WORD PTR MZ1],AX
	DB $66;	MOV		AX,[WORD PTR PZ2]
	DB $66;	MOV		[WORD PTR MZ2],AX
@@OK15:

	DB $66;	XOR		CX,CX
	DB $66;	SAR		[WORD PTR MX1],Scaler
	DB $66;	ADC		[WORD PTR MX1],CX
	DB $66;	SAR		[WORD PTR MX2],Scaler
	DB $66;	ADC		[WORD PTR MX2],CX

	DB $66;	MOV		AX,[WORD PTR MX1]
	DB $66;	CMP		AX,[WORD PTR MX2]
			JNE		@@NONFLAT5
	DB $66;	XOR		AX,AX
	DB $66;	MOV		[WORD PTR DCC1],AX
	DB $66;	MOV		[WORD PTR DZZ1],AX
			JMP		@@OK17
@@NONFLAT5:
	DB $66;	MOV		BX,[WORD PTR MX2]
	DB $66;	SUB		BX,[WORD PTR MX1]
	DB $66;	MOV		AX,[WORD PTR MC2]
	DB $66;	SUB		AX,[WORD PTR MC1]
	DB $66;	CWD
	DB $66;	IDIV	BX
	DB $66;	MOV		[WORD PTR DCC1],AX

	DB $66;	MOV		AX,[WORD PTR MZ2]
	DB $66;	SUB		AX,[WORD PTR MZ1]
	DB $66;	CWD
	DB $66;	IDIV	BX
	DB $66;	MOV		[WORD PTR DZZ1],AX
@@OK17:
			MOV		SI,DI
			MOV		AX,[WORD PTR MX1]
			CMP		AX,[ClipX1]
			JGE		@@OK17_2
			MOV		AX,[ClipX1]
@@OK17_2:
			ADD		DI,AX
@@LOOP1:
			MOV		AX,[WORD PTR MX1]
			CMP		AX,[ClipX1]
			JL		@@NEXTPIXEL
			CMP		AX,[ClipX2]
			JG		@@ENDOFLINE
			CMP		AX,[WORD PTR MX2]
			JG		@@ENDOFLINE

	DB $66;	MOV		AX,[WORD PTR MC1]
	DB $66;	XOR		BX,BX
	DB $66;	SAR     AX,Scaler
	DB $66;	ADC		AX,BX

	DB $66;	MOV		CX,[WORD PTR MZ1]
	DB $66;	SAR		CX,Scaler
	DB $66;	ADC		CX,BX

			CMP		CL,[DS:DI]
			JBE		@@NOTPLOT

			ADD		[ES:DI],AL
			MOV		[DS:DI],CL
@@NOTPLOT:
			INC		DI
@@NEXTPIXEL:
			INC		[WORD PTR MX1]
	DB $66;	MOV		AX,[WORD PTR DCC1]
	DB $66;	ADD		[WORD PTR MC1],AX
	DB $66;	MOV		AX,[WORD PTR DZZ1]
	DB $66;	ADD		[WORD PTR MZ1],AX
			JMP		@@LOOP1
@@ENDOFLINE:
			MOV		DI,SI
			ADD		DI,320
@@NEXTLINE:

	DB $66;	MOV		AX,[WORD PTR DX3]
	DB $66;	ADD		[WORD PTR CX1],AX
	DB $66;	MOV		AX,[WORD PTR DC3]
	DB $66;	ADD		[WORD PTR PC1],AX
	DB $66;	MOV		AX,[WORD PTR DZ3]
	DB $66;	ADD		[WORD PTR PZ1],AX

			MOV		AX,[Y]
			CMP		AX,[Y2]
			JL		@@TOPPART
	DB $66;	MOV		AX,[WORD PTR DX2]
	DB $66;	ADD		[WORD PTR CX2],AX
	DB $66;	MOV		AX,[WORD PTR DC2]
	DB $66;	ADD		[WORD PTR PC2],AX
	DB $66;	MOV		AX,[WORD PTR DZ2]
	DB $66;	ADD		[WORD PTR PZ2],AX
			JMP		@@OK18
@@TOPPART:
	DB $66;	MOV		AX,[WORD PTR DX1]
	DB $66;	ADD		[WORD PTR CX2],AX
	DB $66;	MOV		AX,[WORD PTR DC1]
	DB $66;	ADD		[WORD PTR PC2],AX
	DB $66;	MOV		AX,[WORD PTR DZ1]
	DB $66;	ADD		[WORD PTR PZ2],AX
@@OK18:
			INC		[Y]
			JMP		@@LINELOOP
@@EXIT:
			POP		DS
End;

Procedure XTetraGouradGlenzORSpaceCutZBufferClip(X1,Y1,Z1,C1,X2,Y2,Z2,C2,X3,Y3,Z3,C3,ClipX1,ClipY1,ClipX2,ClipY2 : Integer;
	VideoSeg,ZSeg : Word); Assembler;
Var
	X,Y			: Integer;
	XX1,XX2,XX3	: LongInt;
	CC1,CC2,CC3	: LongInt;
	ZZ1,ZZ2,ZZ3	: LongInt;
	DX1,DX2,DX3	: LongInt;
	DZ1,DZ2,DZ3	: LongInt;
	DC1,DC2,DC3	: LongInt;
	MX1,MX2		: LongInt;
	MC1,MC2		: LongInt;
	MZ1,MZ2		: LongInt;
	PC1,PC2		: LongInt;
	PZ1,PZ2		: LongInt;
	CX1,CX2		: LongInt;
	DCC1		: LongInt;
	DZZ1		: LongInt;
Asm
			CLD
			PUSH	DS
			MOV		DS,[ZSeg]
			MOV		AX,[Y1]
			CMP		AX,[Y2]
			JLE		@@OK1
			XCHG	AX,[Y2]
			MOV		[Y1],AX
			MOV		AX,[X1]
			XCHG	AX,[X2]
			MOV		[X1],AX
			MOV		AX,[C1]
			XCHG	AX,[C2]
			MOV		[C1],AX
			MOV		AX,[Z1]
			XCHG	AX,[Z2]
			MOV		[Z1],AX
@@OK1:
			MOV		AX,[Y1]
			CMP		AX,[Y3]
			JLE		@@OK2
			XCHG	AX,[Y3]
			MOV		[Y1],AX
			MOV		AX,[X1]
			XCHG	AX,[X3]
			MOV		[X1],AX
			MOV		AX,[C1]
			XCHG	AX,[C3]
			MOV		[C1],AX
			MOV		AX,[Z1]
			XCHG	AX,[Z3]
			MOV		[Z1],AX
@@OK2:
			MOV		AX,[Y2]
			CMP		AX,[Y3]
			JLE		@@OK3
			XCHG	AX,[Y3]
			MOV		[Y2],AX
			MOV		AX,[X2]
			XCHG	AX,[X3]
			MOV		[X2],AX
			MOV		AX,[C2]
			XCHG	AX,[C3]
			MOV		[C2],AX
			MOV		AX,[Z2]
			XCHG	AX,[Z3]
			MOV		[Z2],AX
@@OK3:

	DB $66;	DB $0F, $BF, $46, OFFSET X1
	DB $66;	SAL		AX,Scaler
	DB $66;	MOV		[WORD PTR XX1],AX
	DB $66;	DB $0F, $BF, $46, OFFSET X2
	DB $66;	SAL		AX,Scaler
	DB $66;	MOV		[WORD PTR XX2],AX
	DB $66;	DB $0F, $BF, $46, OFFSET X3
	DB $66;	SAL		AX,Scaler
	DB $66;	MOV		[WORD PTR XX3],AX

	DB $66;	DB $0F, $BF, $46, OFFSET C1
	DB $66;	SAL		AX,Scaler
	DB $66;	MOV		[WORD PTR CC1],AX
	DB $66;	DB $0F, $BF, $46, OFFSET C2
	DB $66;	SAL		AX,Scaler
	DB $66;	MOV		[WORD PTR CC2],AX
	DB $66;	DB $0F, $BF, $46, OFFSET C3
	DB $66;	SAL		AX,Scaler
	DB $66;	MOV		[WORD PTR CC3],AX

	DB $66;	DB $0F, $BF, $46, OFFSET Z1
	DB $66;	SAL		AX,Scaler
	DB $66;	MOV		[WORD PTR ZZ1],AX
	DB $66;	DB $0F, $BF, $46, OFFSET Z2
	DB $66;	SAL		AX,Scaler
	DB $66;	MOV		[WORD PTR ZZ2],AX
	DB $66;	DB $0F, $BF, $46, OFFSET Z3
	DB $66;	SAL		AX,Scaler
	DB $66;	MOV		[WORD PTR ZZ3],AX

			MOV		AX,[Y1]
			CMP		AX,[Y2]
			JNE		@@NONFLAT1
	DB $66;	XOR		AX,AX
	DB $66;	MOV		[WORD PTR DX1],AX
	DB $66;	MOV		[WORD PTR DC1],AX
	DB $66;	MOV		[WORD PTR DZ1],AX
			JMP		@@OK6
@@NONFLAT1:
	DB $66;	DB $0F, $BF, $5E, OFFSET Y2
	DB $66;	DB $0F, $BF, $4E, OFFSET Y1
	DB $66;	SUB		BX,CX

	DB $66;	MOV		AX,[WORD PTR XX2]
	DB $66;	SUB		AX,[WORD PTR XX1]
	DB $66;	CWD
	DB $66;	IDIV	BX
	DB $66;	MOV		[WORD PTR DX1],AX

	DB $66;	MOV		AX,[WORD PTR CC2]
	DB $66;	SUB		AX,[WORD PTR CC1]
	DB $66;	CWD
	DB $66;	IDIV	BX
	DB $66;	MOV		[WORD PTR DC1],AX
	DB $66;	MOV		AX,[WORD PTR ZZ2]
	DB $66;	SUB		AX,[WORD PTR ZZ1]
	DB $66;	CWD
	DB $66;	IDIV	BX
	DB $66;	MOV		[WORD PTR DZ1],AX

@@OK6:

			MOV		AX,[Y2]
			CMP		AX,[Y3]
			JNE		@@NONFLAT2
	DB $66;	XOR		AX,AX
	DB $66;	MOV		[WORD PTR DX2],AX
	DB $66;	MOV		[WORD PTR DC2],AX
	DB $66;	MOV		[WORD PTR DZ2],AX
			JMP		@@OK9
@@NONFLAT2:
	DB $66;	DB $0F, $BF, $5E, OFFSET Y3
	DB $66;	DB $0F, $BF, $4E, OFFSET Y2
	DB $66;	SUB		BX,CX

	DB $66;	MOV		AX,[WORD PTR XX3]
	DB $66;	SUB		AX,[WORD PTR XX2]
	DB $66;	CWD
	DB $66;	IDIV	BX
	DB $66;	MOV		[WORD PTR DX2],AX

	DB $66;	MOV		AX,[WORD PTR CC3]
	DB $66;	SUB		AX,[WORD PTR CC2]
	DB $66;	CWD
	DB $66;	IDIV	BX
	DB $66;	MOV		[WORD PTR DC2],AX

	DB $66;	MOV		AX,[WORD PTR ZZ3]
	DB $66;	SUB		AX,[WORD PTR ZZ2]
	DB $66;	CWD
	DB $66;	IDIV	BX
	DB $66;	MOV		[WORD PTR DZ2],AX
@@OK9:

			MOV		AX,[Y1]
			CMP		AX,[Y3]
			JNE		@@NONFLAT3
	DB $66;	XOR		AX,AX
	DB $66;	MOV		[WORD PTR DX3],AX
	DB $66;	MOV		[WORD PTR DC3],AX
	DB $66;	MOV		[WORD PTR DZ3],AX
			JMP		@@OK12
@@NONFLAT3:
	DB $66;	DB $0F, $BF, $5E, OFFSET Y3
	DB $66;	DB $0F, $BF, $4E, OFFSET Y1
	DB $66;	SUB		BX,CX

	DB $66;	MOV		AX,[WORD PTR XX3]
	DB $66;	SUB		AX,[WORD PTR XX1]
	DB $66;	CWD
	DB $66;	IDIV	BX
	DB $66;	MOV		[WORD PTR DX3],AX

	DB $66;	MOV		AX,[WORD PTR CC3]
	DB $66;	SUB		AX,[WORD PTR CC1]
	DB $66;	CWD
	DB $66;	IDIV	BX
	DB $66;	MOV		[WORD PTR DC3],AX

	DB $66;	MOV		AX,[WORD PTR ZZ3]
	DB $66;	SUB		AX,[WORD PTR ZZ1]
	DB $66;	CWD
	DB $66;	IDIV	BX
	DB $66;	MOV		[WORD PTR DZ3],AX
@@OK12:

	DB $66;	MOV		AX,[WORD PTR XX1]
	DB $66;	MOV		[WORD PTR CX1],AX
	DB $66;	MOV		AX,[WORD PTR CC1]
	DB $66;	MOV		[WORD PTR PC1],AX
	DB $66;	MOV		AX,[WORD PTR ZZ1]
	DB $66;	MOV		[WORD PTR PZ1],AX

			MOV		AX,[Y1]
			CMP		AX,[Y2]
			JNE		@@NONFLAT4
	DB $66;	MOV		AX,[WORD PTR XX2]
	DB $66;	MOV		[WORD PTR CX2],AX
	DB $66;	MOV		AX,[WORD PTR CC2]
	DB $66;	MOV		[WORD PTR PC2],AX
	DB $66;	MOV		AX,[WORD PTR ZZ2]
	DB $66;	MOV		[WORD PTR PZ2],AX
			JMP		@@OK13
@@NONFLAT4:
	DB $66;	MOV		AX,[WORD PTR XX1]
	DB $66;	MOV		[WORD PTR CX2],AX
	DB $66;	MOV		AX,[WORD PTR CC1]
	DB $66;	MOV		[WORD PTR PC2],AX
	DB $66;	MOV		AX,[WORD PTR ZZ1]
	DB $66;	MOV		[WORD PTR PZ2],AX
@@OK13:

			MOV		AX,[Y1]
			MOV		[Y],AX

			MOV		ES,[VideoSeg]
			CMP		AX,[ClipY1]
			JGE		@@OK13_2
			MOV		AX,[ClipY1]
@@OK13_2:
			MOV		DI,AX
			SHL		AX,8
			SHL		DI,6
			ADD		DI,AX
@@LINELOOP:
			MOV		AX,[Y]
			CMP		AX,[ClipY1]
			JL		@@NEXTLINE
			CMP		AX,[ClipY2]
			JG		@@EXIT
			CMP		AX,[Y3]
			JG		@@EXIT
	DB $66;	MOV		AX,[WORD PTR CX1]
	DB $66;	CMP		AX,[WORD PTR CX2]
			JLE		@@OK14
	DB $66;	MOV		[WORD PTR MX2],AX
	DB $66;	MOV		AX,[WORD PTR CX2]
	DB $66;	MOV		[WORD PTR MX1],AX
	DB $66;	MOV		AX,[WORD PTR PC1]
	DB $66;	MOV		[WORD PTR MC2],AX
	DB $66;	MOV		AX,[WORD PTR PC2]
	DB $66;	MOV		[WORD PTR MC1],AX
	DB $66;	MOV		AX,[WORD PTR PZ1]
	DB $66;	MOV		[WORD PTR MZ2],AX
	DB $66;	MOV		AX,[WORD PTR PZ2]
	DB $66;	MOV		[WORD PTR MZ1],AX
			JMP		@@OK15
@@OK14:
	DB $66;	MOV		[WORD PTR MX1],AX
	DB $66;	MOV		AX,[WORD PTR CX2]
	DB $66;	MOV		[WORD PTR MX2],AX
	DB $66;	MOV		AX,[WORD PTR PC1]
	DB $66;	MOV		[WORD PTR MC1],AX
	DB $66;	MOV		AX,[WORD PTR PC2]
	DB $66;	MOV		[WORD PTR MC2],AX
	DB $66;	MOV		AX,[WORD PTR PZ1]
	DB $66;	MOV		[WORD PTR MZ1],AX
	DB $66;	MOV		AX,[WORD PTR PZ2]
	DB $66;	MOV		[WORD PTR MZ2],AX
@@OK15:

	DB $66;	XOR		CX,CX
	DB $66;	SAR		[WORD PTR MX1],Scaler
	DB $66;	ADC		[WORD PTR MX1],CX
	DB $66;	SAR		[WORD PTR MX2],Scaler
	DB $66;	ADC		[WORD PTR MX2],CX

	DB $66;	MOV		AX,[WORD PTR MX1]
	DB $66;	CMP		AX,[WORD PTR MX2]
			JNE		@@NONFLAT5
	DB $66;	XOR		AX,AX
	DB $66;	MOV		[WORD PTR DCC1],AX
	DB $66;	MOV		[WORD PTR DZZ1],AX
			JMP		@@OK17
@@NONFLAT5:
	DB $66;	MOV		BX,[WORD PTR MX2]
	DB $66;	SUB		BX,[WORD PTR MX1]
	DB $66;	MOV		AX,[WORD PTR MC2]
	DB $66;	SUB		AX,[WORD PTR MC1]
	DB $66;	CWD
	DB $66;	IDIV	BX
	DB $66;	MOV		[WORD PTR DCC1],AX

	DB $66;	MOV		AX,[WORD PTR MZ2]
	DB $66;	SUB		AX,[WORD PTR MZ1]
	DB $66;	CWD
	DB $66;	IDIV	BX
	DB $66;	MOV		[WORD PTR DZZ1],AX
@@OK17:
			MOV		SI,DI
			MOV		AX,[WORD PTR MX1]
			CMP		AX,[ClipX1]
			JGE		@@OK17_2
			MOV		AX,[ClipX1]
@@OK17_2:
			ADD		DI,AX
@@LOOP1:
			MOV		AX,[WORD PTR MX1]
			CMP		AX,[ClipX1]
			JL		@@NEXTPIXEL
			CMP		AX,[ClipX2]
			JG		@@ENDOFLINE
			CMP		AX,[WORD PTR MX2]
			JG		@@ENDOFLINE

	DB $66;	MOV		AX,[WORD PTR MC1]
	DB $66;	XOR		BX,BX
	DB $66;	SAR     AX,Scaler
	DB $66;	ADC		AX,BX

	DB $66;	MOV		CX,[WORD PTR MZ1]
	DB $66;	SAR		CX,Scaler
	DB $66;	ADC		CX,BX

			CMP		CL,[DS:DI]
			JBE		@@NOTPLOT

			OR		[ES:DI],AL
			MOV		[DS:DI],CL
@@NOTPLOT:
			INC		DI
@@NEXTPIXEL:
			INC		[WORD PTR MX1]
	DB $66;	MOV		AX,[WORD PTR DCC1]
	DB $66;	ADD		[WORD PTR MC1],AX
	DB $66;	MOV		AX,[WORD PTR DZZ1]
	DB $66;	ADD		[WORD PTR MZ1],AX
			JMP		@@LOOP1
@@ENDOFLINE:
			MOV		DI,SI
			ADD		DI,320
@@NEXTLINE:

	DB $66;	MOV		AX,[WORD PTR DX3]
	DB $66;	ADD		[WORD PTR CX1],AX
	DB $66;	MOV		AX,[WORD PTR DC3]
	DB $66;	ADD		[WORD PTR PC1],AX
	DB $66;	MOV		AX,[WORD PTR DZ3]
	DB $66;	ADD		[WORD PTR PZ1],AX

			MOV		AX,[Y]
			CMP		AX,[Y2]
			JL		@@TOPPART
	DB $66;	MOV		AX,[WORD PTR DX2]
	DB $66;	ADD		[WORD PTR CX2],AX
	DB $66;	MOV		AX,[WORD PTR DC2]
	DB $66;	ADD		[WORD PTR PC2],AX
	DB $66;	MOV		AX,[WORD PTR DZ2]
	DB $66;	ADD		[WORD PTR PZ2],AX
			JMP		@@OK18
@@TOPPART:
	DB $66;	MOV		AX,[WORD PTR DX1]
	DB $66;	ADD		[WORD PTR CX2],AX
	DB $66;	MOV		AX,[WORD PTR DC1]
	DB $66;	ADD		[WORD PTR PC2],AX
	DB $66;	MOV		AX,[WORD PTR DZ1]
	DB $66;	ADD		[WORD PTR PZ2],AX
@@OK18:
			INC		[Y]
			JMP		@@LINELOOP
@@EXIT:
			POP		DS
End;

Procedure XHLine(Y,X1,X2 : Integer; Color : Byte; VideoSeg : Word); Assembler;
Asm
		MOV		AX,[Y]
		TEST	AX,AX
		JL		@@EXIT
		CMP		AX,199
		JG		@@EXIT
		MOV		AX,[X1]
		TEST	AX,AX
		JGE		@@OK1
		MOV		BX,[X2]
		TEST	BX,BX
		JGE		@@OK1
		JMP		@@EXIT
@@OK1:
		MOV		BX,[X2]
		CMP		AX,319
		JLE		@@OK2
		CMP		BX,319
		JLE		@@OK2
		JMP		@@EXIT
@@OK2:
		TEST	AX,AX
		JGE		@@OK3
		XOR		AX,AX
@@OK3:
		CMP		BX,319
		JLE		@@OK4
		MOV		BX,319
@@OK4:
		MOV		CX,BX
		SUB		CX,AX
		INC		CX
		MOV		ES,[VideoSeg]
		MOV		DI,[Y]
		MOV		BX,DI
		SHL		BX,6
		SHL		DI,8
		ADD		DI,BX
		ADD		DI,AX
		MOV		AL,[Color]
		CLD
		REP		STOSB
@@EXIT:
End;

Procedure XVLine(X,Y1,Y2 : Integer; Color : Byte; VideoSeg : Word);
Var
	Y	: Integer;
Begin
	For Y:=Y1 To Y2 Do
		XPlot(X,Y,Color,VideoSeg);
End;

Procedure AsmRotate32(Var SourcePoints,DestPoints : Array Of TPoint32;
	PointCount : Word; RX,RY,RZ	: Integer); Assembler;
Var
	XS,XC,YS,YC,ZS,ZC	: LongInt;
	X1,Y1,Z1			: LongInt;
Asm
			PUSH	DS
			MOV		DX,[TableMask]
			LES		DI,[DWORD PTR _S]
			LDS		SI,[DWORD PTR _C]
			MOV		BX,[RX]
			AND		BX,DX
			SHL		BX,1
	DB $66;	DB $26, $0F, $BF, $01			{ MOVSX EAX, [WORD ES:DI+BX] }
	DB $66;	MOV		[WORD PTR XS],AX
	DB $66;	DB $0F, $BF, $00				{ MOVSX EAX, [WORD DS:SI+BX] }
	DB $66;	MOV		[WORD PTR XC],AX
			MOV		BX,[RY]
			AND		BX,DX
			SHL		BX,1
	DB $66;	DB $26, $0F, $BF, $01			{ MOVSX EAX, [WORD ES:DI+BX] }
	DB $66;	MOV		[WORD PTR YS],AX
	DB $66;	DB $0F, $BF, $00				{ MOVSX EAX, [WORD DS:SI+BX] }
	DB $66;	MOV		[WORD PTR YC],AX
			MOV		BX,[RZ]
			AND		BX,DX
			SHL		BX,1
	DB $66;	DB $26, $0F, $BF, $01			{ MOVSX EAX, [WORD ES:DI+BX] }
	DB $66;	MOV		[WORD PTR ZS],AX
	DB $66;	DB $0F, $BF, $00				{ MOVSX EAX, [WORD DS:SI+BX] }
	DB $66;	MOV		[WORD PTR ZC],AX

			LDS		SI,[DWORD PTR SourcePoints]
			LES		DI,[DWORD PTR DestPoints]
			MOV		CX,[PointCount]
@@POINTLOOP:
			PUSH	CX

	DB $66;	MOV		AX,[WORD PTR DS:SI+4]
	DB $66;	IMUL	[WORD PTR XC]
	DB $66;	MOV		BX,AX
	DB $66;	MOV		AX,[WORD PTR DS:SI+8]
	DB $66;	IMUL	[WORD PTR XS]
	DB $66;	ADD		BX,AX
	DB $66;	SAR		BX,8
	DB $66;	MOV		[WORD PTR Y1],BX		{ Y1 = (Y*_C[RX]+Z*_S[RX]) DIV 256 }

	DB $66;	MOV		AX,[WORD PTR DS:SI+4]
	DB $66;	NEG		AX
	DB $66;	IMUL	[WORD PTR XS]
	DB $66;	MOV		CX,AX
	DB $66;	MOV		AX,[WORD PTR DS:SI+8]
	DB $66;	IMUL	[WORD PTR XC]
	DB $66;	ADD		CX,AX
	DB $66;	SAR		CX,8
	DB $66;	MOV		[WORD PTR Z1],CX		{ Z1 = (-Y*_S[RX]+Z*_C[RX]) DIV 256 }

	DB $66;	MOV		AX,[WORD PTR DS:SI]
	DB $66;	IMUL	[WORD PTR YC]
	DB $66;	MOV		BX,AX
	DB $66;	MOV		AX,CX
	DB $66;	IMUL	[WORD PTR YS]
	DB $66;	ADD		BX,AX
	DB $66;	SAR		BX,8
	DB $66;	MOV		[WORD PTR X1],BX		{ X1:=(X*_C[RY]+Z1*_S[RY]) Div 256; }
	DB $66;	MOV		AX,[WORD PTR DS:SI]
	DB $66;	NEG		AX
	DB $66;	IMUL	[WORD PTR YS]
	DB $66;	MOV		BX,AX
	DB $66;	MOV		AX,CX
	DB $66;	IMUL	[WORD PTR YC]
	DB $66;	ADD		BX,AX
	DB $66;	SAR		BX,8
	DB $66;	MOV		[ES:DI+8],BX			{ CZ := (-X*_S[RY]+Z1*_C[RY]) DIV 256; }

	DB $66;	MOV		AX,[WORD PTR X1]
	DB $66;	IMUL	[WORD PTR ZC]
	DB $66;	MOV		BX,AX
	DB $66;	MOV		AX,[WORD PTR Y1]
	DB $66;	IMUL	[WORD PTR ZS]
	DB $66;	ADD		BX,AX
	DB $66;	SAR		BX,8
	DB $66;	MOV		[ES:DI],BX				{ CX := (X1*_C[RZ]+Y1*_S[RZ]) DIV 256; }

	DB $66;	MOV		AX,[WORD PTR X1]
	DB $66;	NEG		AX
	DB $66;	IMUL	[WORD PTR ZS]
	DB $66;	MOV		BX,AX
	DB $66;	MOV		AX,[WORD PTR Y1]
	DB $66;	IMUL	[WORD PTR ZC]
	DB $66;	ADD		BX,AX
	DB $66;	SAR		BX,8
	DB $66;	MOV		[ES:DI+4],BX			{ CY := (-X1*_S[RZ]+Y1*_C[RZ]) DIV 256; }

			ADD		SI,12
			ADD		DI,12
			POP		CX
			DEC		CX
			JNZ		@@POINTLOOP
			POP		DS
End;

Procedure XVGourad(X,Y1,Y2 : Integer; C1,C2 : Byte; VideoSeg : Word); Assembler;
Var
	CC1,CC2,DC	: LongInt;
Asm
			MOV		AX,[X]
			CMP		AX,0
			JL		@@EXIT
			CMP		AX,319
			JG		@@EXIT

	DB $66;	DB $0F, $BF, $46, OFFSET C1
	DB $66;	SHL		AX,Scaler
	DB $66;	MOV		[WORD PTR CC1],AX

	DB $66;	DB $0F, $BF, $46, OFFSET C2
	DB $66;	SHL		AX,Scaler
	DB $66;	MOV		[WORD PTR CC2],AX

			MOV		AX,[Y1]
			CMP		AX,[Y2]
			JNE		@@NONFLAT
	DB $66;	XOR		AX,AX
	DB $66;	MOV		[WORD PTR DC],AX
			JMP		@@OK3
@@NONFLAT:
	DB $66;	MOV		AX,[WORD PTR CC2]
	DB $66;	SUB		AX,[WORD PTR CC1]
	DB $66;	CWD
	DB $66;	DB $0F, $BF, $5E, OFFSET Y2
	DB $66;	DB $0F, $BF, $4E, OFFSET Y1
	DB $66;	SUB		BX,CX
	DB $66;	IDIV	BX
	DB $66;	MOV		[WORD PTR DC],AX
	DB $66;	MOV		AX,[WORD PTR CC1]
@@OK3:

			MOV		ES,[VideoSeg]
			MOV		AX,[Y1]
			CMP		AX,0
			JGE		@@OK2
			SUB		AX,AX
@@OK2:
			MOV		DI,AX
			SHL		DI,6
			SHL		AX,8
			ADD		DI,AX
			ADD		DI,[X]
			MOV		AX,[Y1]
	DB $66;	MOV		BX,[WORD PTR CC1]
	DB $66;	MOV		CX,[WORD PTR DC]
@@LOOP1:
			CMP		AX,0
			JL		@@NEXTLINE
			CMP		AX,199
			JG		@@EXIT
			CMP		AX,[Y2]
			JG		@@EXIT
	DB $66;	MOV		SI,BX
	DB $66;	SHR		BX,Scaler
			MOV		[ES:DI],BL
	DB $66;	MOV		BX,SI
	DB $66;	ADD		BX,CX
			ADD		DI,320
@@NEXTLINE:
			INC		AX
			JMP		@@LOOP1
@@EXIT:
End;

Procedure XHGourad(Y,X1,X2 : Integer; C1,C2 : Byte; VideoSeg : Word); Assembler;
Var
	CC1,CC2,DC	: LongInt;
Asm
			MOV		AX,[y]
			CMP		AX,0
			JL		@@EXIT
			CMP		AX,199
			JG		@@EXIT

	DB $66;	DB $0F, $BF, $46, OFFSET C1
	DB $66;	SHL		AX,Scaler
	DB $66;	MOV		[WORD PTR CC1],AX

	DB $66;	DB $0F, $BF, $46, OFFSET C2
	DB $66;	SHL		AX,Scaler
	DB $66;	MOV		[WORD PTR CC2],AX

			MOV		AX,[X1]
			CMP		AX,[X2]
			JNE		@@NONFLAT
	DB $66;	XOR		AX,AX
	DB $66;	MOV		[WORD PTR DC],AX
			JMP		@@OK3
@@NONFLAT:
	DB $66;	MOV		AX,[WORD PTR CC2]
	DB $66;	SUB		AX,[WORD PTR CC1]
	DB $66;	CWD
	DB $66;	DB $0F, $BF, $5E, OFFSET X2
	DB $66;	DB $0F, $BF, $4E, OFFSET X1
	DB $66;	SUB		BX,CX
	DB $66;	IDIV	BX
	DB $66;	MOV		[WORD PTR DC],AX
	DB $66;	MOV		AX,[WORD PTR CC1]
@@OK3:

			MOV		ES,[VideoSeg]
			MOV		AX,[X1]
			CMP		AX,0
			JGE		@@OK2
			SUB		AX,AX
@@OK2:
			MOV		DI,[Y]
			MOV		BX,DI
			SHL		DI,6
			SHL		BX,8
			ADD		DI,AX
			ADD		DI,BX
			MOV		AX,[X1]
	DB $66;	MOV		BX,[WORD PTR CC1]
	DB $66;	MOV		CX,[WORD PTR DC]
@@LOOP1:
			CMP		AX,0
			JL		@@NEXTLINE
			CMP		AX,319
			JG		@@EXIT
			CMP		AX,[X2]
			JG		@@EXIT
	DB $66;	MOV		SI,BX
	DB $66;	SHR		BX,Scaler
			MOV		[ES:DI],BL
	DB $66;	MOV		BX,SI
	DB $66;	ADD		BX,CX
			INC		DI
@@NEXTLINE:
			INC		AX
			JMP		@@LOOP1
@@EXIT:
End;

Procedure XVWideGourad(X1,Y1,X2,Y2 : Integer; C1,C2 : Byte; VideoSeg : Word); Assembler;
Var
	Y			: Integer;
	CC1,CC2,DC	: LongInt;
	Width		: Word;
	DeltaLine	: Word;
Asm
			MOV		AX,[Y1]
			CMP		AX,[Y2]
			JLE		@@OK1_4
			XCHG	AX,[Y2]
			MOV		[Y1],AX
			MOV		AL,[C1]
			XCHG	AL,[C2]
			MOV		[C1],AL
@@OK1_4:
			MOV		AX,[X2]
			CMP		AX,[X1]
			JGE		@@OK1_3
			XCHG	AX,[X1]
			MOV		[X2],AX
@@OK1_3:
			CMP		AX,0
			JL		@@EXIT
			MOV		AX,[X1]
			CMP		AX,319
			JG		@@EXIT
			MOV		AX,[X1]
			CMP		AX,0
			JGE		@@OK1_1
			XOR		AX,AX
@@OK1_1:
			MOV		[X1],AX
			MOV		AX,[X2]
			CMP		AX,319
			JLE		@@OK2_1
			MOV		AX,319
@@OK2_1:
			MOV		[X2],AX

			MOV		AX,[X2]
			SUB		AX,[X1]
			INC		AX
			MOV		[Width],AX

	DB $66;	DB $0F, $BF, $46, OFFSET C1
	DB $66;	SHL		AX,Scaler
	DB $66;	MOV		[WORD PTR CC1],AX

	DB $66;	DB $0F, $BF, $46, OFFSET C2
	DB $66;	SHL		AX,Scaler
	DB $66;	MOV		[WORD PTR CC2],AX

			MOV		AX,[Y1]
			CMP		AX,[Y2]
			JNE		@@NONFLAT
	DB $66;	XOR		AX,AX
	DB $66;	MOV		[WORD PTR DC],AX
			JMP		@@OK3
@@NONFLAT:
	DB $66;	MOV		AX,[WORD PTR CC2]
	DB $66;	SUB		AX,[WORD PTR CC1]
	DB $66;	CWD
	DB $66;	DB $0F, $BF, $5E, OFFSET Y2
	DB $66;	DB $0F, $BF, $4E, OFFSET Y1
	DB $66;	SUB		BX,CX
	DB $66;	IDIV	BX
	DB $66;	MOV		[WORD PTR DC],AX
	DB $66;	MOV		AX,[WORD PTR CC1]
@@OK3:

			MOV		ES,[VideoSeg]
			MOV		AX,[Y1]
			CMP		AX,0
			JGE		@@OK2
			SUB		AX,AX
@@OK2:
			MOV		DI,AX
			SHL		DI,6
			SHL		AX,8
			ADD		DI,AX
			ADD		DI,[X1]

			MOV		AX,320
			SUB		AX,[Width]
			MOV		[DeltaLine],AX

			MOV		AX,[Y1]
	DB $66;	MOV		BX,[WORD PTR CC1]
	DB $66;	MOV		CX,[WORD PTR DC]

@@LOOP1:
			CMP		AX,0
			JL		@@NEXTLINE
			CMP		AX,199
			JG		@@EXIT
			CMP		AX,[Y2]
			JG		@@EXIT
	DB $66;	MOV		SI,BX
	DB $66;	SHR		BX,Scaler
			PUSH	CX
			PUSH	BX
			PUSH	AX
			MOV		AL,BL
			MOV		AH,AL
			PUSH	AX
	DB $66;	SHL		AX,16
			POP		AX
			CLD
			MOV		CX,[Width]
			SHR		CX,1
			DB $0F, $92, $C7				{ SETC BL }
			SHR		CX,1
	DB $66;	REP		STOSW
			JNC		@@SKIP1
			STOSW
@@SKIP1:
			OR		BH,BH
			JZ		@@SKIP2
			STOSB
@@SKIP2:
			POP		AX
			POP		BX
			POP		CX
	DB $66;	MOV		BX,SI
	DB $66;	ADD		BX,CX
			ADD		DI,[DeltaLine]
@@NEXTLINE:
			INC		AX
			JMP		@@LOOP1
@@EXIT:
End;

Procedure XLine(X1,Y1,X2,Y2 : Integer; Color : Byte; VideoSeg : Word); Assembler;
Var
	XX1,XX2	: LongInt;
	YY1,YY2	: LongInt;
	DDX,DDY	: LongInt;
	X,Y		: LongInt;
	LastX	: Integer;
	LastY	: Integer;
Asm
			MOV		DX,[Y1]
			CMP		DX,[Y2]
			JNE		@@NONHORIZ

			TEST	DX,DX
			JL		@@EXIT
			CMP		DX,199
			JG		@@EXIT
			MOV		AX,[X1]
			MOV		BX,[X2]
			CMP		AX,BX
			JLE		@@OK1
			XCHG	AX,BX
@@OK1:
			CMP		AX,319
			JG		@@EXIT
			TEST	BX,BX
			JL		@@EXIT
			TEST	AX,AX
			JGE		@@OK2
			SUB		AX,AX
@@OK2:
			MOV		CX,BX
			CMP		CX,319
			JLE		@@OK3
			MOV		CX,319
@@OK3:
			SUB		CX,AX
			INC		CX
			MOV		DI,DX
			SHL		DI,6
			SHL		DX,8
			ADD		DI,DX
			ADD		DI,AX
			MOV		ES,[VideoSeg]
			MOV		AL,[Color]
			MOV		AH,AL
			MOV		BX,AX
	DB $66;	SHL		AX,16
			MOV		AX,BX
			CLD
			SHR		CX,1
			DB $0F, $92, $C3			{ SETC BL }
			SHR		CX,1
	DB $66;	REP		STOSW
			JNC		@@SKIP1
			STOSW
@@SKIP1:
			OR		BL,BL
			JZ		@@SKIP2
			STOSB
@@SKIP2:
			JMP		@@EXIT
@@NONHORIZ:
			MOV		DX,[X1]
			CMP		DX,[X2]
			JNE		@@NONVERTIC
			MOV		DX,[X1]
			TEST	DX,DX
			JL		@@EXIT
			CMP		DX,319
			JG		@@EXIT
			MOV		AX,[Y1]
			MOV		BX,[Y2]
			CMP		AX,BX
			JLE		@@OK4
			XCHG	AX,BX
@@OK4:
			CMP		AX,199
			JG		@@EXIT
			TEST	BX,BX
			JL		@@EXIT
			TEST	AX,AX
			JGE		@@OK5
			SUB		AX,AX
@@OK5:
			MOV		CX,BX
			CMP		CX,199
			JLE		@@OK6
			MOV		CX,199
@@OK6:
			SUB		CX,AX
			INC		CX
			MOV		DI,AX
			SHL		DI,6
			SHL		AX,8
			ADD		DI,AX
			ADD		DI,DX
			MOV		ES,[VideoSeg]
			MOV		AL,[Color]
@@LOOP:
			MOV		[ES:DI],AL
			ADD		DI,320
			DEC		CX
			JNZ		@@LOOP
			JMP		@@EXIT
@@NONVERTIC:
			MOV		AX,[Y2]
			SUB		AX,[Y1]
			JNS		@@OK6_1
			NEG		AX
@@OK6_1:
			MOV		BX,[X2]
			SUB		BX,[X1]
			JNS		@@OK6_2
			NEG		BX
@@OK6_2:
			CMP		AX,BX
			JLE		@@LINE_2

			MOV		AX,[Y1]
			CMP		AX,[Y2]
			JLE		@@OK7
			XCHG	AX,[Y2]
			MOV		[Y1],AX
			MOV		AX,[X1]
			XCHG	AX,[X2]
			MOV		[X1],AX
@@OK7:
	DB $66;	DB $0F, $BF, $5E, OFFSET X1	{ MOVSX EAX,[WORD PTR Y1] }
	DB $66;	SHL		BX,Scaler
	DB $66;	MOV		[WORD PTR XX1],BX
	DB $66;	DB $0F, $BF, $46, OFFSET X2	{ MOVSX EAX,[WORD PTR Y2] }
	DB $66;	SHL		AX,Scaler
	DB $66;	MOV		[WORD PTR XX2],AX

	DB $66;	SUB		AX,BX
	DB $66;	CWD
	DB $66;	DB $0F, $BF, $5E, OFFSET Y2
	DB $66;	DB $0F, $BF, $4E, OFFSET Y1
	DB $66;	SUB		BX,CX
	DB $66;	IDIV	BX
	DB $66;	MOV		[WORD PTR DDX],AX

			MOV		AX,[X1]
			TEST	AX,AX
			JGE		@@OK8
			SUB		AX,AX
@@OK8:
			CMP		AX,319
			JLE		@@OK8_2
			MOV		AX,319
@@OK8_2:
			MOV		[LASTX],AX
			MOV		DI,AX
			MOV		AX,[Y1]
			TEST	AX,AX
			JGE		@@OK9
			SUB		AX,AX
@@OK9:
			CMP		AX,199
			JLE		@@OK9_2
			MOV		AX,199
@@OK9_2:
			MOV		BX,AX
			SHL		AX,6
			SHL		BX,8
			ADD		DI,AX
			ADD		DI,BX

			MOV		DX,[Y1]
			MOV		CL,[Color]
			MOV		ES,[VideoSeg]
	DB $66;	MOV		BX,[WORD PTR XX1]
	DB $66;	MOV		SI,[WORD PTR DDX]
@@LOOP2:
	DB $66;	MOV		AX,BX
	DB $66;	SAR		AX,Scaler
			JNC		@@NOTROUND
	DB $66;	INC		AX
@@NOTROUND:
			CMP		AX,0
			JL		@@NEXTPIXEL
			CMP		AX,319
			JG		@@NEXTPIXEL
			CMP		AX,[LASTX]
			JE		@@OK10
			JG		@@GORIGHT
			DEC		DI
			JMP		@@ADJUSTED
@@GORIGHT:
			INC		DI
@@ADJUSTED:
			MOV		[LASTX],AX
@@OK10:
			CMP		DX,0
			JL		@@NEXTPIXEL
			CMP		DX,199
			JG		@@EXIT

			MOV		[ES:DI],CL
@@NEXTPIXEL:
			CMP		DX,0
			JL		@@NEXTHORZ
			CMP		DX,199
			JG		@@EXIT
			ADD		DI,320
@@NEXTHORZ:
	DB $66;	ADD		BX,SI
			INC		DX
			CMP		DX,[Y2]
			JLE		@@LOOP2
			JMP		@@EXIT
@@LINE_2:
			MOV		AX,[X1]
			CMP		AX,[X2]
			JLE		@@OK7_2
			XCHG	AX,[X2]
			MOV		[X1],AX
			MOV		AX,[Y1]
			XCHG	AX,[Y2]
			MOV		[Y1],AX
@@OK7_2:
	DB $66;	DB $0F, $BF, $5E, OFFSET Y1	{ MOVSX EAX,[WORD PTR Y1] }
	DB $66;	SHL		BX,Scaler
	DB $66;	MOV		[WORD PTR YY1],BX
	DB $66;	DB $0F, $BF, $46, OFFSET Y2	{ MOVSX EAX,[WORD PTR Y2] }
	DB $66;	SHL		AX,Scaler
	DB $66;	MOV		[WORD PTR YY2],AX

	DB $66;	SUB		AX,BX
	DB $66;	CWD
	DB $66;	DB $0F, $BF, $5E, OFFSET X2
	DB $66;	DB $0F, $BF, $4E, OFFSET X1
	DB $66;	SUB		BX,CX
	DB $66;	IDIV	BX
	DB $66;	MOV		[WORD PTR DDY],AX

			MOV		AX,[X1]
			TEST	AX,AX
			JGE		@@OK8_3
			SUB		AX,AX
@@OK8_3:
			MOV		DI,AX
			MOV		AX,[Y1]
			TEST	AX,AX
			JGE		@@OK9_3
			SUB		AX,AX
@@OK9_3:
			CMP		AX,199
			JLE		@@OK9_4
			MOV		AX,199
@@OK9_4:
			MOV		[LASTY],AX
			MOV		BX,AX
			SHL		AX,6
			SHL		BX,8
			ADD		DI,AX
			ADD		DI,BX

			MOV		DX,[X1]
			MOV		CL,[Color]
			MOV		ES,[VideoSeg]
	DB $66;	MOV		BX,[WORD PTR YY1]
	DB $66;	MOV		SI,[WORD PTR DDY]
@@LOOP3:
	DB $66;	MOV		AX,BX
	DB $66;	SAR		AX,Scaler
			JNC		@@NOTROUND2
	DB $66;	INC		AX
@@NOTROUND2:
			CMP		AX,0
			JL		@@NEXTPIXEL2
			CMP		AX,199
			JG		@@NEXTPIXEL2
			CMP		AX,[LASTY]
			JE		@@OK10_2
			JG		@@GODOWN
			SUB		DI,320
			JMP		@@ADJUSTED2
@@GODOWN:
			ADD		DI,320
@@ADJUSTED2:
			MOV		[LASTY],AX
@@OK10_2:
			CMP		DX,0
			JL		@@NEXTPIXEL2
			CMP		DX,319
			JG		@@EXIT

			MOV		[ES:DI],CL
@@NEXTPIXEL2:
			CMP		DX,0
			JL		@@NEXTVERT
			CMP		DX,319
			JG		@@EXIT
			INC		DI
@@NEXTVERT:
	DB $66;	ADD		BX,SI
			INC		DX
			CMP		DX,[X2]
			JLE		@@LOOP3
@@EXIT:
End;

Procedure XLineClip(X1,Y1,X2,Y2,ClipX1,ClipY1,ClipX2,ClipY2 : Integer; Color : Byte; VideoSeg : Word); Assembler;
Var
	XX1,XX2	: LongInt;
	YY1,YY2	: LongInt;
	DDX,DDY	: LongInt;
	X,Y		: LongInt;
	LastX	: Integer;
	LastY	: Integer;
Asm
			MOV		DX,[Y1]
			CMP		DX,[Y2]
			JNE		@@NONHORIZ

			CMP		DX,[ClipY1]
			JL		@@EXIT
			CMP		DX,[ClipY2]
			JG		@@EXIT
			MOV		AX,[X1]
			MOV		BX,[X2]
			CMP		AX,BX
			JLE		@@OK1
			XCHG	AX,BX
@@OK1:
			CMP		AX,[ClipX2]
			JG		@@EXIT
			CMP		BX,[ClipX1]
			JL		@@EXIT
			CMP		AX,[ClipX1]
			JGE		@@OK2
			MOV		AX,[ClipX1]
@@OK2:
			MOV		CX,BX
			CMP		CX,[ClipX2]
			JLE		@@OK3
			MOV		CX,[ClipX2]
@@OK3:
			SUB		CX,AX
			INC		CX
			MOV		DI,DX
			SHL		DI,6
			SHL		DX,8
			ADD		DI,DX
			ADD		DI,AX
			MOV		ES,[VideoSeg]
			MOV		AL,[Color]
			MOV		AH,AL
			MOV		BX,AX
	DB $66;	SHL		AX,16
			MOV		AX,BX
			CLD
			SHR		CX,1
			DB $0F, $92, $C3			{ SETC BL }
			SHR		CX,1
	DB $66;	REP		STOSW
			JNC		@@SKIP1
			STOSW
@@SKIP1:
			OR		BL,BL
			JZ		@@SKIP2
			STOSB
@@SKIP2:
			JMP		@@EXIT
@@NONHORIZ:
			MOV		DX,[X1]
			CMP		DX,[X2]
			JNE		@@NONVERTIC
			MOV		DX,[X1]
			CMP		DX,[ClipX1]
			JL		@@EXIT
			CMP		DX,[ClipX2]
			JG		@@EXIT
			MOV		AX,[Y1]
			MOV		BX,[Y2]
			CMP		AX,BX
			JLE		@@OK4
			XCHG	AX,BX
@@OK4:
			CMP		AX,[ClipY2]
			JG		@@EXIT
			CMP		BX,[ClipY1]
			JL		@@EXIT
			CMP		AX,[ClipY1]
			JGE		@@OK5
			MOV		AX,[ClipY1]
@@OK5:
			MOV		CX,BX
			CMP		CX,[ClipY2]
			JLE		@@OK6
			MOV		CX,[ClipY2]
@@OK6:
			SUB		CX,AX
			INC		CX
			MOV		DI,AX
			SHL		DI,6
			SHL		AX,8
			ADD		DI,AX
			ADD		DI,DX
			MOV		ES,[VideoSeg]
			MOV		AL,[Color]
@@LOOP:
			MOV		[ES:DI],AL
			ADD		DI,320
			DEC		CX
			JNZ		@@LOOP
			JMP		@@EXIT
@@NONVERTIC:
			MOV		AX,[Y2]
			SUB		AX,[Y1]
			JNS		@@OK6_1
			NEG		AX
@@OK6_1:
			MOV		BX,[X2]
			SUB		BX,[X1]
			JNS		@@OK6_2
			NEG		BX
@@OK6_2:
			CMP		AX,BX
			JLE		@@LINE_2

			MOV		AX,[Y1]
			CMP		AX,[Y2]
			JLE		@@OK7
			XCHG	AX,[Y2]
			MOV		[Y1],AX
			MOV		AX,[X1]
			XCHG	AX,[X2]
			MOV		[X1],AX
@@OK7:
	DB $66;	DB $0F, $BF, $5E, OFFSET X1	{ MOVSX EAX,[WORD PTR Y1] }
	DB $66;	SHL		BX,Scaler
	DB $66;	MOV		[WORD PTR XX1],BX
	DB $66;	DB $0F, $BF, $46, OFFSET X2	{ MOVSX EAX,[WORD PTR Y2] }
	DB $66;	SHL		AX,Scaler
	DB $66;	MOV		[WORD PTR XX2],AX

	DB $66;	SUB		AX,BX
	DB $66;	CWD
	DB $66;	DB $0F, $BF, $5E, OFFSET Y2
	DB $66;	DB $0F, $BF, $4E, OFFSET Y1
	DB $66;	SUB		BX,CX
	DB $66;	IDIV	BX
	DB $66;	MOV		[WORD PTR DDX],AX

			MOV		AX,[X1]
			CMP		AX,[ClipX1]
			JGE		@@OK8
			MOV		AX,[ClipX1]
@@OK8:
			CMP		AX,[ClipX2]
			JLE		@@OK8_2
			MOV		AX,[ClipX2]
@@OK8_2:
			MOV		[LASTX],AX
			MOV		DI,AX
			MOV		AX,[Y1]
			CMP		AX,[ClipY1]
			JGE		@@OK9
			MOV		AX,[ClipY1]
@@OK9:
			CMP		AX,[ClipY2]
			JLE		@@OK9_2
			MOV		AX,[ClipY2]
@@OK9_2:
			MOV		BX,AX
			SHL		AX,6
			SHL		BX,8
			ADD		DI,AX
			ADD		DI,BX

			MOV		DX,[Y1]
			MOV		CL,[Color]
			MOV		ES,[VideoSeg]
	DB $66;	MOV		BX,[WORD PTR XX1]
	DB $66;	MOV		SI,[WORD PTR DDX]
@@LOOP2:
	DB $66;	MOV		AX,BX
	DB $66;	SAR		AX,Scaler
			JNC		@@NOTROUND
	DB $66;	INC		AX
@@NOTROUND:
			CMP		AX,[ClipX1]
			JL		@@NEXTPIXEL
			CMP		AX,[ClipX2]
			JG		@@NEXTPIXEL
			CMP		AX,[LASTX]
			JE		@@OK10
			JG		@@GORIGHT
			DEC		DI
			JMP		@@ADJUSTED
@@GORIGHT:
			INC		DI
@@ADJUSTED:
			MOV		[LASTX],AX
@@OK10:
			CMP		DX,[ClipY1]
			JL		@@NEXTPIXEL
			CMP		DX,[ClipY2]
			JG		@@EXIT

			MOV		[ES:DI],CL
@@NEXTPIXEL:
			CMP		DX,[ClipY1]
			JL		@@NEXTHORZ
			CMP		DX,[ClipY2]
			JG		@@EXIT
			ADD		DI,320
@@NEXTHORZ:
	DB $66;	ADD		BX,SI
			INC		DX
			CMP		DX,[Y2]
			JLE		@@LOOP2
			JMP		@@EXIT
@@LINE_2:
			MOV		AX,[X1]
			CMP		AX,[X2]
			JLE		@@OK7_2
			XCHG	AX,[X2]
			MOV		[X1],AX
			MOV		AX,[Y1]
			XCHG	AX,[Y2]
			MOV		[Y1],AX
@@OK7_2:
	DB $66;	DB $0F, $BF, $5E, OFFSET Y1	{ MOVSX EAX,[WORD PTR Y1] }
	DB $66;	SHL		BX,Scaler
	DB $66;	MOV		[WORD PTR YY1],BX
	DB $66;	DB $0F, $BF, $46, OFFSET Y2	{ MOVSX EAX,[WORD PTR Y2] }
	DB $66;	SHL		AX,Scaler
	DB $66;	MOV		[WORD PTR YY2],AX

	DB $66;	SUB		AX,BX
	DB $66;	CWD
	DB $66;	DB $0F, $BF, $5E, OFFSET X2
	DB $66;	DB $0F, $BF, $4E, OFFSET X1
	DB $66;	SUB		BX,CX
	DB $66;	IDIV	BX
	DB $66;	MOV		[WORD PTR DDY],AX

			MOV		AX,[X1]
			CMP		AX,[ClipX1]
			JGE		@@OK8_3
			MOV		AX,[ClipX1]
@@OK8_3:
			MOV		DI,AX
			MOV		AX,[Y1]
			CMP		AX,[ClipY1]
			JGE		@@OK9_3
			MOV		AX,[ClipY1]
@@OK9_3:
			CMP		AX,[ClipY2]
			JLE		@@OK9_4
			MOV		AX,[ClipY2]
@@OK9_4:
			MOV		[LASTY],AX
			MOV		BX,AX
			SHL		AX,6
			SHL		BX,8
			ADD		DI,AX
			ADD		DI,BX

			MOV		DX,[X1]
			MOV		CL,[Color]
			MOV		ES,[VideoSeg]
	DB $66;	MOV		BX,[WORD PTR YY1]
	DB $66;	MOV		SI,[WORD PTR DDY]
@@LOOP3:
	DB $66;	MOV		AX,BX
	DB $66;	SAR		AX,Scaler
			JNC		@@NOTROUND2
	DB $66;	INC		AX
@@NOTROUND2:
			CMP		AX,[ClipY1]
			JL		@@NEXTPIXEL2
			CMP		AX,[ClipY2]
			JG		@@NEXTPIXEL2
			CMP		AX,[LASTY]
			JE		@@OK10_2
			JG		@@GODOWN
			SUB		DI,320
			JMP		@@ADJUSTED2
@@GODOWN:
			ADD		DI,320
@@ADJUSTED2:
			MOV		[LASTY],AX
@@OK10_2:
			CMP		DX,[ClipX1]
			JL		@@NEXTPIXEL2
			CMP		DX,[ClipX2]
			JG		@@EXIT

			MOV		[ES:DI],CL
@@NEXTPIXEL2:
			CMP		DX,[ClipX1]
			JL		@@NEXTVERT
			CMP		DX,[ClipX2]
			JG		@@EXIT
			INC		DI
@@NEXTVERT:
	DB $66;	ADD		BX,SI
			INC		DX
			CMP		DX,[X2]
			JLE		@@LOOP3
@@EXIT:
End;

Procedure XLineGlenzXOR(X1,Y1,X2,Y2 : Integer; Color : Byte; VideoSeg : Word); Assembler;
Var
	XX1,XX2	: LongInt;
	YY1,YY2	: LongInt;
	DDX,DDY	: LongInt;
	X,Y		: LongInt;
	LastX	: Integer;
	LastY	: Integer;
Asm
			MOV		DX,[Y1]
			CMP		DX,[Y2]
			JNE		@@NONHORIZ

			TEST	DX,DX
			JL		@@EXIT
			CMP		DX,199
			JG		@@EXIT
			MOV		AX,[X1]
			MOV		BX,[X2]
			CMP		AX,BX
			JLE		@@OK1
			XCHG	AX,BX
@@OK1:
			CMP		AX,319
			JG		@@EXIT
			TEST	BX,BX
			JL		@@EXIT
			TEST	AX,AX
			JGE		@@OK2
			SUB		AX,AX
@@OK2:
			MOV		CX,BX
			CMP		CX,319
			JLE		@@OK3
			MOV		CX,319
@@OK3:
			SUB		CX,AX
			INC		CX
			MOV		DI,DX
			SHL		DI,6
			SHL		DX,8
			ADD		DI,DX
			ADD		DI,AX
			MOV		ES,[VideoSeg]
			MOV		AL,[Color]
			MOV		AH,AL
			MOV		BX,AX
	DB $66;	SHL		AX,16
			MOV		AX,BX
			CLD
			SHR		CX,1
			DB $0F, $92, $C3			{ SETC BL }
			SHR		CX,1
			DB $0F, $92, $C7
@@STOSLOOP:
			JCXZ	@@SKIP1
	DB $66;	XOR		[ES:DI],AX
			ADD		DI,4
			DEC		CX
			JNZ		@@STOSLOOP
@@SKIP1:
			OR		BH,BH
			JZ		@@SKIP2
			XOR		[ES:DI],AX
			ADD		DI,2
@@SKIP2:
			OR		BL,BL
			JZ		@@SKIP3
			XOR		[ES:DI],AL
			INC		DI
@@SKIP3:
			JMP		@@EXIT
@@NONHORIZ:
			MOV		DX,[X1]
			CMP		DX,[X2]
			JNE		@@NONVERTIC
			MOV		DX,[X1]
			TEST	DX,DX
			JL		@@EXIT
			CMP		DX,319
			JG		@@EXIT
			MOV		AX,[Y1]
			MOV		BX,[Y2]
			CMP		AX,BX
			JLE		@@OK4
			XCHG	AX,BX
@@OK4:
			CMP		AX,199
			JG		@@EXIT
			TEST	BX,BX
			JL		@@EXIT
			TEST	AX,AX
			JGE		@@OK5
			SUB		AX,AX
@@OK5:
			MOV		CX,BX
			CMP		CX,199
			JLE		@@OK6
			MOV		CX,199
@@OK6:
			SUB		CX,AX
			INC		CX
			MOV		DI,AX
			SHL		DI,6
			SHL		AX,8
			ADD		DI,AX
			ADD		DI,DX
			MOV		ES,[VideoSeg]
			MOV		AL,[Color]
@@LOOP:
			XOR		[ES:DI],AL
			ADD		DI,320
			DEC		CX
			JNZ		@@LOOP
			JMP		@@EXIT
@@NONVERTIC:
			MOV		AX,[Y2]
			SUB		AX,[Y1]
			JNS		@@OK6_1
			NEG		AX
@@OK6_1:
			MOV		BX,[X2]
			SUB		BX,[X1]
			JNS		@@OK6_2
			NEG		BX
@@OK6_2:
			CMP		AX,BX
			JLE		@@LINE_2

			MOV		AX,[Y1]
			CMP		AX,[Y2]
			JLE		@@OK7
			XCHG	AX,[Y2]
			MOV		[Y1],AX
			MOV		AX,[X1]
			XCHG	AX,[X2]
			MOV		[X1],AX
@@OK7:
	DB $66;	DB $0F, $BF, $5E, OFFSET X1	{ MOVSX EAX,[WORD PTR Y1] }
	DB $66;	SHL		BX,Scaler
	DB $66;	MOV		[WORD PTR XX1],BX
	DB $66;	DB $0F, $BF, $46, OFFSET X2	{ MOVSX EAX,[WORD PTR Y2] }
	DB $66;	SHL		AX,Scaler
	DB $66;	MOV		[WORD PTR XX2],AX

	DB $66;	SUB		AX,BX
	DB $66;	CWD
	DB $66;	DB $0F, $BF, $5E, OFFSET Y2
	DB $66;	DB $0F, $BF, $4E, OFFSET Y1
	DB $66;	SUB		BX,CX
	DB $66;	IDIV	BX
	DB $66;	MOV		[WORD PTR DDX],AX

			MOV		AX,[X1]
			TEST	AX,AX
			JGE		@@OK8
			SUB		AX,AX
@@OK8:
			CMP		AX,319
			JLE		@@OK8_2
			MOV		AX,319
@@OK8_2:
			MOV		[LASTX],AX
			MOV		DI,AX
			MOV		AX,[Y1]
			TEST	AX,AX
			JGE		@@OK9
			SUB		AX,AX
@@OK9:
			CMP		AX,199
			JLE		@@OK9_2
			MOV		AX,199
@@OK9_2:
			MOV		BX,AX
			SHL		AX,6
			SHL		BX,8
			ADD		DI,AX
			ADD		DI,BX

			MOV		DX,[Y1]
			MOV		CL,[Color]
			MOV		ES,[VideoSeg]
	DB $66;	MOV		BX,[WORD PTR XX1]
	DB $66;	MOV		SI,[WORD PTR DDX]
@@LOOP2:
	DB $66;	MOV		AX,BX
	DB $66;	SAR		AX,Scaler
			JNC		@@NOTROUND
	DB $66;	INC		AX
@@NOTROUND:
			CMP		AX,0
			JL		@@NEXTPIXEL
			CMP		AX,319
			JG		@@NEXTPIXEL
			CMP		AX,[LASTX]
			JE		@@OK10
			JG		@@GORIGHT
			DEC		DI
			JMP		@@ADJUSTED
@@GORIGHT:
			INC		DI
@@ADJUSTED:
			MOV		[LASTX],AX
@@OK10:
			CMP		DX,0
			JL		@@NEXTPIXEL
			CMP		DX,199
			JG		@@EXIT

			XOR		[ES:DI],CL
@@NEXTPIXEL:
			CMP		DX,0
			JL		@@NEXTHORZ
			CMP		DX,199
			JG		@@EXIT
			ADD		DI,320
@@NEXTHORZ:
	DB $66;	ADD		BX,SI
			INC		DX
			CMP		DX,[Y2]
			JLE		@@LOOP2
			JMP		@@EXIT
@@LINE_2:
			MOV		AX,[X1]
			CMP		AX,[X2]
			JLE		@@OK7_2
			XCHG	AX,[X2]
			MOV		[X1],AX
			MOV		AX,[Y1]
			XCHG	AX,[Y2]
			MOV		[Y1],AX
@@OK7_2:
	DB $66;	DB $0F, $BF, $5E, OFFSET Y1	{ MOVSX EAX,[WORD PTR Y1] }
	DB $66;	SHL		BX,Scaler
	DB $66;	MOV		[WORD PTR YY1],BX
	DB $66;	DB $0F, $BF, $46, OFFSET Y2	{ MOVSX EAX,[WORD PTR Y2] }
	DB $66;	SHL		AX,Scaler
	DB $66;	MOV		[WORD PTR YY2],AX

	DB $66;	SUB		AX,BX
	DB $66;	CWD
	DB $66;	DB $0F, $BF, $5E, OFFSET X2
	DB $66;	DB $0F, $BF, $4E, OFFSET X1
	DB $66;	SUB		BX,CX
	DB $66;	IDIV	BX
	DB $66;	MOV		[WORD PTR DDY],AX

			MOV		AX,[X1]
			TEST	AX,AX
			JGE		@@OK8_3
			SUB		AX,AX
@@OK8_3:
			MOV		DI,AX
			MOV		AX,[Y1]
			TEST	AX,AX
			JGE		@@OK9_3
			SUB		AX,AX
@@OK9_3:
			CMP		AX,199
			JLE		@@OK9_4
			MOV		AX,199
@@OK9_4:
			MOV		[LASTY],AX
			MOV		BX,AX
			SHL		AX,6
			SHL		BX,8
			ADD		DI,AX
			ADD		DI,BX

			MOV		DX,[X1]
			MOV		CL,[Color]
			MOV		ES,[VideoSeg]
	DB $66;	MOV		BX,[WORD PTR YY1]
	DB $66;	MOV		SI,[WORD PTR DDY]
@@LOOP3:
	DB $66;	MOV		AX,BX
	DB $66;	SAR		AX,Scaler
			JNC		@@NOTROUND2
	DB $66;	INC		AX
@@NOTROUND2:
			CMP		AX,0
			JL		@@NEXTPIXEL2
			CMP		AX,199
			JG		@@NEXTPIXEL2
			CMP		AX,[LASTY]
			JE		@@OK10_2
			JG		@@GODOWN
			SUB		DI,320
			JMP		@@ADJUSTED2
@@GODOWN:
			ADD		DI,320
@@ADJUSTED2:
			MOV		[LASTY],AX
@@OK10_2:
			CMP		DX,0
			JL		@@NEXTPIXEL2
			CMP		DX,319
			JG		@@EXIT

			XOR		[ES:DI],CL
@@NEXTPIXEL2:
			CMP		DX,0
			JL		@@NEXTVERT
			CMP		DX,319
			JG		@@EXIT
			INC		DI
@@NEXTVERT:
	DB $66;	ADD		BX,SI
			INC		DX
			CMP		DX,[X2]
			JLE		@@LOOP3
@@EXIT:
End;

Procedure XLineGlenzXORClip(X1,Y1,X2,Y2,ClipX1,ClipY1,ClipX2,ClipY2 : Integer; Color : Byte; VideoSeg : Word); Assembler;
Var
	XX1,XX2	: LongInt;
	YY1,YY2	: LongInt;
	DDX,DDY	: LongInt;
	X,Y		: LongInt;
	LastX	: Integer;
	LastY	: Integer;
Asm
			MOV		DX,[Y1]
			CMP		DX,[Y2]
			JNE		@@NONHORIZ

			CMP		DX,[ClipY1]
			JL		@@EXIT
			CMP		DX,[ClipY2]
			JG		@@EXIT
			MOV		AX,[X1]
			MOV		BX,[X2]
			CMP		AX,BX
			JLE		@@OK1
			XCHG	AX,BX
@@OK1:
			CMP		AX,[ClipX2]
			JG		@@EXIT
			CMP		BX,[ClipX1]
			JL		@@EXIT
			CMP		AX,[ClipX1]
			JGE		@@OK2
			MOV		AX,[ClipX1]
@@OK2:
			MOV		CX,BX
			CMP		CX,[ClipX2]
			JLE		@@OK3
			MOV		CX,[ClipX2]
@@OK3:
			SUB		CX,AX
			INC		CX
			MOV		DI,DX
			SHL		DI,6
			SHL		DX,8
			ADD		DI,DX
			ADD		DI,AX
			MOV		ES,[VideoSeg]
			MOV		AL,[Color]
			MOV		AH,AL
			MOV		BX,AX
	DB $66;	SHL		AX,16
			MOV		AX,BX
			CLD
			SHR		CX,1
			DB $0F, $92, $C3			{ SETC BL }
			SHR		CX,1
			DB $0F, $92, $C7
@@STOSLOOP:
			JCXZ	@@SKIP1
	DB $66;	XOR		[ES:DI],AX
			ADD		DI,4
			DEC		CX
			JNZ		@@STOSLOOP
@@SKIP1:
			OR		BH,BH
			JZ		@@SKIP2
			XOR		[ES:DI],AX
			ADD		DI,2
@@SKIP2:
			OR		BL,BL
			JZ		@@SKIP3
			XOR		[ES:DI],AL
			INC		DI
@@SKIP3:
			JMP		@@EXIT
@@NONHORIZ:
			MOV		DX,[X1]
			CMP		DX,[X2]
			JNE		@@NONVERTIC
			MOV		DX,[X1]
			CMP		DX,[ClipX1]
			JL		@@EXIT
			CMP		DX,[ClipX2]
			JG		@@EXIT
			MOV		AX,[Y1]
			MOV		BX,[Y2]
			CMP		AX,BX
			JLE		@@OK4
			XCHG	AX,BX
@@OK4:
			CMP		AX,[ClipY2]
			JG		@@EXIT
			CMP		BX,[ClipY1]
			JL		@@EXIT
			CMP		AX,[ClipY1]
			JGE		@@OK5
			MOV		AX,[ClipY1]
@@OK5:
			MOV		CX,BX
			CMP		CX,[ClipY2]
			JLE		@@OK6
			MOV		CX,[ClipY2]
@@OK6:
			SUB		CX,AX
			INC		CX
			MOV		DI,AX
			SHL		DI,6
			SHL		AX,8
			ADD		DI,AX
			ADD		DI,DX
			MOV		ES,[VideoSeg]
			MOV		AL,[Color]
@@LOOP:
			XOR		[ES:DI],AL
			ADD		DI,320
			DEC		CX
			JNZ		@@LOOP
			JMP		@@EXIT
@@NONVERTIC:
			MOV		AX,[Y2]
			SUB		AX,[Y1]
			JNS		@@OK6_1
			NEG		AX
@@OK6_1:
			MOV		BX,[X2]
			SUB		BX,[X1]
			JNS		@@OK6_2
			NEG		BX
@@OK6_2:
			CMP		AX,BX
			JLE		@@LINE_2

			MOV		AX,[Y1]
			CMP		AX,[Y2]
			JLE		@@OK7
			XCHG	AX,[Y2]
			MOV		[Y1],AX
			MOV		AX,[X1]
			XCHG	AX,[X2]
			MOV		[X1],AX
@@OK7:
	DB $66;	DB $0F, $BF, $5E, OFFSET X1	{ MOVSX EAX,[WORD PTR Y1] }
	DB $66;	SHL		BX,Scaler
	DB $66;	MOV		[WORD PTR XX1],BX
	DB $66;	DB $0F, $BF, $46, OFFSET X2	{ MOVSX EAX,[WORD PTR Y2] }
	DB $66;	SHL		AX,Scaler
	DB $66;	MOV		[WORD PTR XX2],AX

	DB $66;	SUB		AX,BX
	DB $66;	CWD
	DB $66;	DB $0F, $BF, $5E, OFFSET Y2
	DB $66;	DB $0F, $BF, $4E, OFFSET Y1
	DB $66;	SUB		BX,CX
	DB $66;	IDIV	BX
	DB $66;	MOV		[WORD PTR DDX],AX

			MOV		AX,[X1]
			CMP		AX,[ClipX1]
			JGE		@@OK8
			MOV		AX,[ClipX1]
@@OK8:
			CMP		AX,[ClipX2]
			JLE		@@OK8_2
			MOV		AX,[ClipX2]
@@OK8_2:
			MOV		[LASTX],AX
			MOV		DI,AX
			MOV		AX,[Y1]
			CMP		AX,[ClipY1]
			JGE		@@OK9
			MOV		AX,[ClipY1]
@@OK9:
			CMP		AX,[ClipY2]
			JLE		@@OK9_2
			MOV		AX,[ClipY2]
@@OK9_2:
			MOV		BX,AX
			SHL		AX,6
			SHL		BX,8
			ADD		DI,AX
			ADD		DI,BX

			MOV		DX,[Y1]
			MOV		CL,[Color]
			MOV		ES,[VideoSeg]
	DB $66;	MOV		BX,[WORD PTR XX1]
	DB $66;	MOV		SI,[WORD PTR DDX]
@@LOOP2:
	DB $66;	MOV		AX,BX
	DB $66;	SAR		AX,Scaler
			JNC		@@NOTROUND
	DB $66;	INC		AX
@@NOTROUND:
			CMP		AX,[ClipX1]
			JL		@@NEXTPIXEL
			CMP		AX,[ClipX2]
			JG		@@NEXTPIXEL
			CMP		AX,[LASTX]
			JE		@@OK10
			JG		@@GORIGHT
			DEC		DI
			JMP		@@ADJUSTED
@@GORIGHT:
			INC		DI
@@ADJUSTED:
			MOV		[LASTX],AX
@@OK10:
			CMP		DX,[ClipY1]
			JL		@@NEXTPIXEL
			CMP		DX,[ClipY2]
			JG		@@EXIT

			XOR		[ES:DI],CL
@@NEXTPIXEL:
			CMP		DX,[ClipY1]
			JL		@@NEXTHORZ
			CMP		DX,[ClipY2]
			JG		@@EXIT
			ADD		DI,320
@@NEXTHORZ:
	DB $66;	ADD		BX,SI
			INC		DX
			CMP		DX,[Y2]
			JLE		@@LOOP2
			JMP		@@EXIT
@@LINE_2:
			MOV		AX,[X1]
			CMP		AX,[X2]
			JLE		@@OK7_2
			XCHG	AX,[X2]
			MOV		[X1],AX
			MOV		AX,[Y1]
			XCHG	AX,[Y2]
			MOV		[Y1],AX
@@OK7_2:
	DB $66;	DB $0F, $BF, $5E, OFFSET Y1	{ MOVSX EAX,[WORD PTR Y1] }
	DB $66;	SHL		BX,Scaler
	DB $66;	MOV		[WORD PTR YY1],BX
	DB $66;	DB $0F, $BF, $46, OFFSET Y2	{ MOVSX EAX,[WORD PTR Y2] }
	DB $66;	SHL		AX,Scaler
	DB $66;	MOV		[WORD PTR YY2],AX

	DB $66;	SUB		AX,BX
	DB $66;	CWD
	DB $66;	DB $0F, $BF, $5E, OFFSET X2
	DB $66;	DB $0F, $BF, $4E, OFFSET X1
	DB $66;	SUB		BX,CX
	DB $66;	IDIV	BX
	DB $66;	MOV		[WORD PTR DDY],AX

			MOV		AX,[X1]
			CMP		AX,[ClipX1]
			JGE		@@OK8_3
			MOV		AX,[ClipX1]
@@OK8_3:
			MOV		DI,AX
			MOV		AX,[Y1]
			CMP		AX,[ClipY1]
			JGE		@@OK9_3
			MOV		AX,[ClipY1]
@@OK9_3:
			CMP		AX,[ClipY2]
			JLE		@@OK9_4
			MOV		AX,[ClipY2]
@@OK9_4:
			MOV		[LASTY],AX
			MOV		BX,AX
			SHL		AX,6
			SHL		BX,8
			ADD		DI,AX
			ADD		DI,BX

			MOV		DX,[X1]
			MOV		CL,[Color]
			MOV		ES,[VideoSeg]
	DB $66;	MOV		BX,[WORD PTR YY1]
	DB $66;	MOV		SI,[WORD PTR DDY]
@@LOOP3:
	DB $66;	MOV		AX,BX
	DB $66;	SAR		AX,Scaler
			JNC		@@NOTROUND2
	DB $66;	INC		AX
@@NOTROUND2:
			CMP		AX,[ClipY1]
			JL		@@NEXTPIXEL2
			CMP		AX,[ClipY2]
			JG		@@NEXTPIXEL2
			CMP		AX,[LASTY]
			JE		@@OK10_2
			JG		@@GODOWN
			SUB		DI,320
			JMP		@@ADJUSTED2
@@GODOWN:
			ADD		DI,320
@@ADJUSTED2:
			MOV		[LASTY],AX
@@OK10_2:
			CMP		DX,[ClipX1]
			JL		@@NEXTPIXEL2
			CMP		DX,[ClipX2]
			JG		@@EXIT

			XOR		[ES:DI],CL
@@NEXTPIXEL2:
			CMP		DX,[ClipX1]
			JL		@@NEXTVERT
			CMP		DX,[ClipX2]
			JG		@@EXIT
			INC		DI
@@NEXTVERT:
	DB $66;	ADD		BX,SI
			INC		DX
			CMP		DX,[X2]
			JLE		@@LOOP3
@@EXIT:
End;

Procedure XLineGlenzSUB(X1,Y1,X2,Y2 : Integer; Color : Byte; VideoSeg : Word); Assembler;
Var
	XX1,XX2	: LongInt;
	YY1,YY2	: LongInt;
	DDX,DDY	: LongInt;
	X,Y		: LongInt;
	LastX	: Integer;
	LastY	: Integer;
Asm
			MOV		DX,[Y1]
			CMP		DX,[Y2]
			JNE		@@NONHORIZ

			TEST	DX,DX
			JL		@@EXIT
			CMP		DX,199
			JG		@@EXIT
			MOV		AX,[X1]
			MOV		BX,[X2]
			CMP		AX,BX
			JLE		@@OK1
			XCHG	AX,BX
@@OK1:
			CMP		AX,319
			JG		@@EXIT
			TEST	BX,BX
			JL		@@EXIT
			TEST	AX,AX
			JGE		@@OK2
			SUB		AX,AX
@@OK2:
			MOV		CX,BX
			CMP		CX,319
			JLE		@@OK3
			MOV		CX,319
@@OK3:
			SUB		CX,AX
			INC		CX
			MOV		DI,DX
			SHL		DI,6
			SHL		DX,8
			ADD		DI,DX
			ADD		DI,AX
			MOV		ES,[VideoSeg]
			MOV		AL,[Color]
			MOV		AH,AL
			MOV		BX,AX
	DB $66;	SHL		AX,16
			MOV		AX,BX
			CLD
			SHR		CX,1
			DB $0F, $92, $C3			{ SETC BL }
			SHR		CX,1
			DB $0F, $92, $C7
@@STOSLOOP:
			JCXZ	@@SKIP1
	DB $66;	SUB		[ES:DI],AX
			ADD		DI,4
			DEC		CX
			JNZ		@@STOSLOOP
@@SKIP1:
			OR		BH,BH
			JZ		@@SKIP2
			SUB		[ES:DI],AX
			ADD		DI,2
@@SKIP2:
			OR		BL,BL
			JZ		@@SKIP3
			SUB		[ES:DI],AL
			INC		DI
@@SKIP3:
			JMP		@@EXIT
@@NONHORIZ:
			MOV		DX,[X1]
			CMP		DX,[X2]
			JNE		@@NONVERTIC
			MOV		DX,[X1]
			TEST	DX,DX
			JL		@@EXIT
			CMP		DX,319
			JG		@@EXIT
			MOV		AX,[Y1]
			MOV		BX,[Y2]
			CMP		AX,BX
			JLE		@@OK4
			XCHG	AX,BX
@@OK4:
			CMP		AX,199
			JG		@@EXIT
			TEST	BX,BX
			JL		@@EXIT
			TEST	AX,AX
			JGE		@@OK5
			SUB		AX,AX
@@OK5:
			MOV		CX,BX
			CMP		CX,199
			JLE		@@OK6
			MOV		CX,199
@@OK6:
			SUB		CX,AX
			INC		CX
			MOV		DI,AX
			SHL		DI,6
			SHL		AX,8
			ADD		DI,AX
			ADD		DI,DX
			MOV		ES,[VideoSeg]
			MOV		AL,[Color]
@@LOOP:
			SUB		[ES:DI],AL
			ADD		DI,320
			DEC		CX
			JNZ		@@LOOP
			JMP		@@EXIT
@@NONVERTIC:
			MOV		AX,[Y2]
			SUB		AX,[Y1]
			JNS		@@OK6_1
			NEG		AX
@@OK6_1:
			MOV		BX,[X2]
			SUB		BX,[X1]
			JNS		@@OK6_2
			NEG		BX
@@OK6_2:
			CMP		AX,BX
			JLE		@@LINE_2

			MOV		AX,[Y1]
			CMP		AX,[Y2]
			JLE		@@OK7
			XCHG	AX,[Y2]
			MOV		[Y1],AX
			MOV		AX,[X1]
			XCHG	AX,[X2]
			MOV		[X1],AX
@@OK7:
	DB $66;	DB $0F, $BF, $5E, OFFSET X1	{ MOVSX EAX,[WORD PTR Y1] }
	DB $66;	SHL		BX,Scaler
	DB $66;	MOV		[WORD PTR XX1],BX
	DB $66;	DB $0F, $BF, $46, OFFSET X2	{ MOVSX EAX,[WORD PTR Y2] }
	DB $66;	SHL		AX,Scaler
	DB $66;	MOV		[WORD PTR XX2],AX

	DB $66;	SUB		AX,BX
	DB $66;	CWD
	DB $66;	DB $0F, $BF, $5E, OFFSET Y2
	DB $66;	DB $0F, $BF, $4E, OFFSET Y1
	DB $66;	SUB		BX,CX
	DB $66;	IDIV	BX
	DB $66;	MOV		[WORD PTR DDX],AX

			MOV		AX,[X1]
			TEST	AX,AX
			JGE		@@OK8
			SUB		AX,AX
@@OK8:
			CMP		AX,319
			JLE		@@OK8_2
			MOV		AX,319
@@OK8_2:
			MOV		[LASTX],AX
			MOV		DI,AX
			MOV		AX,[Y1]
			TEST	AX,AX
			JGE		@@OK9
			SUB		AX,AX
@@OK9:
			CMP		AX,199
			JLE		@@OK9_2
			MOV		AX,199
@@OK9_2:
			MOV		BX,AX
			SHL		AX,6
			SHL		BX,8
			ADD		DI,AX
			ADD		DI,BX

			MOV		DX,[Y1]
			MOV		CL,[Color]
			MOV		ES,[VideoSeg]
	DB $66;	MOV		BX,[WORD PTR XX1]
	DB $66;	MOV		SI,[WORD PTR DDX]
@@LOOP2:
	DB $66;	MOV		AX,BX
	DB $66;	SAR		AX,Scaler
			JNC		@@NOTROUND
	DB $66;	INC		AX
@@NOTROUND:
			CMP		AX,0
			JL		@@NEXTPIXEL
			CMP		AX,319
			JG		@@NEXTPIXEL
			CMP		AX,[LASTX]
			JE		@@OK10
			JG		@@GORIGHT
			DEC		DI
			JMP		@@ADJUSTED
@@GORIGHT:
			INC		DI
@@ADJUSTED:
			MOV		[LASTX],AX
@@OK10:
			CMP		DX,0
			JL		@@NEXTPIXEL
			CMP		DX,199
			JG		@@EXIT

			SUB		[ES:DI],CL
@@NEXTPIXEL:
			CMP		DX,0
			JL		@@NEXTHORZ
			CMP		DX,199
			JG		@@EXIT
			ADD		DI,320
@@NEXTHORZ:
	DB $66;	ADD		BX,SI
			INC		DX
			CMP		DX,[Y2]
			JLE		@@LOOP2
			JMP		@@EXIT
@@LINE_2:
			MOV		AX,[X1]
			CMP		AX,[X2]
			JLE		@@OK7_2
			XCHG	AX,[X2]
			MOV		[X1],AX
			MOV		AX,[Y1]
			XCHG	AX,[Y2]
			MOV		[Y1],AX
@@OK7_2:
	DB $66;	DB $0F, $BF, $5E, OFFSET Y1	{ MOVSX EAX,[WORD PTR Y1] }
	DB $66;	SHL		BX,Scaler
	DB $66;	MOV		[WORD PTR YY1],BX
	DB $66;	DB $0F, $BF, $46, OFFSET Y2	{ MOVSX EAX,[WORD PTR Y2] }
	DB $66;	SHL		AX,Scaler
	DB $66;	MOV		[WORD PTR YY2],AX

	DB $66;	SUB		AX,BX
	DB $66;	CWD
	DB $66;	DB $0F, $BF, $5E, OFFSET X2
	DB $66;	DB $0F, $BF, $4E, OFFSET X1
	DB $66;	SUB		BX,CX
	DB $66;	IDIV	BX
	DB $66;	MOV		[WORD PTR DDY],AX

			MOV		AX,[X1]
			TEST	AX,AX
			JGE		@@OK8_3
			SUB		AX,AX
@@OK8_3:
			MOV		DI,AX
			MOV		AX,[Y1]
			TEST	AX,AX
			JGE		@@OK9_3
			SUB		AX,AX
@@OK9_3:
			CMP		AX,199
			JLE		@@OK9_4
			MOV		AX,199
@@OK9_4:
			MOV		[LASTY],AX
			MOV		BX,AX
			SHL		AX,6
			SHL		BX,8
			ADD		DI,AX
			ADD		DI,BX

			MOV		DX,[X1]
			MOV		CL,[Color]
			MOV		ES,[VideoSeg]
	DB $66;	MOV		BX,[WORD PTR YY1]
	DB $66;	MOV		SI,[WORD PTR DDY]
@@LOOP3:
	DB $66;	MOV		AX,BX
	DB $66;	SAR		AX,Scaler
			JNC		@@NOTROUND2
	DB $66;	INC		AX
@@NOTROUND2:
			CMP		AX,0
			JL		@@NEXTPIXEL2
			CMP		AX,199
			JG		@@NEXTPIXEL2
			CMP		AX,[LASTY]
			JE		@@OK10_2
			JG		@@GODOWN
			SUB		DI,320
			JMP		@@ADJUSTED2
@@GODOWN:
			ADD		DI,320
@@ADJUSTED2:
			MOV		[LASTY],AX
@@OK10_2:
			CMP		DX,0
			JL		@@NEXTPIXEL2
			CMP		DX,319
			JG		@@EXIT

			SUB		[ES:DI],CL
@@NEXTPIXEL2:
			CMP		DX,0
			JL		@@NEXTVERT
			CMP		DX,319
			JG		@@EXIT
			INC		DI
@@NEXTVERT:
	DB $66;	ADD		BX,SI
			INC		DX
			CMP		DX,[X2]
			JLE		@@LOOP3
@@EXIT:
End;

Procedure XLineGlenzSUBClip(X1,Y1,X2,Y2,ClipX1,ClipY1,ClipX2,ClipY2 : Integer; Color : Byte; VideoSeg : Word); Assembler;
Var
	XX1,XX2	: LongInt;
	YY1,YY2	: LongInt;
	DDX,DDY	: LongInt;
	X,Y		: LongInt;
	LastX	: Integer;
	LastY	: Integer;
Asm
			MOV		DX,[Y1]
			CMP		DX,[Y2]
			JNE		@@NONHORIZ

			CMP		DX,[ClipY1]
			JL		@@EXIT
			CMP		DX,[ClipY2]
			JG		@@EXIT
			MOV		AX,[X1]
			MOV		BX,[X2]
			CMP		AX,BX
			JLE		@@OK1
			XCHG	AX,BX
@@OK1:
			CMP		AX,[ClipX2]
			JG		@@EXIT
			CMP		BX,[ClipX1]
			JL		@@EXIT
			CMP		AX,[ClipX1]
			JGE		@@OK2
			MOV		AX,[ClipX1]
@@OK2:
			MOV		CX,BX
			CMP		CX,[ClipX2]
			JLE		@@OK3
			MOV		CX,[ClipX2]
@@OK3:
			SUB		CX,AX
			INC		CX
			MOV		DI,DX
			SHL		DI,6
			SHL		DX,8
			ADD		DI,DX
			ADD		DI,AX
			MOV		ES,[VideoSeg]
			MOV		AL,[Color]
			MOV		AH,AL
			MOV		BX,AX
	DB $66;	SHL		AX,16
			MOV		AX,BX
			CLD
			SHR		CX,1
			DB $0F, $92, $C3			{ SETC BL }
			SHR		CX,1
			DB $0F, $92, $C7
@@STOSLOOP:
			JCXZ	@@SKIP1
	DB $66;	SUB		[ES:DI],AX
			ADD		DI,4
			DEC		CX
			JNZ		@@STOSLOOP
@@SKIP1:
			OR		BH,BH
			JZ		@@SKIP2
			SUB		[ES:DI],AX
			ADD		DI,2
@@SKIP2:
			OR		BL,BL
			JZ		@@SKIP3
			SUB		[ES:DI],AL
			INC		DI
@@SKIP3:
			JMP		@@EXIT
@@NONHORIZ:
			MOV		DX,[X1]
			CMP		DX,[X2]
			JNE		@@NONVERTIC
			MOV		DX,[X1]
			CMP		DX,[ClipX1]
			JL		@@EXIT
			CMP		DX,[ClipX2]
			JG		@@EXIT
			MOV		AX,[Y1]
			MOV		BX,[Y2]
			CMP		AX,BX
			JLE		@@OK4
			XCHG	AX,BX
@@OK4:
			CMP		AX,[ClipY2]
			JG		@@EXIT
			CMP		BX,[ClipY1]
			JL		@@EXIT
			CMP		AX,[ClipY1]
			JGE		@@OK5
			MOV		AX,[ClipY1]
@@OK5:
			MOV		CX,BX
			CMP		CX,[ClipY2]
			JLE		@@OK6
			MOV		CX,[ClipY2]
@@OK6:
			SUB		CX,AX
			INC		CX
			MOV		DI,AX
			SHL		DI,6
			SHL		AX,8
			ADD		DI,AX
			ADD		DI,DX
			MOV		ES,[VideoSeg]
			MOV		AL,[Color]
@@LOOP:
			SUB		[ES:DI],AL
			ADD		DI,320
			DEC		CX
			JNZ		@@LOOP
			JMP		@@EXIT
@@NONVERTIC:
			MOV		AX,[Y2]
			SUB		AX,[Y1]
			JNS		@@OK6_1
			NEG		AX
@@OK6_1:
			MOV		BX,[X2]
			SUB		BX,[X1]
			JNS		@@OK6_2
			NEG		BX
@@OK6_2:
			CMP		AX,BX
			JLE		@@LINE_2

			MOV		AX,[Y1]
			CMP		AX,[Y2]
			JLE		@@OK7
			XCHG	AX,[Y2]
			MOV		[Y1],AX
			MOV		AX,[X1]
			XCHG	AX,[X2]
			MOV		[X1],AX
@@OK7:
	DB $66;	DB $0F, $BF, $5E, OFFSET X1	{ MOVSX EAX,[WORD PTR Y1] }
	DB $66;	SHL		BX,Scaler
	DB $66;	MOV		[WORD PTR XX1],BX
	DB $66;	DB $0F, $BF, $46, OFFSET X2	{ MOVSX EAX,[WORD PTR Y2] }
	DB $66;	SHL		AX,Scaler
	DB $66;	MOV		[WORD PTR XX2],AX

	DB $66;	SUB		AX,BX
	DB $66;	CWD
	DB $66;	DB $0F, $BF, $5E, OFFSET Y2
	DB $66;	DB $0F, $BF, $4E, OFFSET Y1
	DB $66;	SUB		BX,CX
	DB $66;	IDIV	BX
	DB $66;	MOV		[WORD PTR DDX],AX

			MOV		AX,[X1]
			CMP		AX,[ClipX1]
			JGE		@@OK8
			MOV		AX,[ClipX1]
@@OK8:
			CMP		AX,[ClipX2]
			JLE		@@OK8_2
			MOV		AX,[ClipX2]
@@OK8_2:
			MOV		[LASTX],AX
			MOV		DI,AX
			MOV		AX,[Y1]
			CMP		AX,[ClipY1]
			JGE		@@OK9
			MOV		AX,[ClipY1]
@@OK9:
			CMP		AX,[ClipY2]
			JLE		@@OK9_2
			MOV		AX,[ClipY2]
@@OK9_2:
			MOV		BX,AX
			SHL		AX,6
			SHL		BX,8
			ADD		DI,AX
			ADD		DI,BX

			MOV		DX,[Y1]
			MOV		CL,[Color]
			MOV		ES,[VideoSeg]
	DB $66;	MOV		BX,[WORD PTR XX1]
	DB $66;	MOV		SI,[WORD PTR DDX]
@@LOOP2:
	DB $66;	MOV		AX,BX
	DB $66;	SAR		AX,Scaler
			JNC		@@NOTROUND
	DB $66;	INC		AX
@@NOTROUND:
			CMP		AX,[ClipX1]
			JL		@@NEXTPIXEL
			CMP		AX,[ClipX2]
			JG		@@NEXTPIXEL
			CMP		AX,[LASTX]
			JE		@@OK10
			JG		@@GORIGHT
			DEC		DI
			JMP		@@ADJUSTED
@@GORIGHT:
			INC		DI
@@ADJUSTED:
			MOV		[LASTX],AX
@@OK10:
			CMP		DX,[ClipY1]
			JL		@@NEXTPIXEL
			CMP		DX,[ClipY2]
			JG		@@EXIT

			SUB		[ES:DI],CL
@@NEXTPIXEL:
			CMP		DX,[ClipY1]
			JL		@@NEXTHORZ
			CMP		DX,[ClipY2]
			JG		@@EXIT
			ADD		DI,320
@@NEXTHORZ:
	DB $66;	ADD		BX,SI
			INC		DX
			CMP		DX,[Y2]
			JLE		@@LOOP2
			JMP		@@EXIT
@@LINE_2:
			MOV		AX,[X1]
			CMP		AX,[X2]
			JLE		@@OK7_2
			XCHG	AX,[X2]
			MOV		[X1],AX
			MOV		AX,[Y1]
			XCHG	AX,[Y2]
			MOV		[Y1],AX
@@OK7_2:
	DB $66;	DB $0F, $BF, $5E, OFFSET Y1	{ MOVSX EAX,[WORD PTR Y1] }
	DB $66;	SHL		BX,Scaler
	DB $66;	MOV		[WORD PTR YY1],BX
	DB $66;	DB $0F, $BF, $46, OFFSET Y2	{ MOVSX EAX,[WORD PTR Y2] }
	DB $66;	SHL		AX,Scaler
	DB $66;	MOV		[WORD PTR YY2],AX

	DB $66;	SUB		AX,BX
	DB $66;	CWD
	DB $66;	DB $0F, $BF, $5E, OFFSET X2
	DB $66;	DB $0F, $BF, $4E, OFFSET X1
	DB $66;	SUB		BX,CX
	DB $66;	IDIV	BX
	DB $66;	MOV		[WORD PTR DDY],AX

			MOV		AX,[X1]
			CMP		AX,[ClipX1]
			JGE		@@OK8_3
			MOV		AX,[ClipX1]
@@OK8_3:
			MOV		DI,AX
			MOV		AX,[Y1]
			CMP		AX,[ClipY1]
			JGE		@@OK9_3
			MOV		AX,[ClipY1]
@@OK9_3:
			CMP		AX,[ClipY2]
			JLE		@@OK9_4
			MOV		AX,[ClipY2]
@@OK9_4:
			MOV		[LASTY],AX
			MOV		BX,AX
			SHL		AX,6
			SHL		BX,8
			ADD		DI,AX
			ADD		DI,BX

			MOV		DX,[X1]
			MOV		CL,[Color]
			MOV		ES,[VideoSeg]
	DB $66;	MOV		BX,[WORD PTR YY1]
	DB $66;	MOV		SI,[WORD PTR DDY]
@@LOOP3:
	DB $66;	MOV		AX,BX
	DB $66;	SAR		AX,Scaler
			JNC		@@NOTROUND2
	DB $66;	INC		AX
@@NOTROUND2:
			CMP		AX,[ClipY1]
			JL		@@NEXTPIXEL2
			CMP		AX,[ClipY2]
			JG		@@NEXTPIXEL2
			CMP		AX,[LASTY]
			JE		@@OK10_2
			JG		@@GODOWN
			SUB		DI,320
			JMP		@@ADJUSTED2
@@GODOWN:
			ADD		DI,320
@@ADJUSTED2:
			MOV		[LASTY],AX
@@OK10_2:
			CMP		DX,[ClipX1]
			JL		@@NEXTPIXEL2
			CMP		DX,[ClipX2]
			JG		@@EXIT

			SUB		[ES:DI],CL
@@NEXTPIXEL2:
			CMP		DX,[ClipX1]
			JL		@@NEXTVERT
			CMP		DX,[ClipX2]
			JG		@@EXIT
			INC		DI
@@NEXTVERT:
	DB $66;	ADD		BX,SI
			INC		DX
			CMP		DX,[X2]
			JLE		@@LOOP3
@@EXIT:
End;

Procedure XTetraLine(X1,Y1,X2,Y2,X3,Y3 : Integer; Color : Byte; VideoSeg : Word); Assembler;
Asm
	PUSH	[X1]
	PUSH	[Y1]
	PUSH	[X2]
	PUSH	[Y2]
	MOV		AL,[Color]
	PUSH	AX
	PUSH	[VideoSeg]
	CALL	XLine
	PUSH	[X2]
	PUSH	[Y2]
	PUSH	[X3]
	PUSH	[Y3]
	MOV		AL,[Color]
	PUSH	AX
	PUSH	[VideoSeg]
	CALL	XLine
	PUSH	[X3]
	PUSH	[Y3]
	PUSH	[X1]
	PUSH	[Y1]
	MOV		AL,[Color]
	PUSH	AX
	PUSH	[VideoSeg]
	CALL	XLine
End;

Procedure XQuadraLine(X1,Y1,X2,Y2,X3,Y3,X4,Y4 : Integer; Color : Byte; VideoSeg : Word); Assembler;
Asm
	PUSH	[X1]
	PUSH	[Y1]
	PUSH	[X2]
	PUSH	[Y2]
	MOV		AL,[Color]
	PUSH	AX
	PUSH	[VideoSeg]
	CALL	XLine
	PUSH	[X2]
	PUSH	[Y2]
	PUSH	[X3]
	PUSH	[Y3]
	MOV		AL,[Color]
	PUSH	AX
	PUSH	[VideoSeg]
	CALL	XLine
	PUSH	[X3]
	PUSH	[Y3]
	PUSH	[X4]
	PUSH	[Y4]
	MOV		AL,[Color]
	PUSH	AX
	PUSH	[VideoSeg]
	CALL	XLine
	PUSH	[X4]
	PUSH	[Y4]
	PUSH	[X1]
	PUSH	[Y1]
	MOV		AL,[Color]
	PUSH	AX
	PUSH	[VideoSeg]
	CALL	XLine
End;

Procedure XTetraLineClip(X1,Y1,X2,Y2,X3,Y3,ClipX1,ClipY1,ClipX2,ClipY2 : Integer; Color : Byte; VideoSeg : Word); Assembler;
Asm
	PUSH	[X1]
	PUSH	[Y1]
	PUSH	[X2]
	PUSH	[Y2]
	PUSH	[ClipX1]
	PUSH	[ClipY1]
	PUSH	[ClipX2]
	PUSH	[ClipY2]
	MOV		AL,[Color]
	PUSH	AX
	PUSH	[VideoSeg]
	CALL	XLineClip
	PUSH	[X2]
	PUSH	[Y2]
	PUSH	[X3]
	PUSH	[Y3]
	PUSH	[ClipX1]
	PUSH	[ClipY1]
	PUSH	[ClipX2]
	PUSH	[ClipY2]
	MOV		AL,[Color]
	PUSH	AX
	PUSH	[VideoSeg]
	CALL	XLineClip
	PUSH	[X3]
	PUSH	[Y3]
	PUSH	[X1]
	PUSH	[Y1]
	PUSH	[ClipX1]
	PUSH	[ClipY1]
	PUSH	[ClipX2]
	PUSH	[ClipY2]
	MOV		AL,[Color]
	PUSH	AX
	PUSH	[VideoSeg]
	CALL	XLineClip
End;

Procedure XQuadraLineClip(X1,Y1,X2,Y2,X3,Y3,X4,Y4,ClipX1,ClipY1,ClipX2,ClipY2 : Integer;
	Color : Byte; VideoSeg : Word); Assembler;
Asm
	PUSH	[X1]
	PUSH	[Y1]
	PUSH	[X2]
	PUSH	[Y2]
	PUSH	[ClipX1]
	PUSH	[ClipY1]
	PUSH	[ClipX2]
	PUSH	[ClipY2]
	MOV		AL,[Color]
	PUSH	AX
	PUSH	[VideoSeg]
	CALL	XLineClip
	PUSH	[X2]
	PUSH	[Y2]
	PUSH	[X3]
	PUSH	[Y3]
	PUSH	[ClipX1]
	PUSH	[ClipY1]
	PUSH	[ClipX2]
	PUSH	[ClipY2]
	MOV		AL,[Color]
	PUSH	AX
	PUSH	[VideoSeg]
	CALL	XLineClip
	PUSH	[X3]
	PUSH	[Y3]
	PUSH	[X4]
	PUSH	[Y4]
	PUSH	[ClipX1]
	PUSH	[ClipY1]
	PUSH	[ClipX2]
	PUSH	[ClipY2]
	MOV		AL,[Color]
	PUSH	AX
	PUSH	[VideoSeg]
	CALL	XLineClip
	PUSH	[X4]
	PUSH	[Y4]
	PUSH	[X1]
	PUSH	[Y1]
	PUSH	[ClipX1]
	PUSH	[ClipY1]
	PUSH	[ClipX2]
	PUSH	[ClipY2]
	MOV		AL,[Color]
	PUSH	AX
	PUSH	[VideoSeg]
	CALL	XLineClip
End;

Procedure XBox(X1,Y1,X2,Y2 : Integer; Color : Byte; VideoSeg : Word); Assembler;
Asm
	PUSH	[X1]
	PUSH	[Y1]
	PUSH	[X2]
	PUSH	[Y1]
	MOV		AL,[Color]
	PUSH	AX
	PUSH	[VideoSeg]
	CALL	XLine
	PUSH	[X2]
	PUSH	[Y1]
	PUSH	[X2]
	PUSH	[Y2]
	MOV		AL,[Color]
	PUSH	AX
	PUSH	[VideoSeg]
	CALL	XLine
	PUSH	[X2]
	PUSH	[Y2]
	PUSH	[X1]
	PUSH	[Y2]
	MOV		AL,[Color]
	PUSH	AX
	PUSH	[VideoSeg]
	CALL	XLine
	PUSH	[X1]
	PUSH	[Y2]
	PUSH	[X1]
	PUSH	[Y1]
	MOV		AL,[Color]
	PUSH	AX
	PUSH	[VideoSeg]
	CALL	XLine
End;

Procedure XBoxClip(X1,Y1,X2,Y2,ClipX1,ClipY1,ClipX2,ClipY2 : Integer; Color : Byte; VideoSeg : Word); Assembler;
Asm
	PUSH	[X1]
	PUSH	[Y1]
	PUSH	[X2]
	PUSH	[Y1]
	PUSH	[ClipX1]
	PUSH	[ClipY1]
	PUSH	[ClipX2]
	PUSH	[ClipY2]
	MOV		AL,[Color]
	PUSH	AX
	PUSH	[VideoSeg]
	CALL	XLineClip
	PUSH	[X2]
	PUSH	[Y1]
	PUSH	[X2]
	PUSH	[Y2]
	PUSH	[ClipX1]
	PUSH	[ClipY1]
	PUSH	[ClipX2]
	PUSH	[ClipY2]
	MOV		AL,[Color]
	PUSH	AX
	PUSH	[VideoSeg]
	CALL	XLineClip
	PUSH	[X2]
	PUSH	[Y2]
	PUSH	[X1]
	PUSH	[Y2]
	PUSH	[ClipX1]
	PUSH	[ClipY1]
	PUSH	[ClipX2]
	PUSH	[ClipY2]
	MOV		AL,[Color]
	PUSH	AX
	PUSH	[VideoSeg]
	CALL	XLineClip
	PUSH	[X1]
	PUSH	[Y2]
	PUSH	[X1]
	PUSH	[Y1]
	PUSH	[ClipX1]
	PUSH	[ClipY1]
	PUSH	[ClipX2]
	PUSH	[ClipY2]
	MOV		AL,[Color]
	PUSH	AX
	PUSH	[VideoSeg]
	CALL	XLineClip
End;

Procedure XBoxGlenzXOR(X1,Y1,X2,Y2 : Integer; Color : Byte; VideoSeg : Word); Assembler;
Asm
	MOV		AX,[Y1]
	CMP		AX,[Y2]
	JE		@@HORIZ
	JLE		@@OK1
	XCHG	AX,[Y2]
	MOV		[Y1],AX
@@OK1:
	MOV		AX,[X1]
	CMP		AX,[X2]
	JE		@@VERTIC
	JLE		@@OK2
	XCHG	AX,[X2]
	MOV		[X1],AX
@@OK2:
	MOV		AX,[X1]
	INC		AX
	PUSH	AX
	PUSH	[Y1]
	PUSH	[X2]
	PUSH	[Y1]
	MOV		AL,[Color]
	PUSH	AX
	PUSH	[VideoSeg]
	CALL	XLineGlenzXOR
	PUSH	[X2]
	MOV		AX,[Y1]
	INC		AX
	PUSH	AX
	PUSH	[X2]
	PUSH	[Y2]
	MOV		AL,[Color]
	PUSH	AX
	PUSH	[VideoSeg]
	CALL	XLineGlenzXOR
	MOV		AX,[X2]
	DEC		AX
	PUSH	AX
	PUSH	[Y2]
	PUSH	[X1]
	PUSH	[Y2]
	MOV		AL,[Color]
	PUSH	AX
	PUSH	[VideoSeg]
	CALL	XLineGlenzXOR
	PUSH	[X1]
	MOV		AX,[Y2]
	DEC		AX
	PUSH	AX
	PUSH	[X1]
	PUSH	[Y1]
	MOV		AL,[Color]
	PUSH	AX
	PUSH	[VideoSeg]
	CALL	XLineGlenzXOR
	JMP		@@EXIT
@@HORIZ:
	PUSH	[X1]
	PUSH	[Y1]
	PUSH	[X2]
	PUSH	[Y1]
	MOV		AL,[Color]
	PUSH	AX
	PUSH	[VideoSeg]
	CALL	XLineGlenzXOR
	JMP		@@EXIT
@@VERTIC:
	PUSH	[X1]
	PUSH	[Y1]
	PUSH	[X1]
	PUSH	[Y2]
	MOV		AL,[Color]
	PUSH	AX
	PUSH	[VideoSeg]
	CALL	XLineGlenzXOR
@@EXIT:
End;

Procedure XBoxGlenzXORClip(X1,Y1,X2,Y2,ClipX1,ClipY1,ClipX2,ClipY2 : Integer; Color : Byte; VideoSeg : Word); Assembler;
Asm
	MOV		AX,[Y1]
	CMP		AX,[Y2]
	JE		@@HORIZ
	JL		@@OK1
	XCHG	AX,[Y2]
	MOV		[Y1],AX
@@OK1:
	MOV		AX,[X1]
	CMP		AX,[X2]
	JE		@@VERTIC
	JL		@@OK2
	XCHG	AX,[X2]
	MOV		[X1],AX
@@OK2:
	MOV		AX,[X1]
	INC		AX
	PUSH	AX
	PUSH	[Y1]
	PUSH	[X2]
	PUSH	[Y1]
	PUSH	[ClipX1]
	PUSH	[ClipY1]
	PUSH	[ClipX2]
	PUSH	[ClipY2]
	MOV		AL,[Color]
	PUSH	AX
	PUSH	[VideoSeg]
	CALL	XLineGlenzXORClip
	PUSH	[X2]
	MOV		AX,[Y1]
	INC		AX
	PUSH	AX
	PUSH	[X2]
	PUSH	[Y2]
	PUSH	[ClipX1]
	PUSH	[ClipY1]
	PUSH	[ClipX2]
	PUSH	[ClipY2]
	MOV		AL,[Color]
	PUSH	AX
	PUSH	[VideoSeg]
	CALL	XLineGlenzXORClip
	MOV		AX,[X2]
	DEC		AX
	PUSH	AX
	PUSH	[Y2]
	PUSH	[X1]
	PUSH	[Y2]
	PUSH	[ClipX1]
	PUSH	[ClipY1]
	PUSH	[ClipX2]
	PUSH	[ClipY2]
	MOV		AL,[Color]
	PUSH	AX
	PUSH	[VideoSeg]
	CALL	XLineGlenzXORClip
	PUSH	[X1]
	MOV		AX,[Y2]
	DEC		AX
	PUSH	AX
	PUSH	[X1]
	PUSH	[Y1]
	PUSH	[ClipX1]
	PUSH	[ClipY1]
	PUSH	[ClipX2]
	PUSH	[ClipY2]
	MOV		AL,[Color]
	PUSH	AX
	PUSH	[VideoSeg]
	CALL	XLineGlenzXORClip
	JMP		@@EXIT
@@HORIZ:
	PUSH	[X1]
	PUSH	[Y1]
	PUSH	[X2]
	PUSH	[Y1]
	PUSH	[ClipX1]
	PUSH	[ClipY1]
	PUSH	[ClipX2]
	PUSH	[ClipY2]
	MOV		AL,[Color]
	PUSH	AX
	PUSH	[VideoSeg]
	CALL	XLineGlenzXORClip
	JMP		@@EXIT
@@VERTIC:
	PUSH	[X1]
	PUSH	[Y1]
	PUSH	[X1]
	PUSH	[Y2]
	PUSH	[ClipX1]
	PUSH	[ClipY1]
	PUSH	[ClipX2]
	PUSH	[ClipY2]
	MOV		AL,[Color]
	PUSH	AX
	PUSH	[VideoSeg]
	CALL	XLineGlenzXORClip
@@EXIT:
End;

Procedure XRectangle(X1,Y1,X2,Y2 : Integer; Color : Byte; VideoSeg : Word); Assembler;
Asm
			MOV		AX,[X1]
			MOV		BX,[X2]
			MOV		SI,[Y1]
			MOV		DI,[Y2]
			CMP		AX,BX
			JLE		@@OK1
			XCHG	AX,BX
@@OK1:
			CMP		AX,319
			JG		@@EXIT
			CMP		BX,0
			JL		@@EXIT

			CMP		SI,DI
			JLE		@@OK2
			XCHG	SI,DI
@@OK2:
			CMP		SI,199
			JG		@@EXIT
			CMP		DI,0
			JL		@@EXIT

			TEST	AX,AX
			JGE		@@OK3
			SUB		AX,AX
@@OK3:
			CMP		BX,319
			JLE		@@OK4
			MOV		BX,319
@@OK4:
			TEST	SI,SI
			JGE		@@OK5
			SUB		SI,SI
@@OK5:
			CMP		DI,199
			JLE		@@OK6
			MOV		DI,199
@@OK6:

			SUB		DI,SI
			INC		DI
			MOV		[Y2],DI

			MOV		ES,[VideoSeg]
			MOV		DI,AX
			MOV		CX,BX
			SUB		CX,AX
			INC		CX
			MOV		AX,SI
			SHL		AX,6
			SHL		SI,8
			ADD		DI,SI
			ADD		DI,AX
			MOV		DX,320
			SUB		DX,CX
			CLD
			MOV		AL,[Color]
			MOV		AH,AL
			MOV		SI,AX
	DB $66;	SHL		AX,16
			MOV		AX,SI
@@LOOP1:
			PUSH	CX
			SHR		CX,1
			DB $0F, $92, $C3
			SHR		CX,1
	DB $66;	REP		STOSW
			JNC		@@SKIP1
			STOSW
@@SKIP1:
			OR		BL,BL
			JZ		@@SKIP2
			STOSB
@@SKIP2:
			ADD		SI,DX
			ADD		DI,DX
			POP		CX
			DEC		[Y2]
			JNZ		@@LOOP1
@@EXIT:
End;

Procedure XRectangleGlenzXOR(X1,Y1,X2,Y2 : Integer; Color : Byte; VideoSeg : Word); Assembler;
Asm
			MOV		AX,[X1]
			MOV		BX,[X2]
			MOV		SI,[Y1]
			MOV		DI,[Y2]
			CMP		AX,BX
			JLE		@@OK1
			XCHG	AX,BX
@@OK1:
			CMP		AX,319
			JG		@@EXIT
			CMP		BX,0
			JL		@@EXIT

			CMP		SI,DI
			JLE		@@OK2
			XCHG	SI,DI
@@OK2:
			CMP		SI,199
			JG		@@EXIT
			CMP		DI,0
			JL		@@EXIT

			TEST	AX,AX
			JGE		@@OK3
			SUB		AX,AX
@@OK3:
			CMP		BX,319
			JLE		@@OK4
			MOV		BX,319
@@OK4:
			TEST	SI,SI
			JGE		@@OK5
			SUB		SI,SI
@@OK5:
			CMP		DI,199
			JLE		@@OK6
			MOV		DI,199
@@OK6:

			SUB		DI,SI
			INC		DI
			MOV		[Y2],DI

			MOV		ES,[VideoSeg]
			MOV		DI,AX
			MOV		CX,BX
			SUB		CX,AX
			INC		CX
			MOV		AX,SI
			SHL		AX,6
			SHL		SI,8
			ADD		DI,SI
			ADD		DI,AX
			MOV		DX,320
			SUB		DX,CX
			CLD
			MOV		AL,[Color]
			MOV		AH,AL
			MOV		SI,AX
	DB $66;	SHL		AX,16
			MOV		AX,SI
@@LOOP1:
			PUSH	CX
			SHR		CX,1
			DB $0F, $92, $C3
			SHR		CX,1
			DB $0F, $92, $C7
			JCXZ	@@SKIP1
@@STOSLOOP:
	DB $66;	XOR		[ES:DI],AX
			ADD		DI,4
			DEC		CX
			JNZ		@@STOSLOOP
@@SKIP1:
			OR		BH,BH
			JZ		@@SKIP2
			XOR		[ES:DI],AX
			ADD		DI,2
@@SKIP2:
			OR		BL,BL
			JZ		@@SKIP3
			XOR		[ES:DI],AL
			INC		DI
@@SKIP3:
			ADD		SI,DX
			ADD		DI,DX
			POP		CX
			DEC		[Y2]
			JNZ		@@LOOP1
@@EXIT:
End;

Procedure XRectangleClip(X1,Y1,X2,Y2,ClipX1,ClipY1,ClipX2,ClipY2 : Integer; Color : Byte; VideoSeg : Word); Assembler;
Asm
			MOV		AX,[X1]
			MOV		BX,[X2]
			MOV		SI,[Y1]
			MOV		DI,[Y2]
			CMP		AX,BX
			JLE		@@OK1
			XCHG	AX,BX
@@OK1:
			CMP		AX,[ClipX2]
			JG		@@EXIT
			CMP		BX,[ClipX1]
			JL		@@EXIT

			CMP		SI,DI
			JLE		@@OK2
			XCHG	SI,DI
@@OK2:
			CMP		SI,[ClipY2]
			JG		@@EXIT
			CMP		DI,[ClipY1]
			JL		@@EXIT

			CMP		AX,[ClipX1]
			JGE		@@OK3
			MOV		AX,[ClipX1]
@@OK3:
			CMP		BX,[ClipX2]
			JLE		@@OK4
			MOV		BX,[ClipX2]
@@OK4:
			CMP		SI,[ClipY1]
			JGE		@@OK5
			MOV		SI,[ClipY1]
@@OK5:
			CMP		DI,[ClipY2]
			JLE		@@OK6
			MOV		DI,[ClipY2]
@@OK6:

			SUB		DI,SI
			INC		DI
			MOV		[Y2],DI

			MOV		ES,[VideoSeg]
			MOV		DI,AX
			MOV		CX,BX
			SUB		CX,AX
			INC		CX
			MOV		AX,SI
			SHL		AX,6
			SHL		SI,8
			ADD		DI,SI
			ADD		DI,AX
			MOV		DX,320
			SUB		DX,CX
			CLD
			MOV		AL,[Color]
			MOV		AH,AL
			MOV		SI,AX
	DB $66;	SHL		AX,16
			MOV		AX,SI
@@LOOP1:
			PUSH	CX
			SHR		CX,1
			DB $0F, $92, $C3
			SHR		CX,1
	DB $66;	REP		STOSW
			JNC		@@SKIP1
			STOSW
@@SKIP1:
			OR		BL,BL
			JZ		@@SKIP2
			STOSB
@@SKIP2:
			ADD		SI,DX
			ADD		DI,DX
			POP		CX
			DEC		[Y2]
			JNZ		@@LOOP1
@@EXIT:
End;

Procedure XRectangleGlenzXORClip(X1,Y1,X2,Y2,ClipX1,ClipY1,ClipX2,ClipY2 : Integer; Color : Byte; VideoSeg : Word); Assembler;
Asm
			MOV		AX,[X1]
			MOV		BX,[X2]
			MOV		SI,[Y1]
			MOV		DI,[Y2]
			CMP		AX,BX
			JLE		@@OK1
			XCHG	AX,BX
@@OK1:
			CMP		AX,[ClipX2]
			JG		@@EXIT
			CMP		BX,[ClipX1]
			JL		@@EXIT

			CMP		SI,DI
			JLE		@@OK2
			XCHG	SI,DI
@@OK2:
			CMP		SI,[ClipY2]
			JG		@@EXIT
			CMP		DI,[ClipY1]
			JL		@@EXIT

			CMP		AX,[ClipX1]
			JGE		@@OK3
			MOV		AX,[ClipX1]
@@OK3:
			CMP		BX,[ClipX2]
			JLE		@@OK4
			MOV		BX,[ClipX2]
@@OK4:
			CMP		SI,[ClipY1]
			JGE		@@OK5
			MOV		SI,[ClipY1]
@@OK5:
			CMP		DI,[ClipY2]
			JLE		@@OK6
			MOV		DI,[ClipY2]
@@OK6:

			SUB		DI,SI
			INC		DI
			MOV		[Y2],DI

			MOV		ES,[VideoSeg]
			MOV		DI,AX
			MOV		CX,BX
			SUB		CX,AX
			INC		CX
			MOV		AX,SI
			SHL		AX,6
			SHL		SI,8
			ADD		DI,SI
			ADD		DI,AX
			MOV		DX,320
			SUB		DX,CX
			CLD
			MOV		AL,[Color]
			MOV		AH,AL
			MOV		SI,AX
	DB $66;	SHL		AX,16
			MOV		AX,SI
@@LOOP1:
			PUSH	CX
			SHR		CX,1
			DB $0F, $92, $C3
			SHR		CX,1
			DB $0F, $92, $C7
			JCXZ	@@SKIP1
@@STOSLOOP:
	DB $66;	XOR		[ES:DI],AX
			ADD		DI,4
			DEC		CX
			JNZ		@@STOSLOOP
@@SKIP1:
			OR		BH,BH
			JZ		@@SKIP2
			XOR		[ES:DI],AX
			ADD		DI,2
@@SKIP2:
			OR		BL,BL
			JZ		@@SKIP3
			XOR		[ES:DI],AL
			INC		DI
@@SKIP3:
			ADD		SI,DX
			ADD		DI,DX
			POP		CX
			DEC		[Y2]
			JNZ		@@LOOP1
@@EXIT:
End;

Procedure XMode(XVGAMode : Boolean); Assembler;
Asm
	MOV		AX,$0013
	CMP		[XVGAMode],TRUE
	JE		@@SET_IT
	MOV		AL,$03
@@SET_IT:
	INT		$10
End;

Procedure XSetRGB(Index,R,G,B :	Byte); Assembler;
Asm
	MOV		DX,$03C8
	MOV		AL,[Index]
	OUT		DX,AL
	INC		DX
	MOV		AL,[R]
	OUT		DX,AL
	MOV		AL,[G]
	OUT		DX,AL
	MOV		AL,[B]
	OUT		DX,AL
End;

Procedure XSetRGBMany(StartIndex : Byte; ColorCount : Word; Var	RGBData); Assembler;
Asm
	PUSH	DS
	LDS		SI,[DWORD PTR RGBData]
	MOV		DX,$03C8
	MOV		AL,[StartIndex]
	OUT		DX,AL
	MOV		CX,[ColorCount]
	MOV		AX,CX
	SHL		AX,1
	ADD		CX,AX
	CLD
	MOV		DX,$03C9
	REP		OUTSB
	POP		DS
End;

Procedure XGetRGB(Index : Byte; Var R,G,B : Byte); Assembler;
Asm
	MOV		AX,$1015
	XOR		BH,BH
	MOV		BL,Index
	INT		$10
	LES		DI,DWORD PTR R
	MOV		ES:[DI],DH
	LES		DI,DWORD PTR G
	MOV		ES:[DI],CH
	LES		DI,DWORD PTR B
	MOV		ES:[DI],CL
End;

Procedure XGetRGBMany(StartIndex : Byte; ColorCount : Word; Var RGBData); Assembler;
Asm
	LES		DI,[DWORD PTR RGBData]
	MOV		DX,$03C7
	MOV		AL,[StartIndex]
	OUT		DX,AL
	CLD
	MOV		AX,$0003
	MUL		[ColorCount]
	MOV		CX,AX
	MOV		DX,$03C9
	REP		INSB
End;

Function XLoadPCX320x200SetPalette(FileName : String; VideoSeg : Word) : Integer;
Var
	RGB			: Array[0..767] Of Byte;
	PCXFile		: File;
	OldMode		: Byte;
	BytesRead	: Word;
	Error		: Boolean;
	Buffer1		: PChar;
	InBuffer1	: Word;
	BufferSize1	: Word;
	Buffer2		: PChar;
	InBuffer2	: Word;
	BufferSize2	: Word;
	PCXHeader	: Record
		Manufacturer	: Byte;
		Version			: Byte;
		Encoding		: Byte;
		BitsPerPixel	: Byte;
		Window			: Record
			X1			: Integer;
			Y1			: Integer;
			X2			: Integer;
			Y2			: Integer;
		End;
		DPI				: Record
			Horizontal	: Integer;
			Vertical	: Integer;
		End;
		ColorMap		: Array[0..47] Of Byte;
		Reserved		: Byte;
		NPlanes			: Byte;
		BytesPerLine	: Integer;
		PaletteInfo		: Integer;
		ScreenSize		: Record
			Horizontal	: Integer;
			Vertical	: Integer;
		End;
		Filler			: Array[1..54] Of Byte;
	End;

	Procedure DeCode(VideoSeg : Word; ToDeCode : Word; Buffer1,Buffer2 : PChar; InBuffer1,InBuffer2 : Word); Assembler;
	Asm
		PUSH	DS
		MOV		CX,[ToDeCode]
		LDS		SI,[DWORD PTR Buffer1]
		MOV		DX,[InBuffer1]
		MOV		ES,[VideoSeg]
		XOR		DI,DI
	@@LOOP1:
		JCXZ	@@EXIT
		MOV		AL,[DS:SI]
		INC		SI
		DEC		DX
		JNZ		@@SKIP1
		LDS		SI,[DWORD PTR Buffer2]
		MOV		DX,[InBuffer2]
	@@SKIP1:
		MOV		AH,AL
		AND		AH,$C0
		CMP		AH,$C0
		JE		@@RLE
		MOV		[ES:DI],AL
		INC		DI
		DEC		CX
		JMP		@@LOOP1
	@@RLE:
		MOV		AH,AL
		AND		AH,$3F
	@@LOOP2:
		MOV		AL,[DS:SI]
		INC		SI
		DEC		DX
		JNZ		@@SKIP2
		LDS		SI,[DWORD PTR Buffer2]
		MOV		DX,[InBuffer2]
	@@SKIP2:
		MOV		[ES:DI],AL
		INC		DI
		DEC		CX
		DEC		AH
		JNZ		@@SKIP2
		JMP		@@LOOP1
	@@EXIT:
		POP		DS
	End;

Begin
	Assign(PCXFile,FileName);
	OldMode:=FileMode;
	FileMode:=0;
	{$I-}
	ReSet(PCXFile,1);
	FileMode:=OldMode;
	{$I+}
	If IOResult<>0 Then Begin
		XLoadPCX320x200SetPalette:=1;
		Exit;
	End;
	BlockRead(PCXFile,PCXHeader,SizeOf(PCXHeader),BytesRead);
	If BytesRead<>SizeOf(PCXHeader) Then Begin
		Close(PCXFile);
		XLoadPCX320x200SetPalette:=2;
		Exit;
	End;
	Error:=FALSE;
	With PCXHeader Do Begin
		If Manufacturer<>10 Then
			Error:=TRUE;
		If EnCoding<>1 Then
			Error:=TRUE;
		If BitsPerPixel<>8 Then
			Error:=TRUE;
		If (Window.X2-Window.X1+1)<>320 Then
			Error:=TRUE;
		If (Window.Y2-Window.Y1+1)<>200 Then
			Error:=TRUE;
		If NPlanes<>1 Then
			Error:=TRUE;
		If PaletteInfo<>1 Then
			Error:=TRUE;
	End;
	If Error Then Begin
		XLoadPCX320x200SetPalette:=3;
		Close(PCXFile);
		Exit;
	End;
	If FileSize(PCXFile)-FilePos(PCXFile)-768<=65528 Then Begin
		BufferSize1:=FileSize(PCXFile)-FilePos(PCXFile)-768;
		BufferSize2:=0;
	End Else Begin
		BufferSize1:=65528;
		BufferSize2:=FileSize(PCXFile)-FilePos(PCXFile)-66296;
	End;
	GetMem(Buffer1,BufferSize1);
	If Buffer1=NIL Then Begin
		Close(PCXFile);
		XLoadPCX320x200SetPalette:=5;
		Exit;
	End;
	BlockRead(PCXFile,Buffer1^,BufferSize1,InBuffer1);
	If BufferSize2<>0 Then Begin
		GetMem(Buffer2,BufferSize2);
		If Buffer2=NIL Then Begin
			FreeMem(Buffer1,BufferSize1);
			Close(PCXFile);
			XLoadPCX320x200SetPalette:=5;
			Exit;
		End;
		BlockRead(PCXFile,Buffer2^,BufferSize2,InBuffer2);
	End Else
		InBuffer2:=0;
	If (BufferSize1<>InBuffer1) Or (BufferSize2<>InBuffer2) Then Begin
		Close(PCXFile);
		FreeMem(Buffer1,BufferSize1);
		If BufferSize2<>0 Then
			FreeMem(Buffer2,BufferSize2);
		XLoadPCX320x200SetPalette:=4;
		Exit;
	End;
	With PCXHeader Do
		DeCode(VideoSeg,LongInt(Window.X2-Window.X1+1)*LongInt(Window.Y2-Window.Y1+1),
			Buffer1,Buffer2,InBuffer1,InBuffer2);
	FreeMem(Buffer1,BufferSize1);
	If BufferSize2<>0 Then
		FreeMem(Buffer2,BufferSize2);
	XLoadPCX320x200SetPalette:=4;
	Seek(PCXFile,FileSize(PCXFile)-768);
	BlockRead(PCXFile,RGB,768,BytesRead);
	Close(PCXFile);
	If BytesRead<>768 Then Begin
		XLoadPCX320x200SetPalette:=6;
		Exit;
	End;
	Asm
		LEA		SI,[RGB]
		MOV		CX,768
	@@LOOP1:
		MOV		AL,[SS:SI]
		SHR		AL,2
		MOV		[SS:SI],AL
		INC		SI
		DEC		CX
		JNZ		@@LOOP1
	End;
	VRet;
	XSetRGBMany(0,256,RGB);
	XLoadPCX320x200SetPalette:=0;
End;

Function XLoadPCX(FileName : String; Var Width,Height : Word; Var RGB; VideoSeg : Word) : Integer;
Var
	PCXFile		: File;
	OldMode		: Byte;
	BytesRead	: Word;
	Error		: Boolean;
	Buffer1		: PChar;
	InBuffer1	: Word;
	BufferSize1	: Word;
	Buffer2		: PChar;
	InBuffer2	: Word;
	BufferSize2	: Word;
	PCXHeader	: Record
		Manufacturer	: Byte;
		Version			: Byte;
		Encoding		: Byte;
		BitsPerPixel	: Byte;
		Window			: Record
			X1			: Integer;
			Y1			: Integer;
			X2			: Integer;
			Y2			: Integer;
		End;
		DPI				: Record
			Horizontal	: Integer;
			Vertical	: Integer;
		End;
		ColorMap		: Array[0..47] Of Byte;
		Reserved		: Byte;
		NPlanes			: Byte;
		BytesPerLine	: Integer;
		PaletteInfo		: Integer;
		ScreenSize		: Record
			Horizontal	: Integer;
			Vertical	: Integer;
		End;
		Filler			: Array[1..54] Of Byte;
	End;

	Procedure DeCode(VideoSeg : Word; ToDeCode : Word; Buffer1,Buffer2 : PChar; InBuffer1,InBuffer2 : Word); Assembler;
	Asm
		PUSH	DS
		MOV		CX,[ToDeCode]
		LDS		SI,[DWORD PTR Buffer1]
		MOV		DX,[InBuffer1]
		MOV		ES,[VideoSeg]
		XOR		DI,DI
	@@LOOP1:
		JCXZ	@@EXIT
		MOV		AL,[DS:SI]
		INC		SI
		DEC		DX
		JNZ		@@SKIP1
		LDS		SI,[DWORD PTR Buffer2]
		MOV		DX,[InBuffer2]
	@@SKIP1:
		MOV		AH,AL
		AND		AH,$C0
		CMP		AH,$C0
		JE		@@RLE
		MOV		[ES:DI],AL
		INC		DI
		DEC		CX
		JMP		@@LOOP1
	@@RLE:
		MOV		AH,AL
		AND		AH,$3F
	@@LOOP2:
		MOV		AL,[DS:SI]
		INC		SI
		DEC		DX
		JNZ		@@SKIP2
		LDS		SI,[DWORD PTR Buffer2]
		MOV		DX,[InBuffer2]
	@@SKIP2:
		MOV		[ES:DI],AL
		INC		DI
		DEC		CX
		DEC		AH
		JNZ		@@SKIP2
		JMP		@@LOOP1
	@@EXIT:
		POP		DS
	End;

Begin
	Assign(PCXFile,FileName);
	OldMode:=FileMode;
	FileMode:=0;
	{$I-}
	ReSet(PCXFile,1);
	FileMode:=OldMode;
	{$I+}
	If IOResult<>0 Then Begin
		XLoadPCX:=1;
		Exit;
	End;
	BlockRead(PCXFile,PCXHeader,SizeOf(PCXHeader),BytesRead);
	If BytesRead<>SizeOf(PCXHeader) Then Begin
		Close(PCXFile);
		XLoadPCX:=2;
		Exit;
	End;
	Error:=FALSE;
	With PCXHeader Do Begin
		If Manufacturer<>10 Then
			Error:=TRUE;
		If EnCoding<>1 Then
			Error:=TRUE;
		If BitsPerPixel<>8 Then
			Error:=TRUE;
		If LongInt(Window.X2-Window.X1+1)*LongInt(Window.Y2-Window.Y1+1)>65528 Then
			Error:=TRUE;
		If NPlanes<>1 Then
			Error:=TRUE;
		If PaletteInfo<>1 Then
			Error:=TRUE;
		Width:=Window.X2-Window.X1+1;
		Height:=Window.Y2-Window.Y1+1;
	End;
	If Error Then Begin
		XLoadPCX:=3;
		Close(PCXFile);
		Exit;
	End;
	If FileSize(PCXFile)-FilePos(PCXFile)-768<=65528 Then Begin
		BufferSize1:=FileSize(PCXFile)-FilePos(PCXFile)-768;
		BufferSize2:=0;
	End Else Begin
		BufferSize1:=65528;
		BufferSize2:=FileSize(PCXFile)-FilePos(PCXFile)-66296;
	End;
	GetMem(Buffer1,BufferSize1);
	If Buffer1=NIL Then Begin
		Close(PCXFile);
		XLoadPCX:=5;
		Exit;
	End;
	BlockRead(PCXFile,Buffer1^,BufferSize1,InBuffer1);
	If BufferSize2<>0 Then Begin
		GetMem(Buffer2,BufferSize2);
		If Buffer2=NIL Then Begin
			FreeMem(Buffer1,BufferSize1);
			Close(PCXFile);
			XLoadPCX:=5;
			Exit;
		End;
		BlockRead(PCXFile,Buffer2^,BufferSize2,InBuffer2);
	End Else
		InBuffer2:=0;
	If (BufferSize1<>InBuffer1) Or (BufferSize2<>InBuffer2) Then Begin
		Close(PCXFile);
		FreeMem(Buffer1,BufferSize1);
		If BufferSize2<>0 Then
			FreeMem(Buffer2,BufferSize2);
		XLoadPCX:=4;
		Exit;
	End;
	With PCXHeader Do
		DeCode(VideoSeg,Width*Height,Buffer1,Buffer2,InBuffer1,InBuffer2);
	FreeMem(Buffer1,BufferSize1);
	If BufferSize2<>0 Then
		FreeMem(Buffer2,BufferSize2);
	XLoadPCX:=4;
	Seek(PCXFile,FileSize(PCXFile)-768);
	BlockRead(PCXFile,RGB,768,BytesRead);
	Close(PCXFile);
	If BytesRead<>768 Then Begin
		XLoadPCX:=6;
		Exit;
	End;
	Asm
		LES		DI,[DWORD PTR RGB]
		MOV		CX,768
	@@LOOP1:
		SHR		[BYTE PTR ES:DI],2
		INC		DI
		DEC		CX
		JNZ		@@LOOP1
	End;
	XLoadPCX:=0;
End;

Procedure XScaleBitMap(X1,Y1,X2,Y2 : Integer;
	Var BitMap; BitMapWidth,BitMapHeight : Word; VideoSeg : Word); Assembler;
Var
	CCY		: LongInt;
	DDX,DDY	: LongInt;
	Y		: Integer;
	Ofs3	: LongInt;
	Ofs4	: LongInt;
	DOfs	: LongInt;
	XX1,YY1	: LongInt;
	XX2,YY2	: LongInt;
	TempDS	: Word;
	TempDI	: Word;
	TempSI	: Word;
Asm
			MOV		[TempDS],DS
			MOV		AX,[X1]
			MOV		BX,[Y1]
			MOV		CX,[X2]
			MOV		DX,[Y2]

			TEST	AX,AX
			JGE		@@IN1
			TEST	CX,CX
			JGE		@@IN1
			JMP		@@EXIT
@@IN1:
			CMP		AX,319
			JLE		@@IN2
			CMP		CX,319
			JLE		@@IN2
			JMP		@@EXIT
@@IN2:
			TEST	BX,BX
			JGE		@@IN3
			TEST	DX,DX
			JGE		@@IN3
			JMP		@@EXIT
@@IN3:
			CMP		BX,199
			JLE		@@IN4
			CMP		DX,199
			JLE		@@IN4
			JMP		@@EXIT
@@IN4:

	DB $66;	XOR		AX,AX
	DB $66;	MOV		[WORD PTR XX1],AX
	DB $66;	MOV		[WORD PTR YY1],AX
	DB $66;	DB $0F, $BF, $46, OFFSET BitMapWidth
	DB $66;	DEC		AX
	DB $66;	SHL		AX,Scaler
	DB $66;	MOV		[WORD PTR XX2],AX
	DB $66;	DB $0F, $BF, $46, OFFSET BitMapHeight
	DB $66;	DEC		AX
	DB $66;	SHL		AX,Scaler
	DB $66;	MOV		[WORD PTR YY2],AX

			MOV		AX,[X1]
			CMP		AX,[X2]
			JLE		@@OK1
			XCHG	AX,[X2]
			MOV		[X1],AX
	DB $66;	MOV		AX,[WORD PTR XX1]
	DB $66;	XCHG	AX,[WORD PTR XX2]
	DB $66;	MOV		[WORD PTR XX1],AX
@@OK1:
			MOV		AX,[Y1]
			CMP		AX,[Y2]
			JLE		@@OK2
			XCHG	AX,[Y2]
			MOV		[Y1],AX
	DB $66;	MOV		AX,[WORD PTR YY1]
	DB $66;	XCHG	AX,[WORD PTR YY2]
	DB $66;	MOV		[WORD PTR YY1],AX
@@OK2:

			MOV		AX,[X1]
			CMP		AX,[X2]
			JNE		@@NONFLAT1
	DB $66;	XOR		AX,AX
	DB $66;	MOV		[WORD PTR DDX],AX
			JMP		@@OK3
@@NONFLAT1:
	DB $66;	MOV		AX,[WORD PTR XX2]
	DB $66;	SUB		AX,[WORD PTR XX1]
	DB $66;	CWD
	DB $66;	DB $0F, $BF, $5E, OFFSET X2
	DB $66;	DB $0F, $BF, $4E, OFFSET X1
	DB $66;	SUB		BX,CX
	DB $66;	IDIV	BX
	DB $66;	MOV		[WORD PTR DDX],AX
@@OK3:

			MOV		AX,[Y1]
			CMP		AX,[Y2]
			JNE		@@NONFLAT2
	DB $66;	XOR		AX,AX
	DB $66;	MOV		[WORD PTR DDY],AX
			JMP		@@OK4
@@NONFLAT2:
	DB $66;	MOV		AX,[WORD PTR YY2]
	DB $66;	SUB		AX,[WORD PTR YY1]
	DB $66;	CWD
	DB $66;	DB $0F, $BF, $5E, OFFSET Y2
	DB $66;	DB $0F, $BF, $4E, OFFSET Y1
	DB $66;	SUB		BX,CX
	DB $66;	IDIV	BX
	DB $66;	MOV		[WORD PTR DDY],AX
@@OK4:

	DB $66;	MOV		AX,[WORD PTR YY1]
	DB $66;	MOV		[WORD PTR CCY],AX

			MOV		AX,[Y1]
			TEST	AX,AX
			JGE		@@OK5
			SUB		AX,AX
@@OK5:
			MOV		DI,AX
			SHL		DI,6
			SHL		AX,8
			ADD		DI,AX

			XOR		SI,SI

			MOV		AX,[Y1]
			MOV		[Y],AX

			MOV		ES,[VideoSeg]
			MOV		DS,[WORD PTR BitMap+2]

			XOR		BX,BX
			SUB		AX,AX
			MOV		[WORD PTR Ofs3],BX
			MOV		[WORD PTR Ofs3+2],AX
			ADD		AX,[BitMapWidth]
			DEC		AX
			MOV		[WORD PTR Ofs4],BX
			MOV		[WORD PTR Ofs4+2],AX

			MOV		AX,[X1]
			CMP		AX,[X2]
			JNE		@@NONFLAT3
	DB $66;	XOR		AX,AX
			JMP		@@OK8
@@NONFLAT3:
	DB $66;	MOV		AX,[WORD PTR Ofs4]
	DB $66;	SUB		AX,[WORD PTR Ofs3]
	DB $66;	CWD
	DB $66;	DB $0F, $BF, $5E, OFFSET X2
	DB $66;	DB $0F, $BF, $4E, OFFSET X1
	DB $66;	SUB		BX,CX
	DB $66;	IDIV	BX
@@OK8:
	DB $66;	MOV		[WORD PTR DOfs],AX

@@LINELOOP:
			MOV		AX,[WORD PTR CCY+2]
			MUL		[BitMapWidth]
			MOV		SI,AX
			ADD		SI,[WORD PTR BitMap]

			MOV		AX,[Y]
			TEST	AX,AX
			JL		@@NEXTLINE
			CMP		AX,199
			JG		@@EXIT

			MOV		[TempDI],DI
			MOV		AX,[X1]
			TEST	AX,AX
			JGE		@@OK6
			SUB		AX,AX
@@OK6:
			CMP		AX,319
			JLE		@@OK7
			MOV		AX,319
@@OK7:
			ADD		DI,AX

			MOV		CX,[X1]
			MOV		DX,SI
	DB $66;	SHL		DX,Scaler
			MOV		[TempSI],SI
	DB $66;	MOV		SI,[WORD PTR DOfs]
			PUSH	BP
			MOV		BP,[WORD PTR X2]
			CMP		BP,319
			JLE		@@PIXELLOOP
			MOV		BP,319
@@PIXELLOOP:
			TEST	CX,CX
			JL		@@NEXTPIXEL

	DB $66;	MOV		BX,DX
	DB $66;	SAR		BX,Scaler
			MOV		AL,[DS:BX]
			MOV		[ES:DI],AL
			INC		DI
@@NEXTPIXEL:
	DB $66;	ADD		DX,SI
			INC		CX
			CMP		CX,BP
			JLE		@@PIXELLOOP
@@ENDOFLINE:
			POP		BP
			MOV		SI,[TempSI]
			MOV		DI,[TempDI]
			ADD		DI,320
@@NEXTLINE:

	DB $66;	MOV		AX,[WORD PTR DDY]
	DB $66;	ADD		[WORD PTR CCY],AX

			INC		[Y]
			MOV		AX,[Y]
			CMP		AX,[Y2]
			JLE		@@LINELOOP
@@EXIT:
			MOV		DS,[TempDS]
End;

Procedure XScaleBitMapClip(X1,Y1,X2,Y2,ClipX1,ClipY1,ClipX2,ClipY2 : Integer;
	Var BitMap; BitMapWidth,BitMapHeight : Word; VideoSeg : Word); Assembler;
Var
	CCY		: LongInt;
	DDX,DDY	: LongInt;
	Y		: Integer;
	Ofs3	: LongInt;
	Ofs4	: LongInt;
	DOfs	: LongInt;
	XX1,YY1	: LongInt;
	XX2,YY2	: LongInt;
	TempDS	: Word;
	TempDI	: Word;
	TempSI	: Word;
	NewX2	: Integer;
Asm
			MOV		[TempDS],DS
			MOV		AX,[X1]
			MOV		BX,[Y1]
			MOV		CX,[X2]
			MOV		DX,[Y2]

			CMP		AX,[ClipX1]
			JGE		@@IN1
			CMP		CX,[ClipX1]
			JGE		@@IN1
			JMP		@@EXIT
@@IN1:
			CMP		AX,[ClipX2]
			JLE		@@IN2
			CMP		CX,[ClipX2]
			JLE		@@IN2
			JMP		@@EXIT
@@IN2:
			CMP		BX,[ClipY1]
			JGE		@@IN3
			CMP		DX,[ClipY1]
			JGE		@@IN3
			JMP		@@EXIT
@@IN3:
			CMP		BX,[ClipY2]
			JLE		@@IN4
			CMP		DX,[ClipY2]
			JLE		@@IN4
			JMP		@@EXIT
@@IN4:

	DB $66;	XOR		AX,AX
	DB $66;	MOV		[WORD PTR XX1],AX
	DB $66;	MOV		[WORD PTR YY1],AX
	DB $66;	DB $0F, $BF, $46, OFFSET BitMapWidth
	DB $66;	DEC		AX
	DB $66;	SHL		AX,Scaler
	DB $66;	MOV		[WORD PTR XX2],AX
	DB $66;	DB $0F, $BF, $46, OFFSET BitMapHeight
	DB $66;	DEC		AX
	DB $66;	SHL		AX,Scaler
	DB $66;	MOV		[WORD PTR YY2],AX

			MOV		AX,[X1]
			CMP		AX,[X2]
			JLE		@@OK1
			XCHG	AX,[X2]
			MOV		[X1],AX
	DB $66;	MOV		AX,[WORD PTR XX1]
	DB $66;	XCHG	AX,[WORD PTR XX2]
	DB $66;	MOV		[WORD PTR XX1],AX
@@OK1:
			MOV		AX,[Y1]
			CMP		AX,[Y2]
			JLE		@@OK2
			XCHG	AX,[Y2]
			MOV		[Y1],AX
	DB $66;	MOV		AX,[WORD PTR YY1]
	DB $66;	XCHG	AX,[WORD PTR YY2]
	DB $66;	MOV		[WORD PTR YY1],AX
@@OK2:

			MOV		AX,[X1]
			CMP		AX,[X2]
			JNE		@@NONFLAT1
	DB $66;	XOR		AX,AX
	DB $66;	MOV		[WORD PTR DDX],AX
			JMP		@@OK3
@@NONFLAT1:
	DB $66;	MOV		AX,[WORD PTR XX2]
	DB $66;	SUB		AX,[WORD PTR XX1]
	DB $66;	CWD
	DB $66;	DB $0F, $BF, $5E, OFFSET X2
	DB $66;	DB $0F, $BF, $4E, OFFSET X1
	DB $66;	SUB		BX,CX
	DB $66;	IDIV	BX
	DB $66;	MOV		[WORD PTR DDX],AX
@@OK3:

			MOV		AX,[Y1]
			CMP		AX,[Y2]
			JNE		@@NONFLAT2
	DB $66;	XOR		AX,AX
	DB $66;	MOV		[WORD PTR DDY],AX
			JMP		@@OK4
@@NONFLAT2:
	DB $66;	MOV		AX,[WORD PTR YY2]
	DB $66;	SUB		AX,[WORD PTR YY1]
	DB $66;	CWD
	DB $66;	DB $0F, $BF, $5E, OFFSET Y2
	DB $66;	DB $0F, $BF, $4E, OFFSET Y1
	DB $66;	SUB		BX,CX
	DB $66;	IDIV	BX
	DB $66;	MOV		[WORD PTR DDY],AX
@@OK4:

	DB $66;	MOV		AX,[WORD PTR YY1]
	DB $66;	MOV		[WORD PTR CCY],AX

			MOV		AX,[Y1]
			CMP		AX,[ClipY1]
			JGE		@@OK5
			MOV		AX,[ClipY1]
@@OK5:
			MOV		DI,AX
			SHL		DI,6
			SHL		AX,8
			ADD		DI,AX

			XOR		SI,SI

			MOV		AX,[Y1]
			MOV		[Y],AX

			MOV		ES,[VideoSeg]
			MOV		DS,[WORD PTR BitMap+2]

			XOR		BX,BX
			SUB		AX,AX
			MOV		[WORD PTR Ofs3],BX
			MOV		[WORD PTR Ofs3+2],AX
			ADD		AX,[BitMapWidth]
			DEC		AX
			MOV		[WORD PTR Ofs4],BX
			MOV		[WORD PTR Ofs4+2],AX

			MOV		AX,[X1]
			CMP		AX,[X2]
			JNE		@@NONFLAT3
	DB $66;	XOR		AX,AX
			JMP		@@OK8
@@NONFLAT3:
	DB $66;	MOV		AX,[WORD PTR Ofs4]
	DB $66;	SUB		AX,[WORD PTR Ofs3]
	DB $66;	CWD
	DB $66;	DB $0F, $BF, $5E, OFFSET X2
	DB $66;	DB $0F, $BF, $4E, OFFSET X1
	DB $66;	SUB		BX,CX
	DB $66;	IDIV	BX
@@OK8:
	DB $66;	MOV		[WORD PTR DOfs],AX


@@LINELOOP:
			MOV		AX,[WORD PTR CCY+2]
			MUL		[BitMapWidth]
			MOV		SI,AX
			ADD		SI,[WORD PTR BitMap]

			MOV		AX,[Y]
			CMP		AX,[ClipY1]
			JL		@@NEXTLINE
			CMP		AX,[ClipY2]
			JG		@@EXIT

			MOV		[TempDI],DI
			MOV		AX,[X1]
			CMP		AX,[ClipX1]
			JGE		@@OK6
			MOV		AX,[ClipX1]
@@OK6:
			CMP		AX,[ClipX2]
			JLE		@@OK7
			MOV		AX,[ClipX2]
@@OK7:
			ADD		DI,AX

			MOV		CX,[X1]
			MOV		DX,SI
	DB $66;	SHL		DX,Scaler
			MOV		[TempSI],SI
	DB $66;	MOV		SI,[WORD PTR DOfs]
			MOV		BX,[X2]
			CMP		BX,[ClipX2]
			JLE		@@OK8_2
			MOV		BX,[ClipX2]
@@OK8_2:
			MOV		[NewX2],BX
@@PIXELLOOP:
			CMP		CX,[ClipX1]
			JL		@@NEXTPIXEL

	DB $66;	MOV		BX,DX
	DB $66;	SAR		BX,Scaler
			MOV		AL,[DS:BX]
			MOV		[ES:DI],AL
			INC		DI
@@NEXTPIXEL:
	DB $66;	ADD		DX,SI
			INC		CX
			CMP		CX,[NewX2]
			JLE		@@PIXELLOOP
@@ENDOFLINE:
			MOV		SI,[TempSI]
			MOV		DI,[TempDI]
			ADD		DI,320
@@NEXTLINE:

	DB $66;	MOV		AX,[WORD PTR DDY]
	DB $66;	ADD		[WORD PTR CCY],AX

			INC		[Y]
			MOV		AX,[Y]
			CMP		AX,[Y2]
			JLE		@@LINELOOP
@@EXIT:
			MOV		DS,[TempDS]
End;

Procedure XScaleTransparentBitMap(X1,Y1,X2,Y2 : Integer;
	Var BitMap; BitMapWidth,BitMapHeight : Word; TranspColor : Byte; VideoSeg : Word); Assembler;
Var
	CCY		: LongInt;
	DDX,DDY	: LongInt;
	Y		: Integer;
	Ofs3	: LongInt;
	Ofs4	: LongInt;
	DOfs	: LongInt;
	XX1,YY1	: LongInt;
	XX2,YY2	: LongInt;
	TempDS	: Word;
	TempDI	: Word;
	TempSI	: Word;
Asm
			MOV		[TempDS],DS
			MOV		AX,[X1]
			MOV		BX,[Y1]
			MOV		CX,[X2]
			MOV		DX,[Y2]

			TEST	AX,AX
			JGE		@@IN1
			TEST	CX,CX
			JGE		@@IN1
			JMP		@@EXIT
@@IN1:
			CMP		AX,319
			JLE		@@IN2
			CMP		CX,319
			JLE		@@IN2
			JMP		@@EXIT
@@IN2:
			TEST	BX,BX
			JGE		@@IN3
			TEST	DX,DX
			JGE		@@IN3
			JMP		@@EXIT
@@IN3:
			CMP		BX,199
			JLE		@@IN4
			CMP		DX,199
			JLE		@@IN4
			JMP		@@EXIT
@@IN4:

	DB $66;	XOR		AX,AX
	DB $66;	MOV		[WORD PTR XX1],AX
	DB $66;	MOV		[WORD PTR YY1],AX
	DB $66;	DB $0F, $BF, $46, OFFSET BitMapWidth
	DB $66;	DEC		AX
	DB $66;	SHL		AX,Scaler
	DB $66;	MOV		[WORD PTR XX2],AX
	DB $66;	DB $0F, $BF, $46, OFFSET BitMapHeight
	DB $66;	DEC		AX
	DB $66;	SHL		AX,Scaler
	DB $66;	MOV		[WORD PTR YY2],AX

			MOV		AX,[X1]
			CMP		AX,[X2]
			JLE		@@OK1
			XCHG	AX,[X2]
			MOV		[X1],AX
	DB $66;	MOV		AX,[WORD PTR XX1]
	DB $66;	XCHG	AX,[WORD PTR XX2]
	DB $66;	MOV		[WORD PTR XX1],AX
@@OK1:
			MOV		AX,[Y1]
			CMP		AX,[Y2]
			JLE		@@OK2
			XCHG	AX,[Y2]
			MOV		[Y1],AX
	DB $66;	MOV		AX,[WORD PTR YY1]
	DB $66;	XCHG	AX,[WORD PTR YY2]
	DB $66;	MOV		[WORD PTR YY1],AX
@@OK2:

			MOV		AX,[X1]
			CMP		AX,[X2]
			JNE		@@NONFLAT1
	DB $66;	XOR		AX,AX
	DB $66;	MOV		[WORD PTR DDX],AX
			JMP		@@OK3
@@NONFLAT1:
	DB $66;	MOV		AX,[WORD PTR XX2]
	DB $66;	SUB		AX,[WORD PTR XX1]
	DB $66;	CWD
	DB $66;	DB $0F, $BF, $5E, OFFSET X2
	DB $66;	DB $0F, $BF, $4E, OFFSET X1
	DB $66;	SUB		BX,CX
	DB $66;	IDIV	BX
	DB $66;	MOV		[WORD PTR DDX],AX
@@OK3:

			MOV		AX,[Y1]
			CMP		AX,[Y2]
			JNE		@@NONFLAT2
	DB $66;	XOR		AX,AX
	DB $66;	MOV		[WORD PTR DDY],AX
			JMP		@@OK4
@@NONFLAT2:
	DB $66;	MOV		AX,[WORD PTR YY2]
	DB $66;	SUB		AX,[WORD PTR YY1]
	DB $66;	CWD
	DB $66;	DB $0F, $BF, $5E, OFFSET Y2
	DB $66;	DB $0F, $BF, $4E, OFFSET Y1
	DB $66;	SUB		BX,CX
	DB $66;	IDIV	BX
	DB $66;	MOV		[WORD PTR DDY],AX
@@OK4:

	DB $66;	MOV		AX,[WORD PTR YY1]
	DB $66;	MOV		[WORD PTR CCY],AX

			MOV		AX,[Y1]
			TEST	AX,AX
			JGE		@@OK5
			SUB		AX,AX
@@OK5:
			MOV		DI,AX
			SHL		DI,6
			SHL		AX,8
			ADD		DI,AX

			XOR		SI,SI

			MOV		AX,[Y1]
			MOV		[Y],AX

			MOV		ES,[VideoSeg]
			MOV		DS,[WORD PTR BitMap+2]

			XOR		BX,BX
			SUB		AX,AX
			MOV		[WORD PTR Ofs3],BX
			MOV		[WORD PTR Ofs3+2],AX
			ADD		AX,[BitMapWidth]
			DEC		AX
			MOV		[WORD PTR Ofs4],BX
			MOV		[WORD PTR Ofs4+2],AX

			MOV		AX,[X1]
			CMP		AX,[X2]
			JNE		@@NONFLAT3
	DB $66;	XOR		AX,AX
			JMP		@@OK8
@@NONFLAT3:
	DB $66;	MOV		AX,[WORD PTR Ofs4]
	DB $66;	SUB		AX,[WORD PTR Ofs3]
	DB $66;	CWD
	DB $66;	DB $0F, $BF, $5E, OFFSET X2
	DB $66;	DB $0F, $BF, $4E, OFFSET X1
	DB $66;	SUB		BX,CX
	DB $66;	IDIV	BX
@@OK8:
	DB $66;	MOV		[WORD PTR DOfs],AX

@@LINELOOP:
			MOV		AX,[WORD PTR CCY+2]
			MUL		[BitMapWidth]
			MOV		SI,AX
			ADD		SI,[WORD PTR BitMap]

			MOV		AX,[Y]
			TEST	AX,AX
			JL		@@NEXTLINE
			CMP		AX,199
			JG		@@EXIT

			MOV		[TempDI],DI
			MOV		AX,[X1]
			TEST	AX,AX
			JGE		@@OK6
			SUB		AX,AX
@@OK6:
			CMP		AX,319
			JLE		@@OK7
			MOV		AX,319
@@OK7:
			ADD		DI,AX

			MOV		CX,[X1]
			MOV		DX,SI
	DB $66;	SHL		DX,Scaler
			MOV		[TempSI],SI
	DB $66;	MOV		SI,[WORD PTR DOfs]
			MOV		AH,[TranspColor]
			PUSH	BP
			MOV		BP,[WORD PTR X2]
			CMP		BP,319
			JLE		@@PIXELLOOP
			MOV		BP,319
@@PIXELLOOP:
			TEST	CX,CX
			JL		@@NEXTPIXEL

	DB $66;	MOV		BX,DX
	DB $66;	SAR		BX,Scaler
			MOV		AL,[DS:BX]
			CMP		AL,AH
			JE		@@NOTPLOT
			MOV		[ES:DI],AL
@@NOTPLOT:
			INC		DI
@@NEXTPIXEL:
	DB $66;	ADD		DX,SI
			INC		CX
			CMP		CX,BP
			JLE		@@PIXELLOOP
@@ENDOFLINE:
			POP		BP
			MOV		SI,[TempSI]
			MOV		DI,[TempDI]
			ADD		DI,320
@@NEXTLINE:

	DB $66;	MOV		AX,[WORD PTR DDY]
	DB $66;	ADD		[WORD PTR CCY],AX

			INC		[Y]
			MOV		AX,[Y]
			CMP		AX,[Y2]
			JLE		@@LINELOOP
@@EXIT:
			MOV		DS,[TempDS]
End;

Procedure XScaleTransparentBitMapClip(X1,Y1,X2,Y2,ClipX1,ClipY1,ClipX2,ClipY2 : Integer;
	Var BitMap; BitMapWidth,BitMapHeight : Word; TranspColor : Byte; VideoSeg : Word); Assembler;
Var
	CCY		: LongInt;
	DDX,DDY	: LongInt;
	Y		: Integer;
	Ofs3	: LongInt;
	Ofs4	: LongInt;
	DOfs	: LongInt;
	XX1,YY1	: LongInt;
	XX2,YY2	: LongInt;
	TempDS	: Word;
	TempDI	: Word;
	TempSI	: Word;
	NewX2	: Integer;
Asm
			MOV		[TempDS],DS
			MOV		AX,[X1]
			MOV		BX,[Y1]
			MOV		CX,[X2]
			MOV		DX,[Y2]

			CMP		AX,[ClipX1]
			JGE		@@IN1
			CMP		CX,[ClipX1]
			JGE		@@IN1
			JMP		@@EXIT
@@IN1:
			CMP		AX,[ClipX2]
			JLE		@@IN2
			CMP		CX,[ClipX2]
			JLE		@@IN2
			JMP		@@EXIT
@@IN2:
			CMP		BX,[ClipY1]
			JGE		@@IN3
			CMP		DX,[ClipY1]
			JGE		@@IN3
			JMP		@@EXIT
@@IN3:
			CMP		BX,[ClipY2]
			JLE		@@IN4
			CMP		DX,[ClipY2]
			JLE		@@IN4
			JMP		@@EXIT
@@IN4:

	DB $66;	XOR		AX,AX
	DB $66;	MOV		[WORD PTR XX1],AX
	DB $66;	MOV		[WORD PTR YY1],AX
	DB $66;	DB $0F, $BF, $46, OFFSET BitMapWidth
	DB $66;	DEC		AX
	DB $66;	SHL		AX,Scaler
	DB $66;	MOV		[WORD PTR XX2],AX
	DB $66;	DB $0F, $BF, $46, OFFSET BitMapHeight
	DB $66;	DEC		AX
	DB $66;	SHL		AX,Scaler
	DB $66;	MOV		[WORD PTR YY2],AX

			MOV		AX,[X1]
			CMP		AX,[X2]
			JLE		@@OK1
			XCHG	AX,[X2]
			MOV		[X1],AX
	DB $66;	MOV		AX,[WORD PTR XX1]
	DB $66;	XCHG	AX,[WORD PTR XX2]
	DB $66;	MOV		[WORD PTR XX1],AX
@@OK1:
			MOV		AX,[Y1]
			CMP		AX,[Y2]
			JLE		@@OK2
			XCHG	AX,[Y2]
			MOV		[Y1],AX
	DB $66;	MOV		AX,[WORD PTR YY1]
	DB $66;	XCHG	AX,[WORD PTR YY2]
	DB $66;	MOV		[WORD PTR YY1],AX
@@OK2:

			MOV		AX,[X1]
			CMP		AX,[X2]
			JNE		@@NONFLAT1
	DB $66;	XOR		AX,AX
	DB $66;	MOV		[WORD PTR DDX],AX
			JMP		@@OK3
@@NONFLAT1:
	DB $66;	MOV		AX,[WORD PTR XX2]
	DB $66;	SUB		AX,[WORD PTR XX1]
	DB $66;	CWD
	DB $66;	DB $0F, $BF, $5E, OFFSET X2
	DB $66;	DB $0F, $BF, $4E, OFFSET X1
	DB $66;	SUB		BX,CX
	DB $66;	IDIV	BX
	DB $66;	MOV		[WORD PTR DDX],AX
@@OK3:

			MOV		AX,[Y1]
			CMP		AX,[Y2]
			JNE		@@NONFLAT2
	DB $66;	XOR		AX,AX
	DB $66;	MOV		[WORD PTR DDY],AX
			JMP		@@OK4
@@NONFLAT2:
	DB $66;	MOV		AX,[WORD PTR YY2]
	DB $66;	SUB		AX,[WORD PTR YY1]
	DB $66;	CWD
	DB $66;	DB $0F, $BF, $5E, OFFSET Y2
	DB $66;	DB $0F, $BF, $4E, OFFSET Y1
	DB $66;	SUB		BX,CX
	DB $66;	IDIV	BX
	DB $66;	MOV		[WORD PTR DDY],AX
@@OK4:

	DB $66;	MOV		AX,[WORD PTR YY1]
	DB $66;	MOV		[WORD PTR CCY],AX

			MOV		AX,[Y1]
			CMP		AX,[ClipY1]
			JGE		@@OK5
			MOV		AX,[ClipY1]
@@OK5:
			MOV		DI,AX
			SHL		DI,6
			SHL		AX,8
			ADD		DI,AX

			XOR		SI,SI

			MOV		AX,[Y1]
			MOV		[Y],AX

			MOV		ES,[VideoSeg]
			MOV		DS,[WORD PTR BitMap+2]

			XOR		BX,BX
			SUB		AX,AX
			MOV		[WORD PTR Ofs3],BX
			MOV		[WORD PTR Ofs3+2],AX
			ADD		AX,[BitMapWidth]
			DEC		AX
			MOV		[WORD PTR Ofs4],BX
			MOV		[WORD PTR Ofs4+2],AX

			MOV		AX,[X1]
			CMP		AX,[X2]
			JNE		@@NONFLAT3
	DB $66;	XOR		AX,AX
			JMP		@@OK8
@@NONFLAT3:
	DB $66;	MOV		AX,[WORD PTR Ofs4]
	DB $66;	SUB		AX,[WORD PTR Ofs3]
	DB $66;	CWD
	DB $66;	DB $0F, $BF, $5E, OFFSET X2
	DB $66;	DB $0F, $BF, $4E, OFFSET X1
	DB $66;	SUB		BX,CX
	DB $66;	IDIV	BX
@@OK8:
	DB $66;	MOV		[WORD PTR DOfs],AX


@@LINELOOP:
			MOV		AX,[WORD PTR CCY+2]
			MUL		[BitMapWidth]
			MOV		SI,AX
			ADD		SI,[WORD PTR BitMap]

			MOV		AX,[Y]
			CMP		AX,[ClipY1]
			JL		@@NEXTLINE
			CMP		AX,[ClipY2]
			JG		@@EXIT

			MOV		[TempDI],DI
			MOV		AX,[X1]
			CMP		AX,[ClipX1]
			JGE		@@OK6
			MOV		AX,[ClipX1]
@@OK6:
			CMP		AX,[ClipX2]
			JLE		@@OK7
			MOV		AX,[ClipX2]
@@OK7:
			ADD		DI,AX

			MOV		CX,[X1]
			MOV		DX,SI
	DB $66;	SHL		DX,Scaler
			MOV		[TempSI],SI
	DB $66;	MOV		SI,[WORD PTR DOfs]
			MOV		BX,[X2]
			CMP		BX,[ClipX2]
			JLE		@@OK8_2
			MOV		BX,[ClipX2]
@@OK8_2:
			MOV		[NewX2],BX
			MOV		AH,[TranspColor]
@@PIXELLOOP:
			CMP		CX,[ClipX1]
			JL		@@NEXTPIXEL

	DB $66;	MOV		BX,DX
	DB $66;	SAR		BX,Scaler
			MOV		AL,[DS:BX]
			CMP		AL,AH
			JE		@@NOTPLOT
			MOV		[ES:DI],AL
@@NOTPLOT:
			INC		DI
@@NEXTPIXEL:
	DB $66;	ADD		DX,SI
			INC		CX
			CMP		CX,[NewX2]
			JLE		@@PIXELLOOP
@@ENDOFLINE:
			MOV		SI,[TempSI]
			MOV		DI,[TempDI]
			ADD		DI,320
@@NEXTLINE:

	DB $66;	MOV		AX,[WORD PTR DDY]
	DB $66;	ADD		[WORD PTR CCY],AX

			INC		[Y]
			MOV		AX,[Y]
			CMP		AX,[Y2]
			JLE		@@LINELOOP
@@EXIT:
			MOV		DS,[TempDS]
End;

Procedure XPutBitMap(X,Y,Width,Height : Integer; BitMap : PChar; VideoSeg : Word); Assembler;
Var
	XX,YY	: Integer;
Asm
			PUSH	DS
			CMP		[Y],199
			JG		@@EXIT
			CMP		[X],319
			JG		@@EXIT
			MOV		AX,[X]
			ADD		AX,[Width]
			CMP		AX,0
			JLE		@@EXIT
			MOV		AX,[Y]
			ADD		AX,[Height]
			CMP		AX,0
			JLE		@@EXIT
			LDS		SI,[DWORD PTR BitMap]
			MOV		ES,[VideoSeg]
			MOV		AX,[Y]
			TEST	AX,AX
			JGE		@@OK1
			XOR		AX,AX
@@OK1:
			MOV		DI,AX
			SHL		AX,8
			SHL		DI,6
			ADD		DI,AX
			MOV		CX,[Height]

			MOV		AX,[Y]
			MOV		[YY],AX
@@LOOP1:
			PUSH	SI
			CMP		[YY],0
			JL		@@NEXTLINE
			PUSH	DI
			PUSH	CX
			MOV		CX,[Width]
			MOV		AX,[X]
			TEST	AX,AX
			JL		@@LESS
			ADD		DI,AX
			JMP		@@OK2
@@LESS:
			SUB		SI,AX
			ADD		CX,AX
			XOR		AX,AX
@@OK2:
			MOV		BX,AX
			ADD		BX,CX
			CMP		BX,319
			JLE		@@OK3
			SUB		BX,320
			SUB		CX,BX
@@OK3:
			CLD
			SHR		CX,1
			DB $0F, $92, $C3			{ SETC BL }
			SHR		CX,1
	DB $66;	REP		MOVSW
			JNC		@@OK4
			MOVSW
@@OK4:
			OR		BL,BL
			JZ		@@ENDOFLINE
			MOVSB
@@ENDOFLINE:
			POP		CX
			POP		DI
			ADD		DI,320
@@NEXTLINE:
			POP		SI
			ADD		SI,[Width]
			INC		[YY]
			CMP		[YY],199
			JG		@@EXIT
			DEC		CX
			JNZ		@@LOOP1
@@EXIT:
			POP		DS
End;

Procedure XPutBitMapClip(X,Y,Width,Height,ClipX1,ClipY1,ClipX2,ClipY2 : Integer; BitMap : PChar; VideoSeg : Word); Assembler;
Var
	XX,YY	: Integer;
Asm
			PUSH	DS

			MOV		AX,[Y]
			CMP		AX,[ClipY2]
			JG		@@EXIT

			MOV		AX,[X]
			CMP		AX,[ClipX2]
			JG		@@EXIT

			MOV		AX,[X]
			ADD		AX,[Width]
			CMP		AX,[ClipX1]
			JLE		@@EXIT

			MOV		AX,[Y]
			ADD		AX,[Height]
			CMP		AX,[ClipY1]
			JLE		@@EXIT

			LDS		SI,[DWORD PTR BitMap]
			MOV		ES,[VideoSeg]
			MOV		AX,[Y]
			CMP		AX,[ClipY1]
			JGE		@@OK1
			MOV		AX,[ClipY1]
@@OK1:
			MOV		DI,AX
			SHL		AX,8
			SHL		DI,6
			ADD		DI,AX
			MOV		CX,[Height]

			MOV		AX,[Y]
			MOV		[YY],AX

			MOV		AX,[ClipX2]
			SUB		AX,[ClipX1]
			MOV		[ClipX2],AX

			MOV		AX,[ClipX1]
			ADD		DI,AX
			SUB		[X],AX
			XOR		AX,AX
			MOV		[ClipX1],AX

@@LOOP1:
			PUSH	SI
			MOV		AX,[YY]
			CMP		AX,[ClipY1]
			JL		@@NEXTLINE
			PUSH	DI
			PUSH	CX
			MOV		CX,[Width]
			MOV		AX,[X]
			CMP		AX,[ClipX1]
			JL		@@LESS
			ADD		DI,AX
			JMP		@@OK2
@@LESS:
			SUB		SI,AX
			ADD		CX,AX
			XOR		AX,AX
@@OK2:
			MOV		BX,AX
			ADD		BX,CX
			CMP		BX,[ClipX2]
			JLE		@@OK3
			SUB		BX,[ClipX2]
			DEC		BX
			SUB		CX,BX
@@OK3:
			CLD
			SHR		CX,1
			DB $0F, $92, $C3			{ SETC BL }
			SHR		CX,1
	DB $66;	REP		MOVSW
			JNC		@@OK4
			MOVSW
@@OK4:
			OR		BL,BL
			JZ		@@ENDOFLINE
			MOVSB
@@ENDOFLINE:
			POP		CX
			POP		DI
			ADD		DI,320
@@NEXTLINE:
			POP		SI
			ADD		SI,[Width]
			INC		[YY]
			MOV		AX,[YY]
			CMP		AX,[ClipY2]
			JG		@@EXIT
			DEC		CX
			JNZ		@@LOOP1
@@EXIT:
			POP		DS
End;

Procedure XPutBitMapTranslate(X,Y,Width,Height : Integer; BitMap : PChar; VideoSeg : Word;
	Var Translate); Assembler;
Var
	XX,YY	: Integer;
Asm
			PUSH	DS
			CMP		[Y],199
			JG		@@EXIT
			CMP		[X],319
			JG		@@EXIT
			MOV		AX,[X]
			ADD		AX,[Width]
			CMP		AX,0
			JLE		@@EXIT
			MOV		AX,[Y]
			ADD		AX,[Height]
			CMP		AX,0
			JLE		@@EXIT
			LDS		SI,[DWORD PTR BitMap]
			MOV		ES,[VideoSeg]
			MOV		AX,[Y]
			TEST	AX,AX
			JGE		@@OK1
			XOR		AX,AX
@@OK1:
			MOV		DI,AX
			SHL		AX,8
			SHL		DI,6
			ADD		DI,AX
			MOV		CX,[Height]

			MOV		AX,[Y]
			MOV		[YY],AX
@@LOOP1:
			PUSH	SI
			CMP		[YY],0
			JL		@@NEXTLINE
			PUSH	DI
			PUSH	CX
			MOV		CX,[Width]
			MOV		AX,[X]
			TEST	AX,AX
			JL		@@LESS
			ADD		DI,AX
			JMP		@@OK2
@@LESS:
			SUB		SI,AX
			ADD		CX,AX
			XOR		AX,AX
@@OK2:
			MOV		BX,AX
			ADD		BX,CX
			CMP		BX,319
			JLE		@@OK3
			SUB		BX,320
			SUB		CX,BX
@@OK3:
			JCXZ	@@ENDOFLINE
@@PIXELLOOP:
			MOV		BL,[DS:SI]
			CMP		BL,DL
			JE		@@NEXTPIXEL
			PUSH	ES
			PUSH	DI
			LES		DI,[DWORD PTR Translate]
			XOR		BH,BH
			MOV		AL,[ES:DI+BX]
			POP		DI
			POP		ES
			MOV		[ES:DI],AL
@@NEXTPIXEL:
			INC		SI
			INC		DI
			DEC		CX
			JNZ		@@PIXELLOOP
@@ENDOFLINE:
			POP		CX
			POP		DI
			ADD		DI,320
@@NEXTLINE:
			POP		SI
			ADD		SI,[Width]
			INC		[YY]
			CMP		[YY],199
			JG		@@EXIT
			DEC		CX
			JNZ		@@LOOP1
@@EXIT:
			POP		DS
End;

Procedure XPutBitMapClipTranslate(X,Y,Width,Height,ClipX1,ClipY1,ClipX2,ClipY2 : Integer;
	BitMap : PChar; VideoSeg : Word; Var Translate); Assembler;
Var
	XX,YY	: Integer;
Asm
			PUSH	DS

			MOV		AX,[Y]
			CMP		AX,[ClipY2]
			JG		@@EXIT

			MOV		AX,[X]
			CMP		AX,[ClipX2]
			JG		@@EXIT

			MOV		AX,[X]
			ADD		AX,[Width]
			CMP		AX,[ClipX1]
			JLE		@@EXIT

			MOV		AX,[Y]
			ADD		AX,[Height]
			CMP		AX,[ClipY1]
			JLE		@@EXIT

			LDS		SI,[DWORD PTR BitMap]
			MOV		ES,[VideoSeg]
			MOV		AX,[Y]
			CMP		AX,[ClipY1]
			JGE		@@OK1
			MOV		AX,[ClipY1]
@@OK1:
			MOV		DI,AX
			SHL		AX,8
			SHL		DI,6
			ADD		DI,AX
			MOV		CX,[Height]

			MOV		AX,[Y]
			MOV		[YY],AX

			MOV		AX,[ClipX2]
			SUB		AX,[ClipX1]
			MOV		[ClipX2],AX

			MOV		AX,[ClipX1]
			ADD		DI,AX
			SUB		[X],AX
			XOR		AX,AX
			MOV		[ClipX1],AX

@@LOOP1:
			PUSH	SI
			MOV		AX,[YY]
			CMP		AX,[ClipY1]
			JL		@@NEXTLINE
			PUSH	DI
			PUSH	CX
			MOV		CX,[Width]
			MOV		AX,[X]
			CMP		AX,[ClipX1]
			JL		@@LESS
			ADD		DI,AX
			JMP		@@OK2
@@LESS:
			SUB		SI,AX
			ADD		CX,AX
			XOR		AX,AX
@@OK2:
			MOV		BX,AX
			ADD		BX,CX
			CMP		BX,[ClipX2]
			JLE		@@OK3
			SUB		BX,[ClipX2]
			DEC		BX
			SUB		CX,BX
@@OK3:
			JCXZ	@@ENDOFLINE
@@PIXELLOOP:
			MOV		BL,[DS:SI]
			PUSH	ES
			PUSH	DI
			LES		DI,[DWORD PTR Translate]
			XOR		BH,BH
			MOV		AL,[ES:DI+BX]
			POP		DI
			POP		ES
			MOV		[ES:DI],AL
@@NEXTPIXEL:
			INC		SI
			INC		DI
			DEC		CX
			JNZ		@@PIXELLOOP
@@ENDOFLINE:
			POP		CX
			POP		DI
			ADD		DI,320
@@NEXTLINE:
			POP		SI
			ADD		SI,[Width]
			INC		[YY]
			MOV		AX,[YY]
			CMP		AX,[ClipY2]
			JG		@@EXIT
			DEC		CX
			JNZ		@@LOOP1
@@EXIT:
			POP		DS
End;

Procedure XPutTransparentBitMap(X,Y,Width,Height : Integer; BitMap : PChar;
	TranspColor : Byte; VideoSeg : Word); Assembler;
Var
	XX,YY	: Integer;
Asm
			PUSH	DS
			MOV		DL,[TranspColor]
			CMP		[Y],199
			JG		@@EXIT
			CMP		[X],319
			JG		@@EXIT
			MOV		AX,[X]
			ADD		AX,[Width]
			CMP		AX,0
			JLE		@@EXIT
			MOV		AX,[Y]
			ADD		AX,[Height]
			CMP		AX,0
			JLE		@@EXIT
			LDS		SI,[DWORD PTR BitMap]
			MOV		ES,[VideoSeg]
			MOV		AX,[Y]
			TEST	AX,AX
			JGE		@@OK1
			XOR		AX,AX
@@OK1:
			MOV		DI,AX
			SHL		AX,8
			SHL		DI,6
			ADD		DI,AX
			MOV		CX,[Height]

			MOV		AX,[Y]
			MOV		[YY],AX
@@LOOP1:
			PUSH	SI
			CMP		[YY],0
			JL		@@NEXTLINE
			PUSH	DI
			PUSH	CX
			MOV		CX,[Width]
			MOV		AX,[X]
			TEST	AX,AX
			JL		@@LESS
			ADD		DI,AX
			JMP		@@OK2
@@LESS:
			SUB		SI,AX
			ADD		CX,AX
			XOR		AX,AX
@@OK2:
			MOV		BX,AX
			ADD		BX,CX
			CMP		BX,319
			JLE		@@OK3
			SUB		BX,320
			SUB		CX,BX
@@OK3:
			JCXZ	@@ENDOFLINE
@@PIXELLOOP:
			MOV		AL,[DS:SI]
			CMP		AL,DL
			JE		@@NEXTPIXEL
			MOV		[ES:DI],AL
@@NEXTPIXEL:
			INC		SI
			INC		DI
			DEC		CX
			JNZ		@@PIXELLOOP
@@ENDOFLINE:
			POP		CX
			POP		DI
			ADD		DI,320
@@NEXTLINE:
			POP		SI
			ADD		SI,[Width]
			INC		[YY]
			CMP		[YY],199
			JG		@@EXIT
			DEC		CX
			JNZ		@@LOOP1
@@EXIT:
			POP		DS
End;

Procedure XPutTransparentBitMapClip(X,Y,Width,Height,ClipX1,ClipY1,ClipX2,
	ClipY2 : Integer; BitMap : PChar; TranspColor : Byte; VideoSeg : Word); Assembler;
Var
	XX,YY	: Integer;
Asm
			PUSH	DS
			MOV		DL,[TranspColor]

			MOV		AX,[Y]
			CMP		AX,[ClipY2]
			JG		@@EXIT

			MOV		AX,[X]
			CMP		AX,[ClipX2]
			JG		@@EXIT

			MOV		AX,[X]
			ADD		AX,[Width]
			CMP		AX,[ClipX1]
			JLE		@@EXIT

			MOV		AX,[Y]
			ADD		AX,[Height]
			CMP		AX,[ClipY1]
			JLE		@@EXIT

			LDS		SI,[DWORD PTR BitMap]
			MOV		ES,[VideoSeg]
			MOV		AX,[Y]
			CMP		AX,[ClipY1]
			JGE		@@OK1
			MOV		AX,[ClipY1]
@@OK1:
			MOV		DI,AX
			SHL		AX,8
			SHL		DI,6
			ADD		DI,AX
			MOV		CX,[Height]

			MOV		AX,[Y]
			MOV		[YY],AX

			MOV		AX,[ClipX2]
			SUB		AX,[ClipX1]
			MOV		[ClipX2],AX

			MOV		AX,[ClipX1]
			ADD		DI,AX
			SUB		[X],AX
			XOR		AX,AX
			MOV		[ClipX1],AX

@@LOOP1:
			PUSH	SI
			MOV		AX,[YY]
			CMP		AX,[ClipY1]
			JL		@@NEXTLINE
			PUSH	DI
			PUSH	CX
			MOV		CX,[Width]
			MOV		AX,[X]
			CMP		AX,[ClipX1]
			JL		@@LESS
			ADD		DI,AX
			JMP		@@OK2
@@LESS:
			SUB		SI,AX
			ADD		CX,AX
			XOR		AX,AX
@@OK2:
			MOV		BX,AX
			ADD		BX,CX
			CMP		BX,[ClipX2]
			JLE		@@OK3
			SUB		BX,[ClipX2]
			DEC		BX
			SUB		CX,BX
@@OK3:
			JCXZ	@@ENDOFLINE
@@PIXELLOOP:
			MOV		AL,[DS:SI]
			CMP		AL,DL
			JE		@@NEXTPIXEL
			MOV		[ES:DI],AL
@@NEXTPIXEL:
			INC		SI
			INC		DI
			DEC		CX
			JNZ		@@PIXELLOOP
@@ENDOFLINE:
			POP		CX
			POP		DI
			ADD		DI,320
@@NEXTLINE:
			POP		SI
			ADD		SI,[Width]
			INC		[YY]
			MOV		AX,[YY]
			CMP		AX,[ClipY2]
			JG		@@EXIT
			DEC		CX
			JNZ		@@LOOP1
@@EXIT:
			POP		DS
End;

Procedure XPutTransparentBitMapTranslate(X,Y,Width,Height : Integer; BitMap : PChar;
	TranspColor : Byte; VideoSeg : Word; Var Translate); Assembler;
Var
	XX,YY	: Integer;
Asm
			PUSH	DS
			MOV		DL,[TranspColor]
			CMP		[Y],199
			JG		@@EXIT
			CMP		[X],319
			JG		@@EXIT
			MOV		AX,[X]
			ADD		AX,[Width]
			CMP		AX,0
			JLE		@@EXIT
			MOV		AX,[Y]
			ADD		AX,[Height]
			CMP		AX,0
			JLE		@@EXIT
			LDS		SI,[DWORD PTR BitMap]
			MOV		ES,[VideoSeg]
			MOV		AX,[Y]
			TEST	AX,AX
			JGE		@@OK1
			XOR		AX,AX
@@OK1:
			MOV		DI,AX
			SHL		AX,8
			SHL		DI,6
			ADD		DI,AX
			MOV		CX,[Height]

			MOV		AX,[Y]
			MOV		[YY],AX
@@LOOP1:
			PUSH	SI
			CMP		[YY],0
			JL		@@NEXTLINE
			PUSH	DI
			PUSH	CX
			MOV		CX,[Width]
			MOV		AX,[X]
			TEST	AX,AX
			JL		@@LESS
			ADD		DI,AX
			JMP		@@OK2
@@LESS:
			SUB		SI,AX
			ADD		CX,AX
			XOR		AX,AX
@@OK2:
			MOV		BX,AX
			ADD		BX,CX
			CMP		BX,319
			JLE		@@OK3
			SUB		BX,320
			SUB		CX,BX
@@OK3:
			JCXZ	@@ENDOFLINE
@@PIXELLOOP:
			MOV		BL,[DS:SI]
			CMP		BL,DL
			JE		@@NEXTPIXEL
			PUSH	ES
			PUSH	DI
			LES		DI,[DWORD PTR Translate]
			XOR		BH,BH
			MOV		AL,[ES:DI+BX]
			POP		DI
			POP		ES
			MOV		[ES:DI],AL
@@NEXTPIXEL:
			INC		SI
			INC		DI
			DEC		CX
			JNZ		@@PIXELLOOP
@@ENDOFLINE:
			POP		CX
			POP		DI
			ADD		DI,320
@@NEXTLINE:
			POP		SI
			ADD		SI,[Width]
			INC		[YY]
			CMP		[YY],199
			JG		@@EXIT
			DEC		CX
			JNZ		@@LOOP1
@@EXIT:
			POP		DS
End;

Procedure XPutTransparentBitMapClipTranslate(X,Y,Width,Height,ClipX1,ClipY1,ClipX2,
	ClipY2 : Integer; BitMap : PChar; TranspColor : Byte; VideoSeg : Word;
	Var Translate); Assembler;
Var
	XX,YY	: Integer;
Asm
			PUSH	DS
			MOV		DL,[TranspColor]

			MOV		AX,[Y]
			CMP		AX,[ClipY2]
			JG		@@EXIT

			MOV		AX,[X]
			CMP		AX,[ClipX2]
			JG		@@EXIT

			MOV		AX,[X]
			ADD		AX,[Width]
			CMP		AX,[ClipX1]
			JLE		@@EXIT

			MOV		AX,[Y]
			ADD		AX,[Height]
			CMP		AX,[ClipY1]
			JLE		@@EXIT

			LDS		SI,[DWORD PTR BitMap]
			MOV		ES,[VideoSeg]
			MOV		AX,[Y]
			CMP		AX,[ClipY1]
			JGE		@@OK1
			MOV		AX,[ClipY1]
@@OK1:
			MOV		DI,AX
			SHL		AX,8
			SHL		DI,6
			ADD		DI,AX
			MOV		CX,[Height]

			MOV		AX,[Y]
			MOV		[YY],AX

			MOV		AX,[ClipX2]
			SUB		AX,[ClipX1]
			MOV		[ClipX2],AX

			MOV		AX,[ClipX1]
			ADD		DI,AX
			SUB		[X],AX
			XOR		AX,AX
			MOV		[ClipX1],AX

@@LOOP1:
			PUSH	SI
			MOV		AX,[YY]
			CMP		AX,[ClipY1]
			JL		@@NEXTLINE
			PUSH	DI
			PUSH	CX
			MOV		CX,[Width]
			MOV		AX,[X]
			CMP		AX,[ClipX1]
			JL		@@LESS
			ADD		DI,AX
			JMP		@@OK2
@@LESS:
			SUB		SI,AX
			ADD		CX,AX
			XOR		AX,AX
@@OK2:
			MOV		BX,AX
			ADD		BX,CX
			CMP		BX,[ClipX2]
			JLE		@@OK3
			SUB		BX,[ClipX2]
			DEC		BX
			SUB		CX,BX
@@OK3:
			JCXZ	@@ENDOFLINE
@@PIXELLOOP:
			MOV		BL,[DS:SI]
			CMP		BL,DL
			JE		@@NEXTPIXEL
			PUSH	ES
			PUSH	DI
			LES		DI,[DWORD PTR Translate]
			XOR		BH,BH
			MOV		AL,[ES:DI+BX]
			POP		DI
			POP		ES
			MOV		[ES:DI],AL
@@NEXTPIXEL:
			INC		SI
			INC		DI
			DEC		CX
			JNZ		@@PIXELLOOP
@@ENDOFLINE:
			POP		CX
			POP		DI
			ADD		DI,320
@@NEXTLINE:
			POP		SI
			ADD		SI,[Width]
			INC		[YY]
			MOV		AX,[YY]
			CMP		AX,[ClipY2]
			JG		@@EXIT
			DEC		CX
			JNZ		@@LOOP1
@@EXIT:
			POP		DS
End;

Procedure XGetBitMap(X1,Y1,X2,Y2 : Integer; Var BitMap; VideoSeg : Word);
Var
	X,Y	: Integer;
	P	: PChar;
Begin
	P:=@BitMap;
	For Y:=Y1 To Y2 Do
		For X:=X1 To X2 Do Begin
			P^:=Chr(XGetPixel(X,Y,VideoSeg));
			Inc(P);
		End;
End;

Function AllocMem(Size : Word) : Pointer;
Const
	OldMem	: Pointer	= NIL;
	OldSize	: Word		= 0;
Begin
	If OldMem<>NIL Then
		FreeMem(OldMem,OldSize);
	OldSize:=Size;
	If Size=0 Then
		OldMem:=NIL
	Else
		GetMem(OldMem,Size);
	AllocMem:=OldMem;
End;

Procedure XFillPoly(Var Lines : Array Of TLine32; LineCount : Word; Color : Byte; VideoSeg : Word); Assembler;
Var
	Y1,Y2,Y		: Integer;
	X1,X2		: Integer;
	XMin,XMax	: Integer;
	Temp		: Pointer;
Asm
			CMP		[LineCount],0
			JE		@@EXIT
			LES		DI,[DWORD PTR Lines]
			MOV		AX,[(TLine32 PTR ES:DI).Y1]
			MOV		[Y1],AX
			MOV		[Y2],AX
			MOV		AX,[(TLine32 PTR ES:DI).X1]
			MOV		[X1],AX
			MOV		[X2],AX

			MOV		CX,[LineCount]
@@MINMAXLOOP:
			MOV		AX,[(TLine32 PTR ES:DI).Y1]
			CMP		[Y1],AX
			JLE		@@OK1
			MOV		[Y1],AX
@@OK1:
			CMP		[Y2],AX
			JGE		@@OK2
			MOV		[Y2],AX
@@OK2:
			MOV		AX,[(TLine32 PTR ES:DI).Y2]
			CMP		[Y1],AX
			JLE		@@OK3
			MOV		[Y1],AX
@@OK3:
			CMP		[Y2],AX
			JGE		@@OK4
			MOV		[Y2],AX
@@OK4:
			MOV		AX,[(TLine32 PTR ES:DI).X1]
			CMP		[X1],AX
			JLE		@@OK5
			MOV		[X1],AX
@@OK5:
			CMP		[X2],AX
			JGE		@@OK6
			MOV		[X2],AX
@@OK6:
			MOV		AX,[(TLine32 PTR ES:DI).X2]
			CMP		[X1],AX
			JLE		@@OK7
			MOV		[X1],AX
@@OK7:
			CMP		[X2],AX
			JGE		@@NEXTLINE
			MOV		[X2],AX
@@NEXTLINE:
			ADD		DI,TYPE TLine32
			DEC		CX
			JNZ		@@MINMAXLOOP

			MOV		AX,[X2]
			SUB		AX,[X1]
			INC		AX
			PUSH	AX
			CALL	AllocMem
			MOV		[WORD PTR Temp],AX
			MOV		[WORD PTR Temp+2],DX

			LES		DI,[DWORD PTR Lines]
			MOV		CX,[LineCount]
@@SWAPLOOP:
			PUSH	CX
			MOV		AX,[(TLine32 PTR ES:DI).Y1]
			CMP		AX,[(TLine32 PTR ES:DI).Y2]
			JE		@@NEXTLINE2
			JL		@@CALCSLOPE
			XCHG	AX,[(TLine32 PTR ES:DI).Y2]
			MOV		[(TLine32 PTR ES:DI).Y1],AX

			MOV		AX,[(TLine32 PTR ES:DI).X1]
			XCHG	AX,[(TLine32 PTR ES:DI).X2]
			MOV		[(TLine32 PTR ES:DI).X1],AX
@@CALCSLOPE:
			MOV		AX,[(TLine32 PTR ES:DI).X1]
			MOV		[WORD PTR (TLine32 PTR ES:DI).IX],$0000
			MOV		[WORD PTR (TLine32 PTR ES:DI).IX+2],AX

			MOV		AX,[(TLine32 PTR ES:DI).X2]
			SUB		AX,[(TLine32 PTR ES:DI).X1]
	DB $66;	SAL		AX,16
	DB $66;	CWD

			MOV		BX,[(TLine32 PTR ES:DI).Y2]
			SUB		BX,[(TLine32 PTR ES:DI).Y1]
	DB $66, $0F, $BF, $CB				{ MOVSX ECX,BX }
	DB $66;	IDIV	CX
	DB $66;	MOV		[WORD PTR (TLine32 PTR ES:DI).GX],AX
@@NEXTLINE2:
			POP		CX
			ADD		DI,TYPE TLine32
			DEC		CX
			JNZ		@@SWAPLOOP

			MOV		AX,[Y1]
			MOV		[Y],AX
@@LINELOOP:
			MOV		AX,[Y]
			CMP		AX,0
			JL		@@NOLINE
			CMP		AX,199
			JG		@@EXIT

			MOV		BL,1
			LES		DI,[DWORD PTR Lines]
			MOV		CX,[LineCount]
@@MINMAXLOOP2:
			MOV		AX,[(TLine32 PTR ES:DI).Y1]
			CMP		AX,[(TLine32 PTR ES:DI).Y2]
			JE		@@SKIP1
			MOV		AX,[Y]
			CMP		AX,[(TLine32 PTR ES:DI).Y1]
			JL		@@SKIP1
			CMP		AX,[(TLine32 PTR ES:DI).Y2]
			JG		@@SKIP1
	DB $66;	MOV		AX,[WORD PTR (TLine32 PTR ES:DI).IX]
	DB $66;	SAR		AX,16
			ADC		AX,$0000
			TEST	BL,BL
			JZ		@@NOTFIRST
			SUB		BL,BL
			MOV		[XMin],AX
			MOV		[XMax],AX
			JMP		@@SKIP1
@@NOTFIRST:
			CMP		AX,[XMin]
			JGE		@@NOTMIN
			MOV		[XMin],AX
@@NOTMIN:
			CMP		AX,[XMax]
			JLE		@@SKIP1
			MOV		[XMax],AX
@@SKIP1:
			ADD		DI,TYPE TLine32
			DEC		CX
			JNZ		@@MINMAXLOOP2

			CMP		[XMax],0
			JL		@@NOLINE
			CMP		[XMin],319
			JG		@@NOLINE

			LES		DI,[DWORD PTR Temp]
	DB $66;	XOR		AX,AX
			MOV		CX,XMax
			SUB		CX,XMin
			ADD		CX,3
			SHR		CX,1
			DB $0F, $92, $C3			{ SETC BL }
			SHR		CX,1
	DB $66;	REP		STOSW
			JNC		@@SKIP2
			STOSW
@@SKIP2:
			OR		BL,BL
			JZ		@@SKIP3
			STOSB
@@SKIP3:

			PUSH	DS
			LDS		SI,[DWORD PTR Temp]
			LES		DI,[DWORD PTR Lines]
			MOV		CX,[LineCount]
@@INTERSECTLOOP:
			MOV		AX,[(TLine32 PTR ES:DI).Y1]
			CMP		AX,[(TLine32 PTR ES:DI).Y2]
			JE		@@SKIP4
			MOV		AX,[Y]
			CMP		AX,[(TLine32 PTR ES:DI).Y1]
			JL		@@SKIP4
			CMP		AX,[(TLine32 PTR ES:DI).Y2]
			JGE		@@SKIP4
	DB $66;	MOV		BX,[WORD PTR (TLine32 PTR ES:DI).IX]
	DB $66;	SAR		BX,16
			ADC		BX,$0000
			SUB		BX,[XMin]
			MOV		AL,[DS:SI+BX+$0001]
			XOR		AL,$01
			OR		AL,$02
			MOV		[DS:SI+BX+$0001],AL
@@SKIP4:
			ADD		DI,TYPE TLine32
			DEC		CX
			JNZ		@@INTERSECTLOOP
			POP		DS

			PUSH	DS

			MOV		BL,FALSE

			LDS		SI,[DWORD PTR Temp]

			MOV		ES,[VideoSeg]
			MOV		DI,[Y]
			MOV		AX,DI
			SHL		AX,6
			SHL		DI,8
			ADD		DI,AX

			MOV		AL,[Color]

			DEC		[XMin]
			INC		[XMax]
			MOV		DX,[XMin]
			CMP		DX,0
			JL		@@OK8
			ADD		DI,DX
@@OK8:
			MOV		CX,[XMax]
			SUB		CX,[XMin]
			INC		CX
@@PLOTLOOP:
			MOV		BH,BL
			TEST	[BYTE PTR DS:SI],1
			JZ		@@SKIP5
			XOR		BH,$01
			JZ		@@SKIP5
			MOV		BL,BH
@@SKIP5:
			CMP		DX,0
			JL		@@SKIP6
			CMP		DX,319
			JG		@@SKIP6
			TEST	[BYTE PTR DS:SI],2
			JNZ		@@DOPLOT
			TEST	BL,1
			JZ		@@SKIP6
@@DOPLOT:
			MOV		[ES:DI],AL
@@SKIP6:
			CMP		DX,0
			JL		@@SKIP7
			INC		DI
@@SKIP7:
			INC		DX
			CMP		DX,319
			JG		@@ENDOFLINE
			INC		SI
			MOV		BL,BH
			DEC		CX
			JNZ		@@PLOTLOOP
@@ENDOFLINE:
			POP		DS
@@NOLINE:

			LES		DI,[DWORD PTR Lines]
			MOV		CX,[LineCount]
@@ADJUSTLOOP:
			MOV		AX,[(TLine32 PTR ES:DI).Y1]
			CMP		AX,[(TLine32 PTR ES:DI).Y2]
			JE		@@NOADJUST
			MOV		AX,[Y]
			CMP		AX,[(TLine32 PTR ES:DI).Y1]
			JL		@@NOADJUST
			CMP		AX,[(TLine32 PTR ES:DI).Y2]
			JG		@@NOADJUST
	DB $66;	MOV		AX,[WORD PTR (TLine32 PTR ES:DI).GX]
	DB $66;	ADD		[WORD PTR (TLine32 PTR ES:DI).IX],AX
@@NOADJUST:
			ADD		DI,TYPE TLine32
			DEC		CX
			JNZ		@@ADJUSTLOOP

			INC		[Y]
			JMP		@@LINELOOP
@@EXIT:
			PUSH	$0000
			CALL	AllocMem
End;

Procedure XSirds(SourceSeg,DestSeg : Word; Levels : Byte; Color1,Color2 : Byte); Assembler;
Var
	P1		: ^Byte;
	P2		: ^Byte;
	Level	: Byte;
	Pattern	: Array[0..511] Of Char;
	I		: Word;
Const
	Seed	: Word	= $F19B;

	Function RandomBit : Byte; Assembler;
	Asm
		PUSH	DX
		PUSH	BX
		MOV		AX,[Seed]
		MOV		DX,AX
		SHR		DX,12
		MOV		BX,AX
		SHR		BX,8
		XOR		DX,BX
		MOV		BX,AX
		SHR		BX,4
		XOR		DX,BX
		MOV		BX,AX
		SHR		BX,1
		XOR		DX,BX
		RCR		DX,1
		RCL		AX,1
		MOV		[Seed],AX
		AND		AX,$0001
		INC		AL
		POP		BX
		POP		DX
	End;

Asm
	MOV		AX,[SourceSeg]
	XOR		BX,BX
	MOV		[WORD PTR P1],BX
	MOV		[WORD PTR P1+2],AX
	MOV		[WORD PTR P2],BX
	MOV		AX,[DestSeg]
	MOV		[WORD PTR P2+2],AX
	LEA		DI,[Pattern]
	MOV		CX,TYPE Pattern
@@LOOP1:
	MOV		[BYTE PTR SS:DI],0
	INC		DI
	DEC		CX
	JNZ		@@LOOP1

	MOV		[I],0
	MOV		CX,200
@@LINE_LOOP:
	PUSH	CX
	LEA		DI,[Pattern]
	MOV		CL,[Levels]
@@LOOP2:
	PUSH	CX
	PUSH	DI
	PUSH	BP
	CALL	RandomBit
	POP		DI
	POP		CX
	MOV		[SS:DI],AL
	INC		DI
	DEC		CL
	JNZ		@@LOOP2
	MOV		[BYTE PTR SS:DI],0

	MOV		[Level],0
	MOV		CX,320
@@PIXEL_LOOP:
	PUSH	CX
	LES		DI,[DWORD PTR P1]
	INC		[WORD PTR P1]
	MOV		AH,[ES:DI]

	CMP		AH,[Level]
	JA		@@ABOVE
	JB		@@BELOWE
	MOV		AL,AH
	JMP		@@SAME
@@BELOWE:
	MOV		AL,[Level]
@@LOOP3:
	CMP		AL,AH		{ CMP Level,V }
	JBE		@@SKIP4
	DEC		AL
	LEA		DI,[Pattern]
	ADD		DI,[I]
	MOV		SI,DI
@@LOOP5:
	CMP		[BYTE PTR SS:SI],0
	JE		@@OK5
	INC		SI
	JMP		@@LOOP5
@@OK5:
	INC		SI
@@LOOP4:
	MOV		DL,[SS:SI-1]
	MOV		[SS:SI],DL
	DEC		SI
	CMP		SI,DI
	JA		@@LOOP4
	LEA		DI,[Pattern]
	ADD		DI,[I]
	PUSH	AX
	PUSH	CX
	PUSH	DI
	PUSH	SI
	PUSH	BP
	CALL	RandomBit
	POP		SI
	POP		DI
	POP		CX
	MOV		[SS:DI],AL
	POP		AX
	JMP		@@LOOP3
@@SKIP4:
	JMP		@@SAME

@@ABOVE:
	MOV		AL,[Level]
@@LOOP3_2:
	CMP		AL,AH		{ CMP Level,V }
	JAE		@@SAME
	INC		AL
	LEA		DI,[Pattern]
	ADD		DI,[I]
@@LOOP4_2:
	MOV		DL,[SS:DI+1]
	MOV		[SS:DI],DL
	INC		DI
	TEST	DL,DL
	JNZ		@@LOOP4_2
	LEA		DI,[Pattern]
	ADD		DI,[I]
	CMP		[BYTE PTR SS:DI],0
	JNE		@@LOOP3_2
	MOV		[I],0
	JMP		@@LOOP3_2
@@SAME:
	MOV		[Level],AL

	LES		DI,[DWORD PTR P2]
	LEA		SI,[Pattern]
	ADD		SI,[I]
	CMP		[BYTE PTR SS:SI],1
	JNE		@@SET_IT
@@CLEAR_IT:
	MOV		AL,[Color1]
	JMP		@@GO_ON
@@SET_IT:
	MOV		AL,[Color2]
@@GO_ON:
	MOV		[ES:DI],AL
	INC		[WORD PTR P2]
	INC		[I]
	CMP		[BYTE PTR SS:SI+1],0
	JNE		@@OK
	MOV		[I],0
@@OK:
@@NEXT_PIXEL:
	POP		CX
	DEC		CX
	JNZ		@@PIXEL_LOOP
@@NEXT_LINE:
	POP		CX
	DEC		CX
	JNZ		@@LINE_LOOP
End;

End.
