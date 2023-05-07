begin
;All specific informations of the functions can been found in 
; https://www.ncl.ucar.edu/Document/Functions/list_alpha.shtml 

;*****begin read the input data**************
;---begin read the data of Control experiment
diri1 = "/elic/home/liuwe/LPHYS2267/"        ;the directory name for input data
file1 = "atmmmyl002400.PrI.nc"                            ;the file name for input data
infile1 = addfile(diri1+file1, "r")                       ;read input data
pp11   = infile1->pp                                      ;extract the variable
pp1 = pp11*10/360                                         ;cm/yr->mm/day
copy_VarMeta(pp11, pp1)                                   ;copy all attributes and coordinate to new variable
pp1@units = "mm/day"
printVarSummary(pp1)                                      ;print the information of variable
printMinMax(pp1,1)                                        ;print the minimum and maximum of all values
;---end read the data of Control experiment
;---begin read the data of sensitivity experiment
diri2 = "/elic/home/liuwe/LPHYS2267/"
file2 = "atmmmyl002400.PrI_doub.nc"
infile2 = addfile(diri2+file2, "r")
pp22   = infile2->pp
pp2 = pp22*10/360
copy_VarMeta(pp22, pp2)
pp2@units = "mm/day"
printVarSummary(pp2)
;---end read the data of sensitivity experiment
;*****end read the input data**************
pp_clm = clmMonTLL(pp1)                             ;calculate the climatology of the entire period
;pp_clm = clmMonTLL(pp1(70*12:100*12-1,:,:))        ;calculate the climatology with the last 30 years(71-100yr)
pp_anm = calcMonAnomTLL(pp2, pp_clm)                ;calculate the monthly anomaly with respect to the climatology

pp_ann = month_to_annual(pp_anm, 1)                 ;calculate the annual mean with the monthly anomalous data
pp_jja = month_to_season(pp_anm, "JJA")             ;calculate the summer mean with the monthly anomalous data
pp_djf = month_to_season(pp_anm, "DJF")             ;calculate the winter mean with the monthly anomalous data

out_ann = dim_avg_n_Wrap(pp_ann, 0)      ;calculate multi-year mean for plopp
out_jja = dim_avg_n_Wrap(pp_jja, 0)
out_djf = dim_avg_n_Wrap(pp_djf, 0)

;*******plot************************
plot = new(3, graphic)       ;will plot 3 figures
   wks_type = "png"
   wks_type@wkWidth = 2500
   wks_type@wkHeight = 2500 
wks = gsn_open_wks(wks_type,"LPHYS_pp01") ;name of the figure
gsn_define_colormap(wks, "precip_diff_12lev")    ;set the pattern of coloring 
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
res@cnMaxLevelValF     = 1.               ;min value for contour line
res@cnMinLevelValF     = -1.              ;max value for contour line
res@cnLevelSpacingF    = 0.2               ;stride, the difference between the adjacent contour lines
res@lbBoxEndCapStyle   = "TriangleBothEnds"
res@lbLabelBarOn       = False             ;don't add color bars for single figure
res@gsnAddCyclic    = True

res@tiMainString  = ""
res@gsnDraw     = False
res@gsnFrame    = False
res@gsnZonalMean = True                   ;plot the zonal mean
res@gsnZonalMeanYRefLine = 0.
res@gsnZonalMeanXMinF = -0.5
res@gsnZonalMeanXMaxF = 0.5
;res@gsnRightstring = "mm/day"
out_ann@long_name = "ANN"
;res@gsnLeftstring = "ANN"
plot(0) = gsn_csm_contour_map(wks, out_ann, res)
out_jja@long_name = "JJA"
;res@gsnLeftstring = "JJA"
plot(1) = gsn_csm_contour_map(wks, out_jja, res)
out_djf@long_name = "DJF"
;res@gsnLeftstring = "DJF"
plot(2) = gsn_csm_contour_map(wks, out_djf, res)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
pres     = True
pres@gsnPanelMainString = "TEMPLATE FOR LPHYS PRECIPITATION"
pres@gsnPanelLabelBar   = True  ;all figures use a common color bar
pres@gsnPanelFigureStrings = (/"(a)","(b)","(c)"/)
pres@amJust = "TopLeft"
pres@gsnPanelFigureStringsBackgroundFillColor = -1
pres@gsnPanelFigureStringsFontHeightF = 0.015

   gsn_panel(wks, plot, (/3,1/),pres)      ;3 raw and 1 colum, total 3 figures

end
