library(tidyr)
library(dplyr)
library(broom)

source("C:/R Packages/cba/R/costTable_function.R", chdir = TRUE)
source("C:/R Packages/cba/R/cbatable_function.R", chdir = TRUE)
source("C:/R Packages/cba/R/cbasummary_function.R", chdir = TRUE)

a <- costTable(costEst = 60, priceBaseYear = 2011, openingYear = 2018, appraisalPeriod = 30, residualValuePeriod = 0,
               cpiBase = 103.8, cpiCostEst = 106.6, sppf = 1.3, spl = 1.0,
                 costYears = c(2022:2025), costProp = c(0.116, 0.437, 0.409, 0.038))

b <- cbaTable(a, 30, 0, 2018, 2035, 2, 4, 14.03, 0.02, 0.05, 2011)
c <- cbaSummary(b)
