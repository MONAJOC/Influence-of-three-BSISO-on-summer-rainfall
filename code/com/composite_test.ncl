latmin  = 28
latmax  = 34
lonmin  = 110
lonmax  = 122

cdate = asciiread("/home/cuixy/Desktop/K-means/centraldate.csv", -1, "integer")  ;central date
c1    = asciiread("/home/cuixy/Desktop/K-means/cluster/BSclus1.csv", -1, "integer")
c2    = asciiread("/home/cuixy/Desktop/K-means/cluster/BSclus2.csv", -1, "integer")
c3    = asciiread("/home/cuixy/Desktop/K-means/cluster/BSclus3.csv", -1, "integer")
fpre    = addfile("/home/cuixy/Desktop/K-means/data/preAnom.nc","r")
fdqdt   = addfile("/home/cuixy/Desktop/search/buget_new/data/BSISO_qten.nc","r")
fadv    = addfile("/home/cuixy/Desktop/search/buget_new/data/BSISO_adv.nc","r")
fwdqdp  = addfile("/home/cuixy/Desktop/search/buget_new/data/BSISO_wdqdp.nc","r")
fmsink  = addfile("/home/cuixy/Desktop/search/buget_new/data/BSISO_msink.nc","r")

pre1     = fpre->pre(:,{latmin:latmax},{lonmin:lonmax})
dqdt     = fdqdt->qten(:,{latmin:latmax},{lonmin:lonmax})
uadv     = fadv->u(:,{latmin:latmax},{lonmin:lonmax})
vadv     = fadv->v(:,{latmin:latmax},{lonmin:lonmax})
wdqdp    = fwdqdp->w(:,{latmin:latmax},{lonmin:lonmax})
pre      = pre1(:,::2,::2)
uadv     = -1*uadv*86400
vadv     = -1*vadv*86400
wdqdp    = -1*wdqdp*86400
msink    = dqdt - uadv - vadv - wdqdp
copy_VarCoords(dqdt, msink)

time    = pre&time
ymdhms  = cd_calendar(time, 0)
iyear   = floattoint( ymdhms(:,0) )
imon    = floattoint( ymdhms(:,1) )   
nt = ind(imon.ge.5.and.imon.le.8)


;variable_fit
;pre
pdata = new((/dimsizes(cdate),6,dimsizes(pre&lat),dimsizes(pre&lon)/),float)
pdata!0 = "event"
pdata!1 = "pentad"
copy_VarCoords(pre(0,:,:), pdata(0,0,:,:))
c = (/0,0,0,0,0,0/)
do n = 0,dimsizes(cdate)-1
    do j = 0,5
        c(j) = cdate(n) + (j-2)*5
    end do
    do i = 0,dimsizes(c)-1
        pdata(n,i,:,:) = dim_avg_n(pre((c(i)-2):(c(i)+2),:,:),0)
    end do
    c = 0
end do

;dqdt
qtdata = new((/dimsizes(cdate),6,dimsizes(dqdt&latitude),dimsizes(dqdt&longitude)/),float)
qtdata!0 = "event"
qtdata!1 = "pentad"
copy_VarCoords(dqdt(0,:,:), qtdata(0,0,:,:))
c = (/0,0,0,0,0,0/)
do n = 0,dimsizes(cdate)-1
    do j = 0,5
        c(j) = cdate(n) + (j-2)*5
    end do
    do i = 0,dimsizes(c)-1
        qtdata(n,i,:,:) = dim_avg_n(dqdt((c(i)-2):(c(i)+2),:,:),0)
    end do
    c = 0
end do

;uadv
udata = new((/dimsizes(cdate),6,dimsizes(uadv&latitude),dimsizes(uadv&longitude)/),float)
udata!0 = "event"
udata!1 = "pentad"
copy_VarCoords(uadv(0,:,:), udata(0,0,:,:))
c = (/0,0,0,0,0,0/)
do n = 0,dimsizes(cdate)-1
    do j = 0,5
        c(j) = cdate(n) + (j-2)*5
    end do
    do i = 0,dimsizes(c)-1
        udata(n,i,:,:) = dim_avg_n(uadv((c(i)-2):(c(i)+2),:,:),0)
    end do
    c = 0
end do

;vadv
vdata = new((/dimsizes(cdate),6,dimsizes(vadv&latitude),dimsizes(vadv&longitude)/),float)
vdata!0 = "event"
vdata!1 = "pentad"
copy_VarCoords(vadv(0,:,:), vdata(0,0,:,:))
c = (/0,0,0,0,0,0/)
do n = 0,dimsizes(cdate)-1
    do j = 0,5
        c(j) = cdate(n) + (j-2)*5
    end do
    do i = 0,dimsizes(c)-1
        vdata(n,i,:,:) = dim_avg_n(vadv((c(i)-2):(c(i)+2),:,:),0)
    end do
    c = 0
end do

;wdqdp
wdata = new((/dimsizes(cdate),6,dimsizes(wdqdp&latitude),dimsizes(wdqdp&longitude)/),float)
wdata!0 = "event"
wdata!1 = "pentad"
copy_VarCoords(wdqdp(0,:,:), wdata(0,0,:,:))
c = (/0,0,0,0,0,0/)
do n = 0,dimsizes(cdate)-1
    do j = 0,5
        c(j) = cdate(n) + (j-2)*5
    end do
    do i = 0,dimsizes(c)-1
        wdata(n,i,:,:) = dim_avg_n(wdqdp((c(i)-2):(c(i)+2),:,:),0)
    end do
    c = 0
end do

;msink
mdata = new((/dimsizes(cdate),6,dimsizes(msink&latitude),dimsizes(msink&longitude)/),float)
mdata!0 = "event"
mdata!1 = "pentad"
copy_VarCoords(msink(0,:,:), mdata(0,0,:,:))
c = (/0,0,0,0,0,0/)
do n = 0,dimsizes(cdate)-1
    do j = 0,5
        c(j) = cdate(n) + (j-2)*5
    end do
    do i = 0,dimsizes(c)-1
        mdata(n,i,:,:) = dim_avg_n(msink((c(i)-2):(c(i)+2),:,:),0)
    end do
    c = 0
end do

;date variable
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
date1 := ndtooned(date1)
date2 := ndtooned(date2)
date3 := ndtooned(date3)
delete([/cdate1,cdate2,cdate3/])

;general value to plot
;pre
pr = new((/3,6,dimsizes(pdata&lat),dimsizes(pdata&lon)/),float)
pr!0 = "cluster"
pr!1 = "pentad"
copy_VarCoords(pdata(0,0,:,:), pr(0,0,:,:))
pr(0,:,:,:) = dim_avg_n_Wrap(pdata(c1,:,:,:),0)
pr(1,:,:,:) = dim_avg_n_Wrap(pdata(c2,:,:,:),0)
pr(2,:,:,:) = dim_avg_n_Wrap(pdata(c3,:,:,:),0)

;dqdt
qt = new((/3,6,dimsizes(qtdata&latitude),dimsizes(qtdata&longitude)/),float)
qt!0 = "cluster"
qt!1 = "pentad"
copy_VarCoords(qtdata(0,0,:,:), qt(0,0,:,:))
qt(0,:,:,:) = dim_avg_n_Wrap(qtdata(c1,:,:,:),0)
qt(1,:,:,:) = dim_avg_n_Wrap(qtdata(c2,:,:,:),0)
qt(2,:,:,:) = dim_avg_n_Wrap(qtdata(c3,:,:,:),0)

;uadv
u = new((/3,6,dimsizes(udata&latitude),dimsizes(udata&longitude)/),float)
u!0 = "cluster"
u!1 = "pentad"
copy_VarCoords(udata(0,0,:,:), u(0,0,:,:))
u(0,:,:,:) = dim_avg_n_Wrap(udata(c1,:,:,:),0)
u(1,:,:,:) = dim_avg_n_Wrap(udata(c2,:,:,:),0)
u(2,:,:,:) = dim_avg_n_Wrap(udata(c3,:,:,:),0)

;vadv
v = new((/3,6,dimsizes(vdata&latitude),dimsizes(vdata&longitude)/),float)
v!0 = "cluster"
v!1 = "pentad"
copy_VarCoords(vdata(0,0,:,:), v(0,0,:,:))
v(0,:,:,:) = dim_avg_n_Wrap(vdata(c1,:,:,:),0)
v(1,:,:,:) = dim_avg_n_Wrap(vdata(c2,:,:,:),0)
v(2,:,:,:) = dim_avg_n_Wrap(vdata(c3,:,:,:),0)

;wdqdp
w = new((/3,6,dimsizes(wdata&latitude),dimsizes(wdata&longitude)/),float)
w!0 = "cluster"
w!1 = "pentad"
copy_VarCoords(wdata(0,0,:,:), w(0,0,:,:))
w(0,:,:,:) = dim_avg_n_Wrap(wdata(c1,:,:,:),0)
w(1,:,:,:) = dim_avg_n_Wrap(wdata(c2,:,:,:),0)
w(2,:,:,:) = dim_avg_n_Wrap(wdata(c3,:,:,:),0)

;msink
m = new((/3,6,dimsizes(mdata&latitude),dimsizes(mdata&longitude)/),float)
m!0 = "cluster"
m!1 = "pentad"
copy_VarCoords(mdata(0,0,:,:), m(0,0,:,:))
m(0,:,:,:) = dim_avg_n_Wrap(mdata(c1,:,:,:),0)
m(1,:,:,:) = dim_avg_n_Wrap(mdata(c2,:,:,:),0)
m(2,:,:,:) = dim_avg_n_Wrap(mdata(c3,:,:,:),0)

pr1 = dim_avg_n(pr(:,:,{28:34},{110:122}),(/2,3/))
qt1 = dim_avg_n(qt(:,:,{28:34},{110:122}),(/2,3/))
u1 = dim_avg_n(u(:,:,{28:34},{110:122}),(/2,3/))
v1 = dim_avg_n(v(:,:,{28:34},{110:122}),(/2,3/))
w1 = dim_avg_n(w(:,:,{28:34},{110:122}),(/2,3/))
m1 = dim_avg_n(m(:,:,{28:34},{110:122}),(/2,3/))

colors = (/"red","green","blue"/)
;plot
;plot pre
resp                     = True 
resp@gsnMaximize         = True
resp@gsnPaperOrientation = "portrait"
resp@gsnDraw          = False
resp@gsnFrame         = False
resp@gsnLeftString   = "(a)precipitation"
resp@trYMinF          = -0.6    
resp@trYMaxF          = 1.5 

resp@xyLineThicknessF = 2.0
resp@xyLineColor      = colors(0)
resp@tiYAxisString    = "Precipitation (mm/day)"
resp@tmXMajorGrid           = True               
resp@tmXMajorGridLineColor  = "gray"
resp@tmYMajorGrid           = True
resp@tmYMajorGridLineColor  = "gray"
resp@tmXMajorGridLineDashPattern = 1.0
resp@tmYMajorGridLineDashPattern = 1.0
resp@tmXMajorGridThicknessF      = 0.5
resp@tmYMajorGridThicknessF      = 0.5

resp@tmXBMode                    = "Explicit"
resp@tmXBValues                  = ispan(0, 5, 1)
resp@tmXBLabels                  = (/"P-2","P-1","P0","P1","P2","P3"/)

resp@gsnYRefLine           = 0. 

res                     = True 
res@gsnMaximize         = True
res@gsnPaperOrientation = "portrait"
res@gsnDraw          = False
res@gsnFrame         = False

res@trYMinF          = -0.5    
res@trYMaxF          = 0.5

res@xyLineThicknessF = 2.0
res@xyLineColor      = colors(0)
res@tmXMajorGrid           = True               
res@tmXMajorGridLineColor  = "gray"
res@tmYMajorGrid           = True
res@tmYMajorGridLineColor  = "gray"
res@tmXMajorGridLineDashPattern = 1.0
res@tmYMajorGridLineDashPattern = 1.0
res@tmXMajorGridThicknessF      = 0.5
res@tmYMajorGridThicknessF      = 0.5

res@tmXBMode                    = "Explicit"
res@tmXBValues                  = ispan(0, 5, 1)
res@tmXBLabels                  = (/"P-2","P-1","P0","P1","P2","P3"/)

res@gsnYRefLine           = 0.         

x1    = ispan(0,5,1)
wks   = gsn_open_wks("eps","/home/cuixy/Desktop/search/buget_new/figure/111")
;pre
plot0 = gsn_csm_xy(wks,x1,pr1(0,:),resp)

resp@xyLineColor     = colors(1)
plot1 = gsn_csm_xy(wks,x1,pr1(1,:),resp)

resp@xyLineColor     = colors(2)
plot2 = gsn_csm_xy(wks,x1,pr1(2,:),resp)

overlay(plot0,plot1)
overlay(plot0,plot2)

;moisture budget
color2 = (/"black","red","green","blue","orange"/)
plot = new((/3,5/),graphic)
i = 0
    res@gsnLeftString   = "(b)canonical"
    res@xyLineColor     = color2(0)
    plot(i,0) = gsn_csm_xy(wks,x1,qt1(i,:),res)

    res@xyLineColor     = color2(1)
    plot(i,1) = gsn_csm_xy(wks,x1,u1(i,:),res)

    res@xyLineColor     = color2(2)
    plot(i,2) = gsn_csm_xy(wks,x1,v1(i,:),res)

    res@xyLineColor     = color2(3)
    plot(i,3) = gsn_csm_xy(wks,x1,w1(i,:),res)

    res@xyLineColor     = color2(4)
    plot(i,4) = gsn_csm_xy(wks,x1,m1(i,:),res)
    overlay(plot(i,0),plot(i,1))
    overlay(plot(i,0),plot(i,2))
    overlay(plot(i,0),plot(i,3))
    overlay(plot(i,0),plot(i,4))

i = 1
    res@gsnLeftString   = "(c)eastward expansion"
    res@xyLineColor     = color2(0)
    plot(i,0) = gsn_csm_xy(wks,x1,qt1(i,:),res)

    res@xyLineColor     = color2(1)
    plot(i,1) = gsn_csm_xy(wks,x1,u1(i,:),res)

    res@xyLineColor     = color2(2)
    plot(i,2) = gsn_csm_xy(wks,x1,v1(i,:),res)

    res@xyLineColor     = color2(3)
    plot(i,3) = gsn_csm_xy(wks,x1,w1(i,:),res)

    res@xyLineColor     = color2(4)
    plot(i,4) = gsn_csm_xy(wks,x1,m1(i,:),res)
    overlay(plot(i,0),plot(i,1))
    overlay(plot(i,0),plot(i,2))
    overlay(plot(i,0),plot(i,3))
    overlay(plot(i,0),plot(i,4))

i = 2
    res@gsnLeftString   = "(d)northward dipole"
    res@xyLineColor     = color2(0)
    plot(i,0) = gsn_csm_xy(wks,x1,qt1(i,:),res)

    res@xyLineColor     = color2(1)
    plot(i,1) = gsn_csm_xy(wks,x1,u1(i,:),res)

    res@xyLineColor     = color2(2)
    plot(i,2) = gsn_csm_xy(wks,x1,v1(i,:),res)

    res@xyLineColor     = color2(3)
    plot(i,3) = gsn_csm_xy(wks,x1,w1(i,:),res)

    res@xyLineColor     = color2(4)
    plot(i,4) = gsn_csm_xy(wks,x1,m1(i,:),res)
    overlay(plot(i,0),plot(i,1))
    overlay(plot(i,0),plot(i,2))
    overlay(plot(i,0),plot(i,3))
    overlay(plot(i,0),plot(i,4))


lgres                    = True
lgres@lgLineColors       = colors
lgres@lgItemType         = "Lines"        ; show lines only (default)
lgres@lgLabelFontHeightF = .12            ; legend label font thickness
lgres@vpWidthF           = 0.3           ; width of legend (NDC)
lgres@vpHeightF          = 0.15           ; height of legend (NDC)
lgres@lgPerimThicknessF  = 0.0            ; thicken the box perimeter
lgres@lgLineThicknesses  = 2.0
lgres@lgMonoDashIndex    = True
lgres@lgDashIndex        = 0

labels = (/"canonical","eastward expansion", "northward dipole"/)
legend = gsn_create_legend (wks, 3, labels,lgres)

amres                  = True
amres@amJust           = "TopRight"        ; Use bottom right corner of box
                                           ; for determining its location.
amres@amParallelPosF   =  0.5              ; Move legend to right
amres@amOrthogonalPosF = -0.5              ; Move legend down.

annoid = gsn_add_annotation(plot0,legend,amres)  

lgres1                    = True
lgres1@lgLineColors       = color2
lgres1@lgItemType         = "Lines"        ; show lines only (default)
lgres1@lgLabelFontHeightF = .12            ; legend label font thickness
lgres1@vpWidthF           = 0.3           ; width of legend (NDC)
lgres1@vpHeightF          = 0.15           ; height of legend (NDC)
lgres1@lgPerimThicknessF  = 0.0            ; thicken the box perimeter
lgres1@lgLineThicknesses  = 2.0
lgres1@lgMonoDashIndex    = True
lgres1@lgDashIndex        = 0

labels1 = (/"q_tendency","zonal_adv","meridional_adv","vertical_adv","moisture_sink"/)
legend1 = gsn_create_legend (wks, 4, labels1,lgres)

;annoid1  = gsn_add_annotation(plot(0,0),legend1,amres)
;annoid2  = gsn_add_annotation(plot(1,0),legend1,amres)
;annoid3  = gsn_add_annotation(plot(2,0),legend1,amres)

resP                     = True        
resP@gsnMaximize         = True 
resP@gsnFrame            = False        
resP@gsnPanelLabelBar    = False 
resP@gsnPanelTop         = 0.95     
resP@gsnPanelBottom      = 0.03
resP@gsnPanelMainFontHeightF = 0.015
resP@pmLabelBarOrthogonalPosF = 0.0          
resP@pmLabelBarWidthF    = 0.8
resP@gsnPanelRowSpec = True
gsn_panel(wks,(/plot0,plot(0,0),plot(1,0),plot(2,0)/),(/2,2/),resP) 
delete(wks)