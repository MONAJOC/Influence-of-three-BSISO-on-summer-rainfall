diri      = "/home/cuixy/Desktop/DATA/Omega/"
files = systemfunc("ls " + diri + "*.nc")
f = addfiles(files, "r")

omega = f[:]->w
w1    = short2flt(omega)

opt           = True
opt@nval_crit = 4

w     = calculate_daily_values(w1, "avg", 0, opt)

diro = "/home/cuixy/Desktop/search/buget_new/data/"
filo = "ERA5_daily_omega"+".nc"
system("/bin/rm -f "+diro+filo)   
ncdf = addfile(diro+filo,"c") 
ncdf->w  = w
