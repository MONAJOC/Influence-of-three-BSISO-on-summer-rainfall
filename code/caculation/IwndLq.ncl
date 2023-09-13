uvf = addfile("/home/cuixy/Desktop/DATA/UWND/Intral/Intral_uv.nc","r")
qf  = addfile("/home/cuixy/Desktop/DATA/Qfile/Low/Low_q.nc","r")
f1 = addfile("/home/cuixy/Desktop/DATA/ERA5_daily_NH_sp.nc","r")


time = uvf->time
ymdhms  = cd_calendar(time, 0)
iyear   = floattoint( ymdhms(:,0) )
imon    = floattoint( ymdhms(:,1) )   
iday    = floattoint( ymdhms(:,2) )
ddd     = day_of_year(iyear, imon, iday) 
yyyyddd = iyear*1000 + ddd 

; variable
u = uvf->u
v = uvf->v
q = qf ->q(:,:,{25:40},{105:125})
sp = f1->sp(:,{25:40},{105:125})
level = q&level*100
dp  = dpres_plevel_Wrap(level, sp, 30000, 0)
g   = 9.80665
; calculate qcon
div = uv2dv_cfd(u, v, u&latitude, u&longitude, 0)
copy_VarCoords(u, div)
qcon1  = div*q
qcon   = dim_sum_n(qcon1, 1)/g
delete([/qcon1,div/])
copy_VarCoords(u(:,0,:,:), qcon)

;calculate advection
advc = advect_variable_cfd(u,v,q,u&latitude,u&longitude,False,"","",1)
uadv = advc[1]
vadv = advc[2]
copy_VarCoords(u, uadv)
copy_VarCoords(u, vadv)
delete(advc)
delete([/q,v/])
uadv := dim_sum_n(uadv, 1)/g
copy_VarCoords(u(:,0,:,:), uadv)
vadv := dim_sum_n(vadv, 1)/g
copy_VarCoords(u(:,0,:,:), vadv)
delete(u)

; MJO Filter
wts  = filwgts_lanczos (101, 2, 1/80.,1/30. , 1.0)

xClmDay = clmDayTLL(uadv, yyyyddd)
xClmDay_sm = smthClmDayTLL(xClmDay, 3)
xAnom = calcDayAnomTLL(uadv, yyyyddd, xClmDay_sm)
uadv := wgt_runave_n_Wrap(xAnom, wts, 0, 0)
delete([/xClmDay,xClmDay_sm,xAnom/])

xClmDay = clmDayTLL(vadv, yyyyddd)
xClmDay_sm = smthClmDayTLL(xClmDay, 3)
xAnom = calcDayAnomTLL(vadv, yyyyddd, xClmDay_sm)
vadv := wgt_runave_n_Wrap(xAnom, wts, 0, 0)
delete([/xClmDay,xClmDay_sm,xAnom/])

xClmDay = clmDayTLL(qcon, yyyyddd)
xClmDay_sm = smthClmDayTLL(xClmDay, 3)
xAnom = calcDayAnomTLL(qcon, yyyyddd, xClmDay_sm)
qcon := wgt_runave_n_Wrap(xAnom, wts, 0, 0)
delete([/xClmDay,xClmDay_sm,xAnom/])

diro = "/home/cuixy/Desktop/search/buget_diagnose/data/"
filo = "IwndLq"+".nc"
system("/bin/rm -f "+diro+filo)   
ncdf = addfile(diro+filo,"c") 
ncdf->vadv       = vadv
ncdf->uadv       = uadv
ncdf->qcon       = qcon