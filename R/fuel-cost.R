#' Table of fuel consumption costs
#'
#' This function generates a table of fuel consumption costs per km for the 
#' specified vector of traffic speeds (in kph) for the standard vehicle and
#' fuel types.
#' @param speed A vector of traffic speeds.
#' @param fuel_cons_param Fuel consumption parameters available in package 
#' @param fuel_split 2011 Fleet vehicle splits by fuel type available in 
#' package
#' @param fuel_cost_2011 Petrol and diesel fuel costs in cents from 2011 available
#'  in package
#' @param road_type road type as character vector, i.e. "m_way", "nat_pr", "nat_sec"
#' @keywords cba, fuel, consumption
#' @import dplyr
#' @return A table of fuel consumption costs per km for the specified vector of
#' speeds
#' @export

fuel_cost_km <- function(speed, 
                         fuel_cons_param, 
                         fuel_split, 
                         fuel_cost_2011,
                         road_type) {
    
    if (missing(speed))
        stop("Need to specify a vector of traffic speeds")
    
    if (missing(fuel_cons_param))
        stop("Need to specify fuel consumption parameters")
        
    if (missing(fuel_split))
        stop("Need to specify fleet splits by fuel type")
        
    if (missing(fuel_cost_2011))
        stop("Need to specify test base fuel costs")
    
    fuel_cons <- function(speed) {
        param <- fuel_cons_param
        v <- speed
        cons <- (param[[2]] + (param[[3]] * v) + 
                     (param[[4]] * (v ^2)) +
                     (param[[5]] * (v ^ 3))) / v
        return(cons)
    }
    
    cons_veh <- data_frame(speed = speed,
                           vehicle = list(fuel_cons_param[[1]])) %>% 
        mutate(cons = map(speed, fuel_cons)) %>% 
        tidyr::unnest() %>% 
        tidyr::separate(vehicle, into = c("fuel", "veh"), sep = "_") %>% 
        mutate(vehicle = paste(fuel, veh, sep = "_")) %>%
        left_join(fuel_split, by = "vehicle") %>%
        left_join(fuel_cost_2011, by = "fuel") %>%
        mutate(cost_per_km = (cons * price) / 100) %>% 
        group_by(speed, veh) %>% 
        summarise(cons_w_ave = weighted.mean(cons, prop),
                  cost_per_km = weighted.mean(cost_per_km, prop))
    
    veh_prop <- pag_611_T19 %>% 
        filter(road_type == road_type) %>% 
        rename(veh = vehicle)
    
    costs_table <- cons_veh %>% 
        left_join(veh_prop, by = "veh") %>% 
        group_by(speed) %>% 
        summarise(cost_per_km = weighted.mean(cost_per_km, prop))
    
    return(costs_table)
}






    


