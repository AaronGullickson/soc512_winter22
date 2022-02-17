####################################
# example_script.R
# A basic example script
# Aaron Gullickson
####################################

# Load Libraries ----------------------------------------------------------

library(ggplot2)
library(ggthemes)
library(wesanderson)

# Data Loading ------------------------------------------------------------

load("example_data/politics.RData")

# Actual Analysis ---------------------------------------------------------

table(politics$president)

tab_polgender <- table(politics$gender, politics$president)

# The 1 makes sure that I look at presidential voting by gender rather than
# gender by presidential voting
prop.table(tab_polgender, 1)

ggplot(politics, aes(x=president, y=..prop.., fill=gender, group=gender))+
  geom_bar(position="dodge")+
  scale_y_continuous(labels=scales::percent)+
  labs(x="presidential choice", 
       y=NULL, 
       title="Presidential voting distributions by gender")+
  scale_fill_manual(values = wes_palette("GrandBudapest2"))+
  theme_fivethirtyeight()

