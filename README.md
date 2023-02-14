# Bayesian Mixture Model For Environmetal Application

Project for the course of Bayesian Statistics for Mathematical Engineering, academic year 2022-2023.

Project supervisors: Raffaele Argiento, Lucia Paci, Sirio Legramanti.

Team members: P. Bogani, P. Botta, S. Caresana, R. Carrara, G. Corbo, L. Mainini
<!--- - Pietro Bogani ([GitHub](https://github.com/), [Linkedin]())
- Paolo Botta ([GitHub](https://github.com/ploki99), [Linkedin]())
- Silvia Caresana ([GitHub](https://github.com/silviacaresana), [Linkedin]())
- Romeo Carrara ([GitHub](https://github.com/RomeoC1999), [Linkedin](https://www.linkedin.com/in/romeo-carrara-19ab0a162/))
- Gabriele Corbo ([GitHub](https://github.com/gabrielecorbo), [Linkedin](https://www.linkedin.com/in/gabriele-corbo-657982218/))
- Luca Mainini ([GitHub](https://github.com/lucamainini), [Linkedin](https://www.linkedin.com/in/luca-mainini/))
-->
## Description

The World Health Organization considers air pollution a major global environmental risk to human health. Only in the EU in 2020, a total of 238 000 premature deaths were linked to exposure to particulate matter. Our objective is to develop Bayesian-mixture-model-based clustering algorithms for environmental applications. Specifically, we focused our attention on PM10.
<!---
The model assumes a linear model

$$\mathbf{y}_i=\mathbf{Z} \boldsymbol{\alpha}_i+\boldsymbol{\theta}_i+\boldsymbol{\epsilon}_i, \quad i=1,2, \ldots, n$$

where $y$ is the concentration of the pollutant, $Z$ is a design matrix which accounts for trend and seasonality, $\theta$ is modelled as an auto-regressive process $\theta_{i t}=\rho \theta_{i, t-1}+\nu_{i t}$

Two different models have been used:

The first model we implemented was inspired by the Nieto-Barajas and Contreras-Cristan "Bayesian Non-parametric clustering for time series". It clusters according $\boldsymbol{\gamma}_i=\left(\boldsymbol{\beta}_i, \boldsymbol{\theta}_i\right)$
-->

### Markdown

In the files **Case study.Rmd**, **Data exploration.Rmd** and **Simulations.Rmd** is possible to find all the code to reproduce the analysis done and described in the report.

### Documents

In the folder [documents](https://github.com/gabrielecorbo/Bayesian-mixture-model-for-environmental-application/tree/main/documents) are located the report of the project, the final presentation exposed on 14 February 2023 and the three pdf files obtained from the Rmarkdown of the three main chapters.

### Code

The folder [code](https://github.com/gabrielecorbo/Bayesian-mixture-model-for-environmental-application/tree/main/code) contains:

- **tseriesclust.R** and **tseriesclust_first.R**, the scripts containing the 2 algortihms implemented
- **include_all.R**, a file that includes all the libraries and codes
- The folder [results](https://github.com/gabrielecorbo/Bayesian-mixture-model-for-environmental-application/tree/main/code/results) containing the RData of the results and a file .R with the same script of the corresponding Rmarkdown
- The folder [simulations](https://github.com/gabrielecorbo/Bayesian-mixture-model-for-environmental-application/tree/main/code/simulations) containing the file to generate the synthetic data, a folder with the codes to check the distribution of the full conditionals and a file .R with the same script of the corresponding Rmarkdown 
- The folder [data exploration](https://github.com/gabrielecorbo/Bayesian-mixture-model-for-environmental-application/tree/main/code/data%20exploration) containing two file .R with the same script of the corresponding Rmarkdown
- The folder [auxiliary_functions](https://github.com/gabrielecorbo/Bayesian-mixture-model-for-environmental-application/tree/main/code/auxiliary_functions) containing the auxiliary functions for the models.
- The folder [data](https://github.com/gabrielecorbo/Bayesian-mixture-model-for-environmental-application/tree/main/code/data) containing the datasets containing the timeseries and the stations' information.

All the code should be run setting the main folder of the repository as working directory.

### References

In the folder [references](https://github.com/gabrielecorbo/Bayesian-mixture-model-for-environmental-application/tree/main/references) are located all the references we consulted to develop the analysis.
