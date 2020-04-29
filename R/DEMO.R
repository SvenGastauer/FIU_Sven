source('./R/helper_functions.R')
#check that all dependenceis are met
check.pkg.FIU()

#################################
# Calibration sphere demo
#################################
source('./R/FIU_cal_demoApp.R')
FIUCalDemo()

#################################
# ZooScatR Demo
#################################
library(ZooScatR)
ZooScatR::DWBAapp()

#################################
# Shape dependence Demo
#################################

openHTML(x='R/FIU_shape_dependence_demo.html')
openHTML(x='R/Skaret_vignette.html')

##########################################
# Sphere Demo for g and h as well as size
##########################################

source('./R/FIU_sphere_demoApp.R')
FIUSphereDemo()
