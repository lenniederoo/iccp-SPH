! SPHdensity.f95 --- Calculates density
subroutine CALCacceleration(R,Ac,Pressure,Density,Ch,h,n)
implicit none
real(8), intent(in) :: h
real(8), intent(in) :: Ch
integer, intent(in) :: n
real(8), intent(in) :: R(n, 3)
real(8), intent(in) :: Density(n)
real(8), intent(in) :: Pressure(n)
real(8), intent(inout) :: Ac(n ,3)
!f2py intent(in, out) Ac
real(8) :: dr(3), direction(3), pos, jpos, q, dW
integer :: i, j

do i = 0, n
    do j = 0, n
        dr = R(i,:) - R(j,:)
        pos = sum(dr**2)**0.5
	if (pos==0) then
		direction(:)=0
	else
		direction=dr/pos
	end if
	jpos=sum(R(j,:)**2)
	q=jpos/h
        if (q<1) then
   		dW=Ch*(-3*(2.-q)**2+12*(1.-q)**2)
	else if (q >= 1 .and. q<2) then
		dW=Ch*(-3*(2.-q)**2)
	else
		dW=0
        end if
	Ac(i,:)=Ac(i,:)+direction*((Pressure(i)/Density(i)**2+Pressure(j)/Density(j)**2)*dW)
    end do
end do
end subroutine
