latmin  = 28
latmax  = 34
lonmin  = 110
lonmax  = 122

cdate = asciiread("/home/cuixy/Desktop/K-means/centraldate.csv", -1, "integer")  ;central date
c1 = asciiread("/home/cuixy/Desktop/K-means/cluster/BSclus1.csv", -1, "integer")
c2 = asciiread("/home/cuixy/Desktop/K-means/cluster/BSclus2.csv", -1, "integer")
c3 = asciiread("/home/cuixy/Desktop/K-means/cluster/BSclus3.csv", -1, "integer")
fpre    = addfile("/home/cuixy/Desktop/K-means/data/preAnom.nc","r")
fa      = addfile("/home/cuixy/Desktop/search/buget/advection.nc","r")
fc      = addfile("/home/cuixy/Desktop/search/buget/convergence.nc","r")

pre1     = fpre->pre(:,{latmin:latmax},{lonmin:lonmax})

advx = fa->advx(:,{latmin:latmax},{lonmin:lonmax})
advy = fa->advy(:,{latmin:latmax},{lonmin:lonmax})
con  = fc->con(:,{latmin:latmax},{lonmin:lonmax})
adv  := advx + advy
copy_VarCoords(advx, adv)
pre      = pre1(:,::2,::2)

adv  = adv*86400*(-1)
con  = con*86400*(-1)

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

;qcon
cdata = new((/dimsizes(cdate),6,dimsizes(con&latitude),dimsizes(con&longitude)/),float)
cdata!0 = "event"
cdata!1 = "pentad"
copy_VarCoords(con(0,:,:), cdata(0,0,:,:))
c = (/0,0,0,0,0,0/)
copy_VarCoords(con(0,:,:), cdata(0,0,:,:))
do n = 0,dimsizes(cdate)-1
    do j = 0,5
        c(j) = cdate(n) + (j-2)*5
    end do
    do i = 0,dimsizes(c)-1
        cdata(n,i,:,:) = dim_avg_n(con((c(i)-2):(c(i)+2),:,:),0)
    end do
    c = 0
end do
;advx
xdata = new((/dimsizes(cdate),6,dimsizes(con&latitude),dimsizes(con&longitude)/),float)
xdata!0 = "event"
xdata!1 = "pentad"
copy_VarCoords(adv(0,:,:), xdata(0,0,:,:))
c = (/0,0,0,0,0,0/)
do n = 0,dimsizes(cdate)-1
    do j = 0,5
        c(j) = cdate(n) + (j-2)*5
    end do
    do i = 0,dimsizes(c)-1
        xdata(n,i,:,:) = dim_avg_n(adv((c(i)-2):(c(i)+2),:,:),0)
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

qc = new((/3,6,dimsizes(con&latitude),dimsizes(con&longitude)/),float)
qc!0 = "cluster"
qc!1 = "pentad"
copy_VarCoords(cdata(0,0,:,:), qc(0,0,:,:))
qc(0,:,:,:) = dim_avg_n_Wrap(cdata(c1,:,:,:),0)
qc(1,:,:,:) = dim_avg_n_Wrap(cdata(c2,:,:,:),0)
qc(2,:,:,:) = dim_avg_n_Wrap(cdata(c3,:,:,:),0)

xa = new((/3,6,dimsizes(con&latitude),dimsizes(con&longitude)/),float)
xa!0 = "cluster"
xa!1 = "pentad"
copy_VarCoords(xdata(0,0,:,:), xa(0,0,:,:))
xa(0,:,:,:) = dim_avg_n_Wrap(xdata(c1,:,:,:),0)
xa(1,:,:,:) = dim_avg_n_Wrap(xdata(c2,:,:,:),0)
xa(2,:,:,:) = dim_avg_n_Wrap(xdata(c3,:,:,:),0)

pr1 = dim_avg_n(pr(:,:,{28:34},{110:122}),(/2,3/))
qc1 = dim_avg_n(qc(:,:,{28:34},{110:122}),(/2,3/))
xa1 = dim_avg_n(xa(:,:,{28:34},{110:122}),(/2,3/))

colors = (/"red4","green4","blue4"/)
;plot
;plot pre
resp                     = True 
resp@gsnMaximize         = False
;resp@gsnPaperOrientation = "portrait"
resp@gsnDraw          = False
resp@gsnFrame         = False
resp@gsnLeftString    = "(a) Precipitation anomaly"
resp@gsnRightString   = "mm d~S~-1~N~"
resp@trYMinF          = -0.6    
resp@trYMaxF          = 1.5 

resp@vpWidthF         = 0.8
resp@vpHeightF        = 0.4
resp@vpXF             = 0.15
resp@vpYF             = 0.94
resp@xyLineThicknessF = 2.0
resp@xyLineColor      = colors(0)
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
res@gsnMaximize         = False
res@gsnPaperOrientation = "portrait"
res@gsnDraw          = False
res@gsnFrame         = False

res@trXMinF               = 0.4
res@trXMaxF               = 6.6
res@trYMinF               = -0.8
res@trYMaxF               = 1.2 

res@gsnXYBarChart         = True
res@gsnXYBarChartBarWidth = 0.4
res@tmXMajorGrid           = True               
res@tmXMajorGridLineColor  = "gray"
res@tmYMajorGrid           = True
res@tmYMajorGridLineColor  = "gray"
res@tmXMajorGridLineDashPattern = 1.0
res@tmYMajorGridLineDashPattern = 1.0
res@tmXMajorGridThicknessF      = 0.5
res@tmYMajorGridThicknessF      = 0.5

res@tmXBMode                    = "Explicit"
res@tmXBValues                  = ispan(1, 6, 1)
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

x2 = fspan(0.8, 5.8, 6)
x3 = fspan(1.2, 6.2, 6)
;moisture budget
color2 = (/"purple4","orange4"/)
plot = new((/3,4/),graphic)
i = 0
    res@gsnLeftString   = "(b) Canonical"
    res@gsnLeftStringFontHeightF = 0.035
    res@gsnXYBarChartColors     = color2(0)
    plot(i,0) = gsn_csm_xy(wks,x2,qc1(i,:),res)

    res@gsnXYBarChartColors     = color2(1)
    plot(i,1) = gsn_csm_xy(wks,x3,xa1(i,:),res)

    overlay(plot(i,0),plot(i,1))


i = 1
    res@gsnLeftString   = "(c) Eastward expansion"

    res@gsnXYBarChartColors     = color2(0)
    plot(i,0) = gsn_csm_xy(wks,x2,qc1(i,:),res)

    res@gsnXYBarChartColors     = color2(1)
    plot(i,1) = gsn_csm_xy(wks,x3,xa1(i,:),res)

    overlay(plot(i,0),plot(i,1))


i = 2
    res@gsnLeftString   = "(d) Northward dipole"

    res@gsnXYBarChartColors     = color2(0)
    plot(i,0) = gsn_csm_xy(wks,x2,qc1(i,:),res)

    res@gsnXYBarChartColors     = color2(1)
    plot(i,1) = gsn_csm_xy(wks,x3,xa1(i,:),res)

    overlay(plot(i,0),plot(i,1))

lgres                    = True
lgres@lgLineColors       = colors(::-1)
lgres@lgItemType         = "Lines"        ; show lines only (default)
lgres@lgLabelFontHeightF = .12            ; legend label font thickness
lgres@vpWidthF           = 0.3            ; width of legend (NDC)
lgres@vpHeightF          = 0.12           ; height of legend (NDC)
lgres@lgPerimThicknessF  = 0.0            ; thicken the box perimeter
lgres@lgPerimOn          = False
lgres@lgLineThicknessF   = 3.0
lgres@lgMonoDashIndex    = True
lgres@lgDashIndex        = 0

labels = (/"canonical","eastward expansion", "northward dipole"/)
legend = gsn_create_legend (wks, 3, labels(::-1),lgres)

amres                  = True
amres@amJust           = "TopLeft"       ; Use bottom right corner of box
                                         ; for determining its location.
amres@amParallelPosF   = -0.45            ; Move legend to right
amres@amOrthogonalPosF = -0.5            ; Move legend down.

annoid = gsn_add_annotation(plot0,legend,amres)  

lbres1                    = True          ; labelbar only resources
lbres1@vpWidthF           = 0.3           ; labelbar width
lbres1@vpHeightF          = 0.1           ; labelbar height
lbres1@lbBoxMajorExtentF  = 0.36          ; puts space between color boxes
lbres1@lbMonoFillPattern  = True          ; Solid fill pattern

lbres1@lbLabelFontHeightF = 0.015         ; font height. default is small
lbres1@lbLabelJust        = "CenterLeft"  ; left justify labels
lbres1@lbPerimOn          = False
lbres1@lgPerimColor       = "white"
lbres1@lgOrientation      = "Horizontal"

labels1 = (/"q_con (mm d~S~-1~N~)","q_adv (mm d~S~-1~N~)"/)
lbres1@lbFillColors       = color2(0)
gsn_labelbar_ndc(wks,1,labels1(0),0.25,0.13,lbres1)   
lbres1@lbFillColors       = color2(1)
gsn_labelbar_ndc(wks,1,labels1(1),0.55,0.13,lbres1)  

resP                     = True        
resP@gsnMaximize         = True 
resP@gsnFrame            = False        
resP@gsnPanelLabelBar    = False 
resP@gsnPanelTop         = 0.5    
resP@gsnPanelBottom      = 0.05
resP@gsnPanelMainFontHeightF = 0.015
resP@pmLabelBarOrthogonalPosF = 0.0          
resP@pmLabelBarWidthF    = 0.8
resP@gsnPanelRowSpec = True
gsn_panel(wks,(/plot(0,0),plot(1,0),plot(2,0)/),(/3/),resP) 
draw(plot0)
delete(wks)