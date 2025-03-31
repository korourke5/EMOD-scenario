library(dplyr)

setwd("/Users/mduprey/Documents/EMOD/Zambia_HIV/output/")

files = list.files()

for(i in files) {
  assign(i, read.csv(paste0(i, "/ReportHIVByAgeAndGender.csv")))
}

summarize.runs <- function(runs = NULL) {
  cohort <- c("Yes_HIV-", "Yes_HIV+")
  year <- c(2020, 2030, 2040, 2050, 2060)
  gender <- c(1, 0)
  df.summary <- NULL
  
  for(r in 1:length(runs)) {
    run <- as.data.frame(get(runs[r]))
    for(i in 1:length(year)) {
      for(j in 1:length(gender)) {
        for(k in 1:length(cohort)) {
          
          df.running <- run %>% 
            filter(IP_Key.Cohort == cohort[k] & Gender == gender[j]) %>% 
            filter(Year <= year[i])
          
          df.current <- df.running %>% 
            filter(Year == year[i])
          
          
          df.summary.tmp <- data.frame(Run = r,
                                       Cohort = cohort[k],
                                       Year = year[i], 
                                       Gender = gender[j], 
                                       Population = sum(df.current$Population),
                                       Infected = sum(df.current$Infected),
                                       On_ART = sum(df.current$On_ART),
                                       Pct_Infected_on_ART = (sum(df.current$On_ART) / sum(df.current$Infected)) * 100,
                                       Tested_or_ART = sum(df.current$Tested.Past.Year.or.On_ART),
                                       Pct_Tested = ((sum(df.current$Tested.Past.Year.or.On_ART) - sum(df.current$On_ART)) / sum(df.current$Population)) * 100,
                                       Died = sum(df.running$Died),
                                       Died_from_HIV = sum(df.running$Died_from_HIV),
                                       Pct_Died_from_HIV = sum(df.running$Died_from_HIV)/sum(df.running$Died) * 100)
          
          df.summary <- rbind(df.summary, df.summary.tmp)
        }
      }
    }
  }
  
  return(df.summary %>%
           group_by(Cohort, Gender, Year) %>%
           summarize(across(Population:Pct_Died_from_HIV, ~ mean(.x, na.rm = TRUE))))
}

pct.15 <- summarize.runs(files[grepl("pct15", files)])
baseline <- summarize.runs(files[grepl("baseline", files)])

setwd("/Users/mduprey/Desktop/Zambia HIV ABM/")

write.csv(pct.15, "pct_15_summary.csv", row.names = F)
write.csv(baseline, "baseline_summary.csv", row.names = F)

