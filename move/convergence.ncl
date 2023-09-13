diri  = "/home/user/Desktop/DATA/VWND/vwnd/"
files = systemfunc("ls " + diri + "ERA5_daily_NH_v*.nc")
fstv  = addfiles(files,"r")
diri  = "/home/user/Desktop/DATA/UWND/uwnd/"
files = systemfunc("ls " + diri + "ERA5_daily_NH_u*.nc")
fstu  = addfiles(files,"r")
diri  = "/home/user/Desktop/DATA/Qfile/q/"
files = systemfunc("ls " + diri + "ERA5_daily_NH_q*.nc")
fstq  = addfiles(files,"r")
f1 = addfile("/home/user/Desktop/DATA/ERA5_daily_NH_sp.nc","r")

time    = fstq[:]->time
ymdhms  = cd_calendar(time, 0)
iyear   = floattoint( ymdhms(:,0) )
imon    = floattoint( ymdhms(:,1) )   
iday    = floattoint( ymdhms(:,2) )
ddd     = day_of_year(iyear, imon, iday) 
yyyyddd = iyear*1000 + ddd 
wts  = filwgts_lanczos (101, 2, 1/80.,1/30. , 1.0)

sp = f1->sp(:,{25:40},{105:125})
u   = fstu[:]->u(:,{1000:300},{25:40},{105:125})
v   = fstv[:]->v(:,{1000:300},{25:40},{105:125})
q   = fstq[:]->q(:,{1000:300},{25:40},{105:125})

level = q&level*100
dp  = dpres_plevel_Wrap(level, sp, 30000, 0)
g   = 9.80665

div = uv2dv_cfd(u, v, u&latitude, u&longitude, 0)
copy_VarCoords(u, div)

qdv = q*div
qdv = qdv*dp
qcon = dim_sum_n(qdv, 1)/g
copy_VarCoords(u(:,0,:,:), qcon)
delete([/div,qdv/])

xClmDay = clmDayTLL(qcon, yyyyddd)
xClmDay_sm = smthClmDayTLL(xClmDay, 3)
xAnom = calcDayAnomTLL(qcon, yyyyddd, xClmDay_sm)
qconAnom = wgt_runave_n_Wrap(xAnom, wts, 0, 0)

diro = "/home/user/Desktop/search/buget/"
filo = "convergence"+".nc"
system("/bin/rm -f "+diro+filo)   
ncdf = addfile(diro+filo,"c")     
ncdf->con  = qconAnom
