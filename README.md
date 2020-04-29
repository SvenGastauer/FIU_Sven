# FIU_Sven
 Acoustic Scattering basics Lecture from 29th of April 2020

contact sgastauer@ucsd.edu for more information or comments.  

- Find the lecture presentation as pptx file in the presentation folder

## QuickStart
Easiest way to use the scripts, is to clone the repository and open the SvenFIU R Project file in RStudio.  

- DEMO.R runs through the demonstrations chronologically as they were used during the original lecture

## All files
- FIU_cal_demoApp.R :
  - R shiny app simulating calibraiton spheres
   ```   
  source('./R/FIU_cal_demoApp.R')
  FIUCalDemo()
  ```
- FIU_shape_dependence_demo.RMD & FIU_shape_dependence_demo.html 
  - R Markdown Document demonstrating the influence of different simplified krill shapes on the estimated target strength  
- FIU_sphere_demoApp
  - Analytical solution for a fluid-like sphere. Shiny app that allows quick analysis of the effect of size, ambient sound speed and density as well as g and h on TS estimates
  ```
  source('./R/FIU_sphere_demoApp.R')
  FIUSphereDemo()
  ```
- helper_functions
  - At the moment of writing this contains functions to check package availability and automated installation of missing packages and a function to opend HTML files in a browser from within R.

- skaret_vignette.Rmd, skaret_vignette.html, skaret_vignette.pdf
  - Vignette demonstrating the effect of L/a on the estimates of TS based on the krill shape from the Skaret et al paper.
- TSCal.R
  - old R function to compute the TS of a standard calibrations sphere
  ```
  #load the ts.cal function
  source('./R/TSCal.R')
  results <- ts.cal(freq=seq(90,170,by=1),c=1480,plot="yes")
  ```

- TSCal_example.R
  - Some examples on how to compute the TS values of standard calibraiton spheres.
  
  
