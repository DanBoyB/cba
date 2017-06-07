library(tidyverse)
# veh_op_costs - fuel cons
#
# L = (a + b.v + c.v2 + d.v3) / v
# Where: 
#        L = consumption, expressed in litres per kilometre;
#        v = average speed in kilometres per hour; and
#        a, b, c, d are parameters defined for each vehicle category
#

# function to read dataframe of fuel consumption paramaters and calculate
# consumption for speeds between 1 and 150kph
fuel_cons <- function(data) {
        v <- c(1:150)
    return (data_frame(speed = v,
                        cons = (data$a + (data$b * v) + (data$c * (v ^2)) + 
                                    (data$d * (v ^ 3))) / v))
}

# read in fuel consumption parameters and nest by vehicle type
fuel_cons_param <- read_csv("data/webTagA138.csv") %>% 
    group_by(vehicle) %>% 
    nest()

ntpm <- read_csv("data/ntpm-veh-totals.csv") %>% 
    gather(veh, total, 2:6)

veh_prop <- read_csv("data/pag611_t19.csv") %>% 
    gather(vehicle, prop, 2:6) %>% 
    mutate(total = ntpm$total) %>% 
    group_by(vehicle) %>% 
    summarise(prop = weighted.mean(prop, total)) %>% 
    mutate(user_class = ifelse(vehicle %in% c("car", "lgv"), "LV", "HV"))

fuel_split <- read_csv("data/fuel-split.csv") %>% 
    gather(fuel, prop, 2:3) %>% 
    rename(veh = vehicle) %>% 
    mutate(vehicle = paste(fuel, veh, sep = "_")) %>% 
    select(vehicle, prop)

fuel_cost <- read_csv("data/fuel-cost-2011.csv")

# Produce fuel consumption table
cons <- fuel_cons_param %>% 
    separate(vehicle, into = c("fuel", "veh"), sep = "_") %>% 
    mutate(cons = map(data, fuel_cons)) %>% 
    select(-data) %>% 
    unnest()

cons_car <- cons %>% 
    mutate(vehicle = paste(fuel, veh, sep = "_")) %>%
    filter(veh == "car") %>% 
    left_join(fuel_split, by = "vehicle") %>%
    mutate(cons_car = cons * prop) %>% 
    group_by(speed, veh) %>% 
    summarise(cons_car = sum(cons_car))

cons_lgv <- cons %>% 
    mutate(vehicle = paste(fuel, veh, sep = "_")) %>%
    filter(veh == "lgv") %>% 
    left_join(fuel_split, by = "vehicle") %>%
    mutate(cons_lgv = cons * prop) %>% 
    group_by(speed, veh) %>% 
    summarise(cons_lgv = sum(cons_lgv))

cons_hgv <- cons %>% 
    mutate(vehicle = paste(fuel, veh, sep = "_")) %>%
    filter(veh %in% c("ogv1", "ogv2")) %>% 
    left_join(fuel_split, by = "vehicle") %>%
    mutate(cons_hgv = cons * prop) %>% 
    group_by(speed, veh) %>% 
    summarise(cons_hgv = sum(cons_hgv))

cons_psv <- cons %>% 
    mutate(vehicle = paste(fuel, veh, sep = "_")) %>%
    filter(veh == "psv") %>% 
    left_join(fuel_split, by = "vehicle") %>%
    mutate(cons_psv = cons * prop) %>% 
    group_by(speed, veh) %>% 
    summarise(cons_psv = sum(cons_psv))



    


