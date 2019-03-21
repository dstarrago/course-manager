unit UnitDB;

interface

uses
  SysUtils, Classes, DB, DBTables;

type
  TDataModule1 = class(TDataModule)
    TableCursos: TTable;
    TableEstudiantes: TTable;
    TableGrupos: TTable;
    TableSinPlaza: TTable;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DataModule1: TDataModule1;

implementation

{$R *.dfm}

end.
