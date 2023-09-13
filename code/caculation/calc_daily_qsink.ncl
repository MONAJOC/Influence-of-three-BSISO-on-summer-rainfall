lonmin  = 110
lonmax  = 122

latmin  = 28
latmax  = 34

fdqdt   = addfile("/home/cuixy/Desktop/search/buget_new/data/BSISO_qten.nc","r")
fadv    = addfile("/home/cuixy/Desktop/search/buget_new/data/BSISO_adv.nc","r")
fwdqdp  = addfile("/home/cuixy/Desktop/search/buget_new/data/BSISO_wdqdp.nc","r")

dqdt    = fdqdt->qten(:,{latmin:latmax},{lonmin:lonmax})
uadv    = fadv->u(:,{latmin:latmax},{lonmin:lonmax})
vadv    = fadv->v(:,{latmin:latmax},{lonmin:lonmax})
wdqdp   = fwdqdp->w(:,{latmin:latmax},{lonmin:lonmax})

msink   = -1*(dqdt + uadv + vadv + wdqdp)
copy_VarCoords(dqdt, msink)

diro = "/home/cuixy/Desktop/search/buget_new/data/"
filo = "BSISO_msink"+".nc"
system("/bin/rm -f "+diro+filo)   
ncdf = addfile(diro+filo,"c") 
ncdf->m  = msink