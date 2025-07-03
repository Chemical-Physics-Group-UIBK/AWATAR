%nproc=20
%mem=20GB
%chk=co3.1.i3.cc_acp.stable.chk
#p HF/aug-cc-pVDZ scf=xqc stable=opt 

co3w2- groundstate energy

-1 2
 C     -0.815482    0.087816   0.00
 O     -0.444860   -1.181080   0.00
 O     -2.088266    0.148521   0.00
 O      0.015154    1.027840   0.00
 O      2.618909   -0.002293   0.00
 H      1.747451    0.454314   0.00
 H      2.337951   -0.925122   0.00

--Link1--
%nproc=20
%mem=20GB
%chk=co3.1.i3.cc_acp.stable.chk
#p CCSD/aug-cc-pVDZ scf=xqc guess=check geom=check opt freq 

co3w2- groundstate energy

-1 2

