library(dplyr)

fuel_cost_2011 <- readr::read_csv("data-raw/fuel-cost-2011.csv")
fuel_cons_param <- readr::read_csv("data-raw/webTagA138.csv")

fuel_split <- readr::read_csv("data-raw/fuel-split.csv") %>% 
    tidyr::gather(fuel, prop, 2:3) %>% 
    rename(veh = vehicle) %>% 
    mutate(vehicle = paste(fuel, veh, sep = "_")) %>% 
    select(vehicle, prop)

pag_t532 <- readr::read_csv("data-raw/pagT532.csv")
non_fuel_param <- readr::read_csv("data-raw/non-fuel-param.csv")
w_ave_vot <- readr::read_csv("data-raw/w-ave-vot.csv")
pag_611_T19 <- readr::read_csv("data-raw/pag-611-T19.csv")
pag_611_T21 <- readr::read_csv("data-raw/pag-611-T21.csv")
pag_611_T22 <- readr::read_csv("data-raw/pag-611-T22.csv")
caf_vot <- readr::read_csv("data-raw/caf-vot.csv")
caf_vot_growth <- readr::read_csv("data-raw/caf-vot-growth.csv")

devtools::use_data(fuel_cost_2011)
devtools::use_data(fuel_cons_param)
devtools::use_data(fuel_split)
devtools::use_data(pag_t532)
devtools::use_data(non_fuel_param)
devtools::use_data(occ_splits)
devtools::use_data(w_ave_vot)
devtools::use_data(pag_611_T19)
devtools::use_data(pag_611_T21)
devtools::use_data(pag_611_T22)
devtools::use_data(caf_vot)
devtools::use_data(caf_vot_growth)
