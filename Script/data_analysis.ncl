;############################################################################################################################
;############################################################################################################################
;# LOVECLIM Data Analysis
;# Author : Amaury Laridon & Élise Françoisse & Augustin Lambotte
;# Course : LPHYS2267 - Paleoclimate dynamics and modelling
;# Goal : Data analysis of LOVECLIM model in order to investigate the impacts of changes in insolation 
;#        and CO2 on climate
;#        More information on the GitHub Page of the project : https://github.com/AmauryLaridon/LPHYS2267---Impact-of-changes-in-insolation-and-CO2-on-Climate
;# Date : 07/05/23
;############################################################################################################################

begin
;All specific informations of the functions can been found in 
; https://www.ncl.ucar.edu/Document/Functions/list_alpha.shtml 

;######################################################## Data Extraction #########################################################

;### Data location ###
dir_loc_1 = "~/Bureau/LPHYS2267 - Paleoclimate Dynamics and Modelling/Projet/Data/Exercise1/"
dir_serv_CTL = "~/home/elic/alaridon/LPHYS2267/Project/LPHYS2267---Impact-of-changes-in-insolation-and-CO2-on-Climate/Data/CTL_run/"        ;the directory name for input data
dir_serv_1 = "~/home/elic/alaridon/LPHYS2267/Project/LPHYS2267---Impact-of-changes-in-insolation-and-CO2-on-Climate/Data/Exercise1/"        ;the directory name for input data
dir_serv_2 = "~/home/elic/alaridon/LPHYS2267/Project/LPHYS2267---Impact-of-changes-in-insolation-and-CO2-on-Climate/Data/Exercise2/"        ;the directory name for input data

;################# CONTROL RUN ##################
;### begin read the data of Control experiment 1 "Prec_PI" used for Exercice 1 and 2 ###
file1 = "atmmmwp002400.PrI.nc"                              ;the file name for input data
infile1 = addfile(dir_serv_CTL+file1, "r")                  ;read input data
ts_CTL   = infile1->ts                                      ;extract the variable
printVarSummary(ts_CTL)                                     ;print the information of variable

file2 = "CLIO3m.PrI002400.nc"                               ;the file name for input data
infile2 = addfile(dir_serv_CTL+file2, "r")                  ;read input data
sst_CTL   = infile2->sst                                    ;extract the variable
printVarSummary(sst_CTL)                                    ;print the information of variable
;### end read the data of Control experiment ###

;################# SENSITIVITY RUN ##################

;### begin read the data of Sensitivity experiment 2 with Precession for Exercice 1 ###
file3 = "atmmmwp002400.Stud1_prec.nc"
infile3 = addfile(dir_serv_1+file3, "r")
ts_PREC   = infile3->ts
printVarSummary(ts_PREC)

file4 = "CLIO3m.Stud1_prec002400.nc"
infile4 = addfile(dir_serv_1+file4, "r")
sst_PREC   = infile4->sst
printVarSummary(sst_PREC)

;### begin read the data of Sensitivity experiment 2 with Doubling CO_2 for Exercice 2 ###
file5 = "atmmmwp002400.PrI_doub.nc"
infile5 = addfile(dir_serv_2+file5, "r")
ts_CO2   = infile5->ts
printVarSummary(ts_CO2  )

file6 = "CLIO3m.PrI_doub002400.nc"
infile6 = addfile(dir_serv_2+file6, "r")
sst_CO2   = infile6->sst
printVarSummary(sst_CO2)
;###end read the data of sensitivity experiment ###

;######################################################## Data Analysis #########################################################

ts_CLM = clmMonTLL(ts_CTL(0*12:100*12-1,:,:))        ;here calculate the climatology with the last 30 years(71-100yr)
ts_anm_PREC = calcMonAnomTLL(ts_PREC, ts_CLM)        ;calculate the monthly anomaly with respect to the climatology
ts_anm_CO2 = calcMonAnomTLL(ts_CO2, ts_CLM)          ;calculate the monthly anomaly with respect to the climatology

ts_ann_anm_PREC = month_to_annual(ts_anm_PREC, 1)    ;calculate the annual mean with the monthly anomalous data
ts_ann_anm_CO2 = month_to_annual(ts_anm_CO2, 1)      ;calculate the annual mean with the monthly anomalous data

ts_jja_anm_PREC = month_to_season(ts_anm_PREC, "JJA")    ;calculate the summer mean with the monthly anomalous data
ts_djf_anm_PREC = month_to_season(ts_anm_PREC, "DJF")    ;calculate the winter mean with the monthly anomalous data
ts_jja_anm_CO2 = month_to_season(ts_anm_CO2, "JJA")      ;calculate the summer mean with the monthly anomalous data
ts_djf_anm_CO2 = month_to_season(ts_anm_CO2, "DJF")      ;calculate the winter mean with the monthly anomalous data

out_ann_PREC = dim_avg_n_Wrap(ts_ann_anm_PREC, 0)    ;calculate multi-year mean for plots
out_ann_CO2 = dim_avg_n_Wrap(ts_ann_anm_CO2, 0)      ;calculate multi-year mean for plots
out_jja_PREC = dim_avg_n_Wrap(ts_jja_anm_PREC, 0)
out_jja_CO2 = dim_avg_n_Wrap(ts_jja_anm_CO2, 0)
out_djf_PREC = dim_avg_n_Wrap(ts_djf_anm_PREC, 0)
out_djf_CO2 = dim_avg_n_Wrap(ts_djf_anm_CO2, 0)

;######################################################### Data Plot #########################################################

end