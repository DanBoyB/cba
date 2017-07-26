#' Calculate time savings benefits over full appraisal period
#'
#' A function to read in appraisal paramaters, time savings 
#' calculated and traffic projections to calculate scheme
#' benefits from time savings
#'
#' @param opening_yr The proposed year of scheme opening
#' @param appr_period The standard appraisal period in years
#' @param resid_period The residual value period in years (in
#' addition to the standard appraisal period)
#' @param disc_rate The test discount rate as a decimal
#' @param price_base_yr The price base year assumed for the 
#' appraisal. Defaults to 2011
#' @param ave_veh_occ The average vehicle occupancy (persions
#' per vehicle)
#' @param traffic_proj A dataframe of annual traffic flow projections
#' @param time_saving A vector of time savings in hours
#'
#' @import dplyr
#' @return A dataframe of discounted scheme benefits
#' @export
#' 
time_benefits <- function(opening_yr, appr_period = 30, resid_period = 30,
                          disc_rate, price_base_yr = 2011, ave_veh_occ = 1.2,
                          traffic_proj, time_saving) {
    if (missing(opening_yr))
        stop("Need to specify opening year")
    
    if (missing(appr_period))
        stop("Need to specify appraisal period in years")
    
    if (missing(resid_period))
        stop("Need to specify residual value period in years")
    
    if (missing(disc_rate))
        stop("Need to specify test discount rate as a decimal")
    
    if (missing(price_base_yr))
        stop("Need to specify price base year")
    
    if (missing(traffic_proj))
        stop("Need to include dataframe of traffic projections")
    
    if (missing(time_saving))
        stop("Need to specify scheme time savings per vehicle")
    
    vot <- w_ave_vot                          
    
    benefits <- traffic_proj %>%
        filter(year %in% c(opening_yr:(opening_yr + appr_period + resid_period - 1))) %>% 
        left_join(vot, by = "year") %>% 
        mutate(saving = time_saving, 
               undisc_ben = vot * ts * total * ave_veh_occ, 
               disc_ben = undisc_ben / ((1 + disc_rate) ^ (year - price_base_yr))) %>% 
        select(year, disc_ben)
    
    benefits
}



