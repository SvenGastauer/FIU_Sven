#' Check if required packages are installed and instll those that are needed
#' @param pkg required packages as string
#' @examples
#' check.packages(c('ggplot2', 'reshape2'))

check.packages <- function(pkg){
  new.pkg <- pkg[!(pkg %in% installed.packages()[, "Package"])]
  if (length(new.pkg))
    install.packages(new.pkg, dependencies = TRUE)
  sapply(pkg, require, character.only = TRUE)
}

#' check pkg wrapper
#' Exception handling to make the installation of ZooScatR and other dependencies easier
#' @example check.pkg.FIU()
#' @export
check.pkg.FIU <- function(){
  packages <- c('ggplot2','dplyr','reshape2','ZooScatR','devtools','shiny','knitr','rmarkdown','scales','pals')
  new.pkg <- packages[!(packages %in% installed.packages()[, "Package"])]
  if(length(new.pkg)){
    message(Sys.time(),': Missing packages are ',new.pkg)
  }else{
      message(Sys.time(),': All packages requirements are met')}
  if('ZooScatR' %in% new.pkg){
    if('devtools' %in% new.pkg){
      install.packages('devtools')
      new.pkg = new.pkg[new.pkg != 'devtools']
    }
    if('rmarkdown' %in% new.pkg){
      install.packages('rmarkdown')
      new.pkg = new.pkg[new.pkg != 'rmarkdown']
    }

    devtools::install_github("AustralianAntarcticDivision/ZooScatR", build_vignettes = TRUE, force_deps=TRUE)
    new.pkg = new.pkg[new.pkg != 'ZooScatR']
  }
  if(length(new.pkg)){
    check.packages(new.pkg)
  }
  a=lapply(packages, require, character.only = TRUE)
}

#' Function to open HTML file
openHTML <- function(x) browseURL(paste0('file://', file.path(getwd(), x)))
