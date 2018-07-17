unit graphtools;

interface

uses types, sysutils, math, dialogs, graphics, extctrls;

type TIntArray = array[0..9999999] of cardinal;
     Pintarray = ^TIntarray;

     TsmallIntArray = array[0..9999999] of smallint;
     Psmallintarray = ^TsmallIntarray;

     TbyteArray = array[0..9999999] of byte;
     Pbytearray = ^Tbytearray;

const nrdigits = 37;

      COgray = 0;
      COred = 1;
      COorange = 2;
      COyellow = 3;
      COyellowgreen = 4;
      COgreen = 5;
      COgreencyan = 6;
      COcyan = 7;
      COcyanblue = 8;
      COblue = 9;
      CObluemagenta = 10;
      COmagenta = 11;
      COmagentared = 12;

      colornames : array[0..12] of string[20]=
      ('gray', 'red', 'orange', 'yellow', 'yellowgreen', 'green',
       'greencyan', 'cyan', 'cyanblue', 'blue', 'bluemagenta',
       'magenta', 'magentared');

      dospal : array[0..15] of cardinal=
      ($000000,
       $0000a8,
       $00a800,
       $00a8a8,
       $a80000,
       $a800a8,
       $a8a800,
       $a8a8a8,
       $545454,
       $5454fc,
       $54fc54,
       $54fcfc,
       $fc5454,
       $fc54fc,
       $fcfc54,
       $fcfcfc);

procedure errorbox(text : string);
//function confirm(text : string) : boolean;

function double2str(d : double) : string;
function inttostrd(i : cardinal; digits : byte) : string;
// ^ gives i with some zeroes ahead like inttohex, i should fit into digits! 
function char2str(c : array of char) : string;
function Pchar2str(c : Pchar) : string;
function fixedlength(s : string; c : integer) : string;

function limit(i, lim : integer) : integer;
function limit0(i, lim0, lim : integer) : integer;
function limitz(i, lim0 : integer) : integer;
function bound(i, lim : integer) : integer;
procedure swap(var i1, i2 : integer);
function biggest(i1, i2 : integer) : integer;
function smallest(i1, i2 : integer) : integer;

procedure getbuffer(var b : tbitmap; i : tpaintbox; c:integer);
function getrect(x1, y1, x2, y2 : integer) : trect;

procedure drawbevel(b : tbitmap; x1, y1, x2, y2 : integer; c1, c2 : integer);

procedure splitcolor(c : cardinal; var r, g, b : byte);
function mergecolor(r, g, b : byte) : cardinal;
function fadecolor(c1, c2 : cardinal; d : double) : cardinal;
function mix4color(c1, c2, c3, c4 : cardinal) : cardinal;
function setgammab(c : cardinal; g : byte) : cardinal;
function multcolor(c, c1 : cardinal) : cardinal;
function getbrightness(c : cardinal) : byte;
function getaverage(c : cardinal) : byte;
function comparecolor(c1, c2 : cardinal; tolerance : byte) : byte;
// ^ compares c1 with c2 using tolerance; returns distance 0..254 or 255 if not equal
function compareaverage(c1, c2 : cardinal; tresh : byte) : boolean;
function comparebrightness(c1, c2 : cardinal; tresh : byte) : boolean;
function desaturate(c1 : cardinal; val : byte) : cardinal;
function addtocolor(c : cardinal; val : smallint) : cardinal;
function addtocolorrgb(c : cardinal; r, g, b : smallint) : cardinal;
function swapRB(c : cardinal) : cardinal;

procedure scaleRGB(var r, g, b : byte);
// ^ short-out the least value and scale to 255

function whatcolor(c : cardinal; tresh : byte) : byte;
// ^ returns one of the CO-constants, where thresh shoulf be < than 127

function findpalcolor(c : cardinal; const p : array of cardinal) : byte;
// ^ returns best matching index for c in array p

procedure setcolor(source : tbitmap; const dest : Tbitmap; c : cardinal);
// ^ takes blue-value of 24bit bitmap for rgb and set to colors c }
procedure changecolor(source : tbitmap; const dest : Tbitmap; c : cardinal; fade : double);
// ^ takes blue-value of 24bit bitmap for rgb and fades to colors c; fade 0..1 }
procedure changecolor1(source : tbitmap; const dest : Tbitmap; c1, c2 : cardinal; fade : double);
// ^ takes blue-value of 24bit bitmap for rgb and fades from colors c1 to c2; fade 0..1 }
procedure digit(digis : tbitmap; var buffer : tbitmap; val : integer; n : byte; c : cardinal);
// ^ draws digit on buffer using digis; digits-> n; color-> c
procedure digitL(digis : tbitmap; var buffer : tbitmap; text : string; n : byte; c : cardinal);
// ^ draws digi-text on buffer using digis; digits-> n; color-> c

procedure fillwith(dest, source : tbitmap; c : cardinal);
// ^ fills dest with continous copys of source using color c

procedure transparenton(dest, source : tbitmap; x, y, c : cardinal);
// ^ copys dest on source with black as fully transparent, colored c

procedure Stextout(dest : tbitmap; x, y : integer; text : string; c1, c2, c3 : cardinal);

procedure drawupdown(dest : tbitmap; x, y : integer; cl, cs : cardinal);

procedure duplicate(source, dest : tbitmap);

implementation

procedure errorbox(text : string);
begin
 MessageDlg(text, mterror, [mbOk], 0);
end;

{function confirm(text : string) : boolean;
begin
// if MessageDlg(text, mtconfirmation, [mbYes, mbNo], 0) = mryes then
//  result := true else result := false;
end;}

// string routines **************************************

function double2str(d : double) : string;
begin
 str(d:5:5, result);
end;

function inttostrd(i : cardinal; digits : byte) : string;
var k, le : byte;
begin
 le := digits-1;
 for k := 1 to digits do if i>=power(10, k) then dec(le);
 result := '';
 if le>0 then for k := 1 to le do result := result + '0';
 result := result + inttostr(i);
end; 

function char2str(c : array of char) : string;
var i : integer;
begin
 result := '';
 i := low(c);
 while (i<=high(c)) and (c[i] <> #0) do begin
  result := result + c[i];
  inc(i);
 end;
end;

function Pchar2str(c : Pchar) : string;
var i : integer;
    ch : array of Char;
begin
 result := '';
 i := 0;
 while (c[i] <> #0) do begin
  result := result + c[i];
  inc(i);
 end;
end;

function fixedlength(s : string; c : integer) : string;
var i : integer;
begin
 result := '';
 for i := 1 to c do
  if i<=length(s) then result := result + s[i] else result := result + ' ';
end;

procedure swap(var i1, i2 : integer);
var i0 : integer;
begin
 i0 := i1; i1 := i2; i2 := i0;
end;

function biggest(i1, i2 : integer) : integer;
begin
 if i1>=i2 then result := i1 else result := i2;
end;

function smallest(i1, i2 : integer) : integer;
begin
 if i1<=i2 then result := i1 else result := i2;
end;


procedure getbuffer(var b : tbitmap; i : tpaintbox; c:integer);
begin
 b := tbitmap.create;
 with b do begin
   pixelformat := pf32bit;
   width := i.width;
   height := i.height;
   canvas.brush.color:=c;
   canvas.fillrect(getrect(0,0,width,height));
 end;
end;

procedure splitcolor(c : cardinal; var r, g, b : byte);
begin
 r := c and $ff;
 g := (c and $ff00) shr 8;
 b := (c and $ff0000) shr 16;
end;

function mergecolor(r, g, b : byte) : cardinal;
begin
 result := r or g shl 8 or b shl 16;
end;

function fadecolor(c1, c2 : cardinal; d : double) : cardinal;
begin
 result :=
  trunc((c1 shr 24)*(1-d)+(c2 shr 24)*d) shl 24 +
  trunc(((c1 and $ff0000) shr 16)*(1-d)+((c2 and $ff0000) shr 16)*d) shl 16 +
  trunc(((c1 and $ff00) shr 8)*(1-d)+((c2 and $ff00) shr 8)*d) shl 8 +
  trunc((c1 and $ff)*(1-d)+(c2 and $ff)*d);
end;

function mix4color(c1, c2, c3, c4 : cardinal) : cardinal;
begin
 result :=
  trunc(((c1 shr 24)+(c2 shr 24)+(c3 shr 24)+(c4 shr 24)) / 4) shl 24 +
  trunc(((c1 shr 16)+(c2 shr 16)+(c3 shr 16)+(c4 shr 16)) / 4) shl 16 +
  trunc((((c1 and $ff00) shr 8)+((c2 and $ff00) shr 8)+((c3 and $ff00) shr 8)+((c4 and $ff00) shr 8)) / 4) shl 8 +
  trunc(((c1 and $ff)+(c2 and $ff)+(c3 and $ff)+(c4 and $ff)) / 4);
end;


function setgammab(c : cardinal; g : byte) : cardinal;
var g1 : double;
begin
 g1 := g/$ff;
 result :=
  trunc((c shr 16)*g1) shl 16 +
  trunc(((c and $ff00) shr 8)*g1) shl 8 +
  trunc((c and $ff)*g1);
end;

function multcolor(c, c1 : cardinal) : cardinal;
begin
 result := (c and $ff)*(c1 and $ff) shr 8+
           ((c and $ff00) shr 8)*((c1 and $ff00) shr 8) and $ff00+
           (((c and $ff0000) shr 16)*(c1 and $ff0000) shr 16) and $ff00 shl 8;
end;           

function getbrightness(c : cardinal) : byte;
begin
 result := round((c and $ff)*0.3+
                 ((c and $ff00) shr 8)*0.59+
                 ((c and $ff0000) shr 16)*0.11);
end;

function getaverage(c : cardinal) : byte;
begin
 result := ((c and $ff)+
            (c and $ff00) shr 8+
            (c and $ff0000) shr 16) div 3;
end;

function comparecolor(c1, c2 : cardinal; tolerance : byte) : byte;
var r1, r2, g1, g2, b1, b2 : byte;
begin
 result := 255;
 splitcolor(c1, r1, g1, b1);
 splitcolor(c2, r2, g2, b2);
 if (r1>=r2-tolerance) and (r1<=r2+tolerance) and
    (g1>=g2-tolerance) and (g1<=g2+tolerance) and
    (b1>=b2-tolerance) and (b1<=b2+tolerance) then
  result := (abs(r2-r1)+abs(g2-g1)+abs(b2-b1)) div 3;
end;

function compareaverage(c1, c2 : cardinal; tresh : byte) : boolean;
begin
 if abs(getaverage(c1)-getaverage(c2))>tresh then result := false else result := true;
end;

function comparebrightness(c1, c2 : cardinal; tresh : byte) : boolean;
begin
 if abs(getbrightness(c1)-getbrightness(c2))>tresh then result := false else result := true;
end;

function desaturate(c1 : cardinal; val : byte) : cardinal;
var c2 : cardinal;
begin
 c2 := round((c1 and $ff)*0.3+
            ((c1 and $ff00) shr 8)*0.59+
            ((c1 and $ff0000) shr 16)*0.11);
 c2 := c2 + c2 shl 8 + c2 shl 16;
 result := fadecolor(c1, c2, val/255);
end;

function addtocolor(c : cardinal; val : smallint) : cardinal;
begin
 result := limit0(c and $ff+val, 0, $ff)+
           limit0(c and $ff00 shr 8+val, 0, $ff) shl 8+
           limit0(c and $ff0000 shr 16+val, 0, $ff) shl 16;
end;

function addtocolorrgb(c : cardinal; r, g, b : smallint) : cardinal;
begin
 result := limit0(c and $ff+r, 0, $ff)+
           limit0(c and $ff00 shr 8+g, 0, $ff) shl 8+
           limit0(c and $ff0000 shr 16+b, 0, $ff) shl 16;
end;

function swapRB(c : cardinal) : cardinal;
begin
 result := c and $ff shl 16 or
           c and $ff00 or
           c and $ff0000 shr 16;
end;           

procedure scaleRGB(var r, g, b : byte);
var d : byte;
begin
 d := smallest(r, smallest(g, b));
 r := r-d; g := g-d; b := b-d;
 d := limit0(biggest(r, biggest(g, b)), 1, 255);
 r := round(r/d*255);
 g := round(g/d*255);
 b := round(b/d*255);
end;

function whatcolor(c : cardinal; tresh : byte) : byte;
const gtresh = 1;
var r, g, b : byte;
begin
 result := 0;
 splitcolor(c, r, g, b);
 if (r>=g-gtresh) and (r<=g+gtresh) and
    (r>=b-gtresh) and (r<=b+gtresh) and
    (b>=g-gtresh) and (b<=g+gtresh)
  then begin result := COgray; exit; end;
  scaleRGB(r, g, b);

 if b=0 then begin
  if r=255 then begin
   if g<tresh then result := COred else
   if (g<255-tresh) then result := COorange
   else result := COyellow;
  end else
   if r>255-tresh then result := COyellow else
   if r>tresh then result := COyellowgreen else
   result := COgreen;
 end;
 if r=0 then begin
  if g=255 then begin
   if (b<tresh) then result := COgreen else
   if (b>tresh) and (b<255-tresh) then result := COgreencyan else
    result := COcyan;
  end else
   if g>255-tresh then result := COcyan else
   if g>tresh then result := COcyanblue else
   result := COblue;
 end;
 if g=0 then begin
  if b=255 then begin
   if r<tresh then result := COblue else
   if r<255-tresh then result := CObluemagenta else
   result := COmagenta;
  end else
   if b>255-tresh then result := COmagenta else
   if b>tresh then result := COmagentared else
   result := COred;
 end; 
end;



function findpalcolor(c : cardinal; const p : array of cardinal) : byte;
var i, it, r, g, b, r1, g1, b1 : byte;
begin
 result := p[0];
 splitcolor(c, r, g, b);
 for it := 0 to 255 do
   for i := 0 to high(p) do begin
    splitcolor(p[i], r1, g1, b1);
    if (r1>=r-it) and (r1<=r+it) and
       (g1>=g-it) and (g1<=g+it) and
       (b1>=b-it) and (b1<=b+it) then begin result := i; exit; end;
 end;
end;


procedure drawbevel(b : tbitmap; x1, y1, x2, y2 : integer; c1, c2 : integer);
begin
 with b.canvas do begin
  pen.color :=c1;
  moveto(x1, y2-1); lineto(x1, y1); lineto(x2, y1);
  pen.color := c2;
  moveto(x1+1, y2); lineto(x2, y2); lineto(x2, y1);
 end;
end;

function getrect(x1, y1, x2, y2 : integer) : trect;
begin
 with result do begin
  top := y1;
  left := x1;
  bottom := y2;
  right := x2;
 end;
end;

function limit(i, lim : integer) : integer;
begin
 if i>lim then i := lim; result := i;
end;

function limit0(i, lim0, lim : integer) : integer;
begin
 if i<lim0 then i := lim0 else if i>lim then i := lim;
 result := i;
end;

function limitz(i, lim0 : integer) : integer;
begin
 if i<lim0 then i := lim0;
 result := i;
end;

function bound(i, lim : integer) : integer;
begin
 if i>lim then i := i mod lim else
 if i<0 then i := lim-abs(-i mod lim)-1;
 result := i;
end;





procedure setcolor(source : tbitmap; const dest : Tbitmap; c : cardinal);
var i, j : integer;
    s, d : pbytearray;
    cs : double;
begin
 if (source.pixelformat <> pf24bit) or (dest.pixelformat <> pf24bit) then exit;
 dest.width := source.width;
 dest.height := source.height;
 for j := 0 to dest.height-1 do begin
  s := source.scanline[j];
  d := dest.scanline[j];
  for i := 0 to dest.width-1 do begin
   cs := s[i*3]/255;
   d[i*3] := trunc((c shr 16)*cs);
   d[i*3+1] := trunc(((c and $ffff) shr 8)*cs);
   d[i*3+2] := trunc((c and $ff)*cs);
  end;
 end;
end;

procedure changecolor(source : tbitmap; const dest : Tbitmap; c : cardinal; fade : double);
var i, j : cardinal;
    s, d : pbytearray;
    cs : byte;
    csf, cdf : double;
begin
 if (source.pixelformat <> pf24bit) or (dest.pixelformat <> pf24bit) then exit;
 for j := 0 to dest.height-1 do begin
  s := source.scanline[j];
  d := dest.scanline[j];
  for i := 0 to dest.width-1 do begin
   cs := s[i*3];
   csf := cs*(1-fade);
   cdf := fade*cs/255;
   d[i*3] := trunc(csf+(c shr 16)*cdf);
   d[i*3+1] := trunc(csf+((c and $ffff) shr 8)*cdf);
   d[i*3+2] := trunc(csf+(c and $ff)*cdf);
  end;
 end;
end;

procedure changecolor1(source : tbitmap; const dest : Tbitmap; c1, c2 : cardinal; fade : double);
var i, j : cardinal;
    s, d : pbytearray;
    cs : byte;
    cd : cardinal;
begin
 if (source.pixelformat <> pf24bit) or (dest.pixelformat <> pf24bit) then exit;
 for j := 0 to dest.height-1 do begin
  s := source.scanline[j];
  d := dest.scanline[j];
  for i := 0 to dest.width-1 do begin
   cs := s[i*3];
   cd := fadecolor(trunc(setgammab(c1, cs)), trunc(setgammab(c2, cs)), fade);
   d[i*3] := (cd shr 16);
   d[i*3+1] := (cd and $ffff) shr 8;
   d[i*3+2] := (cd and $ff);
  end;
 end;
end;



procedure digit(digis : tbitmap; var buffer : tbitmap; val : integer; n : byte; c : cardinal);
var i, j, k, d, xs, ys : integer;
    col : byte;
    p1, p2 : pbytearray;
begin
 xs := digis.width div nrdigits;
 ys := digis.height;
 buffer.width := n*xs;
 buffer.height := ys;
 for k := 0 to n-1 do
  for j := 0 to ys-1 do begin
   p1 := digis.scanline[j];
   p2 := buffer.scanline[j];
   for i := 0 to xs-1 do begin
    d := (val div trunc(power(10, n-k-1))) mod 10;
    col := p1[(d*xs+i)*3];
    p2[(k*xs+i)*3  ] := round(col*(c shr 16)/255);
    p2[(k*xs+i)*3+1] := round(col*((c and $ff00) shr 8)/255);
    p2[(k*xs+i)*3+2] := round(col*(c and $ff)/255);
   end;
 end;
end;

procedure digitL(digis : tbitmap; var buffer : tbitmap; text : string; n : byte; c : cardinal);
var i, j, k, d, xs, ys : integer;
    col : byte;
    p1, p2 : pbytearray;
begin
 xs := digis.width div nrdigits;
 ys := digis.height;
 buffer.width := n*xs;
 buffer.height := ys;
 for k := 0 to n-1 do
  for j := 0 to ys-1 do begin
   p1 := digis.scanline[j];
   p2 := buffer.scanline[j];
   d := ord(upcase(text[k+1]));
   if (d>=ord('0')) and (d<=ord('9')) then d := d-ord('0')
   else if (d>=ord('A')) and (d<=ord('Z')) then d := d-ord('A')+10 else d := nrdigits-1;
   if k>length(text) then d := nrdigits-1;
   for i := 0 to xs-1 do begin
    col := p1[(d*xs+i)*3];
    p2[(k*xs+i)*3  ] := round(col*(c shr 16)/255);
    p2[(k*xs+i)*3+1] := round(col*((c and $ff00) shr 8)/255);
    p2[(k*xs+i)*3+2] := round(col*(c and $ff)/255);
   end;
 end;
end;


procedure fillwith(dest, source : tbitmap; c : cardinal);
var buf : tbitmap;
    xs, ys, i, j : integer;
begin
 xs := source.width; ys := source.height;
 buf := tbitmap.create;
 buf.width := xs; buf.height := ys;
 buf.pixelformat := pf24bit;
 setcolor(source, buf, c);
 for i := 0 to dest.width div xs + 1 do for j := 0 to dest.height div ys + 1 do
  dest.canvas.draw(i*xs, j*ys, buf);
 buf.free;
end;

procedure Stextout(dest : tbitmap; x, y : integer; text : string; c1, c2, c3 : cardinal);
begin
 with dest.canvas do begin
  brush.style := bsclear;
  font.color := c2; textout(x-1, y-1, text);
  font.color := c3; textout(x+1, y+1, text);
  font.color := c1; textout(x, y, text);
 end;
end;


procedure transparenton(dest, source : tbitmap; x, y, c : cardinal);
var i, j, xs, ys, pos : integer;
    s, d : pbytearray;
    cs : integer;
    cd : integer;
begin
 if (source.pixelformat <> pf24bit) or (dest.pixelformat <> pf24bit) then exit;
 xs := source.width; ys := source.height;

 for j := 0 to ys-1 do begin
  s := source.scanline[j];
  d := dest.scanline[j+y];
  for i := 0 to xs-1 do begin
   pos := i*3; cs := s[pos+2]+s[pos+1]shl 8+s[pos]shl 16;
   pos := (x+i)*3; cd := d[pos]shl 16+d[pos+1]shl 8+d[pos+2];
   cd := fadecolor(cd, c, (cs and $ff)/$ff);
   d[pos] := (cd shr 16);
   d[pos+1] := (cd and $ff00) shr 8;
   d[pos+2] := (cd and $ff);
  end;
 end;
end;

procedure drawupdown(dest : tbitmap; x, y : integer; cl, cs : cardinal);
const xs = 9;
      ys = 20;
var ys1, ys2, xs1, xs2 : integer;
    a : array[1..3] of tpoint;
begin
 ys1 := ys shr 1;
 ys2 := ys div 3;
 xs1 := xs shr 1;
 xs2 := xs div 3;
 drawbevel(dest, x, y, x+xs, y+ys1, cl, cs);
 drawbevel(dest, x, y+ys1+1, x+xs, y+ys, cl, cs);
 a[1].x := x+xs1-xs2+1;
 a[1].y := y+ys1-ys2;
 a[2].x := x+xs1;
 a[2].y := y+ys2;
 a[3].x := x+xs1+xs2;
 a[3].y := a[1].y;
 with dest.canvas do begin
  pen.color := cs;
  brush.color := cl;
  polygon(a);
 end;
 a[1].y := y+ys1+ys2+1;
 a[2].y := y+ys-ys2-1;
 a[3].y := a[1].y;
 dest.canvas.polygon(a);
end;



procedure duplicate(source, dest : tbitmap);
var i, j : integer;
    p1, p2 : pbytearray;
    m : byte;
begin
 if not dest.handleallocated then dest := tbitmap.create;
 dest.width := source.width;
 dest.height := source.height;
 dest.pixelformat := source.pixelformat;
 m := 1;
 case source.pixelformat of
  pf15bit: m := 2;
  pf16bit: m := 2;
  pf24bit: m := 3;
  pf32bit: m := 4;
 end;

 for j := 0 to source.height-1 do begin
  p1 := source.scanline[j];
  p2 := dest.scanline[j];
  for i := 0 to source.width*m-1 do p2[i] := p1[i];
 end;
end;

end.


