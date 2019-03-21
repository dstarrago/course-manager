unit inCursos;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids, Kernel;

type
  TCursosForm = class(TFrame)
    StringGrid1: TStringGrid;
    procedure StringGrid1SetEditText(Sender: TObject; ACol, ARow: Integer;
      const Value: String);
    procedure StringGrid1GetEditMask(Sender: TObject; ACol, ARow: Integer;
      var Value: String);
  private
    { Private declarations }
    procedure ExtendEdition;
  public
    { Public declarations }
    procedure Initialize;
    procedure SaveData(S: TStream);
    procedure OpenData(S: TStream);
    function Build(Cursos: TCursos): boolean;
  end;

implementation

{$R *.dfm}

uses Main;

const
  EditInterval = 20;

{ TFrame1 }

procedure TCursosForm.ExtendEdition;
var
  i: integer;
begin
  StringGrid1.RowCount := StringGrid1.RowCount + EditInterval;
  for i := StringGrid1.RowCount - EditInterval to StringGrid1.RowCount do
    StringGrid1.Cells[0,i] := IntToStr(i);
end;

procedure TCursosForm.Initialize;
begin
  ExtendEdition;
  StringGrid1.FixedRows := 1;
  StringGrid1.ColWidths[0] := 30;
  StringGrid1.ColWidths[1] := 200;
  StringGrid1.ColWidths[2] := 40;
  StringGrid1.ColWidths[3] := 160;
  StringGrid1.ColWidths[4] := 100;
  StringGrid1.Cells[0,0]   := 'Nro';
  StringGrid1.Cells[1,0]   := 'Curso';
  StringGrid1.Cells[2,0]   := 'Plazas';
  StringGrid1.Cells[3,0]   := 'Prof. Principal';
  StringGrid1.Cells[4,0]   := 'Lugar de Inicio';
  Align := alClient;
end;

procedure TCursosForm.StringGrid1SetEditText(Sender: TObject; ACol,
  ARow: Integer; const Value: String);
begin
  if ARow = pred(StringGrid1.RowCount)
    then ExtendEdition;
end;

procedure TCursosForm.StringGrid1GetEditMask(Sender: TObject; ACol,
  ARow: Integer; var Value: String);
begin
  if ACol = 2
    then Value := '0000';
end;

procedure TCursosForm.OpenData(S: TStream);
var
  i,j: integer;
  Reader: TReader;
begin
  Reader := TReader.Create(S, 10);
  try
    StringGrid1.RowCount := Reader.ReadInteger;
    for i := 0 to pred(StringGrid1.RowCount) do
      for j := 0 to pred(StringGrid1.ColCount) do
        StringGrid1.Cells[j, i] := Reader.ReadString;
  finally
    Reader.Free;
  end;
end;

procedure TCursosForm.SaveData(S: TStream);
var
  i,j: integer;
  Writer: TWriter;
begin
  Writer := TWriter.Create(S, 10);
  try
    Writer.WriteInteger(StringGrid1.RowCount);
    for i := 0 to pred(StringGrid1.RowCount) do
      for j := 0 to pred(StringGrid1.ColCount) do
        Writer.WriteString(StringGrid1.Cells[j, i]);
  finally
    Writer.Free;
  end;
end;

function TCursosForm.Build(Cursos: TCursos): boolean;
var
  i: integer;
begin
  Result := false;
  for i := 1 to pred(StringGrid1.RowCount) do
    begin
      if (TrimRight(StringGrid1.Cells[1, i]) = '') and (TrimRight(StringGrid1.Cells[2, i]) <> '')
        then
          begin
            StringGrid1.Col := 1;
            StringGrid1.Row := i;
            MainForm.Cursos1Click(Self);
            MessageDlg('Debe escribir el nombre del curso', mtError, [mbOk], 0);
            exit;
          end;
      if (TrimRight(StringGrid1.Cells[1, i]) <> '') and (TrimRight(StringGrid1.Cells[2, i]) = '')
        then
          begin
            StringGrid1.Col := 2;
            StringGrid1.Row := i;
            MainForm.Cursos1Click(Self);
            MessageDlg('Debe escribir el numero de plazas', mtError, [mbOk], 0);
            exit;
          end;
      if (TrimRight(StringGrid1.Cells[1, i]) <> '') and (TrimRight(StringGrid1.Cells[2, i]) <> '')
        then Cursos.AddCurso(i);
    end;
  Result := true;
end;

end.
