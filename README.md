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

Undertake a simple cost-benefit analysis of an road upgrade project in Meath. The project consists of the upgrade of a 8km section of an existing single carriageway, consisting of a new 10km alginment of Type 1 dual carriageway. An observed AADT of 8,000 and a 5% HGV content on the road was measured in 2016, with average speeds measured as 70 kph. The scheme opening year is assumed to be 2019 and the design speed of the realigned section is 100 kph.

First, we load the `tiicba` package and use the `traffic_proj`function to create a table of traffic flow projections using PAG Unit 5.3 link based growth projections

``` r
library(tiicba)

proj <- traffic_proj(base_yr = 2016,
                     base_aadt = 8000,
                     opening_yr = 2019,
                     pc_hgv = 0.05,
                     region = "Mid-East")

proj
```

    ## # A tibble: 76 x 4
    ##     year      lv       hv   total
    ##    <int>   <dbl>    <dbl>   <dbl>
    ##  1  2016 2774000 146000.0 2920000
    ##  2  2017 2812836 149460.2 2962296
    ##  3  2018 2852216 153002.4 3005218
    ##  4  2019 2892147 156628.6 3048775
    ##  5  2020 2932637 160340.7 3092977
    ##  6  2021 2973694 164140.7 3137834
    ##  7  2022 3015325 168030.9 3183356
    ##  8  2023 3057540 172013.2 3229553
    ##  9  2024 3100346 176089.9 3276435
    ## 10  2025 3143750 180263.2 3324014
    ## # ... with 66 more rows

Next, we calculate outline time savings using the `time_savings` function.

``` r
savings <- time_saving(ex_length = 8,
                       prop_length = 10,
                       ex_speed = 70,
                       proj_speed = 100)

savings * 60 * 60
```

    ## [1] 51.42857
