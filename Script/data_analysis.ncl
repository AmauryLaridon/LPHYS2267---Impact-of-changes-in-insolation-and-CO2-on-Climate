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
dir_serv_CTL = "~/home/elic/alaridon/LPHYS2267/Project/LPHYS2267---Impact-of-changes-in-insolation-and-CO2-on-Climate/Data/CTL_run/"        ;the directory name for input data
dir_loc_CTL = "~/Bureau/LPHYS2267 - Paleoclimate Dynamics and Modelling/Projet/Data/CTL_run/"                                               ;the directory name for input data

dir_serv_1 = "~/home/elic/alaridon/LPHYS2267/Project/LPHYS2267---Impact-of-changes-in-insolation-and-CO2-on-Climate/Data/Exercise1/"        ;the directory name for input data
dir_loc_1 = "~/Bureau/LPHYS2267 - Paleoclimate Dynamics and Modelling/Projet/Data/Exercise1/"                                               ;the directory name for input data

dir_serv_2 = "~/home/elic/alaridon/LPHYS2267/Project/LPHYS2267---Impact-of-changes-in-insolation-and-CO2-on-Climate/Data/Exercise2/"        ;the directory name for input data
dir_loc_2 = "~/Bureau/LPHYS2267 - Paleoclimate Dynamics and Modelling/Projet/Data/Exercise2/"                                               ;the directory name for input data


;################# CONTROL RUN ##################
;### begin read the data of Control experiment 1 "Prec_PI" used for Exercice 1 and 2 ###
file1 = "atmmmwp002400.PrI.nc"                              ;the file name for input data
; atmmmwp002400.PrI.nc is the monthly climatology for a hundred years and has 12 timesteps (the first entry is the January mean value for 100 years)
infile1 = addfile(dir_loc_CTL+file1, "r")                  ;read input data
ts_CTL   = infile1->ts                                      ;extract the variable
printVarSummary(ts_CTL)                                     ;print the information of variable

file2 = "CLIO3m.PrI002400.nc"                               ;the file name for input data
; CLIO3m.PrI002400.nc monthly data output for the ocean of a hundred years
infile2 = addfile(dir_loc_CTL+file2, "r")                  ;read input data
sst_CTL   = infile2->sst                                    ;extract the variable
printVarSummary(sst_CTL)                                    ;print the information of variable
;### end read the data of Control experiment ###

;################# SENSITIVITY RUN ##################

;### begin read the data of Sensitivity experiment 2 with Precession for Exercice 1 ###
file3 = "atmmmwp002400.Stud1_prec.nc"
infile3 = addfile(dir_loc_1+file3, "r")
ts_PREC   = infile3->ts
printVarSummary(ts_PREC)

file4 = "CLIO3m.Stud1_prec002400.nc"
infile4 = addfile(dir_loc_1+file4, "r")
sst_PREC   = infile4->sst
printVarSummary(sst_PREC)

;### begin read the data of Sensitivity experiment 2 with Doubling CO_2 for Exercice 2 ###
file5 = "atmmmwp002400.PrI_doub.nc"
infile5 = addfile(dir_loc_2+file5, "r")
ts_CO2   = infile5->ts
printVarSummary(ts_CO2  )

file6 = "CLIO3m.PrI_doub002400.nc"
infile6 = addfile(dir_loc_2+file6, "r")
sst_CO2   = infile6->sst
printVarSummary(sst_CO2)
;###end read the data of sensitivity experiment ###

;######################################################## Data Analysis #########################################################

ts_CLM = clmMonTLL(ts_CTL)                           ;calculate the climatology of the entire period for surface temperature. Calculates long term monthly means (monthly climatology) from monthly data (lat,lon,time version) 
;ts_CLM = clmMonTLL(ts_CTL(0*12:100*12-1,:,:))       ;here calculate the climatology with the last 30 years(71-100yr)
sst_CLM = clmMonTLL(sst_CTL)                         ;calculate the climatology of the entire period for surface temperature
ts_anm_PREC = calcMonAnomTLL(ts_PREC, ts_CLM)        ;calculate the monthly anomaly with respect to the climatology. Calculates monthly anomalies by subtracting the long term mean from each point (time,lat,lon version) 
ts_anm_CO2 = calcMonAnomTLL(ts_CO2, ts_CLM)          ;calculate the monthly anomaly with respect to the climatology
sst_anm_PREC = calcMonAnomTLL(sst_PREC, sst_CLM)     ;calculate the monthly anomaly with respect to the climatology
sst_anm_CO2 = calcMonAnomTLL(sst_CO2, sst_CLM)       ;calculate the monthly anomaly with respect to the climatology

ts_ann_anm_PREC = month_to_annual(ts_anm_PREC, 1)      ;calculate the annual mean with the monthly anomalous data. Converts monthly values to annual values. 
ts_ann_anm_CO2 = month_to_annual(ts_anm_CO2, 1)        ;calculate the annual mean with the monthly anomalous data
sst_ann_anm_PREC = month_to_annual(sst_anm_PREC, 1)    ;calculate the annual mean with the monthly anomalous data
sst_ann_anm_CO2 = month_to_annual(sst_anm_CO2, 1)      ;calculate the annual mean with the monthly anomalous data

ts_jja_anm_PREC = month_to_season(ts_anm_PREC, "JJA")    ;calculate the summer mean with the monthly anomalous data. Computes a user-specified three-month seasonal mean (DJF, JFM, FMA, MAM, AMJ, MJJ, JJA, JAS, ASO, SON, OND, NDJ). 
ts_djf_anm_PREC = month_to_season(ts_anm_PREC, "DJF")    ;calculate the winter mean with the monthly anomalous data
ts_jja_anm_CO2 = month_to_season(ts_anm_CO2, "JJA")      ;calculate the summer mean with the monthly anomalous data
ts_djf_anm_CO2 = month_to_season(ts_anm_CO2, "DJF")      ;calculate the winter mean with the monthly anomalous data
sst_jja_anm_PREC = month_to_season(sst_anm_PREC, "JJA")  ;calculate the summer mean with the monthly anomalous data
sst_djf_anm_PREC = month_to_season(sst_anm_PREC, "DJF")  ;calculate the winter mean with the monthly anomalous data
sst_jja_anm_CO2 = month_to_season(sst_anm_CO2, "JJA")    ;calculate the summer mean with the monthly anomalous data
sst_djf_anm_CO2 = month_to_season(sst_anm_CO2, "DJF")    ;calculate the winter mean with the monthly anomalous data

ts_out_ann_PREC = dim_avg_n_Wrap(ts_ann_anm_PREC, 0)      ;calculate multi-year mean for plots.  Computes the average of a variable's given dimensions at all other dimensions and retains metadata. 
ts_out_ann_CO2 = dim_avg_n_Wrap(ts_ann_anm_CO2, 0)        ;calculate multi-year mean for plots
sst_out_ann_PREC = dim_avg_n_Wrap(sst_ann_anm_PREC, 0)    ;calculate multi-year mean for plots
sst_out_ann_CO2 = dim_avg_n_Wrap(sst_ann_anm_CO2, 0)      ;calculate multi-year mean for plots

ts_out_jja_PREC = dim_avg_n_Wrap(ts_jja_anm_PREC, 0)
ts_out_jja_CO2 = dim_avg_n_Wrap(ts_jja_anm_CO2, 0)
sst_out_jja_PREC = dim_avg_n_Wrap(sst_jja_anm_PREC, 0)
sst_out_jja_CO2 = dim_avg_n_Wrap(sst_jja_anm_CO2, 0)

ts_out_djf_PREC = dim_avg_n_Wrap(ts_djf_anm_PREC, 0)
ts_out_djf_CO2 = dim_avg_n_Wrap(ts_djf_anm_CO2, 0)
sst_out_djf_PREC = dim_avg_n_Wrap(sst_djf_anm_PREC, 0)
sst_out_djf_CO2 = dim_avg_n_Wrap(sst_djf_anm_CO2, 0)

;######################################################### Data Plot #########################################################

;############################################# EXERCISE 1 #################################################

;########## 3 Panel Figure with anomaly of Surface Temperature for Exercice 1 PREC ##########

plot = new(3, graphic)       ;will plot 3 figures
   wks_type = "png"
   wks_type@wkWidth = 2500
   wks_type@wkHeight = 2500 
wks = gsn_open_wks(wks_type,"ts_PREC_1") ;name of the figure
gsn_define_colormap(wks, "MPL_Reds")    ;set the pattern of coloring 
;All specific informations of the resources can been found in 
;  https://www.ncl.ucar.edu/Document/Graphics/Resources/list_alpha_res.shtml
res                            = True
res@mpFillOn                  = False
res@mpOutlineOn               = True
res@tmXBLabelFontHeightF = 0.015
res@tmYLLabelFontHeightF = 0.015
res@cnFillOn           = True
res@cnLinesOn          = False
res@cnLineLabelsOn     = False
res@cnLevelSelectionMode = "ManualLevels"  ;manually set contour line
res@cnMaxLevelValF     = 12.               ;max value for contour line
res@cnMinLevelValF     = 0.              ;min value for contour line
res@cnLevelSpacingF    = 0.5               ;stride, the difference between the adjacent contour lines
res@lbBoxEndCapStyle   = "TriangleBothEnds"
res@lbLabelBarOn       = False             ;don't add color bars for single figure
res@gsnAddCyclic    = True

res@tiMainString  = ""
res@gsnDraw     = False
res@gsnFrame    = False
res@gsnZonalMean = True                   ;plot the zonal mean
res@gsnZonalMeanYRefLine = 0.
res@gsnZonalMeanXMinF = 0.
res@gsnZonalMeanXMaxF = 10.
res@gsnRightString = "~S~o~N~C"           ;use ~S~XX~N~ to set superscript in text
res@gsnLeftString = "ANN"
plot(0) = gsn_csm_contour_map(wks, ts_out_ann_PREC, res)

res@gsnLeftString = "JJA"
plot(1) = gsn_csm_contour_map(wks, ts_out_jja_PREC, res)

res@gsnLeftString = "DJF"
plot(2) = gsn_csm_contour_map(wks, ts_out_djf_PREC, res)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
pres     = True
pres@gsnPanelMainString = "SURFACE TEMPERATURE ANOMALY : PRECESSION - CTL RUN"
pres@gsnPanelLabelBar   = True  ;all figures use a common color bar
pres@gsnPanelFigureStrings = (/"(a)","(b)","(c)"/)
pres@amJust = "TopLeft"
pres@gsnPanelFigureStringsBackgroundFillColor = -1
pres@gsnPanelFigureStringsFontHeightF = 0.015

   gsn_panel(wks, plot, (/3,1/),pres)      ;3 raw and 1 colum, total 3 figures

;########## 3 Panel Figure with anomaly of Sea Surface Temperature for Exercice 1 PREC ##########

plot = new(3, graphic)       ;will plot 3 figures
   wks_type = "png"
   wks_type@wkWidth = 2500
   wks_type@wkHeight = 2500 
wks = gsn_open_wks(wks_type,"sst_PREC_1") ;name of the figure
gsn_define_colormap(wks, "MPL_Reds")    ;set the pattern of coloring 
;All specific informations of the resources can been found in 
;  https://www.ncl.ucar.edu/Document/Graphics/Resources/list_alpha_res.shtml
res                            = True
res@mpFillOn                  = False
res@mpOutlineOn               = True
res@tmXBLabelFontHeightF = 0.015
res@tmYLLabelFontHeightF = 0.015
res@cnFillOn           = True
res@cnLinesOn          = False
res@cnLineLabelsOn     = False
res@cnLevelSelectionMode = "ManualLevels"  ;manually set contour line
res@cnMaxLevelValF     = 12.               ;min value for contour line
res@cnMinLevelValF     = 0.              ;max value for contour line
res@cnLevelSpacingF    = 0.5               ;stride, the difference between the adjacent contour lines
res@lbBoxEndCapStyle   = "TriangleBothEnds"
res@lbLabelBarOn       = False             ;don't add color bars for single figure
res@gsnAddCyclic    = True

res@tiMainString  = ""
res@gsnDraw     = False
res@gsnFrame    = False
res@gsnZonalMean = True                   ;plot the zonal mean
res@gsnZonalMeanYRefLine = 0.
res@gsnZonalMeanXMinF = 0.
res@gsnZonalMeanXMaxF = 10.
res@gsnRightString = "~S~o~N~C"           ;use ~S~XX~N~ to set superscript in text
res@gsnLeftString = "ANN"
plot(0) = gsn_csm_contour_map(wks, sst_out_ann_PREC, res)

res@gsnLeftString = "JJA"
plot(1) = gsn_csm_contour_map(wks, sst_out_jja_PREC, res)

res@gsnLeftString = "DJF"
plot(2) = gsn_csm_contour_map(wks, sst_out_djf_PREC, res)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
pres     = True
pres@gsnPanelMainString = "SEA SURFACE TEMPERATURE ANOMALY : PRECESSION - CTL RUN"
pres@gsnPanelLabelBar   = True  ;all figures use a common color bar
pres@gsnPanelFigureStrings = (/"(a)","(b)","(c)"/)
pres@amJust = "TopLeft"
pres@gsnPanelFigureStringsBackgroundFillColor = -1
pres@gsnPanelFigureStringsFontHeightF = 0.015

   gsn_panel(wks, plot, (/3,1/),pres)      ;3 raw and 1 colum, total 3 figures


;############################################# EXERCISE 2 #################################################

;########## 3 Panel Figure with anomaly of Surface Temperature for Exercice 2 CO2 ##########

plot = new(3, graphic)       ;will plot 3 figures
   wks_type = "png"
   wks_type@wkWidth = 2500
   wks_type@wkHeight = 2500 
wks = gsn_open_wks(wks_type,"ts_CO2_1") ;name of the figure
gsn_define_colormap(wks, "MPL_Reds")    ;set the pattern of coloring 
;All specific informations of the resources can been found in 
;  https://www.ncl.ucar.edu/Document/Graphics/Resources/list_alpha_res.shtml
res                            = True
res@mpFillOn                  = False
res@mpOutlineOn               = True
res@tmXBLabelFontHeightF = 0.015
res@tmYLLabelFontHeightF = 0.015
res@cnFillOn           = True
res@cnLinesOn          = False
res@cnLineLabelsOn     = False
res@cnLevelSelectionMode = "ManualLevels"  ;manually set contour line
res@cnMaxLevelValF     = 12.               ;min value for contour line
res@cnMinLevelValF     = 0.              ;max value for contour line
res@cnLevelSpacingF    = 0.5               ;stride, the difference between the adjacent contour lines
res@lbBoxEndCapStyle   = "TriangleBothEnds"
res@lbLabelBarOn       = False             ;don't add color bars for single figure
res@gsnAddCyclic    = True

res@tiMainString  = ""
res@gsnDraw     = False
res@gsnFrame    = False
res@gsnZonalMean = True                   ;plot the zonal mean
res@gsnZonalMeanYRefLine = 0.
res@gsnZonalMeanXMinF = 0.
res@gsnZonalMeanXMaxF = 10.
res@gsnRightString = "~S~o~N~C"           ;use ~S~XX~N~ to set superscript in text
res@gsnLeftString = "ANN"
plot(0) = gsn_csm_contour_map(wks, ts_out_ann_CO2, res)

res@gsnLeftString = "JJA"
plot(1) = gsn_csm_contour_map(wks, ts_out_jja_CO2, res)

res@gsnLeftString = "DJF"
plot(2) = gsn_csm_contour_map(wks, ts_out_djf_CO2, res)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
pres     = True
pres@gsnPanelMainString = "SURFACE TEMPERATURE ANOMALY : CO2 - CTL RUN"
pres@gsnPanelLabelBar   = True  ;all figures use a common color bar
pres@gsnPanelFigureStrings = (/"(a)","(b)","(c)"/)
pres@amJust = "TopLeft"
pres@gsnPanelFigureStringsBackgroundFillColor = -1
pres@gsnPanelFigureStringsFontHeightF = 0.015

   gsn_panel(wks, plot, (/3,1/),pres)      ;3 raw and 1 colum, total 3 figures

;########## 3 Panel Figure with anomaly of Sea Surface Temperature for Exercice 2 CO2 ##########

plot = new(3, graphic)       ;will plot 3 figures
   wks_type = "png"
   wks_type@wkWidth = 2500
   wks_type@wkHeight = 2500 
wks = gsn_open_wks(wks_type,"sst_CO2_1") ;name of the figure
gsn_define_colormap(wks, "MPL_Reds")    ;set the pattern of coloring 
;All specific informations of the resources can been found in 
;  https://www.ncl.ucar.edu/Document/Graphics/Resources/list_alpha_res.shtml
res                            = True
res@mpFillOn                  = False
res@mpOutlineOn               = True
res@tmXBLabelFontHeightF = 0.015
res@tmYLLabelFontHeightF = 0.015
res@cnFillOn           = True
res@cnLinesOn          = False
res@cnLineLabelsOn     = False
res@cnLevelSelectionMode = "ManualLevels"  ;manually set contour line
res@cnMaxLevelValF     = 12.               ;min value for contour line
res@cnMinLevelValF     = 0.              ;max value for contour line
res@cnLevelSpacingF    = 0.5               ;stride, the difference between the adjacent contour lines
res@lbBoxEndCapStyle   = "TriangleBothEnds"
res@lbLabelBarOn       = False             ;don't add color bars for single figure
res@gsnAddCyclic    = True

res@tiMainString  = ""
res@gsnDraw     = False
res@gsnFrame    = False
res@gsnZonalMean = True                   ;plot the zonal mean
res@gsnZonalMeanYRefLine = 0.
res@gsnZonalMeanXMinF = 0.
res@gsnZonalMeanXMaxF = 10.
res@gsnRightString = "~S~o~N~C"           ;use ~S~XX~N~ to set superscript in text
res@gsnLeftString = "ANN"
plot(0) = gsn_csm_contour_map(wks, sst_out_ann_CO2, res)

res@gsnLeftString = "JJA"
plot(1) = gsn_csm_contour_map(wks, sst_out_jja_CO2, res)

res@gsnLeftString = "DJF"
plot(2) = gsn_csm_contour_map(wks, sst_out_djf_CO2, res)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
pres     = True
pres@gsnPanelMainString = "SEA SURFACE TEMPERATURE ANOMALY : CO2 - CTL RUN"
pres@gsnPanelLabelBar   = True  ;all figures use a common color bar
pres@gsnPanelFigureStrings = (/"(a)","(b)","(c)"/)
pres@amJust = "TopLeft"
pres@gsnPanelFigureStringsBackgroundFillColor = -1
pres@gsnPanelFigureStringsFontHeightF = 0.015

   gsn_panel(wks, plot, (/3,1/),pres)      ;3 raw and 1 colum, total 3 figures




end