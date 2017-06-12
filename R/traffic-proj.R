#' Output list of traffic flow projections by year
#'
#' This function reads in base year AADT and the region in which
#' the scheme is located and outputs a list of traffic flow
#' projections based on PAG Unit 5.3 link based projections
#'
#' @param base_yr The year of observed traffic volumes
#' @param base_aadt Base year observed traffic volumes as AADT
#' @param opening_yr The proposed year of scheme opening
#' @param region The region in which the scheme is located as per 
#' PAG Unit 5.3
#'
#' @importFrom magrittr %>% 
#' @return A dataframe of annual traffic flow projections
#' @export
#' 
traffic_proj <- function(base_yr, base_aadt, pc_hgv, opening_yr, region) {
    if (missing(base_yr))
        stop("Need to specify year of observed AADT")
    
    if (missing(base_aadt))
        stop("Need to specify base year AADT")
    
    if (missing(pc_hgv))
        stop("Need to specify base year HGV percentage")
    
    if (missing(opening_yr))
        stop("Need to specify year of scheme opening")
    
    if (missing(region))
        stop("Need to specify region")
    
    growth <- pag_t532 %>% 
        filter(growth == "cen", reg == region)
    
    year <- c(base_yr:(base_yr + 75))
    annual  <-  base_aadt * 365
    hv <- annual * pc_hgv
    lv <- annual - hv
    lv_1330  <-  lv * (growth[[1, 5]] ^ (year[c(1:(2031 - base_yr))] - base_yr))
    lv_3050  <-  lv_1330[2031 - base_yr] * (growth[[3, 5]] ^ (year[c(2030 - 2030):c(2051 - 2030)] - base_yr))
    lv_50_ <- rep(lv_3050[21], tail(year, n = 1) - 2050)
    hv_1330  <-  hv * (growth[[2, 5]] ^ (year[c(1:(2031 - base_yr))] - base_yr))
    hv_3050  <-  hv_1330[[2031 - base_yr]] * (growth[[4, 5]] ^ (year[c(2030 - 2030):c(2051 - 2030)] - base_yr))
    hv_50_ <- rep(hv_3050[21], tail(year, n = 1) - 2050)
    
    lv <-  c(lv_1330, lv_3050[-1], lv_50_)
    hv <-  c(hv_1330, hv_3050[-1], hv_50_)
    
    traffic <- data_frame(year = year, lv = lv, hv = hv) %>% 
        dplyr::mutate(total = lv + hv)
    
    traffic
}