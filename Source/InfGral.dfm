object InfGralForm: TInfGralForm
  Left = 219
  Top = 177
  Width = 430
  Height = 189
  Caption = 'Nuevo Reparto de Tiempos Electivos'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel1: TBevel
    Left = 8
    Top = 8
    Width = 409
    Height = 112
    Shape = bsFrame
  end
  object Label1: TLabel
    Left = 19
    Top = 28
    Width = 37
    Height = 13
    Caption = 'Instituto'
  end
  object Label4: TLabel
    Left = 29
    Top = 92
    Width = 27
    Height = 13
    Caption = 'Curso'
  end
  object Label2: TLabel
    Left = 22
    Top = 60
    Width = 34
    Height = 13
    Caption = 'Carrera'
  end
  object Label5: TLabel
    Left = 298
    Top = 28
    Width = 19
    Height = 13
    Caption = 'A'#241'o'
  end
  object Label6: TLabel
    Left = 273
    Top = 60
    Width = 44
    Height = 13
    Caption = '# Grupos'
  end
  object EditInstituto: TEdit
    Left = 64
    Top = 24
    Width = 185
    Height = 21
    TabOrder = 0
    Text = 'ISCM-VC'
  end
  object EditCurso: TEdit
    Left = 64
    Top = 88
    Width = 80
    Height = 21
    TabOrder = 2
    Text = '2000-2001'
  end
  object EditCarrera: TEdit
    Left = 64
    Top = 56
    Width = 185
    Height = 21
    TabOrder = 1
    Text = 'Medicina'
  end
  object EditYear: TSpinEdit
    Left = 323
    Top = 24
    Width = 80
    Height = 22
    MaxValue = 6
    MinValue = 1
    TabOrder = 3
    Value = 1
  end
  object EditGroup: TSpinEdit
    Left = 323
    Top = 56
    Width = 80
    Height = 22
    MaxValue = 99
    MinValue = 1
    TabOrder = 4
    Value = 1
  end
  object BitBtn1: TBitBtn
    Left = 88
    Top = 128
    Width = 80
    Height = 25
    Caption = 'Aceptar'
    TabOrder = 5
    OnClick = BitBtn1Click
    Kind = bkOK
  end
  object BitBtn2: TBitBtn
    Left = 184
    Top = 128
    Width = 80
    Height = 25
    Caption = 'Cancelar'
    TabOrder = 6
    Kind = bkCancel
  end
  object BitBtn3: TBitBtn
    Left = 280
    Top = 128
    Width = 80
    Height = 25
    Caption = '&Ayuda'
    TabOrder = 7
    Kind = bkHelp
  end
end
