source('code/data exploration/plot_functions.R')

day_above_limit(2019)

matplot1()

matplot2()

arimaModel <- arima_model()

hist(arimaModel$rho, breaks = 25,main="Distribution of rho's")
plot_rho(arimaModel$rho)

