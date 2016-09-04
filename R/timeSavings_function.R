#' Simple time savings estimate
#'
#' A function to estimate time savings from a simple road upgrade scheme
#' @param dmLength The length of road section in the 'Do Minumum' scenario (i.e without scheme)
#' @param dsLength The length of road section in the 'Do Something scenaio (i.e with scheme)
#' @param dmSpeedLimit The existing speed limit (kph) on the road section
#' @param dsSpeedLimit The proposed speed limit (kph)
#' @param openAadt The estimated scheme AADT in the opening year
#' @param forecastAadt The estimated scheme AADT in the forecast year
#' @keywords cba
#' @export

timeSavings <- function(dmLength, dsLength, dmSpeedLimit, dsSpeedLimit, openAadt, forecastAadt) {
    
    dmTime <- (dmLength / dmSpeedLimit)
    dsTime <- (dsLength / dsSpeedLimit)
    
    openTimeSav <- (dmTime - dsTime) * openAadt * 365
    forecastTimeSav <- (dmTime - dsTime) * forecastAadt * 365
    
    return(c(openTimeSav, forecastTimeSav))
    
}
