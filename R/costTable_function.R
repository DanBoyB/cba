#' Scheme cost profile
#'
#' This function generates a table of costs broken down by type and year for input into a CBA
#' @param cost_est The cost estimate for the scheme,  entered in factor prices (millions)
#' @param price_base_yr The price base year assumed for the appraisal. Defaults to 2011
#' @param opening_yr The assumed opening year for the scheme
#' @param appr_period The period in years over which the scheme is being appraised. Defaults to 30.
#' @param resid_period The period in years, after the appraisal period which is assumed to represent the 
#' residual value of the scheme. Defaults to 0.
#' @param cpi_base The consumer price index for the price base year. Defaults tp 103.8 for 2011 (base Dec 2006)
#' @param cpi_cost_est The consumer price index for the month and year of the scheme cost estimate
#' @param sppf The shadow price of public funds. Defaults to 1.3
#' @param spl The shadow price of labour. Defaults to 1.0
#' @param cost_yrs The range of years over which the costs are assumed to be incurred
#' @param cost_prop a vector list of the proportion of scheme costs for each year definec in the costYears argument.
#' @keywords cba, costs
#' @return A table of scheme costs per year to be input into the cbaTable() function
#' @export


cost_table <- function(cost_est, price_base_yr = 2011, opening_yr, appr_period = 30, 
                       resid_period = 0, cpi_base = 99.4, cpi_cost_est, sppf = 1.3, 
                       spl = 1.0, cost_yrs = c(2022:2025), 
                       cost_prop = c(0.116, 0.437, 0.409, 0.038)) {
    
    cost_est_adj <- cost_est * (cpi_base / cpi_cost_est) * sppf * spl
    
    cost_prop <- data_frame(year = cost_yrs, prop = cost_prop)
    
    cost_profile <- data_frame(year = c(price_base_yr:((opening_yr + appr_period + 
                                                            resid_period) - 1))) %>% 
        left_join(cost_prop, by = "year")
    
    
    cost_table <- cost_profile %>% 
        mutate(costs = cost_est_adj * cost_profile$prop) %>% 
        select(year, costs) %>% 
        filter(!is.na(costs))
    
    cost_table
}



