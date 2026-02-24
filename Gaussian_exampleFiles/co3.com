%nproc=28
%mem=28GB
%chk=co3.0.cc_acp.stable.chk
#p HF/aug-cc-pVDZ scf=xqc stable=opt 

co3w2- groundstate energy

-1 2
 o
 c   1 co2     
 o    2 oc3         1 oco3      
 o    2 oc4         1 oco4          3 dih4   
 
co2         1.338592
oc3         1.259700
oco3        115.005
oc4         1.259700
oco4        115.005
dih4        180.000

--Link1--
%nproc=28
%mem=28GB
%chk=co3.0.cc_acp.stable.chk
#p CCSD/aug-cc-pVDZ scf=xqc guess=check geom=check opt freq 

co3w2- groundstate energy

-1 2

