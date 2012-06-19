unit Rotor_Losses_from_Slot_Effects;
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,math,
  Dialogs;


procedure calculate_Bd_and_geometry(iamb,wst,wt,bg,pi,rs,ns:Extended ; out bd,beta,lamb,b:extended);
procedure Input_Stainless_Steel_sleeve_thickness_based_on_stress_results(strain_str,t_stain,t:Extended;stop:integer; out dummy:extended );
procedure Input_Titanium_sleeve_thickness_based_on_stress_results(titan_str,t_tita,t:Extended;stop:integer; out dummy:extended );
procedure Input_Carbon_Fiber_sleeve_thickness_based_on_stress_results(carfib_str,tcarfib,t:Extended;stop:integer; out dummy:extended );
procedure Input_Inconel_sleeve_thickness_based_on_stress_results(inconel_str,tinconel,t:Extended;stop:integer; out dummy:extended );
procedure Calculate_can_losses(p,rpm, ksm, am, lst, rr, magnet_res ,T_stain ,T_titan, t_carfib, t_lnconel, stain_res, titan_res, carfib_res, inconel_res, r, hm, b, pi :Extended; out w_magnet,p_magnet,w_stain,w_carfib,W_titan,w_inconel:extended );

 const
    Stain_res = 0.72e-6;
  Titan_res = 0.78e-6;
  CarFib_res = 9.25e-6;
  Inconel_res = 0.98e-6;
  Magnet_res =1.43e-6;


implementation




procedure calculate_Bd_and_geometry(iamb,wst,wt,bg,pi,rs,ns:Extended ; out bd,beta,lamb,b:extended);
var
k:byte;
begin
  Bd:= (wst/wt)*0.1*Bg;
  beta:= (wst/(2*pi*Rs))*2*pi;
  lamB:= 2*pi/Ns;
  B:= (Bd/sqrt(2))*sqrt(beta/IamB);
  for k:= 0 to 9 do
    begin
      //A(k):= pi*2*(R+hm)*Lst/k;
     // Ks(k):= 1 - ((tan(p*Lst/(k*2*(R+hm))))/(p*Lst/(k*2*(R+hm))));
    end;
end;

procedure Input_Stainless_Steel_sleeve_thickness_based_on_stress_results(strain_str,t_stain,t:Extended;stop:integer; out dummy:extended );
var
i:integer;
begin
  for i:=1 to stop do
    begin
     // if SFHoop(i) <= Stain_str
     // t_Stain := t(i);
      break;
    //else if t(stop) > Stain_str
       Showmessage('Hoop Stress too high for Stainless Steel.A');
   // else
      // dummy:= t(i);
    end;
  end;

  procedure Input_Titanium_sleeve_thickness_based_on_stress_results(titan_str,t_tita,t:Extended;stop:integer; out dummy:extended );

 var
 i:integer ;
 begin
  for i:= 1 to stop do
  begin
//if SFHoop(i) <= Titan_str
//    t_Tita:= t(i);
    break ;
//else if t(stop) > Titan_str
Showmessage('Hoop Stress too high for Titanium\n');
//else
//dummy:=t(i);
end  ;
end;

procedure Input_Carbon_Fiber_sleeve_thickness_based_on_stress_results(carfib_str,tcarfib,t:Extended;stop:integer; out dummy:extended );
var
i:integer;
begin
for i:= 1 to stop do
begin
//if SFHoop(i) <= CarFib_str
//tCarFib:=t(i);
break ;
//else if t(stop) > CarFib_str
showmessage('Hoop Stress too high for Carbon Fiber.\n');
//else
//dummy:=t(i)
end;
end;



 procedure Input_Inconel_sleeve_thickness_based_on_stress_results(inconel_str,tinconel,t:Extended;stop:integer; out dummy:extended );
 var
 i:integer;
 begin
  for i:=1 to stop do
  begin
//if SFHoop(i) <= Inconel_str
//tInconel:=t(i);
break;
//else if t(stop) > Inconel_str
showmessage('Hoop Stress too high for Inconel.\n');
//else
//dummy:=t(i)
end;
end;

procedure Calculate_can_losses(p,rpm, ksm, am, lst, rr, magnet_res ,T_stain ,T_titan, t_carfib, t_lnconel, stain_res, titan_res, carfib_res, inconel_res, r, hm, b, pi :Extended; out w_magnet,p_magnet,w_stain,w_carfib,W_titan,w_inconel:extended );
var
k:byte;
begin
  w_Stain := (sqr(pi)/3600)*(sqr(B *rpm*(Rr+hm))*t_Stain)/Stain_res;
  w_Titan := (sqr(pi)/3600)*(sqr(B *rpm*(Rr+hM))*t_Titan)/Titan_res;
  w_CarFib :=(sqr(pi)/3600)*(sqr(B *rpm*(Rr+hM))*t_CarFib)/CarFib_res;
  w_Inconel :=(sqr(pi)/3600)*(sqr(B*rpm*(Rr+hm))*t_lnconel)/Inconel_res;
  for k:= 1 to 10 do
    begin
     // P_Stain(k) := k*w_Stain*Ks(k)*A(k)/1000;
     // P_Titan(k) := k*w_Titan*Ks(k)*A(k)/1000;
      //P_CarFib(k) :=k*w_CarFib*Ks(k)*A(k)/1000;
     // P_Inconel(k) :=k*w_Inconel*Ks(k)*A(k)/1000;
    end;

  Am := pi*2*Rr*Lst;
  Ksm := 1 - ((tan(p*Lst/(2*R)))/(p*Lst/(2*Rr)));
  w_Magnet :=(sqr(pi)/3600)*(sqr(B*rpm*Rr)*0.1 *hm)/Magnet_res;
  p_Magnet :=w_Magnet*Ksm*Am/1000;
  end;


end.
