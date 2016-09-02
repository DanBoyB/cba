#' A Function to generate a profile of scheme costs for input into the cbaTable() function
#'
#' This function generates a table of costs broken down by type and year for input into a CBA
#' @param baseCostFact The table of Total Scheme Budget (TSB) and Target Costs(TC) in base year factor prices output by the baseCostFact() function
#' @param costProfile The table of cost profile over time output by the costProfile() function
#' @keywords cba, costs
#' @return A table of scheme costs per year to be input into the cbaTable() function
#' @export


costTable <- function(costEst, priceBaseYear = 2011, openingYear, appraisalPeriod, residualValuePeriod, cpiBase = 103.8, cpiCostEst,
                      sppf = 1.3, spl = 1.0, costYears = c(2022:2025), costProp = c(0.116, 0.437, 0.409, 0.038)) {
    
    costEst <- costEst * (cpiBase / cpiCostEst) * sppf * spl
    
    costProfile <- data_frame(year = c(priceBaseYear:((openingYear + appraisalPeriod + residualValuePeriod)-1))) %>% 
        mutate(prop = ifelse(year %in% costYears, costProp, 0))
    
    
    costTable <- costProfile %>% 
        mutate(costs = costEst * costProfile$prop) %>% 
        select(year, costs)
    
}



