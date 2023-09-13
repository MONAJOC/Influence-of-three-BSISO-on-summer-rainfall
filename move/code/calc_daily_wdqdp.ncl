levmin = 700
levmax = 1000
latmin = 28
latmax = 34
lonmin = 110
lonmax = 122

fw = addfile("/home/cuixy/Desktop/search/buget_new/data/ERA5_daily_omega.nc","r")
fq = addfile("/home/cuixy/Desktop/search/buget_new/data/ERA5_daily_quv.nc","r")
f  = addfile("/home/cuixy/Desktop/DATA/ERA5_daily_NH_sp.nc","r")

w  = fw->w(:,{levmax:levmin},{latmin:latmax},{lonmin:lonmax})
q  = fq->q(:,{levmax:levmin},{latmin:latmax},{lonmin:lonmax})
sp = f->sp(:,{latmin:latmax},{lonmin:lonmax})

level = q&level*100
dqdp  = center_finite_diff_n(q, level, False, 0, 1)
wdqdp = w*dqdp
copy_VarCoords(w,wdqdp)

dp  = dpres_plevel_Wrap(level, sp, 85000, 0)
g   = 9.80665

temp = wdqdp*dp
f_value = dim_sum_n(temp, 1)/g
copy_VarCoords(wdqdp(:,0,:,:), f_value)

diro = "/home/cuixy/Desktop/search/buget_new/data/"
filo = "wdqdp"+".nc"
system("/bin/rm -f "+diro+filo)   
ncdf = addfile(diro+filo,"c") 
ncdf->w  = f_value