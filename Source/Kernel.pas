unit Kernel;

interface

uses Classes, Grids;

const
  NUM_OPCIONES = 6;

type
  TEstudiante = class;
  TCursos = class;

  TCurso = class
  private
    FStringGrid: TStringGrid;
    FItem: integer;
    FPlazas: integer;
    FNumCursistas: integer;
    //FCursistas: TList;
    function GetData: TStrings;
    function GetNombre: string;
    function GetProfesor: string;
    function GetLugar: string;
    function GetNumCursistas: integer;
    //function GetCursista(const i: integer): TEstudiante;
    function GetMatricula: string;
  public
    constructor Create(AStringGrid: TStringGrid; const Item: integer);
    destructor Destroy; override;
    function Assign(Stud: TEstudiante): boolean;
    property Data: TStrings read GetData;
    property Plazas: integer read FPlazas;  //Plazas que quedan por tomar
    property Nombre: string read GetNombre;
    property Matricula: string read GetMatricula;
    property Profesor: string read GetProfesor;
    property Lugar: string read GetLugar;
    property NumCursistas: integer read GetNumCursistas;
    //property Cursista[const i: integer]: TEstudiante read GetCursista;
  end;

  TEstudiante = class
  private
    FStringGrid: TStringGrid;
    FItem: integer;
    FGrupo: string;
    FCurso: integer;
    function GetData: TStrings;
    function GetNombre: string;
    function GetNumero: string;
    function GetOpciones(const i: integer): integer;
    function GetPromedio: string;
    function GetGrupo: string;
  public
    constructor Create(AStringGrid: TStringGrid; const Item, AGrupo: integer);
    property Data: TStrings read GetData;
    property Numero: string read GetNumero;
    property Nombre: string read GetNombre;
    property Promedio: string read GetPromedio;
    property Grupo: string read GetGrupo;
    property Opciones[const i: integer]: integer read GetOpciones;
    property Curso: integer read FCurso;
    function  GetOption(Cursos: TCursos): integer;
  end;

  TCursos = class
  private
    FList: TList;
    FStringGrid: TStringGrid;
    function GetCurso(const i: integer): TCurso;
    function GetCount: integer;
  public
    constructor Create(AStringGrid: TStringGrid);
    destructor Destroy;  override;
    procedure AddCurso(const i: integer);
    property Curso[const i: integer]: TCurso read GetCurso; default;  //comiennza en 1..
    property Count: integer read GetCount;
  end;

  TEstudiantes = class
  private
    FList: TList;
    FSinPlaza: TList;
    function GetEstudiante(const i: integer): TEstudiante;
    function GetCount: integer;
    function GetCantidadSinPlaza: integer;
    function GetSinPlaza(const i: integer): TEstudiante;
    procedure Sort;
    function GetSinPlazaCount: integer;
  public
    constructor Create;
    destructor Destroy;  override;
    procedure AddEstudiante(AStringGrid: TStringGrid; const i, Grupo: integer);
    property Estudiante[const i: integer]: TEstudiante read GetEstudiante; default;
    property Count: integer read GetCount;
    property CantidadSinPlaza: integer read GetCantidadSinPlaza;
    property SinPlaza[const i: integer]: TEstudiante read GetSinPlaza;
    property SinPlazaCount: integer read GetSinPlazaCount;
    procedure Solve(Cursos: TCursos);
  end;

implementation

uses SysUtils;

{ TCurso }

function TCurso.Assign(Stud: TEstudiante): boolean;
begin
  if Plazas > 0
    then
      begin
        dec(FPlazas);
        //FCursistas.Add(Stud);
        inc(FNumCursistas);
        Stud.FCurso := StrToInt(Data[0]);
        Result := true;
      end
    else Result := false;
end;

constructor TCurso.Create(AStringGrid: TStringGrid; const Item: integer);
begin
  FStringGrid := AStringGrid;
  FItem := Item;
  FPlazas := StrToInt(TrimRight(FStringGrid.Cells[2, Item]));
  //FCursistas := TList.Create;
end;

destructor TCurso.Destroy;
begin
  //FCursistas.Free;
  inherited;
end;
{
function TCurso.GetCursista(const i: integer): TEstudiante;
begin
  Result := FCursistas.Items[i];
end;
}
function TCurso.GetData: TStrings;
begin
  Result := FStringGrid.Rows[FItem];
end;

function TCurso.GetLugar: string;
begin
  Result := Data[4];
end;

function TCurso.GetMatricula: string;
begin
  Result := Data[2];
end;

function TCurso.GetNombre: string;
begin
  Result := Data[1];
end;

function TCurso.GetNumCursistas: integer;
begin
  Result := FNumCursistas;
end;

function TCurso.GetProfesor: string;
begin
  Result := Data[3];
end;

{ TEstudiante }

constructor TEstudiante.Create(AStringGrid: TStringGrid; const Item, AGrupo: integer);
begin
  FStringGrid := AStringGrid;
  FItem := Item;
  FGrupo := IntToStr(AGrupo);
end;

function TEstudiante.GetData: TStrings;
begin
  Result := FStringGrid.Rows[FItem];
end;

function TEstudiante.GetGrupo: string;
begin
  Result := FGrupo;
end;

function TEstudiante.GetNombre: string;
begin
  Result := Data[1];
end;

function TEstudiante.GetNumero: string;
begin
  Result := Data[0];
end;

function TEstudiante.GetOpciones(const i: integer): integer;
var
  S: string;
begin
  S := TrimRight(Data[2 + i]);
  if S = ''
    then Result := 0
    else Result := StrToInt(S);
end;

function TEstudiante.GetOption(Cursos: TCursos): integer;
var
  i: integer;
begin
  i := 1;                      // Empezamos probando con la primera opción
  while (i <= NUM_OPCIONES) and (Opciones[i] > 0)
    and (Cursos[Opciones[i]].Plazas = 0) do inc(i);
  if i <= NUM_OPCIONES
    then Result := Opciones[i]
    else Result := 0;
end;

function TEstudiante.GetPromedio: string;
begin
  Result := Data[2];
end;

{ TCursos }

procedure TCursos.AddCurso(const i: integer);
begin
  FList.Add(TCurso.Create(FStringGrid, i));
end;

constructor TCursos.Create(AStringGrid: TStringGrid);
begin
  FList := TList.Create;
  FStringGrid := AStringGrid;
end;

destructor TCursos.Destroy;
var
 i: integer;
begin
  for i := 1 to Flist.Count do
    Curso[i].Free;
  FList.Free;
  inherited;
end;

function TCursos.GetCount: integer;
begin
  Result := FList.Count; 
end;

function TCursos.GetCurso(const i: integer): TCurso;
begin
  Result := FList.Items[pred(i)];
end;

{ TEstudiantes }

procedure TEstudiantes.AddEstudiante(AStringGrid: TStringGrid; const i, Grupo: integer);
begin
  FList.Add(TEstudiante.Create(AStringGrid, i, Grupo));
end;

constructor TEstudiantes.Create;
begin
  FList := TList.Create;
  FSinPlaza := TList.Create;
end;

destructor TEstudiantes.Destroy;
var
 i: integer;
begin
  for i := 0 to pred(Flist.Count) do
    Estudiante[i].Free;
  FList.Free;
  FSinPlaza.Free;
  inherited;
end;

function TEstudiantes.GetCantidadSinPlaza: integer;
begin
  Result := FSinPlaza.Count;
end;

function TEstudiantes.GetEstudiante(const i: integer): TEstudiante;
begin
  Result := FList.Items[i];
end;

function TEstudiantes.GetCount: integer;
begin
  Result := FList.Count;
end;

function TEstudiantes.GetSinPlaza(const i: integer): TEstudiante;
begin
  Result := FSinPlaza.Items[i];
end;

procedure TEstudiantes.Solve(Cursos: TCursos);
var
  i: integer;
  Opt: integer;
begin
  Sort;                               // Ordenar los estudiantes por índice académico
  for i := 0 to pred(Count) do        // Resolver para cada estudiante
    begin
      Opt := Estudiante[i].GetOption(Cursos);  // Opción obtenida por el estudiante
      if (Opt > 0) and (Cursos[Opt].Plazas > 0)
        then Cursos[Opt].Assign(Estudiante[i])
        else FSinPlaza.Add(Estudiante[i]);
    end;
end;

procedure TEstudiantes.Sort;

  function Compare(Item1, Item2: Pointer): integer;
    begin
      Result := CompareText(TEstudiante(Item2).Promedio,TEstudiante(Item1).Promedio);
    end;

begin
  FList.Sort(@Compare);
end;

function TEstudiantes.GetSinPlazaCount: integer;
begin
  Result := FSinPlaza.Count; 
end;

end.
