library(dplyr)

# Inspect ReportEventRecorder (RER) files

setwd("/Users/mduprey/Desktop/Zambia HIV ABM/")
rer <- read.csv("/Users/mduprey/Documents/EMOD/Zambia_HIV/output/pct15_1/ReportEventRecorder.csv")


# HIV- --------------------------------------------------------------------

# Get vector of all the HIV- ids
hiv.neg.ids <- rer %>% filter(Cohort == "Yes_HIV-") %>% pull(Individual_ID) %>% unique()
ids <- hiv.neg.ids

# For each id, do they ever hit the HCT Cost Logger?
any.cost.logger <- sapply(hiv.neg.ids, function(id) {
  any(rer %>% filter(Individual_ID == id) %>% pull(Event_Name) == "HCTCostLogger")
})
hiv.neg.ids[any.cost.logger == F]

# Among those who don't hit the HCT Cost Logger, do they just jump to HCT Uptake at Debut?
any.hct.at.debut <- sapply(hiv.neg.ids[any.cost.logger == F], function(id) {
  any(rer %>% filter(Individual_ID == id) %>% pull(InterventionStatus) == "HCTUptakeAtDebut")
})
hiv.neg.ids[any.cost.logger == F][any.hct.at.debut == F]


# Any HIV?
any.hiv <- sapply(hiv.neg.ids, function(id) {
  any(rer %>% filter(Individual_ID == id & HasHIV == "Y") %>% pull(Event_Name) == "DiseaseDeaths")
})
ids <- hiv.neg.ids[any.hiv == T]

n <- 1

id <- ids[n]
rer %>% 
  filter(Individual_ID == id) %>% 
  mutate(Age_Year = round(Age/365), .after = Age) %>% 
  View()
n <- n + 1



# HIV+ --------------------------------------------------------------------

# Get vector of all the HIV- ids
hiv.pos.ids <- rer %>% filter(Cohort == "Yes_HIV+") %>% pull(Individual_ID) %>% unique()
sort(hiv.pos.ids)

# For each id, what's the age at which they are selected for the cohort
cohort.start.yr <- sapply(hiv.pos.ids, function(id) {
  rer %>% filter(Individual_ID == id & Cohort == "Yes_HIV+") %>% pull(Age) %>% head(1)
})

hiv.pos.ids[cohort.start.yr/365 > 25]
cohort.start.yr[cohort.start.yr/365 >= 25]/365

# Step through each case where the cohort member is older than 24
n <- 1

id <- hiv.pos.ids[cohort.start.yr/365 >= 25][n]
rer %>% 
  filter(Individual_ID == id) %>% 
  mutate(Age_Year = round(Age/365), .after = Age) %>% 
  View()
n <- n + 1

# Exploratory

rer %>% 
  filter(Individual_ID == 140183) %>% 
  mutate(Age_Year = round(Age/365), .after = Age) %>% 
  #filter(Year >= 1980 & Cohort == "Yes_HIV-") %>% 
  View()


rer.sub <- rer %>% 
  filter(Year >= 1980 & Cohort == "Yes_HIV-") %>% 
  mutate(Age_Year = round(Age/365), .after = Age)



