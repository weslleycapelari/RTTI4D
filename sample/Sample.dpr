program Sample;

uses
  Vcl.Forms,
  uFrmPrincipal in 'uFrmPrincipal.pas' {Form1},
  RTTI4D in '..\src\RTTI4D.pas',
  RTTI4D.Intf in '..\src\RTTI4D.Intf.pas',
  RTTI4D.Exceptions in '..\src\RTTI4D.Exceptions.pas',
  RTTI4D.Utils in '..\src\RTTI4D.Utils.pas',
  RTTI4D.Field in '..\src\RTTI4D.Field.pas',
  RTTI4D.Obj in '..\src\RTTI4D.Obj.pas',
  RTTI4D.Enum in '..\src\RTTI4D.Enum.pas',
  RTTI4D.Prop in '..\src\RTTI4D.Prop.pas',
  RTTI4D.Method in '..\src\RTTI4D.Method.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
