
f  = addfile("/home/cuixy/Desktop/search/buget_new/data/BSISO_q.nc","r")

q    = f->q
dqdt = center_finite_diff_n(q, 1, False, 0, 0)
dqdt = dqdt
copy_VarCoords(q,dqdt)
diro = "/home/cuixy/Desktop/search/buget_new/data/"
filo = "BSISO_qten"+".nc"
system("/bin/rm -f "+diro+filo)   
ncdf = addfile(diro+filo,"c") 
ncdf->qten  = dqdt
