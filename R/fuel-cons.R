#' Table of fuel consumption costs
#'
#' This function generates a table of fuel consumption costs per km for the 
#' specified vector of traffic speeds (in kph) for the standard vehicle and
#' fuel types.
#' @param speed A vector of traffic speeds. Defaults to between 1 and 150 kph
#' @param fuel_cons_param Fuel consumption parameters available in package 
#' @param fuel_split 2011 Fleet vehicle splits by fuel type available in 
#' package
#' @param fuel_costs Petrol and diesel fuel costs in cents from 2011 available
#'  in package
#' @keywords cba, fuel, consumption
#' @return A table of scheme costs per year to be input into the cbaTable() function
#' @export

fuel_costs_km <- function() {
    
    fuel_cons_table <- function(speed = c(1:150), 
                                fuel_cons_param = fuel_cons_param, 
                                fuel_split = fuel_split, 
                                fuel_costs = fuel_cost_2011) {
        
        fuel_cons <- function(data) {
            v <- c(1:150)
            return (data_frame(speed = v,
                               cons = (data$a + (data$b * v) + (data$c * (v ^2)) +
                                           (data$d * (v ^ 3))) / v))
        }
        
        param <- fuel_cons_param %>% 
            group_by(vehicle) %>% 
            nest()
        
        split <- fuel_split %>% 
            gather(fuel, prop, 2:3) %>% 
            rename(veh = vehicle) %>% 
            mutate(vehicle = paste(fuel, veh, sep = "_")) %>% 
            select(vehicle, prop)
        
        cons <- param %>% 
            separate(vehicle, into = c("fuel", "veh"), sep = "_") %>% 
            mutate(cons = map(data, fuel_cons)) %>% 
            select(-data) %>% 
            unnest()
        
        cost <- fuel_costs
        
        cons_veh <- cons %>% 
            mutate(vehicle = paste(fuel, veh, sep = "_")) %>%
            filter(veh == v) %>% 
            left_join(split, by = "vehicle") %>%
            left_join(cost, by = "fuel") %>%
            mutate(cost_per_km = (cons * price) / 100) %>% 
            group_by(speed, veh) %>% 
            summarise(cons_w_ave = weighted.mean(cons, prop),
                      cost_per_km = weighted.mean(cost_per_km, prop))
        
        return (cons_veh)
    }

    costs_table <- data_frame(vehicle = speed) %>% 
        mutate(cons = map(vehicle, fuel_cons_table, 
                          fuel_cons_param = fuel_cons_param,
                          fuel_split = fuel_split,
                          fuel_costs = fuel_costs)) %>% 
        unnest() %>% 
        select(-vehicle)
    
    return(costs_table)
}






    


