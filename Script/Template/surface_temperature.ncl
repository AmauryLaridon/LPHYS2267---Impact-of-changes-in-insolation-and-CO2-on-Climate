begin
;All specific informations of the functions can been found in 
; https://www.ncl.ucar.edu/Document/Functions/list_alpha.shtml 

;*****begin read the input data**************
;---begin read the data of Control experiment
diri1 = "/elic/home/liuwe/LPHYS2267/"        ;the directory name for input data
file1 = "atmmmyl002400.PrI.nc"                            ;the file name for input data
infile1 = addfile(diri1+file1, "r")                       ;read input data
ts1   = infile1->ts                                       ;extract the variable
printVarSummary(ts1)                                      ;print the information of variable
;---end read the data of Control experiment
;---begin read the data of sensitivity experiment
diri2 = "/elic/home/liuwe/LPHYS2267/"
file2 = "atmmmyl002400.PrI_doub.nc"
infile2 = addfile(diri2+file2, "r")
ts2   = infile2->ts
printVarSummary(ts2)
;---end read the data of sensitivity experiment
;*****end read the input data**************
ts_clm = clmMonTLL(ts1)                             ;calculate the climatology of the entire period
;ts_clm = clmMonTLL(ts1(70*12:100*12-1,:,:))        ;here calculate the climatology with the last 30 years(71-100yr)
ts_anm = calcMonAnomTLL(ts2, ts_clm)                ;calculate the monthly anomaly with respect to the climatology

ts_ann = month_to_annual(ts_anm, 1)                 ;calculate the annual mean with the monthly anomalous data
ts_jja = month_to_season(ts_anm, "JJA")             ;calculate the summer mean with the monthly anomalous data
ts_djf = month_to_season(ts_anm, "DJF")             ;calculate the winter mean with the monthly anomalous data

out_ann = dim_avg_n_Wrap(ts_ann, 0)      ;calculate multi-year mean for plots
out_jja = dim_avg_n_Wrap(ts_jja, 0)
out_djf = dim_avg_n_Wrap(ts_djf, 0)

;*******plot************************
plot = new(3, graphic)       ;will plot 3 figures
   wks_type = "png"
   wks_type@wkWidth = 2500
   wks_type@wkHeight = 2500 
wks = gsn_open_wks(wks_type,"LPHYS_ts01") ;name of the figure
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
plot(0) = gsn_csm_contour_map(wks, out_ann, res)

res@gsnLeftString = "JJA"
plot(1) = gsn_csm_contour_map(wks, out_jja, res)

res@gsnLeftString = "DJF"
plot(2) = gsn_csm_contour_map(wks, out_djf, res)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
pres     = True
pres@gsnPanelMainString = "TEMPLATE FOR LPHYS SURFACE TEMPERATURE"
pres@gsnPanelLabelBar   = True  ;all figures use a common color bar
pres@gsnPanelFigureStrings = (/"(a)","(b)","(c)"/)
pres@amJust = "TopLeft"
pres@gsnPanelFigureStringsBackgroundFillColor = -1
pres@gsnPanelFigureStringsFontHeightF = 0.015

   gsn_panel(wks, plot, (/3,1/),pres)      ;3 raw and 1 colum, total 3 figures

end
