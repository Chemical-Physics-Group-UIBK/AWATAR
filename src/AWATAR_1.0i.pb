; AWATAR vs. 1.0i
; (c) 2006, 2008, 2009, 2021, 2022, 2023 Martin K. Beyer, TU Berlin, Christian-Albrechts-Universität zu Kiel, Universität Innsbruck
; (c) 2022  Milan Ončák, Universität Innsbruck
; (c) 2022, 2023, 2024, 2025 Magdalena Salzburger, Universität Innsbruck

; PureBasic Visual Designer v3.81 build 1321

; new in rrkm vs. 1.05: rotational densities of states
; new in rrkm vs. 1.06: fragment transition states, shorter codes, modifications after codes, code placement arbitrary
; new in rrkm vs. 1.07: improved parsing of input, more tolerant, comments possible starting with semicolon ;
; new in rrkm vs. 1.08: 2D hindered rotor, Gilbert / Smith eq. (4.3.41)
;                  sort frequencies in Beyer-Swinehart (directly in the subroutine)
;
; new rrkm generation 2.00:  allow multiple reactants and transition states
;                       calculate densities of states and multi-well rates,
;                       read IR intensities and absolute energies
;                       remove input via string gadgets, rely on parameter window only
;                       allow resizing of program window
; new in rrkm vs. 2.10: bug fixed in Sum of States Calculation
; new in rrkm vs. 2.20: frequency scaling factor included
; new in rrkm vs. 2.30: resume working on the code after >10 years pause, avoid complications with ambitious version 3.00, goal: get working version fast
;                   adapt syntax to PureBasic 5.73 LTS
; new in rrkm vs. 2.40: change calculation of depletion rates - treat radiative depletion and product formation as parallel reactions
;                   this is a MAJOR change in the algorithm, making it physically more correct
;                   significant improvement in speed
; new in rrkm vs. 2.50: Blackbody radiation from ICR-Cell window (which has a temperature of about 288 K) included.
; new in rrkm vs. 2.60: Induced Emmission added in calculation of k_emm
; new in rrkm vs  2.61: Bug fixed in emission calculation
; new in rrkm vs. 2.70: free definition of quantum states, in particular 1D, 2D and 3D particle in a box
;                  track number of active degrees of freedom and check for consistency between all wells and TSs
; new in rrkm vs. 2.80: Remember populations for all temperatures and write into one excel-import compatible table for final export
;                  Change �save all� And �load all� To include population
;                  Allow Continue MEM With new convergence settings: very easy, replace initial Boltzmann distribution With previously converged population
; new in rrkm vs. 2.90:  fix problem with window size after loading data
;                   bugfix in calculation of multiwell MEM rates - correct: rate(i_channels,k); wrong: rate(well_channel(i_channels),k) - changed in two places
;                   Add button �export population�
;                   MEM works now also with one temperature, start temperature is used in this case
; new in rrkm vs. 3.00 Iterative MEM included. This allows to improve finite timestep and convergence iteratively
; new in rrkm vs. 3.01 radiative transition rates calculated for all temperatures before starting main part of Master Equation Modelling
; new in rrkm vs. 3.02 loose/tight TS can be simulated, by increasing/decreasing TS-degeneracy
; new in rrkm vs. 3.10 possibility to set absolute energy in parameter panel, overwriting energy defined by TS panel
; new in rrkm vs. 3.11 For Iterative MEM, user is asked, whether to start with new Boltzmann distribution or existing population.
; new in rrkm vs. 3.12 scientific output for a .d variable adapted for values between -1 and 1.
; new in rrkm vs. 3.20 new buttons for loose and tight TS.
; new in rrkm vs. 3.21 Bug fixed in determination of active rotors
; new in rrkm vs. 3.30 New Button "Calculate SoS"; Procedure print_sos; Further Information (SoS, DoS and RRKM-Rates) added to the results panel after Calculation of MEM.
; new in rrkm vs. 3.40 In MEM: Exchange of Population not between all wells, but only between wells within the same group. Groups defined in Parameter panel (Default: all wells in group 0)
; new in rrkm vs. 3.41 Included possibility for isomerisation channels between wells of different groups. ATTENTION: This makes use of slow enough time steps more critical!!!
; new in rrkm vs. 3.42 At the End of the MEM Resultseditor, some diagnostics are reported.
; new in rrkm vs. 3.43 Isomerisation channel in MEM not simultaneosly with radiation and dissociaton, but afterwards. Bug fixed in Print Diagnostics, more parameters printed.
; new in rrkm vs. 3.44 New procedure for calculating equilibium between wells. (Chemical Equilibrium between groups as long as transition rates are high).
;                 Program works now only for up to 2 groups!!!
; new in rrkm vs. 3.45 Population after each timestep written in textfile. Diagnostics written in textfile.
; new in rrkm vs. 3.50 very simple IRMPD included: parameters photon absorption rate constant k_irmpd.d in s-1 and photon energy nu_irmpd.d in cm-1
; new in rrkm vs. 3.51 bug fix in reading symmetry numbers from Gaussian Output, values >= 10
; new in rrkm vs. 3.52 allow to use one RRKM rate constant using SoS(all TS), DoS(all Wells), enabled by command
; new in rrkm vs. 3.53 bug in "Add loose TS Fragment 2" fixed
; new in rrkm vs. 3.54 master equation modeling of the evolution of a population in real time, control via MEM parameter editor
;                 subroutine "master_equation_modeling_main_part" renamed "master_equation_modeling_convergence"
;                 new subroutine "master_equation_modeling_real_time" introduced
;                 identical sections in both subroutine singled out as new subroutines: initialize_population, speed_calculations, MEM_iteration
; new in rrkm vs. 3.55 minor bug fix: sum of probabilities = 0 in radiative rate calculation fixed, but does not change results; in these cases, well_dos = 0, so no contribution to anything
;                 some changes to writing population to file: spaces in filename now possible; scientific number format to cover all orders of magnitude
; new in rrkm vs. 3.56 New option to set offset for all or some TS in Parameter window.
;                 Optional writing of Diagnostics in textfile. Default is NO.
; new in rrkm vs. 3.57 Option to define List of Temperatures in loop manually
; new in rrkm vs. 3.58 Printing ln(rate) in results window after MEM.
;                      Printing Energies and Degeneracies of Wells and TS in results window after MEM.
;                      Possibility to adjust the degeneracies of wells and TS by Well-Degeneracy-Vector and TS-Degeneracy-Vector in Parameter window.
; new in rrkm vs. 3.59 Check if Well-Degeneracy-Vector and TS-Degeneracy-Vector have same size as number of Wells/TSs
; new in rrkm vs. 3.60 Possibility to remove multiple TSs or Wells at once
; new in AWATAR vs. 1.0a Program renamed to AWATAR, order of Buttons changed, Parameter Panel restructured, Warning if no Well is available for Calculation of SoS, used Energies and degeneracies printed to results also for Calculate DoS, SoS and RRKM-Rates
; new in AWATAR vs. 1.0c Multiplicity read also for second Fragment of TS
; new in AWATAR vs. 1.0d No information about groups printed any more, use the word bin instead of level, print information for max. 10 wells in the console window
; new in AWATAR vs. 1.0e: Semicolon in front of immaginary frequency in tight TS, 1D active rotor for spherical molecules; bug about manual list for temperatures in loop fixed, new Channel overview for AWATAR channels in "print RRKM-rates", some units added to Results, TS energy set to 0 if defined energy would be lower than global minimum well (prevents chrashing), Energy/Degeneracy definition of not existing TS is now ignored (prevents chrashing)
; new in AWATAR vs. 1.0f: No 2D-rot in linear wells or linear tight TS, 1D- and 2D rotor for spherical loose TS, Warning if system has only few degrees of Freedom, units added to output, rate in output renamed to rate constant or rate coefficient
; new in AWATAR vs. 1.0g: checkpoint-file written during iterative MEM
; new in AWATAR vs. 1.0h: BS-quantum column not written any more to results, "Room temperature" in Parameters panel with spacing (also without spacing allowed for compatibility)
; new in AWATAR vs. 1.0i: Well(TS)-degeneracy-Vector renamed to Well(TS)-degeneracy-List, ln(rate_coefficient) renamed to ln(rate_coefficient/(s-1))
;new in AWATAR on 11.08.25: Some of the parameters renamed, unit removed from Products in Results of Real time MEM, Rate of photon absorption k_irmpd for each well seperately


IncludeFile "AWATAR_1.0i_include.pb"

;- Gamma Function for multiples of 1/2
Procedure.d gamma(n.d)
  If n > 1
    result.d = (n-1)*gamma(n-1)
  Else
    If n = 0.5
      result.d = Sqr(3.141592654)
    Else
      result.d = 1
    EndIf
  EndIf
  ProcedureReturn result
EndProcedure

; prepares input for reading, cuts comments from right end and trims the input from spaces beginning and end
Procedure.s trunc(text$)  
  If FindString(text$,";",1)  ; remove comments from end of text$
    text$=Left(text$,FindString(text$,";",1)-1)
  EndIf
  text$=LCase(text$)
  ; now replace all tabs with space
  text$=ReplaceString(text$,Chr(9)," ")
  text$=Trim(text$)
  ProcedureReturn text$
EndProcedure

; generates scientific output for a .d variable, e.g. 1.653e+13
Procedure.s science(value.d,decimals.l)
  If value < 0
    line$="-"
    value = -value
  EndIf
  If value = 0
    line$=StrD(value,decimals)+"e+000"
  Else
    line$=StrD(value/Pow(10,Int(Log10(value))),decimals)+"e"
    If value >= 1
      line$=line$+"+"
      line$=line$+RSet(Str(Int(Log10(value))),3,"0")
    Else                                                ;new in vs 3.12 (for values between -1 and 1)
      line$=line$+"-"
      line$=line$+RSet(Str(-Int(Log10(value))),3,"0")
    EndIf
  EndIf
  ProcedureReturn line$
EndProcedure


;- Main program

;- Physical Constants
h_planckSI.d = 6.6260693*Pow(10,-34)        ; Planck' constant in J s
conversion_cm_J.d = 1.98648*Pow(10,-23)     ; conversion factor cm-1 -> J
conversion_ht_cm.d = 219474.63              ; conversion factor Hartree -> cm-1
conversion_ghz_cm.d = 0.033356495           ; conversion factor GHz -> cm-1
h_planck.d = h_planckSI / conversion_cm_J   ; Planck's constant in cm-1 s
pi.d = 3.141592654                          ; Pi is Pi, what else should it be ...
c_light.d = 299792458                       ; vacuum light speed in m s-1
k_boltz.d = 1.3806505*Pow(10,-23)           ; Boltzmann constant in J K-1
n_avo.d = 6.0221415*Pow(10,23)              ; Avogadro constant
amu.d = 1.660539066*Pow(10,-27)             ; atomic mass unit - new in vs. 2.7

;- Flags
decimal_flag.l = 0                          ; replace decimal point with komma in results editor if = 1
DoNotClearResults_flag.l = 0                ; deletes Contents of Results panel if = 0, does not delete Contents of Results panel if = 1
TS_flag.l = 0                               ;loading tight TS (TS_flag = 0) or loose TS (TS_flag = 1)
Iterative_MEM_flag.l = 0                    ;calculation runned with iterative MEM if = 1 or with start/continue MEM if = 0
diagnostics_flag.l = 0                      ; write file filename_dia.txt if = 1
manual_temp_list_flag.l = 0                 ; If temperatures in loop are taken from "Manual List for temperatures in loop" then this flag is 1. ; new in vs. 3.57

;- Array Initialization
Dim read_freq.d(5000)       ; reading IR frequencies in cm-1
Dim read_int.d(5000)        ; reading IR intensities in km mol-1
Dim read_rot.d(3)           ; reading rotational constants in cm-1
Dim read_sym.l(3)           ; reading rotational symmetry
Dim freqline$(2)          ; buffer for preparing frequency lines of reactant input

Dim well_frequency.l(0,0)   ; IR frequencies of wells in units of bs_quantum
Dim well_intensity.d(0,0)   ; IR intensities of wells in km mol-1
Dim exact_well.d(0,0)     ; exact frequencies in cm-1
Dim ts_frequency.l(0,0)   ; IR frequencies of TS in units of bs_quantum
Dim exact_ts.d(0,0)       ; IR frequencies of TS in cm-1
Dim k_wp.d(0)             ; rate of reaction from well to product, only one direction
Dim dos_well.d(0,0)       ; initialize Beyer-Swinehart state count array, necessary because of PureBasic error check
Dim n_bs_well.l(0)        ; store n_bs parameters for density of states / Beyer-Swinehart, available energy in TS in units of bs_quantum
Dim sos_ts.d(0,0)         ; same for sum of states array
Dim n_bs_ts.l(0)          ; store n_bs parameters for sum of states / Beyer-Swinehart, available energy in TS in units of bs_quantum
Dim well_1d_ar.d(0,0)     ; rotational constants of 1-dimensional active rotors of wells in cm-1
Dim ts_1d_ar.d(0,0)       ; rotational constants of 1-dimensional active rotors of TS in cm-1
Dim well_1d_ar_sym.l(0,0) ; 1D active rotor symmetry in wells
Dim ts_1d_ar_sym.l(0,0)   ; 1D active rotor symmetry in TS
Dim well_2d_ar.d(0,0)     ; rotational constants of 2-dimensional active rotors of wells in cm-1
Dim ts_2d_ar.d(0,0)       ; rotational constants of 2-dimensional active rotors of TS in cm-1
Dim well_2d_ar_sym.l(0,0) ; 2D active rotor symmetry in wells
Dim ts_2d_ar_sym.l(0,0)   ; 2D active rotor symmetry in TS
Dim n_well_1d_ar.l(0)     ; number of active 1D-rotors in well
Dim n_ts_1d_ar.l(0)       ; number of active 1D-rotors in TS
Dim n_well_2d_ar.l(0)     ; number of active 2D-rotors in well
Dim n_ts_2d_ar.l(0)       ; number of active 2D-rotors in TS
Dim n_well_active_dof.l(0)         ; active degrees of freedom in well - new in vs. 2.7
Dim n_ts_active_dof.l(0)         ; active degrees of freedom in TS - new in vs. 2.7
Dim well_energy.d(0)      ; absolute energy of well in Hartrees
Dim well_offset.d(0)      ; user-defined offset energy of well in cm-1
Dim well_relative.d(0)    ; relative energy of well above minimum in cm-1 
Dim well_degeneracy.l(0)  ; degeneracy of well (electronic & reaction path)
Dim well_degeneracy_vector.d(0) ; Well-Degeneracy-Vector given in Parameter panel, the degeneracy of each Well is multiplied with the corresponding entry in the vector. New in vs 3.58 
Dim well_degen_corr.d(0)    ; = well_degeneracy * well_degeneracy_vector - new in vs 3.58
Dim ts_energy.d(0)        ; absolute energy of transition state in Hartrees
Dim ts_offset.d(0)        ; user-defined offset energy of TS in cm-1
Dim ts_relative.d(0)      ; relative energy of TS above minimum in cm-1 
Dim ts_degeneracy.l(0)    ; degeneracy of TS (electronic & reaction path)
Dim ts_degeneracy_vector.d(0) ; TS-Degeneracy-Vector given in Parameter panel, the degeneracy of each TS is multiplied with the corresponding entry in the vector. New in vs 3.58 
Dim loose_ts_factor.d(0)  ; factor to increase/decrease degeneracy of TS for simulation of loose/tight transition states - new in vs 3.02
Dim ts_degen_corr.d(0)    ; = ts_degeneracy * ts_degeneracy_vector * loose_ts_factor - new in vs 3.02, adapted in vs 3.58
Dim n_well_vmodes.l(0)    ; number of vibrational modes in well
Dim n_ts_vmodes.l(0)      ; number of vibrational modes in TS
; start new definitions in vs. 2.7
Dim n_well_aqsm.l(0)      ; number of arbitrary quantum state models in well
Dim n_ts_aqsm.l(0)        ; number of arbitrary quantum state models in ts
Dim aqsm_well.l(0,0,0)      ; arbitrary quantum state model well: aqsm_well.l(i,j,k): number of states within bin k of aqsm j in well i
Dim aqsm_ts.l(0,0,0)        ; arbitrary quantum state model well: aqsm_ts.l(i,j): number of states within bin k of aqsm j in ts i
Dim daqsm_well.l(0,0)       ; dimensionality of arbitrary quantum state model in well
Dim daqsm_ts.l(0,0)         ; dimensionality of arbitrary quantum state model in ts
Dim zpe_aqsm_well.d(0)      ; zero-point energy of all arbitrary quantum state models in one well
Dim zpe_aqsm_ts.d(0)        ; zero-point energy of all arbitrary quantum state models in one TS
Dim dos_rovib_aqsm.d(0)     ; rovib + aqsm dos for bs_count_rad, calculate only once and remember for efficiency
Dim temp_dos.d(0)           ; temporary dos for efficient folding of aqsm
Dim temp_sos.d(0)           ; temporary sos for efficient folding of aqsm
; end new definitions in vs. 2.7
Dim final_population.d(0,0,0)  ; remember final population in MEM run for continuing with different convergence parameters - new in vs. 2.8
Dim hr2d_flag.l(0)           ; 2d hindered rotor present? no = 0, yes = 1
Dim hr2d_b.d(0)              ; 2d hindered rotor rotational constant
Dim hr2d_sym.l(0)            ; 2d hindered rotor symmetry
Dim hr2d_V0.d(0)             ; 2d hindered rotor potential depth
Dim ts_hr2d_flag.l(0)           ; 2d hindered rotor present? no = 0, yes = 1
Dim ts_hr2d_b.d(0)              ; 2d hindered rotor rotational constant
Dim ts_hr2d_sym.l(0)            ; 2d hindered rotor symmetry
Dim ts_hr2d_V0.d(0)             ; 2d hindered rotor potential depth
Dim well_channel.l(0)           ; reactant well for channel
Dim ts_channel.l(0)             ; TS for channel: -1 is "TS all", -2 is several TS for parallel reactions, requires "Well all"
Dim ts_parallel.l(0,0)          ; only for ts_channel.l(x) = -2, parallel reactions with "Well all", stores TSs defined for channel  ; new in vs. 3.52
Dim n_ts_parallel.l(0)          ; number of TSs in channel x if ts_channel.l(x) = -2; new in vs. 3.52
Dim k_rad.d(0,0,0,0)            ; radiative transition rates between levels of same well - additional dimension for Temperature in vs.3.01
Dim well.d(0,0)                 ; population of wells in master equation model
Dim well_dos.d(0,0)             ; density of states array, spaced with total_en_step
Dim group.l(0)                  ; Array containing information, which well is assigned to which group - new in vs 3.40
Dim total_pop_group.d(0)        ; total population of all wells within a group - new in vs 3.40
Dim startwell_isoreact.l(0)     ; reactant well for isomerisation reaction - new in vs 3.41
Dim ts_isoreact.l(0)            ; TS for isomerisation reaction - new in vs 3.41
Dim endwell_isoreact.l(0)       ; well to which the isomerisation reaction goes - new in vs 3.41
Dim k_iso.d(0,0)                ; Rate for isomerisation channels - new in vs 3.41
Dim total_dos_allwells.d(0)     ; densitiy of states of all wells calculated for each bin
Dim dprod.d(0)                  ; product formation in reactive processes
Dim dwell.d(0,0)                ; depletion of well due to radiative processes and also reactive processes
Dim t_manual_list.d(0)          ; Array containing Manual List for temperatures in loop ; new in vs. 3.57
Dim k_irmpd.d(0)                ; rate of IRMPD photon absorption in s-1 for each well seperately


;- Variable Definition - optional, but very helpful!!!
bs_quantum.d = 1            ; initialize bs_quantum: Energy Quantum for Beyer-Swinehart algorithm
total_en.d = 0              ; total energy in system
total_en_start.d = 0        ; lowest value of total energy in loop
total_en_max.d = 0          ; highest value of total energy in loop
total_en_step.d = 0         ; increment of total energy in loop
dummy.d = 0                 ; locally needed floating point varible, e.g. for swapping values in arrays
idummy.l = 0                ; integer dummy
n_wells.l = 0               ; number of loaded wells
n_ts.l = 0                  ; number of loaded transition states
active_panel.l = 0          ; stores index of active panel from GetGadgetState(#Panel_0)
panel_name$ = ""            ; name of active panel
energy.d = 0                ; energy of read structure
iteration.l = 0             ; iteration number for main loop
th_energy.d = 0             ; thermal correction of read structure according to Gaussian
well_energy.d = 0           ; energy read from Gaussian
n_lines.l = 0               ; number of lines in editor gadget, used during save and read all
i_wells.l = 0               ; counter for wells
i_ts.l = 0                  ; counter for transition states
max_modes.l = 0             ; find maximum for Dim statements
max_1d.l = 0                ; find maximum for Dim statements
max_2d.l = 0                ; find maximum for Dim statements
max_aqsm.l = 0              ; find maximum for Dim statements - new in vs. 2.7
min_energy.d = 0            ; minimum energy of wells, defines 0 cm-1
current_degeneracy.l = 1    ; for reading spin multiplicities from Gaussian input and to avoid double entry "degeneracy"
n_channels.l = 0            ; number of reaction channels
i_channels.l = 0            ; counter for channels
n_fee.l = 0                 ; number of finite energy elements in master equation modeling
max_modes_well.l = 0        ; remember max_modes for wells, used later in master equation modeling
t_amb.d = 0                 ; black-body radiation temperature
n_t_amb.l = 0               ; number of temperatures in MEM loop
t_room.d = 0                ; black-body radiation temperature trough window (Roomtemperature)
window_angle.d = 0          ; portion of the solid angle fo the ICR-cell covered by the window 
int_scale.d = 1             ; scaling of IR intensities
freq_scale.d = 0            ; scaling of IR frequencies
nu_irmpd.d = 0              ; energy of IRMPD photon in cm-1
; new in vs. 2.7 for particle in a box
pib_mass.d = 0              ; mass of particle in u
pib_a.d = 0                 ; box length in Angstrom
pib_b.d = 0                 ; box length in Angstrom
pib_c.d = 0                 ; box length in Angstrom
; end new in vs. 2.7
n_groups.l = 0              ; Number of groups to which wells are assigned for MEM - new in vs 3.40
n_isochan.l = 0             ; Number of isomerisation channels between wells - new in vs 3.41
n_isoreact.l = 0            ; Number of isomerisation reactions - new in vs 3.41
max_ts_parallel.l = 100     ; maximum number of transition states in parallel reactions with "Well all" channel, used for dim only ; new in vs. 3.52
fee_barrier.d = 0           ;
fee_FreeExchange.d = 0

If ProgramParameter(0) = "terminal"
	Global terminal = 1
	Open_Window_0()
		Gosub load_all
		Gosub Iterative_MEM
		Gosub save_all
		End
Else
	Global terminal = 0 
	Open_Window_0()
	Repeat
		EventID.l = WaitWindowEvent()
		If EventID = #PB_Event_Gadget
		Select EventGadget()
			Case #Button_0
			DoNotClearResults_flag = 0
			Gosub print_rates
			Case #Button_8
			Gosub start_master_equation_modeling
			Case #Button_9
			Gosub master_equation_modeling      ; continues master equation modeling (or starts, if nothing to continue on in the first place ...)
			Case #Button_1
			Gosub load_reactant
			Case #Button_2         ;loads thight TS (with inactive rotors)
			TS_flag = 0
			Gosub load_ts
			Case #Button_3
			DoNotClearResults_flag = 0
			Gosub print_dos  ;prints density of states
			Case #Button_4   ;loads 2nd Fragment of loose TS (with 2D rotor instead of inactive rotors)
			Gosub add_ts
			Case #Button_5   ;loads 1st Fragment of loose TS (with 2D rotor instead of inactive rotors)
			TS_flag = 1
			Gosub load_ts
			Case #Button_6
			Gosub save_all
			Case #Button_7
			Gosub load_all
			Case #Button_10
			Gosub export_population
			Case #Button_11
			Gosub Iterative_MEM
			Case #Button_12
			Gosub remove_active_panel
			Case #Button_13   ;new in vs 33.0
			DoNotClearResults_flag = 0
			Gosub print_sos
			Case #Button_14  ; new in vs 36.0
			Gosub remove_multiple_panels
		EndSelect
		ElseIf EventID = #PB_Event_CloseWindow
		Gosub exit_question
		ElseIf EventID = #PB_Event_SizeWindow
		Gosub resize_window
		EndIf    
	Until Flag_Exit = 1
	End

;- Exit_question
exit_question:
  If MessageRequester("Program End", "Leaving the program will destroy" + Chr(10) + "all unsaved information, proceed?", #PB_MessageRequester_YesNo) = #PB_MessageRequester_Yes
    Flag_Exit = 1
  EndIf
Return
EndIf


;- Load reactant frequencies
load_reactant:
; Read IR modes of Reactant
; read frequency scaling factor from parameter panel
;  OpenConsole()
  Gosub read_scale_factor
  ; new by MR
  Gosub prepare_molecule_input
  ; end new by MR
  j=1
  dateiname$ = OpenFileRequester("Read Reactant Frequencies:", "\*.*", "Gaussian Output (*.out) | *.out | All Files (*.*) | *.*", 1, #PB_Requester_MultiSelection)
  While dateiname$
  	If dateiname$
		If ReadFile(0,dateiname$)
		flag_population.l = 0 ; new in vs. 2.8, prevent continue MEM with changed system
		n_wells = n_wells + 1
		OpenGadgetList(#Panel_0)
		AddGadgetItem(#Panel_0, -1, "Well "+Str(n_wells-1))
		EditorGadget(#Editor_1+n_wells+n_ts, -2, -2, 900, 470)
		SetGadgetFont(#Editor_1+n_wells+n_ts, FontID(1))   
		SetGadgetState(#Panel_0,n_wells+n_ts+1)
		AddGadgetItem(#Editor_1+n_wells+n_ts,-1,"; Reactant: "+dateiname$)
		If freq_scale <> 1
			AddGadgetItem(#Editor_1+n_wells+n_ts,-1,"; Frequency Scale Factor: "+StrD(freq_scale,4))
		EndIf
		While Eof(0)=0
			text$=ReadString(0)
			If FindString(text$,"Multiplicity",1)
			current_degeneracy.l = Val(Right(text$,2))
			EndIf
			If FindString(text$,"Frequencies -- ",1)
			For i = 0 To 2
				dotpos.l = FindString(text$,".",i*23+15)
				If dotpos > 0
				read_freq(j) = ValD(Mid(text$,dotpos-5,11))
				freqline$(i)=RSet(StrD(read_freq(j),4),10)
				EndIf
				j=j+1   ; count even if no 2nd or 3rd vibration is present for correct calculation of intensity index
			Next i
			j=j-3     ; set counter back because intensities are following
			EndIf
			If FindString(text$,"IR Inten    -- ",1)
			For i = 0 To 2
				dotpos.l = FindString(text$,".",i*23+15)
				If dotpos > 0
				read_int(j) = ValD(Mid(text$,dotpos-5,11))
				line$=freqline$(i)+RSet(StrD(read_int(j),4),12)+"    vib"
				If freq_scale <> 1
					line$=line$+RSet(StrD(ValD(freqline$(i))*freq_scale,4),12)+RSet(StrD(read_int(j),4),12)
				EndIf
				If decimal_flag = 1
					line$=ReplaceString(line$,".",",")
				EndIf
				AddGadgetItem(#Editor_1+n_wells+n_ts,-1,line$)
				j = j + 1
				EndIf
			Next i
			EndIf
			If FindString(text$,"Thermal correction to Energy=",1)
			th_energy.d = ValD(Right(text$,15))
			EndIf
			If FindString(text$,"Sum of electronic and thermal Energies",1)
			energy.d = ValD(Right(text$,15))-th_energy
			line$=RSet(StrD(energy,6),22)+"    energy"
			If decimal_flag = 1
				line$=ReplaceString(line$,".",",")
			EndIf
			AddGadgetItem(#Editor_1+n_wells+n_ts,-1,line$)
			line$ = RSet(Str(current_degeneracy),22)+"    degeneracy    ; multiply spin multiplicity with number of optical isomers"
			AddGadgetItem(#Editor_1+n_wells+n_ts,-1,line$)
			EndIf
			If FindString(UCase(text$),"ROTATIONAL CONSTANTS (GHZ)",1) And rot_flag = 1
			For i = 1 To 3
				read_rot(i) = ValD(Mid(text$,24+i*12,12))*conversion_ghz_cm
			Next i
			; determine active rotor
			If read_rot(1) = read_rot(3) ; spherical symmetric molecule with read_rot(1)=read_rot(2)=read_rot(3), changed in vs3.21
				line$=RSet(StrD(read_rot(1),6),10)+"                1D-rot symm ;Note, that this molecule is a spherical rotor"
				If decimal_flag = 1
				line$=ReplaceString(line$,".",",")
				EndIf
				AddGadgetItem(#Editor_1+n_wells+n_ts,-1,line$)
				line$=RSet(StrD(read_rot(2),6),10)+"                inactive external rotor"
				If decimal_flag = 1
				line$=ReplaceString(line$,".",",")
				EndIf
				AddGadgetItem(#Editor_1+n_wells+n_ts,-1,line$)
				line$=RSet(StrD(read_rot(3),6),10)+"                inactive external rotor"
				If decimal_flag = 1
				line$=ReplaceString(line$,".",",")
				EndIf
				AddGadgetItem(#Editor_1+n_wells+n_ts,-1,line$)
			ElseIf read_rot(1)/read_rot(2) >= read_rot(2)/read_rot(3) ; molecule approximated as prolate symmetric top
				active_b.d = read_rot(1)
				line$=RSet(StrD(read_rot(1),6),10)+" "+Str(read_sym.l(1))+"  1D-rot symm"
				If decimal_flag = 1
				line$=ReplaceString(line$,".",",")
				EndIf
				AddGadgetItem(#Editor_1+n_wells+n_ts,-1,line$)
				line$=RSet(StrD(read_rot(2),6),10)+"                inactive external rotor"
				If decimal_flag = 1
				line$=ReplaceString(line$,".",",")
				EndIf
				AddGadgetItem(#Editor_1+n_wells+n_ts,-1,line$)
				line$=RSet(StrD(read_rot(3),6),10)+"                inactive external rotor"
				If decimal_flag = 1
				line$=ReplaceString(line$,".",",")
				EndIf
				AddGadgetItem(#Editor_1+n_wells+n_ts,-1,line$)
			Else ; molecule approximated as oblate symmetric top
				active_b.d = read_rot(3)
				line$=RSet(StrD(read_rot(1),6),10)+"                inactive external rotor"
				If decimal_flag = 1
				line$=ReplaceString(line$,".",",")
				EndIf
				AddGadgetItem(#Editor_1+n_wells+n_ts,-1,line$)
				line$=RSet(StrD(read_rot(2),6),10)+"                inactive external rotor"
				If decimal_flag = 1
				line$=ReplaceString(line$,".",",")
				EndIf
				AddGadgetItem(#Editor_1+n_wells+n_ts,-1,line$)
				line$=RSet(StrD(read_rot(3),6),10)+"    "+Str(read_sym.l(1))+"           1D-rot symm"
				If decimal_flag = 1
				line$=ReplaceString(line$,".",",")
				EndIf
				AddGadgetItem(#Editor_1+n_wells+n_ts,-1,line$)
			EndIf
			EndIf
			; linear rotors
			If FindString(UCase(text$),"ROTATIONAL CONSTANT (GHZ)",1) And rot_flag=1
			read_rot(1) = ValD(Mid(text$,36,12))*conversion_ghz_cm
			; determine active rotor
			line$=";" + RSet(StrD(read_rot(1),6),10)+"    "+Str(read_sym.l(1))+"           inactive 2D rotor"
			If decimal_flag=1
				line$=ReplaceString(line$,".",",")
			EndIf
			AddGadgetItem(#Editor_1+n_wells+n_ts,-1,line$)
			EndIf
			If FindString(UCase(text$),"ROTATIONAL SYMMETRY NUMBER",1)
			read_sym.l(1) = Val(Right(text$,4))
			EndIf  
			If FindString(UCase(text$),"ROTATIONAL TEMPERATURE",1)
			rot_flag = 1
			Else
			rot_flag = 0
			EndIf
		Wend
		CloseFile(0)
		n_modes = j-1
		StatusBarText(#StatusBar_0, 0, " Read "+Str(n_modes)+" reactant frequencies.")
		Gosub resize_window
		EndIf
		Else
		StatusBarText(#StatusBar_0, 0, " Error reading reactant frequencies.")
		Ergebnis = MessageRequester("Error","Unable To Read Reactant Frequencies",#PB_MessageRequester_Ok ) 
	EndIf
	; new by MR
	Gosub check_molecule_input
	; end new by MR
	dateiname$ = NextSelectedFileName() 
Wend
Return

;- Load IR Modes of TS
; Read modes and write them into Editor window only
load_ts:
  Gosub read_scale_factor
  ; new by MR
  Gosub prepare_molecule_input
  ; end new by MR
  j=1
dateiname$ = OpenFileRequester("Read Reactant Frequencies:", "\*.*", "Gaussian Output (*.out) | *.out | All Files (*.*) | *.*", 1, #PB_Requester_MultiSelection)
While dateiname$
  If dateiname$
    If ReadFile(0,dateiname$)
      n_ts = n_ts + 1
      OpenGadgetList(#Panel_0)
      AddGadgetItem(#Panel_0, -1, "TS "+Str(n_ts-1))
      EditorGadget(#Editor_1+n_wells+n_ts, -2, -2, 900, 470)
      SetGadgetFont(#Editor_1+n_wells+n_ts, FontID(1))   
      SetGadgetState(#Panel_0,n_wells+n_ts+1)
      AddGadgetItem(#Editor_1+n_wells+n_ts,-1,"; Transition State: "+dateiname$)
      If freq_scale <> 1
        AddGadgetItem(#Editor_1+n_wells+n_ts,-1,"; Frequency Scale Factor: "+StrD(freq_scale,4))
      EndIf
      While Eof(0)=0
        text$=ReadString(0)
        If FindString(text$,"Multiplicity",1)
          current_degeneracy.l = Val(Right(text$,2))
        EndIf
        If FindString(text$,"Frequencies -- ",1)
          For i = 0 To 2
            dotpos.l = FindString(text$,".",i*23+15)
            If dotpos > 0
              read_freq(j) = ValD(Mid(text$,dotpos-5,11))
              If read_freq(j) > 0
                line$=RSet(StrD(read_freq(j),4),10)+"    vib"
                If freq_scale <> 1
                  line$=line$+RSet(StrD(read_freq(j)*freq_scale,4),10)
                EndIf
                If decimal_flag=1
                  line$=ReplaceString(line$,".",",")
                EndIf
                AddGadgetItem(#Editor_1+n_wells+n_ts,-1,line$)
              Else
                line$= ";" + RSet(StrD(read_freq(j),4),10)+"    reaction coordinate"
                If decimal_flag=1
                  line$=ReplaceString(line$,".",",")
                EndIf
                AddGadgetItem(#Editor_1+n_wells+n_ts,-1,line$)
              EndIf
              j=j+1
            EndIf
          Next i
        EndIf
        If FindString(text$,"Thermal correction to Energy=",1)
          th_energy.d = ValD(Right(text$,15))
        EndIf
        If FindString(text$,"Sum of electronic and thermal Energies",1)
          energy.d = ValD(Right(text$,15))-th_energy
          line$=RSet(StrD(energy,6),22)+"    energy"
          If decimal_flag=1
            line$=ReplaceString(line$,".",",")
          EndIf
          AddGadgetItem(#Editor_1+n_wells+n_ts,-1,line$)
          line$ = RSet(Str(current_degeneracy),22)+"    degeneracy    ; multiply with number of optical isomers and reaction path degeneracy, if applicable"
          AddGadgetItem(#Editor_1+n_wells+n_ts,-1,line$)
        EndIf
        If FindString(UCase(text$),"ROTATIONAL CONSTANTS (GHZ)",1) And rot_flag=1 ; molecule not linear
          For i = 1 To 3
            read_rot(i) = ValD(Mid(text$,24+i*12,12))*conversion_ghz_cm
          Next i
          ; determine active rotor
          If TS_flag = 0 ; when loading thight TS
           If read_rot(1) = read_rot(3) ; spherical symmetric molecule with read_rot(1)=read_rot(2)=read_rot(3) , changed in vs3.21
             line$=RSet(StrD(read_rot(1),6),10)+"                1D-rot symm ;Note, that this molecule is a spherical rotor"
             If decimal_flag = 1
               line$=ReplaceString(line$,".",",")
             EndIf
             AddGadgetItem(#Editor_1+n_wells+n_ts,-1,line$)
             line$=RSet(StrD(read_rot(2),6),10)+"                inactive external rotor"
             If decimal_flag = 1
               line$=ReplaceString(line$,".",",")
             EndIf
             AddGadgetItem(#Editor_1+n_wells+n_ts,-1,line$)
             line$=RSet(StrD(read_rot(3),6),10)+"                inactive external rotor"
             If decimal_flag = 1
               line$=ReplaceString(line$,".",",")
             EndIf
             AddGadgetItem(#Editor_1+n_wells+n_ts,-1,line$)
           ElseIf read_rot(1)/read_rot(2) >= read_rot(2)/read_rot(3) ; molecule approximated as prolate symmetric top
             active_b.d = read_rot(1)
             line$=RSet(StrD(read_rot(1),6),10)+" "+Str(read_sym.l(1))+"  1D-rot symm"
             If decimal_flag = 1
               line$=ReplaceString(line$,".",",")
             EndIf
             AddGadgetItem(#Editor_1+n_wells+n_ts,-1,line$)
             line$=RSet(StrD(read_rot(2),6),10)+"                inactive external rotor"
             If decimal_flag = 1
               line$=ReplaceString(line$,".",",")
             EndIf
             AddGadgetItem(#Editor_1+n_wells+n_ts,-1,line$)
             line$=RSet(StrD(read_rot(3),6),10)+"                inactive external rotor"
             If decimal_flag = 1
               line$=ReplaceString(line$,".",",")
             EndIf
             AddGadgetItem(#Editor_1+n_wells+n_ts,-1,line$)
           Else ; molecule approximated as oblate symmetric top
             active_b.d = read_rot(3)
             line$=RSet(StrD(read_rot(1),6),10)+"                inactive external rotor"
             If decimal_flag = 1
               line$=ReplaceString(line$,".",",")
             EndIf
             AddGadgetItem(#Editor_1+n_wells+n_ts,-1,line$)
             line$=RSet(StrD(read_rot(2),6),10)+"                inactive external rotor"
             If decimal_flag = 1
               line$=ReplaceString(line$,".",",")
             EndIf
             AddGadgetItem(#Editor_1+n_wells+n_ts,-1,line$)
             line$=RSet(StrD(read_rot(3),6),10)+"    "+Str(read_sym.l(1))+"           1D-rot symm"
             If decimal_flag = 1
               line$=ReplaceString(line$,".",",")
             EndIf
             AddGadgetItem(#Editor_1+n_wells+n_ts,-1,line$)
           EndIf
          Else ;when loading loose TS, new in vs 3.20, changed in vs3.21
           If read_rot(1) = read_rot(3) ; spherical symmetric molecule with read_rot(1)=read_rot(2)=read_rot(3)
             line$=RSet(StrD(read_rot(1),6),10)+"   1D-rot symm"
             If decimal_flag=1
               line$=ReplaceString(line$,".",",")
             EndIf
             AddGadgetItem(#Editor_1+n_wells+n_ts,-1,line$)
             line$=RSet(StrD(read_rot(2),6),10)+"   2D-rot symm"
             If decimal_flag=1
               line$=ReplaceString(line$,".",",")
             EndIf
             AddGadgetItem(#Editor_1+n_wells+n_ts,-1,line$)
             line$=";" + RSet(StrD(read_rot(3),6),10)+"    inactive external rotor"
             If decimal_flag=1
               line$=ReplaceString(line$,".",",")
             EndIf
             AddGadgetItem(#Editor_1+n_wells+n_ts,-1,line$)
           ElseIf read_rot(1)/read_rot(2) >= read_rot(2)/read_rot(3) ; molecule approximated as prolate symmetric top
             line$=RSet(StrD(read_rot(1),6),10)+" "+Str(read_sym.l(1))+"  1D-rot symm"
             If decimal_flag=1
               line$=ReplaceString(line$,".",",")
             EndIf
             AddGadgetItem(#Editor_1+n_wells+n_ts,-1,line$)
             line$=";" + RSet(StrD(read_rot(2),6),10)+"    inactive external rotor"
             If decimal_flag=1
               line$=ReplaceString(line$,".",",")
             EndIf
             AddGadgetItem(#Editor_1+n_wells+n_ts,-1,line$)
             line$=";" + RSet(StrD(read_rot(3),6),10)+"    inactive external rotor"
             If decimal_flag=1
               line$=ReplaceString(line$,".",",")
             EndIf
             AddGadgetItem(#Editor_1+n_wells+n_ts,-1,line$)
             line$=RSet(StrD(Sqr(read_rot(3)*read_rot(2)),6),10)+" 1  2D-rot symm ;symmetry number set to 1, because it is already counted for this fragment in the 1d rotor"  ; instead of 2 inactive external rotors, there is one active 2d Rotor, with rotational constant = geometric mean of the rotational constants from inactive rotors.  ; Symmetry number set to 1, because it is already counted for this fragment in the 1d rotor
             If decimal_flag=1
               line$=ReplaceString(line$,".",",")
             EndIf
             AddGadgetItem(#Editor_1+n_wells+n_ts,-1,line$)
           Else ; molecule approximated as oblate symmetric top
             line$=";" + RSet(StrD(read_rot(1),6),10)+"    inactive external rotor"
             If decimal_flag=1
               line$=ReplaceString(line$,".",",")
             EndIf
             AddGadgetItem(#Editor_1+n_wells+n_ts,-1,line$)
             line$=";" + RSet(StrD(read_rot(2),6),10)+"    inactive external rotor"
             If decimal_flag=1
               line$=ReplaceString(line$,".",",")
             EndIf
             AddGadgetItem(#Editor_1+n_wells+n_ts,-1,line$)
             line$=RSet(StrD(Sqr(read_rot(1)*read_rot(2)),6),10)+" 1  2D-rot symm  ;symmetry number set to 1, because it is already counted for this fragment in the 1d rotor." ; instead of 2 inactive external rotors, there is one active 2d Rotor, with rotational constant = geometric mean of the rotational constants from inactive rotors.  ; Symmetry number set to 1, because it is already counted for this fragment in the 1d rotor
             If decimal_flag=1
               line$=ReplaceString(line$,".",",")
             EndIf
             AddGadgetItem(#Editor_1+n_wells+n_ts,-1,line$)
             line$=RSet(StrD(read_rot(3),6),10)+" "+Str(read_sym.l(1))+"  1D-rot symm"
             If decimal_flag=1
               line$=ReplaceString(line$,".",",")
             EndIf
             AddGadgetItem(#Editor_1+n_wells+n_ts,-1,line$)
           EndIf
          EndIf
        EndIf 
        ; linear rotors
        If FindString(UCase(text$),"ROTATIONAL CONSTANT (GHZ)",1) And rot_flag=1
          read_rot(1) = ValD(Mid(text$,36,12))*conversion_ghz_cm
          ; determine active rotor
          If TS_flag = 0 ; when loading thight TS
            line$=";" + RSet(StrD(read_rot(1),6),10)+" "+Str(read_sym.l(1))+" inactive 2D rotor"
          Else ;loose TS
            line$=RSet(StrD(read_rot(1),6),10)+" "+Str(read_sym.l(1))+"  2D-rot symm"
          EndIf
          If decimal_flag=1
            line$=ReplaceString(line$,".",",")
          EndIf
          AddGadgetItem(#Editor_1+n_wells+n_ts,-1,line$)
        EndIf
        If FindString(UCase(text$),"ROTATIONAL SYMMETRY NUMBER",1)
          read_sym.l(1) = Val(Right(text$,4))
        EndIf  
        If FindString(UCase(text$),"ROTATIONAL TEMPERATURE",1)
          rot_flag = 1
        Else
          rot_flag = 0
        EndIf
      Wend
      CloseFile(0)
      n_modes_ts = j-1
      StatusBarText(#StatusBar_0, 0, " Read "+Str(n_modes_ts)+" transition state frequencies.")
      Gosub resize_window
    EndIf
    Else
      StatusBarText(#StatusBar_0, 0, " Error reading transition state frequencies.")
      Ergebnis = MessageRequester("Error","Unable To Read TS Frequencies",#PB_MessageRequester_Ok ) 
  EndIf
  ; new by MR
  Gosub check_molecule_input
  ; end new by MR
  dateiname$ = NextSelectedFileName()
Wend
Return

;- Add IR Modes of 2nd TS fragment (for loose TS)
; Read modes and write them into Editor window only
add_ts:
  Gosub read_scale_factor
  ; new by MR
  Gosub prepare_molecule_input
  ; end new by MR
  j = 1
  dateiname$ = OpenFileRequester("Add 2nd Transition State Fragment:", "\*.*", "Gaussian Output (*.out) | *.out | All Files (*.*) | *.*", 1)
  to_add$ = ""
  to_add$ = Trim(InputRequester("Add 2nd TS fragment",
							    "To which TS do you want to add the 2nd TS fragment? Input is in the form n-m. E.g.: 0-1, 9-9", ""))
  Define dashPos.i, startVal.i, endVal.i
  dashPos = FindString(to_add$, "-", 1)
  If dashPos <= 0
    MessageRequester("Error", "Input must be in the form n-m.", 0)
  EndIf
  startVal = Val(Left(to_add$, dashPos - 1))
  endVal = Val(Mid(to_add$, dashPos + 1))
  If Str(startVal) = "" Or Str(endVal) = ""   
    MessageRequester("Error", "Both n and m must be numbers.", 0)
  ElseIf endVal < startVal
    MessageRequester("Error", "End value must be bigger or equal to start value.", 0)
  EndIf

 For l = 0 To n_wells + n_ts + 1
	For k = startVal To endVal
		active_panel = l
		panel_name$ = "TS " + Str(k)
		If GetGadgetItemText(#panel_0,l) = panel_name$
			If dateiname$
			If ReadFile(0,dateiname$)
				AddGadgetItem(#Editor_1+active_panel-1,-1,"")
				AddGadgetItem(#Editor_1+active_panel-1,-1,"; 2nd fragment: "+dateiname$)
				If freq_scale <> 1
				AddGadgetItem(#Editor_1+active_panel-1,-1,"; Frequency Scale Factor: "+StrD(freq_scale,4))
				EndIf
				While Eof(0)=0
				text$=ReadString(0)
				If FindString(text$,"Multiplicity",1)
					current_degeneracy.l = Val(Right(text$,2))
				EndIf  
				If FindString(text$,"Frequencies -- ",1)
					For i = 0 To 2
					dotpos.l = FindString(text$,".",i*23+15)
					If dotpos > 0
					read_freq(j) = ValD(Mid(text$,dotpos-5,11))
					If read_freq(j) > 0
						line$=RSet(StrD(read_freq(j),4),10)+"    vib"
						If freq_scale <> 1
						line$=line$+RSet(StrD(read_freq(j)*freq_scale,4),10)
						EndIf
						If decimal_flag=1
						line$=ReplaceString(line$,".",",")
						EndIf
						AddGadgetItem(#Editor_1+active_panel-1,-1,line$)
						Else
						line$=";" + RSet(StrD(read_freq(j),4),10)+"    reaction coordinate"
						If decimal_flag=1
							line$=ReplaceString(line$,".",",")
						EndIf
						AddGadgetItem(#Editor_1+active_panel-1,-1,line$)
						EndIf
						j=j+1
					EndIf
					Next i
				EndIf
				If FindString(text$,"Thermal correction to Energy=",1)
					th_energy.d = ValD(Right(text$,15))
				EndIf
				If FindString(text$,"Sum of electronic and thermal Energies",1)
					energy.d = ValD(Right(text$,15))-th_energy
					line$=RSet(StrD(energy,6),22)+"    energy"
					If decimal_flag=1
					line$=ReplaceString(line$,".",",")
					EndIf
					AddGadgetItem(#Editor_1+active_panel-1,-1,line$)
					If current_degeneracy = 1
					line$ = "; The Multiplicity of this fragment is " + RSet(Str(current_degeneracy),1)
					Else
					line$ = "; The Multiplicity of this fragment is " + RSet(Str(current_degeneracy),1)+"     WARNING: Degeneracy should be adapted according to the physics of the system"
					EndIf  
					AddGadgetItem(#Editor_1+active_panel-1,-1,line$)
				EndIf
				If FindString(UCase(text$),"ROTATIONAL CONSTANTS (GHZ)",1) And rot_flag=1
					For i = 1 To 3
					read_rot(i) = ValD(Mid(text$,24+i*12,12))*conversion_ghz_cm
					Next i
					; determine active rotor ;changed in vs 3.20, 3.21
					If read_rot(1) = read_rot(3) ; spherical symmetric molecule with read_rot(1)=read_rot(2)=read_rot(3)
					line$= RSet(StrD(read_rot(1),6),10)+"   1D-rot symm"
					If decimal_flag=1
					line$=ReplaceString(line$,".",",")
					EndIf
					AddGadgetItem(#Editor_1+active_panel-1,-1,line$)
					line$=RSet(StrD(read_rot(2),6),10)+"   2D-rot symm"
					If decimal_flag=1
					line$=ReplaceString(line$,".",",")
					EndIf
					AddGadgetItem(#Editor_1+active_panel-1,-1,line$)
					line$=";" + RSet(StrD(read_rot(3),6),10)+"    inactive external rotor"
					If decimal_flag=1
					line$=ReplaceString(line$,".",",")
					EndIf
					AddGadgetItem(#Editor_1+active_panel-1,-1,line$)
				ElseIf read_rot(1)/read_rot(2) >= read_rot(2)/read_rot(3) ; molecule approximated as prolate symmetric top
					line$=RSet(StrD(read_rot(1),6),10)+" "+Str(read_sym.l(1))+"  1D-rot symm"
					If decimal_flag=1
					line$=ReplaceString(line$,".",",")
					EndIf
					AddGadgetItem(#Editor_1+active_panel-1,-1,line$)
					line$=";" + RSet(StrD(read_rot(2),6),10)+"    inactive external rotor"
					If decimal_flag=1
					line$=ReplaceString(line$,".",",")
					EndIf
					AddGadgetItem(#Editor_1+active_panel-1,-1,line$)
					line$=";" + RSet(StrD(read_rot(3),6),10)+"    inactive external rotor"
					If decimal_flag=1
					line$=ReplaceString(line$,".",",")
					EndIf
					AddGadgetItem(#Editor_1+active_panel-1,-1,line$)
					line$=RSet(StrD(Sqr(read_rot(3)*read_rot(2)),6),10)+" 1  2D-rot symm ;symmetry number set to 1."  ; instead of 2 inactive external rotors, there is one active 2d Rotor, with rotational constant = geometric mean of the rotational constants from inactive rotors.  ; Symmetry number set to 1, because it is already counted for this fragment in the 1d rotor
					If decimal_flag=1
					line$=ReplaceString(line$,".",",")
					EndIf
					AddGadgetItem(#Editor_1+active_panel-1,-1,line$)
				Else ; molecule approximated as oblate symmetric top
					line$=";" + RSet(StrD(read_rot(1),6),10)+"    inactive external rotor"
					If decimal_flag=1
					line$=ReplaceString(line$,".",",")
					EndIf
					AddGadgetItem(#Editor_1+active_panel-1,-1,line$)
					line$=";" + RSet(StrD(read_rot(2),6),10)+"    inactive external rotor"
					If decimal_flag=1
					line$=ReplaceString(line$,".",",")
					EndIf
					AddGadgetItem(#Editor_1+active_panel-1,-1,line$)
					line$=RSet(StrD(Sqr(read_rot(1)*read_rot(2)),6),10)+" 1  2D-rot symm  ;symmetry number set to 1." ; instead of 2 inactive external rotors, there is one active 2d Rotor, with rotational constant = geometric mean of the rotational constants from inactive rotors.  ; Symmetry number set to 1, because it is already counted for this fragment in the 1d rotor
					If decimal_flag=1
					line$=ReplaceString(line$,".",",")
					EndIf
					AddGadgetItem(#Editor_1+active_panel-1,-1,line$)
					line$=RSet(StrD(read_rot(3),6),10)+" "+Str(read_sym.l(1))+"  1D-rot symm"
					If decimal_flag=1
					line$=ReplaceString(line$,".",",")
					EndIf
					AddGadgetItem(#Editor_1+active_panel-1,-1,line$)
				EndIf
				EndIf
				; linear rotors
				If FindString(UCase(text$),"ROTATIONAL CONSTANT (GHZ)",1) And rot_flag=1
					read_rot(1) = ValD(Mid(text$,36,12))*conversion_ghz_cm
					; determine active rotor
					line$=RSet(StrD(read_rot(1),6),10)+" "+Str(read_sym.l(1))+"  2D-rot symm"
					If decimal_flag=1
					line$=ReplaceString(line$,".",",")
					EndIf
					AddGadgetItem(#Editor_1+active_panel-1,-1,line$)
				EndIf
				If FindString(UCase(text$),"ROTATIONAL SYMMETRY NUMBER",1)
					read_sym.l(1) = Val(Right(text$,4))
				EndIf  
				If FindString(UCase(text$),"ROTATIONAL TEMPERATURE",1)
					rot_flag = 1
				Else
					rot_flag = 0
				EndIf
				Wend
				CloseFile(0)
				n_modes_ts = j-1
				StatusBarText(#StatusBar_0, 0, " Read "+Str(n_modes_ts)+" transition state frequencies.")
				Gosub resize_window
			EndIf
			Else
				StatusBarText(#StatusBar_0, 0, " Error reading transition state frequencies.")
				Ergebnis = MessageRequester("Error","Unable To Read TS Frequencies",#PB_MessageRequester_Ok ) 
			EndIf
		Gosub check_molecule_input
		EndIf	
	Next k
  Next l
Return

;- remove Well / TS
remove_active_panel:
active_panel = GetGadgetState(#panel_0)
  If active_panel > 1
    panel_name$ = GetGadgetItemText(#Panel_0,active_panel)
    ergebnis = MessageRequester("Remove Well / TS","Do you really want to remove "+panel_name$+"?",#PB_MessageRequester_YesNo)
    If ergebnis = #PB_MessageRequester_Yes
      flag_population.l = 0 ; new in vs. 2.8, prevents continue MEM with different number of wells
      If Left(panel_name$,2) = "TS"   ; remove TS
        For i = active_panel+1 To n_wells+n_ts+1
          panel_name$=GetGadgetItemText(#Panel_0,i)
          If Left(panel_name$,2) = "TS"
            idummy = Val(Right(panel_name$,Len(panel_name$)-2))
            panel_name$ = "TS "+Str(idummy-1)
          EndIf
          SetGadgetItemText(#Panel_0,i-1,panel_name$)
          SetGadgetText(#Editor_1+i-2,GetGadgetText(#Editor_1+i-1))
        Next i
        RemoveGadgetItem(#panel_0,n_wells+n_ts+1)
        n_ts = n_ts-1  
      Else                            ; remove well
        For i = active_panel+1 To n_wells+n_ts+1
          panel_name$=GetGadgetItemText(#Panel_0,i)
          If Left(panel_name$,4) = "Well"
            idummy = Val(Right(panel_name$,Len(panel_name$)-4))
            panel_name$ = "Well "+Str(idummy-1)
          EndIf
          SetGadgetItemText(#Panel_0,i-1,panel_name$)
          SetGadgetText(#Editor_1+i-2,GetGadgetText(#Editor_1+i-1))
        Next i
        RemoveGadgetItem(#panel_0,n_wells+n_ts+1)
        n_wells = n_wells-1  
      EndIf
    EndIf
  EndIf
  Gosub resize_window
  Return
   
   
;- remove multiple Wells/TSs
; In the pop-up window, the user has to enter "[Well|TS] m-n" to remove either all wells from well m to well n, or all transition states from TS m to TS n.
; e.g., "Well 3-6" removes the wells 3,4,5,6; or "TS 0-1" removes TS 0 and 1; or "TS 18-18" removes TS 18
  remove_multiple_panels:
  to_be_removed$ = "None"
  to_be_removed$ = Trim(InputRequester("Which Wells/TSs do you want to remove?",
                                       "Input is in the form [Well|TS] m-n. E.g.: Well 3-6, TS 0-1, TS 9-9", ""))
  ts_flag = 0
  well_flag = 0
  ts_well_string$ = "TS/Well"
  If Left(to_be_removed$,2) = "TS"   ; remove TSs
    ts_flag = 1
    len_ts_well = 2  ;the word "TS" has 2 characters
    ts_well_string$ = "TS"
  ElseIf Left(to_be_removed$,4) = "Well"   ; remove Wells
    well_flag = 1
    len_ts_well = 4  ;the word "Well" has 4 characters
    ts_well_string$ = "Well"
  Else
    MessageRequester("Warning", "Invalid Input")
  EndIf
  
    indices_compact$ = Trim(Right(to_be_removed$, Len(to_be_removed$)-len_ts_well));  e.g. "3-6"
    split_position = FindString(indices_compact$, "-")

    If split_position = 0
      MessageRequester("Warning", "Invalid Input. Please provide input in the form '[Well|TS] m-n'")
      Return
    EndIf
    start_index$ = Left(indices_compact$, split_position-1)
    If start_index$ = ""
      MessageRequester("Warning", "Invalid Input. Please provide input in the form '[Well|TS] m-n'")
      Return
    EndIf
    start_index = Val(start_index$)

    end_index$ = Right(indices_compact$, Len(indices_compact$)-split_position)
    If end_index$ = ""
      MessageRequester("Warning", "Invalid Input. Please provide input in the form '[Well|TS] m-n'")
      Return
    EndIf
    end_index = Val(end_index$)
    
    ; loop through all TSs OR Wells which should be removed (from start_index to end_index)
    For ts_well_index = start_index To end_index
      ; first find out which panel "start_index" refers to
      ; be aware that in every iteration of the loop, all TSs OR Wells are shifted by one, therefore, in every iteration of the loop, the TS/Well which is to be deleted is increased by 1 and decreased by 1, hence, remains constant at start_index
      reference_panel$ = ts_well_string$ + " " + Str(start_index)
      start_index_panel = -1
      For i = 0 To n_wells + n_ts + 1
        panel_name$ = GetGadgetItemText(#panel_0,i)
        If panel_name$ = reference_panel$
          start_index_panel = i
          Break
        EndIf
      Next i
    If start_index_panel = -1
      MessageRequester("Warning", "The provided " + ts_well_string$ + " could not be found.")
      Break
    EndIf
    
    ; now shift the Wells and TSs and rename accordingly
    flag_population.l = 0 ; new in vs. 2.8, prevents continue MEM with different number of wells
    For i = start_index_panel+1 To n_wells+n_ts+1
       panel_name$=GetGadgetItemText(#Panel_0,i)
       If Left(panel_name$,len_ts_well) = ts_well_string$  ;when deleting TSs, check if panel is a TS panel; when deleting Wells, check if panel is a Well panel
         idummy = Val(Right(panel_name$,Len(panel_name$)-len_ts_well))
         panel_name$ = ts_well_string$ + " " +Str(idummy-1)
       EndIf
       SetGadgetItemText(#Panel_0,i-1,panel_name$)
       SetGadgetText(#Editor_1+i-2,GetGadgetText(#Editor_1+i-1))
    Next i
    RemoveGadgetItem(#panel_0,n_wells+n_ts+1)
        If ts_flag
          n_ts = n_ts-1
        ElseIf well_flag
          n_wells = n_wells - 1
        EndIf
          
    Next ts_well_index
  
  Return

;- Save all
save_all:
  ; Write complete status in one large file
  If terminal = 1
    save_file$ = ProgramParameter(2)  
  Else
    save_file$ = SaveFileRequester("Save kinetic data as:","\*.*","RRKM files (*.rrk) | *.rrk|All Files (*.*)|*.*",0)
  EndIf 
  If save_file$<>""
    flag = #PB_MessageRequester_Yes
    If Right(save_file$,4) <> ".rrk"
      save_file$ = save_file$ + ".rrk"
    EndIf
    If ReadFile(0,save_file$) <> 0
      CloseFile(0)
      flag = MessageRequester("Warning","File "+save_file$ + Chr(10) + "exists, overwrite?",#PB_MessageRequester_YesNo)
    EndIf
    If flag = #PB_MessageRequester_Yes
      Gosub Write_RRK_FILE
    EndIf  
  Else
    MessageRequester("Error Notification","RRKM data could not be saved.",#PB_MessageRequester_Ok)
  EndIf
Return

;-Automatic Save All
Automatic_Save_All:
   ; Write complete status in one large file
  save_file$ = Filename$ + "_checkpoint.rrk"
  Gosub Write_RRK_FILE
Return

;-Write RRK File
Write_RRK_FILE:
      If CreateFile(0,save_file$)<>0
        ; finally start writing
        WriteStringN(0,"This is an AWATAR file.")
        WriteLong(0,n_wells)
        WriteLong(0,n_ts)
        WriteLong(0,decimal_flag)
        ; Write all panels
        For k = 0 To n_wells+n_ts+1
          WriteStringN(0,GetGadgetItemText(#Panel_0,k))
          n_lines = CountGadgetItems(#Editor_0+k)
          WriteLong(0,n_lines)
          For i = 0 To n_lines-1
            WriteStringN(0,GetGadgetItemText(#editor_0+k,i))
          Next i          
        Next k
        WriteLong(0,flag_population.l) ; new in vs. 2.80: write population to file
        If flag_population.l = 1
          WriteLong(0,n_t_amb.l)
          WriteLong(0,n_fee)
          WriteLong(0,n_wells)
          For i_t = 0 To n_t_amb.l-1
            For i_fee = 0 To n_fee
              For i_wells = 0 To n_wells-1
                WriteDouble(0,final_population.d(i_t,i_wells,i_fee))
              Next i_wells
            Next i_fee
          Next i_t  
        EndIf
        CloseFile(0)
        StatusBarText(#StatusBar_0, 0,"RRKM data written successfully: "+save_file$)
      Else
        MessageRequester("Error Notification","Error opening file "+ Chr(10) + save_file$ + Chr(10)+"RRKM data not saved.",#PB_MessageRequester_Ok)
      EndIf
 Return     



;- Load all
Load_all:
  If terminal = 1
	save_file$ = ProgramParameter(1)
  Else
	save_file$ = OpenFileRequester("Load RRKM data from:", "\*.*", "RRKM files (*.rrk)|*.rrk|All Files (*.*)|*.*", 0)
  EndIf
  If save_file$<>""
    If ReadFile(0,save_file$)<>0
      in$=ReadString(0)
      If in$<>"This is an RRKM 2.00 file." And in$<>"This is an RRKM 2.80 file." And in$<>"This is an AWATAR file."
        MessageRequester("Error Notification","This file does not contain RRKM data in the expected format.",#PB_MessageRequester_Ok)
        CloseFile(0)
      Else
        n_wells = ReadLong(0)
        n_ts = ReadLong(0)
        decimal_flag = ReadLong(0)
        ; Read all panels
        ClearGadgetItems(#Panel_0)
        OpenGadgetList(#Panel_0)
        For k = 0 To n_wells+n_ts+1
          AddGadgetItem(#Panel_0,-1,ReadString(0))
          EditorGadget(#Editor_0+k, -2, -2, 900, 470)
          SetGadgetFont(#Editor_0+k, FontID(1))   
          ClearGadgetItems(#Editor_0+k) 
          n_lines = ReadLong(0)
          For i = 0 To n_lines-1
            AddGadgetItem(#editor_0+k,-1,ReadString(0))
          Next i          
        Next k
        If in$="This is an RRKM 2.80 file." Or in$="This is an AWATAR file."
          flag_population.l = ReadLong(0) ; new in vs. 2.80: write population to file
          If flag_population.l = 1
            n_t_amb.l = ReadLong(0)
            n_fee.l = ReadLong(0)
            n_wells.l = ReadLong(0)
            Dim final_population.d(n_t_amb-1,n_wells-1,n_fee)
            For i_t = 0 To n_t_amb-1
              For i_fee = 0 To n_fee
                For i_wells = 0 To n_wells-1
                  final_population.d(i_t,i_wells,i_fee) = ReadDouble(0)
                Next i_wells
              Next i_fee
            Next i_t  
          EndIf
        EndIf
        CloseFile(0)
        StatusBarText(#StatusBar_0, 0,"RRKM data loaded from file: "+save_file$)
        Gosub resize_window
      EndIf
    Else
      MessageRequester("Error Notification","Error opening file "+ Chr(10) + save_file$ + Chr(10)+"RRKM data not read.",#PB_MessageRequester_Ok)
    EndIf
  Else
    MessageRequester("Error Notification","RRKM data could not be read.",#PB_MessageRequester_Ok)
  EndIf
Return

;- Read Well Data from Panel
read_well_data:
  Dim n_well_vmodes.l(n_wells-1)       ; number of vibrational modes in well
  Dim n_well_1d_ar.l(n_wells-1)        ; number of active 1D-rotors in well
  Dim n_well_2d_ar.l(n_wells-1)        ; number of active 2D-rotors in well
  Dim n_well_aqsm.l(n_wells-1)         ; number of arbitrary quantum state models in well - new in vs. 2.7
  Dim hr2d_flag.l(n_wells-1)           ; 2d hindered rotor present? no = 0, yes = 1
  Dim hr2d_b.d(n_wells-1)              ; 2d hindered rotor rotational constant
  Dim hr2d_sym.l(n_wells-1)            ; 2d hindered rotor symmetry
  Dim hr2d_V0.d(n_wells-1)             ; 2d hindered rotor potential depth
  Dim n_well_active_dof.l(n_wells-1)         ; active degrees of freedom in well - new in vs. 2.7
  max_modes.l = 0             ; find maximum for Dim statements
  max_1d.l = 0                ; find maximum for Dim statements
  max_2d.l = 0                ; find maximum for Dim statements
  max_aqsm.l = 0              ; find maximum for Dim statements - new in vs. 2.7
  maxbin.l = total_en_max / bs_quantum   ; maximum bin number for aqsm - new in vs. 2.7
  ; count IR modes, active rotors and arbitrary quantum state models in each well
  i_wells = 0
  For k = 2 To n_wells + n_ts + 1
    If Left(GetGadgetItemText(#Panel_0,k),4)="Well"
      j = 0
      text$=Trunc(GetGadgetItemText(#Editor_0+k,j,0))
      If decimal_flag = 1
        text$=ReplaceString(text$,",",".")
      EndIf
      While j<CountGadgetItems(#Editor_0+k)
        If FindString(text$,"vib",1)
          n_well_vmodes(i_wells) = n_well_vmodes(i_wells) + 1
        EndIf
        If FindString(text$,"1d-rot symm",1)
          n_well_1d_ar.l(i_wells) = n_well_1d_ar(i_wells) + 1      ; number of active 1D-rotors in well
        EndIf
        If FindString(text$,"2d-rot symm",1)
          n_well_2d_ar.l(i_wells) = n_well_2d_ar(i_wells) + 1      ; number of active 2D-rotors in well
        EndIf
        If FindString(text$,"2d-hr symm v0",1) And hr2d_flag(i_wells) = 0
          hr2d_flag.l(i_wells) = 1           ; 2d hindered rotor present
        EndIf
        If FindString(text$,"pib1d mass a",1) Or FindString(text$,"pib2d mass a b",1) Or FindString(text$,"pib3d mass a b c",1) ; new in vs. 2.7, append or repeat for new aqsm
          n_well_aqsm.l(i_wells) = n_well_aqsm(i_wells) + 1      ; number of arbitrary quantum state models in well
        EndIf
        j = j + 1
        text$=Trunc(GetGadgetItemText(#Editor_0+k,j,0))
        If decimal_flag = 1
          text$=ReplaceString(text$,",",".")
        EndIf
      Wend
      If max_modes < n_well_vmodes(i_wells)
        max_modes = n_well_vmodes(i_wells)
      EndIf
      If max_1d < n_well_1d_ar(i_wells)
        max_1d = n_well_1d_ar(i_wells)
      EndIf
      If max_2d < n_well_2d_ar(i_wells)
        max_2d = n_well_2d_ar(i_wells)
      EndIf
      If max_aqsm < n_well_aqsm(i_wells) ; new in vs. 2.7
        max_aqsm = n_well_aqsm(i_wells)
      EndIf
      i_wells = i_wells + 1
    EndIf
  Next k
  ; Now read all data
  Dim well_frequency.l(n_wells-1,max_modes)   ; IR frequencies of wells in units of bs_quantum
  Dim well_intensity.d(n_wells-1,max_modes)   ; IR intensities of wells in km mol-1
  Dim exact_well.d(n_wells-1,max_modes)       ; exact frequencies in cm-1
  Dim well_1d_ar.d(n_wells-1,max_1d)       ; rotational constants of 1-dimensional active rotors of wells in cm-1
  Dim well_1d_ar_sym.l(n_wells-1,max_1d)   ; 1D active rotor symmetry in wells
  Dim well_2d_ar.d(n_wells-1,max_2d)       ; rotational constants of 2-dimensional active rotors of wells in cm-1
  Dim well_2d_ar_sym.l(n_wells-1,max_2d)   ; 2D active rotor symmetry in wells
  Dim n_well_vmodes.l(n_wells-1)    ; number of vibrational modes in well
  Dim n_well_1d_ar.l(n_wells-1)     ; number of active 1D-rotors in well
  Dim n_well_2d_ar.l(n_wells-1)     ; number of active 2D-rotors in well
  ; start new definitions in vs. 2.7
  Dim n_well_aqsm.l(n_wells-1)      ; number of arbitrary quantum state models in well
  Dim aqsm_well.l(n_wells-1,max_aqsm,maxbin)      ; arbitrary quantum state model; aqsm_well.l(i,j,k): number of states within bin k of aqsm j in well i
  Dim daqsm_well.l(n_wells-1,max_aqsm)            ; dimensionality of arbitrary quantum state model in well 
  Dim zpe_aqsm_well.d(n_wells-1)                  ; sum of zero-point energies of arbitrary quantum state model for one well
  Dim n_well_active_dof.l(n_wells-1)        ; active degrees of freedom in well 
  ; end new definitions in vs. 2.7
  Dim hr2d_b.d(n_wells-1)              ; 2d hindered rotor rotational constant
  Dim hr2d_sym.l(n_wells-1)            ; 2d hindered rotor symmetry
  Dim hr2d_V0.d(n_wells-1)             ; 2d hindered rotor potential depth
  Dim well_energy.d(n_wells-1)      ; absolute energy of well in Hartrees
  Dim well_offset.d(n_wells-1)      ; user-defined offset energy of well in cm-1
  Dim well_relative.d(n_wells-1)    ; relative energy of well above minimum in cm-1 
  Dim well_degeneracy.l(n_wells-1)  ; degeneracy of well (electronic & reaction path)
  Dim well_degeneracy_vector.d(n_wells-1) ; Well-Degeneracy-Vector given in Parameter panel, the degeneracy of each Well is multiplied with the corresponding entry in the vector. New in vs 3.58
  Dim well_degen_corr.d(n_wells-1)    ; = well_degeneracy * well_degeneracy_vector - new in vs 3.58
  
  i_wells = 0
  For k = 2 To n_wells + n_ts + 1
    If Left(GetGadgetItemText(#Panel_0,k),4)="Well"
      j = 0
      text$=Trunc(GetGadgetItemText(#Editor_0+k,j,0))
      If decimal_flag = 1
        text$=ReplaceString(text$,",",".")
      EndIf
      While j<CountGadgetItems(#Editor_0+k)
        If FindString(text$,"vib",1)
          n_well_vmodes.l(i_wells) = n_well_vmodes(i_wells) + 1
          n_well_active_dof.l(i_wells) = n_well_active_dof.l(i_wells) + 1
          If FindString(text$,"vib",1)+2 < Len(text$) ; "vib" is not at the end of line, i.e. values must be read after "vib"
            Gosub parse
            Gosub parse
            dummy$ = parse$       ; remember original intensity information, if only frequency is changed by user
            text$ = Right(text$,Len(text$)-FindString(text$,"vib",1)-2)
          EndIf
          Gosub parse
          exact_well(i_wells,n_well_vmodes(i_wells))=ValD(parse$)
          Gosub parse
          If parse$ = ""
            well_intensity(i_wells,n_well_vmodes(i_wells))=ValD(dummy$)
          Else
            well_intensity(i_wells,n_well_vmodes(i_wells))=ValD(parse$)
          EndIf
          ; sort newly read vibrational mode in correct place, array must be sorted with increasing energies for Beyer-Swinehart
          If n_well_vmodes(i_wells) > 1
            i = n_well_vmodes(i_wells)
            While exact_well(i_wells,i)<exact_well(i_wells,i-1) And i>1
              dummy.d = exact_well(i_wells,i)
              exact_well(i_wells,i) = exact_well(i_wells,i-1)
              exact_well(i_wells,i-1) = dummy
              i=i-1
            Wend
          EndIf
        EndIf
        If FindString(text$,"1d-rot symm",1)
          n_well_1d_ar.l(i_wells) = n_well_1d_ar(i_wells) + 1      ; number of active 1D-rotors in well
          n_well_active_dof.l(i_wells) = n_well_active_dof.l(i_wells) + 1
          If FindString(text$,"1d-rot symm",1)+10 < Len(text$) ; "1D-rot symm" is not at the end of line, i.e. values must be read after "1D-rot symm"
            text$ = Right(text$,Len(text$)-FindString(text$,"1d-rot symm",1)-10)
          EndIf
          Gosub parse
          well_1d_ar.d(i_wells,n_well_1d_ar(i_wells)) = ValD(parse$)    ; rotational constants of 1-dimensional active rotors of wells in cm-1
          Gosub parse
          well_1d_ar_sym.l(i_wells,n_well_1d_ar(i_wells)) = Val(parse$) ; 1D active rotor symmetry in wells
        EndIf
        If FindString(text$,"2d-rot symm",1)
          n_well_2d_ar.l(i_wells) = n_well_2d_ar(i_wells) + 1      ; number of active 2D-rotors in well
          n_well_active_dof.l(i_wells) = n_well_active_dof.l(i_wells) + 2
          If FindString(text$,"2d-rot symm",1)+10 < Len(text$) ; "2D-rot symm" is not at the end of line, i.e. values must be read after "2D-rot symm"
            text$ = Right(text$,Len(text$)-FindString(text$,"2d-rot symm",1)-10)
          EndIf
          Gosub parse
          well_2d_ar.d(i_wells,n_well_2d_ar(i_wells)) = ValD(parse$)    ; rotational constants of 2-dimensional active rotors of wells in cm-1
          Gosub parse
          well_2d_ar_sym.l(i_wells,n_well_2d_ar(i_wells)) = Val(parse$) ; 2D active rotor symmetry in wells
        EndIf
        If FindString(text$,"2d-hr symm v0",1) And hr2d_flag = 0
          hr2d_flag.l(i_wells) = 1           ; 2d hindered rotor present
          n_well_active_dof.l(i_wells) = n_well_active_dof.l(i_wells) + 2
          If FindString(text$,"2d-hr symm v0",1)+12 < Len(text$) ; "2d-rot symm" is not at the end of line, i.e. values must be read after "2d-rot symm"
            text$ = Right(text$,Len(text$)-FindString(text$,"2d-hr symm v0",1)-12)
          EndIf
          Gosub parse
          hr2d_b.d(i_wells) = ValD(parse$)              ; 2d hindered rotor rotational constant in cm-1
          Gosub parse
          hr2d_sym.l(i_wells) = Val(parse$)            ; 2d hindered rotor symmetry
          Gosub parse
          hr2d_V0.d(i_wells) = ValD(parse$)             ; 2d hindered rotor potential depth in cm-1
        EndIf
        ; new in vs. 2.7 - arbitrary quantum state models
        If FindString(text$,"pib1d mass a",1) ; 1D particle in a box
          n_well_aqsm(i_wells) = n_well_aqsm(i_wells) + 1 ; number of arbitrary quantum state models in well
          daqsm_well(i_wells,n_well_aqsm(i_wells)) = 1    ; dimensionality for 1D particle in a box
          n_well_active_dof.l(i_wells) = n_well_active_dof.l(i_wells) + 1
          If FindString(text$,"pib1d mass a",1)+11 < Len(text$) ; "PIB1D mass a" is not at the end of line, i.e. values must be read after "2D-rot symm"
            text$ = Right(text$,Len(text$)-FindString(text$,"pib1d mass a",1)-11)
          EndIf
          Gosub parse
          aqsm_mass.d = ValD(parse$)*amu ; mass of particle in kg
          Gosub parse
          pib_a.d = ValD(parse$)*1e-10 ; box length in Angstrom
          pib_gsa.d = h_planck*h_planckSI/(8*aqsm_mass*pib_a*pib_a) ; ground state energy of 1D PIB
          zpe_aqsm_well(i_wells) = zpe_aqsm_well(i_wells)+pib_gsa   ; add ground state energy to zero-point correction
          n_piba.l = 0    ; initialize loop for quantum levels
          Repeat
            n_piba = n_piba+1
            pib_bin.l = pib_gsa*(n_piba*n_piba-1)/bs_quantum        ; energy of quantum state n_piba without zero-point energy
            If pib_bin <= maxbin
              aqsm_well(i_wells,n_well_aqsm(i_wells),pib_bin) = aqsm_well(i_wells,n_well_aqsm(i_wells),pib_bin) + 1 
            EndIf
          Until pib_bin > maxbin
        EndIf  
        If FindString(text$,"pib2d mass a b",1) ; 2D particle in a box
          n_well_aqsm(i_wells) = n_well_aqsm(i_wells) + 1 ; number of arbitrary quantum state models in well
          daqsm_well(i_wells,n_well_aqsm(i_wells)) = 2    ; dimensionality for 2D particle in a box
          n_well_active_dof.l(i_wells) = n_well_active_dof.l(i_wells) + 2
          If FindString(text$,"pib2d mass a b",1)+13 < Len(text$) ; "PIB1D mass a" is not at the end of line, i.e. values must be read after "2D-rot symm"
            text$ = Right(text$,Len(text$)-FindString(text$,"pib2d mass a b",1)-13)
          EndIf
          Gosub parse
          aqsm_mass.d = ValD(parse$)*amu ; mass of particle in kg
          Gosub parse
          pib_a.d = ValD(parse$)*1e-10 ; box length in Angstrom
          Gosub parse
          pib_b.d = ValD(parse$)*1e-10 ; box length in Angstrom
          pib_gsa.d = h_planck*h_planckSI/(8*aqsm_mass*pib_a*pib_a) ; ground state energy of 1D PIB dimension a
          pib_gsb.d = h_planck*h_planckSI/(8*aqsm_mass*pib_b*pib_b) ; ground state energy of 1D PIB dimension b
          zpe_aqsm_well(i_wells) = zpe_aqsm_well(i_wells)+pib_gsa+pib_gsb   ; add ground state energy to zero-point correction
          n_piba.l = 0      ; initialize loop for quantum levels
          Repeat
            n_piba = n_piba+1
            n_pibb.l = 0
            Repeat
              n_pibb = n_pibb+1
              pib_bin.l = (pib_gsa*(n_piba*n_piba-1)+pib_gsb*(n_pibb*n_pibb-1))/bs_quantum ; energy of quantum state n_piba, n_pibb without zero-point energy
              If pib_bin <= maxbin
                aqsm_well(i_wells,n_well_aqsm(i_wells),pib_bin) = aqsm_well(i_wells,n_well_aqsm(i_wells),pib_bin) + 1 
              EndIf
            Until pib_bin > maxbin
          Until n_pibb = 1
        EndIf  
        If FindString(text$,"pib3d mass a b c",1) ; 3D particle in a box
          n_well_aqsm(i_wells) = n_well_aqsm(i_wells) + 1 ; number of arbitrary quantum state models in well
          daqsm_well(i_wells,n_well_aqsm(i_wells)) = 3    ; dimensionality for 3D particle in a box
          n_well_active_dof.l(i_wells) = n_well_active_dof.l(i_wells) + 3
          If FindString(text$,"pib3d mass a b c",1)+15 < Len(text$) ; "pib3d mass a b c" is not at the end of line, i.e. values must be read after "pib3d mass a b c"
            text$ = Right(text$,Len(text$)-FindString(text$,"pib3d mass a b c",1)-15)
          EndIf
          Gosub parse
          aqsm_mass.d = ValD(parse$)*amu ; mass of particle in kg
          Gosub parse
          pib_a.d = ValD(parse$)*1e-10 ; box length in Angstrom
          Gosub parse
          pib_b.d = ValD(parse$)*1e-10 ; box length in Angstrom
          Gosub parse
          pib_c.d = ValD(parse$)*1e-10 ; box length in Angstrom
          pib_gsa.d = h_planck*h_planckSI/(8*aqsm_mass*pib_a*pib_a) ; ground state energy of 1D PIB dimension a
          pib_gsb.d = h_planck*h_planckSI/(8*aqsm_mass*pib_b*pib_b) ; ground state energy of 1D PIB dimension b
          pib_gsc.d = h_planck*h_planckSI/(8*aqsm_mass*pib_c*pib_c) ; ground state energy of 1D PIB dimension c
          zpe_aqsm_well(i_wells) = zpe_aqsm_well(i_wells)+pib_gsa+pib_gsb   ; add ground state energy to zero-point correction
          n_piba.l = 0
          Repeat
            n_piba = n_piba+1
            n_pibb.l = 0
            Repeat
              n_pibb = n_pibb+1
              n_pibc.l = 0
              Repeat
                n_pibc = n_pibc+1
                pib_bin.l = (pib_gsa*(n_piba*n_piba-1)+pib_gsb*(n_pibb*n_pibb-1)+pib_gsc*(n_pibc*n_pibc-1))/bs_quantum ; energy of quantum state n_piba, n_pibb, n_pibc without zero-point energy
                If pib_bin <= maxbin
                  aqsm_well(i_wells,n_well_aqsm(i_wells),pib_bin) = aqsm_well(i_wells,n_well_aqsm(i_wells),pib_bin) + 1 
                EndIf
              Until pib_bin > maxbin
            Until n_pibc = 1
          Until n_pibb = 1
        EndIf  
        ; end new section in vs. 2.7
        If FindString(text$,"energy",1)
          If FindString(text$,"energy",1)+5 < Len(text$) ; "energy" is not at the end of line, i.e. values must be read after "energy"
            text$ = Right(text$,Len(text$)-FindString(text$,"energy",1)-5)
          EndIf
          Gosub parse
          well_energy(i_wells) = well_energy(i_wells) + ValD(parse$)      ; summation used only in future version, when reactant fragments are allowed
        EndIf
        If FindString(text$,"offset",1)
          If FindString(text$,"offset",1)+5 < Len(text$) ; "offset" is not at the end of line, i.e. values must be read after "offset"
            text$ = Right(text$,Len(text$)-FindString(text$,"offset",1)-5)
          EndIf
          Gosub parse
          well_offset(i_wells) = ValD(parse$)
        EndIf
        If FindString(text$,"degeneracy",1)
          If FindString(text$,"degeneracy",1)+9 < Len(text$) ; "degeneracy" is not at the end of line, i.e. values must be read after "degeneracy"
            text$ = Right(text$,Len(text$)-FindString(text$,"degeneracy",1)-9)
          EndIf
          Gosub parse
          well_degeneracy(i_wells) = Val(parse$)   ; summation used only in future version, when reactant fragments are allowed
        EndIf
        j = j + 1
        text$=Trunc(GetGadgetItemText(#Editor_0+k,j,0))
        If decimal_flag = 1
          text$=ReplaceString(text$,",",".")
        EndIf
      Wend
      If well_degeneracy(i_wells) = 0
        well_degeneracy(i_wells) = 1
      EndIf
      i_wells = i_wells + 1
    EndIf
  Next k
  
  ; read Well-Degeneracy-Vector from Parameter panel: (new in vs 3.58)
  For i_wells = 0 To n_wells-1
    well_degeneracy_vector(i_wells)=1
  Next i_wells  
  j = 0 
  text$=Trunc(GetGadgetItemText(#Editor_1,j,0))
  If decimal_flag = 1
    text$=ReplaceString(text$,",",".")
  EndIf
  While j<CountGadgetItems(#Editor_1) 
    If FindString(text$,"well-degeneracy-list",1)
      Repeat
        Gosub parse
      Until parse$ = "well-degeneracy-list:"  
      For i_wells = 0 To n_wells-1
        Gosub parse
        If parse$ = ""  ; new in vs 3.59
          MessageRequester("Warning", "The given Well-Degeneracy-List in the parameters panel seems to be shorter than the number of Wells. Please check carefully.")
          Break
        EndIf
        well_degeneracy_vector(i_wells) = ValD(parse$)
      Next i_wells
      Gosub parse
      If parse$:  ; new in vs 3.59
         MessageRequester("Warning", "The given Well-Degeneracy-List in the parameters panel seems to be longer than the number of Wells. Please check carefully.")
      EndIf
    EndIf
    If FindString(text$,"well-degeneracy-vector",1); this is for compatibility with vs. older than AWATAR1.0i
      Repeat
        Gosub parse
      Until parse$ = "well-degeneracy-vector:"  
      For i_wells = 0 To n_wells-1
        Gosub parse
        If parse$ = ""  ; new in vs 3.59
          MessageRequester("Warning", "The given Well-Degeneracy-Vector in the parameters panel seems to be shorter than the number of Wells. Please check carefully.")
          Break
        EndIf
        well_degeneracy_vector(i_wells) = ValD(parse$)
      Next i_wells
      Gosub parse
      If parse$:  ; new in vs 3.59
         MessageRequester("Warning", "The given Well-Degeneracy-Vector in the parameters panel seems to be longer than the number of Wells. Please check carefully.")
      EndIf
    EndIf 
    j = j + 1
    text$=Trunc(GetGadgetItemText(#Editor_1,j,0))
    If decimal_flag = 1
      text$=ReplaceString(text$,",",".")
    EndIf
  Wend 
  ;calculate well_degen_corr
  For i_wells = 0 To n_wells-1
    well_degen_corr(i_wells) = well_degeneracy(i_wells) * well_degeneracy_vector(i_wells)
  Next i_wells  
  
  ; calculate relative energies
  ; first add zero-point corrections and offset to absolute energies
  min_energy.d = 0
  For i_wells = 0 To n_wells-1
    well_offset(i_wells) = well_offset(i_wells) + zpe_aqsm_well(i_wells) ; add zero-point energy of arbitrary quantum state models - new in vs. 2.7
    For i = 1 To n_well_vmodes(i_wells)
      well_offset(i_wells) = well_offset(i_wells) + exact_well(i_wells,i)/2   ; add zero-point correction to offset
    Next i
    well_energy(i_wells) = well_energy(i_wells) + well_offset(i_wells)/conversion_ht_cm
    If min_energy > well_energy(i_wells)
      min_energy = well_energy(i_wells)
    EndIf
  Next i_wells
  For i_wells = 0 To n_wells-1
    well_relative(i_wells) = (well_energy(i_wells) - min_energy)*conversion_ht_cm
  Next i_wells
  max_modes_well.l = max_modes
  flag_donotpub.l = 0      ; new in vs. 2.7: make sure warning is carried over to Results section!
  flag_fewdegrees.l = 0   ; new in vs. AWATAR 1.0f
  For i_wells = 1 To n_wells-1
    If n_well_active_dof(0) <> n_well_active_dof(i_wells)
      MessageRequester("Warning","Number of degrees of freedom of well 0 is not consistent with well "+Str(i_wells)+"."+Chr(10)+"Results are NOT publishable!")
      flag_donotpub = 1  
    EndIf
  Next i_wells
  If n_well_active_dof.l(0) < 5 ;if number of active degrees of freedom in Well 0 (should be the same for other wells) is very small
     Ergebnis = MessageRequester("Error","WARNING: system has very few degrees of freedom. Results may not be meaningful. Use only after very critical evaluation. High value of BS-quantum might help.",#PB_MessageRequester_Ok )    
     flag_fewdegrees = 1
  EndIf ; new i vs. AWATAR1.0f
Return

;- Read TS Data from Panel
read_ts_data:
  Dim n_ts_vmodes.l(n_ts-1)    ; number of vibrational modes in ts
  Dim n_ts_1d_ar.l(n_ts-1)     ; number of active 1D-rotors in ts
  Dim n_ts_2d_ar.l(n_ts-1)     ; number of active 2D-rotors in ts
  Dim n_ts_aqsm.l(n_ts-1)      ; number of arbitrary quantum state models in ts - new in vs. 2.7  
  Dim ts_hr2d_flag.l(n_ts-1)           ; 2d hindered rotor present? no = 0, yes = 1
  Dim ts_hr2d_b.d(n_ts-1)              ; 2d hindered rotor rotational constant
  Dim ts_hr2d_sym.l(n_ts-1)            ; 2d hindered rotor symmetry
  Dim ts_hr2d_V0.d(n_ts-1)             ; 2d hindered rotor potential depth
  max_modes.l = 0             ; find maximum for Dim statements
  max_1d.l = 0                ; find maximum for Dim statements
  max_2d.l = 0                ; find maximum for Dim statements
  max_aqsm.l = 0              ; find maximum for Dim statements - new in vs. 2.7
  maxbin.l = total_en_max / bs_quantum   ; maximum bin number for aqsm - new in vs. 2.7
  ; count IR modes, active rotors and arbitrary quantum state models in each ts
  i_ts = 0
  For k = 2 To n_wells + n_ts + 1
    If Left(GetGadgetItemText(#Panel_0,k),2)="TS"
      j = 0
      text$=Trunc(GetGadgetItemText(#Editor_0+k,j,0))
      If decimal_flag = 1
        text$=ReplaceString(text$,",",".")
      EndIf
      While j<CountGadgetItems(#Editor_0+k)
        If FindString(text$,"vib",1)
          n_ts_vmodes(i_ts) = n_ts_vmodes(i_ts) + 1
        EndIf
        If FindString(text$,"1d-rot symm",1)
          n_ts_1d_ar.l(i_ts) = n_ts_1d_ar(i_ts) + 1      ; number of active 1D-rotors in ts
        EndIf
        If FindString(text$,"2d-rot symm",1)
          n_ts_2d_ar.l(i_ts) = n_ts_2d_ar(i_ts) + 1      ; number of active 2D-rotors in ts
        EndIf
        If FindString(text$,"2d-hr symm v0",1) And ts_hr2d_flag = 0
          ts_hr2d_flag.l(i_ts) = 1           ; 2d hindered rotor present
        EndIf
        If FindString(text$,"pib1d mass a",1) Or FindString(text$,"pib2d mass a b",1) Or FindString(text$,"pib3d mass a b c",1)
          n_ts_aqsm.l(i_ts) = n_ts_aqsm(i_ts) + 1      ; number of arbitrary quantum state models in ts
        EndIf
        j = j + 1
        text$=Trunc(GetGadgetItemText(#Editor_0+k,j,0))
        If decimal_flag = 1
          text$=ReplaceString(text$,",",".")
        EndIf
      Wend
      If max_modes < n_ts_vmodes(i_ts)
        max_modes = n_ts_vmodes(i_ts)
      EndIf
      If max_1d < n_ts_1d_ar(i_ts)
        max_1d = n_ts_1d_ar(i_ts)
      EndIf
      If max_2d < n_ts_2d_ar(i_ts)
        max_2d = n_ts_2d_ar(i_ts)
      EndIf
      If max_aqsm < n_ts_aqsm(i_ts) ; new in vs. 2.7
        max_aqsm = n_ts_aqsm(i_ts)
      EndIf
      i_ts = i_ts + 1
    EndIf
  Next k
  ; Now read all data
  Dim ts_frequency.l(n_ts-1,max_modes)   ; IR frequencies of transition states in units of bs_quantum
  Dim exact_ts.d(n_ts-1,max_modes)       ; exact frequencies in cm-1
  Dim ts_1d_ar.d(n_ts-1,max_1d)       ; rotational constants of 1-dimensional active rotors of transition states in cm-1
  Dim ts_1d_ar_sym.l(n_ts-1,max_1d)   ; 1D active rotor symmetry in transition states
  Dim ts_2d_ar.d(n_ts-1,max_2d)       ; rotational constants of 2-dimensional active rotors of transition states in cm-1
  Dim ts_2d_ar_sym.l(n_ts-1,max_2d)   ; 2D active rotor symmetry in transition states
  Dim n_ts_vmodes.l(n_ts-1)    ; number of vibrational modes in ts
  Dim n_ts_1d_ar.l(n_ts-1)     ; number of active 1D-rotors in ts
  Dim n_ts_2d_ar.l(n_ts-1)     ; number of active 2D-rotors in ts
  Dim ts_hr2d_flag.l(n_ts-1)           ; 2d hindered rotor present? no = 0, yes = 1
  Dim ts_hr2d_b.d(n_ts-1)              ; 2d hindered rotor rotational constant
  Dim ts_hr2d_sym.l(n_ts-1)            ; 2d hindered rotor symmetry
  Dim ts_hr2d_V0.d(n_ts-1)             ; 2d hindered rotor potential depth
  Dim ts_energy.d(n_ts-1)      ; absolute energy of ts in Hartrees
  Dim ts_offset.d(n_ts-1)      ; user-defined offset energy of ts in cm-1
  Dim ts_relative.d(n_ts-1)    ; relative energy of ts above minimum in cm-1
  Dim ts_degeneracy.l(n_ts-1)  ; degeneracy of TS (electronic & reaction path)
  Dim ts_degeneracy_vector.d(n_ts-1) ; TS-Degeneracy-Vector given in Parameter panel, the degeneracy of each TS is multiplied with the corresponding entry in the vector. New in vs 3.58 
  Dim loose_ts_factor.d(n_ts-1)  ; factor to increase degeneracy of TS for simulation of loose/tight transition states - new in vs 3.02
  Dim ts_degen_corr.d(n_ts-1)    ; = ts_degeneracy * ts_degeneracy_vector * loose_ts_factor - new in vs 3.02, adapted in vs 3.58
  ; start new definitions in vs. 2.7
  Dim n_ts_aqsm.l(n_ts-1)      ; number of arbitrary quantum state models in well
  Dim aqsm_ts.l(n_ts-1,max_aqsm,maxbin)      ; arbitrary quantum state model ts: aqsm_ts.l(i,j,k): number of states within bin k of aqsm j in ts i
  Dim daqsm_ts.l(n_ts-1,max_aqsm)            ; dimensionality of arbitrary quantum state model in ts 
  Dim zpe_aqsm_ts.d(n_ts-1)                  ; sum of zero-point energies of arbitrary quantum state model for one well
  Dim n_ts_active_dof.l(n_ts-1)        ; active degrees of freedom in TS 
; end new definitions in vs. 2.7
  
; read TS-Degeneracy-Vector from Parameter panel: (new in vs 3.58)
  For i_ts = 0 To n_ts-1
    ts_degeneracy_vector(i_ts)=1
  Next i_ts  
  j = 0 
  text$=Trunc(GetGadgetItemText(#Editor_1,j,0))
  If decimal_flag = 1
    text$=ReplaceString(text$,",",".")
  EndIf
  While j<CountGadgetItems(#Editor_1)
    If FindString(text$,"ts-degeneracy-list",1)
      Repeat
        Gosub parse
      Until parse$ = "ts-degeneracy-list:"  
      For i_ts = 0 To n_ts-1
          Gosub parse
          If parse$ = ""  ; new in vs 3.59
            MessageRequester("Warning", "The given TS-Degeneracy-List in the parameters panel seems to be shorter than the number of TSs. Please check carefully.")
            Break
          EndIf
          ts_degeneracy_vector(i_ts) = ValD(parse$)
       Next i_ts
       Gosub parse
       If parse$:  ; new in vs 3.59
         MessageRequester("Warning", "The given TS-Degeneracy-List in the parameters panel seems to be longer than the number of TSs. Please check carefully.")
       EndIf
    EndIf
    If FindString(text$,"ts-degeneracy-vector",1) ; This is for compatibility with versions older than AWATAR1.0i
      Repeat
        Gosub parse
      Until parse$ = "ts-degeneracy-vector:"  
      For i_ts = 0 To n_ts-1
          Gosub parse
          If parse$ = ""  ; new in vs 3.59
            MessageRequester("Warning", "The given TS-Degeneracy-Vector in the parameters panel seems to be shorter than the number of Wells. Please check carefully.")
            Break
          EndIf
          ts_degeneracy_vector(i_ts) = ValD(parse$)
       Next i_ts
       Gosub parse
       If parse$:  ; new in vs 3.59
         MessageRequester("Warning", "The given TS-Degeneracy-Vector in the parameters panel seems to be longer than the number of TSs. Please check carefully.")
       EndIf
    EndIf 
    j = j + 1
    text$=Trunc(GetGadgetItemText(#Editor_1,j,0))
    If decimal_flag = 1
      text$=ReplaceString(text$,",",".")
    EndIf
  Wend  
  
; read loose_ts_factor from Parameter panel: (new in vs 3.02)
  For i_ts = 0 To n_ts-1
    loose_ts_factor(i_ts)=1
  Next i_ts
  j = 0
  deg_factor.d = 1
  text$=Trunc(GetGadgetItemText(#Editor_1,j,0))
  If decimal_flag = 1
    text$=ReplaceString(text$,",",".")
  EndIf
  While j<CountGadgetItems(#Editor_1)
    If FindString(text$,"increase degeneracy of",1)
      Repeat  ;read degeneracy-factor
        Gosub parse
      Until parse$ = "factor:"
      Gosub parse
      deg_factor.d = ValD(parse$)
      text$=Trunc(GetGadgetItemText(#Editor_1,j,0))
      If decimal_flag = 1
        text$=ReplaceString(text$,",",".")
      EndIf
      Repeat  ;read for which TS the degeneracy-factor applies
        Gosub parse
      Until parse$ = "ts"
      Gosub parse
      If Val(parse$) <= n_ts-1
        loose_ts_factor(Val(parse$)) = loose_ts_factor(Val(parse$)) * deg_factor
      EndIf  
      Gosub parse
      While parse$ = "ts"
        Gosub parse
        If Val(parse$) <= n_ts-1
          loose_ts_factor(Val(parse$)) = loose_ts_factor(Val(parse$)) * deg_factor
        EndIf
        Gosub parse
      Wend
    EndIf
    j = j + 1
    text$=Trunc(GetGadgetItemText(#Editor_1,j,0))
    If decimal_flag = 1
      text$=ReplaceString(text$,",",".")
    EndIf
  Wend
  
  i_ts = 0
  For k = 2 To n_wells + n_ts + 1
    If Left(GetGadgetItemText(#Panel_0,k),2)="TS"
      j = 0
      text$=Trunc(GetGadgetItemText(#Editor_0+k,j,0))
      If decimal_flag = 1
        text$=ReplaceString(text$,",",".")
      EndIf
      While j<CountGadgetItems(#Editor_0+k)
        If FindString(text$,"vib",1)
          n_ts_vmodes.l(i_ts) = n_ts_vmodes(i_ts) + 1
          n_ts_active_dof(i_ts) = n_ts_active_dof(i_ts) + 1
          If FindString(text$,"vib",1)+2 < Len(text$) ; "vib" is not at the end of line, i.e. values must be read after "vib"
            text$ = Right(text$,Len(text$)-FindString(text$,"vib",1)-2)
          EndIf
          Gosub parse
          exact_ts(i_ts,n_ts_vmodes(i_ts))=ValD(parse$)
          ; sort newly read vibrational mode in correct place, array must be sorted with increasing energies for Beyer-Swinehart
          If n_ts_vmodes(i_ts) > 1
            i = n_ts_vmodes(i_ts)
            While exact_ts(i_ts,i)<exact_ts(i_ts,i-1) And i>1
              dummy.d = exact_ts(i_ts,i)
              exact_ts(i_ts,i) = exact_ts(i_ts,i-1)
              exact_ts(i_ts,i-1) = dummy
              i=i-1
            Wend
          EndIf
        EndIf
        If FindString(text$,"1d-rot symm",1)
          n_ts_1d_ar.l(i_ts) = n_ts_1d_ar(i_ts) + 1      ; number of active 1D-rotors in ts
          n_ts_active_dof(i_ts) = n_ts_active_dof(i_ts) + 1
          If FindString(text$,"1d-rot symm",1)+10 < Len(text$) ; "1D-rot symm" is not at the end of line, i.e. values must be read after "1D-rot symm"
            text$ = Right(text$,Len(text$)-FindString(text$,"1d-rot symm",1)-10)
          EndIf
          Gosub parse
          ts_1d_ar.d(i_ts,n_ts_1d_ar(i_ts)) = ValD(parse$)    ; rotational constants of 1-dimensional active rotors of transition states in cm-1
          Gosub parse
          ts_1d_ar_sym.l(i_ts,n_ts_1d_ar(i_ts)) = Val(parse$) ; 1D active rotor symmetry in transition states
        EndIf
        If FindString(text$,"2d-rot symm",1)
          n_ts_2d_ar.l(i_ts) = n_ts_2d_ar(i_ts) + 1      ; number of active 2D-rotors in ts
          n_ts_active_dof(i_ts) = n_ts_active_dof(i_ts) + 2
          If FindString(text$,"2d-rot symm",1)+10 < Len(text$) ; "2D-rot symm" is not at the end of line, i.e. values must be read after "2D-rot symm"
            text$ = Right(text$,Len(text$)-FindString(text$,"2d-rot symm",1)-10)
          EndIf
          Gosub parse
          ts_2d_ar.d(i_ts,n_ts_2d_ar(i_ts)) = ValD(parse$)    ; rotational constants of 2-dimensional active rotors of transition states in cm-1
          Gosub parse
          ts_2d_ar_sym.l(i_ts,n_ts_2d_ar(i_ts)) = Val(parse$) ; 2D active rotor symmetry in transition states
        EndIf
        If FindString(text$,"2d-hr symm v0",1) And ts_hr2d_flag = 0
          ts_hr2d_flag.l(i_ts) = 1           ; 2d hindered rotor present
          n_ts_active_dof(i_ts) = n_ts_active_dof(i_ts) + 2
          If FindString(text$,"2d-hr symm v0",1)+12 < Len(text$) ; "2d-rot symm" is not at the end of line, i.e. values must be read after "2d-rot symm"
            text$ = Right(text$,Len(text$)-FindString(text$,"2d-hr symm v0",1)-12)
          EndIf
          Gosub parse
          ts_hr2d_b.d(i_ts) = ValD(parse$)              ; 2d hindered rotor rotational constant in cm-1
          Gosub parse
          ts_hr2d_sym.l(i_ts) = Val(parse$)            ; 2d hindered rotor symmetry
          Gosub parse
          ts_hr2d_V0.d(i_ts) = ValD(parse$)             ; 2d hindered rotor potential depth in cm-1
        EndIf
        ; new in vs. 2.7 - arbitrary quantum state models
        If FindString(text$,"pib1d mass a",1) ; 1D particle in a box
          n_ts_aqsm(i_ts) = n_ts_aqsm(i_ts) + 1 ; number of arbitrary quantum state models in ts
          daqsm_ts(i_ts,n_ts_aqsm(i_ts)) = 1    ; dimensionality for 1D particle in a box
          n_ts_active_dof(i_ts) = n_ts_active_dof(i_ts) + 1
          If FindString(text$,"pib1d mass a",1)+11 < Len(text$) ; "PIB1D mass a" is not at the end of line, i.e. values must be read after "2D-rot symm"
            text$ = Right(text$,Len(text$)-FindString(text$,"pib1d mass a",1)-11)
          EndIf
          Gosub parse
          aqsm_mass.d = ValD(parse$)*amu ; mass of particle in kg
          Gosub parse
          pib_a.d = ValD(parse$)*1e-10 ; box length in Angstrom
          pib_gsa.d = h_planck*h_planckSI/(8*aqsm_mass*pib_a*pib_a) ; ground state energy of 1D PIB
          zpe_aqsm_ts(i_ts) = zpe_aqsm_ts(i_ts)+pib_gsa   ; add ground state energy to zero-point correction
          n_piba.l = 0    ; initialize loop for quantum levels
          Repeat
            n_piba = n_piba+1
            pib_bin.l = pib_gsa*(n_piba*n_piba-1)/bs_quantum        ; energy of quantum state n_piba without zero-point energy
            If pib_bin <= maxbin
              aqsm_ts(i_ts,n_ts_aqsm(i_ts),pib_bin) = aqsm_ts(i_ts,n_ts_aqsm(i_ts),pib_bin) + 1 
            EndIf
          Until pib_bin > maxbin
        EndIf  
        If FindString(text$,"pib2d mass a b",1) ; 2D particle in a box
          n_ts_aqsm(i_ts) = n_ts_aqsm(i_ts) + 1 ; number of arbitrary quantum state models in ts
          daqsm_ts(i_ts,n_ts_aqsm(i_ts)) = 2    ; dimensionality for 2D particle in a box
          n_ts_active_dof(i_ts) = n_ts_active_dof(i_ts) + 2
          If FindString(text$,"pib2d mass a b",1)+13 < Len(text$) ; "PIB1D mass a" is not at the end of line, i.e. values must be read after "2D-rot symm"
            text$ = Right(text$,Len(text$)-FindString(text$,"pib2d mass a b",1)-13)
          EndIf
          Gosub parse
          aqsm_mass.d = ValD(parse$)*amu ; mass of particle in kg
          Gosub parse
          pib_a.d = ValD(parse$)*1e-10 ; box length in Angstrom
          Gosub parse
          pib_b.d = ValD(parse$)*1e-10 ; box length in Angstrom
          pib_gsa.d = h_planck*h_planckSI/(8*aqsm_mass*pib_a*pib_a) ; ground state energy of 1D PIB dimension a
          pib_gsb.d = h_planck*h_planckSI/(8*aqsm_mass*pib_b*pib_b) ; ground state energy of 1D PIB dimension b
          zpe_aqsm_ts(i_ts) = zpe_aqsm_ts(i_ts)+pib_gsa+pib_gsb   ; add ground state energy to zero-point correction
          n_piba.l = 0      ; initialize loop for quantum levels
          Repeat
            n_piba = n_piba+1
            n_pibb.l = 0
            Repeat
              n_pibb = n_pibb+1
              pib_bin.l = (pib_gsa*(n_piba*n_piba-1)+pib_gsb*(n_pibb*n_pibb-1))/bs_quantum ; energy of quantum state n_piba, n_pibb without zero-point energy
              If pib_bin <= maxbin
                aqsm_ts(i_ts,n_ts_aqsm(i_ts),pib_bin) = aqsm_ts(i_ts,n_ts_aqsm(i_ts),pib_bin) + 1 
              EndIf
            Until pib_bin > maxbin
          Until n_pibb = 1
        EndIf  
        If FindString(text$,"pib3d mass a b c",1) ; 3D particle in a box
          n_ts_aqsm(i_ts) = n_ts_aqsm(i_ts) + 1 ; number of arbitrary quantum state models in ts
          daqsm_ts(i_ts,n_ts_aqsm(i_ts)) = 3    ; dimensionality for 3D particle in a box
          n_ts_active_dof(i_ts) = n_ts_active_dof(i_ts) + 3
          If FindString(text$,"pib3d mass a b c",1)+15 < Len(text$) ; "pib3d mass a b c" is not at the end of line, i.e. values must be read after "pib3d mass a b c"
            text$ = Right(text$,Len(text$)-FindString(text$,"pib3d mass a b c",1)-15)
          EndIf
          Gosub parse
          aqsm_mass.d = ValD(parse$)*amu ; mass of particle in kg
          Gosub parse
          pib_a.d = ValD(parse$)*1e-10 ; box length in Angstrom
          Gosub parse
          pib_b.d = ValD(parse$)*1e-10 ; box length in Angstrom
          Gosub parse
          pib_c.d = ValD(parse$)*1e-10 ; box length in Angstrom
          pib_gsa.d = h_planck*h_planckSI/(8*aqsm_mass*pib_a*pib_a) ; ground state energy of 1D PIB dimension a
          pib_gsb.d = h_planck*h_planckSI/(8*aqsm_mass*pib_b*pib_b) ; ground state energy of 1D PIB dimension b
          pib_gsc.d = h_planck*h_planckSI/(8*aqsm_mass*pib_c*pib_c) ; ground state energy of 1D PIB dimension c
          zpe_aqsm_ts(i_ts) = zpe_aqsm_ts(i_ts)+pib_gsa+pib_gsb+pib_gsc   ; add ground state energy to zero-point correction
          n_piba.l = 0
          Repeat
            n_piba = n_piba+1
            n_pibb.l = 0
            Repeat
              n_pibb = n_pibb+1
              n_pibc.l = 0
              Repeat
                n_pibc = n_pibc+1
                pib_bin.l = (pib_gsa*(n_piba*n_piba-1)+pib_gsb*(n_pibb*n_pibb-1)+pib_gsc*(n_pibc*n_pibc-1))/bs_quantum ; energy of quantum state n_piba, n_pibb, n_pibc without zero-point energy
                If pib_bin <= maxbin
                  aqsm_ts(i_ts,n_ts_aqsm(i_ts),pib_bin) = aqsm_ts(i_ts,n_ts_aqsm(i_ts),pib_bin) + 1 
                EndIf
              Until pib_bin > maxbin
            Until n_pibc = 1
          Until n_pibb = 1
        EndIf  
        ; end new section in vs. 2.7
        If FindString(text$,"energy",1)
          If FindString(text$,"energy",1)+5 < Len(text$) ; "energy" is not at the end of line, i.e. values must be read after "energy"
            text$ = Right(text$,Len(text$)-FindString(text$,"energy",1)-5)
          EndIf
          Gosub parse
          ts_energy(i_ts) = ts_energy(i_ts) + ValD(parse$)      ; summation used only in future version, when reactant fragments are allowed
        EndIf
        If FindString(text$,"offset",1)
          If FindString(text$,"offset",1)+5 < Len(text$) ; "offset" is not at the end of line, i.e. values must be read after "offset"
            text$ = Right(text$,Len(text$)-FindString(text$,"offset",1)-5)
          EndIf
          Gosub parse
          ts_offset(i_ts) = ValD(parse$)
        EndIf
        If FindString(text$,"degeneracy",1)
          If FindString(text$,"degeneracy",1)+9 < Len(text$) ; "degeneracy" is not at the end of line, i.e. values must be read after "degeneracy"
            text$ = Right(text$,Len(text$)-FindString(text$,"degeneracy",1)-9)
          EndIf
          Gosub parse
          ts_degeneracy(i_ts) = Val(parse$)      ; summation used only in future version, when reactant fragments are allowed
        EndIf
        j = j + 1
        text$=Trunc(GetGadgetItemText(#Editor_0+k,j,0))
        If decimal_flag = 1
          text$=ReplaceString(text$,",",".")
        EndIf
      Wend
      If ts_degeneracy(i_ts) = 0
        ts_degeneracy(i_ts) = 1
      EndIf
      ts_degen_corr(i_ts) = ts_degeneracy(i_ts) * ts_degeneracy_vector(i_ts) * loose_ts_factor(i_ts)    ; new in vs 3.02; adapted in vs 3.58
      i_ts = i_ts + 1
    EndIf
  Next k
  ; calculate relative energies
  ; first add zero-point corrections and offset to absolute energies
  For i_ts = 0 To n_ts-1
    ts_offset(i_ts) = ts_offset(i_ts) + zpe_aqsm_ts(i_ts) ; add zero-point energy of arbitrary quantum state models - new in vs. 2.7
    For i = 1 To n_ts_vmodes(i_ts)
      ts_offset(i_ts) = ts_offset(i_ts) + exact_ts(i_ts,i)/2   ; add zero-point correction to offset
    Next i
    ts_energy(i_ts) = ts_energy(i_ts) + ts_offset(i_ts)/conversion_ht_cm
  Next i_ts
  For i_ts = 0 To n_ts-1
    ts_relative(i_ts) = (ts_energy(i_ts) - min_energy)*conversion_ht_cm
  Next i_ts
  
  ;new in vs 3.10: Overwrite ts_relative with energy given in Parameter Panel
  j = 0
  ts_relative_new.d = 0
  text$=Trunc(GetGadgetItemText(#Editor_1,j,0))
  If decimal_flag = 1
    text$=ReplaceString(text$,",",".")
  EndIf
  While j<CountGadgetItems(#Editor_1)
    If FindString(text$,"absolute",1)
      Repeat  ;read the energy
        Gosub parse
      Until parse$ = "is:"
      Gosub parse
      ts_relative_new.d = ValD(parse$)
      text$=Trunc(GetGadgetItemText(#Editor_1,j,0))
      If decimal_flag = 1
        text$=ReplaceString(text$,",",".")
      EndIf
      Repeat  ;read for which TS the new energy applies
        Gosub parse
      Until parse$ = "ts"
      Gosub parse
      If Val(parse$) <= n_ts-1
       ts_relative(Val(parse$)) = ts_relative_new
      EndIf  
      Gosub parse
      While parse$ = "ts"
        Gosub parse
        If Val(parse$) <= n_ts-1
          ts_relative(Val(parse$)) = ts_relative_new
        EndIf  
        Gosub parse
      Wend
    EndIf
    j = j + 1
    text$=Trunc(GetGadgetItemText(#Editor_1,j,0))
    If decimal_flag = 1
      text$=ReplaceString(text$,",",".")
    EndIf
  Wend
  ; End new block of vs 3.10
  
  
  ; Add Offset defined in Parameter Panel to transition state(s); new in vs.35.6
  j = 0
  ts_offset_parameterwindow.d = 0
  text$=Trunc(GetGadgetItemText(#Editor_1,j,0))
  If decimal_flag = 1
    text$=ReplaceString(text$,",",".")
  EndIf
  While j<CountGadgetItems(#Editor_1)
    
    If FindString(text$,"offset to energy of all ts in cm-1:",1)
      Repeat  ;read degeneracy-factor
        Gosub parse
      Until parse$ = "cm-1:"
      Gosub parse
      ts_offset_parameterwindow.d = ValD(parse$)
      text$=Trunc(GetGadgetItemText(#Editor_1,j,0))
      If decimal_flag = 1
        text$=ReplaceString(text$,",",".")
      EndIf
      For i_ts = 0 To n_ts-1
        ts_relative(i_ts) = ts_relative(i_ts) + ts_offset_parameterwindow
      Next i_ts  
    EndIf
    
    If FindString(text$,"offset to energy of:",1)
      Repeat  ;read degeneracy-factor
        Gosub parse
      Until parse$ = "cm-1:"
      Gosub parse
      ts_offset_parameterwindow.d = ValD(parse$)
      text$=Trunc(GetGadgetItemText(#Editor_1,j,0))
      If decimal_flag = 1
        text$=ReplaceString(text$,",",".")
      EndIf
      Repeat  ;read for which TS the degeneracy-factor applies
        Gosub parse
      Until parse$ = "ts"
      Gosub parse
      If Val(parse$) <= n_ts-1
        ts_relative(Val(parse$)) = ts_relative(Val(parse$)) + ts_offset_parameterwindow
      EndIf  
      Gosub parse
      While parse$ = "ts"
        Gosub parse
        If Val(parse$) <= n_ts-1
          ts_relative(Val(parse$)) = ts_relative(Val(parse$)) + ts_offset_parameterwindow
        EndIf  
        Gosub parse
      Wend
    EndIf
    j = j + 1
    text$=Trunc(GetGadgetItemText(#Editor_1,j,0))
    If decimal_flag = 1
      text$=ReplaceString(text$,",",".")
    EndIf
    
  Wend
  ; End new block of vs 35.6
  
  flag_negativets.l = 0
  For i_ts = 0 To n_ts-1 ;prevents crashing if a TS is lower in energy than global minimum well, new in vs. AWATAR1.0e.
      If ts_relative(i_ts) < 0
        ts_relative(i_ts) = 0
        flag_negativets.l = 1
      EndIf  
  Next i_ts
  If flag_negativets.l = 1
    Ergebnis = MessageRequester("Error","Energy of al least one TS is lower than global minimum Well. Energy of those TS is now set to 0.",#PB_MessageRequester_Ok )
  EndIf
  
  For i_ts = 0 To n_ts-1
    If n_well_active_dof(0) <> n_ts_active_dof(i_ts) + 1
      MessageRequester("Warning","Number of degrees of freedom of well 0 is not consistent with TS "+Str(i_ts)+"."+Chr(10)+"Results are NOT publishable!")
      flag_donotpub = 1  
    EndIf
  Next i_ts
Return

;- Parse
; analyzes text$
; 1. Remove Spaces from left
; 2. Read 1st word or number
; 3. Cut read number from text$
parse:
  text$=LTrim(text$)
  If FindString(text$," ",1) > 0
    parse$=Left(text$,FindString(text$," ",1)-1)
    text$=Right(text$,Len(text$)-FindString(text$," ",1)+1)
  Else
    parse$=text$
    text$=""
  EndIf
Return

;- print DoS to results editor
print_dos:
  If n_wells=0
    Ergebnis = MessageRequester("Error","No reactant data available!",#PB_MessageRequester_Ok ) 
    StatusBarText(#StatusBar_0, 0, " Insufficient data for density of states calculations.")
  Else
    If DoNotClearResults_flag = 0
      ClearGadgetItems(#Editor_0)
    EndIf
    SetGadgetState(#Panel_0,0)
    AddGadgetItem(#Editor_0,-1,"")
    AddGadgetItem(#Editor_0,-1,"Density of States:")
    line$ = ""
    For i_wells = 0 To n_wells-1
      line$ = line$+LSet("Well_"+Str(i_wells),15)
    Next i_wells
    AddGadgetItem(#Editor_0,-1,"Total_Energy   "+line$)
    line$ = ""
    For i_wells = 0 To n_wells-1
      line$ = line$+LSet("(1/cm-1)",15)
    Next i_wells
    AddGadgetItem(#Editor_0,-1,"(cm-1)         "+line$)
    total_en.d=total_en_max.d
    bs_quantum.d=bs_quantum_start
    Gosub calculate_dos
    total_en.d = total_en_step.d
    If flag_donotpub = 1
      AddGadgetItem(#Editor_0,-1,"Number of active degrees of freedom is not consistent. DO NOT PUBLISH THESE RESULTS!!!")
    EndIf
    If flag_fewdegrees = 1 ;if number of active degrees of freedom in Well 0 (should be the same for other wells) is very small
     AddGadgetItem(#Editor_0,-1,"WARNING: system has very few degrees of freedom. Results may Not be meaningful. Use only after very critical evaluation. High value of BS-quantum might help.")
    EndIf ; new i vs. AWATAR1.0f
    Repeat
      line$=""
      line$=line$+LSet(StrD(total_en,2),15)
      For i_wells = 0 To n_wells-1
        If Int((total_en-well_relative(i_wells))/bs_quantum+0.5) > 0
          density_of_states.d = dos_well(i_wells,Int((total_en-well_relative(i_wells))/bs_quantum+0.5))
        Else
          density_of_states.d = 0
        EndIf
        line$=line$+LSet(science(density_of_states,4),15)
      Next i_wells
      If decimal_flag = 1
        line$=ReplaceString(line$,".",",")
      EndIf
      AddGadgetItem(#Editor_0,-1,line$)
      total_en.d = total_en + total_en_step
    Until total_en > total_en_max Or total_en_step <= 0
    If DoNotClearResults_flag = 0 ; this is the case,if button Calculate DoS was used ; notes energies and degeneracies in Results-panel. new in vs AWATAR1.0
       AddGadgetItem(#Editor_0,-1,"")
       AddGadgetItem(#Editor_0,-1,"Further Information:")
       AddGadgetItem(#Editor_0,-1,"")
       AddGadgetItem(#Editor_0,-1,"          Degeneracy:      Relative Energy:")
       For i_wells = 0 To n_wells-1
           AddGadgetItem(#Editor_0,-1,"Well " + StrF(i_wells) + ":      " + StrF(well_degen_corr(i_wells)) + "             " +  StrF(well_relative(i_wells),4) + " cm-1")
       Next i_wells  
    EndIf
  EndIf
Return

;- print Sum of States to results editor 
; new in vs 33.0
print_sos: ;First, the sos_ts is calculated
  If n_ts=0
    Ergebnis = MessageRequester("Error","No transition state data available!",#PB_MessageRequester_Ok ) 
    StatusBarText(#StatusBar_0, 0, " Insufficient data for sum of states calculations.")
  ElseIf n_wells=0 ;new in vs. AWATAR 1.0
    Ergebnis = MessageRequester("Error","No Well data available! The global minimum is needed as energy reference.",#PB_MessageRequester_Ok )
    StatusBarText(#StatusBar_0, 0, " Insufficient data for sum of states calculations.")  
  Else
    If DoNotClearResults_flag = 0
      ClearGadgetItems(#Editor_0)
    EndIf
    SetGadgetState(#Panel_0,0)
    Gosub read_meq_parameters   ; read energy spacing etc., not all parameters needed
    If total_en_max = 0
      total_en_max = 10000
    EndIf
    If total_en_step.d = 0
      total_en_step = 100
      total_en_start.d = 100
    EndIf
    If bs_quantum = 0
      bs_quantum = 1
    EndIf
    total_en.d = total_en_max
    Gosub read_well_data ; This line is only needed To set flag_donotpub = 0.
    Gosub calculate_sos ;this calculates sos_ts
    total_en = total_en_start
    ; Print sos_ts in the results panel:
    AddGadgetItem(#Editor_0,-1,"")
    AddGadgetItem(#Editor_0,-1,"Sum of States:")
    line$ = ""
    For i_ts = 0 To n_ts-1
      line$ = line$+LSet("TS_"+Str(i_ts),15)
    Next i_ts
    AddGadgetItem(#Editor_0,-1,"Total_Energy   "+line$)
    AddGadgetItem(#Editor_0,-1,"(cm-1)  ")
    If flag_donotpub = 1
      AddGadgetItem(#Editor_0,-1,"Number of active degrees of freedom is not consistent. DO NOT PUBLISH THESE RESULTS!!!")
    EndIf
    If flag_fewdegrees = 1 ;if number of active degrees of freedom in Well 0 (should be the same for other wells) is very small
     AddGadgetItem(#Editor_0,-1,"WARNING: system has very few degrees of freedom. Results may Not be meaningful. Use only after very critical evaluation. High value of BS-quantum might help.")
    EndIf ; new i vs. AWATAR1.0f
    Repeat
      line$=""
      line$=line$+LSet(StrD(total_en,2),15)
      For i_ts = 0 To n_ts-1
        If Int((total_en-ts_relative(i_ts))/bs_quantum+0.5) > 0
          sum_of_states.d = sos_ts(i_ts,Int((total_en-ts_relative(i_ts))/bs_quantum+0.5))
        Else
          sum_of_states.d = 0
        EndIf
        line$=line$+LSet(science(sum_of_states,4),15)
      Next i_ts
      If decimal_flag = 1
        line$=ReplaceString(line$,".",",")
      EndIf
      AddGadgetItem(#Editor_0,-1,line$)
      total_en.d = total_en + total_en_step
    Until total_en > total_en_max Or total_en_step <= 0
    If DoNotClearResults_flag = 0 ; this is the case, if button Calculate SoS was used ; new in vs AWATAR1.0
      AddGadgetItem(#Editor_0,-1,"")
      AddGadgetItem(#Editor_0,-1,"")
      AddGadgetItem(#Editor_0,-1,"Further Information:")
      Gosub print_energies_degeneracies  ;this adds the used energies and degeneracies to the results
    EndIf
  EndIf
Return

;- calculate Density of States
calculate_dos:      
  ; calls read well data, then calls bs_count_rovib_dos
  ; density of states is finally in dos_well(n_wells-1,int(total_en/bs_quantum+0,5))
  ; additional parameters: total_en.d, bs_quantum.d
  If n_wells=0
    Ergebnis = MessageRequester("Error","No reactant data available!",#PB_MessageRequester_Ok ) 
    StatusBarText(#StatusBar_0, 0, " Insufficient data for density of states calculations.")
  Else
    StatusBarText(#StatusBar_0, 0, " Density of states calculations started ...")
    ; Read reactant IR modes and active rotors from editor
    Gosub read_meq_parameters
    Gosub read_well_data
    total_en = total_en_max
    Dim dos_well.d(n_wells-1,Int(total_en/bs_quantum+0.5))  ; initialize
    Dim n_bs_well.l(n_wells-1)
    For i_wells = 0 To n_wells-1
      For j = 1 To n_well_vmodes(i_wells)
        well_frequency(i_wells,j) = Int(exact_well(i_wells,j)/bs_quantum+0.5) 
        If well_frequency(i_wells,j)<1      ; negative values possible if low-lying imaginary frequencies present - should be treated as internal rotations anyway!!!
          well_frequency(i_wells,j)=1
        EndIf
      Next j
      n_bs_well(i_wells) = Int((total_en-well_relative(i_wells))/bs_quantum+0.5)    ; excess energy above well in units of bs_quantum
      ; calculate density of states of reactant well
      ; prepare Beyer-Swinehart parameters
      If n_bs_well(i_wells) > 0
        Gosub bs_count_rovib_dos
      EndIf
    Next i_wells
    StatusBarText(#StatusBar_0, 0, " Density of states calculations finished.")
  EndIf
Return

;- calculate Sum of States
calculate_sos:      
  ; calls read ts data, then calls bs_count_rovib_sum_of_states
  ; sum of states is finally in sos_ts(n_ts-1,int(total_en/bs_quantum+0,5))
  ; additional parameters: total_en.d, bs_quantum.d
  If n_ts=0
    Ergebnis = MessageRequester("Error","No TS data available!",#PB_MessageRequester_Ok ) 
    StatusBarText(#StatusBar_0, 0, " Insufficient data for sum of states calculations.")
  Else
    StatusBarText(#StatusBar_0, 0, " Sum of states calculations started ...")
    ; Read TS IR modes and active rotors from editor
    Gosub read_ts_data 
    Dim sos_ts.d(n_ts-1,Int(total_en/bs_quantum+0.5))  ; initialize
    Dim n_bs_ts.l(n_ts-1)
    For i_ts = 0 To n_ts-1
      For j = 1 To n_ts_vmodes(i_ts)
        ts_frequency(i_ts,j) = Int(exact_ts(i_ts,j)/bs_quantum+0.5) 
        If ts_frequency(i_ts,j)<1      ; negative values possible if low-lying imaginary frequencies present - should be treated as internal rotations anyway!!!
          ts_frequency(i_ts,j)=1
        EndIf
      Next j
      n_bs_ts(i_ts) = Int((total_en-ts_relative(i_ts))/bs_quantum+0.5)    ; excess energy above TS in units of bs_quantum
      ; calculate sum of states of transition state
      ; prepare Beyer-Swinehart parameters
      If n_bs_ts(i_ts) > 0
        Gosub bs_count_rovib_sum_of_states
      EndIf
    Next i_ts
    StatusBarText(#StatusBar_0, 0, " Sum of states calculations finished.")
  EndIf
Return


;- bs_count_rovib_dos
; Beyer-Swinehart algorithm COUNT described in 
; Terry Beyer and D. F. Swinehart, Communications of the ACM, Vol. 16, No. 6, June 1973, p 379
; ordered k-tuple c corresponds to bs_frequency(i)
; Energy to be partitioned: N * bs_quantum
; parameter N corresponds to n_bs_well(i_wells)
;
; set parameters before calling bs_count:
; n_bs_well.l(i_wells)                      number of quanta to be partitioned over vibrational modes
; n_well_vmodes.l(i_wells)                   number of vibrational modes
; well_frequency.l(i_wells,0 ... k_bs)  vibrational frequencies in units of bs_quantum
;
; new in vs. 2.7: fold in arbitrary quantum state models, not part of original Beyer-Swinehart
;
; output of bs_count:
; array dos_well.d(n_bs_well) density of states
bs_count_rovib_dos:
  ; load rotational density of states into p_bs, following Gilbert/Smith (4.3.31)
  If n_well_1d_ar(i_wells) > 0 Or n_well_2d_ar(i_wells) > 0 Or hr2d_flag(i_wells) = 1
    gamma_prefactor.d = Pow(pi,n_well_1d_ar(i_wells)/2)/gamma(n_well_2d_ar(i_wells)+n_well_1d_ar(i_wells)/2+2*hr2d_flag(i_wells))
    For j_bs = 1 To n_well_1d_ar.l(i_wells)
      gamma_prefactor = gamma_prefactor/(well_1d_ar_sym(i_wells,j_bs)*Sqr(well_1d_ar(i_wells,j_bs)))
    Next j_bs
    For j_bs = 1 To n_well_2d_ar.l(i_wells)
      gamma_prefactor = gamma_prefactor/(well_2d_ar_sym(i_wells,j_bs)*well_2d_ar(i_wells,j_bs))
    Next j_bs
    If hr2d_flag(i_wells) = 1
      gamma_prefactor = gamma_prefactor/(hr2d_sym(i_wells)*hr2d_b(i_wells)*hr2d_V0(i_wells))
    EndIf
  Else
    gamma_prefactor.d = 0
    dos_well.d(i_wells,0) = 1 ; account for 0 cm-1 in rotations, so algorithm works also without active rotors
  EndIf
  If hr2d_flag(i_wells) = 0        ; no 2D hindered rotor, follow (4.3.31)
    For i_bs = 1 To n_bs_well(i_wells)
      dos_well(i_wells,i_bs) = gamma_prefactor*Pow(((i_bs)*bs_quantum),n_well_2d_ar(i_wells)+n_well_1d_ar(i_wells)/2-1)
    Next i_bs
  Else    ; 2D hindered rotor, follow (4.3.41)
    v0_bs.l = Int(hr2d_V0(i_wells)/bs_quantum)+1
    If n_bs_well(i_wells) > v0_bs
      For i_bs = 1 To v0_bs
        dos_well(i_wells,i_bs) = gamma_prefactor*Pow(((i_bs)*bs_quantum),n_well_2d_ar(i_wells)+n_well_1d_ar(i_wells)/2+1)
      Next i_bs
      For i_bs = v0_bs+1 To n_bs_well(i_wells)
        dos_well(i_wells,i_bs) = gamma_prefactor*(Pow(((i_bs)*bs_quantum),n_well_2d_ar(i_wells)+n_well_1d_ar(i_wells)/2+1)-Pow(((i_bs)*bs_quantum-hr2d_V0(i_wells)),n_well_2d_ar(i_wells)+n_well_1d_ar(i_wells)/2+1))
      Next i_bs
    Else
      For i_bs = 1 To n_bs_well(i_wells)
        dos_well(i_wells,i_bs) = gamma_prefactor*Pow(((i_bs)*bs_quantum),n_well_2d_ar(i_wells)+n_well_1d_ar(i_wells)/2+1)
      Next i_bs
    EndIf
  EndIf
  ; new in vs. 2.7: add arbitrary quantum state models
  For j_bs = 1 To n_well_aqsm(i_wells)
    Dim temp_dos.d(n_bs_well(i_wells))
    For k_bs = 0 To n_bs_well(i_wells)
      For i_bs = 0 To n_bs_well(i_wells)-k_bs
        temp_dos(k_bs+i_bs)=temp_dos(k_bs+i_bs)+aqsm_well(i_wells,j_bs,k_bs) * dos_well(i_wells,i_bs)
      Next i_bs
    Next k_bs    
    For i_bs = 0 To n_bs_well(i_wells)
      dos_well(i_wells,i_bs) = temp_dos(i_bs)
    Next i_bs
  Next j_bs
  ; end new section vs. 2.7
  ; now modified Beyer-Swinehart from Gilbert/Smith p. 157 starts
  For j_bs = 1 To n_well_vmodes(i_wells)
    If n_bs_well(i_wells) >= well_frequency(i_wells,j_bs)
      For i_bs = well_frequency(i_wells,j_bs) To n_bs_well(i_wells)
        dos_well(i_wells,i_bs) = dos_well(i_wells,i_bs) + dos_well(i_wells,i_bs-well_frequency(i_wells,j_bs))
      Next i_bs
    EndIf
  Next j_bs
  For i_bs = 0 To n_bs_well(i_wells)
    dos_well(i_wells,i_bs) = dos_well(i_wells,i_bs)*well_degen_corr(i_wells)
  Next i_bs
Return

;- bs_count_rovib_sum_of_states
; Beyer-Swinehart algorithm COUNT described in 
; Terry Beyer and D. F. Swinehart, Communications of the ACM, Vol. 16, No. 6, June 1973, p 379
; ordered k-tuple c corresponds to bs_frequency(i)
; Energy to be partitioned: N * bs_quantum
; parameter N corresponds to n_bs
;
; set parameters before calling bs_count:
; n_bs_ts.l(i_ts)           number of quanta to be partitioned over vibrational modes
; n_ts_vmodes.l(i_ts)       number of vibrational modes
; ts_frequency.l(i_ts,0 ... k_bs)  vibrational frequencies in units of bs_quantum
;
; output of bs_count:
; array sos_ts.d(n_bs_ts) sum of states
bs_count_rovib_sum_of_states:
  ; load rotational sum of states into sos_ts.d(), analytically integrate Gilbert/Smith (4.3.31)
  If n_ts_1d_ar(i_ts) > 0 Or n_ts_2d_ar(i_ts) > 0 Or ts_hr2d_flag(i_ts) = 1
    gamma_prefactor.d = Pow(pi,n_ts_1d_ar(i_ts)/2)/gamma(n_ts_2d_ar(i_ts)+n_ts_1d_ar(i_ts)/2+2*ts_hr2d_flag(i_ts))
    gamma_prefactor.d = gamma_prefactor/(n_ts_2d_ar(i_ts)+n_ts_1d_ar(i_ts)/2+2*ts_hr2d_flag(i_ts)) ; due to exponent of energy in integration
    For j_bs = 1 To n_ts_1d_ar.l(i_ts)
      gamma_prefactor = gamma_prefactor/(ts_1d_ar_sym(i_ts,j_bs)*Sqr(ts_1d_ar(i_ts,j_bs)))
    Next j_bs
    For j_bs = 1 To n_ts_2d_ar.l(i_ts)
      gamma_prefactor = gamma_prefactor/(ts_2d_ar_sym(i_ts,j_bs)*ts_2d_ar(i_ts,j_bs))
    Next j_bs
    If ts_hr2d_flag(i_ts) = 1
      gamma_prefactor = gamma_prefactor/(ts_hr2d_sym(i_ts)*ts_hr2d_b(i_ts)*ts_hr2d_V0(i_ts))
    EndIf
  Else
    gamma_prefactor.d = 0
  EndIf
  sos_ts.d(i_ts,0) = 1         ; account for 0 cm-1 in rotations, so algorithm works also without active rotors
  If ts_hr2d_flag(i_ts) = 0    ; no 2d hindered rotor
    For i_bs = 1 To n_bs_ts(i_ts)
      sos_ts(i_ts,i_bs) = gamma_prefactor*Pow(((i_bs)*bs_quantum),n_ts_2d_ar(i_ts)+n_ts_1d_ar(i_ts)/2)
    Next i_bs
  Else                  ;2D-hindered rotor present
    v0_bs.l = Int(ts_hr2d_V0(i_ts)/bs_quantum)+1
    If n_bs_ts(i_ts) > v0_bs
      For i_bs = 1 To v0_bs
        sos_ts(i_ts,i_bs) = gamma_prefactor*Pow(((i_bs)*bs_quantum),n_ts_2d_ar(i_ts)+n_ts_1d_ar(i_ts)/2+2)
      Next i_bs
      For i_bs = v0_bs+1 To n_bs_ts(i_ts)
        sos_ts(i_ts,i_bs) = gamma_prefactor*Pow(((i_bs)*bs_quantum),n_ts_2d_ar(i_ts)+n_ts_1d_ar(i_ts)/2+2)-gamma_prefactor*Pow(((i_bs)*bs_quantum-ts_hr2d_V0(i_ts)),n_ts_2d_ar(i_ts)+n_ts_1d_ar(i_ts)/2+2)
      Next i_bs
    Else
      For i_bs = 1 To n_bs_ts(i_ts)
        sos_ts(i_ts,i_bs) = gamma_prefactor*Pow(((i_bs)*bs_quantum),n_ts_2d_ar(i_ts)+n_ts_1d_ar(i_ts)/2+2)
      Next i_bs
    EndIf
  EndIf
  For i_bs = 1 To n_bs_ts(i_ts)
  ; for small rotational sums of states - very small systems and/or very small bs_quantum:
    If sos_ts(i_ts,i_bs) < 1
      sos_ts(i_ts,i_bs) = 1
    EndIf
  Next i_bs
  ; new in vs. 2.7: add arbitrary quantum state models
  For j_bs = 1 To n_ts_aqsm(i_ts)
    Dim temp_sos.d(n_bs_ts(i_ts))
    For k_bs = 0 To n_bs_ts(i_ts)
      For i_bs = 0 To n_bs_ts(i_ts)-k_bs
        temp_sos(k_bs+i_bs)=temp_sos(k_bs+i_bs)+aqsm_ts(i_ts,j_bs,k_bs) * sos_ts(i_ts,i_bs)
      Next i_bs
    Next k_bs    
    For i_bs = 0 To n_bs_ts(i_ts)
      sos_ts(i_ts,i_bs) = temp_sos(i_bs)
    Next i_bs
  Next j_bs
  ; end new section vs. 2.7
  ; now modified Beyer-Swinehart from Gilbert/Smith p. 157 starts
  For j_bs = 1 To n_ts_vmodes(i_ts)
    If n_bs_ts(i_ts) >= ts_frequency(i_ts,j_bs)
      For i_bs = ts_frequency(i_ts,j_bs) To n_bs_ts(i_ts)
        sos_ts(i_ts,i_bs) = sos_ts(i_ts,i_bs) + sos_ts(i_ts,i_bs-ts_frequency(i_ts,j_bs))
      Next i_bs
    EndIf
  Next j_bs
  For i_bs = 0 To n_bs_ts(i_ts)
    sos_ts(i_ts,i_bs) = sos_ts(i_ts,i_bs)*ts_degen_corr(i_ts)
  Next i_bs
Return

;- Print RRKM Rates k(E)
print_rates:
  Gosub read_channels
  Gosub read_isochan          ; new in vs 3.41
  Gosub read_meq_parameters   ; read energy spacing etc., not all parameters needed
  If total_en_max = 0
    total_en_max = 10000
  EndIf
  If total_en_step.d = 0
    total_en_step = 100
    total_en_start.d = 100
  EndIf
  If bs_quantum = 0
    bs_quantum = 1
  EndIf
  total_en.d = total_en_max
  Gosub calculate_dos         ; load all information and employ Beyer / Swinehart
  Gosub calculate_sos
  total_en = total_en_start
  If DoNotClearResults_flag = 0
      ClearGadgetItems(#Editor_0)
  EndIf
  SetGadgetState(#Panel_0,0)
  AddGadgetItem(#Editor_0,-1,"")
 ; AddGadgetItem(#Editor_0,-1,"Channels:              Well Energy:         TS Energy:           Activation Energy:")
  If flag_donotpub = 1
    AddGadgetItem(#Editor_0,-1,"Number of active degrees of freedom is not consistent. DO NOT PUBLISH THESE RESULTS!!!")
  EndIf
  If flag_fewdegrees = 1 ;if number of active degrees of freedom in Well 0 (should be the same for other wells) is very small
     AddGadgetItem(#Editor_0,-1,"WARNING: system has very few degrees of freedom. Results may Not be meaningful. Use only after very critical evaluation. High value of BS-quantum might help.")
  EndIf ; new i vs. AWATAR1.0f
  If n_well_active_dof.l(0) < 5 ;if number of active degrees of freedom in Well 0 (should be the same for other wells) is very small
     AddGadgetItem(#Editor_0,-1,"WARNING: system has very few degrees of freedom. Results may not be meaningful. Use only after very critical evaluation. High value of BS-quantum might help.")
     AddGadgetItem(#Editor_0,-1,"")   
  EndIf  
  For i_channels = 0 To n_channels-1
    If well_channel(i_channels) >= 0
      AddGadgetItem(#Editor_0,-1,"Channel "+Str(i_channels)+":        Well Energy:"+RSet(StrD(well_relative(well_channel(i_channels)),2),16)+" cm-1          TS Energy:"+RSet(StrD(ts_relative(ts_channel(i_channels)),2),16)+" cm-1         Activation Energy:"+RSet(StrD(ts_relative(ts_channel(i_channels))-well_relative(well_channel(i_channels)),2),16)+" cm-1")
    Else
      AddGadgetItem(#Editor_0,-1,"Channel "+Str(i_channels)+": AWATAR-channel") ;new in vs. AWATA1.0e, instead of writing "TS all" for the Energies
 ;     If ts_channel(i_channels) >= 0
 ;       AddGadgetItem(#Editor_0,-1,"Channel "+Str(i_channels)+":"+RSet("0,00",16)+" cm-1"+RSet(StrD(ts_relative(ts_channel(i_channels)),2),20)+" cm-1")
 ;     Else
 ;       AddGadgetItem(#Editor_0,-1,"Channel "+Str(i_channels)+":"+RSet("0,00",16)+" cm-1"+RSet("all TS",20)+" cm-1")
 ;     EndIf
    EndIf
    clip$=clip$+"Channel"+RSet(Str(i_channels),3,"-")+"    "
  Next i_channels
  If n_isochan > 0           ; new in vs 3.41
    AddGadgetItem(#Editor_0,-1,"")
    AddGadgetItem(#Editor_0,-1,"IsoChannels:           Well Energy:         TS Energy:           Activation Energy:")
    i_isoreact.l = 1
    For i_isochan = 0 To n_isochan-1 
      AddGadgetItem(#Editor_0,-1,"Isochan_"+Str(i_isochan)+"_fwd:"+RSet(StrD(well_relative(startwell_isoreact(i_isoreact)),2),16)+" cm-1"+RSet(StrD(ts_relative(ts_isoreact(i_isoreact)),2),16)+" cm-1"+RSet(StrD(ts_relative(ts_isoreact(i_isoreact))-well_relative(startwell_isoreact(i_isoreact)),2),16)+" cm-1")
      AddGadgetItem(#Editor_0,-1,"Isochan_"+Str(i_isochan)+"_bwd:"+RSet(StrD(well_relative(startwell_isoreact(i_isoreact+1)),2),16)+" cm-1"+RSet(StrD(ts_relative(ts_isoreact(i_isoreact+1)),2),16)+" cm-1"+RSet(StrD(ts_relative(ts_isoreact(i_isoreact+1))-well_relative(startwell_isoreact(i_isoreact+1)),2),16)+" cm-1")     
      i_isoreact = i_isoreact + 2
    Next i_isochan
  EndIf
  AddGadgetItem(#Editor_0,-1,"")
  AddGadgetItem(#Editor_0,-1,"RRKM Rate Constants:")
  line$ = ""
  For i_channels = 0 To n_channels-1
    line$ = line$+LSet("Channel_"+Str(i_channels),15)
  Next i_channels
  If n_isochan > 0            ; new in vs 3.41
    For i_isochan = 0 To n_isochan-1
     line$ = line$+LSet("Isochan_"+Str(i_isochan)+"_fwd",15)+LSet("Isochan_"+Str(i_isochan)+"_bwd",15) 
    Next i_isochan
  EndIf
  AddGadgetItem(#Editor_0,-1,"Total_Energy   "+line$)
  line$ = ""
  For i_channels = 0 To n_channels-1
    line$ = line$+LSet("(s-1)",15)
  Next i_channels
  AddGadgetItem(#Editor_0,-1,"(cm-1)         "+line$)
  If flag_donotpub = 1
    AddGadgetItem(#Editor_0,-1,"Number of active degrees of freedom is not consistent. DO NOT PUBLISH THESE RESULTS!!!")
  EndIf
  If flag_fewdegrees = 1 ;if number of active degrees of freedom in Well 0 (should be the same for other wells) is very small
     AddGadgetItem(#Editor_0,-1,"WARNING: system has very few degrees of freedom. Results may Not be meaningful. Use only after very critical evaluation. High value of BS-quantum might help.")
  EndIf ; new i vs. AWATAR1.0f
  Repeat
    line$=""
    line$=line$+LSet(StrD(total_en,2),15)
    For i_channels = 0 To n_channels-1
      If well_channel(i_channels) = -1 
        If ts_channel(i_channels) >= 0  ; obsolete option, cannot occur starting vs. 3.52
         If Int((total_en-ts_relative(ts_channel(i_channels)))/bs_quantum+0.5) > 0
            totaldos.d = 0
            For i_wells = 0 To n_wells-1
              totaldos = totaldos+dos_well(i_wells,Int(total_en/bs_quantum+0.5))
            Next i_wells
            rate.d = sos_ts(ts_channel(i_channels),Int((total_en-ts_relative(ts_channel(i_channels)))/bs_quantum+0.5))/(h_planck*totaldos)
          Else
            rate.d = 0
          EndIf
        Else
          If ts_channel(i_channels) = -1
            totaldos.d = 0
            For i_wells = 0 To n_wells-1
              totaldos = totaldos+dos_well(i_wells,Int(total_en/bs_quantum+0.5))
            Next i_wells
            totalsos.d = 0
            For i_ts = 0 To n_ts-1
              If Int((total_en-ts_relative(i_ts))/bs_quantum+0.5) > 0
                totalsos.d = totalsos.d + sos_ts(i_ts,Int((total_en-ts_relative(i_ts))/bs_quantum+0.5))
              EndIf
            Next i_ts
            rate.d = totalsos.d/(h_planck*totaldos)
          Else  ; ts_channel(i_channels) = -2 only option remaining, i.e. "Well all", list of TSs defined for parallel reactions
            totaldos.d = 0
            For i_wells = 0 To n_wells-1
              totaldos = totaldos+dos_well(i_wells,Int(total_en/bs_quantum+0.5))
            Next i_wells
            totalsos.d = 0
            For i_ts = 0 To n_ts_parallel(i_channels)-1
              If Int((total_en-ts_relative(ts_parallel(i_channels,i_ts)))/bs_quantum+0.5) > 0
                totalsos.d = totalsos.d + sos_ts(ts_parallel(i_channels,i_ts),Int((total_en-ts_relative(ts_parallel(i_channels,i_ts)))/bs_quantum+0.5))
              EndIf
            Next i_ts
            rate.d = totalsos.d/(h_planck*totaldos)
          EndIf
        EndIf
      Else
        If Int((total_en-well_relative(well_channel(i_channels)))/bs_quantum+0.5) > 0 And Int((total_en-ts_relative(ts_channel(i_channels)))/bs_quantum+0.5) > 0
          rate.d = sos_ts(ts_channel(i_channels),Int((total_en-ts_relative(ts_channel(i_channels)))/bs_quantum+0.5))/(h_planck*dos_well(well_channel(i_channels),Int((total_en-well_relative(well_channel(i_channels)))/bs_quantum+0.5)))
        Else
          rate.d = 0
        EndIf
      EndIf
      line$=line$+LSet(science(rate,4),15)
    Next i_channels
    For i_isoreact = 1 To n_isoreact ;If n_isoreact = 0 this For-loop is skipped           ; new in vs 3.41
      If Int((total_en-well_relative(startwell_isoreact(i_isoreact)))/bs_quantum+0.5) > 0 And Int((total_en-ts_relative(ts_isoreact(i_isoreact)))/bs_quantum+0.5) > 0
        k_iso.d = sos_ts(ts_isoreact(i_isoreact),Int((total_en-ts_relative(ts_isoreact(i_isoreact)))/bs_quantum+0.5))/(h_planck*dos_well(startwell_isoreact(i_isoreact),Int((total_en-well_relative(startwell_isoreact(i_isoreact)))/bs_quantum+0.5)))
      Else
        k_iso.d = 0
      EndIf  
      line$=line$+LSet(science(k_iso,4),15)
    Next i_isoreact   
    If decimal_flag = 1
      line$=ReplaceString(line$,".",",")
    EndIf
    AddGadgetItem(#Editor_0,-1,line$)
    total_en = total_en + total_en_step
  Until total_en > total_en_max Or total_en_step <= 0
  If DoNotClearResults_flag = 0 ; this is the case, if button Calculate RRKM rates was used ; new in vs AWATAR1.0
    AddGadgetItem(#Editor_0,-1,"")
    AddGadgetItem(#Editor_0,-1,"")
    AddGadgetItem(#Editor_0,-1,"Further Information:")
    Gosub print_energies_degeneracies  ;this adds the used energies and degeneracies to the results
  EndIf
Return

;- Read Reaction Channels
; read reaction channel information from Parameter Editor, format: "Channel w Well x TS y" or "Channel 0 Well all TS all" or "Channel 0 Well all TS a b c"
read_channels:
  n_channels = 0
  ; first count number of channels
  j = 0
  text$=Trunc(GetGadgetItemText(#Editor_1,j,0))
  If decimal_flag = 1
    text$=ReplaceString(text$,",",".")
  EndIf
  While j<CountGadgetItems(#Editor_1)
    If FindString(text$,"channel",1)
      n_channels = n_channels + 1
    EndIf
    j = j + 1
    text$=Trunc(GetGadgetItemText(#Editor_1,j,0))
    If decimal_flag = 1
      text$=ReplaceString(text$,",",".")
    EndIf
  Wend
  ; now read channels
  If n_channels > 0
    Dim well_channel.l(n_channels-1)           ; reactant well for channel
    Dim ts_channel.l(n_channels-1)             ; TS for channel
    Dim ts_parallel.l(n_channels-1,max_ts_parallel)        ; TSs for parallel reactions if ts_channel(x) = -2 and "Well all" for channel ; new in vs. 3.52
    Dim n_ts_parallel.l(n_channels-1)          ; number of TSs y in ts_parallel.l(x,y) for channel x
  EndIf
  j = 0
  i_channels.l = 0
  text$=Trunc(GetGadgetItemText(#Editor_1,j,0))
  If decimal_flag = 1
    text$=ReplaceString(text$,",",".")
  EndIf
  While j<CountGadgetItems(#Editor_1)
    If FindString(text$,"channel",1)
      Repeat
        Gosub parse ; read #well
      Until parse$ = "well"
      Gosub parse
      If parse$="all"
        well_channel(i_channels) = -1
        Gosub parse ; read "ts"
        Gosub parse ; read #TS
        If parse$="all"
          ts_channel(i_channels) = -1 ; all wells to all TSs, one product only
        Else
          ts_channel(i_channels) = -2 ; all wells, but parallel reactions, TSs for channel need be defined
          Repeat
            ts_parallel(i_channels,n_ts_parallel(i_channels)) = Val(parse$)  ; remember TSs used for parallel reaction channel
            n_ts_parallel(i_channels) = n_ts_parallel(i_channels)+1          ; count number of TSs in parallel reaction channel
            Gosub parse            
          Until parse$ = ""
        EndIf
      Else
        well_channel(i_channels) = Val(parse$)
        Gosub parse ; read "ts"
        Gosub parse ; read #TS
        ts_channel(i_channels) = Val(parse$)
      EndIf
      i_channels = i_channels + 1
    EndIf
    j = j + 1
    text$=Trunc(GetGadgetItemText(#Editor_1,j,0))
    If decimal_flag = 1
      text$=ReplaceString(text$,",",".")
    EndIf
  Wend
  Return
  
;- Read Isomerisation Channels
; new in vs 3.41
; read isomerisation channel information from Parameter Editor, format: "IsoChan w Well x TS y Well z"
read_isochan:
  n_isochan = 0
  ; first count number of isomerisation channels
  j = 0
  text$=Trunc(GetGadgetItemText(#Editor_1,j,0))
  If decimal_flag = 1
    text$=ReplaceString(text$,",",".")
  EndIf
  While j<CountGadgetItems(#Editor_1)
    If FindString(text$,"isochan",1)
      n_isochan = n_isochan + 1
    EndIf
    j = j + 1
    text$=Trunc(GetGadgetItemText(#Editor_1,j,0))
    If decimal_flag = 1
      text$=ReplaceString(text$,",",".")
    EndIf
  Wend
  n_isoreact = 2 * n_isochan ; For each isomerisation channel, there is forward and backward reaction
  ; now read isomerisation reactions
 If n_isochan > 0 
  Dim startwell_isoreact.l(n_isoreact)      ; reactant well for isomerisation reaction
  Dim ts_isoreact.l(n_isoreact)             ; TS for isomerisation reaction
  Dim endwell_isoreact.l(n_isoreact)        ; well to which the isomerisation reaction goes
  j = 0
  i_isoreact = 1 ; 0th index of the arrays is not used; makes programm easier, if no isochannels defined.
  text$=Trunc(GetGadgetItemText(#Editor_1,j,0))
  While j<CountGadgetItems(#Editor_1)
    If FindString(text$,"isochan",1)
      Repeat
        Gosub parse ; read first well of isochannel
      Until parse$ = "well"
      Gosub parse
      startwell_isoreact(i_isoreact) = Val(parse$) ;First well after Isochan is startwell for forward reaction
      endwell_isoreact(i_isoreact+1) = Val(parse$) ;First well after Isochan is endwell for backward reaction
      Gosub parse ; read TS of isochannel
      Gosub parse
      ts_isoreact(i_isoreact) = Val(parse$)        ;TS for forward reaction
      ts_isoreact(i_isoreact+1) = Val(parse$)      ;TS for backward reaction     
      Gosub parse ;read second well of isochannel
      Gosub parse
      endwell_isoreact(i_isoreact) = Val(parse$)     ;Second well is endwell for forward reaction
      startwell_isoreact(i_isoreact+1) = Val(parse$) ;Second well is startwell for backward reaction
      i_isoreact = i_isoreact + 2 ; go to next isomerisation channel
    EndIf   
    If FindString(text$,"free isomerisation criterion:",1) ;new in vs. 34.4
      Repeat
        Gosub parse
      Until parse$ = "criterion:"
      Gosub parse
      FreeExchange_Criterion.d = ValD(parse$)
    EndIf        
    j = j + 1
    text$=Trunc(GetGadgetItemText(#Editor_1,j,0))
  Wend
 EndIf 
Return  

;- read Master Equation Modeling Parameters
read_meq_parameters:
j = 0
  manual_temp_list_flag.l = 0 ;default Manual list for temperatures in loop is inactive
  Dim k_irmpd.d(n_wells-1)    ; default: no IRMPD; This sets all entries of the array to 0.
  nu_irmpd.d = 0   ; default: no IRMPD
  real_time_flag.l = 0 ; default: run MEM in convergence mode
  t_totsim.d = 1      ; default total simulation time for real time MEM
  point_export_interval.d = 0.01 ; default for real time MEM
  n_export.l = 10    ; default number of data points after which population is exportet in real time MEM
  temp_initial.d = 0               ; default for real time MEM
  uv_photon.d = 0                ; default for real time MEM
  text$=Trunc(GetGadgetItemText(#Editor_1,j,0))
  If decimal_flag = 1
    text$=ReplaceString(text$,",",".")
  EndIf
  While j<CountGadgetItems(#Editor_1)
    If FindString(text$,"the filename is:",1)
      Repeat
        Gosub parse
      Until parse$ = "is:"
      Filename$ = Trim(text$)
    EndIf
    If FindString(text$,"energy range of population in cm-1:",1)
      Repeat
        Gosub parse
      Until parse$ = "cm-1:"
      Gosub parse
      total_en_max.d = Val(parse$)
    EndIf
    If FindString(text$,"size of finite energy element in cm-1:",1) ; This is for compability with versions older than August 2025
      Repeat
        Gosub parse
      Until parse$ = "cm-1:"
      Gosub parse
      total_en_step.d = ValD(parse$)
      total_en_start.d = ValD(parse$)
    EndIf
    
    If FindString(text$,"bin size in cm-1:",1)
      Repeat
        Gosub parse
      Until parse$ = "cm-1:"
      Gosub parse
      total_en_step.d = ValD(parse$)
      total_en_start.d = ValD(parse$)
    EndIf
    
    If FindString(text$,"energy quantum for beyer/swinehart in cm-1:",1)
      Repeat
        Gosub parse
      Until parse$ = "cm-1:"
      Gosub parse
      bs_quantum.d = ValD(parse$)
    EndIf
    If FindString(text$,"start temperature in k:",1) ; This is for compatibility with versions older than August 2025
      Repeat
        Gosub parse
      Until parse$ = "k:"
      Gosub parse
      t_amb0.d = ValD(parse$)
    EndIf
    
    If FindString(text$,"loop starts with temperature in k:",1)
      Repeat
        Gosub parse
      Until parse$ = "k:"
      Gosub parse
      t_amb0.d = ValD(parse$)
    EndIf    
    
    If FindString(text$,"end temperature in k:",1) ; This is for compatibility with versions older than August 2025
      Repeat
        Gosub parse
      Until parse$ = "k:"
      Gosub parse
      t_amb1.d = ValD(parse$)
    EndIf
    
    If FindString(text$,"loop ends with temperature in k:",1)
      Repeat
        Gosub parse
      Until parse$ = "k:"
      Gosub parse
      t_amb1.d = ValD(parse$)
    EndIf    
    
    If FindString(text$,"number of temperatures in loop:",1)
      Repeat
        Gosub parse
      Until parse$ = "loop:"
      Gosub parse
      n_t_amb.l = Val(parse$)
    EndIf
    If FindString(text$,"manual list for temperatures in loop:",1) ; new in vs. 3.57
      manual_temp_list_flag.l = 1
      Dim t_manual_list.d(n_t_amb-1)
      Repeat
        Gosub parse
      Until parse$ = "loop:"
      For i = 0 To n_t_amb-1
      Gosub parse
      t_manual_list(i) = ValD(parse$)
      Next i
    EndIf  
    If FindString(text$,"roomtemperature in k:",1) ;without spacing imn Roomttemperature is for compatibility with vs before AWATAR1.0h
      Repeat
        Gosub parse
      Until parse$ = "k:"
      Gosub parse
      t_room.d = ValD(parse$)
    EndIf
    If FindString(text$,"room temperature in k:",1)  ;room temperature with spacing corrected in vs AWATAR1.0h This is for versions before August 2025
      Repeat
        Gosub parse
      Until parse$ = "k:"
      Gosub parse
      t_room.d = ValD(parse$)
    EndIf
    
    If FindString(text$,"temperature of icr cell window in k:",1)
      Repeat
        Gosub parse
      Until parse$ = "k:"
      Gosub parse
      t_room.d = ValD(parse$)
    EndIf
    
    If FindString(text$,"proportion on solid angle of icr cell window:",1) ;icr cell with spacing corrected in vs AWATAR1.0a
      Repeat
        Gosub parse
      Until parse$ = "window:"
      Gosub parse
      window_angle.d = ValD(parse$)
    EndIf
    If FindString(text$,"proportion on solid angle of icrcell window:",1) ;this icrcell without space is for compatibility with older versions 
      Repeat
        Gosub parse
      Until parse$ = "window:"
      Gosub parse
      window_angle.d = ValD(parse$)
    EndIf
    
    If FindString(text$,"rate of photon absorption in s-1:",1) ; This is for compatibility with versions before August 2025
      Repeat
        Gosub parse
      Until parse$ = "s-1:"
      Gosub parse
        For i = 0 To n_wells-1
          k_irmpd.d(i) = ValD(parse$)
        Next i 
    EndIf
    
    If FindString(text$,"rate of photon absorption for well",1)
      Repeat
        Gosub parse
      Until parse$ = "well"
      Gosub parse
      If parse$="all"  ; If "Rate of Photon absorption for Well all in s-1:" is used.
        Gosub parse
        Gosub parse
        Gosub parse
        For i = 0 To n_wells-1
          k_irmpd.d(i) = ValD(parse$)
        Next i  
      Else ; If "Rate of Photon absorption for Well 0 3 7 in s-1:" is used.
        Repeat
          Gosub parse
        Until parse$ = "s-1:"
          Gosub parse
          k_ir.d = Val(parse$) ;This is the rate of photon absorption
        text$=Trunc(GetGadgetItemText(#Editor_1,j,0)) ;Now read, for which wells it should apply.
        If decimal_flag = 1
          text$=ReplaceString(text$,",",".")
        EndIf  
        Repeat
          Gosub parse
        Until parse$ = "well"
        Repeat
          Gosub parse
          If parse$ = "in" Or Val(parse$) > n_wells-1
            ;Do nothing
          Else  
            k_irmpd(Val(parse$))= k_ir.d
          EndIf  
        Until parse$ = "in"   
      EndIf
    EndIf
    
    If FindString(text$,"irmpd photon energy in cm-1:",1)
      Repeat
        Gosub parse
      Until parse$ = "cm-1:"
      Gosub parse
      nu_irmpd.d = ValD(parse$)
    EndIf
    If FindString(text$,"scaling of ir intensities:",1)
      Repeat
        Gosub parse
      Until parse$ = "intensities:"
      Gosub parse
      int_scale.d = ValD(parse$)
    EndIf
    If FindString(text$,"finite time step at 300 k:",1) ; This is for compatibility with versions before August 2025
      Repeat
        Gosub parse
      Until parse$ = "k:"
      Gosub parse
      dt300k_1.d = ValD(parse$)
    EndIf
    
    If FindString(text$,"finite time step parameter:",1)
      Repeat
        Gosub parse
      Until parse$ = "parameter:"
      Gosub parse
      dt300k_1.d = ValD(parse$)
    EndIf
    
    If FindString(text$,"minimum time step at 300 k:",1)
      Repeat
        Gosub parse
      Until parse$ = "k:"
      Gosub parse
      min_fts.i = ValD(parse$)
    EndIf
    If FindString(text$,"convergence parameter:",1)
      Repeat
        Gosub parse
      Until parse$ = "parameter:"
      Gosub parse
      convergence_1.d = ValD(parse$)
    EndIf
    If FindString(text$,"minimum number of iterations:",1)
      Repeat
        Gosub parse
      Until parse$ = "iterations:"
      Gosub parse
      min_iter.d = ValD(parse$)
    EndIf   
    If FindString(text$,"run mem in real time (yes/no):",1)
      Repeat
        Gosub parse
      Until parse$ = "(yes/no):"
      Gosub parse
      If parse$ = "yes"
        real_time_flag.l = 1
      EndIf
    EndIf   
    If FindString(text$,"total simulation time in seconds:",1)
      Repeat
        Gosub parse
      Until parse$ = "seconds:"
      Gosub parse
      t_totsim.d = ValD(parse$)
    EndIf   
    If FindString(text$,"interval for data point export in seconds:",1)
      Repeat
        Gosub parse
      Until parse$ = "seconds:"
      Gosub parse
      point_export_interval.d = ValD(parse$)
    EndIf   
    If FindString(text$,"export population after n data points:",1)
      Repeat
        Gosub parse
      Until parse$ = "points:"
      Gosub parse
      n_export.l = Val(parse$)
    EndIf   
    If FindString(text$,"initial cluster temperature in k:",1)
      Repeat
        Gosub parse
      Until parse$ = "k:"
      Gosub parse
      temp_initial.d = ValD(parse$)
    EndIf   
    If FindString(text$,"photon energy at t = 0 in cm-1:",1)
      Repeat
        Gosub parse
      Until parse$ = "cm-1:"
      Gosub parse
      uv_photon.d = ValD(parse$)
    EndIf   
    
    j = j + 1
    text$=Trunc(GetGadgetItemText(#Editor_1,j,0))
    If decimal_flag = 1
      text$=ReplaceString(text$,",",".")
    EndIf
  Wend
Return
  
;- Read Well Groups
; new in vs 3.40
; Idea: Wells are assigned to groups. For MEM, isomerisation within a group is barrierless and driven by DoS. Isomerisation between groups is only allowed via a Transition State, defined in isomerisation channels.  
; read information about which well belongs to which group from Parameter Editor, format: "Group w: Well x, ..., Well z"
read_groups:
  n_groups = 1 ;If no groups or only group 0 are defined, the number of groups is 1
  Dim group.l(n_wells-1)
  j = 0
  text$=Trunc(GetGadgetItemText(#Editor_1,j,0))
  While j<CountGadgetItems(#Editor_1)
    If FindString(text$,"group",1)
      Gosub parse
      Gosub parse
      If ValD(parse$) > 0 ; group 0 is ignored (as all wells are already in group 0)
        Gosub parse
        While parse$ = "well"
          Gosub parse
          group(Val(parse$)) = n_groups ; fills the group array with the groupnumber of the respective well.
          Gosub parse
        Wend
        n_groups = n_groups + 1 ;counts all groups except for group 0, which is already counted in the beginning.
      EndIf  
    EndIf
    j = j + 1
    text$=Trunc(GetGadgetItemText(#Editor_1,j,0))
  Wend
Return 

;- Start Master equation modeling
start_master_equation_modeling:
  flag_population.l = 0           ; override potentially present population and restart with new Boltzmann
  Gosub master_equation_modeling
Return

;-Iterative Master Equation Modelling
Iterative_MEM:                  ; new in vs 3.0 improves convergence and timestep iteratively
  Iterative_MEM_flag = 1      ;calculation runned with iterative MEM if = 1 or with start/continue MEM if = 0
  NewBoltzmann = MessageRequester("Start Population", "Do you want to start Iterative MEM with a new Boltzmann distribution?" + Chr(10) + "(If you click no, a potentially present population is used as start population.)", #PB_MessageRequester_YesNoCancel) 
  If NewBoltzmann = #PB_MessageRequester_Yes           ;allows to start Iterative MEM with a new Boltzmann distribution -  new in vs 3.11
    flag_population.l = 0
  ElseIf NewBoltzmann = #PB_MessageRequester_Cancel
    Return
  EndIf  
  Gosub read_channels
  Gosub read_isochan           ; new in vs 3.41
  Gosub read_meq_parameters 
  Gosub read_groups
  Gosub master_equation_modeling_rate_calculation ;new in vs 3.01: calculate rates beforehand.
  CreateFile(0,Filename$+"_pop.txt")
  convergence.d = 0.001
  For variable_timestep = 4 To min_fts
    dt300k.d = Pow(10, -(variable_timestep))
    check_convergence = 0
    While check_convergence = 0
      Gosub master_equation_modeling_convergence
      If iteration < min_iter
        convergence = convergence/10
      Else
        check_convergence = 1
      EndIf
    Wend
    Gosub Automatic_Save_All ;new in vs AWATAR 1.0g, creates file filename.checkpoint.rrk
  Next variable_timestep
  DoNotClearResults_flag = 1
  AddGadgetItem(#Editor_0,-1,"")
  AddGadgetItem(#Editor_0,-1,"")
  AddGadgetItem(#Editor_0,-1,"")
  AddGadgetItem(#Editor_0,-1,"Further Information:")
  Gosub print_energies_degeneracies
  Gosub print_rates  
  Gosub print_dos
  Gosub print_sos
  Gosub print_diagnostics
  Gosub Automatic_Save_All ;new in vs AWATAR 1.0g, creates file filename.checkpoint.rrk
Return


;- Master equation modeling
master_equation_modeling:
  Iterative_MEM_flag = 0                    ;calculation runned with iterative MEM if = 1 or with start/continue MEM if = 0
  Gosub read_channels
  Gosub read_isochan           ; new in vs 3.41
  Gosub read_meq_parameters
  Gosub read_groups
  CreateFile(0,Filename$+"_pop.txt")
  convergence.d = convergence_1
  dt300k.d = dt300k_1  
  Gosub master_equation_modeling_rate_calculation
  If real_time_flag = 1
    Gosub master_equation_modeling_real_time
  Else
    Gosub master_equation_modeling_convergence
  EndIf
  DoNotClearResults_flag = 1
  AddGadgetItem(#Editor_0,-1,"")
  AddGadgetItem(#Editor_0,-1,"")
  AddGadgetItem(#Editor_0,-1,"")
  AddGadgetItem(#Editor_0,-1,"Further Information:")
  Gosub print_energies_degeneracies
  Gosub print_rates  
  Gosub print_dos
  Gosub print_sos
  Gosub print_diagnostics
Return
  
;- Master equation modeling rate calculation
master_equation_modeling_rate_calculation:  
  n_fee.l = Int(total_en_max/total_en_step+0.5)     ; number of finite energy intervals
  Dim rate.d(n_channels-1,n_fee)        ; this rate already includes degeneracies, but changed relative to vs. 2.30 and earlier: individual RRKM rate in well only!
;  Dim total_rate.d(n_fee)               ; Martin 24.10.2023: looks totally useless and senseless
  Dim total_dos.d(n_groups-1,n_fee) ; Dimension added in vs 3.40 total_dos is now calculated for each group seperately
  Dim total_dos_allwells.d(n_fee) ; total densitiy of states of all Wells
  Dim well_dos.d(n_wells-1,n_fee)
  Dim k_rad.d(n_t_amb-1,n_wells-1,n_fee,n_fee)   ;new in vs 3.01: additional dimension for temperature
  Dim k_iso.d(n_isoreact,n_fee)     ; Rate for isomerisation channels - new in vs 3.41
  If flag_population.l = 0
    Dim final_population.d(n_t_amb-1,n_wells-1,n_fee)   ; new in vs. 2.8: remember final converged population for export to Excel or restart of MEM
  EndIf
  total_en.d = total_en_max
  Gosub calculate_dos         ; load all information and employ Beyer / Swinehart
  Gosub calculate_sos
  For i_fee = 1 To n_fee
    total_en = i_fee*total_en_step
    ; calculate total_dos(n_groups-1,i_fee), total_dos_allwells and LOAD WELL_DOS(i,j) With CORRECT DOS!!! SPEED REQUIRES IT!!!
    For i_wells = 0 To n_wells-1
      If Int((total_en-well_relative(i_wells))/bs_quantum+0.5) > 0
        well_dos(i_wells,i_fee) = dos_well(i_wells,Int((total_en-well_relative(i_wells))/bs_quantum+0.5))
        total_dos(group(i_wells),i_fee) = total_dos(group(i_wells),i_fee)+well_dos(i_wells,i_fee)
        total_dos_allwells(i_fee) = total_dos_allwells(i_fee) + well_dos(i_wells,i_fee) ; new in vs 34.4
      EndIf
    Next i_wells
    ; calculate rates of product formation
    For i_channels = 0 To n_channels-1
      If well_channel(i_channels) >= 0
        If Int((total_en-well_relative(well_channel(i_channels)))/bs_quantum+0.5) > 0 And Int((total_en-ts_relative(ts_channel(i_channels)))/bs_quantum+0.5) > 0
          rate.d(i_channels,i_fee) = sos_ts(ts_channel(i_channels),Int((total_en-ts_relative(ts_channel(i_channels)))/bs_quantum+0.5))/(h_planck*well_dos(well_channel(i_channels),i_fee))
  ;       total_rate(i_fee) = total_rate(i_fee)+rate(i_channels,i_fee) ; Martin 24.10.2023: looks totally useless and senseless, not used any further ...
        EndIf
      Else   ; well_channel(i_channels) = -1 only other option, "Well all" used in channel definition
        If ts_channel(i_channels) = -1  ; new in vs. 3.52: allow total rate according to Hartmann et al., NaCl cluster RRKM paper DOI: 10.1039/D4CP00357H
          totaldos.d = 0
          For i_wells = 0 To n_wells-1
            totaldos = totaldos+well_dos(i_wells,i_fee)
          Next i_wells
          totalsos.d = 0
          For i_ts = 0 To n_ts-1
            If Int((total_en-ts_relative(i_ts))/bs_quantum+0.5) > 0
              totalsos.d = totalsos.d + sos_ts(i_ts,Int((total_en-ts_relative(i_ts))/bs_quantum+0.5))
            EndIf
          Next i_ts
          rate.d(i_channels,i_fee) = totalsos.d/(h_planck*totaldos)
        Else    ; ts_channel(i_channels) = -2 only option, SoS only for TSs defined in ts_parallel(i_channels,i_ts)
          totaldos.d = 0
          For i_wells = 0 To n_wells-1
            totaldos = totaldos+well_dos(i_wells,i_fee)
          Next i_wells
          totalsos.d = 0
          For i_ts = 0 To n_ts_parallel(i_channels)-1
            If Int((total_en-ts_relative(ts_parallel(i_channels,i_ts)))/bs_quantum+0.5) > 0
              totalsos.d = totalsos.d + sos_ts(ts_parallel(i_channels,i_ts),Int((total_en-ts_relative(ts_parallel(i_channels,i_ts)))/bs_quantum+0.5))
            EndIf
          Next i_ts
          rate.d(i_channels,i_fee) = totalsos.d/(h_planck*totaldos)
        EndIf
      EndIf
    Next i_channels
    ; calculate isomerisation rates           ; new in vs 3.41
    For i_isoreact = 1 To n_isoreact ;If n_isoreact = 0 this For-loop is skipped
      If Int((total_en-well_relative(startwell_isoreact(i_isoreact)))/bs_quantum+0.5) > 0 And Int((total_en-ts_relative(ts_isoreact(i_isoreact)))/bs_quantum+0.5) > 0
        k_iso.d(i_isoreact,i_fee) = sos_ts(ts_isoreact(i_isoreact),Int((total_en-ts_relative(ts_isoreact(i_isoreact)))/bs_quantum+0.5))/(h_planck*well_dos(startwell_isoreact(i_isoreact),i_fee))
      EndIf  
    Next i_isoreact   
  Next i_fee


  OpenConsole()
  ;- temperature loop for rate calculation
  For i_t = 0 To n_t_amb-1
    If manual_temp_list_flag = 1  
      t_amb.d = t_manual_list(i_t)  ; new in vs. 3.57 - takes temperature from list in parameter panel 
    ElseIf n_t_amb > 1
      t_amb.d = 1/(1/t_amb0-(1/t_amb0-1/t_amb1)/(n_t_amb-1)*i_t)    ; equal intervals on 1/T scale
    Else
      t_amb.d = t_amb0
    EndIf

    ;- Einstein emission and absorption rates
    Dim einstein_rb.d(n_wells-1,max_modes_well)
    Dim einstein_rb_window.d(n_wells-1,max_modes_well)
    Dim einstein_a.d(n_wells-1,max_modes_well)
    For i_wells = 0 To n_wells-1
      For j = 1 To n_well_vmodes(i_wells)
        ; absorption
        einstein_rb(i_wells,j) = 8*pi*c_light*exact_well(i_wells,j)*exact_well(i_wells,j)*Pow(10,4)*well_intensity(i_wells,j)*int_scale*1000/(n_avo*(Exp((h_planckSI*c_light*exact_well(i_wells,j)*100/(k_boltz*t_amb)))-1))
        ; absorption of Blackbody Radiation through window
        einstein_rb_window(i_wells,j) = 8*pi*c_light*exact_well(i_wells,j)*exact_well(i_wells,j)*Pow(10,4)*well_intensity(i_wells,j)*int_scale*1000/(n_avo*(Exp((h_planckSI*c_light*exact_well(i_wells,j)*100/(k_boltz*t_room)))-1))
        ; emission
        einstein_a(i_wells,j) = 8*pi*c_light*exact_well(i_wells,j)*exact_well(i_wells,j)*Pow(10,4)*well_intensity(i_wells,j)*int_scale*1000/n_avo
      Next j
    Next i_wells

    ;- radiative transition rates between levels of same well
    PrintN("Calculating radiative rates (Temperature " + StrF(t_amb) + " K)  ... ")
    For i_wells = 0 To n_wells-1                      ; loop over wells
      ; prepare n_well_vmodes(i_wells) DoS-arrays with each mode missing in turn
      If n_bs_well(i_wells) > 0
        Dim dos_rad.d(n_well_vmodes(i_wells),n_bs_well(i_wells))
        Dim dos_rovib_aqsm.d(n_bs_well(i_wells)) ; new in vs. 2.7: perform calculation of ro-vibrational dos and aqsm contributions only once
        Gosub bs_count_rovib_aqsm
        For j = 1 To n_well_vmodes(i_wells)
          Gosub bs_count_rad
        Next j
        For i_fee = Int(well_relative(i_wells)/total_en_step+0.5) To n_fee      ; loop over allowed energy levels
          For k = 1 To n_well_vmodes(i_wells)                  ; loop over vibrational modes
            test.d = 0  ; sum up probabilities, in the end test = 1 expected
            For m = 0 To Int((i_fee*total_en_step - well_relative(i_wells)) / exact_well(i_wells,k))  ; loop over possible populations of vibrational mode
              ; calculate probability pkm that mode k is populated m times 
              If Int((i_fee*total_en_step-well_relative(i_wells)-m*exact_well(i_wells,k))/bs_quantum) > 0
                pkm.d = dos_rad(k,Int((i_fee*total_en_step-well_relative(i_wells)-m*exact_well(i_wells,k))/bs_quantum))/dos_well(i_wells,Int((i_fee*total_en_step - well_relative(i_wells))/bs_quantum))
              Else
                If i_fee = Int(well_relative(i_wells)/total_en_step+0.5)  ; if m = 0 and lowest i_fee of well
                  pkm.d = 1
                Else
                  pkm.d = 0
                EndIf
              EndIf
              test = test + pkm
              ; calculate absorption
              k_abs.d = pkm * (m+1) * (einstein_rb(i_wells,k)*(1 - window_angle) + einstein_rb_window(i_wells,k)* window_angle)
              ; calculate level l for absorption i_fee -> l
              i_fee_new.l = i_fee + (exact_well(i_wells,k)/total_en_step)
              If i_fee_new > n_fee
                i_fee_new = n_fee
              EndIf              
              k_rad(i_t,i_wells,i_fee_new,i_fee) = k_rad(i_t,i_wells,i_fee_new,i_fee) + k_abs
              k_rad(i_t,i_wells,i_fee,i_fee) = k_rad(i_t,i_wells,i_fee,i_fee) - k_abs
              ; calculate emission
              If m > 0
                k_emm.d = pkm * m * (einstein_a(i_wells,k) + (einstein_rb(i_wells,k)*(1 - window_angle) + einstein_rb_window(i_wells,k)* window_angle)) ;NEW in vs.rrkm_2.6: Induced Emmission added in this line
                ; calculate level l for emission
                i_fee_new.l = i_fee - (exact_well(i_wells,k)/total_en_step)
                If i_fee_new < Int(well_relative(i_wells)/total_en_step+0.5)
                  i_fee_new = Int(well_relative(i_wells)/total_en_step+0.5)
                EndIf
                k_rad(i_t,i_wells,i_fee_new,i_fee) = k_rad(i_t,i_wells,i_fee_new,i_fee) + k_emm
                k_rad(i_t,i_wells,i_fee,i_fee) = k_rad(i_t,i_wells,i_fee,i_fee) - k_emm
              EndIf
            Next m
            If test < 0.9 Or test > 1.1
              PrintN("Sum of probabilities at Temperature "+ Str(t_amb) +" K: "+StrF(test)+" for mode " + Str(k) +" for bin "+Str(i_fee)+" in well "+Str(i_wells))
            EndIf
          Next k
        Next i_fee
      EndIf
      ; new in VS 3.5: add IRMPD rate, if applicable
        If k_irmpd.d(i_wells) > 0 And nu_irmpd > 0
          nu_step.l = Int(nu_irmpd / total_en_step+0.5)
          For i_fee = Int(well_relative(i_wells)/total_en_step+0.5) To n_fee - nu_step      ; loop over allowed energy levels from which an IRMPD photon can be absorbed
            k_rad(i_t,i_wells,i_fee + nu_step,i_fee) = k_rad(i_t,i_wells,i_fee + nu_step,i_fee) + k_irmpd(i_wells)
            k_rad(i_t,i_wells,i_fee,i_fee) = k_rad(i_t,i_wells,i_fee,i_fee) - k_irmpd(i_wells)
          Next i_fee
        EndIf
      ; end IRMPD section  
    Next i_wells
    PrintN("Radiative rates calculated.")
    If n_t_amb = 1
          Break ; exit temperature loop after start temperature if only one temperature needed
    EndIf
  Next i_t ; close temperature loop for rate calculation
Return   
    
;- Master Equation Modeling Convergence
master_equation_modeling_convergence:
  ClearGadgetItems(#Editor_0)
  SetGadgetState(#Panel_0,0)
  AddGadgetItem(#Editor_0,-1,"Master Equation Modeling for the calculation of a steady state")
  AddGadgetItem(#Editor_0,-1,"")
  clip$=" Temperature   1/Temperature  rate_coefficient  ln(rate_coefficient/(s-1)) "
  clip_pop$=""
  If flag_donotpub = 1
    AddGadgetItem(#Editor_0,-1,"Number of active degrees of freedom is not consistent. DO NOT PUBLISH THESE RESULTS!!!")
  EndIf
  If flag_fewdegrees = 1 ;if number of active degrees of freedom in Well 0 (should be the same for other wells) is very small
     AddGadgetItem(#Editor_0,-1,"WARNING: system has very few degrees of freedom. Results may Not be meaningful. Use only after very critical evaluation. High value of BS-quantum might help.")
  EndIf ; new i vs. AWATAR1.0f
  For i_channels = 0 To n_channels-1
    clip$=clip$+RSet("Channel"+RSet(Str(i_channels),3,"_"),11)+"  "
  Next i_channels  
  AddGadgetItem(#Editor_0,-1,clip$)
  clip$="         (K)           (K-1)             (s-1)                             "
  For i_channels = 0 To n_channels-1
    clip$=clip$+RSet("(s-1)",11)+"  "
  Next i_channels
  AddGadgetItem(#Editor_0,-1,clip$)
  ; start temperature loop
  For i_t = 0 To n_t_amb-1
    If manual_temp_list_flag = 1  
      t_amb.d = t_manual_list(i_t) ; new in vs. 3.57 - takes temperature from list in parameter panel
    ElseIf n_t_amb > 1
      t_amb.d = 1/(1/t_amb0-(1/t_amb0-1/t_amb1)/(n_t_amb-1)*i_t)    ; equal intervals on 1/T scale
    Else
      t_amb.d = t_amb0
    EndIf 
    dt.d = dt300k*300*300*300*300/(t_amb*t_amb*t_amb*t_amb)       ; correct time interval for T^4 dependence
   
    Gosub initialize_population
    Gosub speed_calculations    
    
    iteration = 0
    rate1.d = 1e5 ; initialize with a high value to make sure convergence criterion is not fulfilled
    While Abs(1-(rate_old.d/rate1))>convergence Or iteration<100
      Gosub MEM_iteration
      Gosub normalize_population
      
      loop_count = loop_count +1
      If loop_count = 100
        rate_old = rate1.d
        ClearConsole()
        rate1.d = 0
        For i = 0 To n_channels-1
 ;         PrintN("Rate of product formation in channel "+Str(i)+":   "+StrF(dprod(i)/dt)) ;Include this again if it is of interest.
          rate1.d = rate1 + dprod(i)/dt
        Next i
        PrintN("Total rate of product formation :   "+StrD(rate1)+" s-1")
        PrintN("Convergence:    "+StrD(Abs(1-rate_old/rate1),15)+"     Temperature: "+StrF(t_amb) + " K   Timestep(at 300K): " +StrF(dt300k,15) + " s   Wait for convergence: " + StrF(convergence,15))
  ;      PrintN("Lowest TS between groups is at Level "+StrF(fee_barrier) + "     Chemical equilibrium between groups above Level "+StrF(fee_FreeExchange)) ;new in vs 3.44. (See Restore Equilibrium between Wells)
        Gosub print_population
        loop_count = 0
      EndIf
    Wend
    clip$=RSet(StrF(t_amb,3),12)+"      "+RSet(StrF(1/t_amb,8),10)+"    "+RSet(StrF(rate1,8),14)+"              "+ RSet(StrF(Log(rate1),8),14) +" " 
    For i = 0 To n_channels-1
      clip$=clip$+RSet(StrF(dprod(i)/dt,8),11)+"  "
    Next i
    AddGadgetItem(#Editor_0,-1,clip$)
    ; remember population  - new in vs. 2.8
    For i_fee = 0 To n_fee
      For i_wells = 0 To n_wells-1
        final_population.d(i_t,i_wells,i_fee) = well(i_wells,i_fee)  
      Next i_wells
    Next i_fee
    ; prepare for export to popfile
    clip_pop$=clip_pop$+Chr(13)+Chr(10)+"T="+StrF(t_amb)+"K   "
    clip_pop$=clip_pop$+"Convergence: "+StrF(convergence,15)+"   Timestep(at 300K): " +StrF(dt300k,15)+" s"+Chr(13)+Chr(10)
  ;  clip_pop$=clip_pop$+"(Lowest TS between groups is at Level "+StrF(fee_barrier) + ", Chemical equilibrium between groups above Level "+StrF(fee_FreeExchange)+")"+Chr(13)+Chr(10)
    clip_pop$=clip_pop$+"Population:" +Chr(13)+Chr(10)
    welllist$=""
    For i = 0 To n_wells-1
      welllist$=welllist$+"Well_"+i+"            "
    Next i
    clip_pop$=clip_pop$+" Energy        "+ welllist$+Chr(13)+Chr(10)
    clip_pop$=clip_pop$+" (cm-1)       "
      For i = 0 To n_wells-1
        clip_pop$=clip_pop$+" (1/cm-1)         "
      Next i
      clip_pop$=clip_pop$+Chr(13)+Chr(10)
    For j = 0 To n_fee
      clip_pop$=clip_pop$+RSet(Str(j*total_en_step),10)+"     "
      For i = 0 To n_wells-1
        clip_pop$=clip_pop$+science(well(i,j)/total_en_step,6)+"     "
      Next i
      clip_pop$=clip_pop$+Chr(13)+Chr(10)
    Next j
    If n_t_amb = 1
      Break ; exit temperature loop after start temperature if only one temperature needed
    EndIf
  Next i_t ; close temperature loop
  ; export population to popfile ; new in vs 34.5
  OpenFile(0,Filename$+"_pop.txt",#PB_File_Append)
  WriteStringN(0, clip_pop$)
  CloseFile(0) 
  flag_population.l = 1
  If Iterative_MEM_flag = 0
    PrintN("Done. Populations for all temperatures are in the file "+Filename$+"_pop.txt, rest in results panel.")
  Else
    PrintN("Done. Populations for all temperatures and all iteration steps are in the file "+Filename$+"_pop.txt, rest in results panel.")
  EndIf  
Return

;- Master Equation Modeling Real Time
master_equation_modeling_real_time:
  ClearGadgetItems(#Editor_0)
  SetGadgetState(#Panel_0,0)
  AddGadgetItem(#Editor_0,-1,"Master Equation Modeling in Real Time")
  AddGadgetItem(#Editor_0,-1,"")
  ; start temperature loop
  For i_t = 0 To n_t_amb-1
    If manual_temp_list_flag = 1  
      t_amb.d = t_manual_list(i_t) ; new in vs. 3.57 - takes temperature from list in parameter panel
    ElseIf n_t_amb > 1
      t_amb.d = 1/(1/t_amb0-(1/t_amb0-1/t_amb1)/(n_t_amb-1)*i_t)    ; equal intervals on 1/T scale
    Else
      t_amb.d = t_amb0
    EndIf 
    dt.d = dt300k       ; use the same time step for all temperatures for consistency
    
    t_amb_old.d = t_amb         ; now change temperature for initial Boltzmann distribution to value read from parameter window    
    If temp_initial.d > 0       ; only positive temperatures allowed
      flag_population = 0       ; forget previous population if ambient temperature modified
      t_amb = temp_initial
    EndIf
    
    Gosub initialize_population
    t_amb = t_amb_old
    If uv_photon.d > 0    ; shift complete population by photon energy before MEM starts
      Dim well_old.d(n_wells-1,n_fee-1)   ; remember old population
      For i_fee = 0 To n_fee-1
        For i_wells = 0 To n_wells-1
          well_old(i_wells,i_fee) = well(i_wells,i_fee)
        Next i_wells
      Next i_fee
      For i_fee = 0 To n_fee
        For i_wells = 0 To n_wells-1
          i_fee_photon.l = Int(Round(i_fee-uv_photon/total_en_step,#PB_Round_Nearest))
          If i_fee_photon >= 0 And i_fee_photon <= n_fee
            well(i_wells,i_fee) = well_old(i_wells,i_fee_photon)
          Else
            well(i_wells,i_fee) = 0
          EndIf
        Next i_wells
      Next i_fee
      Gosub normalize_population
    EndIf
    Gosub speed_calculations    
    ClearConsole()
    clip$ = "Temperature "+StrF(t_amb,2)+" K"
    AddGadgetItem(#Editor_0,-1,clip$)
    clip$=RSet("Time",15)+RSet("Reactant",20)
    clip_pop$=""
    If flag_donotpub = 1
      AddGadgetItem(#Editor_0,-1,"Number of active degrees of freedom is not consistent. DO NOT PUBLISH THESE RESULTS!!!")
    EndIf
    If flag_fewdegrees = 1 ;if number of active degrees of freedom in Well 0 (should be the same for other wells) is very small
     AddGadgetItem(#Editor_0,-1,"WARNING: system has very few degrees of freedom. Results may Not be meaningful. Use only after very critical evaluation. High value of BS-quantum might help.")
    EndIf ; new in vs. AWATAR1.0f
    For i_channels = 0 To n_channels-1
      clip$=clip$+RSet("Channel"+RSet(Str(i_channels),3,"_"),20)
    Next i_channels  
    clip$=clip$+RSet("Mean_Energy",20)
    AddGadgetItem(#Editor_0,-1,clip$)
    clip$=RSet("(s)",15)+RSet("",20)
    For i_channels = 0 To n_channels-1
      clip$=clip$+RSet("",20)
    Next i_channels  
    clip$=clip$+RSet("(cm-1)",20)
    AddGadgetItem(#Editor_0,-1,clip$)

    
    n_point_export.l = Int(Round(point_export_interval/dt,#PB_Round_Nearest))
    simulation_time.d = 0
    reactant_intensity.d = 1
    Dim product_intensity.d(n_channels-1)
    ; print intensities at t = 0 s
    clip$=RSet(Science(simulation_time,6),15)+RSet(Science(reactant_intensity,6),20)
    For i = 0 To n_channels-1
      clip$=clip$+RSet(Science(product_intensity(i),6),20)
    Next i
    Gosub calculate_mean_energy
    clip$=clip$+RSet(Science(mean_energy.d,6),20)
    AddGadgetItem(#Editor_0,-1,clip$)
    PrintN(clip$)
    
    ; prepare for export to popfile - starting population
      clip_pop$=clip_pop$+Chr(13)+Chr(10)+"T="+StrF(t_amb)+"K   "
      clip_pop$=clip_pop$+"Simulation Time: "+StrF(simulation_time,15)+" s   Timestep: " +StrF(dt,15)+" s"+Chr(13)+Chr(10)
      clip_pop$=clip_pop$+"Population:" +Chr(13)+Chr(10)
      welllist$=""
      For i = 0 To n_wells-1
        welllist$=welllist$+"Well_"+i+"            "
      Next i
      clip_pop$=clip_pop$+" Energy        "+ welllist$+Chr(13)+Chr(10)
      clip_pop$=clip_pop$+" (cm-1)       "
      For i = 0 To n_wells-1
        clip_pop$=clip_pop$+" (1/cm-1)         "
      Next i
      clip_pop$=clip_pop$+Chr(13)+Chr(10)
      For j = 0 To n_fee
        clip_pop$=clip_pop$+RSet(Str(j*total_en_step),10)+"     "
        For i = 0 To n_wells-1
          clip_pop$=clip_pop$+science(well(i,j)/total_en_step,6)+"     "
        Next i
        clip_pop$=clip_pop$+Chr(13)+Chr(10)
      Next j
      ; export population to popfile 
      OpenFile(0,Filename$+"_pop.txt",#PB_File_Append)
      WriteStringN(0, clip_pop$)
      CloseFile(0) 
      clip_pop$ = ""
    
    Repeat
      For i_pop_export.l = 1 To n_export
        For i_point_export.l = 1 To n_point_export
          Gosub MEM_iteration
          Gosub normalize_population
          reactant_intensity_old.d = reactant_intensity
          For i = 0 To n_channels-1
            product_intensity(i) = product_intensity(i) + dprod(i)*reactant_intensity_old
            reactant_intensity = reactant_intensity - dprod(i)*reactant_intensity_old
          Next i
          simulation_time = simulation_time + dt
        Next i_point_export
        clip$=RSet(Science(simulation_time,6),15)+RSet(science(reactant_intensity,6),20)
        For i = 0 To n_channels-1
          clip$=clip$+RSet(science(product_intensity(i),6),20)
        Next i
        Gosub calculate_mean_energy
        clip$=clip$+RSet(Science(mean_energy.d,6),20)
        AddGadgetItem(#Editor_0,-1,clip$)
        PrintN(clip$)
      Next i_pop_export
      ; prepare for export to popfile
      clip_pop$=clip_pop$+Chr(13)+Chr(10)+"T="+StrF(t_amb)+"K   "
      clip_pop$=clip_pop$+"Simulation Time: "+StrF(simulation_time,15)+" s   Timestep: " +StrF(dt,15)+" s"+Chr(13)+Chr(10)
      clip_pop$=clip_pop$+"Population:" +Chr(13)+Chr(10)
      welllist$=""
      For i = 0 To n_wells-1
        welllist$=welllist$+"Well_"+i+"            "
      Next i
      clip_pop$=clip_pop$+" Energy        "+ welllist$+Chr(13)+Chr(10)
      clip_pop$=clip_pop$+" (cm-1)       "
      For i = 0 To n_wells-1
        clip_pop$=clip_pop$+" (1/cm-1)         "
      Next i
      clip_pop$=clip_pop$+Chr(13)+Chr(10)
      For j = 0 To n_fee
        clip_pop$=clip_pop$+RSet(Str(j*total_en_step),10)+"     "
        For i = 0 To n_wells-1
          clip_pop$=clip_pop$+science(well(i,j)/total_en_step,6)+"     "
        Next i
        clip_pop$=clip_pop$+Chr(13)+Chr(10)
      Next j
      ; export population to popfile 
      OpenFile(0,Filename$+"_pop.txt",#PB_File_Append)
      WriteStringN(0, clip_pop$)
      CloseFile(0) 
      clip_pop$ = ""
    Until simulation_time >= t_totsim-dt
    If n_t_amb = 1
      Break ; exit temperature loop after start temperature if only one temperature needed
    EndIf
  Next i_t ; close temperature loop
  flag_population.l = 0
Return


;- Initialize Population
initialize_population:  ; subroutine to initialize a population at temperature t_amb before master equation modeling or copy existing population into active array
  Dim well.d(n_wells-1,n_fee)
  If flag_population.l = 0   ; no population available, initialize with Boltzmann
    If t_amb = 0
      For i_wells = 0 To n_wells-1
        well(i_wells,0) = well_dos(i_wells,0)
      Next i_wells
    Else
      For i_fee = 0 To n_fee
        For i_wells = 0 To n_wells-1
          well(i_wells,i_fee) = well_dos(i_wells,i_fee)*Exp(-(i_fee*total_en_step*conversion_cm_J/(k_boltz*t_amb)))
        Next i_wells
      Next i_fee
    EndIf
    ; normalize population
    Gosub normalize_population  
  Else  ; reuse existing population
    For i_fee = 0 To n_fee
      For i_wells = 0 To n_wells-1
        well(i_wells,i_fee) = final_population.d(i_t,i_wells,i_fee)
      Next i_wells
    Next i_fee
  EndIf
Return

;- speed calculations
speed_calculations:
    ; speed things up: calculate depletion of each finite energy element (fee) with all processes for all wells, using exponential to capture fast processes on equal footing
    ; these can later be multiplied with the population
    ; the contribution of each radiative or reactive channel is simply the individual rate divided by the total rate
    Dim k_total_depletion.d(n_wells-1,n_fee)  ; total depletion rate of finite energy element and well (without isomerisation)
    Dim total_depletion.d(n_wells-1,n_fee)    ; exp(-k_total_depletion*dt), calculate exponential only once
    Dim rel_total_depletion.d(n_wells-1,n_fee)  ; total_depletion(..)/k_total_depletion(..) speeds things up, calculated repeatedly in the main loop
    For i = 0 To n_wells-1      ; loop for radiative contribution to k_total_depletion
      For j = 0 To n_fee
        For k = 0 To n_fee
          If k <> j
            k_total_depletion(i,k) = k_total_depletion(i,k) + k_rad(i_t,i,j,k)
          EndIf
        Next k
      Next j
    Next i
    For i_channels = 0 To n_channels-1   ; loop for reactive contribution to k_total_depletion
      If well_channel(i_channels) >= 0 ; And ts_channel(i_channels) >= 0 ; ts_channel(i_channels) < 0 only possible if well_channel(i_channels) = -1, "Well all" defined
        For k = 0 To n_fee
          k_total_depletion(well_channel(i_channels),k) = k_total_depletion(well_channel(i_channels),k) + rate(i_channels,k)
        Next k
      Else
        If well_channel(i_channels) = -1 ; And ts_channel(i_channels) = -1 ; redundant condition and not complete, ts_channel(i_channels) = -2 possible
          For i = 0 To n_wells-1
            For k = 0 To n_fee
              k_total_depletion(i,k) = k_total_depletion(i,k) + rate(i_channels,k)
            Next k
          Next i
        EndIf
      EndIf
    Next i_channels
    For i = 0 To n_wells-1
      For k = 0 To n_fee
        total_depletion(i,k) = 1-Exp(-k_total_depletion(i,k)*dt)
        If k_total_depletion(i,k)>0
          rel_total_depletion(i,k) = total_depletion(i,k)/k_total_depletion(i,k)
        EndIf
      Next k
    Next i
    
    ;Calculate the total depletion rate due to isomerisation channels, k_total_iso_depletion: - new in vs 3.43
    Dim k_total_iso_depletion.d(n_wells-1,n_fee)  ; total depletion rate of finite energy element and well due to isomerisation
    Dim total_iso_depletion.d(n_wells-1,n_fee)    ; exp(-k_total_iso_depletion*dt)
    Dim rel_total_iso_depletion.d(n_wells-1,n_fee); total_iso_depletion(..)/k_total_iso_depletion(..)
    Dim total_iso_depletion_SumAllWells.d(n_fee)  ; total_iso_depletion summed over all wells
    For i_isoreact = 1 To n_isoreact;  (skipped, if no isochannels defined)
      For k = 0 To n_fee
        k_total_iso_depletion(startwell_isoreact(i_isoreact),k) = k_total_iso_depletion(startwell_isoreact(i_isoreact),k) + k_iso(i_isoreact,k)
      Next k
    Next i_isoreact  
    For i = 0 To n_wells-1
      For k = 0 To n_fee
        total_iso_depletion(i,k) = 1-Exp(-k_total_iso_depletion(i,k)*dt)
        total_iso_depletion_SumAllWells(k) = total_iso_depletion_SumAllWells(k) + total_iso_depletion(i,k)
        If k_total_iso_depletion(i,k)>0
          rel_total_iso_depletion(i,k) = total_iso_depletion(i,k)/k_total_iso_depletion(i,k)
        EndIf
      Next k
    Next i
    Return
    
;- MEM iteration
MEM_iteration:    ; iteration of MEM without normalization; one time step d_t is handeled
      iteration=iteration+1
      ; set differential changes to 0 by initializing arrays
      Dim dprod.d(n_channels-1) ; reactive processes
      Dim dwell.d(n_wells-1,n_fee)        ; radiative processes and also reactive processes.
      For i_channels = 0 To n_channels-1  ; loop for reactive processes
        If well_channel(i_channels) >= 0 ; And ts_channel(i_channels) >= 0 ; redundant, always fulfilled
          For k = 0 To n_fee
            dprod(i_channels) = dprod(i_channels) + well(well_channel(i_channels),k) * rel_total_depletion(well_channel(i_channels),k)* rate(i_channels,k)
          Next k
        Else
          If well_channel(i_channels) = -1 ; And ts_channel(i_channels) = -1 ; may also be -2, but handled in the same way
            For i_wells = 0 To n_wells-1
              For k = 0 To n_fee
                dprod(i_channels) = dprod(i_channels) + well(i_wells,k) * rel_total_depletion(i_wells,k)* rate(i_channels,k)
              Next k
            Next i_wells
          EndIf
        EndIf
      Next i_channels
      For i = 0 To n_wells-1  ; loop for radiative processes
        For j = 0 To n_fee
          For k = 0 To n_fee
            If j = k
              dwell(i,k) = dwell(i,k)-total_depletion(i,k)*well(i,k)    ; this includes loss due to reactions.
            Else
              dwell(i,j) = dwell(i,j)+k_rad(i_t,i,j,k)*rel_total_depletion(i,k)*well(i,k)
            EndIf
          Next k
        Next j
      Next i
      ; calculate new population
      For i = 0 To n_wells-1
        For j = 0 To n_fee
          well(i,j)=well(i,j)+dwell(i,j)
          If well(i,j) < 0
            well(i,j) = 0
          EndIf
        Next j
      Next i
      
      ;-Restore Equilibrium between Wells
      ;new procedure for calculation equilibium since vs.3.44:  If isomerisationrates trough TS would be very high, the isomerisation takes place without barrier (chemical equilibrium). Only for bins and timesteps, where the rates are low enough, Isomerisation takes place via the TS.
      ;equilibrium is calculated for each bin seperately.      
      ;TO DO This is programmed for max 2 groups! Adapt for more groups if needed.
      
      ; first determine fee_barrier (the last i_fee below the TS connecting the two groups) and fee_FreeExchange (above of fee_FreeExchange there is a chemical equilibrium between both groups)
      lowest_TS_Energy.d = 0      
      fee_barrier.d = 0
      fee_FreeExchange.d = 0
      If n_isoreact > 0
         For i = 1 To n_isoreact
           If ts_energy(ts_isoreact(i)) < lowest_TS_Energy
             lowest_TS_Energy = ts_relative(ts_isoreact(i))
           EndIf  
         Next i
         For i_fee = 0 To n_fee
           If i_fee*total_en_step > lowest_TS_Energy 
             fee_barrier = i_fee - 1
           EndIf
           If fee_barrier <> 0
            Break ; stop at first fee above lowest_TS_Energy
           EndIf
         Next i_fee 
         For i_fee = fee_barrier To n_fee
           If total_iso_depletion_SumAllWells(i_fee) < FreeExchange_Criterion
             fee_FreeExchange = i_fee
           EndIf
         Next i_fee  
      EndIf
      ; Now restore Equilibium:         
      Dim isomerisationtype(n_fee)
      For j = 0 To n_fee  
        If n_groups = 1 Or (n_isochan > 0 And j > fee_FreeExchange)  ;In this case, the groups are fully connected, chemical equilibrium between all wells independend of their group.
          total_pop.d=0
          For i = 0 To n_wells-1
            total_pop=total_pop+well(i,j)
          Next i
          For i = 0 To n_wells-1
            well(i,j)=total_pop*well_dos(i,j)/total_dos_allwells(j)
          Next i
          isomerisationtype(j)= 3
        ElseIf n_isochan = 0 Or j =< fee_barrier   ;In this case, all groups are seperated, chemical equilibrium only within the group.
          Dim total_pop_group.d(n_groups-1)
          For i = 0 To n_wells-1
            total_pop_group(group(i))=total_pop_group(group(i))+well(i,j)
          Next i
          For i = 0 To n_wells-1
            well(i,j)=total_pop_group(group(i))*well_dos(i,j)/total_dos(group(i),j) ; population redistributed within the group.
          Next i
          isomerisationtype(j)= 1
        Else ;In this case, the groups are weakly connected via Isomerisation channels
          Gosub Isomerisation_via_Isochannel_TS
          isomerisationtype(j)= 2
        EndIf 
      Next j      
Return
    
;- normalize population
normalize_population:
  ; normalize population - refill population lost due to reactions, otherwise stationary state will never be reached!
  population.d = 0
  For i =0 To n_wells-1
    For j = 0 To n_fee
      If well(i,j)<0
        well(i,j) = 0
      EndIf
      population = well(i,j) + population
    Next j
  Next i
  For i =0 To n_wells-1
    For j = 0 To n_fee
      well(i,j)=well(i,j)/population
    Next j
  Next i
Return

;- Calculate mean energy
calculate_mean_energy:
  ; calculate energy expectation value of population
  mean_energy.d = 0
  For i =0 To n_wells-1
    For j = 0 To n_fee
      mean_energy = mean_energy+well(i,j)*j*total_en_step
    Next j
  Next i
Return



;-Isomerisation_via_Isochannel_TS
Isomerisation_via_Isochannel_TS:   ;calculated at given Energy bin j.   
      ; restore equilibrium of well population within a group: DOS determines relative population ; This is done here, because isomerisation within the group is fast compared to isomerisation between groups.
        Dim total_pop_group.d(n_groups-1) ;total_pop_group is calculated for all groups seperately.
        For i = 0 To n_wells-1
          total_pop_group(group(i))=total_pop_group(group(i))+well(i,j)
        Next i
        For i = 0 To n_wells-1
          well(i,j)=total_pop_group(group(i))*well_dos(i,j)/total_dos(group(i),j) ; population redistributed within the group.
        Next i         
      ;Isomerisation channels for exchange between groups - new in vs 3.43:
      Dim dwell_iso.d(n_wells-1,n_fee) ;change in population due to isomerisation.
      For  i_isoreact = 1 To n_isoreact ; (skipped, if no isochannels defined)
          dwell_iso(startwell_isoreact(i_isoreact),j) = dwell_iso(startwell_isoreact(i_isoreact),j) - k_iso(i_isoreact,j)*rel_total_iso_depletion(startwell_isoreact(i_isoreact),j)*well(startwell_isoreact(i_isoreact),j)
          dwell_iso(endwell_isoreact(i_isoreact),j) = dwell_iso(endwell_isoreact(i_isoreact),j) + k_iso(i_isoreact,j)*rel_total_iso_depletion(startwell_isoreact(i_isoreact),j)*well(startwell_isoreact(i_isoreact),j)
      Next i_isoreact
      ;calculate new population after isomerisation
      For i = 0 To n_wells-1
          well(i,j)=well(i,j)+dwell_iso(i,j)
          If well(i,j) < 0
           well(i,j) = 0
          EndIf
      Next i      
      ; restore equilibrium of well population within a group: DOS determines relative population
        Dim total_pop_group.d(n_groups-1) ;Since vs 3.40 total_pop_group is calculated for all groups seperately.
        For i = 0 To n_wells-1
          total_pop_group(group(i))=total_pop_group(group(i))+well(i,j)
        Next i
        For i = 0 To n_wells-1
          well(i,j)=total_pop_group(group(i))*well_dos(i,j)/total_dos(group(i),j) ; population redistributed within the group.
        Next i
Return      



;- print population ;changed in vs 3.44
print_population:
  For j_count = 1 To 10
    j = j_count * Int(n_fee/10)-1
    Print("bin "+ Str(j))
    k_well = 9  ; prints only information for first 10 wells
    If n_wells-1 < 9
     k_well = n_wells-1
    EndIf  
    For i = 0 To k_well
      Print("  "+StrF(n_fee/10*well(i,j)))
    Next i        
;    If isomerisationtype(j) = 1
;      Print( "     Isomerisation only within group" )
;    ElseIf isomerisationtype(j) = 2
;      Print( "     Isomerisation via isomerisation channels" )
;    ElseIf isomerisationtype(j) = 3
;      Print( "     Chemical equilibrium between all groups" )
;    EndIf
     PrintN("")     
  Next j_count
  PrintN("Iteration Number: "+Str(iteration)+" Time Elapsed: "+StrF(iteration*dt)+" s")
;  Delay(200)
Return
  
;- export population
export_population:
  OpenConsole()
  If flag_population.l = 1
    Gosub read_meq_parameters
    clip_pop$=""
    For i_t= 0 To n_t_amb-1 ; temperature loop for population export
      If manual_temp_list_flag = 1  
        t_amb.d = t_manual_list(i_t) ; new in vs. 3.57 - takes temperature from list in parameter panel
      ElseIf n_t_amb > 1
        t_amb.d = 1/(1/t_amb0-(1/t_amb0-1/t_amb1)/(n_t_amb-1)*i_t)    ; equal intervals on 1/T scale
      Else
        t_amb.d = t_amb0
      EndIf
      ; prepare for export to clipboard
      clip_pop$=clip_pop$+" T="+StrF(t_amb)+"K"+Chr(13)+Chr(10)
      welllist$=""
      For i = 0 To n_wells-1 
        welllist$=welllist$+RSet("Well_"+Str(i),15)
      Next i   
      clip_pop$=clip_pop$+"    Energy     "+ welllist$+Chr(13)+Chr(10)
      untislist$=""
      For i = 0 To n_wells-1 
        untislist$=untislist$+RSet("(1/cm-1)",15)
      Next i   
      clip_pop$=clip_pop$+"    (cm-1)     "+ untislist$+Chr(13)+Chr(10)
      For i_fee = 0 To n_fee
        clip_pop$=clip_pop$+RSet(Str(i_fee*total_en_step),10)+"     "
        For i_wells = 0 To n_wells-1
          clip_pop$=clip_pop$+RSet(science(final_population.d(i_t,i_wells,i_fee)/total_en_step,6),15)
        Next i_wells
        clip_pop$=clip_pop$+Chr(13)+Chr(10)
      Next i_fee
      If n_t_amb = 1 ; exit loop if only one temperature
        Break
      EndIf
    Next i_t ; close temperature loop for population export
    ; export population to clipboard
    SetClipboardText(clip_pop$)
    PrintN("Done. Populations for all temperatures are copied to the clipboard.")
  Else
    PrintN("No population available.")
    SetClipboardText("")  
  EndIf
Return

;-bs_count_rovib_aqsm
; new in vs. 2.7: single out calculation of rovib dos and contribution of aqsm to save time
bs_count_rovib_aqsm:
  ; load rotational density of states into p_bs, following Gilbert/Smith (4.3.31)
  If n_well_1d_ar(i_wells) > 0 Or n_well_2d_ar(i_wells) > 0 Or hr2d_flag(i_wells) = 1
    gamma_prefactor.d = Pow(pi,n_well_1d_ar(i_wells)/2)/gamma(n_well_2d_ar(i_wells)+n_well_1d_ar(i_wells)/2+2*hr2d_flag(i_wells))
    For j_bs = 1 To n_well_1d_ar.l(i_wells)
      gamma_prefactor = gamma_prefactor/(well_1d_ar_sym(i_wells,j_bs)*Sqr(well_1d_ar(i_wells,j_bs)))
    Next j_bs
    For j_bs = 1 To n_well_2d_ar.l(i_wells)
      gamma_prefactor = gamma_prefactor/(well_2d_ar_sym(i_wells,j_bs)*well_2d_ar(i_wells,j_bs))
    Next j_bs
    If hr2d_flag(i_wells) = 1
      gamma_prefactor = gamma_prefactor/(hr2d_sym(i_wells)*hr2d_b(i_wells)*hr2d_V0(i_wells))
    EndIf
  Else
    gamma_prefactor.d = 0
  EndIf
  dos_rovib_aqsm.d(0) = 1 ; account for 0 cm-1 in rotations, so algorithm works also without active rotors
  If hr2d_flag(i_wells) = 0        ; no 2D hindered rotor, follow (4.3.31)
    For i_bs = 1 To n_bs_well(i_wells)
      dos_rovib_aqsm.d(i_bs) = gamma_prefactor*Pow(((i_bs)*bs_quantum),n_well_2d_ar(i_wells)+n_well_1d_ar(i_wells)/2-1)
    Next i_bs
  Else    ; 2D hindered rotor, follow (4.3.41)
    v0_bs.l = Int(hr2d_V0(i_wells)/bs_quantum)+1
    If n_bs_well(i_wells) > v0_bs
      For i_bs = 1 To v0_bs
        dos_rovib_aqsm.d(i_bs) = gamma_prefactor*Pow(((i_bs)*bs_quantum),n_well_2d_ar(i_wells)+n_well_1d_ar(i_wells)/2+1)
      Next i_bs
      For i_bs = v0_bs+1 To n_bs_well(i_wells)
        dos_rovib_aqsm.d(i_bs) = gamma_prefactor*(Pow(((i_bs)*bs_quantum),n_well_2d_ar(i_wells)+n_well_1d_ar(i_wells)/2+1)-Pow(((i_bs)*bs_quantum-hr2d_V0(i_wells)),n_well_2d_ar(i_wells)+n_well_1d_ar(i_wells)/2+1))
      Next i_bs
    Else
      For i_bs = 1 To n_bs_well(i_wells)
        dos_rovib_aqsm.d(i_bs) = gamma_prefactor*Pow(((i_bs)*bs_quantum),n_well_2d_ar(i_wells)+n_well_1d_ar(i_wells)/2+1)
      Next i_bs
    EndIf
  EndIf
  For j_bs = 1 To n_well_aqsm(i_wells)
    Dim temp_dos.d(n_bs_well(i_wells))
    For k_bs = 0 To n_bs_well(i_wells)
      For i_bs = 0 To n_bs_well(i_wells)-k_bs
        temp_dos(k_bs+i_bs)=temp_dos(k_bs+i_bs)+aqsm_well(i_wells,j_bs,k_bs) * dos_rovib_aqsm(i_bs)
      Next i_bs
    Next k_bs    
    For i_bs = 0 To n_bs_well(i_wells)
      dos_rovib_aqsm(i_bs) = temp_dos(i_bs)
    Next i_bs
  Next j_bs
  ; end new section vs. 2.7
Return

;- bs_count_rad
; like bs_count_rovib_dos, but leaves jth oscillator out
; needed to calculate radiative transition rates
bs_count_rad:
  ; first load results from ;-bs_count_rovib_aqsm - new in vs. 2.7
  For i_bs = 0 To n_bs_well(i_wells)
    dos_rad.d(j,i_bs) = dos_rovib_aqsm(i_bs)  
  Next i_bs
  ; end new section vs. 2.7
  ; now modified Beyer-Swinehart from Gilbert/Smith p. 157 starts
  For j_bs = 1 To n_well_vmodes(i_wells)
    If j <> j_bs  ; leave jth mode out
      If n_bs_well(i_wells) >= well_frequency(i_wells,j_bs)
        For i_bs = well_frequency(i_wells,j_bs) To n_bs_well(i_wells)
          dos_rad.d(j,i_bs) = dos_rad.d(j,i_bs) + dos_rad.d(j,i_bs-well_frequency(i_wells,j_bs))
        Next i_bs
      EndIf
    EndIf
  Next j_bs
  For i_bs = 0 To n_bs_well(i_wells)
    dos_rad.d(j,i_bs) = dos_rad.d(j,i_bs)*well_degen_corr(i_wells)
  Next i_bs
Return

;- resize window
resize_window:
  ResizeGadget(#Panel_0,#PB_Ignore, #PB_Ignore,WindowWidth(#Window_0)-58,WindowHeight(#Window_0)-142)
  For k = 0 To n_wells+n_ts+1
    ResizeGadget(#Editor_0+k,#PB_Ignore, #PB_Ignore,WindowWidth(#Window_0)-58,WindowHeight(#Window_0)-162)
  Next k
Return

;- read frequency scale factor
read_scale_factor:
  j = 0
  text$=Trunc(GetGadgetItemText(#Editor_1,j,0))
  If decimal_flag = 1
    text$=ReplaceString(text$,",",".")
  EndIf
  While j<CountGadgetItems(#Editor_1)
    If FindString(text$,"frequency scale factor:",1)
      Gosub parse
      Gosub parse
      Gosub parse
      Gosub parse
      freq_scale.d = ValD(parse$)
      If freq_scale.d <= 0 Or freq_scale.d > 2
        freq_scale.d = 1
        Ergebnis = MessageRequester("Error","Frequency scale factor out of bounds, reset to 1.",#PB_MessageRequester_Ok ) 
      EndIf
    EndIf
    j = j+1
    text$=Trunc(GetGadgetItemText(#Editor_1,j,0))
  Wend
  Return 
  
; new by MR
;- set all input parameters to zero
prepare_molecule_input:
  energy = 0.0
  read_freq(1) = 0.0
  read_int(1) = 0.0
  read_rot(1) = 0.0
Return
  
;- check molecule input
check_molecule_input:
    
  If energy.d < -0.1 ; valid electronic energy
    If Abs(read_freq(1)) < 0.001 And read_rot(1) > 0.001 ; no frequencies and no atom
      Ergebnis = MessageRequester("Error","No Frequencies could be read from the output file.",#PB_MessageRequester_Ok)
    Else
      Return
    EndIf
  EndIf
  
  If Abs(read_freq(1)) < 0.001 ; no frequencies (and invalid energy)
    If read_rot(1) < 0.001 ; atom
      Ergebnis = MessageRequester("Error","No Energy could be read from the output file. If you are using Gaussian, please ensure that your input file contains the mandatory FREQ key (even for an atom)!",#PB_MessageRequester_Ok ) 
    Else
      Ergebnis = MessageRequester("Error","No Energy could be read from the output file. Please check your output file!",#PB_MessageRequester_Ok ) 
    EndIf 
  Else ; frequencies are found and still no valid energy
    Ergebnis = MessageRequester("Error","No Energy could be read from the output file.",#PB_MessageRequester_Ok ) 
  EndIf
Return    
; end new by MR
  
  ;- Print Energies and Degeneracies
  print_energies_degeneracies:  ;new in vs.35.8
    SetGadgetState(#Panel_0,0)
    AddGadgetItem(#Editor_0,-1,"")
    AddGadgetItem(#Editor_0,-1,"          Degeneracy:      Relative Energy:")
      For i_wells = 0 To n_wells-1
          AddGadgetItem(#Editor_0,-1,"Well " + StrF(i_wells) + ":      " + StrF(well_degen_corr(i_wells)) + "             " +  StrF(well_relative(i_wells),4) + " cm-1")
      Next i_wells  
      For i_ts = 0 To n_ts-1
          AddGadgetItem(#Editor_0,-1,"TS " + StrF(i_ts) + ":        " + StrF(ts_degen_corr(i_ts)) +"             " + StrF(ts_relative(i_ts),4) + " cm-1      ")
      Next i_ts
    Return  
 
  ;- Print Diagnostics
  print_diagnostics:
    SetGadgetState(#Panel_0,0)
    AddGadgetItem(#Editor_0,-1,"")    
    If Iterative_MEM_flag = 1                    ;calculation runned with iterative MEM if = 1 or with start/continue MEM if = 0
      AddGadgetItem(#Editor_0,-1,"Calculated with Iterative MEM.    Last timestep(at 300K): " +StrF(dt300k,15) + " s   Reached convergence: " + StrF(convergence,15)+ "   Last Number of Iterations: " + StrF(iteration))
    ElseIf real_time_flag = 0
      AddGadgetItem(#Editor_0,-1,"Calculated with Start/Continue MEM. Timestep(at 300K): " +StrF(dt300k,15) + " s   Reached convergence: " + StrF(convergence,15)+ "   Last Number of Iterations: " + StrF(iteration))
    EndIf  
    AddGadgetItem(#Editor_0,-1,"")
    AddGadgetItem(#Editor_0,-1,"Populations in file "+Filename$+"_pop.txt")
    AddGadgetItem(#Editor_0,-1,"")
    ; write the rest in Filename_dia.txt file if set to YES in Parameter window: ;optional Diagnostics textfile is new in vs 3.56
    j = 0
    diagnostics_flag = 0
    text$=Trunc(GetGadgetItemText(#Editor_1,j,0))
    While j<CountGadgetItems(#Editor_1)
      If FindString(text$,"print diagnostics in .txt file (yes/no):",1)
        Repeat  ;read degeneracy-factor
          Gosub parse
        Until parse$ = "(yes/no):"
        Gosub parse
        If parse$ = "yes"
          diagnostics_flag = 1
        EndIf 
      EndIf
    j = j + 1
    text$=Trunc(GetGadgetItemText(#Editor_1,j,0))
    Wend
    If diagnostics_flag = 1
      AddGadgetItem(#Editor_0,-1,"Diagnostics in file "+Filename$+"_dia.txt")
      CreateFile(1,Filename$+"_dia.txt")      
      OpenFile(1,Filename$+"_dia.txt",#PB_File_Append)
      WriteStringN(1, "DIAGNOSTICS:"+Chr(13)+Chr(10)+"Parameters for last timestep at highest used temperature: T="+StrF(t_amb)+"K"  )
      ;WriteStringN(1, "fee_barrier = "+StrF(fee_barrier) + "          fee_FreeExchange = "+StrF(fee_FreeExchange)+Chr(13)+Chr(10))     ;include again if needed.
      WriteStringN(1, ""+Chr(13)+Chr(10)) 
      WriteStringN(1, "Total Energy      total_iso_depletion_SumAllWells:      Isomerisation"+Chr(13)+Chr(10)) ; new in vs 3.44
      total_en = total_en_start
      For i_fee = 1 To n_fee 
        line$ = "" 
        line$ = line$+LSet(StrD(total_en,2),15) 
        line$ = line$+LSet(science(total_iso_depletion_SumAllWells(i_fee),4),25) 
        If isomerisationtype(i_fee) = 1 ;new in vs 3.44
           WriteStringN(1, line$+ "    only within group")
        ElseIf isomerisationtype(i_fee) = 2 
           WriteStringN(1, line$+ "    via isomerisation channels") 
        ElseIf isomerisationtype(i_fee) = 3 
           WriteStringN(1, line$+ "    chemical equilibrium between all isomers") 
        EndIf   
        total_en = total_en + total_en_step
      Next i_fee
      WriteStringN(1, ""+Chr(13)+Chr(10))
      For i_wells = 0 To n_wells-1
        WriteStringN(1, "Well "+Str(i_wells)+Chr(13)+Chr(10))
        WriteStringN(1, "Total Energy   BS-Quantum     Population:         k_total_depletion:       k_total_iso_depletion:   Total_depletion:         Total_iso_depletion:"+Chr(13)+Chr(10) )
        total_en = total_en_start
        For i_fee = 1 To n_fee
          line$ = ""
          line$ = line$+LSet(StrD(total_en,2),15)
          line$ = line$+LSet(StrD(bs_quantum,2),15)
          line$ = line$+LSet(science(final_population(n_t_amb-1,i_wells,i_fee)/total_en_step,4),25)         
          line$ = line$+LSet(science(k_total_depletion(i_wells,i_fee),4),25)
          line$ = line$+LSet(science(k_total_iso_depletion(i_wells,i_fee),4),25)
          line$ = line$+LSet(science(total_depletion(i_wells,i_fee),4),25)
          line$ = line$+LSet(science(total_iso_depletion(i_wells,i_fee),4),25)
          WriteStringN(1, line$)
          total_en = total_en + total_en_step
        Next i_fee
        WriteStringN(1, ""+Chr(13)+Chr(10))
      Next i_wells      
      CloseFile(1)
    EndIf
    Return
; IDE Options = PureBasic 5.73 LTS (Windows - x64)
; CursorPosition = 79
; FirstLine = 72
; Folding = -
; Executable = ..\bin\AWATAR_1.0i.exe