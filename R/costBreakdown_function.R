#' A Function to generate a profile of scheme costs (in current prices) for input into CBA
#'
#' This function generates in a table of expenditure broken down by type, with assumptions regarding public funding & labour content
#' @param construction The estimated construction element of the total scheme cost
#' @param supervision The estimated supervision element of the total scheme cost
#' @param archaeology The estimated archaeology element of the total scheme cost
#' @param advanceWorks The estimated advance works element of the total scheme cost
#' @param residualNetwork The estimated residual network element of the total scheme cost
#' @param landProperty The estimated land & property element of the total scheme cost
#' @param planningDesign The estimated planning & design element of the total scheme cost
#' @param govFunding The estimated proportion of public funding for each cost element as a list (entered as a decimal)
#' @param labourCont The estimated proportion of labour content associated with each cost element as a list (entered as a decimal)
#' @keywords cba, costs
#' @return A dataframe of expenditure broken down by type, with assumptions regarding public funding & labour content
#' @export

costBreakdown <- function(construction, supervision, archaeology, advanceWorks, residualNetwork, landProperty, planningDesign,
                          govFunding = c(1, 1, 1, 1, 1, 1, 1), labourCont = c(0.3, 0.5, 0.5, 0.3, 0.3, 0.1, 0.6)) {
    
    costBreakdown <- data_frame(expenditure = c("construction", "supervision", "archaeology", "advanceWorks", "residualNetwork", 
                                                "landProperty", "planningDesign")) %>%
        mutate(value = c(construction, supervision, archaeology, advanceWorks, residualNetwork, landProperty, planningDesign)) %>%
        mutate(govFunds = govFunding) %>% 
        mutate(labourContent = labourCont) %>% 
        mutate(percTotal = value / sum(value)) %>% 
        mutate(vatRate = c(0.135, 0.23, 0.1825, 0.135, 0.135, 0, 0.23))
}
