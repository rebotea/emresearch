unit SizingUnit;

interface
const
  // General variables    ������� ����������
Pwr = 16e6; // Required power (W)   ������������ �������� (��)

rpm = 13000; // Speed (RPM)   �������� �������� (RPM)

psi = 0; // Power factor angle     ����������� �������� ����

Bsat = 1.65; // Stator saturation flux density ��������� ��������� ������ �������


 // Rotor variables   ���������� ������
vtip = 200; // Tip speed limit (m/s)  ����������� �������� (� / �)

p = 3; // Number of pole pairs      ����� ��� �������

Br = 1.2; // Magnet remnant flux density (T)  ������� ��������� ������ �������(�)

thsk = 10; // Magnet skew angle (elec deg)   ���� ������� �������

PC = 5.74; // Permeance coefficient for magnets  ����������� ������������� ��� ��� ��������


// Stator variables     �������� �������
Ja = 2200; // Initial current density (A/cm2)   ��������� ��������� ����

q = 3; // Number of phases   ���������� ���

m = 2; // Slots/pole/phase   ���� / ����� / ����

Nsp = 1; // Number of slots short pitched  ���������� �������� ������

g =0.004; // Air gap (in)  ��������� �����

hs =0.025; // Slot depth (in)   ������� �����

hd =0.0005; // Slot depression depth (in)  ������� ��������� �����

wd = le-6; // Slot depression width (in) ������ ��������� �����

ws =0.016; // Avg slot width (in)    ������� ������ ����

Nc = 1; // Turns per coil �������� �� �������

lams = 0.5; // Slot fill fraction ������� ���������� �����

sigst = 6.0e+7; // Stator winding conductivity  ������������ ������� �������

// Densities    / / ���������


rhos = 7700; // Steel density (kg/m3) ��������� �����(��/�3)
rhom = 7400; // Magnet density (kg/m3)    ��������� �������(��/�3)
rhoc = 8900; // Conductor density (kg/m3)    ��������� ��������(��/�3)

// Constants to be used  ���������, ������� ����� ��������������

muO = 4*pi*le-7; // Free space permeability   ��������� ����� �� �������������

tol = le-2; // Tolerance factor ������ �������������

cpair = 1005.7; // Specific heat capacity of air (J/kg*C)  �������� ������������ ������� (�� / �� * �)

rhoair = 1.205; // Density of air at 20 C (kg/m3)    ��������� ������� ��� 20 � � (��/�3)

nuair = 1.5e-5; // Kinematic viscosity of air at 20 C (m2/s) �������������� �������� ������� ��� 20 � � (�2 / �)

P0 = 36.79; // Base Power Losss, W/lb    ���� Losss ��������, �� / ����

FO = 1000; // Base freuency, 60 Hz   ���� freuency, 60 ��

BO = 1.0; // Base flux density, 1.0 T   ���� ��������� ������, 1.0 T

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

  // Winding & skew factors   ????????  �� ���� �������
  Ns:= floor(2*q*p*m); // Number of slots     ����� �����
  gama:= 2*pi*p/Ns;
  Nsfp:= floor(Ns/(2*p));
  Nsct:= Nsfp - Nsp;
  alfa:= pi*Nsct/Nsfp;
  kp:= sin(pi/2)*sin(alfa/2);
  kb:= sin(m*gama/2)/(m*sin(gama/2));
  kw:= kp*kb;
  ths:= ((p*thsk)+le-6)*(pi/180); // skew angle (elec rad)    ���� ������� (���������� ���)

  ks:= sin(ths/2)/(ths/2);

end;

procedure MagnetDimensionsToothWidthAirGapFluxDensity(PC, R, Ws, Bg, Bsat, ge, eratio :extended);
begin
  thme:= 1; // Initial Magnet angle (deg e)  ��������� ���� �������
  notdone:= 1;
  ge:= g; // Initial effective air gap    ��������� ����������� ��������� �����
  while notdone:= 1 do
  begin
    alpham:= thme/180; // Pitch coverage coefficient  ����������� ��������  Pitch

    Cphi:= (2*alpham)/(l+alpham); // Flux concentration factor ����������� ������������   flux

    hm:= ge*Cphi*PC; // Magnet height  ������ �������
    Ds:= 2*(R+hm+g); // Inner stator/air gap diameter   ���������� ������ / ������� ���������� ������

    K1:= 0.95; // Leakage factor  ������ ������
    Kr:= 1.05; // Reluctance factor ������ ��������������� (������������� ������)
    murec:= 1.05; // Recoil permeability   ������������� recoil
    Bg:= ((Kl*Cphi)/(1+(Kr*murec/PC)))*Br;
    wt:= ((pi*Ds)/Ns)*(Bg/Bsat); // Tooth width    ������ ����

    taus:= ws + wt; // Width of slot and tooth  ������ ���� � �����

    Kc:= 1/(1-(1/((taus/ws)*((5*g/ws)+1)))); // Carter's coefficient   ����������� �������

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
  thm:= thme/p; // Magnet physical angle  ���������� ����   �������

  thmrad:= thm*(pi/180);
  hm:= ge*Cphi*PC; // Magnet height   ������ �������
  Ds:= 2*(R+hm+g); // Inner stator/air gap diameter  ���������� ������ / ������� ���������� ������
  // Generate geometry of machine     �������� ��������� ������


  // Peripheral tooth fraction  ������� ������������� ����

  tfrac:= wt/(wt+ws);

  // Slot top width (at air gap) ������ ����� �� ����� (�� ��������� �����)

  wst:= 2*pi*(R+g+hm+hd)*tfrac/Ns;

  // Slot bottom width  ������ ������� �����

  wsb:= wst*(R+g+hm+hd+hs)/(R+g+hm+hd);

  // Stator core back iron depth    �� ���� �������????????????????????????

  dc:= (pi*Ds*thmradl(4*p))*(Bg/Bsat);

  // Core inside radius   ���������� ������  �ore

  Rci:= R+hm+g+hd+hs;

  // Core outside radius  ������� ����� Core
  Rco:= Rci+dc;

  // Slot area   ������� �����
  Ass:= ws*hs;
  // Estimate end turn length   ������ ����� ����� �������

  // End turn travel (one end)   ����� ����� ������� (���� �����)

  laz:= pi*(R+g+hm+hd+0.5*hs)*NsctlNs;
  // End length (half coil)   ����� ����� (1/2 �������)

  le2:= pi*laz;

  // End length (axial direction)  ����� ����� (������ �����������)

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

  // Core loss calculations (per length)    ������� ������ Core (� �����)


  // Core mass per length   ����� core �� ������� �����

  Mcbperl = rhos*pi*(RcOA 2-RciA 2); % Back iron
  MctperL =rhos *(Ns*wt*hs+2*pi*R*hd-Ns*hd*wd); % Teeth
  Mcperl = McbperL + MctperL;

  // Tooth Flux Density  ��������m ������ ����

  Bt = Bg/tfrac;

  // Back iron flux density (Hanselman) ��������� ������������� ������ ������
  Bb = Bg*R/(p*dc);

  // Core back iron loss per length    Core ������� ������ ������ � �����

  PcbperL = McbperL*PO*abs(Bb/BO0)A epsb*abs(f/FO)A epsf,
  // Teeth Loss per length    ������ ����� � �����


  PctperL = MctperL*PO*abs(Bt!BO)A epsb*abs(f/FO)A epsf;

  // Total core loss per length ������ ������  � �����

  PcperL = PcbperL + PctperL;

  // Current and surface current density  ������� � ������������� ��������� ����


  // Armature turns (each slot has 2 half coils) �������� �������� (������ ���� ����� 2 ������� 1/2)

  Na = 2*p*m*Nc;

  // Arm cond area (assumes form wound)  ����-������� �������
  Aac = (As*lams)/(2*Nc);
  // Power & Current waveform factors (Lipo)  �������� � ��� �������� ������� (Lipo)

  ke 0.52;
  ki =sqrt(2);

  // Initial terminal current    ������� ��������
  la = Ns*lams*As*Ja* 1 e4/(2*q*Na);
  notfin = 1;
  Lst =0. 1; // Initial stack length     ��������� ���� �����

  = 1

  // Start loop to determine Lst, Ea, Va, and Ia   ������ ����� ��� ����������� LST, ��, ��, ia.

  notdone = 1;
  k = 0;
  while notdone == 1
  k=k+ 1;

  // Surface current density    ����������� ��������� ����

  A = 2*q*Na*Ia/(pi*Ds);

  // Calculate stack length of machine  ��������� ���� ����� ������


  // Loop to get stack length   �� ���� ��� ����������� ??????????????
  while notfin == 1

  // Gap power
  Pgap = 4*pi*ke*ki*kw*ks*kg*sin(thmrad)*(f/p)*A*Bg*(Ds^2)*Lst;

  // Length of conductor  ����� ����������
  Lac = 2*Na*(Lst+2*le2);

  // Stator resistance    ����������� �������
  Ra = Lac/(sigst*Aac);

  // Copper Loss    ������ � ����
  Pa = q*IaA2*Ra;

  // Core losses  �������� ������
  Pc = PcperL*Lst;

  // Iterate to get length    ��������, ����� �������� �����

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
  // Air-gap inductance        ��������� ����� � ������� �������������
  Lag = (q/2)*(4/pi)*(muO*NaA2*kwA2*Lst*Rs)/(pA2*(g+hm));
  // Slot leakage inductance   ��� �������������
  perm = muO*((1/3)*(hs/wst) + hd/wst);
  Las = 2*p*Lst*perm*(4*NcA2*(m-Nsp)+2*Nsp*NcA2);
  Lam = 2*p*Lst*Nsp*NcA2*perm;
  if q == 3
  Lslot = Las + 2*Lam*cos(2*pi/q); % 3 phase equation
  else
  Lslot = Las - 2*Lam*cos(2*pi/q); % multiple phases
  End

  // End-turn inductance (Hanselman)  ����� �������� ������������� (�����������)

  taus = ws + wt;// Width of slot and tooth  ������ ���� � �����

  Le = ((Nc*muO*(taus)*NaA2)/2)*log(wt*sqrt(pi)/sqrt(2*As));

  // Total inductance and reactance ����� ������������� � ������������
  Ls = Lag+Lslot+Le;
  Xs = omega*Ls;
  // Lengths, Volumes, and Weights   �����, �������� � ������
  // Armature conductor length
  Lac = 2*Na*(Lst+2*le2);

  // Mass of armature conductor   ����� �������� ����������
  Mac = q*Lac*Aac*rhoc;

  //% Overall machine length ����� ����� ������

  Lmach = Lst+2*lel;

  //% Overall diameter   �������� �������
  Dmach = 2*Rco;

  //% Core mass   �������� �����
  Mc = McperL*Lst;

  //% Magnet mass  ����� �������
  Mm = 0.5*(p*thmrad)*((R+hm)A2-RA2)*Lst*rhom;

  //% Shaft mass  ����� ����
  Ms = pi*RA2*Lst*rhos;

  Mser = 0.15*(Mc+Ms+Mm+Mac);

  //% Total mass   ����� �����
  Mtot = Mser+Mc+Ms+Mm+Mac;

  //"% Reynold's number in air gap   ����� ���������� � ��������� ������
  omegam = omega/p;
  Rey = omegam*R*g/nuair;

  //% Friction coefficient   ���������� ������
  Cf = .0725/ReyA.2;
  //% Windage losses  ������ �� ����������
  Pwind = Cf*pi*rhoair*omegamA3*RA4*Lst;

  //% Get terminal voltage   ��������� ����������� �� ������
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
