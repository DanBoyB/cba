tiicba
================
Dan Brennan
6/7/2017

A set of functions for use in the cost-benefit analysis (cba) of TII simple road realignment schemes. Includes the following functions:

`cost_table`: generates a table of present value costs (PVC) broken down by type and year for input into a CBA.

`fuel_cons`: generates a table of fuel consumption costs per km for traffic speeds between 1 and 150 kph for the standard vehicle and fuel types.

`time_saving`: reads in outline lengths and average speeds for the existing section of road and proposed scheme and estimates time savings per vehicle.

`time_benefits`: A function to read in appraisal paramaters, time savings calculated and traffic projections to calculate scheme benefits from time savings.

`fuel_cons`: generates a table of fuel consumption costs per km for traffic speeds between 1 and 150 kph for the standard vehicle and fuel types.

`nonfuel_cost_km`: generates a table of non-fuel consumption costs per km for traffic speeds between 1 and 150 kph for the standard vehicle types.

`veh_op_costs`: reads in appraisal paramaters, fuel and non-fuel costs calculated and traffic projections to calculate scheme vehicle operating costs.

*More to be added over time. The intention is to ultimately replace the PAG Unit 12 Simple Appraisal Tool with a web based app (via Shiny).*

Example
-------

Undertake a simple cost-benefit analysis of an road upgrade project in Meath. The project consists of the upgrade of a 8km section of an existing single carriageway, consisting of a new 10km alginment of Type 1 dual carriageway. An observed AADT of 18,000 and a 5% HGV content on the road was measured in 2016, with average speeds measured as 70 kph. The scheme opening year is assumed to be 2019 and the design speed of the realigned section is 100 kph.

The scheme is estimated to cost €15 million in 2016 prices.

First, load the `tiicba` package and use the `traffic_proj`function to create a table of traffic flow projections using PAG Unit 5.3 link based growth projections

``` r
library(tiicba)
library(tidyverse)
```

    ## Loading tidyverse: ggplot2
    ## Loading tidyverse: tibble
    ## Loading tidyverse: tidyr
    ## Loading tidyverse: readr
    ## Loading tidyverse: purrr
    ## Loading tidyverse: dplyr

    ## Conflicts with tidy packages ----------------------------------------------

    ## filter(): dplyr, stats
    ## lag():    dplyr, stats

``` r
proj <- traffic_proj(base_yr = 2016,
                     base_aadt = 18000,
                     opening_yr = 2019,
                     pc_hgv = 0.05,
                     region = "Mid-East")

proj
```

    ## # A tibble: 76 x 4
    ##     year      lv       hv   total
    ##    <int>   <dbl>    <dbl>   <dbl>
    ##  1  2016 6241500 328500.0 6570000
    ##  2  2017 6328881 336285.5 6665166
    ##  3  2018 6417485 344255.4 6761741
    ##  4  2019 6507330 352414.3 6859744
    ##  5  2020 6598433 360766.5 6959199
    ##  6  2021 6690811 369316.7 7060127
    ##  7  2022 6784482 378069.5 7162552
    ##  8  2023 6879465 387029.7 7266495
    ##  9  2024 6975777 396202.3 7371980
    ## 10  2025 7073438 405592.3 7479031
    ## # ... with 66 more rows

Next, calculate outline time savings using the `time_savings` function.

``` r
savings <- time_saving(ex_length = 8,
                       prop_length = 10,
                       ex_speed = 70,
                       proj_speed = 100)

savings * 60 * 60
```

    ## [1] 51.42857

The scheme time benefits can now be estimated using the `time_benefits` function.

``` r
time_ben <- time_benefits(opening_yr = 2019,
                          appr_period = 30,
                          resid_period = 0,
                          disc_rate = 0.05,
                          price_base_yr = 2011,
                          ave_veh_occ = 1.2,
                          traffic_proj = proj,
                          time_saving = savings)

time_ben %>% 
    summarise(benefits = sum(disc_ben))
```

    ## # A tibble: 1 x 1
    ##   benefits
    ##      <dbl>
    ## 1 59462951

Fuel and non-fuel operating costs for a vector of traffic speeds (eg. 1 - 150 kph) can be estimated using the `fuel_cost_km` and `nonfuel_cost_km` functions.

``` r
fuel <- fuel_cost_km(speed = c(1:150),
                     fuel_cons_param = fuel_cons_param,
                     fuel_split = fuel_split,
                     fuel_cost_2011 = fuel_cost_2011,
                     road_type = "nat_pri"
                     )

fuel
```

    ## # A tibble: 150 x 2
    ##    speed cost_per_km
    ##    <int>       <dbl>
    ##  1     1   0.7543899
    ##  2     2   0.4009198
    ##  3     3   0.2828310
    ##  4     4   0.2235940
    ##  5     5   0.1879031
    ##  6     6   0.1639894
    ##  7     7   0.1468095
    ##  8     8   0.1338413
    ##  9     9   0.1236839
    ## 10    10   0.1154967
    ## # ... with 140 more rows

``` r
non_fuel <- nonfuel_cost_km(speed = c(1:150),
                            non_fuel_param = non_fuel_param,
                            road_type = "nat_pri")

non_fuel
```

    ## # A tibble: 150 x 2
    ##    speed cost_per_km
    ##    <int>       <dbl>
    ##  1     1    95.23348
    ##  2     2    50.03993
    ##  3     3    34.97541
    ##  4     4    27.44315
    ##  5     5    22.92380
    ##  6     6    19.91089
    ##  7     7    17.75882
    ##  8     8    16.14477
    ##  9     9    14.88939
    ## 10    10    13.88509
    ## # ... with 140 more rows

The output of the `fuel_cost_km` and `nonfuel_cost_km` can then be used to calculate overall vehicle operating costs using the `veh_op_costs` function.

``` r
veh_op <- veh_op_costs(opening_yr = 2019,
                       appr_period = 30,
                       resid_period = 0,
                       disc_rate = 0.05,
                       price_base_yr = 2011,
                       ave_veh_occ = 1.2,
                       traffic_proj = proj,
                       speed_ex = 70,
                       speed_prop = 100,
                       fuel_costs = fuel,
                       non_fuel_costs = non_fuel)

veh_op %>% 
    summarise(benefits = sum(disc_costs))
```

    ## # A tibble: 1 x 1
    ##    benefits
    ##       <dbl>
    ## 1 -39022143

On the costs side, a table of scheme costs can be generated using the `costs_table` function.

``` r
costs <- cost_table(cost_est = 15000000,
                    price_base_yr = 2011,
                    opening_yr = 2019,
                    appr_period = 30,
                    resid_period = 0,
                    cpi_base = 103.8,
                    cpi_cost_est = 106.0,
                    sppf = 1.3,
                    spl = 0.8,
                    cost_yrs = c(2017:2019),
                    cost_prop = c(0.25, 0.5, 0.25))

costs
```

    ## # A tibble: 3 x 2
    ##    year   costs
    ##   <int>   <dbl>
    ## 1  2017 3819057
    ## 2  2018 7638113
    ## 3  2019 3819057

Produce a summary table of costs and benefits and calculate NPV and BCR using the `cost_benefit` function.

``` r
cost_benefit(cost_table = costs,
             time_benefits = time_ben,
             veh_op_costs = veh_op)
```

    ## # A tibble: 1 x 4
    ##        pvb      pvc     npv     bcr
    ##      <dbl>    <dbl>   <dbl>   <dbl>
    ## 1 20440807 15276226 5164581 1.33808
