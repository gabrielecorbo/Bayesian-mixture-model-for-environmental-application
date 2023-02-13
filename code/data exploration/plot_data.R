source('code/data exploration/plot_functions.R')


day_above_limit(2019)

matplot1()

matplot2()

arimaModel <- arima_model()

plot_rho(arimaModel$rho)
hist_rho(arimaModel$rho)

