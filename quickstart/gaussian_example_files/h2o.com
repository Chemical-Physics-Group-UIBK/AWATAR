%nproc=8
%chk=h2o.cc_acp.stable.chk
#p HF/aug-cc-pVDZ scf=xqc stable=opt 

h2o groundstate energy

0 1
 O     0.000000     0.000000     0.000000
 H     0.000000     0.000000     0.950000
 H     0.895670     0.000000    -0.316663

--Link1--
%nproc=8
%chk=h2o.cc_acp.stable.chk
#p CCSD/aug-cc-pVDZ scf=xqc guess=check geom=check opt freq 

h2o groundstate energy

0 1

