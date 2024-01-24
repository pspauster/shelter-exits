library(tidyverse)
library(tabulizer)
library(janitor)
library(lubridate)

current_date <- Sys.Date()

months <-  seq(as.Date("2023-05-01"), current_date %m-% months(2), by = "1 month") %>%
  data.frame(month_year = format(., "%m_%Y"))

report <- extract_tables(paste0("./temporary_housing_reports/temporary_housing_report_", month, "_", year, ".pdf"),
                         pages = c(7:10))

as.data.frame(report[[4]]) %>% remove_empty()


read_table <- function(table, agency_name) {
    as.data.frame(table) %>% 
    remove_empty() %>% 
    mutate(across(everything(), ~ifelse(row_number() == 1, gsub("[0-9]", "", .), .))) %>% 
    row_to_names(1) %>% 
    clean_names() %>% 
    mutate(agency = agency_name)
}

read_report <- function(month) {
  agency_names <- c("DHS", "HPD", "HRA", "DYCD")
  
  if(month %in% months[0:3]) {
    report <- extract_tables(paste0("./temporary_housing_reports/temporary_housing_report_", month, ".pdf"),
                             pages = c(7:10))
  } else {
    report <- extract_tables(paste0("./temporary_housing_reports/temporary_housing_report_", month, ".pdf"),
                             pages = c(8:11))
  }
  
  result <- map2_df(.x = report, .y=agency_names, ~read_table(.x, .y)) %>% 
    mutate(period = month)
  
  return(result)
  
}

read_report("05_2023")

all_months <- map_df(months$month_year, ~read_report(.x))

#consider saving and switching to markdown here

field_categorization <- all_months %>% 
  count(facility_or_program_type)

field_categorization %>% xlsx::write.xlsx("field_names_categorization.xlsx")

field_validation <- xlsx::read.xlsx("field_names_validated.xlsx", sheetIndex = 1) %>% 
  select(facility_or_program_type, category, notes)

#need to lag families 1 month and lag single adults 2 months for DHS.
shelter_exits_clean <- all_months %>% 
  select(-starts_with("x")) %>% 
  mutate(across(.cols = everything(), .fns = ~as.character(str_replace_all(.x, ",|#", "")))) %>% 
  mutate_at(vars(families_with_children:total_single_adults), ~as.numeric(if_else(.x == "<10", "0", .x))) %>% #replace under 10 with 0
  mutate_at(vars(facility_or_program_type), ~str_trim(str_replace_all(.x, "[0-3]", ""), side = "both")) %>%  #sometimes there are footnotes - can't be more than 8 or we lose S8
  left_join(months, by = c("period"="month_year")) %>% 
  rename("date" = ".") %>% 
  pivot_longer(cols = families_with_children:total_single_adults, names_to = "series", values_to = "exits") %>% 
  left_join(field_validation, by = "facility_or_program_type")

write_csv(shelter_exits_clean, "data/shelter_exits.csv")

#############################################################################


            