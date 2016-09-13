#' Generates a table of costs and Benefits
#'
#' This takes standard appraisal parameters plus time savings  and costs estimated elsewhere
#' to produce a table of discounted costs and benefits over the selected appraisal period.
#' @param costTable The capital costs of the proposed scheme output from the cbaTable function
#' @param appraisalPeriod The number of years over which the scheme should be appraised
#' @param residualValuePeriod The numnber of years beyond the appraisal period where the scheme benefits can be taken as a residual value
#' @param openingYear The proposed opening year for the scheme being appraised
#' @param forecastYear A future year for which where scheme impacts have been forecast
#' @param timeSavings The estimated time savings (in hours) due to the scheme in the opening year and forecast year
#' as a list, (i.e. c(x, y)). Can also use output by the timeSavings() function.
#' @param aveVoT An average value of time assumed for the calculation of scheme benefits
#' @param discountRate The project discount rate used to convert future year prices to the price base year
#' @param priceBaseYear The year that all appraisal prices are to be represented in
#' @return A table of the undiscounted and discounted costs and benefits over the appraisal period.
#' @keywords cba
#' @export

cbaTable <- function(costTable, appraisalPeriod, residualValuePeriod, openingYear, forecastYear, timeSavings, aveVoT, 
                     discountRate, priceBaseYear) {
    
    year <- c(priceBaseYear:((openingYear + appraisalPeriod + residualValuePeriod)-1))
    modBenefits <- data.frame(Year = c(openingYear, forecastYear), Savings = timeSavings) %>% 
        mutate(Savings = (Savings * aveVoT) / 1000000)
    benGrowth <- tidy(lm(Savings ~ Year, data = modBenefits))
    
    
    benefitsTable <- data.frame(Year = year) %>% 
        mutate(undiscCosts = costTable$costs) %>%
        mutate(discCosts = undiscCosts / ((1 + discountRate) ^ (Year - priceBaseYear))) %>%
        mutate(votGrowth = ifelse(year <= 2014, 1.04, 
                                  ifelse(year >= 2015 & year <= 2019, 1.036,
                                         ifelse(year >= 2020 & year <= 2024, 1.022,
                                                ifelse(year >= 2025, 1.023,0)
                                         )))) %>% 
        mutate(undiscBenefits = (benGrowth$estimate[1] + Year*benGrowth$estimate[2]) * ((votGrowth) ^ (Year - priceBaseYear))) %>%
        mutate(discBenefits = undiscBenefits / ((1 + discountRate) ^ (Year - priceBaseYear))) %>% 
        select(-votGrowth)
    
    
}


