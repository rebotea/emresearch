unit BasicSizingMethodUnit1;
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,math,
  Dialogs;





implementation

  procedure BasicSizingMethod(var hs,lams,conv1,conv2,Pwr,Vtip,LovD,omega,Stress,P,Bg,Lst,hscm,R,D,f,rpm,Kz,Ja:Extended );
  procedure SizingMethod(var Pwr,rpm,psi,R,hm,Lst,p,Br,thm,thsk,q,Ns,Nsp,g,tfrac,hs,hd,wd,syrat,Nc,lams,sigst,rhos,rhom,rhoc,tol,cpair,rhoair,nuair,P0,F0,B0,epsb,epsf,omega,Kc,Ea,m,Na,wt,wst,wsb,dc,Nsfp,Nsct,laz,le2,lel,f,vtip,gama,alfa,kp,kb,kw,ths,ks,Rs,Ri,R1,R2,kg,KI,Kr,murec,ws,taus,ge,Cphi,PC,Bg,thmrad,B1,lambda,Lag,perm,Las,Lam,Lslot,As1,Le,Ls,Xs,Lac,Aac,Mac,Lmach,Rci,Rco,Dmach,Mcb,
Mct,Mc,Mm,Ms,Mser,Mtot,Ra,Bt,Bb,Pcb,Pct,i,notdone,la,xa,Pa,omegam,Rey,Cf,Pwind,Va,Ptemp,error,Ia,Ja,Pin,eff,pf,Pout,Jao,Pco,Pwindo,Pao,wso,hso,wto,dco,Lso,hmo,go:Extended);
 {$R *.dfm}

procedure BasicSizingMethod(var hs,lams,conv1,conv2,Pwr,Vtip,LovD,omega,Stress,P,Bg,Lst,hscm,R,D,f,rpm,Kz,Ja:Extended) ;
begin
//General variables

// Constants & conversion factors

hs:=0.015; // Assume slot depth of 15 mm
lams:=0.5; // Assume slot fill fraction
conv1:=9.81; // 9.81 W per Nm/s
conv2:=703.0696; // 703.0696 N/m2 per psi

// INPUTS

Pwr:=16e6; // Required power
vtip:=200; // Max tip speed (m/s)
LovD:=2.851 ; // Wound rotor usually 0.5-1.0, PM 1.0-3.0

// Shear stress usually 1-10 psi small machines, 10-20 large liquid
// liquid cooled machines

stress:=15;
p:=3; // Pole pairs
Bg:=0.8; // Tesla

// Calculations
// Size
// Initially use

Pwr:=2*pi*R*Lst*stress*vtip ;
Lst:=2*LovD*R;
hscm:=hs*100;
R:=sqrt(Pwr/(2*pi*(LovD*2)*vtip*stress*convl*conv2));
D:=2*R;
Lst:=LovD*D;

// Speed
omega:=(p*vtip)/R;
f:=omega/(2*pi);
rpm:=(60*f)/p;

// Current densities
Kz:=(stress*conv2)/(Bg*100);
Ja:=10*Kz/(hscm*lams);
end;



procedure SizingMethod(var Pwr,rpm,psi,R,hm,Lst,p,Br,thm,thsk,q,Ns,Nsp,g,tfrac,hs,hd,wd,syrat,Nc,lams,sigst,rhos,rhom,rhoc,tol,cpair,rhoair,nuair,P0,F0,B0,epsb,epsf,omega,Kc,Ea,m,Na,wt,wst,wsb,dc,Nsfp,Nsct,laz,le2,lel,f,vtip,gama,alfa,kp,kb,kw,ths,ks,Rs,Ri,R1,R2,kg,KI,Kr,murec,ws,taus,ge,Cphi,PC,Bg,thmrad,B1,lambda,Lag,perm,Las,Lam,Lslot,As1,Le,Ls,Xs,Lac,Aac,Mac,Lmach,Rci,Rco,Dmach,Mcb,
Mct,Mc,Mm,Ms,Mser,Mtot,Ra,Bt,Bb,Pcb,Pct,i,notdone,la,xa,Pa,omegam,Rey,Cf,Pwind,Va,Ptemp,error,Ia,Ja,Pin,eff,pf,Pout,Jao,Pco,Pwindo,Pao,wso,hso,wto,dco,Lso,hmo,go:Extended);

begin

 // General variables

  Pwr:=16e6; // Required power (W)
  rpm:=13000; // Speed (RPM)
  psi:=0; // Power factor angle

// Rotor variables

  R:=0.147; // Rotor radius (m)
  hm:=0.025; // Magnet thickness (m)
  Lst:=0.838; // Rotor stack length (m)
  p:=3; // Number of pole pairs
  Br:=1.2; // Magnet remnant flux density (T)
  thm:=50; // Magnet physical angle (deg)
  thsk:=10; // Magnet skew angle (actual deg)

// Stator variables

  q:= 3; // Number of phases
  Ns:=36; // Number of slots
  Nsp:= 1; // Number of slots short pitched
  g:= 0.004; // Air gap (m)
  tfrac:= 0.5; // Peripheral tooth fraction
  hs:=0.025; // Slot depth (m)
  hd:=0.0005; // Slot depression depth (m)
  wd:=1e-6; // Slot depression width (m)
  syrat:=0.7;// Stator back iron ratio (yoke thick/rotor radius)
  Nc:=1; // Turns per coil
  lams:=0.5; // Slot fill fraction
  sigst:=6.0e+7; // Stator winding conductivity

// Densities

  rhos:=7700; // Steel density (kg/m3)
  rhom:=7400; // Magnet density (kg/m3)
  rhoc:=8900; // Conductor density (kg/m3)

//Constants to be used

  mu0:=4*pi*le-7; // Free space permeability
  tol:=1e-2; // Tolerance factor
  cpair:=1005.7; // Specific heat capacity of air (J/kg*C)
  rhoair:=1.205; // Density of air at 20 C (kg/m3)
  nuair:=1.5e-5; // Kinematic viscosity of air at 20 C (m2/s)
  P0:=36.79; // Base Power Losss, W/lb
  FO:=1000; // Base freuency, 60 Hz
  B0:=1.0; // Base flux density, 1.0 T
  epsb:=2.12;
  epsf:=1.68;

// Generate geometry of machine

  m:= Ns/(2*p*q); //Number of slots/pole/phase
  Na:=2*p*m*Nc; //Number of armature turns (each slot has 2 half coils)
  wt:=2*pi*(R+g+hm+hd)*tfrac/Ns; //Tooth width
  wst:=2*pi*(R+g+hm+hd)*(1-tfrac)/Ns;// Slot top width (at air gap)
  wsb:=wst*(R+g+hd+hs)/(R+g+hm+hd); // Slot bottom width
  dc:=syrat*R/p;// Stator core back iron depth (as p increases, dc decreases)
  Nsfp:=floor(Ns/(2*p)); // Full-pitch coil throw
  Nsct:=Nsfp - Nsp;  // Actual coil throw

// Estimate end turn length

  laz:=pi*(R+g+hm+hd+0.5*hs)*Nsct/Ns;// End turn travel (one end)

  le2:=pi*laz;// End length (half coil)

  lel:=2*le2/(2*pi);// End length (axial direction)

// Calculate electrical frequency & surface speed

  f:=p*rpm/60;
  omega:=2*pi*f;
  vtip:=R*omega/p;

// Winding & skew factors

  gama:=2*pi*p/Ns;
  alfa:=pi*Nsct/Nsfp;
  kp:=sin(pi/2)*sin(alfa/2);
  kb:=sin(m*gama/2)/(m*sin(gama/2));
  kw:=kp*kb;
  ths:=((p*thsk)+le-6)*(pi/180); // skew angle (elec rad)
  ks:= sin(ths/2)/(ths/2);

// Calculate magnetic gap factor

  Rs:= R+hm+g;
  Ri:=R;
  R1:=R;
  R2:=R+hm;
  kg := (power(Ri,(p-1))/(power(Rs,(2*p))-power(Ri,(2*p))))*((p/(p+l))*(power(R2,(p+l))-power(R1^(p+l)))+(p*power(Rs,(2*p))/(p-1))*(power(R1,(1-p))-power(R2,(1-p))));

// Calculate air gap magnetic flux density
// Account for slots, reluctance, and leakage

  ws := (wst+wsb)/2; // Average slot width
  taus:=  ws + wt; // Width of slot and tooth
  Kc :=  1/(1-(1/((taus/ws)*((5*g/ws)+l))));
  ge :=  Kc*g;
  Cphi:=  (p*thm)/180; // Flux concentration factor
  KI :=  0.95; // Leakage factor
  Kr :=  1.05; // Reluctance factor
  murec :=  1.05; // Recoil permeability
  PC :=  hm/(ge*Cphi); // Permeance coefficient
  Bg :=  ((KI*Cphi)/(1+(Kr*murec/PC)))*Br;


// Calculate magnetic flux and internal voltage
  thmrad :=  thm*(pi/180);
  BI :=  (4/pi)*Bg*kg*sin(p*thmrad/2);
  lambda :=  2*Rs*Lst*Na*kw*ks*Bl/p;
  Ea :=  omega*lambda/sqrt(2); // RMS back voltage

// Calculation of inductances/reactances

// Air-gap inductance
  Lag:=((q/2)*(4/pi)*(muo*power(Na,2)*power(kw,2)*Lst*Rs)/(power(p,2)*(g+hm)));

// Slot leakage inductance
  perm :=  mu0*((1/3)*(hs/wst) + hd/wst);
  Las :=  2*p*Lst*perm*(4*power(Nc,2)*(m-Nsp)+2*Nsp*power(Nc,2));
  Lam :=  2*p*Lst*Nsp*power(Nc,2)*perm;
  if q = 3 then Lslot :=  Las + 2*Lam*cos(2*pi/q) // 3 phase equation
           else Lslot :=  Las - 2*Lam*cos(2*pi/q); // multiple phases

// End-turn inductance (Hanselman)

  As1 :=  ws*hs; // Slot area
  Le :=  ((Nc*muO*(taus)*power(Na,2))/2)*log(wt*sqrt(pi)/sqrt(2*As1));

// Total inductance and reactance

  Ls:=  Lag+Lslot+Le;
  Xs :=  omega*Ls;

// Lengths, Volumes, and Weights

  Lac :=  2*Na*(Lst+2*le2);// Armature conductor length
  Aac :=  As1*lams/(2*Nc);// Armature conductor area (assumes form wound)
  Mac :=  q*Lac*Aac*rhoc;//Mass of armature conductor
  Lmach :=  Lst+2*lel; // Overall machine length
  Rci :=  R+hm+g+hd+hs; // Core inside radius
  Rco :=  Rci+dc; // Core outside radius
  Dmach :=  2*Rco; // Overall diameter
  Mcb :=  rhos*pi*(power(Rco,2)-power(Rci,2))*Lst;// Back iron
  Mct :=  rhos*Lst*(Ns*wt*hs+2*pi*R*hd-Ns*hd*wd); // Teeth
  Mc:=  Mcb + Mct; // Core mass
  Mm :=  0.5*(p*thmriad)*(power((R+hM),2)-power(R,2))*Lst*rhom; // Magnet mass
  Ms :=  pi*power(R,2)*Lst*rhos; // Shaft mass
  Mser :=  0.15 *(Mc+Ms+Mm+Mac); // 15% service fraction
  Mtot :=  Mser+Mc+Ms+Mm+Mac; // Total mass
  Ra:=  Lac/(sigst*Aac); // Stator resistance

//Core Loss Calculations

  Bt := Bg/tfrac; //Tooth Flux Density
  Bb :=  Bg*R/(p*dc); // Back iron flux density (Hanselman)
  Pcb:=  Mcb*P0*power(abs(Bb/BO),epsb)*power(abs(f/F0),epsf); //Core back iron loss

// Teeth Loss

  Pct :=  Mct*P0*power(abs(Bt/BO),epsb)*power(abs(f/F0),epsf);

// Total core loss

  Pc :=  Pcb + Pct;

// Start loop to determine terminal voltage and current
  notdone := 1;
  i := 0;
  la :=  Pwr/(q*Ea);
  while notdone=1 do
   i:=  i+1;
   xa :=  Xs*Ia/Ea;

// Conductor losses
   Pa :=  q*IaA2*Ra;

//Gap friction losses
//Reynold's number in air gap

   omegam :=  omega/p;
   Rey :=  omegam*R*g/nuair;


   Cf :=  0.0725/power(Rey,2);//Friction coefficient
   Pwind := Cf*pi*rhoair*omegamA3*power(R,4)*Lst; // Windage losses

// Get terminal voltage
   Va :=  sqrt(power(Ea,2)-power(((Xs+Ra)*Ia*COS(pSi)),2))-(Xs+Ra)*Ia*sin(psi);
   Ptemp :=  q*Va*Ia*cos(psi)-Pwind;
   error :=  Pwr/Ptemp;
   err(i) :=  error;
   if abs(error - 1) < tol then notdone = 0
                           else Ia :=Ia*error
end;




//Remaining performance parameters

//Current density
Ja:=  Ia/Aac;

// Power and efficiency

Pin := Pwr+Pc+Pa+Pwind;
eff:= Pwr/Pin;
pf :=  cos(psi);
Pout:=  Pwr/le3;
Jao:= Ja/le4;
Pco := Pc/le3;
Pwindo :=  Pwind/1e3;
Pao :=  Pa/1e3;
wso :=  ws* 1000;
hso :=  hs* 1000;
wto :=  wt* 1000;
dco :=  dc* 1000;
Lso := Ls* 1000;
hmo := hm* 1000;
go :=  g*1000;


end.







