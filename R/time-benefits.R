#' Calculate time savings benefits over full appraisal period
#'
#' A function to read in appraisal paramaters, time savings 
#' calculated and traffic projections to calculate scheme
#' benefits from time savings
#'
#' @param opening_yr 
#' @param appr_period 
#' @param resid_period 
#' @param disc_rate 
#' @param price_base_yr 
#' @param ave_veh_occ 
#' @param traffic_proj 
#' @param time_saving 
#'
#' @import readr, dplyr
#' @return A dataframe of discounted scheme benefits
#' @export
#'
#' @examples
#' 
time_benefits <- function(opening_yr, appr_period, resid_period,
                          disc_rate, price_base_yr, ave_veh_occ,
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
    
    vot <- read_csv("data/w-ave-vot.csv")                          
    
    benefits <- traffic_proj %>%
        filter(year %in% c(opening_yr:(opening_yr + appr_period + resid_period - 1))) %>% 
        left_join(vot, by = "year") %>% 
        mutate(saving = time_saving, 
               undisc_ben = vot * ts * total * ave_veh_occ, 
               disc_ben = undisc_ben / ((1 + disc_rate) ^ (year - price_base_yr))) %>% 
        select(year, disc_ben)
    
    benefits
}



