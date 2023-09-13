levmin = 850
levmax = 1000

lonmin = 109
lonmax = 123

latmin = 27
latmax = 35

f    = addfile("/home/cuixy/Desktop/search/buget_new/data/ERA5_daily_quv.nc","r")
fsp  = addfile("/home/cuixy/Desktop/DATA/ERA5_daily_NH_sp.nc","r")

u = f->u(:,{levmax:levmin},:,:)
v = f->v(:,{levmax:levmin},:,:)
q = f->q(:,{levmax:levmin},:,:)

;advection
gradq = grad_latlon_cfd(q, u&latitude, u&longitude, False, False)
gradlat = gradq[0]
gradlon = gradq[1]
uadv = u*gradlon
vadv = v*gradlat
copy_VarCoords(u, uadv)
copy_VarCoords(u, vadv)

;VIn
sp  = fsp->sp(:,{latmin:latmax},{lonmin:lonmax})

level = q&level*100
dp    = dpres_plevel_Wrap(level, sp, 85000, 0)
g     = 9.80665

temp = uadv*dp
uadv1 = dim_sum_n(temp, 1)/g
temp = vadv*dp
vadv1 = dim_sum_n(temp, 1)/g

copy_VarCoords(sp, uadv1)
copy_VarCoords(sp, vadv1)

diro = "/home/cuixy/Desktop/search/buget_new/data/"
filo = "advection"+".nc"
system("/bin/rm -f "+diro+filo)   
ncdf = addfile(diro+filo,"c") 
ncdf->v       = vadv1
ncdf->u       = uadv1
