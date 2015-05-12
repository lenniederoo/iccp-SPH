program main
	use md_plot
	implicit none
	integer :: timesteps = 10000,  i, j, k, l
	integer, parameter :: n = 400
	real(8) :: gama = 7, rho0 = 1, deltat = 0.005, c = 10, h = 100, xs
	real(8), dimension(3) :: boundaries, dr, direction, dv
	real(8), dimension(n) :: density, Pressure
	real(8), dimension(n,3) :: velocity, positions, ac
	real(8), parameter :: pi = 4._8*datan(1._8)
	real(8) :: pos, q, W, dW, jpos, Ch, energyvariation, piij, muij

	call init_random_seed
	boundaries=(/50, 50, 50/) !Boundaries of box first two numbers are distance from 0 on both sides for X and Y, last number is floor.
	density=0d0
	velocity=0d0
	do i = 1,n
		do j = 1,3
			CALL RANDOM_NUMBER(xs)						
			positions(i,j) = xs*100 - 50
			CALL RANDOM_NUMBER(xs)	
			velocity(i,j) = xs* 250 - 125
		end do
	end do
	ac=0d0
	energyvariation = 0d0
	Ch=1./(4*pi*h**3)

	call plot_init(-boundaries(1), boundaries(1) , -boundaries(2), boundaries(2) , -boundaries(3), boundaries(3))

	do k= 1,timesteps
		energyvariation = 0d0
  		call calc_velo_pos
		call plot_points(positions)
		!print *, energyvariation
	end do   

	call plot_end

contains
	
	subroutine calc_velo_pos
		do i = 1,n
			do j = 1,3
				velocity(i,j) = velocity(i,j) + .5*(deltat)*ac(i,j)
				positions(i,j) = positions(i,j) + .5*(deltat)*velocity(i,j)
			end do
		end do
		call calc_kinenergy
		call calcboundaries
		call calc_density
		call calc_pressure
		call calc_acceleration
	end subroutine

	subroutine calc_density 
		Density = 0d0
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

	subroutine calc_pressure
		do i = 1,n
			Pressure(i)=((rho0*c**2)/gama)*(((density(i)/rho0)**gama)-1)
		end do
	end subroutine

	subroutine calc_acceleration
		Ac = 0d0
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
				energyvariation = energyvariation + (velocity(i,l)*Pressure(j)/density(j)**2 + velocity(j,l)*Pressure(i)/density(i)**2) * dW
				if ( l == 3) then
					Ac(i,l) = Ac(i,l) - 98
				end if
			end do
		    end do
		end do		
	end subroutine

	subroutine calcboundaries
		do i = 1, n
		    do j = 1, 3
			if (abs(positions(i,j)) > boundaries(j)) then
			 	if (positions(i,j) < 0) then
					positions(i,j)=-boundaries(j)-(positions(i,j)+boundaries(j))
				else
					positions(i,j)=boundaries(j)-(positions(i,j)-boundaries(j))
				end if
			velocity(i,j)=velocity(i,j)*(-1)
			end if
		    end do
		end do
	end subroutine

	! copied from ICCP coding-notes
	subroutine init_random_seed()
		implicit none
		integer, allocatable :: seed(:)
		integer :: i, n, un, istat, dt(8), pid, t(2), s
		integer(8) :: count, tms

		call random_seed(size = n)
		allocate(seed(n))
		open(newunit=un, file="/dev/urandom", access="stream",&
		form="unformatted", action="read", status="old", &
		iostat=istat)
		if (istat == 0) then
			read(un) seed
			close(un)
		else
			call system_clock(count)
			if (count /= 0) then
				t = transfer(count, t)
			else
				call date_and_time(values=dt)
				tms = (dt(1) - 1970)*365_8 * 24 * 60 * 60 * 1000 &
				+ dt(2) * 31_8 * 24 * 60 * 60 * 1000 &
				+ dt(3) * 24 * 60 * 60 * 60 * 1000 &
				+ dt(5) * 60 * 60 * 1000 &
				+ dt(6) * 60 * 1000 + dt(7) * 1000 &
				+ dt(8)
				t = transfer(tms, t)
			end if
			s = ieor(t(1), t(2))
			pid = getpid() + 1099279 ! Add a prime
			s = ieor(s, pid)
			if (n >= 3) then
				seed(1) = t(1) + 36269
				seed(2) = t(2) + 72551
				seed(3) = pid
				if (n > 3) then
					seed(4:) = s + 37 * (/ (i, i = 0, n - 4) /)
				end if
			else
				seed = s + 37 * (/ (i, i = 0, n - 1 ) /)
			end if
		end if
		call random_seed(put=seed)
	end subroutine init_random_seed

	subroutine calc_kinenergy
		
	end subroutine
end program   
    
