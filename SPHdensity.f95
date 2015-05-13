! SPHdensity.f95 --- Calculates density
subroutine CALCDensity(positions,Density,Mass,Ch,h,n)
implicit none
real(8), intent(in) :: h
real(8), intent(in) :: Ch
integer, intent(in) :: n
real(8), intent(in) :: positions(n, 3)
real(8), intent(in) :: Mass(n)
real(8), intent(inout) :: Density(n)
!f2py intent(in, out) Density
real(8) :: dr(3), pos, q, W
integer :: i, j

		do i = 1, n
		    do j = 1, n
		        pos = (positions(i,1) - positions(j,1))**2 + (positions(i,2) - positions(j,2))**2 + (positions(i,3) - positions(j,3))**2
			pos = pos**0.5
			q=pos/h
		if (q<1) then
   				W=Ch*((2.-q)**3-4*(1.-q)**3)
			else if (q >= 1 .and. q<2) then
				W=Ch*(2.-q)**3
			else
				W=0
		end if
			Density(i)=Density(i)+W*1 !Mass(j)
		    end do
			!print *, Density(i)
		end do		
end subroutine