library(tidyverse)
library(gtsummary)

nlsy_cols <- c("glasses", "eyesight", "sleep_wkdy", "sleep_wknd",
							 "id", "nsibs", "samp", "race_eth", "sex", "region",
							 "income", "res_1980", "res_2002", "age_bir")
nlsy <- read_csv(here::here("data", "raw", "nlsy.csv"),
								 na = c("-1", "-2", "-3", "-4", "-5", "-998"),
								 skip = 1, col_names = nlsy_cols) |>
	mutate(region_cat = factor(region, labels = c("Northeast", "North Central", "South", "West")),
				 sex_cat = factor(sex, labels = c("Male", "Female")),
				 race_eth_cat = factor(race_eth, labels = c("Hispanic", "Black", "Non-Black, Non-Hispanic")),
				 eyesight_cat = factor(eyesight, labels = c("Excellent", "Very good", "Good", "Fair", "Poor")),
				 glasses_cat = factor(glasses, labels = c("No", "Yes")))


# Customization of `tbl_summary()`

tbl_summary(
	nlsy,
	by = sex_cat,
	include = c(sex_cat, race_eth_cat, region_cat,
							eyesight_cat, glasses, age_bir))


tbl_summary(
	nlsy,
	by = sex_cat,
	include = c(sex_cat, race_eth_cat, region_cat,
							eyesight_cat, glasses, age_bir),
	label = list(
		race_eth_cat ~ "Race/ethnicity",
		region_cat ~ "Region",
		eyesight_cat ~ "Eyesight",
		glasses ~ "Wears glasses",
		age_bir ~ "Age at first birth"
	),
	missing_text = "Missing")


tbl_summary(
	nlsy,
	by = sex_cat,
	include = c(sex_cat, race_eth_cat,
							eyesight_cat, glasses, age_bir),
	label = list(
		race_eth_cat ~ "Race/ethnicity",
		eyesight_cat ~ "Eyesight",
		glasses ~ "Wears glasses",
		age_bir ~ "Age at first birth"
	),
	missing_text = "Missing") |>
	add_p(test = list(all_continuous() ~ "t.test",
										all_categorical() ~ "chisq.test")) |>
	add_overall(col_label = "**Total**") |>
	bold_labels() |>
	modify_footnote(update = everything() ~ NA) |>
	modify_header(label = "**Variable**", p.value = "**P**")


#in-class exercise

#3. Make a tbl_summary(). Include categorical region, race/ethnicity, income, and the sleep variables (use a helper function to select those) and make sure they are nicely labeled

table_q3 <-
	nlsy |>
		tbl_summary(include = c(region_cat, race_eth_cat, income, starts_with("sleep")),
	label = list(
		race_eth_cat ~ "Race/Ethnicity",
		region_cat ~ "Region",
		income ~ "Income",
		sleep_wkdy ~ "Weekday Sleep",
		sleep_wknd ~ "Weekend Sleep"

	)

)

print(table_q3)


#4. Stratify the table by sex. Add a p-value comparing the sexes and an overall column combining both sexes.

table_q4 <-
	nlsy |>
	tbl_summary(
		by = sex_cat,
		include = c(region_cat, race_eth_cat, income, starts_with("sleep")),
							label = list(
								race_eth_cat ~ "Race/Ethnicity",
								region_cat ~ "Region",
								income ~ "Income",
								sleep_wkdy ~ "Weekday Sleep",
								sleep_wknd ~ "Weekend Sleep"

							)

	) |>

	add_p () |>
	add_overall()

print(table_q4)

#5. For the income variable, show the 10th and 90th percentiles of income with 3 digits, and for the sleep variables, show the min and the max with 1 digit.


table_q5 <-
	nlsy |>
	tbl_summary(
		by = sex_cat,
		include = c(region_cat, race_eth_cat, income, starts_with("sleep")),
		label = list(
			race_eth_cat ~ "Race/Ethnicity",
			region_cat ~ "Region",
			income ~ "Income",
			sleep_wkdy ~ "Weekday Sleep",
			sleep_wknd ~ "Weekend Sleep"

		),
		statistic = list(
			income ~"10th {p10}, 90th{p90}",
			starts_with("sleep") ~"min = {min}; max = {max}"),
		digits = list(
			income ~c(3,3),
			starts_with("sleep") ~c(1,1)
		)
		) |>

	add_p () |>
	add_overall()


print(table_q5)

#6. Add a footnote to the race/ethnicity variable with a link to the page describling how NLSY classified participants


table_q6 <-
	nlsy |>
	tbl_summary(
		by = sex_cat,
		include = c(region_cat, race_eth_cat, income, starts_with("sleep")),
		label = list(
			race_eth_cat ~ "Race/Ethnicity",
			region_cat ~ "Region",
			income ~ "Income",
			sleep_wkdy ~ "Weekday Sleep",
			sleep_wknd ~ "Weekend Sleep"

		),
		statistic = list(
			income ~"10th {p10}, 90th{p90}",
			starts_with("sleep") ~"min = {min}; max = {max}"),
		digits = list(
			income ~c(3,3),
			starts_with("sleep") ~c(1,1)
		)
	) |>


	add_p () |> #be aware of default stats and specify something else if needed
	add_overall() |>
	modify_table_styling(
		columns = label,
		rows = label ==" Race/Ethnicity",
		footnote = "see https://www.nlsinfo.org/content/cohorts/nlsy79/topical-guide/household/race-ethnicity-immigration-data"
	)


print(table_q6)

#7. Play around with the extra functions from the examples and/or from the documentation


