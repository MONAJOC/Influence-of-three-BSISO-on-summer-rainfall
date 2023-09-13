levmin = 850
levmax = 1000

lonmin = 110
lonmax = 122

latmin = 28
latmax = 34

f    = addfile("/home/cuixy/Desktop/search/buget_new/data/ERA5_daily_quv.nc","r")
fsp  = addfile("/home/cuixy/Desktop/DATA/ERA5_daily_NH_sp.nc","r")

q    = f->q(:,{levmax:levmin},{latmin:latmax},{lonmin:lonmax})
sp   = fsp->sp(:,{latmin:latmax},{lonmin:lonmax})

level = q&level*100
dp  = dpres_plevel_Wrap(level, sp, 30000, 0)
g   = 9.80665

temp = q*dp
x    = dim_sum_n(temp, 1)/g
copy_VarCoords(q(:,0,:,:), x)

diro = "/home/cuixy/Desktop/search/buget_new/data/"
filo = "ERA5_daily_Inq"+".nc"
system("/bin/rm -f "+diro+filo)   
ncdf = addfile(diro+filo,"c") 
ncdf->q  = x

