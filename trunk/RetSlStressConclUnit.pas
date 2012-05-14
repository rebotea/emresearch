unit RetSlStressConclUnit;

{
Unit calculates  and outputs  retaining  can stress
for permanent magnet  machines  with  surface  magnets and
slotted  stators.}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, TeEngine, Series, StdCtrls, ExtCtrls, TeeProcs, Chart, math;

type
  AppendixH = class(TObject)
  private
  vmag{Magnet tangential velocity}, Fm{Centrifugal force}, Phoop{Outward pressure}: Extended;
  protected
  public
    Constructor Create;
    Destructor Destroy; virtual;
    function CalcRetSlStresses(): HRESULT;
end;

const
  Patopsi = 1.45038 * power(10,-4);// Conversion
  //Material yield stresses (ksi)
  Stain_str = 90;
  Alum_str = 75;
  Titan_str = 110;
  CarFib_str = 100;
  Inconel_str = 132;
  //Safety factor
  SF = 1.2;

implementation

{ AppendixH }

function AppendixH.CalcRetSlStresses: HRESULT;
begin

end;

constructor AppendixH.Create;
begin

end;

destructor AppendixH.Destroy;
begin

end;

end.
