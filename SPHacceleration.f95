! SPHacceleration.f95 --- Calculates acceleration
subroutine CALCacceleration(R,velocity,Ac,Pressure,Density,Ch,h,c,n)
implicit none
real(8), intent(in) :: h
real(8), intent(in) :: c
real(8), intent(in) :: Ch
integer, intent(in) :: n
real(8), intent(in) :: R(n, 3)
real(8), intent(in) :: velocity(n, 3)
real(8), intent(in) :: Density(n)
real(8), intent(in) :: Pressure(n)
real(8), intent(inout) :: Ac(n ,3)
!f2py intent(in, out) Ac
real(8) :: dr(3), direction(3), pos, jpos, q, dW, muij, piij, dv(3)
integer :: i, j

do i = 1, n
    do j = 1, n
        dr = R(i,:) - R(j,:)
	dv = velocity(i,:) - velocity(j,:)
	muij= h*(dot_product(dv,dr))/(dot_product(dr,dr)+ 0.01*h**2)
	if (dot_product(dv,dr)<0) then
		piij=(-c*muij+2*muij**2)/((density(i)+density(j))/2)
	else
		piij=0
	end if
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
	Ac(i,:)=Ac(i,:)+direction*((Pressure(i)/Density(i)**2+Pressure(j)/Density(j)**2 + piij)*dW)
    end do
end do
end subroutine
