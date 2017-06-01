library(tidyverse)

first_yr <- 2024
horizon_yr <- 2057
modelled_yrs <- c(2039, 2054)
current_yr <- 2014
mrktCostFact <- 1.183


no_timeslices <- 3
timeslice_dur <- c(60, 60, 60)
timeslice_ann <- c(633, 2190, 734)
timeslices <- list(AM = 1, IP = 2, PM = 3)
vehicles <- list(car = 1, lgv = 2, ogv1 = 3, ogv2 = 4,
              bus = 5, light_rail = 6, heavy_rail = 7)
modes <- list(road = 1, public_transport = 2)
persons <- list(driver = 1, passenger = 2)
purpose <- list(business = 1, commuting = 2, other = 3)
user_classes <- data_frame(vehicles = unlist(vehicles))

fuel_type <- list(petrol = 2, diesel = 2, electric = 3)
disc_rate <- 0.05

purpose_splits <- read_csv("data/NTpM-purpose-splits.csv")

# Travel time benefits equations
#
# work = (0.5 * mrktCostFact) * (DS_demand + DM_demand) * ((DM_time * VoT) - (DS_time * VoT))
#
# non-work = 0.5 * (DS_demand + DM_demand) * ((DM_time * VoT) - (DS_time * VoT))


