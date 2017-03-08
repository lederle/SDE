library(RODBC)
library(dplyr)

options(stringsAsFactors=TRUE)
rawhandle <- odbcDriverConnect('driver={SQL Server};server=VHACDWa06.vha.med.va.gov;database=CDWWork;trusted_connection=true')
a01handle <- odbcDriverConnect('driver={SQL Server};server=VHACDWa01.vha.med.va.gov;database=CDWWork;trusted_connection=true')
wghandle <- odbcDriverConnect('driver={SQL Server};server=VHACDWDWHSQL33.vha.med.va.gov;database=D03_VISN10CMES;trusted_connection=true')
  
wgdata <- sqlFetch(wghandle, "App.CDWSurgeryPull", as.is = TRUE)
dssdata <- sqlFetch(wghandle, "App.DSS_SUR", as.is = TRUE)
dssdata$caseno <- as.character(dssdata$caseno)

y <- inner_join(wgdata, dssdata, by = c("SurgeryIEN" = "caseno", "Sta3n" = "sta3n"))

y <- filter(y, CaseScheduleType == "EL" | CaseScheduleType == "A")

sapply(y[,sapply(y, is.factor)],