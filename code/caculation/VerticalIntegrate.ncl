f  = addfile("/home/user/Desktop/DATA/ERA5_daily_NH_sp.nc","r")
f1 = addfile("/home/user/Desktop/search/Event12/advection.nc","r")
f2 = addfile("/home/user/Desktop/search/Event12/advectionLI.nc","r")
f3 = addfile("/home/user/Desktop/search/Event12/convergence.nc","r")
f4 = addfile("/home/user/Desktop/search/Event12/convergenceLI.nc","r")

sp = f->sp(:,{25:36},{105:125})
u  = f1->u(:,{1000:300},{25:36},{105:125})
v  = f1->v(:,{1000:300},{25:36},{105:125})
adv = f1->q(:,{1000:300},{25:36},{105:125})
ul = f2->u(:,{1000:300},{25:36},{105:125})
vl = f2->v(:,{1000:300},{25:36},{105:125})
advl = f2->q(:,{1000:300},{25:36},{105:125})
q  = f3->q(:,{1000:300},{25:36},{105:125})
ql = f4->q(:,{1000:300},{25:36},{105:125})

level = u&level*100
dp  = dpres_plevel_Wrap(level, sp, 30000, 0)
g   = 9.80665

temp = u*dp
u := dim_sum_n(temp, 1)/g
temp = v*dp
v := dim_sum_n(temp, 1)/g
temp = ul*dp
ul := dim_sum_n(temp, 1)/g
temp = vl*dp
vl := dim_sum_n(temp, 1)/g
temp = q*dp
q := dim_sum_n(temp, 1)/g
delete(temp)
temp = ql*dp
ql := dim_sum_n(temp, 1)/g
delete(temp)
temp = adv*dp
adv := dim_sum_n(temp, 1)/g
delete(temp)
temp = advl*dp
advl := dim_sum_n(temp, 1)/g

copy_VarCoords(sp, u)
copy_VarCoords(sp, v)
copy_VarCoords(sp, ul)
copy_VarCoords(sp, vl)
copy_VarCoords(sp, q)
copy_VarCoords(sp, ql)
copy_VarCoords(sp, adv)
copy_VarCoords(sp, advl)


diro = "/home/user/Desktop/search/Event12/"
filo = "INadvection"+".nc"
system("/bin/rm -f "+diro+filo)   
ncdf = addfile(diro+filo,"c")     
ncdf->u  = u
ncdf->v  = v
ncdf->adv  = adv
ncdf->advl = advl
ncdf->ul = ul
ncdf->vl = vl
diro = "/home/user/Desktop/search/Event12/"
filo = "INconvergence"+".nc"
system("/bin/rm -f "+diro+filo)   
ncdf = addfile(diro+filo,"c")     
ncdf->q  = q
ncdf->ql = ql




