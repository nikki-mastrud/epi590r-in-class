#try to think of changes you might make
#I mean first of all I would want to see comments but I don't know if that's the kind of thing you're looking for here.

nlsy_cols <- c("glasses", "eyesight", "sleep_wkdy", "sleep_wknd",
							 "id", "nsibs", "samp", "race_eth", "sex", "region",
							 "income", "res_1980", "res_2002", "age_bir")

library(tidyverse)
#got a weird error about conflicts when loading this package?

setwd("~/Documents/Teaching/Emory/epi590r-in-class/data/raw/")
#Error in setwd: cannot change working directory because that wd does not exist on my computer

nlsy <- readr::read_csv("data/raw/nlsy.csv",
								 na = c("-1", "-2", "-3", "-4", "-5", "-998"),
								 skip = 1, col_names = nlsy_cols)

#new error that nlsy.csv does not exist in the current wd
#because it's in the "raw" folder
#change file name to follow path "data/raw/nlsy.csv"
#commit

library(dplyr)
nlsy <- nlsy |>
	mutate(region_cat = factor(region, labels = c("Northeast", "North Central", "South", "West")),
				 sex_cat = factor(sex, labels = c("Male", "Female")),
				 race_eth_cat = factor(race_eth, labels = c("Hispanic", "Black", "Non-Black, Non-Hispanic")),
				 eyesight_cat = factor(eyesight, labels = c("Excellent", "Very good", "Good", "Fair", "Poor")),
				 glasses_cat = factor(glasses, labels = c("No", "Yes")))
#no apparent errors

nlsy <- na.omit(nlsy)
#remove missing values
#no errors

setwd("../clean/")
#cannot change working directory error again
#wouldn't this need to be data/clean, not just clean, since the working directory ends at epi590r-in-class?

write_rds(nlsy, "nlsy-complete-cases.rds")
