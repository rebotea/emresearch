unit SizingUnit;

interface

uses
Math;

const
  // General variables
Pwr = 16e6; // Required power (W)
rpm = 13000; // Speed (RPM)
psi = 0; // Power factor angle
Bsat = 1.65; // Stator saturation flux density

 // Rotor variables
vtip = 200; // Tip speed limit (m/s)
p = 3; // Number of pole pairs
Br = 1.2; // Magnet remnant flux density (T)
thsk = 10; // Magnet skew angle (elec deg)
PC = 5.74; // Permeance coefficient for magnets

// Stator variables
Ja = 2200; // Initial current density (A/cm2)
q = 3; // Number of phases
m = 2; // Slots/pole/phase
Nsp = 1; // Number of slots short pitched
g =0.004; // Air gap (in)
hs =0.025; // Slot depth (in)
hd =0.0005; // Slot depression depth (in)
wd = 1e-6; // Slot depression width (in)
ws =0.016; // Avg slot width (in)
Nc = 1; // Turns per coil
lams = 0.5; // Slot fill fraction
sigst = 6.0e+7; // Stator winding conductivity

// Densities
rhos = 7700; // Steel density (kg/m3)
rhom = 7400; // Magnet density (kg/m3)
rhoc = 8900; // Conductor density (kg/m3)

// Constants to be used
muO = 4*pi*1e-7; // Free space permeability
tol = 1e-2; // Tolerance factor
cpair = 1005.7; // Specific heat capacity of air (J/kg*C)
rhoair = 1.205; // Density of air at 20 C (kg/m3)
nuair = 1.5e-5; // Kinematic viscosity of air at 20 C (m2/s)
P0 = 36.79; // Base Power Losss, W/lb
FO = 1000; // Base freuency, 60 Hz
BO = 1.0; // Base flux density, 1.0 T
epsb = 2.12;
epsf= 1.68;

type
TEFRROutput = record
  R, Ns:extended;
end;

MDTWAGFDOutput = record
end;

ValOutput = record
end;

MGFOutput = record
end;

MFIOutput = record
end;

IROutput =record
end;

function ElectricalFrequencyRotorRadius(p, q, m: extended): TEFRROutput;
function MagnetDimensionsToothWidthAirGapFluxDensity(Ns, PC, R, Ws, Bg, Bsat, ge, eratio :extended): MDTWAGFDOutput;
function Values(thme, p, ge, Cphi, PC, R, G, wt, ws, hd, Ns, tfrac, wst, wsb, dc, Rci, Rco, lel, Nsct: extended): ValOutput;
function MagneticGapFactor(le2, kw, ks, thmrad, R, hm, g, A, p, rhos, Rc, Ns, wt, hs, hd, wd, Bg, tfrac, dc, epsf, epsb, FO, f, BO, lams, m, Ja, As1, q, Ds, pi: extended): MGFOutput;
function MagneticFluxInternalVoltage(thmrad, thm, pi, Bg, kg, p, Rs, Lst, Na, kw, ks, omega, Ea: extended): MFIOutput;
function InductancesReactances(Pa, Ra, lel, Aac, le2, As1, q, pi, Ia, Na, kw, Rs, g, hm, hs, wst, hd, Lst, perm, Nc, Ns, ws, wt, rhoc, McperL, thmrad, omega, R, nuair, Ea, muO, Pin, Ja, Ptemp, Perr, Pwind, Rey, Mser, Mm, Mc, Dmach, Lmach, Mac, Lac, Lslot: extended): IROutput;


implementation

function ElectricalFrequencyRotorRadius(p, q, m: extended):TEFRROutput;
var
f, omega, floor, gama, Nsfp, Nsct, alfa, Ks, kw, kp, kb, ths : extended;
begin
  f:= p*rpm/60;
  omega:= 2*pi*f;
  Result.R:= p*vtip/omega;

  // Winding & skew factors
  Result.Ns:= floor*(2*q*p*m); // Number of slots
  gama:= 2*pi*p/Result.Ns;
  Nsfp:= floor*(Result.Ns/(2*p));
  Nsct:= Nsfp - Nsp;
  alfa:= pi*Nsct/Nsfp;
  kp:= sin(pi/2)*sin(alfa/2);
  kb:= sin(m*gama/2)/(m*sin(gama/2));
  kw:= kp*kb;
  ths:= ((p*thsk)+1e-6)*(pi/180); // skew angle (elec rad)
  ks:= sin(ths/2)/(ths/2);

end;

function MagnetDimensionsToothWidthAirGapFluxDensity(Ns, PC, R, Ws, Bg, Bsat, ge, eratio :extended): MDTWAGFDOutput;
var
thme, alpham, Cphi, hm, Ds, K1, Kr, murec, wt, taus, Kc: Extended;
notdone: boolean;
begin
  thme:= 1; // Initial Magnet angle (deg e)
  notdone:= true;
  ge:= g; // Initial effective air gap
  while notdone= true do
  begin
    alpham:= thme/180; // Pitch coverage coefficient
    Cphi:= (2*alpham)/(1+alpham); // Flux concentration factor
    hm:= ge*Cphi*PC; // Magnet height
    Ds:= 2*(R+hm+g); // Inner stator/air gap diameter
    K1:= 0.95; // Leakage factor
    Kr:= 1.05; // Reluctance factor
    murec:= 1.05; // Recoil permeability
    Bg:= ((K1*Cphi)/(1+(Kr*murec/PC)))*Br;
    wt:= ((pi*Ds)/Ns)*(Bg/Bsat); // Tooth width
    taus:= ws + wt; // Width of slot and tooth
    Kc:= 1/(1-(1/((taus/ws)*((5*g/ws)+1)))); // Carter's coefficient
    ge:= Kc*g;
    eratio:= ws/wt;
    if abs(eratio - 1) < tol then
     notdone:= false
    else
    thme:= thme + 1;
  end;
end;

function Values(thme, p, ge, Cphi, PC, R, G, wt, ws, hd, Ns, tfrac, wst, wsb, dc, Rci, Rco, lel, Nsct: extended): ValOutput;
var
thm, thmrad, hm, Ds, Bg, As1, laz, le2: extended;
begin
  thm:= thme/p; // Magnet physical angle
  thmrad:= thm*(pi/180);
  hm:= ge*Cphi*PC; // Magnet height
  Ds:= 2*(R+hm+g); // Inner stator/air gap diameter
  // Generate geometry of machine
  // Peripheral tooth fraction
  tfrac:= wt/(wt+ws);
  // Slot top width (at air gap)
  wst:= 2*pi*(R+g+hm+hd)*tfrac/Ns;
  // Slot bottom width
  wsb:= wst*(R+g+hm+hd+hs)/(R+g+hm+hd);
  // Stator core back iron depth
  dc:= (pi*Ds*thmrad/(4*p))*(Bg/Bsat);
  // Core inside radius
  Rci:= R+hm+g+hd+hs;

  // Core outside radius
  Rco:= Rci+dc;

  // Slot area
  As1:= ws*hs;
  // Estimate end turn length
  // End turn travel (one end)
  laz:= pi*(R+g+hm+hd+0.5*hs)*Nsct/Ns;
  // End length (half coil)
  le2:= pi*laz;
  // End length (axial direction)
  lel:= 2*le2/(2*pi);
 end;

function MagneticGapFactor(le2, kw, ks, thmrad, R, hm, g, A, p, rhos, Rc, Ns, wt, hs, hd, wd, Bg, tfrac, dc, epsf, epsb, FO, f, BO, lams, m, Ja, As1, q, Ds, pi: extended): MGFOutput;
var
Pwr, Pc, error1, Ptemp1, Ra, Pa, Lac, Pgap, Aac, k, ke, ki, Ia, Lst, i, Rs, Ri, R1, R2, kg, McbperL, MctperL, McperL, Rco, Rci, Bt, Bb, PcbperL, PctperL, PcperL, P0, B0, Na: extended;
 notfin, notdone: boolean;
begin
  Rs:= R+hm+g;
  Ri:= R;
  R1:= R;
  R2:= R+hm;
  kg:= ((power(Ri,(p-1)))/(power(RS,(2*p))-power(Ri,(2*p))))*((p/(p+1))*(power(R2,(p+1))-power(Ri,(p+ 1)))+(power(p*RS,(2*p))/(p- 1))*(power(R1, (1-p))-power(R2,(1-p))));
  // Core loss calculations (per length)
  // Core mass per length
  McbperL:= rhos*pi*(sqr(Rco) - sqr(Rci)); //% Back iron
  MctperL:=rhos *(Ns*wt*hs+2*pi*R*hd-Ns*hd*wd); //% Teeth
  McperL:= McbperL + MctperL;
  // Tooth Flux Density
  Bt:= Bg/tfrac;
  // Back iron flux density (Hanselman)
  Bb:= Bg*R/(p*dc);
  // Core back iron loss per length
  PcbperL:= McbperL*P0*power(abs(Bb/B0),epsb) * power(abs(f/FO), epsf);
  // Teeth Loss per length
  PctperL:= MctperL*P0*power(abs(Bt/B0), epsb) * power(abs(f/FO), epsf);
  // Total core loss per length
  PcperL:= PcbperL + PctperL;
  // Current and surface current density
  // Armature turns (each slot has 2 half coils)
  Na:= 2*p*m*Nc;
  // Arm cond area (assumes form wound)
  Aac:= (As1*lams)/(2*Nc);
  // Power & Current waveform factors (Lipo)
  ke:= 0.52;
  ki:=sqrt(2);
  // Initial terminal current
  Ia:= Ns*lams*As1*Ja* 1e4/(2*q*Na);
  notfin:= true;
  Lst:=0.1; // Initial stack length
  i:= 1;
  // Start loop to determine Lst, Ea, Va, and Ia
  notdone:= true;
  k:= 0;
  while notdone = true do
  begin
    k:=k+ 1;
    // Surface current density
    A:= 2*q*Na*Ia/(pi*Ds);
    // Calculate stack length of machine
    // Loop to get stack length
     while notfin = true do
     begin
      // Gap power
      Pgap:= 4*pi*ke*ki*kw*ks*kg*sin(thmrad)*(f/p)*A*Bg*sqr(Ds)*Lst;
      // Length of conductor
      Lac:= 2*Na*(Lst+2*le2);
      // Stator resistance
      Ra:= Lac/(sigst*Aac);
      // Copper Loss
      Pa:= q*sqr(Ia)*Ra;
      // Core losses
      Pc:= PcperL*Lst;
      // Iterate to get length
      Ptemp1:= Pgap-Pa-Pc;
      error1:= Pwr/Ptemp1;
//      err(i):= error;
      if abs(error1-1) < tol then
      notfin:= false
      else
      begin
        Lst:= Lst*error1;
        i:=i+ 1;
      end;
     end;
  end;
end;

function MagneticFluxInternalVoltage(thmrad, thm, pi, Bg, kg, p, Rs, Lst, Na, kw, ks, omega, Ea: extended): MFIOutput;
var
B1, lambda: extended;
begin
  thmrad:= thm*(pi/180);
  B1:= (4/pi)*Bg*kg*sin(p*thmrad/2);
  lambda:= 2*Rs*Lst*Na*kw*ks*B1/p;
  Ea:= omega*lambda/sqrt(2); // RMS back voltage
end;

function InductancesReactances(Pa, Ra, lel, Aac, le2, As1, q, pi, Ia, Na, kw, Rs, g, hm, hs, wst, hd, Lst, perm, Nc, Ns, ws, wt, rhoc, McperL, thmrad, omega, R, nuair, Ea, muO, Pin, Ja, Ptemp, Perr, Pwind, Rey, Mser, Mm, Mc, Dmach, Lmach, Mac, Lac, Lslot: extended): IROutput;
var
Perror, pf, eff, Lag, Las, Lam,  taus, Le, Ls, Xs, Rco, Ms, Mtot, omegam, Cf, xa, Va, k, Pout, Pwr, Jao, Pco, Pc, Pwindo, Pao, wso, hso, wto, dco, dc, Lso, hmo, go: extended;
notdone: boolean;
fprintf: string;
begin
  // Air-gap inductance
  Lag:= (q/2)*(4/pi)*(muO*sqr(Na)*sqr(kw)*Lst*Rs)/(sqr(p)*(g+hm));
  // Slot leakage inductance
  perm:= muO*((1/3)*(hs/wst) + hd/wst);
  Las:= 2*p*Lst*perm*(4*sqr(Nc)*(m-Nsp)+2*Nsp*sqr(Nc));
  Lam:= 2*p*Lst*Nsp*sqr(Nc)*perm;
  if q= 3 then
  Lslot:= Las + 2*Lam*cos(2*pi/q) //% 3 phase equation
  else
  Lslot:= Las - 2*Lam*cos(2*pi/q); //% multiple phases

  // End-turn inductance (Hanselman)
  taus:= ws + wt; //% Width of slot and tooth
  Le:= ((Nc*muO*(taus)*sqr(Na))/2)*ln(wt*sqrt(pi)/sqrt(2*As1));

  // Total inductance and reactance
  Ls:= Lag+Lslot+Le;
  Xs:= omega*Ls;
  // Lengths, Volumes, and Weights
  // Armature conductor length
  Lac:= 2*Na*(Lst+2*le2);

  // Mass of armature conductor
  Mac:= q*Lac*Aac*rhoc;

  //% Overall machine length
  Lmach:= Lst+2*lel;

  //% Overall diameter
  Dmach:= 2*Rco;

  //% Core mass
  Mc:= McperL*Lst;

  //% Magnet mass
  Mm:= 0.5*(p*thmrad)*(sqr(R+hm)-sqr(R))*Lst*rhom;

  //% Shaft mass
  Ms:= pi*sqr(R)*Lst*rhos;
  //% 15% service fraction
  Mser:= 0.15*(Mc+Ms+Mm+Mac);

  //% Total mass
  Mtot:= Mser+Mc+Ms+Mm+Mac;
  //"% Gap friction losses
  //"% Reynold's number in air gap
  omegam:= omega/p;
  Rey:= omegam*R*g/nuair;

  //% Friction coefficient
  Cf:= 0.0725/power(Rey,0.2);
  //% Windage losses
  Pwind:= Cf*pi*rhoair*power(omegam,3)*power(R,4)*Lst;

  //% Get terminal voltage
  xa:= Xs*Ia/Ea;
  Va:= sqrt(sqr(Ea)-((Xs+Ra)*Ia*sqr(cos(psi))))-(Xs+Ra)*Ia*sin(psi);
  Ptemp:= q*Va*Ia*cos(psi)-Pwind;
  Perror:= Pwr/Ptemp;
  //Perr(k):= Perror;
  if abs(Perror-1) < tol then
  notdone:= false
  else
  Ia:= Ia*Perror;

  //% Remaining performance parameters

  //% Current density
  Ja:= Ia/Aac;
  //% Power and efficiency
  Pin:= Pwr+Pc+Pa+Pwind;
  eff:= Pwr/Pin;
  pf:= cos(psi);

  fprintf:= 'pm2calc complete: Ready.\n';
  //"%Jo nathan Rucker, MIT Thesis
  //"%M ay 2005
  //"%P rogram: pm2output
  //"%P rogram outputs values from pm2calc.
  //"%Pr ogram developed from J.L. Kirtley script with permission
  //"%M UST RUN pm2input and pm2calc PRIOR TO RUNNING pm2output
  //"%V ariables for output display
  Pout:=Pwr/1e3;
  Jao:=Ja/1e4;
  Pco:=Pc/1e3;
  Pwindo:= Pwind/1e3;
  Pao:=Pa/1e3;
  wso:= ws*1000;
  hso:= hs* 1000;
  wto:= wt* 1000;
  dco:= dc* 1000;
  Lso:=Ls* 1000;
  hmo:= hm* 1000;
  go:= g*1000;

end;
end.
