library(tidyverse)

setwd("/Users/mduprey/Desktop/Zambia HIV ABM/")
rer <- read.csv("/Users/mduprey/Documents/EMOD/Zambia_HIV/output/ReportEventRecorder_int.csv")

rer <- read.csv("/Users/mduprey/Documents/EMOD/Zambia_HIV/output/ReportEventRecorder.csv")

# Goals:
# For each individual, compute the cost of the care cascade broken out by each component
# Find the average for each group of interest 

hiv.pos.m <- rer %>% filter(Cohort == "Yes_HIV+" & Gender == "M")
hiv.pos.f <- rer %>% filter(Cohort == "Yes_HIV+" & Gender == "F")

hiv.neg.m <- rer %>% filter(Cohort == "Yes_HIV-" & Gender == "M")
hiv.neg.f <- rer %>% filter(Cohort == "Yes_HIV-" & Gender == "F")

rer.ids <- rer %>% pull(Individual_ID) %>% unique()
yrs_df <- data.frame("Year" = 2020:2060)
all_cost <- NULL

# Right now limiting the IDs just to like the first 10
for(i in 1:length(rer.ids)) {
  id <- rer.ids[i]
  person <- rer %>% filter(Individual_ID == id)
  dense_person <- full_join(yrs_df, person) %>% arrange(Year)
  
  ART_status <- 0
  cost_HCT <- 0
  cost_ART_staging <- 0
  cost_ART <- 0
  
  for(j in 1:nrow(dense_person)) {
    cur_event <- dense_person$Event_Name[j]
    cur_year <- dense_person$Year[j]
    
    # Turn on ART counter
    if(is.na(cur_event) == F && cur_event %in% c("StartedART", "OnART1")) {
      ART_status <- 1
    }
    
    # Turn off ART counter
    if(is.na(cur_event) == F && cur_event %in% c("StoppedART", "LostForever0", "LTFU0", "DiseaseDeaths", "NonDiseaseDeaths")) {
      ART_status <- 0
    }
    
    if(cur_year >= 2020) {
      # HCT cost
      if(is.na(cur_event) == F && cur_event == "HCTTestingLoop1") {
        cost_HCT <- cost_HCT + 3.69
      }
      
      # Blood draw cost
      if(is.na(cur_event) == F && cur_event == "ARTStaging1") {
        cost_ART_staging <- cost_ART_staging + 1.18
      }
      
      # ART cost
      if(ART_status == 1 & cur_year %% 1 == 0) {
        cost_ART <- cost_ART + 255.64
      }
    }
  }
  
  cost_total <- sum(cost_HCT, cost_ART_staging, cost_ART)

  person_cost <- data.frame("id"=id, "cost_HCT"=cost_HCT, "cost_ART_staging"=cost_ART_staging, "cost_ART"=cost_ART, "cost_total"=cost_total)
  #person_cost <- c(id, cost_HCT, cost_ART_staging, cost_ART, cost_total)
  all_cost <- rbind(all_cost, person_cost)
}

rer %>% filter(Individual_ID == 1166)

hiv.pos.m <- rer %>% filter(Cohort == "Yes_HIV+" & Gender == "M") %>% pull(Individual_ID)
hiv.pos.f <- rer %>% filter(Cohort == "Yes_HIV+" & Gender == "F") %>% pull(Individual_ID)

hiv.neg.m <- rer %>% filter(Cohort == "Yes_HIV-" & Gender == "M") %>% pull(Individual_ID)
hiv.neg.f <- rer %>% filter(Cohort == "Yes_HIV-" & Gender == "F") %>% pull(Individual_ID)

all_cost.hiv.pos.m <- all_cost %>% filter(id %in% hiv.pos.m)
all_cost.hiv.pos.f <- all_cost %>% filter(id %in% hiv.pos.f)

all_cost.hiv.neg.m <- all_cost %>% filter(id %in% hiv.neg.m)
all_cost.hiv.neg.f <- all_cost %>% filter(id %in% hiv.neg.f)

summary(all_cost.hiv.pos.m$cost_total) / 40
summary(all_cost.hiv.pos.f$cost_total) / 40

summary(all_cost.hiv.neg.m$cost_total) / 40
summary(all_cost.hiv.neg.f$cost_total) / 40


# HIV- M
mean(all_cost.hiv.neg.m$cost_HCT)
mean(all_cost.hiv.neg.m$cost_ART_staging)
mean(all_cost.hiv.neg.m$cost_ART)

# HIV- F
mean(all_cost.hiv.neg.f$cost_HCT)
mean(all_cost.hiv.neg.f$cost_ART_staging)
mean(all_cost.hiv.neg.f$cost_ART)

# HIV+ M
mean(all_cost.hiv.pos.m$cost_HCT)
mean(all_cost.hiv.pos.m$cost_ART_staging)
mean(all_cost.hiv.pos.m$cost_ART)

# HIV+ F
mean(all_cost.hiv.pos.f$cost_HCT)
mean(all_cost.hiv.pos.f$cost_ART_staging)
mean(all_cost.hiv.pos.f$cost_ART)