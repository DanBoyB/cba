#' Table of non-fuel costs
#'
#' This function generates a table of non-fuel consumption costs per km for the 
#' specified vector of traffic speeds (in kph) for the standard vehicle and
#' fuel types.
#' 
#' @param speed A vector of traffic speeds.
#' @param non_fuel_param Non-fuel consumption parameters available in package 
#' @param road_type road type as character vector, i.e. "m_way", "nat_pr", "nat_sec"
#' 
#' @keywords cba, fuel, consumption
#' @return A table of non-fuel costs per km for the specified vector of speeds
#' 
#' @import dplyr
#' @export
#' 

nonfuel_cost_km <- function(speed, non_fuel_param, road_type) {
    nonfuel_cost <- function(data) {
        v <- speed
        return (data_frame(speed = v,
                           cost_per_km = (data$a1 + (data$b1 / v))))
    }
    
    cost_table <- non_fuel_param %>% 
        group_by(vehicle, purpose, fuel) %>% 
        tidyr::nest() %>% 
        mutate(cons = purrr::map(data, nonfuel_cost)) %>% 
        select(-data) %>% 
        tidyr::unnest()
    
    veh_prop <- pag_611_T19 %>% 
        filter(road_type == road_type) %>% 
        rename(veh = vehicle)
    
    cost_table <- cost_table %>% 
        rename(veh = vehicle) %>% 
        left_join(veh_prop, by = "veh") %>% 
        group_by(speed) %>% 
        summarise(cost_per_km = weighted.mean(cost_per_km, prop))
    
    return(cost_table)
    
}

