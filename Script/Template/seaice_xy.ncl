begin
;All specific informations of the functions can been found in 
; https://www.ncl.ucar.edu/Document/Functions/list_alpha.shtml 

;*****begin read the input data**************
;---begin read the data of Control experiment
diri1 = "/elic/home/liuwe/LPHYS2267/"                     ;the directory name for input data
file1 = "CLIO3m.PrI002400.nc"                            ;the file name for input data, the ocean grid has been coverted to latlon grid
infile1 = addfile(diri1+file1, "r")                          ;read input data
ice11   = infile1->albq                                      ;extract the variable
print(ice11(0,{-85},0))
print(ice11(0,{0},0))
sst11   = infile1->sst
print(sst11(0,{-85},0))
print(sst11(0,{0},0))

ice1 = where(sst11.lt.-50., ice11@_FillValue, ice11)         ;if one grid is with <-50degreeC SST, it must be a land grid
ice1 = where(ice1.lt.0., 0., ice1)                           ;if one grid is with <0 seaice fraction and normal SST, it's a ice-free grid
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
ice_clm1 = clmMonTLL(ice1)         ;calculate the climatology of the entire period
ice_clm2 = clmMonTLL(ice2)         


lat = ice_clm1&lat
rad    = 4.0*atan(1.0)/180.0
clat   = cos(lat*rad)                                 ;use the cosine of the latitudes to be the weighting
clat!0 = "lat"
clat&lat = lat                                        ;set coordinate for the variable
ice_nh1 = wgt_areaave_Wrap(ice_clm1(:,{60:90},:), clat({60:90}), 1.0, 1)  ;compute the weighted area mean for Arctic
ice_sh1 = wgt_areaave_Wrap(ice_clm1(:,{-90:-60},:), clat({-90:-60}), 1.0, 1) ;for Antarctic

ice_nh2 = wgt_areaave_Wrap(ice_clm2(:,{60:90},:), clat({60:90}), 1.0, 1)  ;compute the weighted area mean for Arctic
ice_sh2 = wgt_areaave_Wrap(ice_clm2(:,{-90:-60},:), clat({-90:-60}), 1.0, 1) ;for Antarctic



;*******plot************************
plot = new(4, graphic)       ;will plot 4 figures
   wks_type = "png"
   wks_type@wkWidth = 2500
   wks_type@wkHeight = 2500 
wks = gsn_open_wks(wks_type,"LPHYS_seaice02") ;name of the figure
;All specific informations of the resources can been found in 
;  https://www.ncl.ucar.edu/Document/Graphics/Resources/list_alpha_res.shtml
res                            = True
res@gsnDraw = False
res@gsnFrame = False
res@trYMinF = 0.
res@trYMaxF = 1.
res@xyLineColor = "black"
res@gsnXYBarChart = True
res@gsnXYBarChartBarWidth = 0.75
res@tiYAxisString = "SEA-ICE CONCENTRATION"           ; y axis title
res@tmXBMode    = "Explicit"        ; explicit X axis labels
res@tmXBValues     = ispan(1,12,1)
res@tmXBLabels = (/"Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"/)
res@tmXTOn = False
res@gsnRightString = ""
res@gsnLeftString = "Arctic MEAN SEC-ICE CONCENTRATION IN EXP1"
res@gsnAboveYRefLineColor = "red"
plot(0) = gsn_csm_xy(wks,ispan(1,12,1),ice_nh1,res)
res@gsnLeftString = "Antarctic MEAN SEC-ICE CONCENTRATION IN EXP1"
res@gsnAboveYRefLineColor = "blue"
plot(1) = gsn_csm_xy(wks,ispan(1,12,1),ice_sh1,res)
res@gsnLeftString = "Arctic MEAN SEC-ICE CONCENTRATION IN EXP2"
res@gsnAboveYRefLineColor = "red"
plot(2) = gsn_csm_xy(wks,ispan(1,12,1),ice_nh2,res)
res@gsnLeftString = "Antarctic MEAN SEC-ICE CONCENTRATION IN EXP2"
res@gsnAboveYRefLineColor = "blue"
plot(3) = gsn_csm_xy(wks,ispan(1,12,1),ice_sh2,res)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
pres     = True
pres@gsnPanelMainString = "TEMPLATE FOR LPHYS AREA MEAN SEA-ICE CONCENTRATION"
pres@gsnPanelFigureStrings = (/"(a)","(b)","(c)","(d)"/)
pres@gsnPanelFigureStringsPerimOn = False
pres@amJust = "TopLeft"
pres@gsnPanelFigureStringsBackgroundFillColor = -1
pres@gsnPanelFigureStringsFontHeightF = 0.015

   gsn_panel(wks, plot, (/2,2/),pres)      ;2 raw and 2 colum, total 4 figures

end
