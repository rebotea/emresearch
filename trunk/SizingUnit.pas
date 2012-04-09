unit SizingUnit;

interface
const
  // General variables    главные переменные
Pwr = 16e6; // Required power (W)   Потребляемая мощность (Вт)

rpm = 13000; // Speed (RPM)   Скорость вращения (RPM)

psi = 0; // Power factor angle     коэффициент мощности угол

Bsat = 1.65; // Stator saturation flux density насыщения плотность потока статора


 // Rotor variables   переменные ротора
vtip = 200; // Tip speed limit (m/s)  ограничение скорости (м / с)

p = 3; // Number of pole pairs      Число пар полюсов

Br = 1.2; // Magnet remnant flux density (T)  остаток плотности потока магнита(Т)

thsk = 10; // Magnet skew angle (elec deg)   угол наклона магнита

PC = 5.74; // Permeance coefficient for magnets  коэффициент проницаемости для для магнитов


// Stator variables     перменны статора
Ja = 2200; // Initial current density (A/cm2)   Начальная плотность тока

q = 3; // Number of phases   количестов фаз

m = 2; // Slots/pole/phase   Слот / полюс / фаза

Nsp = 1; // Number of slots short pitched  Количество коротких слотов

g =0.004; // Air gap (in)  Воздушный зазор

hs =0.025; // Slot depth (in)   Глубина слота

hd =0.0005; // Slot depression depth (in)  глубина дипрессии слота

wd = le-6; // Slot depression width (in) ширина дипрессии слота

ws =0.016; // Avg slot width (in)    средняя ширина щели

Nc = 1; // Turns per coil повороты на катушку

lams = 0.5; // Slot fill fraction фракция заполнения слота

sigst = 6.0e+7; // Stator winding conductivity  проводимость обмотки статора

// Densities    / / Плотность


rhos = 7700; // Steel density (kg/m3) Плотность стали(кг/м3)
rhom = 7400; // Magnet density (kg/m3)    плотность магнита(кг/м3)
rhoc = 8900; // Conductor density (kg/m3)    плотность дирижера(кг/м3)

// Constants to be used  Константы, которые будут использоваться

muO = 4*pi*le-7; // Free space permeability   свободное место на проницаемость

tol = le-2; // Tolerance factor фактор толерантности

cpair = 1005.7; // Specific heat capacity of air (J/kg*C)  Удельная теплоемкость воздуха (Дж / кг * С)

rhoair = 1.205; // Density of air at 20 C (kg/m3)    Плотность воздуха при 20 ° С (кг/м3)

nuair = 1.5e-5; // Kinematic viscosity of air at 20 C (m2/s) кинематическая вязкость воздуха при 20 ° С (м2 / с)

P0 = 36.79; // Base Power Losss, W/lb    База Losss мощность, Вт / фунт

FO = 1000; // Base freuency, 60 Hz   База freuency, 60 Гц

BO = 1.0; // Base flux density, 1.0 T   База плотности потока, 1.0 T

epsb = 2.12;
epsf= 1.68;



procedure ElectricalFrequencyRotorRadius(p,q,m, Ks, Rkp, kb, kw: extended);
procedure MagnetDimensionsToothWidthAirGapFluxDensity(PC, R, Ws, Bg, Bsat, ge, eratio :extended);
procedure Values(thme, p, ge, Cphi, PC, R, G, wt, ws, hd, Ns, tfrac, wst, wsb, dc, Rci, Rco, lel: extended);
procedure MagneticGapFactor(R, hm, g, RSA, A, p, rhos, Rc, Ns, wt, hs, hd, wd, Bg, tfrac, dc, epsf, epsb, FO, f, BO, lams, m, Ja, Ass, q, Ds, pi, Lst, Ra, Pa, Lac, Pgap, PcperL, Bb, Bt, Mcperl: extended);
procedure MagneticFluxInternalVoltage(thm, pi, Bg, kg, p, Rs, Lst, Na, kw, ks, omega, Ea: extended);
procedure InductancesReactances(pi, Ia, Na, kw, Rs, g, hm, hs, wst, hd, Lst, perm, Nc, Ns, ws, wt, rhoc, McperL, thmrad, omega, R, nuair, Ea, muO, Pin, Ja, Ptemp, Perr, Pwind, Rey, Mser, Mm, Mc, Dmach, Lmach, Mac, Lac, Lslot: extended);

implementation

procedure ElectricalFrequencyRotorRadius(p,q,m, Ks, Rkp, kb, kw: extended);
begin
  f = p*rprn/60;
  omega = 2*pi*f;
  R = p*vtip/omega;

  // Winding & skew factors   ????????  не знаю перевод
  Ns:= floor(2*q*p*m); // Number of slots     номер слота
  gama:= 2*pi*p/Ns;
  Nsfp:= floor(Ns/(2*p));
  Nsct:= Nsfp - Nsp;
  alfa:= pi*Nsct/Nsfp;
  kp:= sin(pi/2)*sin(alfa/2);
  kb:= sin(m*gama/2)/(m*sin(gama/2));
  kw:= kp*kb;
  ths:= ((p*thsk)+le-6)*(pi/180); // skew angle (elec rad)    угол наклона (электронов рад)

  ks:= sin(ths/2)/(ths/2);

end;

procedure MagnetDimensionsToothWidthAirGapFluxDensity(PC, R, Ws, Bg, Bsat, ge, eratio :extended);
begin
  thme:= 1; // Initial Magnet angle (deg e)  начальный угол магнита
  notdone:= 1;
  ge:= g; // Initial effective air gap    Начальный эффективный воздушный зазор
  while notdone:= 1 do
  begin
    alpham:= thme/180; // Pitch coverage coefficient  коэффициент покрытия  Pitch

    Cphi:= (2*alpham)/(l+alpham); // Flux concentration factor коэффициент концентрации   flux

    hm:= ge*Cphi*PC; // Magnet height  высота магнита
    Ds:= 2*(R+hm+g); // Inner stator/air gap diameter   Внутренний статор / диаметр воздушного зазора

    K1:= 0.95; // Leakage factor  фактор утечки
    Kr:= 1.05; // Reluctance factor фактор нежелательности (нежелательный фактор)
    murec:= 1.05; // Recoil permeability   проницаемость recoil
    Bg:= ((Kl*Cphi)/(1+(Kr*murec/PC)))*Br;
    wt:= ((pi*Ds)/Ns)*(Bg/Bsat); // Tooth width    ширина зуба

    taus:= ws + wt; // Width of slot and tooth  ширина щели и зубов

    Kc:= 1/(1-(1/((taus/ws)*((5*g/ws)+1)))); // Carter's coefficient   коэффициент Картера

    ge:= Kc*g;
    eratio:= ws/wt;
    if abs(eratio - 1) < tol then
     notdone:= 0
    else
    thme:= thme + 1;
  end;
end;

procedure Values(thme, p, ge, Cphi, PC, R, G, wt, ws, hd, Ns, tfrac, wst, wsb, dc, Rci, Rco, lel: extended);
begin
  thm:= thme/p; // Magnet physical angle  физических угол   магнита

  thmrad:= thm*(pi/180);
  hm:= ge*Cphi*PC; // Magnet height   высота магнита
  Ds:= 2*(R+hm+g); // Inner stator/air gap diameter  Внутренний статор / диаметр воздушного зазора
  // Generate geometry of machine     Создание геометрии машины


  // Peripheral tooth fraction  фракция периферийного зуба

  tfrac:= wt/(wt+ws);

  // Slot top width (at air gap) ширина слота по верху (на воздушный зазор)

  wst:= 2*pi*(R+g+hm+hd)*tfrac/Ns;

  // Slot bottom width  Ширина нижнего слота

  wsb:= wst*(R+g+hm+hd+hs)/(R+g+hm+hd);

  // Stator core back iron depth    не знаю перевод????????????????????????

  dc:= (pi*Ds*thmradl(4*p))*(Bg/Bsat);

  // Core inside radius   внутренний радиус  Сore

  Rci:= R+hm+g+hd+hs;

  // Core outside radius  внешний радис Core
  Rco:= Rci+dc;

  // Slot area   область слота
  Ass:= ws*hs;
  // Estimate end turn length   Оценка длины конца очереди

  // End turn travel (one end)   Конец своей очереди (один конец)

  laz:= pi*(R+g+hm+hd+0.5*hs)*NsctlNs;
  // End length (half coil)   Конец длины (1/2 катушки)

  le2:= pi*laz;

  // End length (axial direction)  Конец длины (осевое направление)

  lel:= 2*le2/(2*pi);

 end;

procedure MagneticGapFactor(R, R hm, g, RSA, A, p, rhos, Rc, Ns, wt, hs, hd, wd, Bg, tfrac, dc, epsf, epsb, FO, f, BO, lams, m, Ja, Ass, q, Ds, pi, Lst, Ra, Pa, Lac, Pgap, PcperL, Bb, Bt, Mcperl: extended);
begin
  Rs = R+hm+g;
  Ri = R
  RI = R;
  R2 =R+hm;
  kg = ((RiA(p~1 ))/(RSA (2*p)-RiA (2*p)))*((p/(p+l1))*(R2A(p+ 1)-Ri A(p+ 1))...
  +(p*RSA (2*p)I(p- 1))*(R JA( I -p)-R2A( 1p)));

  // Core loss calculations (per length)    расчеты потерь Core (в длину)


  // Core mass per length   массы core на единицу длины

  Mcbperl = rhos*pi*(RcOA 2-RciA 2); % Back iron
  MctperL =rhos *(Ns*wt*hs+2*pi*R*hd-Ns*hd*wd); % Teeth
  Mcperl = McbperL + MctperL;

  // Tooth Flux Density  плотностm потока зуба

  Bt = Bg/tfrac;

  // Back iron flux density (Hanselman) плотность возвращаемого потока железа
  Bb = Bg*R/(p*dc);

  // Core back iron loss per length    Core обратно потери железа в длину

  PcbperL = McbperL*PO*abs(Bb/BO0)A epsb*abs(f/FO)A epsf,
  // Teeth Loss per length    Потери зубов в длину


  PctperL = MctperL*PO*abs(Bt!BO)A epsb*abs(f/FO)A epsf;

  // Total core loss per length Полная потеря  в длину

  PcperL = PcbperL + PctperL;

  // Current and surface current density  Текущая и поверхностная плотность тока


  // Armature turns (each slot has 2 half coils) Арматура повороты (каждый слот имеет 2 катушки 1/2)

  Na = 2*p*m*Nc;

  // Arm cond area (assumes form wound)  Рука-дирижер области
  Aac = (As*lams)/(2*Nc);
  // Power & Current waveform factors (Lipo)  Мощность и ток факторов сигнала (Lipo)

  ke 0.52;
  ki =sqrt(2);

  // Initial terminal current    текущий терминал
  la = Ns*lams*As*Ja* 1 e4/(2*q*Na);
  notfin = 1;
  Lst =0. 1; // Initial stack length     Начальный стек длины

  = 1

  // Start loop to determine Lst, Ea, Va, and Ia   Начало цикла для определения LST, Еа, Ва, ia.

  notdone = 1;
  k = 0;
  while notdone == 1
  k=k+ 1;

  // Surface current density    Поверхность плотности тока

  A = 2*q*Na*Ia/(pi*Ds);

  // Calculate stack length of machine  вычислить стек длины машины


  // Loop to get stack length   не знаю как переводится ??????????????
  while notfin == 1

  // Gap power
  Pgap = 4*pi*ke*ki*kw*ks*kg*sin(thmrad)*(f/p)*A*Bg*(Ds^2)*Lst;

  // Length of conductor  длина кондуктора
  Lac = 2*Na*(Lst+2*le2);

  // Stator resistance    резистенция статора
  Ra = Lac/(sigst*Aac);

  // Copper Loss    потреи в меди
  Pa = q*IaA2*Ra;

  // Core losses  основные потери
  Pc = PcperL*Lst;

  // Iterate to get length    Итерация, чтобы получить длину

  Ptempl = Pgap-Pa-Pc;
  error = Pwr/Ptemp 1;
  err(i) = error;
  if abs(error-1) < tol
  notfin = 0;
  else
  Lst = Lst*error;
  i=i+ 1;
end;

procedure MagneticFluxInternalVoltage(thm, pi, Bg, kg, p, Rs, Lst, Na, kw, ks, omega, Ea: extended);
begin
  thmrad = thm*(pi/180);
  B 1 = (4/pi)*Bg*kg*sin(p*thmrad/2);
  lambda = 2*Rs*Lst*Na*kw*ks*B I/p;
  Ea = omega*lambda/sqrt(2); // RMS back voltage
end;

procedure InductancesReactances(pi, Ia, Na, kw, Rs, g, hm, hs, wst, hd, Lst, perm, Nc, Ns, ws, wt, rhoc, McperL, thmrad, omega, R, nuair, Ea, muO, Pin, Ja, Ptemp, Perr, Pwind, Rey, Mser, Mm, Mc, Dmach, Lmach, Mac, Lac, Lslot: extended);
begin
  // Air-gap inductance        воздушный зазор в катушке индуктивности
  Lag = (q/2)*(4/pi)*(muO*NaA2*kwA2*Lst*Rs)/(pA2*(g+hm));
  // Slot leakage inductance   слт индуктивности
  perm = muO*((1/3)*(hs/wst) + hd/wst);
  Las = 2*p*Lst*perm*(4*NcA2*(m-Nsp)+2*Nsp*NcA2);
  Lam = 2*p*Lst*Nsp*NcA2*perm;
  if q == 3
  Lslot = Las + 2*Lam*cos(2*pi/q); % 3 phase equation
  else
  Lslot = Las - 2*Lam*cos(2*pi/q); % multiple phases
  End

  // End-turn inductance (Hanselman)  Конец поворота индуктивности (Хансельмана)

  taus = ws + wt;// Width of slot and tooth  Ширина щели и зубов

  Le = ((Nc*muO*(taus)*NaA2)/2)*log(wt*sqrt(pi)/sqrt(2*As));

  // Total inductance and reactance общая индуктивность и реактивность
  Ls = Lag+Lslot+Le;
  Xs = omega*Ls;
  // Lengths, Volumes, and Weights   Длина, значения и ширина
  // Armature conductor length
  Lac = 2*Na*(Lst+2*le2);

  // Mass of armature conductor   масса арматуры кондуктора
  Mac = q*Lac*Aac*rhoc;

  //% Overall machine length Общая длина машины

  Lmach = Lst+2*lel;

  //% Overall diameter   наружный диаметр
  Dmach = 2*Rco;

  //% Core mass   основная масса
  Mc = McperL*Lst;

  //% Magnet mass  масса магнита
  Mm = 0.5*(p*thmrad)*((R+hm)A2-RA2)*Lst*rhom;

  //% Shaft mass  масса вала
  Ms = pi*RA2*Lst*rhos;

  Mser = 0.15*(Mc+Ms+Mm+Mac);

  //% Total mass   общая масса
  Mtot = Mser+Mc+Ms+Mm+Mac;

  //"% Reynold's number in air gap   число рейнольдса в воздушном зазоре
  omegam = omega/p;
  Rey = omegam*R*g/nuair;

  //% Friction coefficient   коэфициент трения
  Cf = .0725/ReyA.2;
  //% Windage losses  потери на парусность
  Pwind = Cf*pi*rhoair*omegamA3*RA4*Lst;

  //% Get terminal voltage   получение напряженния на клемах
  xa = Xs*Ia/Ea;
  Va = sqrt(EaA2-((Xs+Ra)*Ia*cos(psi))A2)-(Xs+Ra)*Ia*sin(psi);
  Ptemp = q*Va*Ia*cos(psi)-Pwind;
  Perror = Pwr/Ptemp;
  Perr(k) = Perror;
  if abs(Perror-1) < tol
  notdone = 0;
  else
  Ia = Ia*Perror;
  end
  end


    Ja = Ia/Aac;
  % Power and efficiency
  Pin = Pwr+Pc+Pa+Pwind;
  eff = Pwr/Pin;
  pf = cos(psi);
  156
  fprintf('pm2calc complete: Ready.\n');
  //"%Jo nathan Rucker, MIT Thesis
  //"%M ay 2005
  //"%P rogram: pm2output
  //"%P rogram outputs values from pm2calc.
  //"%Pr ogram developed from J.L. Kirtley script with permission
  //"%M UST RUN pm2input and pm2calc PRIOR TO RUNNING pm2output
  //"%V ariables for output display
  Pout =Pwr/1e3;
  Jao =Ja/l e4;
  Pco =Pc/1e3;
  Pwindo = Pwind/1e3;
  Pao =Pa/le3;
  wso = ws*1000;
  hso = hs* 1000;
  wto = wt* 1000;
  dco = dc* 1000;
  Lso =Ls* 1000;
  hmo hm* 1000;
  go = g*1000;

end;
end.
