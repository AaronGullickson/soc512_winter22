# Lets Clean Some Data!


# Load Libraries ----------------------------------------------------------

library(readr)
library(tidyverse)


# Read the data -----------------------------------------------------------

ipums <- read_fwf("data_examples/usa_00084.dat.gz",
                  col_positions = fwf_positions(start = c(1,32,55,74,84,85,88,94),
                                                end =   c(4,41,56,83,84,87,91,96),
                                                col_names=c("year","hhwt","statefip",
                                                            "perwt","sex","age","yrmarr",
                                                            "educd")),
                  progress=TRUE,
                  col_types = cols(.default = "i"))


# Code year married --------------------------------------------------------

# a basic ifelse statement should work
summary(ipums$yrmarr)
ipums$yrmarr <- ifelse(ipums$yrmarr==0, NA, ipums$yrmarr)
summary(ipums$yrmarr)


# Code gender -------------------------------------------------------------

table(ipums$sex)
# 1=male, 2=female
# lets first use nested ifelse statements
ipums$gender <- factor(ifelse(ipums$sex==1, "Male", 
                              ifelse(ipums$sex==2, "Female", NA)),
                       levels=c("Female", "Male"))
table(ipums$sex, ipums$gender, exclude=NULL)

# tidyverse solution - using case_when
ipums$gender <- case_when(
  ipums$sex==1 ~ "Male",
  ipums$sex==2 ~ "Female",
  TRUE ~ NA_character_) %>%
  factor(levels=c("Female","Male"))
table(ipums$sex, ipums$gender, exclude=NULL)

# Education example -------------------------------------------------------

# Less than HS
# HS
# Some College
# 4-year College or more

# using case_when
ipums$high_degree <- case_when(
  ipums$educd>=2 & ipums$educd<=61 ~ "LHS",
  ipums$educd>=62 & ipums$educd<=65 ~ "HS",
  ipums$educd>=70 & ipums$educd<=100 ~ "SC",
  ipums$educd>=101 & ipums$educd<=116 ~ "C",
  TRUE ~ NA_character_) %>%
  factor(levels=c("LHS","HS","SC","C"),
         ordered = TRUE)
table(ipums$educd, ipums$high_degree, exclude=NULL)


# nested ifelse statements
ipums$high_degree <- factor(ifelse(ipums$educd>=2 & ipums$educd<=61, "LHS",
                                   ifelse(ipums$educd>=62 & ipums$educd<=65, "HS",
                                          ifelse(ipums$educd>=70 & ipums$educd<=100, "SC",
                                                 ifelse(ipums$educd>=101 & ipums$educd<=116, "C", NA)))),
                            levels=c("LHS", "HS","SC","C"), ordered = TRUE)
table(ipums$educd, ipums$high_degree, exclude=NULL)

# Tidy dataset ------------------------------------------------------------

# subset to those 18 and over and keep only necessary variables

# base R approach
analytical_data <- subset(ipums, age>=18,
                          select=c("year","statefip","age","yrmarr","gender",
                                   "high_degree"))

# tidyverse solution
analytical_data <- ipums %>%
  filter(age>=18) %>%
  select(year,statefip,age,yrmarr,gender,high_degree)

save(analytical_data, file="analytical_data.RData")


# Aggregate data ----------------------------------------------------------

# calculate mean age by state
agg_data <- aggregate(age ~ statefip, data=analytical_data, mean, na.rm=TRUE)

# calculate mean age by state and gender
agg_data <- aggregate(age ~ statefip+gender, data=analytical_data, mean, 
                      na.rm=TRUE)

# calculate mean age and mean yrmarr by state and gender
agg_data <- aggregate(cbind(age,yrmarr) ~ statefip+gender, data=analytical_data, 
                      mean, na.rm=TRUE)

# This doesn't work because it drops all cases missing yrmarr, even when
# calculating age!

# Proportion of respondents in each education category by statefip
agg_data <- aggregate(cbind(prop_lhs=high_degree == "LHS",
                            prop_hs=high_degree == "HS",
                            prop_sc=high_degree == "SC",
                            prop_c=high_degree == "C") ~ statefip+gender, 
                      data=analytical_data, mean, na.rm=TRUE)

# what if I want age as well
agg_data <- aggregate(cbind(age,
                            prop_lhs=high_degree == "LHS",
                            prop_hs=high_degree == "HS",
                            prop_sc=high_degree == "SC",
                            prop_c=high_degree == "C") ~ statefip+gender, 
                      data=analytical_data, mean, na.rm=TRUE)

# will only work if applying the same function and no missing values!

# tidyverse solution to aggregating
agg_data <- analytical_data %>%
  group_by(statefip, gender) %>%
  summarize(mean_age = mean(age, na.rm=TRUE), 
            mean_yrmarr = mean(yrmarr, na.rm=TRUE), 
            n_college = sum(high_degree=="C", na.rm=TRUE),
            n = n()) %>%
  mutate(pct_college = 100 * n_college/n)

agg_data <- analytical_data %>%
  group_by(statefip, gender) %>%
  summarize(mean_age = mean(age, na.rm=TRUE), 
            mean_yrmarr = mean(yrmarr, na.rm=TRUE), 
            pct_college = 100*mean(high_degree=="C", na.rm=TRUE),
            n = n())

# Lets reshape the aggregate data so both gender values are on the same row
data_reshape <- agg_data %>%
  pivot_wider(id_cols = c(statefip), 
              names_from = gender,
              values_from = c(mean_age, mean_yrmarr, pct_college, n)) %>%
  mutate(age_diff=mean_age_Female-mean_age_Male)
  