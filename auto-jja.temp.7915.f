      parameter(im=240,jm=121,km=444,km1=12,km2=37)
      real r(im,jm,km1,km2),s(im,jm),x(km2*3),y(km2*3),z
      

      open(12,file='temp.7915.noac.dat',form='unformatted',
     &access='direct',recl=im*jm)
      open(14,file='temp.7915.auto-jja.dat',form='unformatted',
     &access='direct',recl=im*jm)
   
      irec=1
      do k2=2,km2
      do k1=1,km1
      read(12,rec=irec)((r(i,j,k1,k2),i=1,im),j=1,jm)
      irec=irec+1
      enddo
      enddo

      do i=1,im
      do j=1,jm

      if(r(i,j,1,1).ne.-9.99e8) then

      do k=1,km2*3
      x(k)=0.
      y(k)=0.
      enddo

      do k2=1,km2
      do k1=6,8

      kk=k1-5+(k2-1)*3
      x(kk)=r(i,j,k1,k2)
      y(kk)=r(i,j,k1+1,k2)

      enddo
      enddo

      call corr(x,y,km2*3,z)
      s(i,j)=z

      else

      s(i,j)=-9.99e8

      endif

      enddo
      enddo

      write(14,rec=1)((s(i,j),i=1,im),j=1,jm)
      
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

