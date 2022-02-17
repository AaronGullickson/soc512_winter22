# Making Pretty Pictures
# Soc 512, Winter 2022


# Load data and libraries -------------------------------------------------

library(ggplot2)
library(scales)
library(ggthemes)

load("example_data/movies.RData")
load("example_data/nyc.RData")

# Plot relationship between maturity rating and runtime -------------------

ggplot(movies, aes(x=Rating, y=Runtime))+
  geom_violin(fill="grey")+
  geom_jitter(alpha=0.5, aes(color=Genre))+
  scale_y_continuous(breaks = seq(from=60, to=240, by=30),
                     labels = paste(seq(from=60, to=240, by=30), 
                                    "minutes", sep=" "))+
  scale_color_viridis_d()+
  coord_flip()+
  labs(x=NULL, y="movie runtime", color="movie genre",
       title="Distribution of movie runtime by maturity rating",
       subtitle="This is a subtitle!",
       caption="Soc 512 Movies database, 2001-2013")+
  theme_bw()+
  theme(panel.grid.minor = element_blank(), legend.position = "right")

# Panelize relationship between maturity rating and runtime by genre ---

ggplot(movies, aes(x=Rating, y=Runtime))+
  geom_violin(fill="grey")+
  scale_y_continuous(breaks = seq(from=60, to=240, by=30))+
  coord_flip()+
  facet_wrap(~Genre)+
  labs(x=NULL, y="movie runtime (in minutes)",
       title="Distribution of movie runtime by maturity rating",
       subtitle="This is a subtitle!",
       caption="Soc 512 Movies database, 2001-2013")+
  theme_bw()+
  theme(panel.grid.minor = element_blank())


# Health area scatterplot -------------------------------------------------

ggplot(nyc, aes(x=poverty/100, y=amtcapita))+
  geom_point(alpha=0.7, aes(color=borough, size=popn))+
  scale_x_continuous(labels=percent)+
  geom_smooth(method="lm", color="black", se=FALSE)+
  scale_y_log10(labels=dollar)+
  scale_color_viridis_d()+
  theme_bw()+
  theme(legend.position="right")+
  labs(x="poverty rate",
       y="amount per capita",
       title="Non-profit funding to NYC health area by poverty rate",
       caption="Data from NYC, 2009-2010",
       color="Borough",
       size="Population")

ggplot(nyc, aes(x=poverty/100, y=amtcapita))+
  geom_point(alpha=0.7, aes(size=popn))+
  scale_x_continuous(labels=percent)+
  geom_smooth(method="lm", color="black", se=FALSE)+
  scale_y_log10(labels=dollar)+
  facet_wrap(~borough)+
  theme_bw()+
  theme(legend.position="right")+
  labs(x="poverty rate",
       y="amount per capita",
       title="Non-profit funding to NYC health area by poverty rate",
       caption="Data from NYC, 2009-2010",
       color="Borough",
       size="Population")
