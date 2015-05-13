! SPHacceleration.f95 --- Calculates acceleration
subroutine CALCacceleration(positions,velocity,Ac,Pressure,Density,Ch,h,c,n)
implicit none
real(8), intent(in) :: h
real(8), intent(in) :: c
real(8), intent(in) :: Ch
integer, intent(in) :: n
real(8), intent(in) :: positions(n, 3)
real(8), intent(in) :: velocity(n, 3)
real(8), intent(in) :: Density(n)
real(8), intent(in) :: Pressure(n)
real(8), intent(inout) :: Ac(n ,3)
!f2py intent(in, out) Ac
real(8) :: dr(3), direction(3), pos, jpos, q, dW, muij, piij, dv(3)
integer :: i, j, l

           do i = 1, n
		    do j = 1, n
			dr = (/ positions(i,1) - positions(j,1), positions(i,2) - positions(j,2), positions(i,3) - positions(j,3) /)
		        pos = (positions(i,1) - positions(j,1))**2 + (positions(i,2) - positions(j,2))**2 + (positions(i,3) - positions(j,3))**2
			pos = pos**0.5
			dv = (/ velocity(i,1) - velocity(j,1), velocity(i,2) - velocity(j,2), velocity(i,3) - velocity(j,3) /)!velocity(i,:) - velocity(j,:)
			muij= h*(dot_product(dv,dr))/(dot_product(dr,dr)+ 0.01*h**2)
			if (dot_product(dv,dr) < 0) then
				piij=(-1*c*muij+2*muij**2)/((density(i)+density(j))/2)
			else
				piij=0
			end if
			!print *, piij
			if (pos < 0.000001) then
				direction=0d0
			else
				direction(:)=dr(:)/pos
			end if
			jpos=positions(j,1)**2 + positions(j,2)**2 + positions(j,3)**2
			jpos = jpos**0.5
			q= pos/h !jpos/h
			!print *, q
		        if (q<1) then
		   		dW=Ch/h*(-3*(2.-q)**2+12*(1.-q)**2)
			else if (q >= 1 .and. q<2) then
				dW=Ch/h*(-3*(2.-q)**2)
			else
				dW=0
		        end if
			Ac(i,:)=Ac(i,:) - direction(:)*(Pressure(i)/Density(i)**2 + Pressure(j)/Density(j)**2 + piij)*dW                                 !((Pressure(i)/Density(i)**2+Pressure(j)/Density(j)**2 + piij)*dW)
			if (i == 10) then
				!print *, Ac(i,1), Ac(i,2), Ac(i,3), Pressure(i), Density(i), Pressure(j), Density(j), piij, dW
			end if
			!Ac(i,:)=Ac(i,:)+direction(:)*((Pressure(i)/Density(i)**2+(Pressure(j)/Density(j)**2) + piij)*dW
			do l = 1,3
				if ( l == 3) then
					Ac(i,l) = Ac(i,l) - 98
				end if
			end do
		    end do
		end do		
end subroutine
