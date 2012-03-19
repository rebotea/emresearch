program EMResearchProject;

uses
  Forms,
  MainUnit in 'MainUnit.pas' {Form3},
  SizingUnit in 'SizingUnit.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm3, Form3);
  Application.Run;
end.
