
    !##################
    !   size.h
    !
    ! This include file contains the key dimensions of the model arrays.
    !
    !------------------

    ! ntr is the number of tracers
    ! nconsume is the number of columns of the consume array.
    ! Be careful, neither ntr nor nconsume can be zero.
    INTEGER, PARAMETER :: ntr = 2, nconsume = 1


    ! NI, NJ, NK: dimensions of the model grid.
    ! ngrid, maxout, maxint,int1: key parameters for the computation of the nonhydrostatic pressure.

    INTEGER,PARAMETER :: NI=48, NJ=73,NK=32,ngrid=5,maxout=2729032, maxint= 2527740,int1= 2211840
    !--- SIZE OF HEAT FLUX INPUT ARRAY
    nq = 1897,
