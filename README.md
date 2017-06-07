tiicba
================
Dan Brennan
6/7/2017

A set of functions for use in the cost-benefit analysis (cba) of TII simple road realignment schemes. Includes the following functions:

`cost_table`: generates a table of present value costs (PVC) broken down by type and year for input into a CBA.

`fuel_cons`: generates a table of fuel consumption costs per km for traffic speeds between 1 and 150 kph for the standard vehicle and fuel types.

`time_saving`: reads in outline lengths and average speeds for the existing section of road and proposed scheme and estimates time savings per vehicle.

`time_benefits`: A function to read in appraisal paramaters, time savings calculated and traffic projections to calculate scheme benefits from time savings.

More to be added over time. The intention is to ultimately replace the PAG Unit 12 Simple Appraisal Tool with a web based app (via Shiny).
