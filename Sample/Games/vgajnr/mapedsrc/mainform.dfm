object mform: Tmform
  Left = 292
  Top = 235
  Width = 672
  Height = 702
  Caption = 'mapeditor'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel1: TBevel
    Left = 0
    Top = 0
    Width = 642
    Height = 402
  end
  object box: TPaintBox
    Left = 1
    Top = 1
    Width = 640
    Height = 400
    OnMouseDown = boxMouseDown
    OnMouseMove = boxMouseMove
    OnPaint = boxPaint
  end
  object Bevel2: TBevel
    Left = 0
    Top = 426
    Width = 644
    Height = 44
  end
  object spbox: TPaintBox
    Left = 2
    Top = 428
    Width = 640
    Height = 40
    OnMouseDown = spboxMouseDown
    OnMouseMove = spboxMouseMove
    OnPaint = spboxPaint
  end
  object SBeditms: TSpeedButton
    Left = 8
    Top = 476
    Width = 61
    Height = 22
    Caption = 'edit'
    OnClick = MSfunc
  end
  object Bevel3: TBevel
    Left = 226
    Top = 472
    Width = 417
    Height = 169
  end
  object obox: TPaintBox
    Left = 542
    Top = 516
    Width = 48
    Height = 48
    OnDblClick = oboxDblClick
    OnPaint = reshowobj
  end
  object sboL: TSpeedButton
    Left = 230
    Top = 494
    Width = 19
    Height = 17
    Hint = 'select object'
    Caption = '<'
    ParentShowHint = False
    ShowHint = True
    OnClick = Ofunk
  end
  object sboR: TSpeedButton
    Left = 252
    Top = 494
    Width = 19
    Height = 17
    Hint = 'select object'
    Caption = '>'
    ParentShowHint = False
    ShowHint = True
    OnClick = Ofunk
  end
  object Label1: TLabel
    Left = 274
    Top = 476
    Width = 5
    Height = 13
    Caption = '/'
  end
  object Bevel4: TBevel
    Left = 536
    Top = 474
    Width = 7
    Height = 165
    Shape = bsLeftLine
  end
  object Label2: TLabel
    Left = 586
    Top = 476
    Width = 5
    Height = 13
    Caption = '/'
  end
  object sbsL: TSpeedButton
    Left = 542
    Top = 494
    Width = 19
    Height = 17
    Hint = 'select sprite'
    Caption = '<'
    ParentShowHint = False
    ShowHint = True
    OnClick = Sfunc
  end
  object SBsR: TSpeedButton
    Left = 564
    Top = 494
    Width = 19
    Height = 17
    Hint = 'select sprite'
    Caption = '>'
    ParentShowHint = False
    ShowHint = True
    OnClick = Sfunc
  end
  object sbOcreate: TSpeedButton
    Left = 284
    Top = 494
    Width = 41
    Height = 17
    Caption = 'create'
    ParentShowHint = False
    ShowHint = True
    OnClick = Ofunk
  end
  object sbodel: TSpeedButton
    Left = 284
    Top = 514
    Width = 41
    Height = 17
    Caption = 'delete'
    ParentShowHint = False
    ShowHint = True
    OnClick = Ofunk
  end
  object sbcopyms: TSpeedButton
    Left = 8
    Top = 502
    Width = 61
    Height = 22
    Caption = 'copy'
    OnClick = MSfunc
  end
  object sbpastems: TSpeedButton
    Left = 8
    Top = 526
    Width = 61
    Height = 22
    Caption = 'paste'
    OnClick = MSfunc
  end
  object SBscreate: TSpeedButton
    Left = 596
    Top = 494
    Width = 41
    Height = 19
    Caption = 'create'
    ParentShowHint = False
    ShowHint = True
    OnClick = Sfunc
  end
  object SBsdel: TSpeedButton
    Left = 596
    Top = 516
    Width = 41
    Height = 19
    Hint = 't'
    Caption = 'delete'
    ParentShowHint = False
    ShowHint = True
    OnClick = Sfunc
  end
  object Label3: TLabel
    Left = 336
    Top = 478
    Width = 7
    Height = 13
    Caption = 'X'
  end
  object Bevel5: TBevel
    Left = 330
    Top = 474
    Width = 7
    Height = 165
    Shape = bsLeftLine
  end
  object Label4: TLabel
    Left = 336
    Top = 498
    Width = 7
    Height = 13
    Caption = 'Y'
  end
  object SBtL: TSpeedButton
    Left = 488
    Top = 548
    Width = 15
    Height = 17
    Caption = '<'
    ParentShowHint = False
    ShowHint = True
    OnClick = Ofunk
  end
  object SBtR: TSpeedButton
    Left = 518
    Top = 548
    Width = 15
    Height = 17
    Caption = '>'
    ParentShowHint = False
    ShowHint = True
    OnClick = Ofunk
  end
  object Label5: TLabel
    Left = 420
    Top = 548
    Width = 20
    Height = 13
    Caption = 'type'
  end
  object Label6: TLabel
    Left = 406
    Top = 476
    Width = 34
    Height = 13
    Caption = 'xspeed'
  end
  object SBxsL: TSpeedButton
    Left = 488
    Top = 476
    Width = 15
    Height = 17
    Caption = '<'
    ParentShowHint = False
    ShowHint = True
    OnClick = Ofunk
  end
  object SBxsR: TSpeedButton
    Left = 518
    Top = 476
    Width = 15
    Height = 17
    Caption = '>'
    ParentShowHint = False
    ShowHint = True
    OnClick = Ofunk
  end
  object Label7: TLabel
    Left = 406
    Top = 494
    Width = 34
    Height = 13
    Caption = 'yspeed'
  end
  object SBysL: TSpeedButton
    Left = 488
    Top = 494
    Width = 15
    Height = 17
    Caption = '<'
    ParentShowHint = False
    ShowHint = True
    OnClick = Ofunk
  end
  object SBysR: TSpeedButton
    Left = 518
    Top = 494
    Width = 15
    Height = 17
    Caption = '>'
    ParentShowHint = False
    ShowHint = True
    OnClick = Ofunk
  end
  object Sbt0: TSpeedButton
    Left = 504
    Top = 548
    Width = 13
    Height = 17
    Caption = '0'
    Margin = 1
    ParentShowHint = False
    ShowHint = True
    OnClick = Ofunk
  end
  object SBxs0: TSpeedButton
    Left = 504
    Top = 476
    Width = 13
    Height = 17
    Caption = '0'
    Margin = 1
    ParentShowHint = False
    ShowHint = True
    OnClick = Ofunk
  end
  object SBys0: TSpeedButton
    Left = 504
    Top = 494
    Width = 13
    Height = 17
    Caption = '0'
    Margin = 1
    ParentShowHint = False
    ShowHint = True
    OnClick = Ofunk
  end
  object SBscopy: TSpeedButton
    Left = 596
    Top = 564
    Width = 41
    Height = 17
    Hint = 'edit sprite'
    Caption = 'copy'
    ParentShowHint = False
    ShowHint = True
    OnClick = Sfunc
  end
  object SBspaste: TSpeedButton
    Left = 596
    Top = 584
    Width = 41
    Height = 17
    Hint = 'edit sprite'
    Caption = 'paste'
    ParentShowHint = False
    ShowHint = True
    OnClick = Sfunc
  end
  object Label8: TLabel
    Left = 416
    Top = 566
    Width = 24
    Height = 13
    Caption = 'add2'
  end
  object SBa2L: TSpeedButton
    Left = 488
    Top = 566
    Width = 15
    Height = 17
    Caption = '<'
    ParentShowHint = False
    ShowHint = True
    OnClick = Ofunk
  end
  object SBa20: TSpeedButton
    Left = 504
    Top = 566
    Width = 13
    Height = 17
    Caption = '0'
    Margin = 1
    ParentShowHint = False
    ShowHint = True
    OnClick = Ofunk
  end
  object SBa2R: TSpeedButton
    Left = 518
    Top = 566
    Width = 15
    Height = 17
    Caption = '>'
    ParentShowHint = False
    ShowHint = True
    OnClick = Ofunk
  end
  object Label9: TLabel
    Left = 416
    Top = 584
    Width = 24
    Height = 13
    Caption = 'add3'
  end
  object SBa3L: TSpeedButton
    Left = 488
    Top = 584
    Width = 15
    Height = 17
    Caption = '<'
    ParentShowHint = False
    ShowHint = True
    OnClick = Ofunk
  end
  object SBa30: TSpeedButton
    Left = 504
    Top = 584
    Width = 13
    Height = 17
    Caption = '0'
    Margin = 1
    ParentShowHint = False
    ShowHint = True
    OnClick = Ofunk
  end
  object SBa3R: TSpeedButton
    Left = 518
    Top = 584
    Width = 15
    Height = 17
    Caption = '>'
    ParentShowHint = False
    ShowHint = True
    OnClick = Ofunk
  end
  object Label10: TLabel
    Left = 416
    Top = 602
    Width = 24
    Height = 13
    Caption = 'add4'
  end
  object SBa4L: TSpeedButton
    Left = 488
    Top = 602
    Width = 15
    Height = 17
    Caption = '<'
    ParentShowHint = False
    ShowHint = True
    OnClick = Ofunk
  end
  object SBa40: TSpeedButton
    Left = 504
    Top = 602
    Width = 13
    Height = 17
    Caption = '0'
    Margin = 1
    ParentShowHint = False
    ShowHint = True
    OnClick = Ofunk
  end
  object SBa4R: TSpeedButton
    Left = 518
    Top = 602
    Width = 15
    Height = 17
    Caption = '>'
    ParentShowHint = False
    ShowHint = True
    OnClick = Ofunk
  end
  object Label12: TLabel
    Left = 406
    Top = 512
    Width = 35
    Height = 13
    Caption = 'direct 1'
  end
  object Label13: TLabel
    Left = 406
    Top = 532
    Width = 35
    Height = 13
    Caption = 'direct 2'
  end
  object SBd1L: TSpeedButton
    Left = 488
    Top = 512
    Width = 15
    Height = 17
    Caption = '<'
    ParentShowHint = False
    ShowHint = True
    OnClick = Ofunk
  end
  object SBd2L: TSpeedButton
    Left = 488
    Top = 530
    Width = 15
    Height = 17
    Caption = '<'
    ParentShowHint = False
    ShowHint = True
    OnClick = Ofunk
  end
  object SBd10: TSpeedButton
    Left = 504
    Top = 512
    Width = 13
    Height = 17
    Caption = '0'
    Margin = 1
    ParentShowHint = False
    ShowHint = True
    OnClick = Ofunk
  end
  object SBd20: TSpeedButton
    Left = 504
    Top = 530
    Width = 13
    Height = 17
    Caption = '0'
    Margin = 1
    ParentShowHint = False
    ShowHint = True
    OnClick = Ofunk
  end
  object SBd1R: TSpeedButton
    Left = 518
    Top = 512
    Width = 15
    Height = 17
    Caption = '>'
    ParentShowHint = False
    ShowHint = True
    OnClick = Ofunk
  end
  object SBd2R: TSpeedButton
    Left = 518
    Top = 530
    Width = 15
    Height = 17
    Caption = '>'
    ParentShowHint = False
    ShowHint = True
    OnClick = Ofunk
  end
  object SBsedit: TSpeedButton
    Left = 596
    Top = 538
    Width = 41
    Height = 19
    Hint = 't'
    Caption = 'edit'
    ParentShowHint = False
    ShowHint = True
    OnClick = Sfunc
  end
  object Lcms: TLabel
    Left = 82
    Top = 478
    Width = 3
    Height = 13
  end
  object hbar: TScrollBar
    Left = 1
    Top = 404
    Width = 639
    Height = 16
    PageSize = 0
    TabOrder = 0
    OnChange = boxPaint
  end
  object vbar: TScrollBar
    Left = 645
    Top = 1
    Width = 16
    Height = 400
    Kind = sbVertical
    PageSize = 0
    TabOrder = 1
    OnChange = boxPaint
  end
  object Lo: TStaticText
    Left = 230
    Top = 474
    Width = 41
    Height = 17
    Alignment = taRightJustify
    AutoSize = False
    BevelKind = bkSoft
    Caption = '0'
    TabOrder = 2
  end
  object Lno: TStaticText
    Left = 284
    Top = 474
    Width = 41
    Height = 17
    Alignment = taRightJustify
    AutoSize = False
    BevelKind = bkSoft
    Caption = '0'
    TabOrder = 3
  end
  object Lsp: TStaticText
    Left = 542
    Top = 474
    Width = 41
    Height = 17
    Alignment = taRightJustify
    AutoSize = False
    BevelKind = bkSoft
    Caption = '0'
    TabOrder = 4
  end
  object Lnsp: TStaticText
    Left = 596
    Top = 474
    Width = 41
    Height = 17
    Alignment = taRightJustify
    AutoSize = False
    BevelKind = bkSoft
    Caption = '0'
    TabOrder = 5
  end
  object RBdraw: TRadioButton
    Left = 80
    Top = 504
    Width = 107
    Height = 17
    Caption = 'draw map'
    Checked = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 6
    TabStop = True
  end
  object RBselo: TRadioButton
    Left = 80
    Top = 572
    Width = 105
    Height = 17
    Caption = 'select obj'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 7
  end
  object RBseto: TRadioButton
    Left = 80
    Top = 550
    Width = 111
    Height = 17
    Caption = 'set object'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 8
  end
  object Lox: TStaticText
    Left = 346
    Top = 476
    Width = 45
    Height = 17
    Alignment = taRightJustify
    AutoSize = False
    BevelKind = bkSoft
    Caption = '0'
    TabOrder = 9
  end
  object Loy: TStaticText
    Left = 346
    Top = 496
    Width = 45
    Height = 17
    Alignment = taRightJustify
    AutoSize = False
    BevelKind = bkSoft
    Caption = '0'
    TabOrder = 10
  end
  object Lt: TEdit
    Left = 444
    Top = 548
    Width = 41
    Height = 21
    TabOrder = 15
    OnChange = LabelChange
  end
  object Lxs: TEdit
    Left = 444
    Top = 476
    Width = 41
    Height = 21
    TabOrder = 11
    OnChange = LabelChange
  end
  object Lys: TEdit
    Left = 444
    Top = 494
    Width = 41
    Height = 21
    TabOrder = 12
    OnChange = LabelChange
  end
  object La2: TEdit
    Left = 444
    Top = 566
    Width = 41
    Height = 21
    TabOrder = 16
    OnChange = LabelChange
  end
  object La3: TEdit
    Left = 444
    Top = 584
    Width = 41
    Height = 21
    TabOrder = 17
    OnChange = LabelChange
  end
  object La4: TEdit
    Left = 444
    Top = 602
    Width = 41
    Height = 21
    TabOrder = 18
    OnChange = LabelChange
  end
  object Ld1: TEdit
    Left = 444
    Top = 512
    Width = 41
    Height = 21
    TabOrder = 13
    OnChange = LabelChange
  end
  object Ld2: TEdit
    Left = 444
    Top = 530
    Width = 41
    Height = 19
    TabOrder = 14
    OnChange = LabelChange
  end
  object MainMenu1: TMainMenu
    Left = 170
    Top = 118
    object MMfile: TMenuItem
      Caption = 'file'
      OnClick = MMfunc
      object MMloadmap: TMenuItem
        Caption = 'load map'
        OnClick = MMfunc
      end
      object MMsavemap: TMenuItem
        Caption = 'save map'
        OnClick = MMfunc
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object MMloadMS: TMenuItem
        Caption = 'load map-sprites'
        OnClick = MMfunc
      end
      object MMsaveMS: TMenuItem
        Caption = 'save map-sprites'
        OnClick = MMfunc
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object MMloadspr: TMenuItem
        Caption = 'load sprites'
        OnClick = MMfunc
      end
      object MMsavespr: TMenuItem
        Caption = 'save sprites'
        OnClick = MMfunc
      end
      object N3: TMenuItem
        Caption = '-'
      end
      object MMsaveall: TMenuItem
        Caption = 'save all'
        OnClick = MMfunc
      end
      object N5: TMenuItem
        Caption = '-'
      end
      object MMexit: TMenuItem
        Caption = 'exit'
        OnClick = MMfunc
      end
    end
    object map1: TMenuItem
      Caption = 'map'
      object MMdrawboarder: TMenuItem
        Caption = 'draw boarder'
        OnClick = MMapfunk
      end
      object MMresizemap: TMenuItem
        Caption = 'resize ...'
        OnClick = MMapfunk
      end
      object N4: TMenuItem
        Caption = '-'
      end
      object MMnewmap: TMenuItem
        Caption = '!! new !!'
        OnClick = MMapfunk
      end
    end
    object MMmapsprites: TMenuItem
      Caption = 'mapsprites'
      object N7: TMenuItem
        Caption = '-'
      end
      object MMnewMS: TMenuItem
        Caption = 'new'
        OnClick = MSfunc
      end
    end
    object MMobjects: TMenuItem
      Caption = 'objects'
      object N6: TMenuItem
        Caption = '-'
      end
      object MMnewobj: TMenuItem
        Caption = 'new'
        OnClick = Ofunk
      end
    end
  end
  object loaddia: TOpenDialog
    Left = 84
    Top = 118
  end
  object savedia: TSaveDialog
    Filter = '*.*|*.*'
    Left = 120
    Top = 118
  end
end
