% macro match dba test lattice beta functions and dispersion using
% quadrupoles.
clear all
load('dba.mat','RING');

%%  VARIABLES
vi=   1;
Variab{vi}=struct('PERTURBINDX',[findcells(RING,'FamName','QD')],...
    'PVALUE',0,...
    'Fam',1,...
    'LowLim',[],...
    'HighLim',[],...
    'FIELD','PolynomB',...
    'IndxInField',{{1,2}}); % the double braces {{}} are necessary in orded 
                            % to avoid the creation of multiple structures.

vi=vi+1;
Variab{vi}=struct('PERTURBINDX',[findcells(RING,'FamName','QF')]...
    ,'PVALUE',0,...
    'Fam',1,...
    'LowLim',[],...
    'HighLim',[],...
    'FIELD','PolynomB',...
    'IndxInField',{{1,2}});

vi=vi+1;
k1start=getcellstruct(RING,'PolynomB',findcells(RING,'FamName','QDM'),1,2);

Variab{vi}=struct('FUN',@(RING,K1Val)VaryQuadFam(RING,K1Val,'QDM'),...
    'PVALUE',0,... % starting perturbation value.
    'Fam',1,...
    'StartVALUE',k1start(1),...
    'LowLim',[],...
    'HighLim',[],...
    'FIELD','macro');

% % Alternative to change a quadrupole gradient
% %  %   standard perturbindx variable approach
% vi=vi+1;
% Variab{vi}=struct('PERTURBINDX',[findcells(RING,'FamName','QDM')],...
%     'PVALUE',0,...
%     'Fam',1,...
%     'LowLim',[],...
%     'HighLim',[],...
%     'FIELD','PolynomB',...
%     'IndxInField',{{1,2}});

vi=vi+1;
Variab{vi}=struct('PERTURBINDX',[findcells(RING,'FamName','QFM')],...
    'PVALUE',0,...
    'Fam',1,...
    'LowLim',[],...
    'HighLim',[],...
    'FIELD','PolynomB',...
    'IndxInField',{{1,2}});

vi=vi+1;
Variab{vi}=struct('PERTURBINDX',[findcells(RING,'FamName','QFM')],...
    'PVALUE',0,...
    'Fam',1,...
    'LowLim',[],...
    'HighLim',[],...
    'FIELD','PolynomB',...
    'IndxInField',{{1,2}});

%%  CONSTRAINTS
c_i=1;
qfmindx=findcells(RING,'FamName','QFM');
Constr{c_i}=struct('Fun',@(RING)dispx(RING,1),...
    'Min',0,...
    'Max',0,...
    'Weight',1);
disp('Horizontal dispersion at straigth section= 0')


% c_i=1;
% qfmindx=findcells(RING,'FamName','QFM');
% Constr{c_i}=struct('Fun',@(RING)dispx(RING,qfmindx(2)),...
%     'Min',2,...
%     'Max',2,...
%     'Weight',1);

c_i=c_i+1;
Constr{c_i}=struct('Fun',@(RING)betx(RING,qfmindx(2)),...
    'Min',17.3,...
    'Max',17.3,...
    'Weight',1);
disp('Horizontal beta at QFM= 17.3')

c_i=c_i+1;
Constr{c_i}=struct('Fun',@(RING)bety(RING,qfmindx(2)),...
    'Min',0.58,...
    'Max',0.58,...
    'Weight',1);
disp('Vertical beta at QFM= 0.58')

c_i=c_i+1;
Constr{c_i}=struct('Fun',@(RING)mux(RING,length(RING)),...
    'Min',4.35,...
    'Max',4.35,...
    'Weight',1);
disp('Horizontal phase advance = 4.35')


%% MATCHING
% disp('wait 1 iterations')
% RING_matched=atmatch(RING,Variab,Constr,10^-25,1000,'lsqnonlin',0);%
% disp('wait 353 iterations')
% RING_matched=atmatch(RING,Variab,Constr,10^-6,1000,'fminsearch',0);%

 
% different constraint assignement using the function atConstrOptics
% list of quintuplets
vincoli={'betx',qfmindx(2),17.3,17.3,1,...
         'bety',qfmindx(2),0.58,0.58,1,...
         'dispx',1,0,0,1,...
         ...         'mux',length(RING),4.35,4.35,1... % phase advance with few indxes is not correct
         'Qx',length(RING),0.35,0.35,1};
    
c{1}=atConstrOptics(RING,0,vincoli);

RING_matched=atmatch(RING,Variab,c,10^-25,1000,'lsqnonlin',0);%
%RING_matched=atmatch(RING,Variab,c,10^-6,1000,'fminsearch',0);%


figure;atplot(RING);% export_fig('ringdba.pdf','-transparent');
figure;atplot(RING_matched);% export_fig('ringdba_matched.pdf','-transparent');
