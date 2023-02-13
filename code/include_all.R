# Easy way to include libraries and codes

library(MASS)
library(mvtnorm)
library(salso)
library(mcclust)
library(maps)
library(progress)
library(shiny)
library(shinythemes)
library(leaflet)


source("code/tseriesclust.R")
source("code/tseriesclust_first.R")

source("code/simulations/generate_synthetic_data.R")
source("code/simulations/binderfunction.R")

# 
source("code/algorithm/scaleandperiods.R")
source("code/algorithm/designmatrices.R")
source("code/algorithm/comp11.R")
source("code/algorithm/check.R")

#
source("code/debug/debug_theta.R")
source("code/debug/debug_alpha.R")
source("code/debug/debug_sig2eps.R")