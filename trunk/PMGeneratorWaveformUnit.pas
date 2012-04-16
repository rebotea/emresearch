unit PMGeneratorWaveformUnit;

{
Unit calculates  and outputs different waveforms,
calculates THD, and computes  the harmonic content
for permanent magnet machines with  surface magnets and
slotted stators.
}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, TeEngine, Series, StdCtrls, ExtCtrls, TeeProcs, Chart, math;

type
  TVector = array of Extended;

type
  AppendixG = class(TObject)
  private
    // General variables
    // ������� ����������
    Pwr{Required power(W)}, prm{Speed(RPM)}, psi{Power factor angle}, f{Electrical frequency(Hz)},
    omega{electrical frequency(rad/sec)}, vtip{Tip speed(m/s)}, lambda{Flux linkage},
    Ea{RMS Internal voltage(V)},
    // Rotor variables
    // ���������� ���������� ������
    R{Rotor radius(m)}, hm{Magnete thickness(m)}, Lst{Rotor stack length(m)},
    p{Number of pole pairs}, Br{Magnet remnant flux density(T)}, thm{Magnet physical angle(deg)},
    thsk{Magnet skew angle(actual deg)},
    // Stator variables
    // ���������� ���������� �������
    q{Number of phases}, m{Slots per pole per phase}, Ns{Number of slots}, Nsp{Nyumber of slots short pitched},
    g{Air gap(m)}, ge{Effective air gap(m)}, tfrac{Peripheral tooth fraction},
    hs{Slot depth(m)}, hd{Slot depression depth(m)}, wd{Slot depression width(m)},
    syrat{Stator back iron ratio(yoke thick/rotor radius)}, Nc{Turns per coil},
    lams{Slot fill fraction}, sigst{Stator conductivity}, Kc{Carter coefficient} : Extended;

    function VectorSizing(V: TVector): TVector;
    function AProgressive(x, s, sum: Extended): TVector;
    function VMul(x: Extended; V: TVector): Tvector;
    function VMul1(x, V: TVector): Tvector;
    function VDiv(x: Extended; V: TVector): TVector;
    function VDiv1(x, V: TVector): TVector;
    function VPow(x: Extended; V: TVector): TVector;
    function VPow1(x, V: TVector): TVector;
    function VMinus(x: Extended; V: TVector): TVector;
    function VMinus1(x, V: TVector): TVector;
    function VPlus(x: Extended; V: TVector): TVector;
    function VPlus1(x, V: TVector): TVector;
    function VSin(V: TVector): TVector;
    function VAbs(V: TVector): TVector;
    function SetLengthZero(Size: Integer): TVector;
  protected
    procedure EvaluatedToHarmonics(var n, np, w, freq: TVector);
    procedure HarmonicWind_SkFact(n: TVector);
    function CalcMgapFtrs(): TVector;
    function CalcMFlx_InV(): HRESULT;
    function Normalized(): HRESULT;
    function GenWave(): HRESULT;
  public
    Constructor Create;
    Destructor Destroy; virtual;
    function PlotWaveforms(CLine_1Sr, CLine_1Sr2, CBar_2Sr: TChart): HRESULT;

end;

const
  mu0 = 4 * Pi * 0.0000001;// Free space permeability
  tol = 0.01;// Toleracne factor

{ AppendixG }
implementation

function AppendixG.VectorSizing(V: TVector): TVector;
begin
  while V[Length(V) - 1] = 0 do
   SetLength(V, Length(V) - 1);
  Result:= V;
end;

function AppendixG.AProgressive(x, s, sum: Extended): TVector;
var
  i: Integer;
  Cx: Extended;
  Result1: TVector;
begin
  i:= 0;
  SetLength(Result1, Round((abs(sum) - abs(x)) / s + 2));
  while (sum >= RoundTo(x, -4)) do
  begin
    Result1[i]:= x;
    x:= x + s;
    inc(i);
  end;
  Result1:= VectorSizing(Result1);
end;

function AppendixG.VMul(x: Extended; V: TVector): Tvector;
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

function AppendixG.VMul1(x, V: TVector): Tvector;
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

function AppendixG.VDiv(x: Extended; V: TVector): TVector;
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

function AppendixG.VDiv1(x, V: TVector): TVector;
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

function AppendixG.VPow(x: Extended; V: TVector): TVector;
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

function AppendixG.VPow1(x, V: TVector): TVector;
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

function AppendixG.VMinus(x: Extended; V: TVector): TVector;
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

function AppendixG.VMinus1(x, V: TVector): TVector;
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

function AppendixG.VPlus(x: Extended; V: TVector): TVector;
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

function AppendixG.VPlus1(x, V: TVector): TVector;
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

function AppendixG.VSin(V: TVector): TVector;
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

function AppendixG.VAbs(V: TVector): TVector;
var
  i: Integer;
begin
  i:= 0;
  repeat
    Result[i]:= abs(V[i]);
    inc(i);
  until i = Length(V);
  Result:= VectorSizing(Result);
end;

function AppendixG.SetLengthZero(Size: Integer): TVector;
var
  Massive: TVector;
  I: Integer;
begin
  SetLength(Massive, Size);
  for I := 0 to Length(Massive) do
   Massive[I]:= 0;
  Result:= Massive;
end;


// Harmonics  to be evaluated
// ������ ���������
procedure AppendixG.EvaluatedToHarmonics(var n, np, w, freq: TVector);
begin
  n:= AProgressive(1, 2, 35);
  np:= AppendixG.VMul(p, n);
  w:= AppendixG.VMul(omega, n);
  freq:= AppendixG.VDiv(2 * Pi, w);
end;

// Harmonic  winding  and  skew factors
// ������� � ���������� ����������
procedure AppendixG.HarmonicWind_SkFact(n: TVector);
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
// ������ ������������ �������
function AppendixG.CalcMgapFtrs(): TVector;
begin
  Rs:= R + hm + g;
  Ri:= R;
  R1:= R;
  R2:= R + hm;
  kgn:=
  VPlus1
  (
    Vmul1
    (
      Vmul1
      (
        VDiv1
        (
          VPow
          (
            Ri
            ,
            VMinus
            (
              1
              ,
              np
            )
          )
          ,
          VMinus1
          (
            VPow
            (
              Rs
              ,
              VMul
              (
                2
                ,
                np
              )
            )
            ,
            VPow
            (
              Ri
              ,
              VMul
              (
                2
                ,
                np
              )
            )
          )
        )
        ,
        VDiv1
        (
          np
          ,
          VPlus
          (
            1
            ,
            np
          )
        )
      )
    ,
      VMinus1
      (
        VPov1
        (
          R2
          ,
          VPlus
          (
            1
            ,
            np
          )
        )
        ,
        VPov1
        (
          R1
          ,
          VPlus(1, np)
        )
      )
    )
    ,
    VMul1
    (
      VDiv1
      (
        VPov1
        (
          VMul
          (
            Rs
            ,
            np
          )
          ,
          Vmul
          (
            2
            ,
            np
          )
        )
        ,
        VMinus
        (
          1
          ,
          np
        )
      )
      ,
      VMinus1
      (
        VPow
        (
          R1
          ,
          VMinus
          (
            1
            ,
            np
          )
        )
        ,
        VPow
        (
          R2
          ,
          VMinus
          (
            1
            ,
            np
          )
        )
      )
    )
  );
  Result:= kgn;
end;

constructor AppendixG.Create;
begin
  inherited Create;
  // ������������� �����
  //...
end;

destructor AppendixG.Destroy;
begin
  // ������������ �����/������
  inherited Destroy;
  //...
end;

//Calculate magnetic flux and internal voltage
//������ ���������� ������ � ����������� ����������
function AppendixG.CalcMFlx_InV(): HRESULT;
var
  thmrad, thmerad: Extended;
begin
  thmrad:= thm * (Pi / 180);
  thmerad:= p * thmrad;
  Bn:=
  VMul1
  (
    VMul1
    (
      VMul1
      (
        VMul
        (
          Bg
          ,
          VDiv
          (
            4 / Pi
            ,
            n
          )
        )
        ,
        kgn
      )
      ,
      VSin
      (
        VMul1
        (
          thmerad / 2
          ,
          n
        )
      )
    )
    ,
    VSin
    (
      VMul
      (
         Pi / 2
         ,
         n
      )
    )
  );

  lambdan:=
  VDiv
  (
    VMul1
    (
      VMul1
      (
        VMul
        (
          2 * Rs * Lst * Na
          ,
          kwn
        )
        ,
        ksn
       )
       ,
       Bn
     )
    ,
    p
  );

  // Normalized values for plotting
  // ������������ ������� ��� ���������� �������
  Ean:= VMul(omega, lambdan);
  Eanorm:= VDiv(Ean[1], VAbs(Ean));
end;

// Voltage THD
// ���������� THD
function AppendixG.Normalized(): HRESULT;
var
  r: Integer;
begin
  Eah = 0;
  for r := 2 to Length(n) do
    Eah:= Eah + sqr(Ean[r]);
  THD:= 100 * sqrt(Eah / sqr(Ean[1]));
end;

// Generate waveforms
// Rotor physical angle goes from 0 to 2*pi - electrical to 2*p*pi
// ����������� ������� ��� ���������� �����
// ��� �������� ������ �� 0 �� 2 * Pi - � ��������� ���������� �� 2 * p * PI
function AppendixG.GenWave(): HRESULT;
var
  ang: Extended;
  i: Integer;
begin
  ang:= 0;
  i:= 0;
  SetLength(angp, 2 * Pi / 100);
  Bout:= SetLengthZero(2 * Pi / 100);
  Eaout:= SetLengthZero(2 * Pi / 100);
  while ang <= 2 * Pi do
  begin
    ang:= ang + Pi / 100;
    angp[i]:= p * ang;
    inc(i);
  end;
  for I := 0 to Length(Bout) do
  begin
    Bout:=
    VPlus1
    (
      Bout
      ,
      VMul
      (
        Bn[i]
        ,
        VSin
        (
          VMul
          (
            n[i]
            ,
            angp
          )
        )
      )
    );
    VPlus1
    (
      Eaout
      ,
      VMul
      (
        Ean[i]
        ,
        VSin
        (
          VMul
          (
            n[i]
            ,
            angp
          )
        )
      )
    );
  end;
end;

//Plot waveforms
//����������� ��������� �� �������

function AppendixG.PlotWaveforms(CLine_1Sr, CLine_1Sr2, CBar_2Sr: TChart): HRESULT;
var
  I: Integer;
  ang: Extended;
begin
  ang:= 0;
  I:= 0;
  CLine_1Sr.Series[0].Clear;
  CLine_1Sr2.Series[0].Clear;
  CBar_2Sr.Series[0].Clear;
  CBar_2Sr.Series[1].Clear;
  CLine_1Sr.Title:= 'PM  Generator:  Flux  Density';
  CLine_1Sr.BottomAxis.Title.Caption:='Rotor Angle (rad)';
  CLine_1Sr.LeftAxis.Title.Caption:='B (Tesla)';
  CLine_1Sr2.Title:= 'PM  Generator:  Back EMF';
  CLine_1Sr2.BottomAxis.Title.Caption:='Rotor  Angle  (rad)';
  CLine_1Sr2.LeftAxis.Title.Caption:='Peak  Voltage  (V)';
  CBar_2Sr.Title:= ('PM  Generator:  EMF Harmonics,  THD');
  CBar_2Sr.BottomAxis.Title.Caption:='Harmonic  Number';
  CBar_2Sr.LeftAxis.Title.Caption:='Normalized  Back EMF';
  while ang < (2 * Pi / 100) do
  begin
    CLine_1Sr.Series[0].AddXY(ang, Bout[I]);
    CLine_1Sr2.Series[0].AddXY(ang, Eaout[I]);
    ang:= ang + Pi / 100;
    inc(I);
  end;

  for I := 1 to Length(Eanorm) do
  begin
    if Eanorm[I] < 0.1 then
      CBar_2Sr.Series[0].AddXY(n[I], Eanorm[I])
    else
      CBar_2Sr.Series[1].AddXY(n[I], Eanorm[I])
  end;

  CLine_1Sr.Refresh;
  CLine_1Sr2.Refresh;
  CBar_2Sr.Refresh;



end;





end.

