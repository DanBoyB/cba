#' Produce cost benefit summary table
#'
#' This function generates a summary of the cost benefit analysis results
#' including present value of costs (PVC), present value of benefits (PVB),
#' net present value (NPV) and the benefit to costs ratio (BCR.
#' @param cost_table The table of costs output by the cost_table() function.
#' @param time_benefits The table of time beneftis output by the 
#' time_benefits() function. 
#' @param veh_op_costs The table of vehicle operating costs output by the 
#' veh_op_costs() function.
#' @keywords cba, summary, table
#' @import dplyr
#' @return A a summary of the cost benefit analysis results.
#' @export

cost_benefit <- function(cost_table, 
                         time_benefits, 
                         veh_op_costs) {
    
    costs_ben_table <- data_frame(
        year = cost_table$year[1]:time_benefits$year[nrow(time_benefits)]) %>% 
        left_join(cost_table, by = "year") %>% 
        left_join(time_benefits, by = "year") %>% 
        left_join(veh_op_costs, by = "year") %>% 
        rename(pvc = costs, time_ben = disc_ben, veh_op_costs = disc_costs) %>% 
        mutate(pvb = time_ben + veh_op_costs)
    
    costs_ben_summary <- costs_ben_table %>% 
        summarise(pvb = sum(pvb, na.rm = TRUE),
                  pvc = sum(pvc, na.rm = TRUE),
                  npv = pvb - pvc,
                  bcr = pvb / pvc)
    
    return(costs_ben_summary)
}