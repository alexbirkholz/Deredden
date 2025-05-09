**Fortran Program Dereddening for Infrared, Optical, and Ultraviolet Wavelengths.**

As light travels through space, it is "reddened" by dust. This obscures the nature of the light source because of the way that the light received looks dimmer and redder. This makes it difficult to accurately determine information about astronomical objects. "Dereddening" spectra allows for the original spectra to be recovered and analyzed.
There are several ways to deredden spectra. This project applies equations from the paper Cardelli et al. (1989) to deredden an input spectra.


**Installation**

Download deredden.f90 and replace input.dat with the data file of the spectrum you want to deredden. This data file must be in the order wavelength, flux so as to be read in properly. The units for wavelength must be micrometers, because the empirical relation determined in Cardelli et al.(1989) is stated in micrometers. Since this is the relation being applied, the input must be in those units. The code only dereddens between 0.3 and 8 micrometers; beyond that it returns 0s due to lack of parameters. Thus, for best results, the input spectrum must be within 0.3 and 8 micrometers. The input data file must also not have header text, because this will interfere with Fortran reading the file. You will also need to change the value fo n to match the maximum index of your input data file.

You must have a version of Fortran installed locally to use this. This was written on Red Hat 11.4.1-3, and has not tested on any other versions. Therefore, it may require modifications to run on other versions. To run the program, after changing file names as you need to, compile the program and run the executable.

**Usage**

This code works by applying the dereddening parameters found in Cardelli et al. (1989) to the input file. It does so by loading the data in a do loop and then using a set of nested if loops to apply the appropriate parameters to each set of data. This ensures that the entire input spectrum is dereddened. This is the beginning of the loop; similar statements continue on for each section of the electromagnetic spectrum.


		
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

Once the dereddening parameters have been applied to the whole input spectrum, the results are written to an output file. You may change the name of this output file if you so wish when running the program. The resulting data file can be used for whatever purpose you need. The output file should look something like this:

wavelength, flux

   7.4921185593040937E-002   9.8839999999999991E-013

   7.4969284040470291E-002   9.8639999999999992E-013
   
   7.5017394182578870E-002   9.8190000000000009E-013
   
   7.5065516017549475E-002   9.9440000000000008E-013
   
   7.5113649543565919E-002   1.0360000000000000E-012
   
   7.5161794758812947E-002   1.0599999999999999E-012
   
   7.5209951661476385E-002   9.9999999999999998E-013
   
   7.5258120249742988E-002   9.0810000000000004E-013

**Contributing**

Contributions are welcome. Please follow these steps:
(1) Fork the repository
(2) Create a new branch for your addition of a feature or bugfix
(3) Submit a pull request with a detailed and in-depth description of your changes.



**License**

This project is under the MIT license.

**References**

Cardelli, J. A., Clayton, G. C., & Mathis, J. S. (1989). The relationship between infrared, optical, and ultraviolet extinction. The Astrophysical Journal, 345, 245. https://doi.org/10.1086/167900

**Acknowledgements**

Alexina Birkholz thanks M. Joyce, Niall J Miller, and Eliza Frankel for assistance with Fortran, and Chip Kobulnicky for the original homework assignment in Python that started this project.
