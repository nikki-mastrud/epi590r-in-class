#try to think of changes you might make
#I mean first of all I would want to see comments but I don't know if that's the kind of thing you're looking for here.

nlsy_cols <- c("glasses", "eyesight", "sleep_wkdy", "sleep_wknd",
							 "id", "nsibs", "samp", "race_eth", "sex", "region",
							 "income", "res_1980", "res_2002", "age_bir")

library(tidyverse)
setwd("~/Documents/Teaching/Emory/epi590r-in-class/data/raw/")
#Error in setwd: cannot change working directory
	#I assume this is because you cannot change the wd within an R project?

nlsy <- readr::read_csv("nlsy.csv",
								 na = c("-1", "-2", "-3", "-4", "-5", "-998"),
								 skip = 1, col_names = nlsy_cols)
#Error could not find function "read_csv"
#Assume this is because we don't have the package for it
#changed code to "readr::read_csv" to load that package

library(dplyr)
nlsy <- nlsy |>
	mutate(region_cat = factor(region, labels = c("Northeast", "North Central", "South", "West")),
				 sex_cat = factor(sex, labels = c("Male", "Female")),
				 race_eth_cat = factor(race_eth, labels = c("Hispanic", "Black", "Non-Black, Non-Hispanic")),
				 eyesight_cat = factor(eyesight, labels = c("Excellent", "Very good", "Good", "Fair", "Poor")),
				 glasses_cat = factor(glasses, labels = c("No", "Yes")))

nlsy <- na.omit(nlsy)

setwd("../clean/")
write_rds(nlsy, "nlsy-complete-cases.rds")
