unit SizingUnit;

interface

uses
Math;

const
{// General variables
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
g = 0.004; // Air gap (in)
hs = 0.025; // Slot depth (in)
hd = 0.0005; // Slot depression depth (in)
wd = 1e-6; // Slot depression width (in)
ws = 0.016; // Avg slot width (in)
Nc = 1; // Turns per coil
lams = 0.5; // Slot fill fraction
sigst = 6.0e+7; // Stator winding conductivity
}
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
f, omega, floor, gama, Nsfp, Nsct, alfa, Ks, kw, kp, kb, ths, R, Ns:extended;
end;

MDTWAGFDOutput = record
thme, alpham, Cphi, hm, Ds, K1, Kr, murec, wt, taus, Kc: Extended;
notdone: boolean;
end;

ValOutput = record
thm, thmrad, hm, Ds, Bg, As1, laz, le2: extended;
end;

MGFOutput = record
Pwr, Pc, error1, Ptemp1, Ra, Pa, Lac, Pgap, Aac, k, ke, ki, Ia, Lst, i, Rs, Ri, R1, R2, kg, McbperL, MctperL, McperL, Rco, Rci, Bt, Bb, PcbperL, PctperL, PcperL, P0, B0, Na: extended;
 notfin, notdone: boolean;
end;

MFIOutput = record
B1, lambda: extended;
end;

IROutput =record
Perror, pf, eff, Lag, Las, Lam,  taus, Le, Ls, Xs, Rco, Ms, Mtot, omegam, Cf, xa, Va, k, Pout, Pwr, Jao, Pco, Pc, Pwindo, Pao, wso, hso, wto, dco, dc, Lso, hmo, go: extended;
notdone: boolean;
fprintf: string;
end;

function ElectricalFrequencyRotorRadius(floor, p, q, m, rpm, vtip, Nsp, thsk: extended): TEFRROutput;
function MagnetDimensionsToothWidthAirGapFluxDensity(Ns, PC, R, Ws, Bg, Bsat, ge, eratio, g, Br, tol :extended): MDTWAGFDOutput;
function Values(thme, p, ge, Cphi, PC, R, G, wt, ws, hd, Ns, tfrac, wst, wsb, dc, Rci, Rco, lel, Nsct, hs, Bsat: extended): ValOutput;
function MagneticGapFactor(Pwr, Nc, sigst, tol, le2, kw, ks, thmrad, R, hm, g, A, p, rhos, Rc, Ns, wt, hs, hd, wd, Bg, tfrac, dc, epsf, epsb, FO, f, BO, lams, m, Ja, As1, q, Ds, pi: extended): MGFOutput;
function MagneticFluxInternalVoltage(thmrad, thm, pi, Bg, kg, p, Rs, Lst, Na, kw, ks, omega, Ea: extended): MFIOutput;
function InductancesReactances(Pwr, p, m, Nsp, rhom, rhos, rhoair, psi, tol, Pa, Ra, lel, Aac, le2, As1, q, pi, Ia, Na, kw, Rs, g, hm, hs, wst, hd, Lst, perm, Nc, Ns, ws, wt, rhoc, McperL, thmrad, omega, R, nuair, Ea, muO, Pin, Ja, Ptemp, Perr, Pwind, Rey, Mser, Mm, Mc, Dmach, Lmach, Mac, Lac, Lslot: extended): IROutput;

implementation

function ElectricalFrequencyRotorRadius(floor, p, q, m, rpm, vtip, Nsp, thsk: extended): TEFRROutput;
begin
  result.f:= p*rpm/60;
  result.omega:= 2*pi*result.f;
  Result.R:= p*vtip/result.omega;

  // Winding & skew factors
  Result.Ns:= floor *(2*q*p*m); // Number of slots
  result.gama:= 2*pi*p/Result.Ns;
  result.Nsfp:= floor *(Result.Ns/(2*p));
  result.Nsct:= result.Nsfp - Nsp;
  result.alfa:= pi*result.Nsct/result.Nsfp;
  result.kp:= sin(pi/2)*sin(result.alfa/2);
  result.kb:= sin(m*result.gama/2)/(m*sin(result.gama/2));
  result.kw:= result.kp*result.kb;
  result.ths:= ((p*thsk)+1e-6)*(pi/180); // skew angle (elec rad)
  result.ks:= sin(result.ths/2)/(result.ths/2);
end;

function MagnetDimensionsToothWidthAirGapFluxDensity(Ns, PC, R, Ws, Bg, Bsat, ge, eratio, g, Br, tol :extended): MDTWAGFDOutput;
begin
  result.thme:= 1; // Initial Magnet angle (deg e)
  result.notdone:= true;
  ge:= g; // Initial effective air gap
  while result.notdone= true do
  begin
    result.alpham:= result.thme/180; // Pitch coverage coefficient
    result.Cphi:= (2*result.alpham)/(1+result.alpham); // Flux concentration factor
    result.hm:= ge*result.Cphi*PC; // Magnet height
    result.Ds:= 2*(R+result.hm+g); // Inner stator/air gap diameter
    result.K1:= 0.95; // Leakage factor
    result.Kr:= 1.05; // Reluctance factor
    result.murec:= 1.05; // Recoil permeability
    Bg:= ((result.K1*result.Cphi)/(1+(result.Kr*result.murec/PC)))*Br;
    result.wt:= ((pi*result.Ds)/Ns)*(Bg/Bsat); // Tooth width
    result.taus:= ws + result.wt; // Width of slot and tooth
    result.Kc:= 1/(1-(1/((result.taus/ws)*((5*g/ws)+1)))); // Carter's coefficient
    ge:= result.Kc*g;
    eratio:= ws/result.wt;
    if abs(eratio - 1) < tol then
     result.notdone:= false
    else
    result.thme:= result.thme + 1;
  end;
end;

function Values(thme, p, ge, Cphi, PC, R, G, wt, ws, hd, Ns, tfrac, wst, wsb, dc, Rci, Rco, lel, Nsct, hs, Bsat: extended): ValOutput;
begin
  result.thm:= thme/p; // Magnet physical angle
  result.thmrad:= result.thm*(pi/180);
  result.hm:= ge*Cphi*PC; // Magnet height
  result.Ds:= 2*(R+result.hm+g); // Inner stator/air gap diameter
  // Generate geometry of machine
  // Peripheral tooth fraction
  tfrac:= wt/(wt+ws);
  // Slot top width (at air gap)
  wst:= 2*pi*(R+g+result.hm+hd)*tfrac/Ns;
  // Slot bottom width
  wsb:= wst*(R+g+result.hm+hd+hs)/(R+g+result.hm+hd);
  // Stator core back iron depth
  dc:= (pi*result.Ds*result.thmrad/(4*p))*(result.Bg/Bsat);
  // Core inside radius
  Rci:= R+result.hm+g+hd+hs;
  // Core outside radius
  Rco:= Rci+dc;
  // Slot area
  result.As1:= ws*hs;
  // Estimate end turn length
  // End turn travel (one end)
  result.laz:= pi*(R+g+result.hm+hd+0.5*hs)*Nsct/Ns;
  // End length (half coil)
  result.le2:= pi*result.laz;
  // End length (axial direction)
  lel:= 2*result.le2/(2*pi);
 end;

function MagneticGapFactor(Pwr, Nc, sigst, tol, le2, kw, ks, thmrad, R, hm, g, A, p, rhos, Rc, Ns, wt, hs, hd, wd, Bg, tfrac, dc, epsf, epsb, FO, f, BO, lams, m, Ja, As1, q, Ds, pi: extended): MGFOutput;
begin
  result.Rs:= R+hm+g;
  result.Ri:= R;
  result.R1:= R;
  result.R2:= R+hm;
  result.kg:= ((power(result.Ri,(p-1)))/(power(result.RS,(2*p))-power(result.Ri,(2*p))))*((p/(p+1))*(power(result.R2,(p+1))-power(result.Ri,(p+ 1)))+(power(p*result.RS,(2*p))/(p- 1))*(power(result.R1, (1-p))-power(result.R2,(1-p))));
  // Core loss calculations (per length)
  // Core mass per length
  result.McbperL:= rhos*pi*(sqr(result.Rco) - sqr(result.Rci)); //% Back iron
  result.MctperL:=rhos *(Ns*wt*hs+2*pi*R*hd-Ns*hd*wd); //% Teeth
  result.McperL:= result.McbperL + result.MctperL;
  // Tooth Flux Density
  result.Bt:= Bg/tfrac;
  // Back iron flux density (Hanselman)
  result.Bb:= Bg*R/(p*dc);
  // Core back iron loss per length
  result.PcbperL:= result.McbperL*P0*power(abs(result.Bb/result.B0),epsb) * power(abs(f/FO), epsf);
  // Teeth Loss per length
  result.PctperL:= result.MctperL*P0*power(abs(result.Bt/result.B0), epsb) * power(abs(f/FO), epsf);
  // Total core loss per length
  result.PcperL:= result.PcbperL + result.PctperL;
  // Current and surface current density
  // Armature turns (each slot has 2 half coils)
  result.Na:= 2*p*m*Nc;
  // Arm cond area (assumes form wound)
  result.Aac:= (As1*lams)/(2*Nc);
  // Power & Current waveform factors (Lipo)
  result.ke:= 0.52;
  result.ki:=sqrt(2);
  // Initial terminal current
  result.Ia:= Ns*lams*As1*Ja* 1e4/(2*q*result.Na);
  result.notfin:= true;
  result.Lst:=0.1; // Initial stack length
  result.i:= 1;
  // Start loop to determine Lst, Ea, Va, and Ia
  result.notdone:= true;
  result.k:= 0;
  while result.notdone = true do
  begin
    result.k:=result.k+ 1;
    // Surface current density
    A:= 2*q*result.Na*result.Ia/(pi*Ds);
    // Calculate stack length of machine
    // Loop to get stack length
     while result.notfin = true do
     begin
       // Gap power
       result.Pgap:= 4*pi*result.ke*result.ki*kw*ks*result.kg*sin(thmrad)*(f/p)*A*Bg*sqr(Ds)*result.Lst;
       // Length of conductor
       result.Lac:= 2*result.Na*(result.Lst+2*le2);
       // Stator resistance
       result.Ra:= result.Lac/(sigst*result.Aac);
       // Copper Loss
       result.Pa:= q*sqr(result.Ia)*result.Ra;
       // Core losses
       result.Pc:= result.PcperL*result.Lst;
       // Iterate to get length
       result.Ptemp1:= result.Pgap-result.Pa-Result.Pc;
       result.error1:= Pwr/result.Ptemp1;
//     err(i):= error;
       if abs(result.error1-1) < tol then
       result.notfin:= false
       else
       begin
         result.Lst:= result.Lst*result.error1;
         result.i:=result.i+ 1;
      end;
     end;
  end;
end;

function MagneticFluxInternalVoltage(thmrad, thm, pi, Bg, kg, p, Rs, Lst, Na, kw, ks, omega, Ea: extended): MFIOutput;
begin
  thmrad:= thm*(pi/180);
  result.B1:= (4/pi)*Bg*kg*sin(p*thmrad/2);
  result.lambda:= 2*Rs*Lst*Na*kw*ks*result.B1/p;
  Ea:= omega*result.lambda/sqrt(2); // RMS back voltage
end;

function InductancesReactances(Pwr, p, m, Nsp, rhom, rhos, rhoair, psi, tol, Pa, Ra, lel, Aac, le2, As1, q, pi, Ia, Na, kw, Rs, g, hm, hs, wst, hd, Lst, perm, Nc, Ns, ws, wt, rhoc, McperL, thmrad, omega, R, nuair, Ea, muO, Pin, Ja, Ptemp, Perr, Pwind, Rey, Mser, Mm, Mc, Dmach, Lmach, Mac, Lac, Lslot: extended): IROutput;
begin
  // Air-gap inductance
  result.Lag:= (q/2)*(4/pi)*(muO*sqr(Na)*sqr(kw)*Lst*Rs)/(sqr(p)*(g+hm));
  // Slot leakage inductance
  perm:= muO*((1/3)*(hs/wst) + hd/wst);
  result.Las:= 2*p*Lst*perm*(4*sqr(Nc)*(m-Nsp)+2*Nsp*sqr(Nc));
  result.Lam:= 2*p*Lst*Nsp*sqr(Nc)*perm;
  if q= 3 then
  Lslot:= result.Las + 2*result.Lam*cos(2*pi/q) //% 3 phase equation
  else
  Lslot:= result.Las - 2*result.Lam*cos(2*pi/q); //% multiple phases
  // End-turn inductance (Hanselman)
  result.taus:= ws + wt; //% Width of slot and tooth
  result.Le:= ((Nc*muO*(result.taus)*sqr(Na))/2)*ln(wt*sqrt(pi)/sqrt(2*As1));
  // Total inductance and reactance
  result.Ls:= result.Lag+Lslot+result.Le;
  result.Xs:= omega*result.Ls;
  // Lengths, Volumes, and Weights
  // Armature conductor length
  Lac:= 2*Na*(Lst+2*le2);
  // Mass of armature conductor
  Mac:= q*Lac*Aac*rhoc;
  //% Overall machine length
  Lmach:= Lst+2*lel;
  //% Overall diameter
  Dmach:= 2*result.Rco;
  //% Core mass
  Mc:= McperL*Lst;
  //% Magnet mass
  Mm:= 0.5*(p*thmrad)*(sqr(R+hm)-sqr(R))*Lst*rhom;
  //% Shaft mass
  result.Ms:= pi*sqr(R)*Lst*rhos;
  //% 15% service fraction
  Mser:= 0.15*(Mc+result.Ms+Mm+Mac);
  //% Total mass
  result.Mtot:= Mser+Mc+result.Ms+Mm+Mac;
  //"% Gap friction losses
  //"% Reynold's number in air gap
  result.omegam:= omega/p;
  Rey:= result.omegam*R*g/nuair;
  //% Friction coefficient
  result.Cf:= 0.0725/power(Rey,0.2);
  //% Windage losses
  Pwind:= result.Cf*pi*rhoair*power(result.omegam,3)*power(R,4)*Lst;
  //% Get terminal voltage
  result.xa:= result.Xs*Ia/Ea;
  result.Va:= sqrt(sqr(Ea)-((result.Xs+Ra)*Ia*sqr(cos(psi))))-(result.Xs+Ra)*Ia*sin(psi);
  Ptemp:= q*result.Va*Ia*cos(psi)-Pwind;
  result.Perror := Pwr/Ptemp;
  //Perr(k):= Perror;
  if abs(result.Perror-1) < tol then
  result.notdone:= false
  else
  Ia:= Ia*result.Perror;
  //% Remaining performance parameters
  //% Current density
  Ja:= Ia/Aac;
  //% Power and efficiency
  Pin:= Pwr+Result.Pc+Pa+Pwind;
  result.eff:= Pwr/Pin;
  result.pf:= cos(psi);
  result.fprintf:= 'pm2calc complete: Ready.\n';
  //"%Jo nathan Rucker, MIT Thesis
  //"%M ay 2005
  //"%P rogram: pm2output
  //"%P rogram outputs values from pm2calc.
  //"%Pr ogram developed from J.L. Kirtley script with permission
  //"%M UST RUN pm2input and pm2calc PRIOR TO RUNNING pm2output
  //"%V ariables for output display
  result.Pout:=Pwr/1e3;
  result.Jao:=Ja/1e4;
  result.Pco:=Result.Pc/1e3;
  result.Pwindo:= Pwind/1e3;
  result.Pao:=Pa/1e3;
  result.wso:= ws*1000;
  result.hso:= hs* 1000;
  result.wto:= wt* 1000;
  result.dco:= result.dc* 1000;
  result.Lso:= result.Ls* 1000;
  result.hmo:= hm* 1000;
  result.go:= g*1000;
end;
end.
