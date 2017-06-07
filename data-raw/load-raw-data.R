fuel_cost_2011 <- readr::read_csv("data-raw/fuel-cost-2011.csv")
fuel_cons_param <- readr::read_csv("data-raw/webTagA138.csv")
fuel_split <- readr::read_csv("data-raw/fuel-split.csv")
pag_t532 <- readr::read_csv("data-raw/pagT532.csv")

devtools::use_data(fuel_cost_2011)
devtools::use_data(fuel_cons_param)
devtools::use_data(fuel_split)
devtools::use_data(pag_t532)
