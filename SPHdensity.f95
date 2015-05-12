! SPHdensity.f95 --- Calculates density
subroutine CALCDensity(R,Density,Mass,Ch,h,n)
implicit none
real(8), intent(in) :: h
real(8), intent(in) :: Ch
integer, intent(in) :: n
real(8), intent(in) :: R(n, 3)
real(8), intent(in) :: Mass(n)
real(8), intent(inout) :: Density(n)
!f2py intent(in, out) Density
real(8) :: dr(3), pos, q, W
integer :: i, j

do i = 1, n
    do j = 1, n
        dr = R(i,:) - R(j,:)
        pos = sum(dr**2)**0.5
	q=pos/h
        if (q<1) then
   		W=Ch*((2.-q)**3-4*(1.-q)**3)
	else if (q >= 1 .and. q<2) then
		W=Ch*(2.-q)**3
	else
		W=0
        end if
	Density(i)=Density(i)+W*Mass(j)
    end do
end do
end subroutine
