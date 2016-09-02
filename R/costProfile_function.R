#' A Function to enter profles of scheme costs over time
#'
#' This function generates a table of expenditure proportions over time
#' @param constYears A list of years over which construction costs are assumed to be spent
#' @param constProp The proportion of construction costs  for each year specified in the constYears argument, given as a decimal. Must sum to 1.0.
#' @param supervYears A list of years over which supervision costs are assumed to be spent
#' @param supervProp The proportion of supervision costs for each year specified in the supervYears argument, given as a decimal. Must sum to 1.0.
#' @param archYears A list of years over which archaeology costs are assumed to be spent
#' @param archProp The proportion of archaeology costs for each year specified in the archYears argument, given as a decimal. Must sum to 1.0.
#' @param advYears A list of years over which advance works costs are assumed to be spent
#' @param advProp The proportion of advance works costs for each year specified in the advYears argument, given as a decimal. Must sum to 1.0.
#' @param resYears A list of years over which residual network costs are assumed to be spent
#' @param resProp The proportion of residual network costs for each year specified in the resYears argument, given as a decimal. Must sum to 1.0.
#' @param landYears A list of years over which land & property costs are assumed to be spent
#' @param landProp The proportion of land & property costs for each year specified in the landYears argument, given as a decimal. Must sum to 1.0.
#' @param planYears A list of years over which planning & design costs are assumed to be spent
#' @param planProp The proportion of planning & design costs for each year specified in the planYears argument, given as a decimal. Must sum to 1.0.
#' @keywords cba, costs
#' @return A table of cost profile over time
#' @export

costProfile <- function(
    priceBaseYear = 2011, openingYear, appraisalPeriod, residualValuePeriod,
    constYears = c(2022:2025), constProp = c(0.116, 0.437, 0.409, 0.038), supervYears = c(2022:2024), supervProp = c(0.091, 0.460, 0.448),
    archYears = c(2022:2023), archProp = c(0.763, 0.234), advYears = c(2022:2023), advProp = c(0.815, 0.185), resYears = c(2022), resProp = c(1.000),
    landYears = c(2021:2025), landProp = c(0.095, 0.320, 0.257, 0.199, 0.129), planYears = c(2019:2022), planProp = c(0.467, 0.073, 0.440, 0.019)) {
    
    costAlloc <- data_frame(year = c(priceBaseYear:((openingYear + appraisalPeriod + residualValuePeriod)-1))) %>% 
        mutate(construction = ifelse(year %in% constYears, constProp, 0)) %>% 
        mutate(supervision = ifelse(year %in% supervYears, supervProp, 0)) %>% 
        mutate(archaeology = ifelse(year %in% archYears, archProp, 0)) %>% 
        mutate(advanceWorks = ifelse(year %in% advYears, advProp, 0)) %>% 
        mutate(residualNetwork = ifelse(year %in% resYears, resProp, 0)) %>% 
        mutate(landProperty = ifelse(year %in% landYears, landProp, 0)) %>% 
        mutate(planningDesign = ifelse(year %in% planYears, planProp, 0))
}
