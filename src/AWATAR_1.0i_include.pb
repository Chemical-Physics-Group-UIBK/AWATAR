; PureBasic Visual Designer v3.95 build 1485 (PB4Code)


;- Window Constants
;
Enumeration
  #Window_0
EndEnumeration

;- Gadget Constants
;
Enumeration
  #Button_0
  #Button_1
  #Button_2
  #Button_3
  #Button_4
  #Button_5
  #Button_6
  #Button_7
  #Button_8
  #Button_9
  #Button_10
  #Button_11
  #Button_12
  #Button_13
  #Button_14
  #Panel_0
  #Editor_0
  #Editor_1
; IMPORTANT! ADD NEW CONSTANTS ONLY BEFORE #Editor_0. New Editor gadgets are enumerated automatically later in the program!!!
;  #Editor_2
EndEnumeration

;- StatusBar Constants
;
Enumeration
  #StatusBar_0
EndEnumeration



Procedure Open_Window_0()
  If OpenWindow(#Window_0, 70, 20, 1058, 632, "AWATAR 1.0 (c) 2006, 2008, 2010, 2021, 2022, 2023, 2024, 2025 Martin K. Beyer, Milan Oncák, Magdalena Salzburger",  #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget | #PB_Window_SizeGadget | #PB_Window_TitleBar )
    If CreateStatusBar(#StatusBar_0, WindowID(#Window_0))
      AddStatusBarField(5000)
      EndIf

;      If CreateGadgetList(WindowID(#Window_0))
        ButtonGadget(#Button_13, 540, 60, 120, 40, "Calculate SoS", #PB_Button_Default); ButtonGadget(#Gadget , x , y , Breite , Höhe , Text$)
        ButtonGadget(#Button_14, 410, 60, 120, 40, "Remove Multi")
        ButtonGadget(#Button_1, 120, 10, 120, 40, "Load Well")
        ButtonGadget(#Button_2, 120, 60, 120, 40, "Load tight TS")
        ButtonGadget(#Button_4, 250, 60, 150, 40, "Add loose TS Fragment 2")
        ButtonGadget(#Button_5, 250, 10, 150, 40, "Load loose TS Fragment 1")
        ButtonGadget(#Button_6, 20, 10, 90, 40, "Save All")
        ButtonGadget(#Button_7, 20, 60, 90, 40, "Load All")
        ButtonGadget(#Button_0, 670, 10, 120, 40, "RRKM Rate Constants")
        ButtonGadget(#Button_8, 670, 60, 120, 40, "Start MEM")
        ButtonGadget(#Button_11, 800, 60, 120, 40, "Iterative MEM")
        ButtonGadget(#Button_9, 800, 10, 120, 40, "Continue MEM")
        ButtonGadget(#Button_12, 410, 10, 120, 40, "Remove Well / TS")
        ButtonGadget(#Button_3, 540, 10, 120, 40, "Calculate DoS")
        ButtonGadget(#Button_10, 930, 10, 120, 40, "Export Population")

        
        ;- Panel0
        PanelGadget(#Panel_0, 30, 110, 1000, 490)
          AddGadgetItem(#Panel_0, -1, "Results")
          EditorGadget(#Editor_0, -2, -2, 1000, 470)
          AddGadgetItem(#Panel_0, -1, "Parameters")
          EditorGadget(#Editor_1, -2, -2, 1000, 470)
;          AddGadgetItem(#Panel_0, -1, "Transition State")
;          EditorGadget(#Editor_2, -2, -2, 900, 470)        
        CloseGadgetList()
        AddGadgetItem(#Editor_1, -1,";ProgramVersion AWATAR_1.0")
        AddGadgetItem(#Editor_1, -1,"")
        AddGadgetItem(#Editor_1, -1,";General Parameters:")
        AddGadgetItem(#Editor_1, -1,"     The filename is:                                      FILENAME")        
        AddGadgetItem(#Editor_1, -1,"     Frequency Scale Factor:                               0.96  ; used in reading Gaussian Data")
        AddGadgetItem(#Editor_1, -1,"     Energy range of population in cm-1:                   20000")
        AddGadgetItem(#Editor_1, -1,"     Bin size in cm-1:                                     100")
        AddGadgetItem(#Editor_1, -1,"     Energy quantum for Beyer/Swinehart in cm-1:           1")
        AddGadgetItem(#Editor_1, -1,"")
        AddGadgetItem(#Editor_1, -1,";Reaction Channels:")
        AddGadgetItem(#Editor_1, -1,"     Channel 0 Well all TS all      ; AWATAR-approach: use RRKM expression for one product as defined in Hartmann et al. DOI: 10.1039/D4CP00357H")
        AddGadgetItem(#Editor_1, -1,";    Channel 0 Well all TS 0 1 2    ; AWATAR-approach: use RRKM expression for multiple products, define one channel per product")
        AddGadgetItem(#Editor_1, -1,";    Channel 0 Well 0 TS 0          ; Example for regular channel definition from one Well via one TS to product")
        AddGadgetItem(#Editor_1, -1,"")      
        AddGadgetItem(#Editor_1, -1,";Definitions for master equation modeling (MEM):")
        AddGadgetItem(#Editor_1, -1,";General MEM parameters:")        
        AddGadgetItem(#Editor_1, -1,";   BIRD parameters:")
        AddGadgetItem(#Editor_1, -1,"       Number of temperatures in loop:                      3")
        AddGadgetItem(#Editor_1, -1,";      Manual list for temperatures in loop:                150.00 215.34 250.50  ;Define Temperatures in K which should be calculated. The Number of temperatures in loop has to match the number of entries in the list. Start temperature and End temperature are ignored if the Manual list is active.")
        AddGadgetItem(#Editor_1, -1,"       Loop starts with temperature in K:                   200")
        AddGadgetItem(#Editor_1, -1,"       Loop ends with temperature in K:                     300")
        AddGadgetItem(#Editor_1, -1,"       Proportion on solid angle of ICR cell window:        0.002")
        AddGadgetItem(#Editor_1, -1,"       Temperature of ICR cell window in K:                 288")
        AddGadgetItem(#Editor_1, -1,";  IRMPD parameters:")
        AddGadgetItem(#Editor_1, -1,"       Rate of Photon absorption for Well all in s-1:       0")
        AddGadgetItem(#Editor_1, -1,";      Rate of Photon absorption for Well 0 3 7 in s-1:     0")
        AddGadgetItem(#Editor_1, -1,"       IRMPD photon energy in cm-1:                         0")
        AddGadgetItem(#Editor_1, -1,"   Finite time step parameter:                              0.00001         ; Used for Start MEM, Continue MEM and real time MEM")
        AddGadgetItem(#Editor_1, -1,";Real time MEM parameters:")
        AddGadgetItem(#Editor_1, -1,"       Run MEM in real time (YES/NO):                       YES")
        AddGadgetItem(#Editor_1, -1,"       Total simulation time in seconds:                    1")
        AddGadgetItem(#Editor_1, -1,"       Interval for data point export in seconds:           0.01            ; data points of reactant and product intensity")
        AddGadgetItem(#Editor_1, -1,"       Export population after n data points:               10              ; population will be written to a file after 10 data points each")
        AddGadgetItem(#Editor_1, -1,"       Initial Cluster Temperature in K:                    0               ; active if non-zero, allows to model heating or cooling of thermalized ensemble, e.g. after electrospray ionization; caution: very low temperatures cause numerical problem")
        AddGadgetItem(#Editor_1, -1,"       Photon energy at t = 0 in cm-1:                      0               ; allows to follow evolution of thermalized population after photon absorption")
        AddGadgetItem(#Editor_1, -1,";Steady state MEM parameters:")        
        AddGadgetItem(#Editor_1, -1,"       Minimum time step at 300 K:                          12              ; give x for 10^(-x) s ;Used for Iterative MEM instead of the parameter Finite time step at 300 K ")
        AddGadgetItem(#Editor_1, -1,"       Minimum number of iterations:                        500             ; Used for Iterative MEM")
        AddGadgetItem(#Editor_1, -1,"       Convergence parameter:                               0.0001          ; Used for Start MEM and for Continue MEM")
        AddGadgetItem(#Editor_1, -1,"")
        AddGadgetItem(#Editor_1, -1,";Fit parameters:")
        AddGadgetItem(#Editor_1, -1,"; 1) Adapt Energies")
        AddGadgetItem(#Editor_1, -1,";      Absolute energy of: TS 0, TS 1, TS 7         is:     3750.50         ; define TS energy in cm-1 including ZPE relative to global minimum - This overwrites the TS energy defined by TS-Panel.")
        AddGadgetItem(#Editor_1, -1,";      Offset to Energy of all TS in cm-1:                  100.00          ; Adds Offset to all transition states.") ; new in vs 35.6
        AddGadgetItem(#Editor_1, -1,";      Offset to Energy of: TS 0, TS 1, TS 7 in cm-1:       100.00          ; Adds Offset to the defined transition states.") ; new in vs 35.6        
        AddGadgetItem(#Editor_1, -1,"; 2) Adapt infrared intensities")
        AddGadgetItem(#Editor_1, -1,"       Scaling of IR intensities:                           1")
        AddGadgetItem(#Editor_1, -1,"; 3) Adapt Degeneracies:")
        AddGadgetItem(#Editor_1, -1,";      Well-Degeneracy-List:      5 4 1 2 1 1 1 7 8 9 10 33                 ; The length of the list has to match the number of wells. The degeneracy of each well is multiplied with the corresponding entry of the Well-Degeneracy-List.")
        AddGadgetItem(#Editor_1, -1,";      TS-Degeneracy-List:        7 18 4 9 8 67 8                           ; The length of the list has to match the number of TS. The degeneracy of each TS is multiplied with the corresponding entry of the TS-Degeneracy-List.")
        AddGadgetItem(#Editor_1, -1,";      Increase degeneracy of: TS 0, TS 3, TS 24 by factor: 1.0             ; This can be used to change proportion of channels.")        
;        AddGadgetItem(#Editor_1, -1,"")
;        AddGadgetItem(#Editor_1, -1,"")        
;        AddGadgetItem(#Editor_1, -1,";Including Transition States between Well-Groups:                          (Isomerisation within a group is barrierless, Isomerisation between groups is not possible below the lowest Isochan-TS, barrierless if isomerisationrates trough TS would be very high (*), only possible via TS otherwise.")
;        AddGadgetItem(#Editor_1, -1,";  Definition of groups: (Default = all wells in group 0)                  !!!code works only with up to 2 groups.!!!)")
;        AddGadgetItem(#Editor_1, -1,";    Group 1: Well 1, Well 3, Well 5                            ; Example for group definition")
;        AddGadgetItem(#Editor_1, -1,";  Definition of isomerisation channels:")
;        AddGadgetItem(#Editor_1, -1,";    IsoChan 0 Well 0 TS 0 Well 1                               ; Example for isomerisation channel definition   ")
;        AddGadgetItem(#Editor_1, -1,";    Free Isomerisation criterion:                    0.1       ; (*) Barrierless isomerisation if Total_iso_depletion_SumAllWells is bigger than this number")
;        AddGadgetItem(#Editor_1, -1,";    Print Diagnostics in .txt file (YES/NO):         NO")        

        ; Load Editor Font
        If LoadFont(1,"Courier",10)
          SetGadgetFont(#Editor_0, FontID(1))   
          SetGadgetFont(#Editor_1, FontID(1))   
 ;         SetGadgetFont(#Editor_2, FontID(1))   
        EndIf

        
 ;     EndIf
    EndIf
EndProcedure


; IDE Options = PureBasic 5.73 LTS (Windows - x64)
; CursorPosition = 100
; FirstLine = 91
; Folding = -
; Executable = Z:\Paper in Progress\Awatar_PCCP_Tutorial\AWATAR_Manual\AWATAR_1.0d.exe