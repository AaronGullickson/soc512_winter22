# Programming in R

# Load libraries ----------------------------------------------------------

library(readr)
library(tidyverse)

# Read data ---------------------------------------------------------------

tracts <- read_csv("data_examples/tracts_state.csv")

# Calculate Theil H for Alabama -------------------------------------------

alabama_tracts <- subset(tracts, statename=="Alabama")

# calculate entropy for each tract
alabama_tracts <- alabama_tracts %>%
  mutate(total=white+latino+black+asian+indigenous+other,
         p_white=white/total, p_latino=latino/total, p_black=black/total,
         p_asian=asian/total, p_indig=indigenous/total, p_other=other/total)
props <- as.matrix(alabama_tracts[,c("p_white","p_black","p_latino",
                                     "p_asian","p_indig","p_other")])
alabama_tracts <- alabama_tracts %>%
  mutate(entropy=apply(props*log(1/props), 1, sum, na.rm=TRUE))

# aggregate Alabama
alabama_state <- alabama_tracts %>%
  select(statename, white, black, latino, asian, indigenous, other) %>%
  group_by(statename) %>%
  summarize_all(sum) %>%
  mutate(total=white+latino+black+asian+indigenous+other,
         p_white=white/total, p_latino=latino/total, p_black=black/total,
         p_asian=asian/total, p_indig=indigenous/total, p_other=other/total,
         entropy=p_white*log(1/p_white)+p_latino*log(1/p_latino)+
           p_black*log(1/p_black)+p_asian*log(1/p_asian)+
           p_indig*log(1/p_indig)+p_other*log(1/p_other))

theil_h <- 1-sum((alabama_tracts$total * alabama_tracts$entropy)/
  (alabama_state$total * alabama_state$entropy))


# Generalize the code -----------------------------------------------------

selected_tracts <- subset(tracts, statename=="Montana")

# calculate entropy for each tract
selected_tracts <- selected_tracts %>%
  mutate(total=white+latino+black+asian+indigenous+other,
         p_white=white/total, p_latino=latino/total, p_black=black/total,
         p_asian=asian/total, p_indig=indigenous/total, p_other=other/total)
props <- as.matrix(selected_tracts[,c("p_white","p_black","p_latino",
                                     "p_asian","p_indig","p_other")])
selected_tracts <- selected_tracts %>%
  mutate(entropy=apply(props*log(1/props), 1, sum, na.rm=TRUE))

# aggregate Alabama
selected_state <- selected_tracts %>%
  select(statename, white, black, latino, asian, indigenous, other) %>%
  group_by(statename) %>%
  summarize_all(sum) %>%
  mutate(total=white+latino+black+asian+indigenous+other,
         p_white=white/total, p_latino=latino/total, p_black=black/total,
         p_asian=asian/total, p_indig=indigenous/total, p_other=other/total,
         entropy=p_white*log(1/p_white)+p_latino*log(1/p_latino)+
           p_black*log(1/p_black)+p_asian*log(1/p_asian)+
           p_indig*log(1/p_indig)+p_other*log(1/p_other))

theil_h <- 1-sum((selected_tracts$total * selected_tracts$entropy)/
                   (selected_state$total * selected_state$entropy))

# Create a function -------------------------------------------------------

calculate_theilh <- function(selected_tracts) {
  # calculate entropy for each tract
  selected_tracts <- selected_tracts %>%
    mutate(total=white+latino+black+asian+indigenous+other,
           p_white=white/total, p_latino=latino/total, p_black=black/total,
           p_asian=asian/total, p_indig=indigenous/total, p_other=other/total)
  props <- as.matrix(selected_tracts[,c("p_white","p_black","p_latino",
                                        "p_asian","p_indig","p_other")])
  selected_tracts <- selected_tracts %>%
    mutate(entropy=apply(props*log(1/props), 1, sum, na.rm=TRUE))
  
  # aggregate state
  selected_state <- selected_tracts %>%
    select(statename, white, black, latino, asian, indigenous, other) %>%
    group_by(statename) %>%
    summarize_all(sum) %>%
    mutate(total=white+latino+black+asian+indigenous+other,
           p_white=white/total, p_latino=latino/total, p_black=black/total,
           p_asian=asian/total, p_indig=indigenous/total, p_other=other/total,
           entropy=p_white*log(1/p_white)+p_latino*log(1/p_latino)+
             p_black*log(1/p_black)+p_asian*log(1/p_asian)+
             p_indig*log(1/p_indig)+p_other*log(1/p_other))
  
  #calculate theil's H
  theil_h <- 1-sum((selected_tracts$total * selected_tracts$entropy)/
                     (selected_state$total * selected_state$entropy))

  return(theil_h)
} 

# try it out!
calculate_theilh(subset(tracts, statename=="Alabama"))
calculate_theilh(subset(tracts, statename=="Oregon"))
calculate_theilh(subset(tracts, statename=="Washington"))
calculate_theilh(subset(tracts, statename=="California"))
calculate_theilh(subset(tracts, statename=="Maryland"))
calculate_theilh(subset(tracts, statename=="Louisiana"))


# Iterate by for loop -----------------------------------------------------

states <- unique(tracts$statename)

theil_h <- NULL
for(state in states) {
  theil_h <- c(theil_h, calculate_theilh(subset(tracts, statename==state)))
}

theil_h <- tibble(statename=states, theil_h)


# The lapply approach -----------------------------------------------------

#my_list <- list(c(2,2),c(3,7),c(4,24))

#lapply(my_list, sum)

#split tracts into a list by statename
tracts_list <- split(tracts, tracts$statename)

#use sapply to apply calculate_theilh on each object in the list
theil_h <- sapply(tracts_list, calculate_theilh)

theil_h <- enframe(theil_h, "statename", "theil_h")
