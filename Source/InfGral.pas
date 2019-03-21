unit InfGral;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Spin, StdCtrls, Buttons, ExtCtrls;

type
  TInfGralForm = class(TForm)
    Label1: TLabel;
    EditInstituto: TEdit;
    Label4: TLabel;
    EditCurso: TEdit;
    Label2: TLabel;
    EditCarrera: TEdit;
    Label5: TLabel;
    EditYear: TSpinEdit;
    Label6: TLabel;
    EditGroup: TSpinEdit;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    Bevel1: TBevel;
    procedure BitBtn1Click(Sender: TObject);
  private
    { Private declarations }
  public
    procedure SaveData(S: TStream);
    procedure OpenData(S: TStream);
  end;

var
  InfGralForm: TInfGralForm;

implementation

{$R *.dfm}

procedure TInfGralForm.BitBtn1Click(Sender: TObject);
begin
  if (EditInstituto.Text = '') or (EditCurso.Text = '') or (EditCarrera.Text = '')
    then
      begin
        ModalResult := 0;
        MessageDlg('Faltan datos por introducir', mtError, [mbOK], 0);
      end;
end;

procedure TInfGralForm.OpenData(S: TStream);
var
  Reader: TReader;
begin
  Reader := TReader.Create(S, 10);
  try
    EditInstituto.Text := Reader.ReadString;
    EditCurso.Text := Reader.ReadString;
    EditCarrera.Text := Reader.ReadString;
    EditYear.Text := Reader.ReadString;
    EditGroup.Text := Reader.ReadString;
  finally
    Reader.Free;
  end;
end;

procedure TInfGralForm.SaveData(S: TStream);
var
  Writer: TWriter;
begin
  Writer := TWriter.Create(S, 10);
  try
    Writer.WriteString(EditInstituto.Text);
    Writer.WriteString(EditCurso.Text);
    Writer.WriteString(EditCarrera.Text);
    Writer.WriteString(EditYear.Text);
    Writer.WriteString(EditGroup.Text);
  finally
    Writer.Free;
  end;
end;

end.
