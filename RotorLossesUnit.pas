unit RotorLossesUnit;

interface
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,math,
  Dialogs;

 procedure Calculate_current_densities(Iharm,Nai,q,I1,Pi,RS,Izj1 :Extended; out Iz,Kz,Iz_1,KzI:extended) ;
 procedure Harmonics_to_be_evaluated(omega,pi,lam,p :Extended; out w,freq,iam,k :extended) ;
 procedure Eta_values(muO,cond_m,w,k,j,cond_sl:Extended; out eta_m,eta_s:extended);
 procedure surfACE(eta_m,hm,j,k,H_sl,eta_s,alfa_m,g_act,wi,mu0 :Extended; out alpha,alfa_s,alfa_f,top1,bot1,top2,bot2,Zs:extended) ;
 procedure Use_only_fundamental_space_harmonic_factors(kw,kz:Extended;n:integer; out zs,sy_t,syt,kz_t:extended ) ;
 procedure Calculate_losses_due_to_space_harmonics(pi,alfa,gama,m,kz_1,zs,sys_s :Extended; out kpn,kbn,kwn,kz_s,sys:extended) ;


implementation



 procedure Calculate_current_densities(Iharm,Nai,q,I1,Pi,RS,Izj1 :Extended; out Iz,Kz,Iz_1,KzI:extended) ;
 begin
   Iz:= (1/sqrt(2))*Iharm;
   Kz:= ((q/2)*(Nai*(2*pi*Rs)))*Iz;
   Iz_1:= (1/sqrt(2))*I1; // Fundamental RMS current
   KzI:= ((q/2)*(Nai/(2*pi*Rs)))*Izj1; // Fundamental current density
 end;

   procedure Harmonics_to_be_evaluated(omega,pi,lam,p :Extended; out w,freq,iam,k :extended) ;
   var
   n:integer;
   begin
    n:=random(31);
w :=n* omega;           // Harmonic angular frequencies
freq:= w/(2*pi);          // Harmonic frequencies
iam:= (2*(2*pi/(2*p)))/n;
k:= (2*pi)/iam;      // Wavenumbers   // Номер волны
   end;


procedure Eta_values(muO,cond_m,w,k,j,cond_sl:Extended; out eta_m,eta_s:extended);

begin
eta_m:= sqrt((j*muO*cond_m)*w + (k*k));
eta_s:= sqrt((j*muO*cond_sl)*w + (k*k));
end;

 procedure surfACE(eta_m,hm,j,k,H_sl,eta_s,alfa_m,g_act,wi,mu0 :Extended; out alpha,alfa_s,alfa_f,top1,bot1,top2,bot2,Zs:extended) ;

   begin
alpha:=j*(k/eta_m)*cot(eta_m*hm);
top1:= (j*(k/eta_s)*sin(eta_s*h_sl)) + (alfa_m*cos(eta_s*h_sl));
bot1 := (j*(k/eta_s)*cos(eta_s*h_sl)) + (alfa_m*sin(eta_s*h_sl));
alfa_s := j*(k/eta_s)*(top1/bot1);
top2 := (j*sin(k*g_act)) + (alfa_s*cos(k*g_act));
bot2 :=  (j*cos(k*g_act)) + (alfa_s*sin(k*g_act));
alfa_f := j*(top2/bot2);
Zs := (mu0*wi/k)*alfa_f;

   end;
procedure Use_only_fundamental_space_harmonic_factors(kw,kz:Extended;n:integer; out zs,sy_t,syt,kz_t:extended ) ;
  var
  i:integer;
  begin
    Kz_t:=kw*Kz;
    Syt:= 0;
    for i:= 0 to n do
      begin
        //Sy_t(i):= 1/2*(abs(Kz_t(i))*Kz_t(i))*real(Zs(i));
        //Syt:= Syt + Sy_t(i);
      end;
  end ;

procedure Calculate_losses_due_to_space_harmonics(pi,alfa,gama,m,kz_1,zs,sys_s :Extended; out kpn,kbn,kwn,kz_s,sys:extended) ;
var
n,i:integer;
begin
kpn:= sin(n*pi/2)*sin(n*alfa/2);
kbn:= sin(n*m*gama/2)/(m*sin(n*gama/2));
kwn:= kpn*kbn;
Kz_s:=kwn*Kz_1/n;
Sys:=0;
for i:=1 to n  do
begin
//Sy_s(i):= 0.5*(abs(Kz_s(i)*Kz_s(i)))*real(Zs(i));
//Sys = Sys + Sy_s(i);

end
end;
end.
