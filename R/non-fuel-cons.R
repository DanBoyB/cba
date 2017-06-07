library(tidyverse)
# veh_op_costs - fuel cons
#
# C = a1 + b1 / v
# Where: 
#        C = cost in cents per kilometre per vehicle;
#        v = average speed in kilometres per hour; and
#        a1, b1 are parameters defined for each vehicle category
#

# function to read dataframe of non-fuel consumption paramaters and calculate
# consumption for speeds between 1 and 150kph
non_fuel_cons <- function(data) {
    v <- c(1:150)
    return (data_frame(speed = v,
                       cons = (data$a1 + (data$b1 / v))))
}