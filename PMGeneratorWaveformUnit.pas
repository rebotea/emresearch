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
    // Основне переменные
    Pwr{Required power(W)}, rpm{Speed(RPM)}, psi{Power factor angle}, f{Electrical frequency(Hz)},
    omega{electrical frequency(rad/sec)}, vtip{Tip speed(m/s)}, lambda{Flux linkage},
    Ea{RMS Internal voltage(V)},
    // Rotor variables
    // Переменные параметров ротора
    R{Rotor radius(m)}, hm{Magnete thickness(m)}, Lst{Rotor stack length(m)},
    p{Number of pole pairs}, Br{Magnet remnant flux density(T)}, thm{Magnet physical angle(deg)},
    thsk{Magnet skew angle(actual deg)},
    // Stator variables
    // Переменные параметров статора
    q{Number of phases}, m{Slots per pole per phase}, Ns{Number of slots}, Nsp{Nyumber of slots short pitched},
    g{Air gap(m)}, ge{Effective air gap(m)}, tfrac{Peripheral tooth fraction},
    hs{Slot depth(m)}, hd{Slot depression depth(m)}, wd{Slot depression width(m)},
    syrat{Stator back iron ratio(yoke thick/rotor radius)}, Nc{Turns per coil},
    lams{Slot fill fraction}, sigst{Stator conductivity}, Kc{Carter coefficient} : Extended;

    n, np, w, freq, kgn, kwn, ksn, Eanorm, Ean, Bout, Eaout, Bn: Tvector;
    Rs,  THD: Extended;



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
    function SetGeneralVariable(ReqPower, Speed, PowFAngle, El_f_Hz, El_f_Rps,
      TSpeed, FlLink, RMSInV: Extended): HRESULT;
  protected
    procedure EvaluatedToHarmonics(var n, np, w, freq: TVector);
    procedure HarmonicWind_SkFact(Nsct, Nsfp: Extended);
    function CalcMgapFtrs: TVector;
    function CalcMFlx_InV(Bg, Na: Extended): HRESULT;
    function Normalized(): HRESULT;
    function GenWave(): HRESULT;
  public
    Constructor Create(in_Pwr, in_rpm, in_psi, in_f, in_omega, in_vtip,
    in_lambda, in_Ea, in_R, in_hm, in_Lst, in_p, in_Br, in_thm, in_thsk, in_q,
    in_m, in_Ns, in_Nsp, in_g, in_ge, in_tfrac, in_hs, in_hd, in_wd, in_syrat,
    in_Nc, in_lams, in_sigst, in_Kc: Extended);
    Destructor Destroy; virtual;
    property SetElFreq: Extended write f;
    property SetLambda: Extended write lambda;
    property SetEa: Extended write Ea;
    property SetKc: Extended write Kc;

    function PlotWaveforms(CLine_1Sr, CLine_1Sr2, CBar_2Sr: TChart): HRESULT;
    function CalcWaveform: HRESULT;
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
  function AppendixG.SetGeneralVariable(ReqPower, Speed, PowFAngle, El_f_Hz,
    El_f_Rps, TSpeed, FlLink, RMSInV: Extended): HRESULT;
  begin
    Pwr:= ReqPower;
    rpm:= Speed;
    psi:= PowFAngle;
    f:= El_f_Hz;
    omega:= El_f_Rps;
    vtip:= TSpeed;
    lambda:= FlLink;
    Ea:= RMSInV;
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
// Оценка гармоники
procedure AppendixG.EvaluatedToHarmonics(var n, np, w, freq: TVector);
begin
  n:= AProgressive(1, 2, 35);
  np:= VMul(p, n);
  w:= VMul(omega, n);
  freq:= VDiv(2 * Pi, w);
end;

// Harmonic  winding  and  skew factors
// Парамтеры обмотки и коэффицинт скольжения
procedure AppendixG.HarmonicWind_SkFact(Nsct, Nsfp: Extended);
var
  gama, alfa, ths: Extended;
  kpn, kbn: TVector;
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
// Расчет коэффициента разрыва
function AppendixG.CalcMgapFtrs: TVector;
var
  Ri, R1, R2: Extended;
begin
  Rs:= R + hm + g;
  Ri:= R;
  R1:= R;
  R2:= R + hm;
  Result:=
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
        VPow
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
        VPow
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
        VPow1
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

end;

function AppendixG.CalcWaveform: HRESULT;
begin
  EvaluatedToHarmonics(n, np, w, freq);
  HarmonicWind_SkFact(Round(Ns/(2*p)) - Nsp, Round(Ns/(2*p)));
  kgn:= CalcMgapFtrs;
  CalcMFlx_InV(Bg, 2 * p * m * Nc);
  Normalized;
  GenWave;
  //PlotWaveforms()
end;

constructor AppendixG.Create(in_Pwr, in_rpm, in_psi, in_f, in_omega, in_vtip,
    in_lambda, in_Ea, in_R, in_hm, in_Lst, in_p, in_Br, in_thm, in_thsk, in_q,
    in_m, in_Ns, in_Nsp, in_g, in_ge, in_tfrac, in_hs, in_hd, in_wd, in_syrat,
    in_Nc, in_lams, in_sigst, in_Kc: Extended);
begin
  inherited Create;
  Pwr:= in_Pwr;  rpm:= in_rpm;  psi:= in_psi;  f:= in_f;  omega:= in_omega;
  vtip:= in_vtip;  lambda:= in_lambda;  Ea:= in_Ea;  R:= in_R;  hm:= in_hm;
  Lst:= in_Lst;  p:= in_p;  Br:= in_Br; thm:= in_thm; thsk:= in_thsk; q:= in_q;
  m:= in_m; Ns:= in_Ns; g:= in_g; ge:= in_ge; tfrac:= in_tfrac;  hs:= in_hs;
  hd:= in_hd;  wd:= in_wd;  syrat:= in_syrat;  Nc:= in_Nc;  lams:= in_lams;
  sigst:= in_sigst;  Kc:= in_Kc;

end;

destructor AppendixG.Destroy;
begin
  inherited Destroy;
end;

//Calculate magnetic flux and internal voltage
//Расчет магнитного потока и внутреннего напряжения
function AppendixG.CalcMFlx_InV(Bg, Na: Extended): HRESULT;
var
  thmrad, thmerad: Extended;
  lambdan: TVector;
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
        VMul
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
    p
    ,
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
  );

  // Normalized values for plotting
  // Нормализация величин для построения графика
  Ean:= VMul(omega, lambdan);
  Eanorm:= VDiv(Ean[1], VAbs(Ean));
end;

// Voltage THD
// Напряжение THD
function AppendixG.Normalized(): HRESULT;
var
  r: Integer;
  Eah: Extended;
begin
  Eah:= 0;
  for r := 2 to Length(n) do
    Eah:= Eah + sqr(Ean[r]);
  THD:= 100 * sqrt(Eah / sqr(Ean[1]));
end;

// Generate waveforms
// Rotor physical angle goes from 0 to 2*pi - electrical to 2*p*pi
// Составление массива для построение волны
// при движении ротора от 0 до 2 * Pi - в состоянии готовности до 2 * p * PI
function AppendixG.GenWave(): HRESULT;
var
  ang: Extended;
  i: Integer;
  angp: TVector;
begin
  ang:= 0;
  i:= 0;
  SetLength(angp, Round(2 * Pi / 100) + 1);
  Bout:= SetLengthZero(Round(2 * Pi / 100) + 1);
  Eaout:= SetLengthZero(Round(2 * Pi / 100) + 1);
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
//Изображение синусоиды на графике

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
  CLine_1Sr.Title.Caption:= 'PM  Generator:  Flux  Density';
  CLine_1Sr.BottomAxis.Title.Caption:='Rotor Angle (rad)';
  CLine_1Sr.LeftAxis.Title.Caption:='B (Tesla)';
  CLine_1Sr2.Title.Caption:= 'PM  Generator:  Back EMF';
  CLine_1Sr2.BottomAxis.Title.Caption:='Rotor  Angle  (rad)';
  CLine_1Sr2.LeftAxis.Title.Caption:='Peak  Voltage  (V)';
  CBar_2Sr.Title.Caption:= 'PM  Generator:  EMF Harmonics,  THD';
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

