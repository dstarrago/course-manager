program TiempoElectivo;

uses
  Forms,
  Main in 'Main.pas' {MainForm},
  inCursos in 'inCursos.pas' {CursosForm: TFrame},
  inEstud in 'inEstud.pas' {EstudiantesForm: TFrame},
  InfGral in 'InfGral.pas' {InfGralForm},
  Kernel in 'Kernel.pas',
  UnitDB in 'UnitDB.pas' {DataModule1: TDataModule},
  rpReparto in 'rpReparto.pas' {MDForm},
  rpCursos in 'rpCursos.pas' {fmCursos},
  rpEstudiantes in 'rpEstudiantes.pas' {fmEstudiantes},
  About in 'About.pas' {fmAbout},
  rpSinPlazas in 'rpSinPlazas.pas' {FSinPLazas};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TInfGralForm, InfGralForm);
  Application.CreateForm(TDataModule1, DataModule1);
  Application.CreateForm(TMDForm, MDForm);
  Application.CreateForm(TfmCursos, fmCursos);
  Application.CreateForm(TfmEstudiantes, fmEstudiantes);
  Application.CreateForm(TfmAbout, fmAbout);
  Application.CreateForm(TFSinPLazas, FSinPLazas);
  Application.Run;
end.
