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

# auxiliary_functionss code
source("code/tseriesclust.R")
source("code/tseriesclust_first.R")

# Synthetic data generator
source("code/simulations/generate_synthetic_data.R")

# Auxiliary functions necessary for the algorithm
source("code/auxiliary_functions/scaleandperiods.R")
source("code/auxiliary_functions/designmatrices.R")
source("code/auxiliary_functions/comp11.R")

# Binder loss function
source("code/simulations/binderfunction.R")

# Function for the data exploration plots
source('code/data exploration/plot_functions.R')

# Debug functions
source("code/simulations/debug/check.R")
source("code/simulations/debug/debug_theta.R")
source("code/simulations/debug/debug_alpha.R")
source("code/simulations/debug/debug_sig2eps.R")