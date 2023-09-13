f  = addfile("/home/cuixy/Desktop/K-means/data/preAnom.nc","r")
f1 = addfile("/home/cuixy/Desktop/K-means/olrAnom.nc","r")
cdate = asciiread("/home/cuixy/Desktop/K-means/centraldate.csv",  -1, "integer")  ;central date
c1 = asciiread("/home/cuixy/Desktop/K-means/cluster/BSclus1.csv", -1, "integer")
c2 = asciiread("/home/cuixy/Desktop/K-means/cluster/BSclus2.csv", -1, "integer")
c3 = asciiread("/home/cuixy/Desktop/K-means/cluster/BSclus3.csv", -1, "integer")


pre  = f->pre(:,{15:40},{100:135})


lat = pre&lat
lon = pre&lon
time = pre&time

ymdhms  = cd_calendar(time, 0)
iyear   = floattoint( ymdhms(:,0) )
imon    = floattoint( ymdhms(:,1) )   
nt = ind(imon.ge.5.and.imon.le.8)
delete([/pre@long_name,u@long_name,v@long_name,u@units,v@units/])

pdata = new((/dimsizes(cdate),6,dimsizes(lat),dimsizes(lon)/),float)
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


plable = (/"(a)pentad-2","(b)pentad-1","(c)pentad0","(d)pentad1","(e)pentad2","(f)pentad3"/)
;pre sig
ave2 = dim_avg_n_Wrap(pre(nt,:,:), 0)
avr2 = dim_stddev_n_Wrap(pre(nt,:,:), 0)
s2 = dimsizes(nt)


;pre
olr = new((/3,6,dimsizes(lat),dimsizes(lon)/),float)
olr!0 = "cluster"
olr!1 = "pentad"
copy_VarCoords(pdata(0,0,:,:), olr(0,0,:,:))
olr(0,:,:,:) = dim_avg_n(pdata(c1,:,:,:),0)
olr(1,:,:,:) = dim_avg_n(pdata(c2,:,:,:),0)
olr(2,:,:,:) = dim_avg_n(pdata(c3,:,:,:),0)



; pre new array
; pre new array
latmin = -15
latmax = 40
lonmin = 60
lonmax = 160

plat   = fspan(latmin, latmax, 221)
plon   = fspan(lonmin, lonmax, 401)
copy_VarAtts(lat, plat)
copy_VarAtts(lon, plon)
pnew   = new((/3,6,dimsizes(plat),dimsizes(plon)/),float,olr@_FillValue)
pnew!0 = "cluster"
pnew!1 = "pentad"
pnew!2 = "lat"
pnew!3 = "lon"
pnew&lat = plat
pnew&lon = plon
copy_VarAtts(olr,pnew)
pnew(:,:,{15:40},{100:135}) = olr
pnew(0,0,{15},{100}) := olr(0,0,{15},{100})
