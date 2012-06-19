program EMResearchProject;

uses
  Forms,
  MainUnit in 'MainUnit.pas' {Form3},
  SizingUnit in 'SizingUnit.pas',
  BodePlotUnit in 'BodePlotUnit.pas',
  PMGeneratorWaveformUnit in 'PMGeneratorWaveformUnit.pas',
  RetSlStressConclUnit in 'RetSlStressConclUnit.pas',
  BasicSizingMethodUnit in 'BasicSizingMethodUnit.pas',
  RotorLossesUnit in 'RotorLossesUnit.pas',
  RotorLossesFromSlotEffectsUnit in 'RotorLossesFromSlotEffectsUnit.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm3, Form3);
  Application.Run;
end.
