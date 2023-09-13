;define
levmin = 700
levmax = 1000

lonmin = 109
lonmax = 123

latmin = 27
latmax = 35

diri_q      = "/home/cuixy/Desktop/DATA/Qfile/q/"
files_q = systemfunc("ls " + diri_q + "*.nc")
fq = addfiles(files_q, "r")

diri_u      = "/home/cuixy/Desktop/DATA/UWND/uwnd/"
files_u = systemfunc("ls " + diri_u + "*.nc")
fu = addfiles(files_u, "r")

diri_v      = "/home/cuixy/Desktop/DATA/VWND/vwnd/"
files_v = systemfunc("ls " + diri_v + "*.nc")
fv = addfiles(files_v, "r")

q = fq[:]->q(:, {levmax:levmin}, {latmin:latmax}, {lonmin:lonmax})

u = fu[:]->u(:, {levmax:levmin}, {latmin:latmax}, {lonmin:lonmax})

v = fv[:]->v(:, {levmax:levmin}, {latmin:latmax}, {lonmin:lonmax})

diro = "/home/cuixy/Desktop/search/buget_new/data/"
filo = "ERA5_daily_quv"+".nc"
system("/bin/rm -f "+diro+filo)   
ncdf = addfile(diro+filo,"c") 
ncdf->q  = q
ncdf->u  = u
ncdf->v  = v