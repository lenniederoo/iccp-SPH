! SPHboundaries.f95 --- Checks boundary conditions
subroutine CALCboundaries(R,velocity,boundaries,n)
implicit none
integer, intent(in) :: n
real(8), intent(in) :: boundaries(3)
real(8), intent(inout) :: R(n,3)
real(8), intent(inout) :: velocity(n,3)
!f2py intent(in, out) R, Velocity
integer :: i, j

do i = 1, n
    do j = 1, 3
	if (abs(R(i,j)) > boundaries(j)) then
	 	if (R(i,j) < 0) then
			R(i,j)=-boundaries(j)-(R(i,j)+boundaries(j))
		else
			R(i,j)=boundaries(j)-(R(i,j)-boundaries(j))
		end if
	velocity(i,j)=velocity(i,j)*-1
	end if
    end do
end do
end subroutine
