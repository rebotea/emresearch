unit MainUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,BasicSizingMethodUnit,{ SizingUnit, BodePlotUnit, RetSlStressConclUnit, PMGeneratorWaveformUnit, RotorlossesUnit,}
  StdCtrls, ComCtrls;

type
  TForm3 = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    TabSheet5: TTabSheet;
    TabSheet6: TTabSheet;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    GroupBox4: TGroupBox;
    GroupBox5: TGroupBox;
    GroupBox6: TGroupBox;
    GroupBox7: TGroupBox;
    GroupBox8: TGroupBox;
    GroupBox9: TGroupBox;
    GroupBox10: TGroupBox;
    GroupBox11: TGroupBox;
    GroupBox12: TGroupBox;
    Edit1: TEdit;
    Edit2: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    Edit6: TEdit;
    Edit7: TEdit;
    Edit8: TEdit;
    Edit9: TEdit;
    Button1: TButton;
    Button2: TButton;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    Label25: TLabel;
    Label26: TLabel;
    Label27: TLabel;
    Label28: TLabel;
    Label29: TLabel;
    Label30: TLabel;
    Edit10: TEdit;
    Edit11: TEdit;
    Edit12: TEdit;
    Edit13: TEdit;
    Edit14: TEdit;
    Edit15: TEdit;
    Edit16: TEdit;
    Edit17: TEdit;
    Edit18: TEdit;
    Edit19: TEdit;
    Edit20: TEdit;
    Edit21: TEdit;
    Edit22: TEdit;
    Edit23: TEdit;
    Edit24: TEdit;
    Edit25: TEdit;
    Edit26: TEdit;
    Edit27: TEdit;
    Edit28: TEdit;
    Edit29: TEdit;
    Edit30: TEdit;
    Label31: TLabel;
    Label32: TLabel;
    Label33: TLabel;
    Label34: TLabel;
    Label35: TLabel;
    Label36: TLabel;
    Label37: TLabel;
    Label38: TLabel;
    Label39: TLabel;
    Label40: TLabel;
    Label41: TLabel;
    Label42: TLabel;
    Label43: TLabel;
    Label44: TLabel;
    Label45: TLabel;
    Label46: TLabel;
    Label47: TLabel;
    Label48: TLabel;
    Label49: TLabel;
    Label50: TLabel;
    Label51: TLabel;
    Label52: TLabel;
    Label53: TLabel;
    Label54: TLabel;
    Label55: TLabel;
    Label56: TLabel;
    Label57: TLabel;
    Label58: TLabel;
    Label59: TLabel;
    Label60: TLabel;
    Label61: TLabel;
    Label62: TLabel;
    Label63: TLabel;
    Label64: TLabel;
    Label65: TLabel;
    Label66: TLabel;
    Label67: TLabel;
    Label68: TLabel;
    Label69: TLabel;
    Label70: TLabel;
    Label71: TLabel;
    Label72: TLabel;
    Label73: TLabel;
    Label74: TLabel;
    Label75: TLabel;
    Label76: TLabel;
    Label77: TLabel;
    Label78: TLabel;
    Label79: TLabel;
    Label80: TLabel;
    Label81: TLabel;
    Label82: TLabel;
    Label83: TLabel;
    Label84: TLabel;
    Label85: TLabel;
    Label86: TLabel;
    Label87: TLabel;
    Label88: TLabel;
    Label89: TLabel;
    Label90: TLabel;
    Label91: TLabel;
    Label92: TLabel;
    Label93: TLabel;
    Label94: TLabel;
    Label95: TLabel;
    Label96: TLabel;
    Label97: TLabel;
    Label98: TLabel;
    Label99: TLabel;
    Label100: TLabel;
    Label101: TLabel;
    Label102: TLabel;
    Label103: TLabel;
    Label104: TLabel;
    Label105: TLabel;
    Label106: TLabel;
    Label107: TLabel;
    Label108: TLabel;
    Label109: TLabel;
    Label110: TLabel;
    Label111: TLabel;
    Label112: TLabel;
    Label113: TLabel;
    Label114: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);


  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form3: TForm3;

implementation

{$R *.dfm}

procedure TForm3.Button1Click(Sender: TObject);
var
  Pwr, rpm, psi, f, vtip, lovd, stress, p, bg, hscm, r, d, lst, omega, kz, ja: Extended;
begin
  Pwr:= StrToFloat(Edit1.Text);
  rpm:= StrToFloat(Edit2.Text);
  psi:= StrToFloat(Edit9.Text);
  f:= StrToFloat(Edit3.Text);
  vtip:= StrToFloat(Edit4.Text);
  lovd:= StrToFloat(Edit5.Text);
  stress:= StrToFloat(Edit6.Text);
  p:= StrToFloat(Edit7.Text);
  bg:= StrToFloat(Edit8.Text);

  BasicSizingMethod(Pwr, rpm, psi, f, vtip, lovd, stress, p, bg, hscm, r, d, lst,
      omega, kz, ja);
  //Label1.Left:=Label1.Left + round(ja);

  Label31.Caption:= Label31.Caption + floattostr(hscm);
  Label32.Caption:= Label32.Caption + floattostr(r);
  Label33.Caption:= Label33.Caption + floattostr(d);
  Label34.Caption:= Label34.Caption + floattostr(lst);
  Label35.Caption:= Label35.Caption + floattostr(omega);
  Label36.Caption:= Label36.Caption + floattostr(kz);
  Label37.Caption:= Label37.Caption + floattostr(ja);
end;

procedure TForm3.Button2Click(Sender: TObject);
var
  Pwr,rpm,psi,R,hm,Lst,p,Br,thm,thsk,q,Ns,Nsp,g,tfrac,hs,hd,wd,syrat,Nc,lams,sigst,rhos,rhom,rhoc:Extended;
  m,na,wt,wst,wsb,dc,nsfp,nsct,laz,le2,le1,f,omega,vtip,gama,alfa,kp,kb,kw,ths,ks,rs,ri,r2,r1,kg,ws,taus,kc,ge,cphi,pc,bg,thmrad,b1,lambda,ea,lag,perm,las,
  lam,lslot,as1,le,ls,xs,lac,aac,mac,lmach,rci,rco,dmach,mcb,mct,mc,mm,ms,mser,mtot,ra,bt,bb,pcb,pct,pc1,ia,xa,pa,omegam,rey,cf,pwind,va,ptemp,pf,eff,pin,ja:Extended;
begin
  pwr:= StrToFloat(Edit1.Text);
  rpm:=StrToFloat(Edit2.Text);
  psi:= StrToFloat(Edit3.Text);

  R:= StrToFloat(Edit10.Text);
  hm:= StrToFloat(Edit11.Text);
  Lst:= StrToFloat(Edit12.Text);
  Br:= StrToFloat(Edit13.Text);
  thm:= StrToFloat(Edit14.Text);
  thsk:= StrToFloat(Edit15.Text);
  q:= StrToFloat(Edit16.Text);
  Ns:= StrToFloat(Edit17.Text);
  Nsp:= StrToFloat(Edit18.Text);
  g:= StrToFloat(Edit19.Text);
  tfrac:= StrToFloat(Edit20.Text);
  hs:= StrToFloat(Edit21.Text);
  hd := StrToFloat(Edit22.Text);
  wd:= StrToFloat(Edit23.Text);
  syrat:= StrToFloat(Edit24.Text);
  Nc:= StrToFloat(Edit25.Text);
  lams:= StrToFloat(Edit26.Text);
  sigst:= StrToFloat(Edit27.Text);
  rhos:= StrToFloat(Edit28.Text);
  rhom:= StrToFloat(Edit29.Text);
  rhoc:= StrToFloat(Edit30.Text);
  p:= StrToFloat(Edit8.Text);

  SizingMethod(Pwr, rpm, psi, R, hm, Lst, p, Br, thm, thsk, q, Ns, Nsp, g, tfrac,
      hs, hd, wd, syrat, Nc, lams, sigst, rhos, rhom, rhoc, m, na, wt, wst, wsb,
      dc, nsfp, nsct, laz, le2, le1, f, omega, vtip, gama, alfa, kp, kb, kw, ths,
      ks, rs, ri, r2, r1, kg, ws, taus, kc, ge, cphi, pc, bg, thmrad, b1, lambda,
      ea, lag, perm, las, lam, lslot, as1, le, ls, xs, lac, aac, mac, lmach, rci,
      rco, dmach, mcb, mct, mc, mm, ms, mser, mtot, ra, bt, bb, pcb, pct, pc1, ia,
      xa, pa, omegam, rey, cf, pwind, va, ptemp, pf, eff, pin, ja);// ŒÕ –¿¡Œ“¿≈“, ÕŒ Õ≈Œ¡’Œƒ»ÃŒ Œ –”√À»“‹ –≈«”À‹“¿“€ ƒŒ Œœ–≈ƒ≈À≈≈ÕŒ√Œ œŒ–ﬂƒ ¿(«¿¬»—»“ Œ“ œŒ–ﬂƒ ¿ –≈«”À‹“¿“¿)
      //Õ¿œ»—¿“‹ œ–Œ¬≈– ” ¬’ŒƒÕ€’ ƒ¿ÕÕ€’
      //Õ¿œ»—¿“‹ Œ¡–¿¡Œ“ ” »— Àﬁ◊»“≈À‹Õ€’ —»“”¿÷»…

  // œŒƒœ»—¿“‹  ŒÃÃ≈Õ“¿–»»
  Label35.Caption:= FloatToStr(omega);
  Label37.Caption:= FloatToStr(ja);
  Label38.Caption:= Label38.Caption + FloatToStr(m);
  Label39.Caption:= Label39.Caption + FloatToStr(na);
  Label40.Caption:= Label40.Caption + FloatToStr(wt);
  Label41.Caption:= Label41.Caption + FloatToStr(wst);
  Label42.Caption:= Label42.Caption + FloatToStr(wsb);
  Label43.Caption:= Label43.Caption + FloatToStr(dc);
  Label44.Caption:= Label44.Caption + FloatToStr(nsfp);
  Label45.Caption:= Label45.Caption + FloatToStr(nsct);
  Label46.Caption:= Label46.Caption + FloatToStr(laz);
  Label47.Caption:= Label47.Caption + FloatToStr(le2);
  Label48.Caption:= Label48.Caption + FloatToStr(le1);
  Label49.Caption:= Label49.Caption + FloatToStr(f);
  Label50.Caption:= Label50.Caption + FloatToStr(vtip);
  Label51.Caption:= Label51.Caption + floattostr(gama);

  Label52.Caption:=Label52.Caption+floattostr(alfa);//Œ“–≈ƒ¿ “»–Œ¬¿“‹  Œƒ “¿ , ◊“Œ¡€ ŒÕ —“¿À ◊»“¿¡≈À≈Õ
  Label53.Caption:=Label53.Caption+floattostr(kp);
  Label54.Caption:=Label54.Caption+floattostr(kb);
  Label55.Caption:=Label55.Caption+floattostr(kw);
  Label56.Caption:=Label56.Caption+floattostr(ths);
  Label57.Caption:=Label57.Caption+floattostr(ks);
  Label58.Caption:=Label58.Caption+floattostr(rs);
  Label59.Caption:=Label59.Caption+floattostr(ri);
  Label60.Caption:=Label60.Caption+floattostr(r2);
  Label61.Caption:=Label61.Caption+floattostr(r1);
  Label62.Caption:=Label62.Caption+floattostr(kg);
  Label63.Caption:=Label63.Caption+floattostr(ws);
  Label64.Caption:=Label64.Caption+floattostr(taus);
  Label65.Caption:=Label65.Caption+floattostr(kc);
  Label66.Caption:=Label66.Caption+floattostr(ge);
  Label67.Caption:=Label67.Caption+floattostr(cphi);
  Label68.Caption:=Label68.Caption+floattostr(pc);
  Label69.Caption:=Label69.Caption+floattostr(bg);
  Label70.Caption:=Label70.Caption+floattostr(thmrad);
  Label71.Caption:=Label71.Caption+floattostr(b1);
  Label72.Caption:=Label72.Caption+floattostr(lambda);
  Label73.Caption:=Label73.Caption+floattostr(ea);
  Label74.Caption:=Label74.Caption+floattostr(lag);
  Label75.Caption:=Label75.Caption+floattostr(perm);
  Label76.Caption:=Label76.Caption+floattostr(las);
  Label77.Caption:=Label77.Caption+floattostr(lam);
  Label78.Caption:=Label78.Caption+floattostr(lslot);
  Label79.Caption:=Label79.Caption+floattostr(as1);
  Label80.Caption:=Label80.Caption+floattostr(le);
  Label81.Caption:=Label81.Caption+floattostr(ls);
  Label82.Caption:=Label82.Caption+floattostr(xs);
  Label83.Caption:=Label83.Caption+floattostr(lac);
  Label84.Caption:=Label84.Caption+floattostr(aac);
  Label85.Caption:=Label85.Caption+floattostr(mac);
  Label86.Caption:=Label86.Caption+floattostr(lmach);
  Label87.Caption:=Label87.Caption+floattostr(rci);
  Label88.Caption:=Label88.Caption+floattostr(rco);
  Label89.Caption:=Label89.Caption+floattostr(dmach);
  Label90.Caption:=Label90.Caption+floattostr(mcb);
  Label91.Caption:=Label91.Caption+floattostr(mct);
  Label92.Caption:=Label92.Caption+floattostr(mc);
  Label93.Caption:=Label93.Caption+floattostr(mm);
  Label94.Caption:=Label94.Caption+floattostr(ms);
  Label95.Caption:=Label95.Caption+floattostr(mser);
  Label96.Caption:=Label96.Caption+floattostr(mtot);
  Label97.Caption:=Label97.Caption+floattostr(ra);
  Label98.Caption:=Label98.Caption+floattostr(bt);
  Label99.Caption:=Label99.Caption+floattostr(bb);
  Label100.Caption:=Label100.Caption+floattostr(pcb);
  Label101.Caption:=Label101.Caption+floattostr(pct);
  Label102.Caption:=Label102.Caption+floattostr(pc1);
  Label103.Caption:=Label103.Caption+floattostr(ia);
  Label104.Caption:=Label104.Caption+floattostr(xa);
  Label105.Caption:=Label105.Caption+floattostr(pa);
  Label106.Caption:=Label106.Caption+floattostr(omegam);
  Label107.Caption:=Label107.Caption+floattostr(rey);
  Label108.Caption:=Label108.Caption+floattostr(cf);
  Label109.Caption:=Label109.Caption+floattostr(pwind);
  Label110.Caption:=Label110.Caption+floattostr(va);
  Label111.Caption:=Label111.Caption+floattostr(ptemp);
  Label112.Caption:=Label112.Caption+floattostr(pf);
  Label113.Caption:=Label113.Caption+floattostr(eff);
  Label114.Caption:=Label114.Caption+floattostr(pin);


end;




end.
