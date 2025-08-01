!
! This code is adapted from the xtb source code.
! Original source: https://github.com/grimme-lab/xtb/src/intmodes.f90
! License: LGPL-3 | GPL-3
!

subroutine zmatpr(nat,at,geo,na,nb,nc,molnum)
   use xtb_mctc_io, only : stdout
   use xtb_mctc_accuracy, only : wp
   use xtb_mctc_constants
   use xtb_mctc_symbols, only : toSymbol
   implicit none
   integer, intent(in) :: nat
   integer, intent(in) :: at(nat)
   integer, intent(in) :: na(nat),nb(nat),nc(nat)
   real(wp),intent(in) :: geo(3,nat)
   character(len=20) :: filename
   logical  :: ex
   integer  :: i,l,m,n
   integer, intent(in) :: molnum
   integer  :: ich ! file handle
   real(wp) :: bl,ang,dihed

   do i=1,nat
      l=1
      m=1
      n=1
      if(i.eq.1)then
         l=0
         m=0
         n=0
      endif
      if(i.eq.2)then
         m=0
         n=0
      endif
      if(i.eq.3)n=0
      bl=geo(1,i)
      ang=geo(2,i)*180./pi
      dihed=geo(3,i)*180./pi
      if(dihed.gt.180.0d0)dihed=dihed-360.0d0
      write(stdout,'(i4,2x,a2,f12.6,2x,f10.4,2x,f10.4,i6,2i5)')&
         &   i,toSymbol(at(i)),bl,ang,dihed,na(i),nb(i),nc(i)
   enddo

   write(filename,'("zmatrix",i0,".zmat")') molnum
   call open_file(ich,trim(filename),'w')

   write(ich,'(a2)') toSymbol(at(1))
   write(ich,'(a2,x,i0,x,f8.3)') toSymbol(at(2)), na(2), geo(1,2)
   write(ich,'(a2,x,i0,x,f8.3,x,i0,x,f8.3)') toSymbol(at(3)), na(3),&
      & geo(1,3),nb(3), geo(2,3)*180./pi

   do i=4,nat
      bl=geo(1,i)
      ang=geo(2,i)*180./pi
      dihed=geo(3,i)*180./pi
      if(dihed.gt.180.0d0)dihed=dihed-360.0d0
      write(ich,'(a2,x,i0,x,f8.3,x,i0,x,f8.3,x,i0,x,f8.3)')&
         & toSymbol(at(i)),na(i),bl,nb(i),ang,nc(i),dihed
   enddo
   write(ich,*)
   close(ich)
end subroutine zmatpr

