# Bayesian Mixture Model For Environmetal Application

Project for the course of Bayesian Statistics for Mathematical Engineering, academic year 2022-2023.

Project supervisors: Raffaele Argiento, Lucia Paci, Sirio Legramanti.

Team members
- Pietro Bogani ([GitHub](https://github.com/), [Linkedin]())
- Paolo Botta ([GitHub](https://github.com/ploki99), [Linkedin]())
- Silvia Caresana ([GitHub](https://github.com/silviacaresana), [Linkedin]())
- Romeo Carrara ([GitHub](https://github.com/RomeoC1999), [Linkedin](https://www.linkedin.com/in/romeo-carrara-19ab0a162/))
- Gabriele Corbo ([GitHub](https://github.com/gabrielecorbo), [Linkedin](https://www.linkedin.com/in/gabriele-corbo-657982218/))
- Luca Mainini ([GitHub](https://github.com/lucamainini), [Linkedin](https://www.linkedin.com/in/luca-mainini/))

## Description

The World Health Organization considers air pollution a major global environmental risk to human health. We are indeed simultaneously exposed to different air pollutants. A better understanding of how they behave in space and time is crucial. Our objective is to develop Bayesian-mixture-model-based clustering algorithms for environmental applications. Specifically, we focused our attention on PM10.

The model assumes a linear model

$$\mathbf{y}_i=\mathbf{Z} \boldsymbol{\alpha}_i+\boldsymbol{\theta}_i+\boldsymbol{\epsilon}_i, \quad i=1,2, \ldots, n$$

where $y$ is the concentration of the pollutant, $Z$ is a design matrix which accounts for trend and seasonality, $\theta$ is modelled as an auto-regressive process $\theta_{i t}=\rho \theta_{i, t-1}+\nu_{i t}$

Two different models have been used:

The first model we implemented was inspired by the Nieto-Barajas and Contreras-Cristan "Bayesian Non-parametric clustering for time series". It clusters according $\boldsymbol{\gamma}_i=\left(\boldsymbol{\beta}_i, \boldsymbol{\theta}_i\right)$

## Output
