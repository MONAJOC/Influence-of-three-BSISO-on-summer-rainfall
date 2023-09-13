
lonmin  = 109
lonmax  = 123

latmin  = 27
latmax  = 35

f       = addfile("/home/cuixy/Desktop/search/buget_new/data/advection.nc","r")

time    = f->time
ymdhms  = cd_calendar(time, 0)
iyear   = floattoint( ymdhms(:,0) )
imon    = floattoint( ymdhms(:,1) )   
iday    = floattoint( ymdhms(:,2) )
ddd     = day_of_year(iyear, imon, iday) 
yyyyddd = iyear*1000 + ddd 
wts     = filwgts_lanczos (101, 2, 1/80.,1/30. , 1.0)

u       = f->u
v       = f->v

xClmDay    = clmDayTLL(u, yyyyddd)
xClmDay_sm = smthClmDayTLL(xClmDay, 3)
xAnom      = calcDayAnomTLL(u, yyyyddd, xClmDay_sm)
x1         = wgt_runave_n_Wrap(xAnom, wts, 0, 0)

xClmDay    = clmDayTLL(v, yyyyddd)
xClmDay_sm = smthClmDayTLL(xClmDay, 3)
xAnom      = calcDayAnomTLL(v, yyyyddd, xClmDay_sm)
x2         = wgt_runave_n_Wrap(xAnom, wts, 0, 0)

diro = "/home/cuixy/Desktop/search/buget_new/data/"
filo = "BSISO_adv"+".nc"
system("/bin/rm -f "+diro+filo)   
ncdf    = addfile(diro+filo,"c")     
ncdf->u = x1
ncdf->v = x2
