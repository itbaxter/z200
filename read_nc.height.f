      include 'netcdf.inc'

      parameter (im=240,jm=121,km=17,lm=444)

      integer status,id_fn1,id_fn2
      integer ID_1,ID_2,ID_3,ID_4,ID_5
      integer start1(1),inc1(1)
      integer start2(3),inc2(3)
      integer start3(4),inc3(4)
      real pout
      double precision hya(km),hyb(km)
      character*100 file1,file2
      real src1(im,jm,km,1),ps(im,jm,1)
      real p(im,jm,km),z(im,jm)
      data start1/1/,inc1/km/
      data start2/1,1,1/,inc2/im,jm,1/
      data start3/1,1,1,1/,inc3/im,jm,km,1/
      data pout/20000./

      open (100,file='temp.7917.seq',form='unformatted',
     &access='sequential')

      file1='era-initerim-temp_19792017.nc'

      status=NF_OPEN(file1,0,id_fn1)
      if(status.ne.NF_NOERR) call handle_err(status)
      write(*,*)id_fn1


      STATUS=NF_INQ_VARID(ID_fn1,'hgt',ID_1)
      IF(STATUS.NE.NF_NOERR) CALL HANDLE_ERR(STATUS)
      write(*,*)ID_1
 
      do l=1,lm

      start3(4)=l
      STATUS=NF_GET_VARA_real(ID_fn1,ID_1,start3,inc3,src1)
      IF(STATUS.NE.NF_NOERR) CALL HANDLE_ERR(STATUS)


      do k=1,km 
      write(100)((src1(i,j,k,1),i=1,im),j=1,jm)
      enddo

      enddo

      status=NF_CLOSE(ID_fn1)
      IF(STATUS.NE.NF_NOERR) CALL HANDLE_ERR(STATUS)

      end
      SUBROUTINE HANDLE_ERR(STATUS)
      include 'netcdf.inc'
      integer status
c
      IF(STATUS.NE.NF_NOERR) THEN
      PRINT*,'NETCDF ERROR'
      STOP
      ENDIF
C
      RETURN
      END       

