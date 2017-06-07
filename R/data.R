#' Fuel consumption parameters.
#'
#' Fuel consumption parameters for use in TUBA based on WebTAG Table A1.3.8
#'
#' @format A data frame with five variables: \code{vehicle}: vehicle types,
#'  \code{a}, \code{b}, \code{c} and \code{d}: fuel consumption parameters.
"fuel_cons_param"

#' 2011 fuel costs.
#'
#' Petrol and diesel fuel costs in cents from 2011.
#'
#' @format A data frame with 2 variables: \code{fuel}, and \code{price}
"fuel_cost_2011"

#' 2011 vehicle splits.
#'
#' 2011 Fleet vehicle splits by fuel type.
#'
#' @format A data frame with 3 variables: \code{vehicle}: vehicle types,
#' \code{petrol} and \code{diesel} splits
"fuel_split"

#' PAG link based growth factors
#'
#' PAG Table 5.3.2: Annual Growth Factors by region
#'
#' @format A data frame with 5 variables: \code{reg}: Geographical reiogn as
#' per Figure 5.3.1 of PAG Unit 5.3, \code{growth}: low/central/high growth
#' scenario, \code{veh}: light vehicle (lv) or heavy vehicle (hv),
#' \code{period}: period in years 2013-2030 (1330) or 2030-2050 (3050), and
#' \code{factor}: annual growth factor
"pag_t532"
