unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, Menus, ExtCtrls, inEstud, inCursos, ComCtrls, Kernel,
  ActnList, ImgList, ToolWin;

type
  TMyTabSheet = class(TTabSheet)
  private
    function GetPageControl: TPageControl;
    procedure SetPageControl(const Value: TPageControl);
  public
    Estudiantes: TEstudiantesForm;
    property PageControl: TPageControl read GetPageControl write SetPageControl;
    destructor Destroy; override;
  end;

  TMainForm = class(TForm)
    MainMenu1: TMainMenu;
    Archivo1: TMenuItem;
    Ver1: TMenuItem;
    N1: TMenuItem;
    Nuevo1: TMenuItem;
    Importar1: TMenuItem;
    Exportar1: TMenuItem;
    N2: TMenuItem;
    Salir1: TMenuItem;
    Acercade1: TMenuItem;
    Estudiantes1: TMenuItem;
    Cursos1: TMenuItem;
    SaveDialog1: TSaveDialog;
    OpenDialog1: TOpenDialog;
    Reportes1: TMenuItem;
    Repartos: TMenuItem;
    Cursos2: TMenuItem;
    Estudiantes2: TMenuItem;
    StatusBar1: TStatusBar;
    ActionList1: TActionList;
    acNuevo: TAction;
    acImportar: TAction;
    acExportar: TAction;
    acSalir: TAction;
    acCursos: TAction;
    acEstudiantes: TAction;
    acRepartos: TAction;
    acVerCursos: TAction;
    acVerEstudiantes: TAction;
    acAcerca: TAction;
    ImageList1: TImageList;
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    ToolButton7: TToolButton;
    ToolButton8: TToolButton;
    ToolButton9: TToolButton;
    ToolButton10: TToolButton;
    procedure Nuevo1Click(Sender: TObject);
    procedure Salir1Click(Sender: TObject);
    procedure Cursos1Click(Sender: TObject);
    procedure Estudiantes1Click(Sender: TObject);
    procedure Exportar1Click(Sender: TObject);
    procedure Importar1Click(Sender: TObject);
    procedure RepartosClick(Sender: TObject);
    procedure Cursos2Click(Sender: TObject);
    procedure Estudiantes2Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Acercade1Click(Sender: TObject);
  private
    DocOpened: boolean;
    Built: boolean;
    PrimeraVez: boolean;
    procedure NewDoc;
    procedure CloseDoc;
    procedure InitializeGroups;
    procedure SaveData(const AFileName: TFileName);
    procedure OpenData(const AFileName: TFileName);
    procedure SaveEstudiantesData(S: TStream);
    procedure OpenEstudiantesData(S: TStream);
    procedure Build;
    procedure ShowResult;
    procedure ShowCursos;
    procedure ShowEstudiantes;
  public
    Cursos: TCursosForm;
    Grupos: TPageControl;
    CursosList: TCursos;
    EstudiantesList: TEstudiantes;
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

uses InfGral, UnitDB, rpReparto, rpCursos, rpEstudiantes, About;

{ TMyTabSheet }

destructor TMyTabSheet.Destroy;
begin
  Estudiantes.Free;
  inherited;
end;

function TMyTabSheet.GetPageControl: TPageControl;
begin
  Result := inherited PageControl;
end;

procedure TMyTabSheet.SetPageControl(const Value: TPageControl);
begin
  inherited PageControl := Value;
  Estudiantes := TEstudiantesForm.Create(Self);
  try
    Estudiantes.Name := 'ef' + IntToStr(PageIndex);
    InsertControl(Estudiantes);
    with Estudiantes do
      begin
        Align := alClient;
        Year := InfGralForm.EditYear.Value;
        Group := succ(PageIndex);
        Instituto.Caption := InfGralForm.EditInstituto.Text;
        Curso.Caption := InfGralForm.EditCurso.Text;
        Carrera.Caption := InfGralForm.EditCarrera.Text;
      end;
    Estudiantes.Initialize;
  except
    raise;
  end;
end;

{ TMainForm }

procedure TMainForm.Nuevo1Click(Sender: TObject);
var
  Abort: boolean;
begin
  Abort := false;
  PrimeraVez := false;
  if DocOpened and (MessageDlg('Esta acción eliminara los datos actuales' + #13 + '¿Desea proseguir?', mtWarning, [mbYes, mbNo], 0) = mrNo)
    then Abort := true;
  if not Abort and (InfGralForm.ShowModal = mrOk)
    then NewDoc;
end;

procedure TMainForm.Salir1Click(Sender: TObject);
begin
  close;
end;

procedure TMainForm.Cursos1Click(Sender: TObject);
begin
  if DocOpened
    then
      begin
        Cursos.Visible := true;
        Cursos1.Checked := true;
        Grupos.Visible := false;
        Estudiantes1.Checked := false;
      end
    else MessageDlg('No existe documento para editar', mtInformation, [mbOk], 0);
end;

procedure TMainForm.Estudiantes1Click(Sender: TObject);
begin
  if DocOpened
    then
      begin
        Cursos.Visible := false;
        Cursos1.Checked := false;
        Grupos.Visible := true;
        Estudiantes1.Checked := true;
      end
    else MessageDlg('No existe documento para editar', mtInformation, [mbOk], 0);
end;

procedure TMainForm.CloseDoc;
begin
  RemoveControl(Cursos);
  Cursos.Free;
  RemoveControl(Grupos);
  Grupos.Free;
  DocOpened := false;
  Cursos1.Checked := true;
  Estudiantes1.Checked := false;
end;

procedure TMainForm.NewDoc;
begin
  if DocOpened
    then CloseDoc;
  Cursos := TCursosForm.Create(Self);
  Grupos := TPageControl.Create(Self);
  try
    InsertControl(Cursos);
    InsertControl(Grupos);
    Cursos.Initialize;
    InitializeGroups;
    DocOpened := true;
    Cursos1Click(Self);
  except
    raise;
  end;
end;

procedure TMainForm.InitializeGroups;
var
  i: integer;
  NewTabSheet: TMyTabSheet;
begin
  for i := 1 to InfGralForm.EditGroup.Value do
    begin
      NewTabSheet := TMyTabSheet.Create(Grupos);
      try
        NewTabSheet.PageControl := Grupos;
        NewTabSheet.Name := 'tsGrupo' + IntToStr(i);
        NewTabSheet.Caption := 'Grupo ' + IntToStr(i);
      except
        raise;
      end;
    end;
  Grupos.Align := alClient;
end;

procedure TMainForm.SaveData(const AFileName: TFileName);
var
  S: TFileStream;
begin
  S := TFileStream.Create(AFileName, fmCreate);
  try
    InfGralForm.SaveData(S);
    Cursos.SaveData(S);
    SaveEstudiantesData(S);
  finally
    S.Free;
  end;
end;

procedure TMainForm.OpenData(const AFileName: TFileName);
var
  S: TFileStream;
begin
  S := TFileStream.Create(AFileName, fmOpenRead);
  try
    InfGralForm.OpenData(S);
    NewDoc;
    Cursos.OpenData(S);
    OpenEstudiantesData(S);
  finally
    S.Free;
  end;
end;

procedure TMainForm.Exportar1Click(Sender: TObject);
begin
  if not DocOpened
    then MessageDlg('No existe documento para exportar', mtInformation, [mbOk], 0)
    else
      if SaveDialog1.Execute
        then SaveData(SaveDialog1.FileName);
end;

procedure TMainForm.Importar1Click(Sender: TObject);
begin
  if OpenDialog1.Execute
    then
      if not DocOpened
        then OpenData(OpenDialog1.FileName)
        else
          if MessageDlg('Esta acción eliminara los datos actuales' + #13 + '¿Desea proseguir?', mtWarning, [mbYes, mbNo], 0) = mrYes
            then OpenData(OpenDialog1.FileName);
end;

procedure TMainForm.OpenEstudiantesData(S: TStream);
var
  i: integer;
begin
  for i := 0 to pred(Grupos.PageCount) do
    TMyTabSheet(Grupos.Pages[i]).Estudiantes.OpenData(S);
end;

procedure TMainForm.SaveEstudiantesData(S: TStream);
var
  i: integer;
begin
  for i := 0 to pred(Grupos.PageCount) do
    TMyTabSheet(Grupos.Pages[i]).Estudiantes.SaveData(S);
end;

procedure TMainForm.Build;
var
  i: integer;
begin
  Built := false;
  CursosList.Free;
  EstudiantesList.Free;
  CursosList := TCursos.Create(Cursos.StringGrid1);
  EstudiantesList := TEstudiantes.Create;
  if Cursos.Build(CursosList)
    then
      begin
        i := 0;
        while (i < Grupos.PageCount)
          and TMyTabSheet(Grupos.Pages[i]).Estudiantes.Build(EstudiantesList)
            do inc(i);
        if i = Grupos.PageCount
          then
            begin
              EstudiantesList.Solve(CursosList);
              Built := true;
            end;
      end;
end;

procedure TMainForm.ShowResult;
var
  i: integer;
begin
  DataModule1.TableCursos.Open;
  with DataModule1.TableCursos do
    while not IsEmpty do Delete;
  for i := 1 to CursosList.Count do
    with DataModule1.TableCursos do
      if CursosList[i].NumCursistas > 0
        then
          begin
            Append;
            FieldValues['NUM'] := i;
            FieldValues['NOMBRE'] := CursosList[i].Nombre;
            FieldValues['PLAZAS'] := CursosList[i].Matricula;
            FieldValues['OTORGADAS'] := IntToStr(CursosList[i].NumCursistas);
            FieldValues['PROFESOR'] := CursosList[i].Profesor;
            FieldValues['LUGAR'] := CursosList[i].Lugar;
            Post;
          end;
  DataModule1.TableCursos.Close;
  // Actualizar la Tabla Estudiantes
  DataModule1.TableEstudiantes.Open;
  with DataModule1.TableEstudiantes do
    while not IsEmpty do Delete;
  for i := 0 to pred(EstudiantesList.Count) do
    with DataModule1.TableEstudiantes do
      begin
        Append;
        FieldValues['NRO'] := EstudiantesList[i].Numero;
        FieldValues['NOMBRE'] := EstudiantesList[i].Nombre;
        FieldValues['PROMEDIO'] := EstudiantesList[i].Promedio;
        FieldValues['GRUPO'] := EstudiantesList[i].Grupo;
        FieldValues['CURSO'] := EstudiantesList[i].Curso;
        Post;
      end;
  DataModule1.TableEstudiantes.Close;
  // Actualizar la Tabla SinPlazas
  DataModule1.TableSinPlaza.Open;
  with DataModule1.TableSinPlaza do
    while not IsEmpty do Delete;
  for i := 0 to pred(EstudiantesList.SinPlazaCount) do
    with DataModule1.TableSinPlaza do
      begin
        Append;
        FieldValues['GRUPO'] := EstudiantesList.SinPlaza[i].Grupo;
        FieldValues['NRO'] := EstudiantesList.SinPlaza[i].Numero;
        FieldValues['NOMBRE'] := EstudiantesList.SinPlaza[i].Nombre;
        FieldValues['PROMEDIO'] := EstudiantesList.SinPlaza[i].Promedio;
        FieldValues['OPC1'] := InttoStr(EstudiantesList.SinPlaza[i].Opciones[1]);
        FieldValues['OPC2'] := InttoStr(EstudiantesList.SinPlaza[i].Opciones[2]);
        FieldValues['OPC3'] := InttoStr(EstudiantesList.SinPlaza[i].Opciones[3]);
        FieldValues['OPC4'] := InttoStr(EstudiantesList.SinPlaza[i].Opciones[4]);
        FieldValues['OPC5'] := InttoStr(EstudiantesList.SinPlaza[i].Opciones[5]);
        FieldValues['OPC6'] := InttoStr(EstudiantesList.SinPlaza[i].Opciones[6]);
        Post;
      end;
  DataModule1.TableEstudiantes.Close;
  MDForm.QuickRep.Preview;
end;

procedure TMainForm.RepartosClick(Sender: TObject);
begin
  if DocOpened
    then
      begin
        if not Built then Build;
        ShowResult;
      end
    else MessageDlg('No existe documento abierto', mtInformation, [mbOk], 0);
end;

procedure TMainForm.Cursos2Click(Sender: TObject);
begin
  if DocOpened
    then
      begin
        if not Built then Build;
        ShowCursos;
      end
    else MessageDlg('No existe documento abierto', mtInformation, [mbOk], 0);
end;

procedure TMainForm.ShowCursos;
var
  i: integer;
begin
  DataModule1.TableCursos.Open;
  with DataModule1.TableCursos do
    while not IsEmpty do Delete;
  for i := 1 to CursosList.Count do
    with DataModule1.TableCursos do
      begin
        Append;
        FieldValues['NUM'] := i;
        FieldValues['NOMBRE'] := CursosList[i].Nombre;
        FieldValues['PLAZAS'] := CursosList[i].Matricula;
        FieldValues['OTORGADAS'] := IntToStr(CursosList[i].NumCursistas);
        FieldValues['PROFESOR'] := CursosList[i].Profesor;
        FieldValues['LUGAR'] := CursosList[i].Lugar;
        Post;
      end;
  DataModule1.TableCursos.Close;
  fmCursos.Ano.Caption := InfGralForm.EditYear.Text + 'º';
  fmCursos.Carrera.Caption := InfGralForm.EditCarrera.Text;
  fmCursos.QuickRep1.Preview;
end;

procedure TMainForm.ShowEstudiantes;
var
  i,j: integer;
begin
  DataModule1.TableEstudiantes.Open;
  with DataModule1.TableEstudiantes do
    while not IsEmpty do Delete;
  for i := 0 to pred(EstudiantesList.Count) do
    with DataModule1.TableEstudiantes do
      begin
        Append;
        FieldValues['NRO'] := EstudiantesList[i].Numero;
        FieldValues['NOMBRE'] := EstudiantesList[i].Nombre;
        FieldValues['PROMEDIO'] := EstudiantesList[i].Promedio;
        FieldValues['GRUPO'] := EstudiantesList[i].Grupo;
        FieldValues['CURSO'] := EstudiantesList[i].Curso;
        for j := 1 to 6 do
          Fields[4 + j].AsString := IntToStr(EstudiantesList[i].Opciones[j]);
        Post;
      end;
  DataModule1.TableEstudiantes.Close;
  // Actualizar la Tabla Grupos
  DataModule1.TableGrupos.Open;
  with DataModule1.TableGrupos do
    while not IsEmpty do Delete;
  for i := 0 to pred(Grupos.PageCount) do
    with DataModule1.TableGrupos do
      begin
        Append;
        FieldValues['NUM'] := IntToStr(succ(i));
        FieldValues['HOSPITAL'] := TMyTabSheet(Grupos.Pages[i]).Estudiantes.Hospital.Text;
        FieldValues['MUNICIPIOS'] := TMyTabSheet(Grupos.Pages[i]).Estudiantes.Municipios.Text;
        Post;
      end;
  DataModule1.TableGrupos.Close;
  fmEstudiantes.Ano.Caption := InfGralForm.EditYear.Text + 'º';
  fmEstudiantes.Carrera.Caption := InfGralForm.EditCarrera.Text;
  fmEstudiantes.Instituto.Caption := InfGralForm.EditInstituto.Text;
  fmEstudiantes.Curso.Caption := InfGralForm.EditCurso.Text;
  fmEstudiantes.QuickRep1.Preview;
end;

procedure TMainForm.Estudiantes2Click(Sender: TObject);
begin
  if DocOpened
    then
      begin
        if not Built then Build;
        ShowEstudiantes;
      end
    else MessageDlg('No existe documento abierto', mtInformation, [mbOk], 0);
end;

procedure TMainForm.FormActivate(Sender: TObject);
begin
  if PrimeraVez then Nuevo1Click(Self);
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  PrimeraVez := true;
end;

procedure TMainForm.Acercade1Click(Sender: TObject);
begin
  fmAbout.ShowModal;
end;

end.
