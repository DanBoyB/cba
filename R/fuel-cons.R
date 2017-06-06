library(tidyverse)
# veh_op_costs - fuel cons
#
# L = (a + b.v + c.v2 + d.v3) / v
# Where: 
#        L = consumption, expressed in litres per kilometre;
#        v = average speed in kilometres per hour; and
#        a, b, c, d are parameters defined for each vehicle category
#

fuel_cons <- function(a, b, c, d, v) {
    fuelCons = (a + (b * v) + (c * (v ^2)) + (d * (v ^ 3))) / v
}

webTagA138 <- read_csv("data/webTagA138.csv")
fuel_split <- read_csv("data/fuel-split.csv")

speed <- c(6:150)

# check the purrr:map function warnings as calcs do not match the below approach in 'test'
cons1 <- webTagA138 %>% 
    mutate(cons = map(a, fuel_cons, b = b, c = c, d = d, v = speed)) %>% 
    unnest() %>% 
    mutate(speed = rep(speed, 7)) %>% 
    select(speed, vehicle, cons)

test <- data_frame(speed) %>% 
    mutate(`Petrol Car` = (fuel_cons(webTagA138$a[1], webTagA138$b[1], webTagA138$c[1], webTagA138$d[1], speed))) %>% 
    mutate(`Diesel Car` = (fuel_cons(webTagA138$a[2], webTagA138$b[2], webTagA138$c[2], webTagA138$d[2], speed))) %>%
    mutate(`Petrol LGV` = (fuel_cons(webTagA138$a[3], webTagA138$b[3], webTagA138$c[3], webTagA138$d[3], speed))) %>%
    mutate(`Diesel LGV` = (fuel_cons(webTagA138$a[4], webTagA138$b[4], webTagA138$c[4], webTagA138$d[4], speed))) %>%
    mutate(`OGV1` = (fuel_cons(webTagA138$a[5], webTagA138$b[5], webTagA138$c[5], webTagA138$d[5], speed))) %>%
    mutate(`OGV2` = (fuel_cons(webTagA138$a[6], webTagA138$b[6], webTagA138$c[6], webTagA138$d[6], speed))) %>%
    mutate(`PSV` = (fuel_cons(webTagA138$a[7], webTagA138$b[7], webTagA138$c[7], webTagA138$d[7], speed))) %>% 
    select(-OGV2)

