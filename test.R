library(tidyr)
library(dplyr)
library(broom)

source("C:/R Packages/cba/R/costTable_function.R", chdir = TRUE)
source("C:/R Packages/cba/R/cbatable_function.R", chdir = TRUE)
source("C:/R Packages/cba/R/cbasummary_function.R", chdir = TRUE)

a <- costTable(costEst = 10, priceBaseYear = 2011, openingYear = 2018, appraisalPeriod = 30, residualValuePeriod = 0,
               cpiBase = 103.8, cpiCostEst = 106.6, sppf = 1.3, spl = 1.0,
                 costYears = c(2022:2025), costProp = c(0.116, 0.437, 0.409, 0.038))
b <- timeSavings(5, 5.2, 80, 100, 10000, 12500)

c <- cbaTable(a, 30, 0, 2018, 2035, b, 14.03, 0.02, 0.05, 2011)
d <- cbaSummary(c)
