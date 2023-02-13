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

# Algorithms code
source("code/tseriesclust.R")
source("code/tseriesclust_first.R")

# Synthetic data generator
source("code/simulations/generate_synthetic_data.R")

# Functions necessary for the algorithm
source("code/algorithm/scaleandperiods.R")
source("code/algorithm/designmatrices.R")
source("code/algorithm/comp11.R")

# Binder loss function
source("code/simulations/binderfunction.R")

# Function for the data exploration plots
source('code/data exploration/plot_functions.R')

# Debug functions
source("code/simulations/debug/check.R")
source("code/simulations/debug/debug_theta.R")
source("code/simulations/debug/debug_alpha.R")
source("code/simulations/debug/debug_sig2eps.R")