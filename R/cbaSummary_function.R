#' Generates appraisal summary table
#'
#' This function reads in a table of discounted costs and benefits over the
#' selected appraisal period generated from the cbaTable function and produces the appraisal summary table 
#' including PVC, PVB, NPV and BCR
#' @param table The CBA table of the undiscounted and discounted costs and benefits over the appraisal period 
#' taken from the cbaTable() function
#' @keywords cba
#' @return An appraisal summary table giving the PVB, PVC, NPV and BCR values
#' @export

cbaSummary <- function(table){
    table <- table %>%
        summarise(PVC = sum(discCosts), PVB = sum(discBenefits)) %>%
        mutate(BCR = PVB/PVC) %>%
        mutate(NPV = PVB - PVC)

    return(table)
}



