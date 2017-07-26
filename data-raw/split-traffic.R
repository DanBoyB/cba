library(tidyverse)

# Calculate vehicle and user class proportions
purpose <- purpose_splits

veh_totals <- read_csv("data-raw/ntpm-veh-totals.csv")

ave_props <- pag_611_T19 %>% 
    bind_cols(veh_totals) %>% 
    select(-road, -vehicle1) %>% 
    group_by(vehicle) %>% 
    summarise(prop = weighted.mean(prop, total)) %>% 
    mutate(class = case_when(
        vehicle %in% c("car", "lgv") ~ "LV",
        vehicle %in% c("ogv1", "ogv2", "psv") ~ "HV"))
    
class_props <- ave_props %>% 
    group_by(class) %>% 
    summarise_if(is.numeric, sum) %>% 
    rename(class_prop = prop)

ave_props <- ave_props %>% 
    left_join(class_props, by = "class") %>% 
    mutate(veh_cat_prop = prop / class_prop)

# Combine VOT, occupancy and purpose split data
veh_occ <- pag_611_T21
purp_splits <- pag_611_T22
vot <- caf_vot %>% 
    mutate(vot_perc = case_when(
        purpose == "business" ~ vot_factor,
        purpose %in% c("commute", "other") ~ vot_market)) %>% 
    select(purpose, vot_perc)

comb_values <- veh_occ %>% 
    bind_cols(purp_splits) %>% 
    select(-vehicle1, -purpose1, -flow_group1) %>% 
    rename(veh_occ = prop, purp_split = prop1) %>% 
    left_join(vot, by = "purpose")

# Calculate average VOT per vehicle type
ave_vot_veh <- comb_values %>% 
    mutate(purp_vot = vot_perc * veh_occ,
           veh_vot = purp_vot * purp_split) %>% 
    group_by(vehicle, flow_group) %>% 
    summarise(veh_vot = sum(veh_vot))

# Calculate average VOT per user class
ave_vot_class <- ave_vot_veh %>% 
    mutate(class = case_when(
        vehicle %in% c("car", "lgv") ~ "LV",
        vehicle %in% c("ogv1", "ogv2", "psv") ~ "HV")) %>% 
    left_join(ave_props, by = "vehicle") %>%
    select(-class.y, -veh_cat_prop) %>% 
    rename(class = class.x) %>% 
    mutate(veh_prop = prop / class_prop,
           class_vot = veh_vot * veh_prop) %>% 
    group_by(class, flow_group) %>% 
    summarise(class_vot = sum(class_vot))

# Calculate average VOT for all vehicles
ave_vot_all <- ave_vot_class %>% 
    left_join(class_props, by = "class") %>% 
    group_by(flow_group) %>% 
    summarise(w_ave_vot = weighted.mean(class_vot, class_prop))

# Average VOT for weekday traffic (note should replace this with weighted ave)
ave_vot <- ave_vot_all %>% 
    filter(flow_group <= 4) %>% 
    summarise_at("w_ave_vot", mean) %>% 
    as.numeric()

# VOT by year
annual_vot <- caf_vot_growth %>% 
    mutate(ave_vot = vot_growth * ave_vot) %>% 
    select(-vot_growth)

write_csv(annual_vot, "data-raw/w-ave-vot.csv")
