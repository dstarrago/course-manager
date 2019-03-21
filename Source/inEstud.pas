unit inEstud;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids, ExtCtrls, StdCtrls, Spin, ComCtrls, Kernel;

type
  TEstudiantesForm = class(TFrame)
    StringGrid1: TStringGrid;
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label7: TLabel;
    Instituto: TLabel;
    Carrera: TLabel;
    Curso: TLabel;
    Ano: TLabel;
    Hospital: TEdit;
    Municipios: TEdit;
    procedure StringGrid1SetEditText(Sender: TObject; ACol, ARow: Integer;
      const Value: String);
    procedure StringGrid1GetEditMask(Sender: TObject; ACol, ARow: Integer;
      var Value: String);
  private
    FYear: integer;
    FGroup: integer;
    procedure ExtendEdition;
    procedure SetYear(const Value: integer);
    procedure SetGroup(const Value: integer);
  public
    property Year: integer read FYear write SetYear;
    property Group: integer read FGroup write SetGroup;
    procedure Initialize;
    procedure SaveData(S: TStream);
    procedure OpenData(S: TStream);
    function Build(Estudiantes: TEstudiantes): boolean;
  end;

implementation

{$R *.dfm}

uses Main;

const
  EditInterval = 20;

procedure TEstudiantesForm.ExtendEdition;
var
  i: integer;
  Base: integer;
begin
  Base := Year * 1000 + Group * 100;
  StringGrid1.RowCount := StringGrid1.RowCount + EditInterval;
  for i := StringGrid1.RowCount - EditInterval to StringGrid1.RowCount do
    StringGrid1.Cells[0,i] := IntToStr(Base + i);
end;

procedure TEstudiantesForm.Initialize;
begin
  ExtendEdition;
  StringGrid1.FixedRows := 1;
  StringGrid1.ColWidths[0] := 40;
  StringGrid1.ColWidths[1] := 200;
  StringGrid1.ColWidths[2] := 50;
  StringGrid1.Cells[0,0]   := 'Nro';
  StringGrid1.Cells[1,0]   := 'Apellidos y Nombres';
  StringGrid1.Cells[2,0]   := 'Promedio';
  StringGrid1.Cells[3,0]   := '1';
  StringGrid1.Cells[4,0]   := '2';
  StringGrid1.Cells[5,0]   := '3';
  StringGrid1.Cells[6,0]   := '4';
  StringGrid1.Cells[7,0]   := '5';
  StringGrid1.Cells[8,0]   := '6';
end;

procedure TEstudiantesForm.StringGrid1SetEditText(Sender: TObject; ACol,
  ARow: Integer; const Value: String);
begin
  if ARow = pred(StringGrid1.RowCount)
    then ExtendEdition;
end;

procedure TEstudiantesForm.StringGrid1GetEditMask(Sender: TObject; ACol,
  ARow: Integer; var Value: String);
begin
  case Acol of
    0: Value := '0000';
    1: Value := '';
    2: Value := '0.00';
    else
       Value := '0000';
  end;
end;

procedure TEstudiantesForm.SetYear(const Value: integer);
begin
  FYear := Value;
  Ano.Caption := IntToStr(FYear) + 'º';
end;

procedure TEstudiantesForm.SetGroup(const Value: integer);
begin
  FGroup := Value;
end;

procedure TEstudiantesForm.OpenData(S: TStream);
var
  i,j: integer;
  Reader: TReader;
begin
  Reader := TReader.Create(S, 10);
  try
    Hospital.Text := Reader.ReadString;
    Municipios.Text := Reader.ReadString;
    StringGrid1.RowCount := Reader.ReadInteger;
    for i := 0 to pred(StringGrid1.RowCount) do
      for j := 0 to pred(StringGrid1.ColCount) do
        StringGrid1.Cells[j, i] := Reader.ReadString;
  finally
    Reader.Free;
  end;
end;

procedure TEstudiantesForm.SaveData(S: TStream);
var
  i,j: integer;
  Writer: TWriter;
begin
  Writer := TWriter.Create(S, 10);
  try
    Writer.WriteString(Hospital.Text);
    Writer.WriteString(Municipios.Text);
    Writer.WriteInteger(StringGrid1.RowCount);
    for i := 0 to pred(StringGrid1.RowCount) do
      for j := 0 to pred(StringGrid1.ColCount) do
        Writer.WriteString(StringGrid1.Cells[j, i]);
  finally
    Writer.Free;
  end;
end;

function TEstudiantesForm.Build(Estudiantes: TEstudiantes): boolean;
var
  i: integer;
begin
  Result := false;
  for i := 1 to pred(StringGrid1.RowCount) do
    begin
      if (TrimRight(StringGrid1.Cells[1, i]) = '') and (TrimRight(StringGrid1.Cells[2, i]) <> '')
        then
          begin
            MainForm.Grupos.ActivePageIndex := pred(Group);
            StringGrid1.Col := 1;
            StringGrid1.Row := i;
            MainForm.Estudiantes1Click(Self);
            MessageDlg('Debe escribir el nombre del estudiante', mtError, [mbOk], 0);
            exit;
          end;
      if (TrimRight(StringGrid1.Cells[1, i]) <> '')
        and ((TrimRight(StringGrid1.Cells[2, i]) = '') or (StringGrid1.Cells[2, i] = ' .  '))
        then
          begin
            MainForm.Grupos.ActivePageIndex := pred(Group);
            StringGrid1.Col := 2;
            StringGrid1.Row := i;
            MainForm.Estudiantes1Click(Self);
            MessageDlg('Debe escribir el promedio', mtError, [mbOk], 0);
            exit;
          end;
      if (TrimRight(StringGrid1.Cells[1, i]) <> '') and (TrimRight(StringGrid1.Cells[2, i]) <> '')
        then Estudiantes.AddEstudiante(StringGrid1, i, Group);
    end;
  Result := true;
end;

end.
