unit rpEstudiantes;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, QuickRpt, QRCtrls, DB, DBTables, ExtCtrls;

type
  TfmEstudiantes = class(TForm)
    QuickRep1: TQuickRep;
    TableEstudiantes: TTable;
    QRBand1: TQRBand;
    Instituto: TQRLabel;
    Ano: TQRLabel;
    QRLabel1: TQRLabel;
    Carrera: TQRLabel;
    Curso: TQRLabel;
    QRLabel2: TQRLabel;
    TableGrupos: TTable;
    QRBand2: TQRBand;
    QRLabel3: TQRLabel;
    QRDBText1: TQRDBText;
    QRLabel4: TQRLabel;
    QRDBText2: TQRDBText;
    QRDBText3: TQRDBText;
    QRLabel5: TQRLabel;
    QRLabel6: TQRLabel;
    QRLabel7: TQRLabel;
    QRLabel8: TQRLabel;
    QRLabel9: TQRLabel;
    QRLabel10: TQRLabel;
    QRLabel11: TQRLabel;
    QRLabel12: TQRLabel;
    QRLabel13: TQRLabel;
    DataSource1: TDataSource;
    QRSubDetail1: TQRSubDetail;
    QRDBText13: TQRDBText;
    QRDBText14: TQRDBText;
    QRDBText15: TQRDBText;
    QRDBText16: TQRDBText;
    QRDBText17: TQRDBText;
    QRDBText18: TQRDBText;
    QRDBText19: TQRDBText;
    QRDBText20: TQRDBText;
    QRDBText21: TQRDBText;
    ChildBand1: TQRChildBand;
    PageFooterBand1: TQRBand;
    QRSysData1: TQRSysData;
    QRSysData2: TQRSysData;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmEstudiantes: TfmEstudiantes;

implementation

{$R *.dfm}

end.
