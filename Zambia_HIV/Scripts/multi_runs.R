library(jsonlite)

# Currently configured for Azure
setwd("C:/Users/maduprey/Documents/EMOD/Zambia_HIV")

# Set the number of runs for both the intervention and baseline campaigns
runs <- 3

# Intervention
for(i in 1:runs) {
  seed <- 10 + i
  folder <- paste0("pct15_", i)
  dir.create(paste0("output/", folder))
  
  config = fromJSON("config.json")
  config$parameters$Run_Number <- seed
  config$parameters$Report_Event_Recorder <- 0
  config$parameters$Report_Event_Recorder_Individual_Properties <- I(config$parameters$Report_Event_Recorder_Individual_Properties)
  config$parameters$Report_HIV_ByAgeAndGender_Collect_IP_Data <- I(config$parameters$Report_HIV_ByAgeAndGender_Collect_IP_Data)
  config$parameters$Report_HIV_ByAgeAndGender_Event_Counter_List <- I(config$parameters$Report_HIV_ByAgeAndGender_Event_Counter_List)
  config$parameters$Campaign_Filename <- "campaign_15pct.json"
  
  config.updated = toJSON(config, pretty = T, auto_unbox = T)
  write(config.updated, "config_batch.json")
  
  cmd <- paste0("C:/Users/maduprey/Documents/EMOD/Eradication.exe --config config_batch.json --input-path C:/Users/maduprey/Documents/EMOD/Zambia_HIV/Demographics --output-path output/", folder)
  shell(cmd)
}

# Baseline
for(i in 1:runs) {
  seed <- 10 + i
  folder <- paste0("baseline_", i)
  dir.create(paste0("output/", folder))
  
  config = fromJSON("config.json")
  config$parameters$Run_Number <- seed
  config$parameters$Report_Event_Recorder <- 0
  config$parameters$Report_Event_Recorder_Individual_Properties <- I(config$parameters$Report_Event_Recorder_Individual_Properties)
  config$parameters$Report_HIV_ByAgeAndGender_Collect_IP_Data <- I(config$parameters$Report_HIV_ByAgeAndGender_Collect_IP_Data)
  config$parameters$Report_HIV_ByAgeAndGender_Event_Counter_List <- I(config$parameters$Report_HIV_ByAgeAndGender_Event_Counter_List)
  config$parameters$Campaign_Filename <- "campaign_baseline.json"
  
  config.updated = toJSON(config, pretty = T, auto_unbox = T)
  write(config.updated, "config_batch.json")
  
  cmd <- paste0("C:/Users/maduprey/Documents/EMOD/Eradication.exe --config config_batch.json --input-path C:/Users/maduprey/Documents/EMOD/Zambia_HIV/Demographics --output-path output/", folder)
  shell(cmd)
}

