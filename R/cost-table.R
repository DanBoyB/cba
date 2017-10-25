#' Scheme cost profile
#'
#' This function generates a table of costs broken down by type and year for input into a CBA
#' @param cost_est The cost estimate for the scheme,  entered in factor prices (millions)
#' @param price_base_yr The price base year assumed for the appraisal. Defaults to 2011
#' @param opening_yr The assumed opening year for the scheme
#' @param appr_period The period in years over which the scheme is being appraised. Defaults to 30.
#' @param disc_rate The test discount rate as a decimal.
#' @param resid_period The period in years, after the appraisal period which is assumed to represent the 
#' residual value of the scheme. Defaults to 0.
#' @param cpi_base The consumer price index for the price base year. Defaults tp 103.8 for 2011 (base Dec 2006)
#' @param cpi_cost_est The consumer price index for the month and year of the scheme cost estimate
#' @param sppf The shadow price of public funds. Defaults to 1.3
#' @param spl The shadow price of labour. Defaults to 1.0
#' @param cost_yrs The range of years over which the costs are assumed to be incurred
#' @param cost_prop a vector list of the proportion of scheme costs for each year definec in the costYears argument.
#' @keywords cba, costs
#' @import dplyr
#' @return A table of scheme costs per year to be input into the cbaTable() function
#' @export


cost_table <- function(cost_est, 
                       price_base_yr = 2011, 
                       opening_yr, 
                       appr_period = 30,
                       disc_rate = 0.05,
                       resid_period = 0,
                       cpi_base = 99.4, 
                       cpi_cost_est, 
                       sppf = 1.3, 
                       spl = 1.0,
                       labour_cont = 0.35,
                       cost_yrs = c(2022:2025), 
                       cost_prop = c(0.116, 0.437, 0.409, 0.038)) {
    
    if (missing(cost_est))
        stop("Need to specify the scheme cost estimates (in millions, factor prices)")
    
    if (missing(price_base_yr))
        stop("Need to specify the price base year")
    
    if (missing(opening_yr))
        stop("Need to specify the scheme opening year")
    
    if (missing(appr_period))
        stop("Need to specify the appraisal period in years")
    
    if (missing(resid_period))
        stop("Need to specify the residual value period in years")
    
    if (missing(cpi_base))
        stop("Need to specify the consumer price index (CPI) in the base year")
    
    if (missing(cpi_cost_est))
        stop("Need to specify the consumer price index (CPI) in the year of the cost estimate")
    
    if (missing(sppf))
        stop("Need to specify the shadow price of public funds")
    
    if (missing(spl))
        stop("Need to specify the shadow price of labour")
    
    if (missing(cost_yrs))
        stop("Need to specify the years over which costs will be incurred")
    
    if (missing(cost_prop))
        stop("Need to specify test proportion of costs spent by year")
    
    labour_adj_cost <- (cost_est * labour_cont * spl) + (cost_est - (cost_est * labour_cont))
    
    cost_est_adj <- labour_adj_cost * (cpi_base / cpi_cost_est) * sppf
    
    cost_prop <- data_frame(year = cost_yrs, prop = cost_prop)
    
    cost_profile <- data_frame(year = c(price_base_yr:((opening_yr + appr_period + 
                                                            resid_period) - 1))) %>% 
        left_join(cost_prop, by = "year")
    
    
    cost_table <- cost_profile %>% 
        mutate(undisc_costs = cost_est_adj * cost_profile$prop,
               disc_costs = undisc_costs / ((1 + disc_rate) ^ 
                                              (year - price_base_yr))) %>% 
        select(year, disc_costs) %>% 
        rename(costs = disc_costs) %>% 
        filter(!is.na(costs))
    
    cost_table
}



