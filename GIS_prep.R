library(tidyverse)
library(readxl)

#Loading Data
vaccine<-read_csv("~/Downloads/kdata14-15.csv") %>% 
  select(-c("X12","X13")) %>%
  filter(Reported=="Y") %>% 
  filter(Category %in% c("Conditional","HC Practitioner Counseled PBE","PBE","PME","Pre-Jan PBE","Religious PBE"))

address<-read_excel("~/Downloads/pubschls.xlsx") %>% 
  filter(EILCode=="ELEM") %>% 
  select(CDSCode,Latitude,Longitude)

#Data Editing 
vaccine_wd<-vaccine %>%
  group_by(`School Year`,`School Code`,County,`School Type`,`School Name`) %>%
  summarise(exemption=sum(as.numeric(Count)),enrollment=max(Enrollment)) %>% mutate(School_Code=as.character(`School Code`)) 

address_wd<-address %>% mutate(School_Code=str_sub(CDSCode,9,14))


#Merging Data
merged<-left_join(vaccine_wd,address_wd,by="School_Code") %>% drop_na() %>% ungroup() %>%
  select(-c("School Code","CDSCode")) %>%
  rename(School_Year=`School Year`,School_Type=`School Type`,School_Name=`School Name`)

#Exporting 
write_csv(merged,path = "vaccine_rates")
