//
//  ! ! ! ! ! W I N D O W S  S U C K S ! ! ! ! ! ! ! ! ! ! !
//

unit spedit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Buttons, Spin;

type
  Teform = class(TForm)
    Bevel1: TBevel;
    box: TPaintBox;
    hbar: TScrollBar;
    vbar: TScrollBar;
    cbgrid: TCheckBox;
    palbox: TPaintBox;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    cbzero: TCheckBox;
    SEframe: TSpinEdit;
    Label1: TLabel;
    SBnewframe: TBitBtn;
    SBcopyf: TBitBtn;
    SBpastef: TBitBtn;
    Label2: TLabel;
    Lnf: TStaticText;
    Bevel2: TBevel;
    Tpen: TSpeedButton;
    Tpaint: TSpeedButton;
    cbloop: TCheckBox;
    zbar: TScrollBar;
    Label3: TLabel;
    Bevel3: TBevel;
    SBappend: TBitBtn;
    Bevel4: TBevel;
    SBflipLR: TBitBtn;
    Bevel5: TBevel;
    SBload: TSpeedButton;
    SBsave: TSpeedButton;
    loaddia: TOpenDialog;
    savedia: TSaveDialog;
    SBloadappend: TSpeedButton;
    fbox: TPaintBox;
    fbar: TScrollBar;
    SBdelete: TBitBtn;
    procedure drawbox;
    procedure drawfbox;

    procedure init(frame : boolean);

    procedure savegraphic(name : string);
    procedure loadgraphic(name : string; newframe : boolean);

    procedure paint(x, y : word; c : byte; fillall : boolean);

    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure boxPaint(Sender: TObject);
    procedure boxMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure boxMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure drawpal(Sender: TObject);
    procedure palboxMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure palboxMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure Ffunc(Sender: TObject);
    procedure FormMouseWheel(Sender: TObject; Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure zbarChange(Sender: TObject);
    procedure fboxPaint(Sender: TObject);
    procedure fboxMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private

  public
    boxbuf, palbuf, fbuf : tbitmap;
    zo : byte;

    sprite : array[0..64535] of byte;
    spclip : array[0..64535] of byte;
    sx, sy, bx, by : word;
    sf, cf : byte;

    vs : byte;  // visible sprites in sbox
    fo : byte;  // offset in sbox

    sel : array[1..2] of byte;
  end;

const sps=32;   // max sprite size in sbox

var eform: Teform;

implementation
{$R *.dfm}
uses graphtools, mainform;




procedure teform.savegraphic(name : string);
var ex : string;
    f : file;
begin
 ex := extractfileext(name);
 ex := ex[1]+upcase(ex[2])+upcase(ex[3])+upcase(ex[4]);

 if ex='.JRB' then begin
   assignfile(f, name);
   {$i-}
   rewrite(f, 1);
   blockwrite(f, sx, 2);
   blockwrite(f, sy, 2);
   blockwrite(f, sf, 2);
   blockwrite(f, sprite[0], sx*sy*sf);
   closefile(f);
   {$i+}
   if ioresult=0 then showmessage('saved '+name);
 end;


 drawbox;
end;

procedure teform.loadgraphic(name : string; newframe : boolean);
var ex : string;
    f : file;
    buf : tbitmap;
    i, j : word;
    hpal : hpalette;
    sx1, sy1, sf1 : word;
begin
 ex := extractfileext(name);
 ex := ex[1]+upcase(ex[2])+upcase(ex[3])+upcase(ex[4]);

 if ex='.JRB' then begin
   assignfile(f, name);
   {$i-}
   reset(f, 1);
   if newframe then begin
    blockread(f, sx1, 2);
    blockread(f, sy1, 2);
    blockread(f, sf1, 2);
    blockread(f, sprite[cf*sx*sy], sx*sy);
   end else begin
    blockread(f, sx, 2);
    blockread(f, sy, 2);
    blockread(f, sf, 2);
    blockread(f, sprite[0], sx*sy*sf);
    closefile(f);
   end;
   {$i+}
 end;
 if ex='.BMP' then begin
   buf := tbitmap.create;
   buf.loadfromfile(name);
   buf.pixelformat := pf32bit;
   if (buf.width>0) and (buf.height>0) then begin
    if newframe then begin
     with buf.canvas do
     for j := 0 to sy-1 do for i := 0 to sx-1 do begin
      sprite[cf*sx*sy+j*sx+i] := findpalcolor(swapRB(pixels[i, j]), dostrans);
     end;
    end else begin
     sx := limit(buf.width,160);
     sy := limit(buf.height,100);
     sf := 1;
     with buf.canvas do
     for j := 0 to sy-1 do for i := 0 to sx-1 do begin
      sprite[j*sx+i] := findpalcolor(swapRB(pixels[i, j]), dostrans);
     end;
    end;
   end else showmessage('NOT loaded '+name);
   buf.free;
 end;
 init(true);
 drawbox;
end;









procedure Teform.FormCreate(Sender: TObject);
var x, y : word;
begin
 getbuffer(boxbuf, box,0);
 getbuffer(palbuf, palbox,0);
 getbuffer(fbuf, fbox,0);
 zo := 10;
 sel[1] := 15;
 sel[2] := 0;
 // create palbuf:
 with palbuf.canvas do begin
  brush.color := clBlack;
  fillrect(getrect(0, 0, palbuf.width, palbuf.height));
  for y := 0 to 15 do for x := 0 to 15 do begin
   brush.color := swapRB(dostrans[y*16+x]);
   fillrect(getrect(x*10+1,y*10+1, x*10+9, y*10+9));
  end;
 end;
end;



procedure Teform.FormDestroy(Sender: TObject);
begin
 fbuf.free;
 palbuf.free;
 boxbuf.free;
end;

procedure teform.init(frame : boolean);
begin
 bx := limit(box.width div zo, sx);
 by := limit(box.height div zo, sy);
 vs := fbox.width div sps;
 fo := 0;
 fbar.max := limitz(sf-vs, 0);
 hbar.min := 0;
 hbar.position := 0;
 hbar.max := limitz(sx-bx, 0);
 vbar.min := 0;
 vbar.position := 0;
 vbar.max := limitz(sy-by, 0);
 if frame then begin
  cf := 0;
  SEframe.value := cf;
  fbar.position := 0;
 end;
 caption := 'sprite '+inttostr(sx)+'x'+inttostr(sy);
 drawbox;
end;

procedure teform.drawbox;
var x, y, fo, by1, bx1 : word;
    z1, z2, c, i : byte;
    zero : boolean;
begin
 SEframe.maxvalue := sf-1;
 Lnf.caption := inttostr(sf-1);
 cf := SEframe.value;
 zero := not cbzero.checked;
 if cbloop.checked then begin
   bx1 := bx*3;
   by1 := by*3;
 end else begin
   bx1 := bx;
   by1 := by;
 end;
 if cbgrid.checked then begin
  z1 := 1; z2 := 2 end
 else begin z1 := 0; z2 := 0; end;
 with boxbuf.canvas do begin
  brush.color := clGray; //tbrushstyle
  brush.style := bsdiagcross;//bsBDiagonal;
  fillrect(getrect(0, 0, box.width, box.height));
  brush.style := bssolid;
  fo := sx*sy*cf;
  for y := 0 to by1-1 do for x := 0 to bx1-1 do begin
   c := sprite[fo+((y mod by)+vbar.position)*sx+(x mod bx)+hbar.position];
   if (c<>0)or zero then begin
    brush.color := swapRB(dostrans[c]);
    fillrect(getrect(x*zo+z1, y*zo+z1, x*zo+zo-z2, y*zo+zo-z2));
   end;
  end;
 end;
 box.canvas.draw(0, 0, boxbuf);
end;

procedure Teform.boxPaint(Sender: TObject);
begin
 drawbox;
 drawfbox;
end;

procedure Teform.boxMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
 if button=mbleft then boxmousemove(sender, [ssleft] + shift, x, y);
 if button=mbright then boxmousemove(sender, [ssright] + shift, x, y);
end;

procedure Teform.boxMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
var b, loop : byte;
begin
 if ssleft in shift then b := 1 else
 if ssright in shift then b := 2 else
  exit;
 if (x<0) or (y<0) then exit;
 x := x div zo + hbar.position; y := y div zo + vbar.position;
 if cbloop.checked then loop:=3 else loop:= 1;
 if (x>=sx*loop) or (y>=sy*loop) then exit;
 if Tpen.down then sprite[cf*sx*sy+(y mod sy)*sx+(x mod sx)] := sel[b]
  else
 if Tpaint.down then paint((x mod sx), (y mod sy), sel[b], ssShift in Shift);
 drawbox;
end;

procedure teform.paint(x, y : word; c : byte; fillall : boolean);
// paint-algorithm.
// !!very slow!! but at least doesnt trash the stack
// works through growing the sourcepoint into all
// directions. painting with color 255 is forbidden
// cause the algorithm needs a non-used temporary color,
// else some not connected areas may be painted too.
const tempcol:byte=255;
var i, j, k, pos, fp : word;
    co : byte;
begin
 fp := sx*sy*cf;
 pos := fp+y*sx+x;
 co := sprite[pos]; sprite[pos] := tempcol;
 if fillall then begin
  // just replace all matching colors, connectd or not.
  // used, when shift is pressed.
  for j := 0 to sy-1 do for i := 0 to sx-1 do begin
   pos := fp+j*sx+i;
   if (sprite[pos]=co) then sprite[pos] := tempcol;
  end;
 end else
 for k := 0 to sx*sy shl 1 do // max iterations
 // mostly it dont needs that much, just to be sure.
 // the worst case, in my opinion, would be a spiral
 // over the whole picture which is solved in max. sx*sy/2 steps.
 for j := 0 to sy-1 do for i := 0 to sx-1 do begin
  if (sprite[fp+j*sx+i]=tempcol) then begin
   if (j>0) then begin
    pos := fp+(j-1)*sx+i; if sprite[pos]=co then sprite[pos] := tempcol;
   end;
   if (j<sy-1) then begin
    pos := fp+(j+1)*sx+i; if sprite[pos]=co then sprite[pos] := tempcol;
   end;
   if (i>0) then begin
    pos := fp+j*sx+i-1; if sprite[pos]=co then sprite[pos] := tempcol;
   end;
   if (i<sx-1) then begin
    pos := fp+j*sx+i+1; if sprite[pos]=co then sprite[pos] := tempcol;
   end;
  end;
 end;

 for i := 0 to sx*sy-1 do begin
  pos := fp+i;
  if sprite[pos]=tempcol then sprite[pos] := c;
 end; 

end;




procedure Teform.drawpal(Sender: TObject);
var x, y : word;
begin
 with palbox.canvas do begin
  draw(0, 0, palbuf);
  brush.color := clred;
  x := (sel[1] mod 16)*10; y := (sel[1] div 16)*10;
  framerect(getrect(x, y, x+10, y+10));
  brush.color := clblue;
  x := (sel[2] mod 16)*10; y := (sel[2] div 16)*10;
  framerect(getrect(x, y, x+10, y+10));
 end;
end;

procedure Teform.palboxMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
 if button=mbleft then palboxmousemove(sender, [ssleft], x, y);
 if button=mbright then palboxmousemove(sender, [ssright], x, y);
end;

procedure Teform.palboxMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
var b : byte;
begin
 if ssleft in shift then b := 1 else
 if ssright in shift then b := 2 else
  exit;
 if (x<0) or (y<0) then exit;
 x := x div 10; y := y div 10;
 if (x>=16) or (y>=16) then exit;
 sel[b] := y*16+x;
 if sel[b]=255 then sel[b]:=254;
 drawpal(self);
end;


procedure Teform.Ffunc(Sender: TObject);
var buf : array[0..64000] of byte;
    i, j : word;
begin
 if sender = SBnewframe then begin
  if cf<sf then begin
    move(sprite[cf*sx*sy], sprite[(cf+1)*sx*sy], sf*sx*sy);
    fillchar(sprite[cf*sx*sy], sx*sy, 0);
  end;
  inc(sf);
  init(false);
 end;
 if sender = SBappend then begin
  inc(sf);
  init(false);
 end;
 if (sender = SBdelete) and (sf>0) then begin
  if cf<sf then begin
    move(sprite[(cf+1)*sx*sy], sprite[cf*sx*sy], sf*sx*sy);
  end;
  dec(sf);
  dec(cf);
  init(false);
 end;
 if sender = SBcopyf then
  move(sprite[sx*sy*cf], spclip[0], sx*sy);
 if sender = SBpastef then
  move(spclip[0], sprite[sx*sy*cf], sx*sy);
 if sender = SBflipLR then begin
  move(sprite[cf*sx*sy], buf[0], sx*sy);
  for j := 0 to sy-1 do for i := 0 to sx-1 do
   sprite[cf*sx*sy+j*sx+i] := buf[j*sx+sx-i-1];
 end;

 if (sender = SBload) and (loaddia.execute) then
   loadgraphic(loaddia.filename, false);
 if (sender = SBloadappend) and (loaddia.execute) then begin
   Ffunc(SBnewframe);
   loadgraphic(loaddia.filename, true);
 end;
 if (sender = SBsave) and (savedia.execute) then
   savegraphic(savedia.filename);
 drawbox;
 drawfbox;
end;

procedure Teform.FormMouseWheel(Sender: TObject; Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
begin
 if wheeldelta<0 then dec(sel[1]);
 if wheeldelta>0 then inc(sel[1]);
 drawpal(self);
 handled := true;
end;

procedure Teform.zbarChange(Sender: TObject);
begin
 zo := zbar.position;
 init(false);
 drawbox;
end;

procedure teform.drawfbox;
var f, c : byte;
    i, j : word;
begin
 fo := fbar.position;
 with fbuf.canvas do begin
  brush.color := clbtnface;
  fillrect(getrect(0, 0, fbox.width, fbox.height));
  for f := 0 to limit(sf, vs)-1 do begin
   for j := 0 to limit(sy, sps)-1 do for i := 0 to limit(sx, sps)-1 do begin
    c := sprite[(f+fo)*sx*sy+j*sx+i];
    if c<>0 then pixels[f*sps+i, j] := swapRB(dostrans[c]);
   end;
  end;
  brush.color := clRed;
  i := (cf-fo)*sps;
  framerect(getrect(i, 0, i+sps, sps));
 end;
 fbox.canvas.draw(0,0,fbuf);
end;

procedure Teform.fboxPaint(Sender: TObject);
begin
 drawfbox;
end;

procedure Teform.fboxMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
 cf := (x div sps) + fo;
 SEframe.value := cf;
 drawbox;
 drawfbox;
end;

end.
