�
 TPACKEDDATA 04
  TPF0TPackedData
PackedDataLeft#TopgBorderStylebsDialogCaptionPacked DataClientHeight� ClientWidth�
Font.ColorclWindowTextFont.Height�	Font.NameSystem
Font.Style PixelsPerInch`
TextHeight 	TGroupBoxBoundingBoxLeft Top Width�Height� Caption+Packed Data (Date Example from Chapter One)TabOrder OnClickBoundingBoxClick TLabelMonthLblLeft� Top Width(HeightCaptionMonth  TLabelDayLblLeft Top WidthHeightCaptionDay  TLabelYearLblLeft`Top WidthHeightCaptionYear  TLabelDataPackLblLeftTopPWidthYHeightCaptionData To Pack:  TLabel
DecimalLblLefthTop8Width9HeightCaptionDecimal:  TLabel	BinaryLblLeftpTop`Width/HeightCaptionBinary:  TLabel
PackResLblLeftTop� WidthaHeightCaptionPacked Result:  TEditMonthBinLeft� TopYWidth1HeightHint0Enter a binary value between 0001 and 1100 here.
Font.ColorclBlackFont.Height�	Font.NameSystem
Font.StylefsBold 	MaxLength
ParentFontParentShowHintShowHint	TabOrder Text0001OnKeyUpMonthBinKeyUp  TButtonExitBtnLeft�Top� WidthAHeightCaptionQuitTabOrderOnClickExitBtnClick  TButtonAboutBtnLeftTop� WidthAHeightCaptionAboutTabOrderOnClickAboutBtnClick  TEditDayBinLeft� TopYWidth9HeightHint+Enter a binary value between 0 and 31 here.
Font.ColorclBlackFont.Height�	Font.NameSystem
Font.StylefsBold 	MaxLength
ParentFontParentShowHintShowHint	TabOrderText0 0001OnKeyUpDayBinKeyUp  TEditYearBinLeftXTopYWidthIHeightHint+Enter a binary value between 0 and 99 here.
Font.ColorclBlackFont.Height�	Font.NameSystem
Font.StylefsBold 	MaxLength
ParentFontParentShowHintShowHint	TabOrderText110 0000OnKeyUpYearBinKeyUp  TEditMonthDecLeft� Top8Width1HeightHint+Enter a decimal number between 1 & 12 here.	MaxLengthParentShowHintShowHint	TabOrderText1OnKeyUpMonthDecKeyUp  TEditDayDecLeft� Top8Width9HeightHint+Enter a decimal number between 1 & 31 here.	MaxLengthParentShowHintShowHint	TabOrderText1OnKeyUpDayDecKeyUp  TEditYearDecLeftXTop8WidthIHeightHint-Enter a decimal number between 0 and 99 here.	MaxLengthParentShowHintShowHint	TabOrderText96OnKeyUpYearDecKeyUp  TPanelPanel1Left� Top� Width	Height1TabOrder TLabel	BinResultLeftTopWidth� HeightCaption	BinResultColorclWhiteParentColor  TLabel	HexResultLeft� TopWidthDHeightCaption	HexResultColorclWhiteParentColor     