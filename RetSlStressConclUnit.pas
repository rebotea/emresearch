unit RetSlStressConclUnit;

{
Unit calculates  and outputs  retaining  can stress
for permanent magnet  machines  with  surface  magnets and
slotted  stators.
}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, TeEngine, Series, StdCtrls, ExtCtrls, TeeProcs, Chart, math;

type TVector = array of Extended;

type
  AppendixH = class(TObject)
  private
  vmag{Magnet tangential velocity}, Fm{Centrifugal force}, Phoop{Outward pressure}: Extended;
  t, slev, Sthoop, SFHoop: TVector;
  //Input fields
  R, hm, omega, p, Mm, Lst: Extended;
  protected
  public
    Constructor Create(in_R, in_hm, in_omega, in_p, in_Mm, in_Lst: Extended);
    Destructor Destroy; virtual;
    function CalcRetSlStresses(): HRESULT;
    property Getvmag: Extended read vmag;
    property GetFm: Extended read Fm;
    property GetPhoop: Extended read Phoop;
    property Getslev: TVector read slev;
    property GetSthoop: TVector read Sthoop;
    property GetSFHoop: TVector read SFHoop;
end;

const
  Patopsi = 1.45038 * 0.0001;// Conversion
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
var
  I: Integer;
begin
//Magnet tangential velocity
  vmag:= ((R + hm) * omega) / p;
//Centrifugal force
  Fm:= (Mm * sqr(vmag)) / (R+ hm);
//Outward pressure
  Phoop:= Fm / (2 * Pi * (R + hm) * Lst);
//Hoop Stress (in general, str = P * R / t)
  SetLength(t, 23);
  SetLength(slev, 23);
  SetLength(Sthoop, 23);
  SetLength(SFHoop, 23);
  for I := 1 to 22 do
  begin
    t[I]:= I * 0.0005;
    slev[I]:= t[I] * 1000;
    Sthoop[I]:= (Phoop * (R + hm) / t[I]) * Patopsi / 1000;
    SFHoop[I]:= Sthoop[I] * SF;
  end;
  Result:= S_OK;
end;

constructor AppendixH.Create(in_R, in_hm, in_omega, in_p, in_Mm, in_Lst: Extended);
begin
  inherited Create;
  R:= in_R;  hm:= in_hm;  omega:= in_omega;  p:= in_p;  Mm:= in_Mm;  Lst:= in_Lst;
end;

destructor AppendixH.Destroy;
begin

end;

end.

