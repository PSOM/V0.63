
subroutine heat_flux(Tdif,step)
  !     ---------------------------------------------                     
  USE header

  !     use level m                                                       
  !     computes d2s/dz2 at the cell centers.                             

  implicit none 

  INTEGER :: i,j,k,step

  !This will be the netCDF ID for the file and data variable.
  integer ncid, varid
  !Loop indexes, and error handling.
  integer ti, retval

  integer NT
  parameter (NT = 1897)
  REAL(kind=rc_kind) :: swnc(NT), qlossnc(NT), nchours(NT)
  REAL(kind=rc_kind) :: bi(NT), ci(NT), di(NT)

  REAL(kind=rc_kind) :: swtemp,qlosstemp,seval
  REAL(kind=rc_kind) :: fac, Kdfluxdzt, Kdfluxdzb, Kdfluxdzz(NK), swrd(NK)
  REAL(kind=rc_kind) :: Tdif(NI,NJ,NK)

#include "netcdf.inc"
! ----------------------------------
  
!Open the file. 
!NF_NOWRITE tells netCDF we want read-only access to the file.
  retval = nf_open(TRIM(dirin)//'input.nc', NF_NOWRITE, ncid)

!Get the varid of the data variable, based on its name.
  retval = nf_inq_varid(ncid, 'swr', varid)

!Read the data.
  retval = nf_get_var_double(ncid, varid, swnc)

!Get the varid of the data variable, based on its name.
  retval = nf_inq_varid(ncid, 'qloss', varid)

!Read the data.
  retval = nf_get_var_double(ncid, varid, qlossnc)

!Get the varid of the data variable, based on its name.
  retval = nf_inq_varid(ncid, 'time', varid)

!Read the data.
  retval = nf_get_var_double(ncid, varid, nchours)

!Interpolating the data for the current time step

  call spline(NT, nchours, swnc, bi, ci, di)
  swtemp = seval(NT, (step*dtime_dim)/(60d0*60d0), nchours, 0*swnc, bi, ci, di)

  call spline(NT, nchours, qlossnc, bi, ci, di)
  qlosstemp = seval(NT, (step*dtime_dim)/(60d0*60d0), nchours, 0*qlossnc, bi, ci, di)

  print*, 'swr,qloss = ', swtemp,qlosstemp

! ----------------------------------

! This part deals with the water type coefficients
  J_lambda1 = 0.6d0     
  J_lambda2 = 20.d0     
  J_A       = 0.62d0      
! ----------------------------------

! This part deals with short wave radiation
  swr = 0.d0
  qloss = 0.d0

  swr  (:) = swtemp
  qloss(:) = qlosstemp


  OPEN (unit=200,file=TRIM(dirout)//'swr.out')                                                  
           WRITE(200,*) swr
  OPEN (unit=300,file=TRIM(dirout)//'cool.out')                                                   
           WRITE(300,*) qloss

! ----------------------------------

  fac= 1.d0/(UL*DL*delta)

  do j=1,NJ 
    do i=1,NI 

      Kdfluxdzt = DL*( swr(j) - qloss(j) )/(R0*4187.d0)
      do k=1,NK
        swrd(k) = swr(j)*( J_A*exp(zf(NI/2,NJ/2,k)*DL/J_lambda1) + (1 - J_A)*exp(zf(NI/2,NJ/2,k)*DL/J_lambda2)   )
        Kdfluxdzz(k) = DL*( swrd(k) )/(R0*4187.d0)
      end do
      Kdfluxdzb = 0.d0

      Tdif(i,j,NK) =fac*Jac(i,j,NK)*wz(i,j,NK)*Kdfluxdzt

      do k=2,NK-1
        Tdif(i,j,k) =fac*Jac(i,j, k)*wz(i,j, k)*(Kdfluxdzz(k) - Kdfluxdzz(k-1))
      end do
      Tdif(i,j, 1) =fac*Jac(i,j, 1)*wz(i,j, 1)*Kdfluxdzb

    enddo
  enddo

return

END
