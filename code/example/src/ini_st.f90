subroutine ini_st 
  !     --------------------                                              
  USE header
!     initializes s as pot.density with a single vertical profile       
!     Across-front use the TANH profile with tightness as a measure of f
!     spread                                                            
!     Larger the factor, tighter the front and larger b_xx.             
!     tightness=4, gives the needed b_xx to make b_xx H/ (2f^2) < 1.    
  IMPLICIT NONE 
  integer  i,j,k,iseed,nplm1,iter,iter2 
  integer ic,jc
  real :: jlim,jloc
  real :: coef,coef2,coef3,zeff,rv,zv
  real :: intdepth
  integer, parameter :: npl=33
  REAL(kind=rc_kind) :: rhovert(npl),Tvert(npl),svert(npl),dep(npl),depoff(npl) 
  REAL(kind=rc_kind) :: bs1(npl),cs1(npl),ds1(npl),bT1(npl),cT1(npl),dT1(npl),z(NK+2),seval,zmm, &
 & sbkgrnd,Tbkgrnd,z1,z2,zprev,alpha,dtdz,dsdz
  REAL(kind=rc_kind) :: slfac,dscl,rdscl,yarg,ex2y,thy,ran3,perturb,slfacnew,dz,bfsqbkgrnd,wiggles,amplitude             
                                                                   
  REAL :: dxvor, dyvor, xcenter, ycenter
 
!   s(:,:,:,0)=1025.5;  s(:,:,:,1)=0.;


  ! BACKGROUND STRATIFICATION
 do j=0,NJ+1 
   do i=0,NI+1
       z= DL*zc(i,j,:) 
      !  s(i,j,:,1) = 1025-TANH(0.025*(z+150))
       s(i,j,:,1) = 1025-0.3*z/100
   enddo
 enddo

 s(:,:,:,0)=s(:,:,:,0)+s(:,:,:,1); s(:,:,:,1)=0.;


  do k=0,NK+1 
     do i=1,NI 
        s(i,0,k,0)= s(i,1,k,0) 
        s(i,NJ+1,k,0)= s(i,NJ,k,0) 
        T(i,0,k,0)= T(i,1,k,0) 
        T(i,NJ+1,k,0)= T(i,NJ,k,0) 
     end do 
 ! periodicew                                                        
     do j=0,NJ+1 
        s(0,j,k,0)= s(NI,j,k,0) 
        s(NI+1,j,k,0)= s(1,j,k,0) 
        T(0,j,k,0)= T(NI,j,k,0) 
        T(NI+1,j,k,0)= T(1,j,k,0) 
     end do 
  end do 
                                                                    
                                                                    
  return 
  END                                           
