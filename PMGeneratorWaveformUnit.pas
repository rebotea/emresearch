unit PMGeneratorWaveformUnit;


interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, TeEngine, Series, StdCtrls, ExtCtrls, TeeProcs, Chart, math;

{type TVector = array of Extended;


function AProgressive(x, s, sum: Extended): TVector;

function VectorMul(x: Extended; V: TVector): Tvector;

    }
implementation

{function VectorSizing(V: TVector): TVector;
begin
  while V[Length(V) - 1] = 0 do
   SetLength(V, Length(V) - 1);
  Result:= V;
end;

function AProgressive(x, s, sum: Extended): TVector;
var
  i: Integer;
  Cx: Extended;
begin
  i:= 0;
  SetLength(Result, Round((abs(sum) - abs(x)) / s + 2));
  while (sum >= RoundTo(x, -4)) do
  begin
    Result[i]:= x;
    x:= x + s;
    inc(i);
  end;
  Result:= VectorSizing(Result);
end;

function VMul(x: Extended; V: TVector): Tvector;
var
  i: Integer;
begin
  SetLength(Result, Length(V));
  i:= 0;
  repeat
    Result[i]:= V[i] * x;
    inc(i);
  until i = Length(V);
  Result:= VectorSizing(Result);
end;

function VMul1(x, V: TVector): Tvector;
var
  i: Integer;
begin
  SetLength(Result, Length(V));
  i:= 0;
  repeat
    Result[i]:= V[i] * x[i];
    inc(i);
  until i = Length(V);
  Result:= VectorSizing(Result);
end;

function VDiv(x: Extended; V: TVector): TVector;
var
  i: Integer;
begin
  SetLength(Result, Length(V));
  i:= 0;
  repeat
    Result[i]:= V[i] / x;
    inc(i);
  until i = Length(V);
  Result:= VectorSizing(Result);
end;

function VDiv1(x, V: TVector): TVector;
var
  i: Integer;
begin
  SetLength(Result, Length(V));
  i:= 0;
  repeat
    Result[i]:= V[i] / x[i];
    inc(i);
  until i = Length(V);
  Result:= VectorSizing(Result);
end;

function VPow(x: Extended; V: TVector): TVector;
var
  i: Integer;
begin
  SetLength(Result, Length(V));
  i:= 0;
  repeat
    Result[i]:= power(V[i], x);
    inc(i);
  until i = Length(V);
  Result:= VectorSizing(Result);
end;

function VPow1(x, V: TVector): TVector;
var
  i: Integer;
begin
  SetLength(Result, Length(V));
  i:= 0;
  repeat
    Result[i]:= power(x[i], V[i]);
    inc(i);
  until i = Length(V);
  Result:= VectorSizing(Result);
end;

function VMinus(x: Extended; V: TVector): TVector;
var
  i: Integer;
begin
  SetLength(Result, Length(V));
  i:= 0;
  repeat
    Result[i]:= V[i] - x;
    inc(i);
  until i = Length(V);
  Result:= VectorSizing(Result);
end;

function VMinus1(x, V: TVector): TVector;
var
  i: Integer;
begin
  SetLength(Result, Length(V));
  i:= 0;
  repeat
    Result[i]:= V[i] - x[i];
    inc(i);
  until i = Length(V);
  Result:= VectorSizing(Result);
end;

function VPlus(x: Extended; V: TVector): TVector;
var
  i: Integer;
begin
  SetLength(Result, Length(V));
  i:= 0;
  repeat
    Result[i]:= V[i] + x;
    inc(i);
  until i = Length(V);
  Result:= VectorSizing(Result);
end;

function VPlus1(x, V: TVector): TVector;
var
  i: Integer;
begin
  SetLength(Result, Length(V));
  i:= 0;
  repeat
    Result[i]:= V[i] + x[i];
    inc(i);
  until i = Length(V);
  Result:= VectorSizing(Result);
end;

function VSin(V: TVector): TVector;
var
  i: Integer;
begin
  i:= 0;
  repeat
    Result[i]:= sin(V[i]);
    inc(i);
  until i = Length(V);
  Result:= VectorSizing(Result);
end;


// Harmonics  to be evaluated
procedure EvaluatedToHarmonics(var n, np, w, freq: TVector);
begin
  n:= AProgressive(1, 2, 35);
  np:= VMul(p, n);// Размерность в kgn
  w:= VMul(omega, n);// Гармоническая переменная частота
  freq:= VDiv(2 * Pi, w);// Гармоническая частота
end;

// Harmonic  winding  and  skew factors
procedure HarmonicWind_SkFact(n: TVector);
begin
  gama:= 2 * Pi * p / Ns;
  alfa:= Pi * Nsct / Nsfp;
  kpn:= VMul1(VSin(VMul(Pi / 2, n)), VSin(VMul(alfa / 2, n)));
  kbn:= VDiv1(VSin(VMul(m * gama / 2, n)), VMul(m, (VSin(VMul(gama / 2, n)))));
  kwn:= VMul1(kpn, kbn);
  ths:= (((p * thsk) + 0.000001) * (Pi / 180));
  ksn:= VDiv1(VSin(VMul(ths / 2, n)), (VMul(ths / 2, n)));
end;

// Calculate  magnetic  gap  factor
function CalcMgapFtrs: TVector;
begin
  Rs:= R + hm + g;
  Ri:= R;
  R1:= R;
  R2:= R + hm;
  kgm:= Vmul1(VDiv1(VPow(Ri, VMinus(1, np)), VMinus1(VPow(Rs, VMul(2, np)), VPow(Ri, VMul(2, np)))),
               )    ;

  VPlus1
  (
    VMul1
    (
      VDiv1(np, VPlus(1, np))
      ,
      VMinus1(VPow(R2, VPlus(1, np)),VPow(R1, VPlus(1, np))
    )
  ,
    VMul1
    (
      VDiv1
      (
      VPow1(VMul(Rs, np), VMul(2, np))
      ,
      VMinus(1, np)
      )
    ,
      VMinus1
        (
         VPov
        ,

        )

    )




  )
  ;


  kgm:= Vdiv1(Vpow(Ri, VMinus(1, np)), ())      (VPow())
end;
      }

end.
