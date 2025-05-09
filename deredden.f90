program Deredden
	implicit none
	real(8) :: w, f, y, redx, RV, a, b
	integer :: i ,n
	logical :: exists

	! load in data file, assign to variables. File must be in form wavelength, flux to work properly. Cardelli, Clayton, & Mathis gives the relations in micrometers, so input data must be in micrometers.

	RV = 3.10				! average Rv value for the Milky Way. If you are implementing this where there is some
							! other value of RV, change this here to use that instead.
	n = 2799 ! data index. Check your input file and enter manually.

	! Check to see if input file exists

	inquire(file="input.dat", exist=exists)
	if (exists) then
		print *, "File exists and can be opened."
	end if

	open(5,file="input.dat", status="old",action="read")

	! Open data file. change to your filename. It is read only so that the input data isn't overwritten.	
	! read(5,*) w,f ! read in data file. w is wavelength, f is flux.
	

	! file to store results. Change name if you wish.
	open(unit=10, file="dereddened_spectra.dat", status="replace")
	write(10,*) "wavelength, flux"
	print *, "results file made"

	! loop to calculate this in multiple parts of the electromagnetic spectrum.

	do i=1,n ! index bounds for datafile

		read(5,*) w,f ! read in data file. w is wavelength, f is flux.
		! Nested if loops to apply parameters

		if (w >= 0.3) then
			if (w < 1.1) then
				! infrared relation: Cardelli, Clayton, & Mathis p.5
				redx=0.574*w**1.61 -(0.527*w**1.61)/RV
				write(10,*) redx,f
				
			else if (w >= 1.1) then
				! optical & NIR relation: Cardelli, Clayton, & Mathis p.5
				if (w < 3.3) then
					! defining y simplifies this, since this relation uses it often.
					y = w-1.82
					a = 1+0.17699*y - 0.50447*y**2 - 0.02427*y**3 + 0.72085*y**4 -0.62251*y**5 + 5.30260*y**6 -2.09002*y**7 
					b = 1.41338*y+ 2.28305*y**2 + 1.07233*y**3 -5.38434*y**4-0.62251*y**5 + 5.30260*y**6 -2.09002*y**7
					redx = a+b/RV
					write(10,*) redx,f
				
				else if (w >= 3.3) then
					! UV relation: Cardelli, Clayton, & Mathis p.6

					if (w < 5.9) then
						redx = 1.752 -0.316*w - 0.104/((w-4.67)**2+0.341) + (-3.090 + 1.825*w + 1.206/((w - 4.62)**2 + 0.263))/RV
						write(10,*) redx,f

					else if (w >= 5.9) then
						! far UV relation: Cardelli, Clayton, & Mathis p.6
						if (w<8) then
							a = 1.752 -0.316*w - 0.104/((w-4.67)**2+0.341) - 0.04473*(w - 5.9)**2 - 0.009779*(w - 5.9)**3
							b = (-3.090 + 1.825*w + 1.206/((w - 4.62)**2 + 0.263) + 0.2130*(w - 5.9)**2 + 0.1207*(w - 5.9)**3)
							redx = a + b/RV
							write(10,*) redx
						else
							! if the value is above the threshhold, the program will only return 0
							redx = 0
							f = 0
							write(10,*) redx,f
						end if

					end if
				end if
			end if
		else
			! if the value is below the threshhold, the program will only return 0
			redx = 0
			f = 0
			write(10,*) redx,f

		end if
	end do
	! close input file
	close(5)
	! close output file now that the process is done.
	close(10)

	print *, "Spectrum dereddened. Results save to dereddened_spectra.dat"

end program Deredden
