object siform: Tsiform
  Left = 299
  Top = 518
  Width = 248
  Height = 97
  Caption = 'select size'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 24
    Top = 14
    Width = 25
    Height = 13
    Caption = 'width'
  end
  object Label2: TLabel
    Left = 20
    Top = 40
    Width = 29
    Height = 13
    Caption = 'height'
  end
  object SEx: TSpinEdit
    Left = 60
    Top = 10
    Width = 57
    Height = 22
    MaxValue = 1
    MinValue = 1
    TabOrder = 0
    Value = 8
  end
  object SEy: TSpinEdit
    Left = 60
    Top = 36
    Width = 57
    Height = 22
    MaxValue = 1
    MinValue = 1
    TabOrder = 1
    Value = 8
  end
  object BitBtn1: TBitBtn
    Left = 146
    Top = 8
    Width = 75
    Height = 25
    Caption = 'OK'
    ModalResult = 1
    TabOrder = 2
  end
  object BitBtn2: TBitBtn
    Left = 146
    Top = 38
    Width = 75
    Height = 25
    Caption = 'cancel'
    ModalResult = 2
    TabOrder = 3
  end
end
