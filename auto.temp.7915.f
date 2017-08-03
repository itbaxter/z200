      parameter(im=240,jm=121,km=444)
      real r(im,jm,km),s(im,jm),x(km),y(km),z
      

      open(12,file='temp.7915.noac.dat',form='unformatted',
     &access='direct',recl=im*jm)
      open(14,file='temp.7915.auto.dat',form='unformatted',
     &access='direct',recl=im*jm)
   
      irec=1
      do k=1,km
      read(12,rec=irec)((r(i,j,k),i=1,im),j=1,jm)
      irec=irec+1
      enddo

      do i=1,im
      do j=1,jm
      if(r(i,j,1).ne.-9.99e8) then
      do k=1,km-1
      x(k)=r(i,j,k)
      y(k)=r(i,j,k+1)
      enddo
      call corr(x,y,km-1,z)
      s(i,j)=z
      else
      s(i,j)=-9.99e8
      endif
      enddo
      enddo


      write(14,rec=1)((s(i,j),i=1,im),j=1,jm)
     
      do i=1,im
      do j=1,jm
      if(r(i,j,1).ne.-9.99e8) then
      do k=1,km-2
      x(k)=r(i,j,k)
      y(k)=r(i,j,k+2)
      enddo
      call corr(x,y,km-2,z)
      s(i,j)=z
      else
      s(i,j)=-9.99e8
      endif
      enddo
      enddo


      write(14,rec=2)((s(i,j),i=1,im),j=1,jm)

      do i=1,im
      do j=1,jm
      if(r(i,j,1).ne.-9.99e8) then
      do k=1,km-3
      x(k)=r(i,j,k)
      y(k)=r(i,j,k+3)
      enddo
      call corr(x,y,km-3,z)
      s(i,j)=z
      else
      s(i,j)=-9.99e8
      endif
      enddo
      enddo


      write(14,rec=3)((s(i,j),i=1,im),j=1,jm)
 
      end

      subroutine corr(dex,u,lyear,cor)
      real dex(lyear),u(lyear)
      real a,b,up1,down1,down2,cor

      a=0.
      b=0.
      up1=0.
      down1=0.
      down2=0.

      do l=1,lyear
      a=a+dex(l)/real(lyear)
      b=b+u(l)/real(lyear)
      enddo

      do l=1,lyear
      dex(l)=dex(l)-a
      u(l)=u(l)-b
      enddo

      do l=1,lyear
      up1=up1+u(l)*dex(l)
      down1=down1+u(l)**2
      down2=down2+dex(l)**2
      enddo

      cor=up1/sqrt(down1)/sqrt(down2)
      end

