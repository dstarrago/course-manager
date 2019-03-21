object CursosForm: TCursosForm
  Left = 0
  Top = 0
  Width = 412
  Height = 283
  TabOrder = 0
  Visible = False
  object StringGrid1: TStringGrid
    Left = 0
    Top = 0
    Width = 412
    Height = 283
    Align = alClient
    DefaultRowHeight = 16
    RowCount = 1
    FixedRows = 0
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing, goEditing, goTabs]
    ParentFont = False
    TabOrder = 0
    OnGetEditMask = StringGrid1GetEditMask
    OnSetEditText = StringGrid1SetEditText
  end
end
