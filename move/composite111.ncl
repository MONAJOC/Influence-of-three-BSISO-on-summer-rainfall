f  = addfile("/home/cuixy/Desktop/K-means/data/preAnom.nc","r")
f1 = addfile("/home/cuixy/Desktop/K-means/olrAnom.nc","r")
cdate = asciiread("/home/cuixy/Desktop/K-means/centraldate.csv", -1, "integer")  ;central date
c1 = asciiread("/home/cuixy/Desktop/K-means/cluster/BSclus1.csv", -1, "integer")
c2 = asciiread("/home/cuixy/Desktop/K-means/cluster/BSclus2.csv", -1, "integer")
c3 = asciiread("/home/cuixy/Desktop/K-means/cluster/BSclus3.csv", -1, "integer")

diri = "/home/cuixy/Desktop/DATA/UWND/30-80uwnd/"
files = systemfunc("ls " + diri + "ERA5_daily_u*.nc")
fstu = addfiles(files,"r")
diri = "/home/cuixy/Desktop/DATA/VWND/30-80vwnd/"
files = systemfunc("ls " + diri + "ERA5_daily_v*.nc")
fstv = addfiles(files,"r")

pre  = f->pre(:,{15:40},{95:135})
time    = pre&time
ymdhms  = cd_calendar(time, 0)
iyear   = floattoint( ymdhms(:,0) )
imon    = floattoint( ymdhms(:,1) )   
nt = ind(imon.ge.5.and.imon.le.8)
delete([/pre@long_name/])

date1 = new((/5*dimsizes(c1),6/),integer)
date2 = new((/5*dimsizes(c2),6/),integer)
date3 = new((/5*dimsizes(c3),6/),integer)
c = (/0,0,0,0,0,0/)
cdate1 = cdate(c1)
do n = 0,dimsizes(cdate1)-1
    c(0) = cdate1(n)-10
    c(1) = cdate1(n)-5
    c(2) = cdate1(n)
    c(3) = cdate1(n) + 5
    c(4) = cdate1(n) + 10
    c(5) = cdate1(n) + 15 
    do i = 0,dimsizes(c)-1
        do j = 0,4,1
            date1(5*n+j,i) = c(i)+j-2
        end do
    end do
    c = 0
end do

cdate2 = cdate(c2)
do n = 0,dimsizes(cdate2)-1
    c(0) = cdate2(n)-10
    c(1) = cdate2(n)-5
    c(2) = cdate2(n)
    c(3) = cdate2(n) + 5
    c(4) = cdate2(n) + 10
    c(5) = cdate2(n) + 15 
    do i = 0,dimsizes(c)-1
        do j = 0,4,1
            date2(5*n+j,i) = c(i)+j-2
        end do
    end do
    c = 0
end do
cdate3 = cdate(c3)
do n = 0,dimsizes(cdate3)-1
    c(0) = cdate3(n)-10
    c(1) = cdate3(n)-5
    c(2) = cdate3(n)
    c(3) = cdate3(n) + 5
    c(4) = cdate3(n) + 10
    c(5) = cdate3(n) + 15 
    do i = 0,dimsizes(c)-1
        do j = 0,4,1
            date3(5*n+j,i) = c(i)+j-2
        end do
    end do
    c = 0
end do
delete([/cdate1,cdate2,cdate3/])

pavr  = new((/3,6,dimsizes(pre&lat),dimsizes(pre&lon)/),float)
do n = 0, 5
    pavr(0,n,:,:) = dim_stddev_n(pre(date1(:,n),:,:),0)
end do
do n = 0, 5
    pavr(1,n,:,:) = dim_stddev_n(pre(date2(:,n),:,:),0)
end do
do n = 0, 5
    pavr(2,n,:,:) = dim_stddev_n(pre(date3(:,n),:,:),0)
end do

pdata = new((/dimsizes(cdate),6,dimsizes(pre&lat),dimsizes(pre&lon)/),float)
pdata!0 = "event"
pdata!1 = "pentad"
copy_VarCoords(pre(0,:,:), pdata(0,0,:,:))
c = (/0,0,0,0,0,0/)
copy_VarCoords(pre(0,:,:), pdata(0,0,:,:))
do n = 0,dimsizes(cdate)-1
    do j = 0,5
        c(j) = cdate(n) + (j-2)*5
    end do
    do i = 0,dimsizes(c)-1
        pdata(n,i,:,:) = dim_avg_n(pre((c(i)-2):(c(i)+2),:,:),0)
    end do
    c = 0
end do
;pre sig
ave2 = dim_avg_n_Wrap(pre(nt,:,:), 0)
avr2 = dim_stddev_n_Wrap(pre(nt,:,:), 0)
s2 = dimsizes(nt)
delete(pre)

u    = fstu[:]->u(:,:,:,:)
u   := u(:,{850},:,:)
v    = fstv[:]->v(:,:,:,:)
v   := v(:,{850},:,:)
delete([/u@long_name,v@long_name,u@units,v@units/])

uavr  = new((/3,6,dimsizes(u&latitude),dimsizes(u&longitude)/),float)
do n = 0, 5
    uavr(0,n,:,:) = dim_stddev_n(u(date1(:,n),:,:),0)
end do
do n = 0, 5
    uavr(1,n,:,:) = dim_stddev_n(u(date2(:,n),:,:),0)
end do
do n = 0, 5
    uavr(2,n,:,:) = dim_stddev_n(u(date3(:,n),:,:),0)
end do

vavr  = new((/3,6,dimsizes(u&latitude),dimsizes(u&longitude)/),float)
do n = 0, 5
    vavr(0,n,:,:) = dim_stddev_n(v(date1(:,n),:,:),0)
end do
do n = 0, 5
    vavr(1,n,:,:) = dim_stddev_n(v(date2(:,n),:,:),0)
end do
do n = 0, 5
    vavr(2,n,:,:) = dim_stddev_n(v(date3(:,n),:,:),0)
end do

pdatauv = new((/dimsizes(cdate),6,2,dimsizes(u&latitude),dimsizes(u&longitude)/),float)
pdatauv!0 = "event"
pdatauv!1 = "pentad"
copy_VarCoords(u(0,:,:), pdatauv(0,0,0,:,:))
c = (/0,0,0,0,0,0/)
copy_VarCoords(u(0,:,:), pdatauv(0,0,0,:,:))
do n = 0,dimsizes(cdate)-1
    do j = 0,5
        c(j) = cdate(n) + (j-2)*5
    end do
    do i = 0,dimsizes(c)-1
        pdatauv(n,i,0,:,:) = dim_avg_n(u((c(i)-2):(c(i)+2),:,:),0)
        pdatauv(n,i,1,:,:) = dim_avg_n(v((c(i)-2):(c(i)+2),:,:),0)
    end do
    c = 0
end do
;u&vsig
ave3 = dim_avg_n_Wrap(u(nt,:,:), 0)
avr3 = dim_stddev_n_Wrap(u(nt,:,:), 0)
ave4 = dim_avg_n_Wrap(v(nt,:,:), 0)
avr4 = dim_stddev_n_Wrap(v(nt,:,:), 0)
delete([/u,v/])

olr  = f1->olr(:,{-15:40},{60:160})
pdataolr = new((/dimsizes(cdate),6,dimsizes(olr&lat),dimsizes(olr&lon)/),float)
pdataolr!0 = "event"
pdataolr!1 = "pentad"
copy_VarCoords(olr(0,:,:), pdataolr(0,0,:,:))
c = (/0,0,0,0,0,0/)
copy_VarCoords(olr(0,:,:), pdataolr(0,0,:,:))
do n = 0,dimsizes(cdate)-1
    do j = 0,5
        c(j) = cdate(n) + (j-2)*5
    end do
    do i = 0,dimsizes(c)-1
        pdataolr(n,i,:,:) = dim_avg_n(olr((c(i)-2):(c(i)+2),:,:),0)
    end do
    c = 0
end do
olr1 = olr
delete(olr)

;olr sig
ave5 = dim_avg_n_Wrap(olr1(nt,:,:), 0)
avr5 = dim_stddev_n_Wrap(olr1(nt,:,:), 0)

;olr
olra = new((/3,6,dimsizes(pdataolr&lat),dimsizes(pdataolr&lon)/),float)
olra!0 = "cluster"
olra!1 = "pentad"
copy_VarCoords(pdataolr(0,0,:,:), olra(0,0,:,:))
olra(0,:,:,:) = dim_avg_n(pdataolr(c1,:,:,:),0)
olra(1,:,:,:) = dim_avg_n(pdataolr(c2,:,:,:),0)
olra(2,:,:,:) = dim_avg_n(pdataolr(c3,:,:,:),0)
delete(pdataolr)
;pre
olr = new((/3,6,dimsizes(pdata&lat),dimsizes(pdata&lon)/),float)
olr!0 = "cluster"
olr!1 = "pentad"
copy_VarCoords(pdata(0,0,:,:), olr(0,0,:,:))
olr(0,:,:,:) = dim_avg_n(pdata(c1,:,:,:),0)
olr(1,:,:,:) = dim_avg_n(pdata(c2,:,:,:),0)
olr(2,:,:,:) = dim_avg_n(pdata(c3,:,:,:),0)
delete(pdata)
;uv
uv = new((/3,6,2,dimsizes(pdatauv&latitude),dimsizes(pdatauv&longitude)/),float)
uv!0 = "cluster"
uv!1 = "pentad"
copy_VarCoords(pdatauv(0,0,:,:,:), uv(0,0,:,:,:))
uv(0,:,:,:,:) = dim_avg_n(pdatauv(c1,:,:,:,:),0)
uv(1,:,:,:,:) = dim_avg_n(pdatauv(c2,:,:,:,:),0)
uv(2,:,:,:,:) = dim_avg_n(pdatauv(c3,:,:,:,:),0)
delete(pdatauv)

;plot

polyx   = (/110,122,122,110,110,110/)
polyy   = (/28,28,34,34,28,34/)

res = True
res@gsnDraw              = False        
res@gsnFrame             = False       
res@gsnMaximize          = False
res@mpFillOn             = True
res@mpMinLatF            = -10         
res@mpMaxLatF            = 40
res@mpMinLonF            = 60
res@mpMaxLonF            = 140 
res@vpWidthF             = 0.8
res@vpHeightF            = 0.45       
res@mpLandFillColor      = "white"
res@cnFillOn             = True         
res@cnFillPalette        = "precip_diff_12lev" 
res@cnLinesOn            = False        
res@cnLineLabelsOn       = False       
res@lbLabelBarOn         = False        
res@gsnAddCyclic         = False
res@gsnMajorLatSpacing   = 10
res@gsnMajorLonSpacing   = 20
res@tmXBLabelFontHeightF = 0.025
res@tmYLLabelFontHeightF = 0.025                                                  
res@cnLevelSelectionMode = "ManualLevels"
res@cnMinLevelValF       =  -1.2        
res@cnMaxLevelValF       =  1.2     
res@cnLevelSpacingF      =  0.2

res0 = True
res0@gsnDraw              = False        
res0@gsnFrame             = False       
res0@gsnMaximize          = False
res0@cnMonoLineColor      = True
res0@cnLinesOn            = True
res0@cnLineLabelsOn       = False
res0@cnInfoLabelPerimOn   = True
res0@cnLineColor          = "red4"
res0@gsnContourNegLineDashPattern = 1
res0@cnLineThicknesses    = 7.0
res0@cnInfoLabelOn        = True                                                       
res0@cnLevelSelectionMode = "ManualLevels"
res0@cnMinLevelValF       = -25        
res0@cnMaxLevelValF       = 25     
res0@cnLevelSpacingF      = 5

resvc = True
resvc@gsnDraw                    = False        
resvc@gsnFrame                   = False       
resvc@vcGlyphStyle               = "LineArrow"            
resvc@vcLineArrowThicknessF      = 1.0
resvc@vcMinDistanceF             = 0.02
resvc@vcRefMagnitudeF            = 1.0 
resvc@vcRefLengthF               = 0.03
resvc@vcLineArrowColor           = "purple"                  
resvc@vcRefAnnoOrthogonalPosF    = -1.0
resvc@vcVectorDrawOrder          = "PostDraw"
resvc@gsnAddCyclic               = False
resvc@vcRefAnnoString2On         = True
resvc@vcRefAnnoString2           = "m s~S~-1~N~"
resvc@vcRefAnnoPerimSpaceF       = 0.7
resvc@vcRefAnnoPerimOn           = False
resvc@vcRefAnnoFontHeightF       = 0.02
resvc@vcRefAnnoSide              = "Right"


res1 = True
res1@gsnDraw              = False       
res1@gsnAddCyclic         = False
res1@gsnFrame             = False
res1@cnLinesOn            = False       
res1@cnLineLabelsOn       = False
res1@cnFillScaleF         = 1.0        
res1@cnLevelSelectionMode = "ManualLevels" 
res1@cnMinLevelValF       = 0.00      
res1@cnMaxLevelValF       = 1.05      
res1@cnLevelSpacingF      = 0.05        
res1@cnInfoLabelPerimOn   = False
res1@cnInfoLabelOn        = False
res1@trGridType = "TriangularMesh"


ress = True
ress@gsnShadeFillType     = "pattern"
ress@gsnShadeLow          = 17
ress@gsnShadeFillScales   = 1.3
ress@gsnShadeFillDotSizeF = 0.003

respoly                   = True                      
respoly@gsLineColor       = "black"                     
respoly@gsLineThicknessF  = 1.5 

resP                          = True        
resP@gsnMaximize              = True 
resP@gsnFrame                 = False        
resP@gsnPanelLabelBar         = True 
resP@gsnPanelTop              = 0.95     
resP@gsnPanelBottom           = 0.03
resP@gsnPanelMainFontHeightF  = 0.015


resP@pmLabelBarOrthogonalPosF = 0.0          
resP@pmLabelBarWidthF         = 0.7   

resP@lbTitleString            = "precipitation (mm d~S~-1~N~)"  
resP@lbTitlePosition          = "Right" 
resP@lbTitleDirection         = "Across"
resP@lbTitleFontHeightF       = 0.015

plot    = new(6,graphic)
plotolr = plot
dum     = plot
pv      = plot
pshade  = plot
sig     = 0.1

plable = (/"(a) pentad-2","(b) pentad-1","(c) pentad0","(d) pentad1","(e) pentad2","(f) pentad3"/)

wks = gsn_open_wks("eps","/home/cuixy/Desktop/search/Composite/Canonical")
i = 0
date = date1
do n = 0,5
    res@gsnLeftString = plable(n)
    ave1 = olr(i,n,:,:)
    avr1 = pavr(0,n,:,:)
    s1   = dimsizes(date(:,n))
    prob = ttest(ave1, avr1^2, s1, ave2, avr2^2, s2,True , False)
    copy_VarCoords(olr(0,0,:,:), prob)
;u&vsig
    u1 = uv(i,n,0,:,:)
    avr = uavr(0,n,:,:)
    prob1 = ttest(u1, avr^2, s1, ave3, avr3^2, s2,True , False)
    v1 = uv(i,n,1,:,:)
    avr = vavr(0,n,:,:)
    prob2 = ttest(v1, avr^2, s1, ave4, avr4^2, s2,True , False)
    u1 = mask(u1,((prob1.lt.sig).or.(prob2.lt.sig)),True)
    v1 = mask(v1,((prob1.lt.sig).or.(prob2.lt.sig)),True)


;plot
    
    plot(n)   = gsn_csm_contour_map(wks, ave1, res)
    pshade(n) = gsn_csm_contour(wks,prob,res1)
    pshade(n) = gsn_contour_shade(pshade(n),sig,1,ress)
    overlay(plot(n),pshade(n))
    pv(n) = gsn_csm_vector(wks,u1(::4,::4),v1(::4,::4),resvc)
    overlay(plot(n),pv(n))
;olr sig
    olro = olra(i,n,:,:)
    avra = dim_stddev_n(olr1(date(:,n),:,:),0)
    probo = ttest(olro, avra^2, s1, ave5, avr5^2, s2,True , False)
    olro = mask(olro, probo.lt.sig, True)
plotolr   = gsn_csm_contour(wks, olro, res0)
    overlay(plot(n), plotolr(n))
    dum(n)  = gsn_add_polyline(wks,plot(n),polyx,polyy,respoly)
    delete([/avr1,s1,prob,u1,v1/])
end do

resP@gsnPanelMainString = "Canonical"
resP@gsnPanelRowSpec = True
gsn_panel(wks,plot,(/2,2,2/),resP) 
delete(wks)
