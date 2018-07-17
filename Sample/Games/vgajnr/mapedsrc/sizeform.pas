unit sizeform;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, Spin;

type
  Tsiform = class(TForm)
    SEx: TSpinEdit;
    Label1: TLabel;
    SEy: TSpinEdit;
    Label2: TLabel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  siform: Tsiform;

implementation

{$R *.dfm}

end.
