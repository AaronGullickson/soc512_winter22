# Reshaping and merging data
# Soc 512, Winter 2022


# Load libraries ----------------------------------------------------------

library(readr)
library(tidyverse)


# Load data ---------------------------------------------------------------

worldbank <- read_csv("data_examples/worldbank.csv") %>%
  rename(country_name=`Country Name`, country_code=`Country Code`,
         series_name=`Series Name`, series_code=`Series Code`,
         year=Time, time_code=`Time Code`, value=Value)
ilo <- read_csv("data_examples/ilostat.csv",
                col_types=cols(obs_status=col_character(),
                               obs_status.label=col_character())) %>%
  filter(sex=="SEX_T" & classif1=="AGE_AGGREGATE_TOTAL" & time==2014) %>%
  filter(!duplicated(ref_area)) %>%
  select(ref_area.label, ref_area, time, obs_value) %>%
  rename(country_name=ref_area.label, country_code=ref_area, year=time,
         unemp_rate=obs_value) %>%
  mutate(country_code=case_when(
    country_code=="IMN" ~ "IMY",
    country_code=="ROU" ~ "ROM",
    TRUE ~ country_code
  ))



# Reshape data ------------------------------------------------------------

# tidyverse solution
# pivot_wider, pivot_longer

# id_cols will identify unique observations
# names_from identifies row identifiers to turn into variables
# values_from identifies where values should be drawn from

worldbank <- worldbank %>%
  pivot_wider(id_cols = c(country_name, country_code, year),
              names_from = series_code, values_from = value) %>%
  rename(gdp=NY.GDP.PCAP.CD, life_exp=SP.DYN.LE00.IN, pop=SP.POP.TOTL)

# Merge data --------------------------------------------------------------

# tidyverse solution
# left_join
# right_join
# inner_join
# full_join

temp1 <- full_join(worldbank, ilo, by=c("country_code","year"))
temp2 <- left_join(worldbank, ilo, by=c("country_code","year"))
temp3 <- right_join(worldbank, ilo, by=c("country_code","year"))
temp4 <- inner_join(worldbank, ilo, by=c("country_code","year"))
