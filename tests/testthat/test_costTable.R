context("Tests for costTable function")

test_that("costTable outputs correct format", {
    expect_is(costTable(costEst = 40, priceBaseYear = 2011, openingYear = 2018, appraisalPeriod = 30, residualValuePeriod = 0,
                        cpiBase = 103.8, cpiCostEst = 106.6, sppf = 1.3, spl = 1.0, costYears = c(2018), costProp = c(1)), "data.frame")
})

test_that("costTable outputs correct values 1", {
    expect_equal(sum(costTable(costEst = 10, priceBaseYear = 2011, openingYear = 2018, appraisalPeriod = 30, residualValuePeriod = 0,
                               cpiBase = 103.8, cpiCostEst = 106.6, sppf = 1.3, spl = 1.0,
                               costYears = c(2022:2025), costProp = c(0.116, 0.437, 0.409, 0.038))$costs), 12.65853659)
})

test_that("costTable outputs correct values 2", {
    expect_equal(sum(costTable(costEst = 150, priceBaseYear = 2011, openingYear = 2016, appraisalPeriod = 30, residualValuePeriod = 30,
                               cpiBase = 103.8, cpiCostEst = 105.2, sppf = 1.3, spl = 0.8, costYears = c(2020:2025), 
                               costProp = c(0.2, 0.4, 0.2, 0.1, 0.05, 0.05))$costs), 153.9239544)
})

test_that("costTable outputs correct values 3", {
    expect_equal(sum(costTable(costEst = 40, priceBaseYear = 2011, openingYear = 2018, appraisalPeriod = 30, residualValuePeriod = 0,
                               cpiBase = 103.8, cpiCostEst = 106.6, sppf = 1.3, spl = 1.0, costYears = c(2018), costProp = c(1))$costs), 50.634146)
})

test_that("costTable outputs correct object size", {
    
    tempf <- function(a, b = 2, ...) {
        argg <- c(as.list(environment()), list(...))
    }
    
    x <- tempf(costEst = 10, priceBaseYear = 2011, openingYear = 2025, appraisalPeriod = 30, residualValuePeriod = 30,
               cpiBase = 103.8, cpiCostEst = 106.6, sppf = 1.3, spl = 1.0,
               costYears = c(2022:2025), costProp = c(0.116, 0.437, 0.409, 0.038))
    
    c <- costTable(costEst = 10, priceBaseYear = 2011, openingYear = 2025, appraisalPeriod = 30, residualValuePeriod = 30,
                   cpiBase = 103.8, cpiCostEst = 106.6, sppf = 1.3, spl = 1.0,
                   costYears = c(2022:2025), costProp = c(0.116, 0.437, 0.409, 0.038))
    
    expect_equal(nrow(c), ((x$openingYear + x$appraisalPeriod + x$residualValuePeriod) - x$priceBaseYear))
})
