clear all
close all
clc

%core Al values approximation
for i = 1:420
    A_l(i)=(281-0.3*i)*(10^(-9))*0.92;
end

% cable parameters
awg_23=0.259;
R_23 = 66.7808*10^(-6);


%Conditions
a=1;
p=0;
while a~=0
V=12;
Imax=6.9+p*0.1;
D=0.58;
f=50e3;
load=0.25;
delta_Ilm=load*5.67*2;
Lm = 18*0.47/(delta_Ilm*f);
Npri_old = ceil(sqrt(Lm/A_l(1)));
MMF = round(Npri_old*Imax);
n=10;
while n>1
Npri_new = ceil(sqrt(Lm/A_l(MMF)));
MMF = round(Npri_new*Imax);
if Npri_new == Npri_old
    Npri = Npri_old;
    n=1;
else
    Npri_old=Npri_new;
end

end
H=MMF/(98.4e-3);
u=A_l(MMF)*(98.4e-3)/(237e-6);
B = u*H;

%losses
tur = (11.89+9.27*2+20.02)*2;
Ieff_pri = Imax*sqrt(D);
Ieff_sec = Imax*sqrt(D)/3;
cable_length_pri=tur*Npri*1.5;
num_cable_pri =ceil((Ieff_pri/3.1)/awg_23);
cable_length_sec=tur*Npri*3*1.5;
num_cable_sec =ceil((Ieff_sec/3.1)/awg_23);


copper_R_primer = cable_length_pri*R_23/num_cable_pri;
copper_loss_primer = Ieff_pri^2*copper_R_primer;
copper_R_seconder = cable_length_sec*R_23/num_cable_sec;
copper_loss_seconder = (Imax*sqrt(D)/3)^2*copper_R_seconder;
copper_loss= copper_loss_seconder+copper_loss_primer;

core_loss = 23.3*(46.32*(B^1.988)*(f/1000)^1.541)/1000;

Transformer_loss = copper_loss+core_loss;

%efficiency
efficiency=(V*Imax*D-Transformer_loss)/(V*Imax*D)*100;
a=round(V*D*Imax-Transformer_loss)-48;
p=p+1;

%fill factor
fill= (((num_cable_pri*Npri+num_cable_sec*Npri*3)*awg_23)/276)*100;

end
