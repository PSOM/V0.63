subroutine ini_h 
  !     ------------------------------------------------                  
  USE header
  ! Initialize h using thermal wind balance
  ! Assume the level of no motion at z=-D  (bottom)
  ! Any density distribution is fine. 
  ! findzall has been called, so zf can be used. sigma not yet called, so wz 
  ! not usable
  implicit none
  integer i,j,k,jlim
  REAL(kind=rc_kind) :: fu(0:NJ),const,hsum,dz
  REAL :: potdens,coef

  REAL :: zl, sigup
  INTEGER :: sig
  INTEGER :: optionl


  ! in case the bottom if flat, h is defined in such a way that it exactly cancels speed at the bottom, 
  ! supposing thermal wind balace.
  if(lv_flat_bottom) then

    optionl=1

    if(optionl==1) then
      const=DL/R0
      !fu is actually fu / g and is at cell faces
      do i=1,NI
         do j=1,NJ-1
            fu(j)= 0.d0
            do k=1,NK
               !fu is at cell faces,is actually fu/g
               dz   = zf(i,j,k)-zf(i,j,k-1)
               drho = (rho(i,j+1,k)- rho(i,j,k))*vy(i,j)/LEN
               fu(j)= fu(j) + const*drho*dz
            end do
         end do
         fu(0)= fu(1)
         fu(NJ)= fu(NJ-1)
         ! at k=NK, fu = g*hy
         h(i,0)= 0.d0
         do j=1,NJ+1
            h(i,j)= h(i,j-1) - (LEN/vy(i,j))*fu(j-1)
         end do
      end do
    endif


    if(optionl==2) then    
      do i=1,NI+1
        ! at k=NK, fu = g*hy
        h(i,0)= 0.d0
        do j=1,NJ
          h(i,j)= h(i,j-1) - HL/(gpr*gj(i,j-1,1,2))*grpjfc(i,j-1,1)
        end do
      end do
    endif

 ! In the general case of non-flat bottom, h cannot cancel bottom speed.
 ! Here, it simply cancels speed at a given depth, zl, that should be within the domain at every (x,y) location.
 else

  h=0.

 endif 



  return 
END subroutine
