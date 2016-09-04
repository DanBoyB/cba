#' Scheme cost profile
#'
#' This function generates a table of costs broken down by type and year for input into a CBA
#' @param costEst The cost estimate for the scheme,  entered in factor prices (millions)
#' @param priceBaseYear The price base year assumed for the appraisal. Defaults to 2011
#' @param openingYear The assumed opening year for the scheme
#' @param appraisalPeriod The period in years over which the scheme is being appraised. Defaults to 30.
#' @param residualValuePeriod The period in years, after the appraisal period which is assumed to represent the 
#' residual value of the scheme. Defaults to 0.
#' @param cpiBase The consumer price index for the price base year. Defaults tp 103.8 for 2011 (base Dec 2006)
#' @param cpiCostEst The consumer price index for the month and year of the scheme cost estimate
#' @param sppf The shadow price of public funds. Defaults to 1.3
#' @param spl The shadow price of labour. Defaults to 1.0
#' @param costYears The range of years over which the costs are assumed to be incurred
#' @param costProp a vector list of the proportion of scheme costs for each year definec in the costYears argument.
#' @keywords cba, costs
#' @return A table of scheme costs per year to be input into the cbaTable() function
#' @export


costTable <- function(costEst, priceBaseYear = 2011, openingYear, appraisalPeriod = 30, residualValuePeriod = 0, cpiBase = 103.8, cpiCostEst,
                      sppf = 1.3, spl = 1.0, costYears = c(2022:2025), costProp = c(0.116, 0.437, 0.409, 0.038)) {
    
    costEst <- costEst * (cpiBase / cpiCostEst) * sppf * spl
    
    costProfile <- data_frame(year = c(priceBaseYear:((openingYear + appraisalPeriod + residualValuePeriod)-1))) %>% 
        mutate(prop = ifelse(year %in% costYears, costProp, 0))
    
    
    costTable <- costProfile %>% 
        mutate(costs = costEst * costProfile$prop) %>% 
        select(year, costs)
    
}



