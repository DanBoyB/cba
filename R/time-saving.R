#' Calculate time savings based on scheme lengths & speeds
#'
#' This function reads in outline lengths and average speeds
#' for the existing section of road and proposed scheme and
#' estimates time savings per vehicle
#' 
#' @param ex_length The length (in km) of the existing road section
#' @param prop_length The length (in km) of the prposed scheme
#' @param ex_speed Current average speeds on the existing route
#' @param proj_speed Projected average speeds on upgraded route
#'
#' @return A vector of time savings in hours
#' @export
#' 
time_saving <- function(ex_length, prop_length, ex_speed, proj_speed) {
    if (missing(ex_length))
        stop("Need to specify length of existing route")
    
    if (missing(prop_length))
        stop("Need to specify length of proposed route")
    
    if (missing(ex_speed))
        stop("Need to specify existing average speed.")
    
    if (missing(proj_speed))
        stop("Need to specify projected average speed")
    
    ex_time <- ex_length / ex_speed
    proj_time <- prop_length / proj_speed
    
    savings <- ex_time - proj_time
    
    savings
}



