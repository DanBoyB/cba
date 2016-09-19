
ggplot(benefitsTable, aes(Year, (undiscBenefits))) + 
    geom_area(stat = "identity", fill = "green", alpha = 0.3) +
    geom_area(aes(Year, discCosts), stat = "identity", fill = "red", alpha = 0.3)
