diri  = "/home/cuixy/Desktop/DATA/VWND/vwnd/"
files = systemfunc("ls " + diri + "ERA5_daily_NH_v*.nc")
fstv  = addfiles(files,"r")
diri  = "/home/cuixy/Desktop/DATA/UWND/uwnd/"
files = systemfunc("ls " + diri + "ERA5_daily_NH_u*.nc")
fstu  = addfiles(files,"r")
diri  = "/home/cuixy/Desktop/DATA/Qfile/q/"
files = systemfunc("ls " + diri + "ERA5_daily_NH_q*.nc")
fstq  = addfiles(files,"r")

time  = fstq[:]->time
ymdhms  = cd_calendar(time, 0)
iyear   = floattoint( ymdhms(:,0) )
imon    = floattoint( ymdhms(:,1) )   
iday    = floattoint( ymdhms(:,2) )
ddd     = day_of_year(iyear, imon, iday) 
yyyyddd = iyear*1000 + ddd 
wts  = filwgts_lanczos (101, 2, 1/80.,1/30. , 1.0)
; uwnd
u   = fstu[:]->u(:,{850},{15:45},{100:130})
u   = wgt_runave_n_Wrap(u, wts, 0, 0)

;vwnd
v   = fstv[:]->v(:,{850},{15:45},{100:130})
v   = wgt_runave_n_Wrap(v, wts, 0, 0)

;q
q   = fstq[:]->q(:,{850},{15:45},{100:130})
q   = wgt_runave_n_Wrap(q, wts, 0, 0)

diro = "/home/cuixy/Desktop/search/buget_diagnose/data/"
filo = "MJO_quv"+".nc"
system("/bin/rm -f "+diro+filo)   
ncdf = addfile(diro+filo,"c")     
ncdf->q = q
ncdf->v = v
ncdf->u = u