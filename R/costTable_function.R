#' A Function to generate a profile of scheme costs for input into the cbaTable() function
#'
#' This function generates a table of costs broken down by type and year for input into a CBA
#' @param baseCostFact The table of Total Scheme Budget (TSB) and Target Costs(TC) in base year factor prices output by the baseCostFact() function
#' @param costProfile The table of cost profile over time output by the costProfile() function
#' @keywords cba, costs
#' @return A table of scheme costs per year to be input into the cbaTable() function
#' @export


costTable <- function(baseCostFact, costProfile) {
    costTable <- costProfile %>% 
        mutate(construction = baseCostFact$totalSchemeBudget[1] * costProfile$construction) %>% 
        mutate(supervision = baseCostFact$totalSchemeBudget[2] * costProfile$supervision) %>% 
        mutate(archaeology = baseCostFact$totalSchemeBudget[3] * costProfile$archaeology) %>% 
        mutate(advanceWorks = baseCostFact$totalSchemeBudget[4] * costProfile$advanceWorks) %>% 
        mutate(residualNetwork = baseCostFact$totalSchemeBudget[5] * costProfile$residualNetwork) %>% 
        mutate(landProperty = baseCostFact$totalSchemeBudget[6] * costProfile$landProperty) %>% 
        mutate(planningDesign = baseCostFact$totalSchemeBudget[7] * costProfile$planningDesign) %>% 
        mutate(total = construction + supervision + archaeology + advanceWorks + residualNetwork +
                   landProperty + planningDesign)
}



