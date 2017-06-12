#' Table of non-fuel costs
#'
#' This function generates a table of non-fuel consumption costs per km for the 
#' specified vector of traffic speeds (in kph) for the standard vehicle and
#' fuel types.
#' 
#' @param speed A vector of traffic speeds.
#' @param non_fuel_param Non-fuel consumption parameters available in package 
#' 
#' @keywords cba, fuel, consumption
#' @return A table of non-fuel costs per km for the specified vector of speeds
#' 
#' @export
#' 

nonfuel_cost_km <- function(speed, non_fuel_param) {
    nonfuel_cost <- function(data) {
        v <- speed
        return (data_frame(speed = v,
                           cons = (data$a1 + (data$b1 / v))))
    }
    
    cost_table <- non_fuel_param %>% 
        group_by(vehicle, purpose, fuel) %>% 
        nest() %>% 
        mutate(cons = map(data, nonfuel_cost)) %>% 
        select(-data) %>% 
        unnest()
    
    return(cost_table)
    
}

