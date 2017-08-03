      parameter(im=240,jm=121,km1=12,km2=37)
      real r(im,jm,km1,km2),z(jm),rr(im,jm)
      real ave(im,jm,km1)
      open(12,file='temp.7915.dat',
     &form='unformatted',
     &access='direct',recl=im*jm)
      open(14,file='temp.7915.noac.dat',
     &form='unformatted',
     &access='direct',recl=im*jm)

   
      irec=1
      do k2=1,km2
      do k1=1,km1
      read(12,rec=irec)((r(i,j,k1,k2),i=1,im),j=1,jm)
      irec=irec+1
      enddo
      enddo



      do k1=1,km1
      do i=1,im
      do j=1,jm
      ave(i,j,k1)=0.
      do k2=1,km2
      ave(i,j,k1)=ave(i,j,k1)+r(i,j,k1,k2)/real(km2)
      enddo
      enddo
      enddo
      enddo
 
      do k2=1,km2
      do k1=1,km1
      do i=1,im
      do j=1,jm

      if(r(i,j,k1,k2).ne.-9.99e8) then
      r(i,j,k1,k2)=r(i,j,k1,k2)-ave(i,j,k1)
      else
      r(i,j,k1,k2)=-9.99e8
      endif

      enddo
      enddo
      enddo
      enddo

      irec=1
      do k2=1,km2
      do k1=1,km1
      write(14,rec=irec)((r(i,j,k1,k2),i=1,im),j=1,jm)
      irec=irec+1
      enddo
      enddo

      
      end
