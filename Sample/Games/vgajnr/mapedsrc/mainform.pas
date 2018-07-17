unit mainform;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, graphtools, Menus, Buttons;



type
  Tmform = class(TForm)
    Bevel1: TBevel;
    box: TPaintBox;
    hbar: TScrollBar;
    vbar: TScrollBar;
    Bevel2: TBevel;
    spbox: TPaintBox;
    MainMenu1: TMainMenu;
    MMfile: TMenuItem;
    MMloadmap: TMenuItem;
    MMsavemap: TMenuItem;
    SBeditms: TSpeedButton;
    N1: TMenuItem;
    MMloadMS: TMenuItem;
    MMsaveMS: TMenuItem;
    Bevel3: TBevel;
    obox: TPaintBox;
    sboL: TSpeedButton;
    sboR: TSpeedButton;
    Lo: TStaticText;
    Lno: TStaticText;
    Label1: TLabel;
    Bevel4: TBevel;
    Lsp: TStaticText;
    Label2: TLabel;
    Lnsp: TStaticText;
    sbsL: TSpeedButton;
    SBsR: TSpeedButton;
    sbOcreate: TSpeedButton;
    sbodel: TSpeedButton;
    sbcopyms: TSpeedButton;
    sbpastems: TSpeedButton;
    SBscreate: TSpeedButton;
    SBsdel: TSpeedButton;
    N2: TMenuItem;
    MMloadspr: TMenuItem;
    MMsavespr: TMenuItem;
    RBdraw: TRadioButton;
    RBselo: TRadioButton;
    RBseto: TRadioButton;
    Label3: TLabel;
    Lox: TStaticText;
    Bevel5: TBevel;
    Label4: TLabel;
    Loy: TStaticText;
    N3: TMenuItem;
    SBtL: TSpeedButton;
    SBtR: TSpeedButton;
    Label5: TLabel;
    Label6: TLabel;
    SBxsL: TSpeedButton;
    SBxsR: TSpeedButton;
    Label7: TLabel;
    SBysL: TSpeedButton;
    SBysR: TSpeedButton;
    Sbt0: TSpeedButton;
    SBxs0: TSpeedButton;
    SBys0: TSpeedButton;
    MMsaveall: TMenuItem;
    map1: TMenuItem;
    MMdrawboarder: TMenuItem;
    MMresizemap: TMenuItem;
    SBscopy: TSpeedButton;
    SBspaste: TSpeedButton;
    Lt: TEdit;
    Lxs: TEdit;
    Lys: TEdit;
    Label8: TLabel;
    La2: TEdit;
    SBa2L: TSpeedButton;
    SBa20: TSpeedButton;
    SBa2R: TSpeedButton;
    Label9: TLabel;
    La3: TEdit;
    SBa3L: TSpeedButton;
    SBa30: TSpeedButton;
    SBa3R: TSpeedButton;
    Label10: TLabel;
    La4: TEdit;
    SBa4L: TSpeedButton;
    SBa40: TSpeedButton;
    SBa4R: TSpeedButton;
    Label12: TLabel;
    Label13: TLabel;
    Ld1: TEdit;
    Ld2: TEdit;
    SBd1L: TSpeedButton;
    SBd2L: TSpeedButton;
    SBd10: TSpeedButton;
    SBd20: TSpeedButton;
    SBd1R: TSpeedButton;
    SBd2R: TSpeedButton;
    SBsedit: TSpeedButton;
    loaddia: TOpenDialog;
    savedia: TSaveDialog;
    N4: TMenuItem;
    MMnewmap: TMenuItem;
    N5: TMenuItem;
    MMexit: TMenuItem;
    MMobjects: TMenuItem;
    MMnewobj: TMenuItem;
    N6: TMenuItem;
    MMmapsprites: TMenuItem;
    MMnewMS: TMenuItem;
    N7: TMenuItem;
    Lcms: TLabel;

    procedure initmap(xs, ys : word);
    procedure initobjects;
    procedure setbars;

    procedure drawmap;
    procedure drawmapsprites;

    procedure loadmap(name : string);
    procedure savemap(name : string);
    procedure loadmapsprites(name : string);
    procedure savemapsprites(name : string);
    procedure loadsprites(name : string);
    procedure savesprites(name : string);

    procedure showobject;
    procedure showsprite;

    procedure drawboarder(s : byte);
    procedure resizemap(w, h : word);

    function savediaexe(ex : byte) : boolean;
    function loaddiaexe(ex : byte) : boolean;
    procedure MMfunc(Sender: TObject);
    procedure MSfunc(Sender: TObject);
    procedure Ofunk(Sender: TObject);
    procedure Sfunc(Sender: TObject);

    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure boxPaint(Sender: TObject);
    procedure boxMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure boxMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure spboxPaint(Sender: TObject);
    procedure spboxMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure spboxMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure reshowobj(Sender: TObject);
    procedure oboxDblClick(Sender: TObject);
    procedure LabelChange(Sender: TObject);
    procedure MMapfunk(Sender: TObject);
  private

  public

  end;


  const pshift = 6;

  type obstruc = packed record
        x,                               //  00
        y      : cardinal;               //  04
        dir1,
        dir2   : byte;                   //  08
        xsp,                             //  10
        ysp    : integer;                //  14
        sp,                              //  18
        fr     : byte;                   //  19
        typ,                             //  20
        add2,                            //  21
        add3,                            //  22
        add4   : byte;                   //  23
      end;

      spritestruc = record
        xs, ys, fr : word;
        data : array of byte;
      end;

const objectsize = sizeof(obstruc);

var mform : Tmform;

    themap : array[0..$8888] of word;
    mapxs, mapys,
    vxs, vys : word;

    mapsprites : array[0..256*64-1] of byte;
    msclip : array[0..63] of byte;

    objects  : array[0..2000] of obstruc;
    nobjects : word;
    sprites  : array[0..255] of spritestruc;
    nsprites : word;
    spriteclip : spritestruc;

    boxbuf,
    spbuf,
    obuf : tbitmap;

    sel : array[1..2] of byte;
    curob : word;

    ofiles : array[1..3] of string;

const mygamepath='maps\';
var   gamepath : string;

{$include 'dospal.inc'}

implementation

uses spedit, sizeform;

{$R *.dfm}

procedure Tmform.FormCreate(Sender: TObject);
begin
 if directoryexists(mygamepath) then gamepath:=mygamepath else
  gamepath:=extractfiledir(application.exename);
 loaddia.initialdir := gamepath;
 savedia.initialdir := gamepath;
 getbuffer(boxbuf, box,0); boxbuf.pixelformat := pf32bit;
 getbuffer(spbuf, spbox,0); spbuf.pixelformat := pf32bit;
 getbuffer(obuf, obox,0);
 vxs := box.width shr 3;
 vys := box.height shr 3;
 //initmap(150, 100);
 initobjects;
 loadsprites(gamepath+'map01.spr');       // try to load standards
 loadmapsprites(gamepath+'map01.msp');
 loadmap(gamepath+'map01.map');
 showobject;
 sel[1] := 1;
 sel[2] := 0;
 ofiles[1]:='';
 ofiles[2]:='';
 ofiles[3]:='';
end;

procedure Tmform.FormDestroy(Sender: TObject);
var i : byte;
begin
 boxbuf.free;
 for i := 0 to 255 do setlength(sprites[i].data, 0);
end;

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

procedure tmform.setbars;
begin
 hbar.min := 0;
 hbar.position := 0;
 hbar.max := limitz(mapxs-vxs, 0);
 vbar.min := 0;
 vbar.position := 0;
 vbar.max := limitz(mapys-vys, 0);
end;

procedure tmform.initmap(xs, ys : word);
begin
 mapxs := xs;
 mapys := ys;
 fillchar(themap, sizeof(themap), 0);
 objects[0].x := 7 shl pshift;
 objects[0].y := 7 shl pshift;
 setbars;
 drawboarder(1);
 drawmap;
end;

procedure tmform.initobjects;
begin
 nobjects := 1;
 nsprites := 0;
 curob := 0;
 fillchar(objects, sizeof(objects), 0);
 fillchar(sprites, sizeof(sprites), 0);
 showobject;
end;





procedure tmform.drawmap;
var ix, iy, xo, yo, x1, y1, i, j : word;
    spos : word;
    c : byte;
    p : pintarray;
    int : integer;
begin
 with boxbuf do begin
  for iy := 0 to vys-1 do for ix := 0 to vxs-1 do begin
   spos := themap[(iy+vbar.position)*mapxs+ix+hbar.position] shl 6;
   for j := 0 to 7 do begin
    p := scanline[iy shl 3 + j];
    for i := 0 to 7 do p[ix shl 3 + i] := dostrans[mapsprites[spos+(j shl 3) + i]];
   end;
  end;
  xo := hbar.position shl 3;
  yo := vbar.position shl 3;
  // draw objects
  for i := 0 to nobjects-1 do with objects[i] do begin
   x1 := x shr pshift-7;
   y1 := y shr pshift-7;
   if (x1+50>=xo) and (y1+50>=yo) then with sprites[sp] do
    if high(data)>0 then
   for iy := 0 to ys-1 do begin
    int := y1+iy-yo;
    if (int>=0) and (int<box.height) then begin
     p := scanline[int];
     for ix := 0 to xs-1 do begin
      int := x1+ix-xo;
      if (int>=0) and (int < box.width) then begin
       c := data[iy*xs+ix];
       if c<>0 then p[int] := (dostrans[c]);
      end;
     end;
    end;
   end;
   if i=curob then begin
    canvas.brush.color := clgreen;
    canvas.framerect(getrect(x1-xo-1, y1-yo-1, x1-xo+1+sprites[sp].xs,y1-yo+1+sprites[sp].ys));
   end; 
  end;
 end;
 box.canvas.draw(0, 0, boxbuf);
end;


procedure Tmform.boxPaint(Sender: TObject);
begin
 drawmap;
end;

procedure tmform.loadmap(name : string);
var f : file;
    i : word;
begin
 assignfile(f, name);
 {$i-}
 reset(f, 1);
 blockread(f, mapxs, 2);
 blockread(f, mapys, 2);
 blockread(f, themap[0], mapxs*mapys*2);


 blockread(f, nobjects, 2);
 for i := 0 to nobjects-1 do
  blockread(f, objects[i], objectsize);

 if ioresult=0 then ofiles[1] := name;
 closefile(f);
 {$i+}
 setbars;
 drawmap;
 showobject;
end;

procedure tmform.savemap(name : string);
var f : file;
    i : word;
begin
 assignfile(f, name);
 {$i-}
 rewrite(f, 1);
 blockwrite(f, mapxs, 2);
 blockwrite(f, mapys, 2);
 blockwrite(f, themap[0], mapxs*mapys*2);

 blockwrite(f, nobjects, 2);
 for i := 0 to nobjects-1 do
  blockwrite(f, objects[i], objectsize);

 if ioresult=0 then ofiles[1] := name;
 closefile(f);
 {$i-}
end;


procedure tmform.loadmapsprites(name : string);
var f : file;
    c : word;
begin
 assignfile(f, name);
 {$i-}
 reset(f, 1);
 blockread(f, c, 2);
 blockread(f, mapsprites[0], c shl 6);
 if ioresult=0 then ofiles[2] := name;
 closefile(f);
 {$i+}
end;

procedure tmform.savemapsprites(name : string);
var f : file;
    c : word;
begin
 assignfile(f, name);
 {$i-}
 rewrite(f, 1);
 c := 256; blockwrite(f, c, 2);
 blockwrite(f, mapsprites[0], 256 shl 6);
 if ioresult=0 then ofiles[2] := name;
 closefile(f);
 {$i+}
end;

procedure tmform.loadsprites(name : string);
var f : file;
    i : byte;
begin
 assignfile(f, name);
 {$i-}
 reset(f, 1);
 blockread(f, nsprites, 2);
 for i := 0 to nsprites-1 do with sprites[i] do begin
   blockread(f, xs, 2);
   blockread(f, ys, 2);
   blockread(f, fr, 2);
   setlength(data, xs*ys*fr);
   blockread(f, data[0], xs*ys*fr);
 end;
 if ioresult=0 then ofiles[3] := name;
 closefile(f);
end;

procedure tmform.savesprites(name : string);
var f : file;
    i : byte;
begin
 assignfile(f, name);
 {$i-}
 rewrite(f, 1);
 blockwrite(f, nsprites, 2);
 for i := 0 to nsprites-1 do with sprites[i] do begin
   blockwrite(f, xs, 2);
   blockwrite(f, ys, 2);
   blockwrite(f, fr, 2);
   blockwrite(f, data[0], xs*ys*fr);
 end;
 if ioresult=0 then ofiles[3] := name;
 closefile(f);
end;


procedure Tmform.boxMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
 if button=mbLeft then boxmousemove(sender, [ssLeft], x, y);
 if button=mbright then boxmousemove(sender, [ssright], x, y);
end;

procedure Tmform.boxMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
var b : byte;
    x1, y1 : cardinal;
begin
 if ssleft in shift then b := 1
 else if ssright in shift then b := 2
 else exit;

 if (x<0) or (y<0) then exit;
 if (x>=box.width) or (y>=box.height) then exit;

 if RBdraw.checked then begin
  x := (x shr 3)+hbar.position;
  y := (y shr 3)+vbar.position;
  if (x>=mapxs) or (y>=mapys) then exit;
  themap[(y*mapxs+x)] := sel[b];
 end;

 x1 := ((hbar.position shl 3)+x) shl pshift;
 y1 := ((vbar.position shl 3)+y) shl pshift;

 if RBseto.checked then with objects[curob] do begin
  x := x1+7;
  y := y1+7;
  showobject;
 end;
 
 drawmap;
end;



procedure tmform.drawmapsprites;
var i, j, x, y : word;
    p : pintarray;
    s : word;
begin
 with spbuf do begin
  with canvas do begin
   brush.color := clbtnface;
   fillrect(getrect(0, 0, width, height));
   brush.color := clRed; x := (sel[1] mod 64)*10; y := (sel[1] div 64) * 10;
   fillrect(getrect(x, y, x+10, y+10));
   brush.color := clBlue; x := (sel[2] mod 64)*10; y := (sel[2] div 64) * 10;
   fillrect(getrect(x, y, x+10, y+10));
  end;
  for y := 0 to 3 do for x := 0 to 63 do begin
   s := (y shl 6 + x) shl 6;
   for j := 0 to 7 do begin
    p := scanline[y*10 + j + 1];
    for i := 0 to 7 do p[x*10 + i + 1] := dostrans[mapsprites[s+j shl 3+i]];
   end;
  end;
 end;
 spbox.canvas.draw(0, 0, spbuf);
 Lcms.caption := chr(sel[1])+' '+inttostr(sel[1]);
end;




procedure Tmform.spboxPaint(Sender: TObject);
begin
 drawmapsprites;
end;

procedure Tmform.spboxMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
 if button=mbleft then spboxmousemove(sender, [ssleft], x, y);
 if button=mbright then spboxmousemove(sender, [ssright], x, y);
end;

procedure Tmform.spboxMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
var b : byte;
begin
 if ssleft in shift then b := 1
 else if ssright in shift then b := 2
 else exit;

 if (x<0) or (y<0) then exit;
 x := (x div 10);
 y := (y div 10);
 if (x>=64) or (y>=4) then exit;
 sel[b] := y*64+x;
 drawmapsprites;
end;








procedure tmform.drawboarder(s : byte);
var i : word;
begin
 for i := 0 to mapxs-1 do begin
  themap[i] := s;
  themap[(mapys-1)*mapxs+i] := s;
 end;
 for i := 0 to mapys-1 do begin
  themap[i*mapxs] := s;
  themap[i*mapxs+mapxs-1] := s;
 end;
 drawmap;
end;


procedure tmform.resizemap(w, h : word);
var x, y : word;
    mapbuf : array[0..32767] of word;
begin
 fillchar(mapbuf[0], sizeof(mapbuf), 0);
 move(themap[0], mapbuf[0], sizeof(mapbuf));
 for y := 0 to h-1 do for x := 0 to w-1 do
  if (y<mapys) and (x<mapxs) then
   themap[y*w+x] := mapbuf[y*mapxs+x]
  else
   themap[y*w+x] := 0;

 mapxs := w;
 mapys := h;
 setbars;
 drawmap;
end;


const etns : array[1..3] of string[5] = ('*.map','*.msp','*.spr');
function tmform.savediaexe(ex : byte) : boolean;
begin
 with savedia do begin
  defaultext := etns[ex];
  filter := etns[ex]+'|'+etns[ex];
  result := execute;
 end;
end;
function tmform.loaddiaexe(ex : byte) : boolean;
begin
 with loaddia do begin
  defaultext := etns[ex];
  filter := etns[ex]+'|'+etns[ex];
  result := execute;
 end;
end;


procedure Tmform.MMfunc(Sender: TObject);
begin
 MMsaveall.enabled := (ofiles[1]<>'') or (ofiles[2]<>'') or (ofiles[3]<>'');
 with savedia do begin
   if (sender = MMsavemap) and (savediaexe(1)) then savemap(filename);
   if (sender = MMsaveMS) and (savediaexe(2)) then savemapsprites(filename);
   if (sender = MMsavespr) and (savediaexe(3)) then savesprites(filename);
   if sender = MMsaveall then begin
     if ofiles[1]<>'' then savemap(ofiles[1]);
     if ofiles[2]<>'' then savemapsprites(ofiles[2]);
     if ofiles[3]<>'' then savesprites(ofiles[3]);
   end;
 end;
 with loaddia do begin
   if (sender = MMloadmap) and (loaddiaexe(1)) then loadmap(filename);
   if (sender = MMloadMS) and (loaddiaexe(2)) then loadmapsprites(filename);
   if (sender = MMloadspr) and (loaddiaexe(3)) then loadsprites(filename);
 end;
 if sender=MMexit then close;
 drawmap;
 showobject;
end;

procedure Tmform.MMapfunk(Sender: TObject);
begin
 if sender = MMdrawboarder then drawboarder(sel[1]);
 if (sender = MMresizemap) or (sender = MMnewmap) then begin
   siform.SEx.value := mapxs;
   siform.SEy.value := mapys;
   siform.showmodal;
   if siform.modalresult = mrOK then begin
    if sender=MMnewmap then fillchar(themap[0],sizeof(themap),0);
    resizemap(siform.SEx.value, siform.SEy.value);
   end;
 end;
 drawmap;
 showobject;
end;

procedure Tmform.MSfunc(Sender: TObject);
begin
 if sender = SBeditms then begin
  eform.sx := 8;
  eform.sy := 8;
  eform.sf := 1;
  move(mapsprites[sel[1]*64], eform.sprite[0], 64);
  eform.init(true);
  eform.showmodal;
  if eform.modalresult=mrOk then begin
   move(eform.sprite[0], mapsprites[sel[1]*64], 64);
  end;
 end;
 if sender = SBcopyms then move(mapsprites[sel[1]*64], msclip[0], 64);
 if sender = SBpastems then move(msclip[0], mapsprites[sel[1]*64], 64);
 if sender = MMnewMS then fillchar(mapsprites[0], 256*64, 0);
 drawmap;
 drawmapsprites;
end;






procedure tmform.showobject;
begin
 Lo.caption := inttostr(curob+1);
 Lno.caption := inttostr(nobjects);
 Lox.caption := inttostr(objects[curob].x);
 Loy.caption := inttostr(objects[curob].y);
 Lxs.text := inttostr(objects[curob].xsp);
 Lys.text := inttostr(objects[curob].ysp);
 Ld1.text := inttostr(objects[curob].dir1);
 Ld2.text := inttostr(objects[curob].dir2);
 Lt.text := inttostr(objects[curob].typ);
 La2.text := inttostr(objects[curob].add2);
 La3.text := inttostr(objects[curob].add3);
 La4.text := inttostr(objects[curob].add4);

 Lsp.caption := inttostr(objects[curob].sp+1);
 Lnsp.caption := inttostr(nsprites);
 sbocreate.enabled := curob=nobjects;
 sbodel.enabled := (curob<>0) and (curob=nobjects-1);
 sbscreate.enabled :=
  high(sprites[objects[curob].sp].data)<1;
 sbsdel.enabled := not sbscreate.enabled;
 sbscopy.enabled := sbsdel.enabled;
 sbspaste.enabled := high(spriteclip.data)>0; 
 showsprite;
end;

procedure tmform.showsprite;
var x, y : word;
begin
 with obuf.canvas do begin
  brush.color := clGray;
  fillrect(getrect(0,0,obox.width,obox.height));
  with sprites[objects[curob].sp] do if high(data)>0 then
  for y := 0 to limit(obox.height, ys)-1 do
  for x := 0 to limit(obox.width, xs)-1 do
  pixels[x,y] := swapRB(dostrans[data[y*xs+x]]);
 end;
 obox.canvas.draw(0,0,obuf);
end;

procedure Tmform.reshowobj(Sender: TObject);
begin
 showsprite;
end;



procedure Tmform.Ofunk(Sender: TObject);
 procedure incdecbyte(s1, s2, s3 : tobject; var x : byte);
 begin
  if (sender=s1) and (x>0) then dec(x);
  if (sender=s2) and (x<255) then inc(x);
  if (sender=s3) then x := 0;
 end;
 procedure incdecint(s1, s2, s3 : tobject; var x : integer);
 begin
  if (sender=s1) then dec(x);
  if (sender=s2) then inc(x);
  if (sender=s3) then x := 0;
 end;
begin
 if (sender = sboL) and (curob>0) then dec(curob);
 if (sender = sboR) and (curob<255) then inc(curob);
 if (sender = sbOcreate) then inc(nobjects);
 if (sender = sbOdel) then dec(nobjects);
 if curob<>0 then with objects[curob] do begin
  incdecint(SBxsL, SBxsR, SBxs0, xsp);
  incdecint(SBysL, SBysR, SBys0, ysp);
  incdecbyte(SBtL, SBtR, SBt0, typ);
  incdecbyte(SBd1L, SBd1R, SBd10, dir1);
  incdecbyte(SBd2L, SBd2R, SBd20, dir2);
  incdecbyte(SBa2L, SBa2R, SBa20, add2);
  incdecbyte(SBa3L, SBa3R, SBa30, add3);
  incdecbyte(SBa4L, SBa4R, SBa40, add4);
 end;

 if (sender = MMnewobj) then begin
   fillchar(objects[1], objectsize*1999, 0);
   nobjects := 1;
 end;

 showobject;
 drawmap;
end;

procedure Tmform.LabelChange(Sender: TObject);
 procedure getbyte(l : TEdit; var x : byte);
 var e : integer;
     b : byte;
 begin
  if sender<>l then exit;
  val(l.text, b, e);
  if e=0 then x := b;
 end;
 procedure getint(l : TEdit; var x : integer);
 var e, i : integer;
 begin
  if sender<>l then exit;
  val(l.text, i, e);
  if e=0 then x := i;
 end;
begin
 if curob<>0 then with objects[curob] do begin
  getint(Lxs, xsp);
  getint(Lys, ysp);
  getbyte(Ld1, dir1);
  getbyte(Ld2, dir2);
  getbyte(Lt, typ);
  getbyte(La2, add2);
  getbyte(La3, add3);
  getbyte(La4, add4);
 end;
end;

procedure Tmform.Sfunc(Sender: TObject);
begin
 with objects[curob] do begin
  if (curob>0) then begin
   if (sender = SBsL) and (sp<>0) then dec(sp);
   if (sender = SBsR) and (sp<255) then inc(sp);
  end;
  if (sender = SBsdel) then with sprites[sp] do setlength(data, 0);
  if (sender = SBscopy) then with sprites[sp] do begin
   spriteclip.xs := xs;
   spriteclip.ys := ys;
   spriteclip.fr := fr;
   setlength(spriteclip.data, xs*ys*fr);
   move(data[0], spriteclip.data[0], xs*ys*fr);
  end;
  if (sender = Sbsedit) then oboxDblClick(self);
  if (sender = SBspaste) then with sprites[sp] do begin
   xs := spriteclip.xs;
   ys := spriteclip.ys;
   fr := spriteclip.fr;
   setlength(data, xs*ys*fr);
   move(spriteclip.data[0], data[0], xs*ys*fr);
  end; 
  if (sender = SBscreate) then with sprites[sp] do begin
   siform.showmodal;
   if siform.modalresult = mrok then begin
    xs := siform.SEx.value;
    ys := siform.SEy.value;
    fr := 1;
    setlength(data, xs*ys);
    fillchar(data[0], xs*ys, 0);
    inc(nsprites);
   end;
  end;
 end;
 showobject;
 drawmap;
end;

procedure Tmform.oboxDblClick(Sender: TObject);
begin
 if not sbsdel.enabled then Sfunc(SBscreate);
 with objects[curob] do
 with sprites[sp] do begin
   eform.sx := xs;
   eform.sy := ys;
   eform.sf := fr;
   move(sprites[sp].data[0], eform.sprite[0], xs*ys*fr);
   eform.init(true);
   eform.showmodal;
   if eform.modalresult = mrOk then begin
    xs := eform.sx;
    ys := eform.sy;
    fr := eform.sf;
    setlength(data, xs*ys*fr);
    move(eform.sprite[0], sprites[sp].data[0], xs*ys*fr);
   end;
 end;
end;


end.
