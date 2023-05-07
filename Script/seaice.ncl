begin
;All specific informations of the functions can been found in 
; https://www.ncl.ucar.edu/Document/Functions/list_alpha.shtml 

;*****begin read the input data**************
;---begin read the data of Control experiment
diri1 = "/elic/home/liuwe/LPHYS2267/"                     ;the directory name for input data
file1 = "CLIO3m.PrI002400.nc"                            ;the file name for input data, the ocean grid has been coverted to latlon grid
infile1 = addfile(diri1+file1, "r")                          ;read input data
ice11   = infile1->albq                                      ;extract the variable
sst11   = infile1->sst

ice1 = where(sst11.lt.-50., ice11@_FillValue, ice11)         ;if one grid is with <-50degreeC SST, it must be a land grid
ice1 = where(ice1.lt.0., 0., ice1)                           ;if one grid is with <0 sea-ice fraction and normal SST, it's a ice-free grid
copy_VarMeta(ice11, ice1)                                    ;copy all attributes and coordinate to new variable
printVarSummary(ice1)                                        ;print the information of variable
;---end read the data of Control experiment
;---begin read the data of sensitivity experiment
diri2 = "/elic/home/liuwe/LPHYS2267/"
file2 = "CLIO3m.PrI_doub002400.nc"
infile2 = addfile(diri2+file2, "r")
ice22   = infile2->albq
ice2 = where(sst11.lt.-50., ice22@_FillValue, ice22)         ;if one grid is with <-50degreeC SST, it must be a land grid
ice2 = where(ice2.lt.0., 0., ice2)                           ;if one grid is with <0 sea-ice fraction and normal SST, it's a ice-free grid
copy_VarMeta(ice22, ice2)                                    ;copy all attributes and coordinate to new variable
printVarSummary(ice2)
;---end read the data of sensitivity experiment
;*****end read the input data**************
ice_clm = clmMonTLL(ice1)        ;calculate the climatology of the entire period
;ice_clm = clmMonTLL(ice1(70*12:100*12-1,:,:))        ;calculate the climatology with the last 30 years(71-100yr)
ice_anm = calcMonAnomTLL(ice2, ice_clm)               ;calculate the monthly anomaly with respect to the climatology

ice_ann = month_to_annual(ice_anm, 1)                 ;calculate the annual mean with the monthly anomalous data
ice_jja = month_to_season(ice_anm, "JJA")             ;calculate the summer mean with the monthly anomalous data
ice_djf = month_to_season(ice_anm, "DJF")             ;calculate the winter mean with the monthly anomalous data

out_ann = dim_avg_n_Wrap(ice_ann, 0)       ;calculate multi-year mean for plots
out_jja = dim_avg_n_Wrap(ice_jja, 0)
out_djf = dim_avg_n_Wrap(ice_djf, 0)

printMinMax(out_ann, 1)

;*******plot************************
plot = new(6, graphic)       ;will plot 6 figures
   wks_type = "png"
   wks_type@wkWidth = 2500
   wks_type@wkHeight = 2500 
wks = gsn_open_wks(wks_type,"LPHYS_seaice01") ;name of the figure
gsn_define_colormap(wks, "precip3_16lev")    ;set the pattern of coloring 
gsn_reverse_colormap(wks)                 ;reverse the pattern of coloring 
;All specific informations of the resources can been found in 
;  https://www.ncl.ucar.edu/Document/Graphics/Resources/list_alpha_res.shtml
res                            = True
res@mpFillOn                  = False
res@mpOutlineOn               = True
res@gsnPolarLabelFontHeightF = 0.02
res@cnFillOn           = True
res@cnLinesOn          = False
res@cnLineLabelsOn     = False
res@cnFillMode         = "CellFill"        ;directly fill the grids rather than the area between contour lines 
res@cnLevelSelectionMode = "ManualLevels"  ;manually set contour line
res@cnMaxLevelValF     = 0.               ;min value for contour line
res@cnMinLevelValF     = -0.8              ;max value for contour line
res@cnLevelSpacingF    = 0.05               ;stride, the difference between the adjacent contour lines
res@lbBoxEndCapStyle   = "TriangleBothEnds"
res@lbLabelBarOn       = False             ;don't add color bars for single figure
res@gsnAddCyclic    = True
res@cnFillDrawOrder = "PreDraw"

res@tiMainString  = ""
res@gsnDraw     = False
res@gsnFrame    = False

res@gsnRightString = "fraction"

res@gsnPolar      = "NH"    ;plot the Stereographic Projection map for NH
res@mpMinLatF     = 40      ;minimum lat to plot for NH
res@mpMaxLatF     = 90      ;maximum lat to plot for NH
res@gsnLeftString = "ANN"
plot(0) = gsn_csm_contour_map_polar(wks, out_ann, res)
res@gsnRightString = ""
res@gsnLeftString = "JJA"
plot(1) = gsn_csm_contour_map_polar(wks, out_jja, res)
res@gsnLeftString = "DJF"
plot(2) = gsn_csm_contour_map_polar(wks, out_djf, res)

res@gsnPolar      = "SH"    ;plot the Stereographic Projection map for NH
res@mpMinLatF     = -90     ;minimum lat to plot for SH
res@mpMaxLatF     = -40     ;maximum lat to plot for SH
res@gsnLeftString = "ANN"
plot(3) = gsn_csm_contour_map_polar(wks, out_ann, res)
res@gsnLeftString = "JJA"
plot(4) = gsn_csm_contour_map_polar(wks, out_jja, res)
res@gsnLeftString = "DJF"
plot(5) = gsn_csm_contour_map_polar(wks, out_djf, res)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
pres     = True
pres@gsnPanelMainString = "TEMPLATE FOR LPHYS SEA-ICE CONCENTRATION"
pres@gsnPanelLabelBar   = True  ;all figures use a common color bar
pres@gsnPanelFigureStrings = (/"(a)","(b)","(c)","(d)","(e)","(f)"/)
pres@gsnPanelFigureStringsPerimOn = False
pres@amJust = "TopLeft"
pres@gsnPanelFigureStringsBackgroundFillColor = -1
pres@gsnPanelFigureStringsFontHeightF = 0.015

   gsn_panel(wks, plot, (/2,3/),pres)      ;2 raw and 3 colum, total 6 figures

end
