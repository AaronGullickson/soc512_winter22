library(haven)
library(tidyverse)
library(survival)
library(texreg)
library(survminer)

frag <- read_dta("fragmentation-with-DS2006.dta")

frag <- frag %>%
  filter(!is.na(duration) & !is.na(peacend))

df_rate <- frag %>%
  summarize(exposure=sum(duration), events=sum(peacend)) %>%
  mutate(rate=events/exposure)

df_rate <- frag %>% 
  group_by(fragmentation) %>% 
  summarize(exposure=sum(duration), events=sum(peacend)) %>%
  mutate(rate=events/exposure)

df_rate$rate[2]/df_rate$rate[1]

table(frag$fragmentation, frag$peacend)
58*15/(58*7)

tapply(frag$duration, frag$fragmentation, mean)

model_naive_logit <- glm(peacend~fragmentation, data=frag, family=binomial)

model_exp <- glm(peacend~fragmentation, offset=log(duration), data=frag,
                 family=poisson)
model_weibull <- survreg(Surv(duration, peacend)~fragmentation, data=frag, 
                         dist="weibull")
model_cox <- coxph(Surv(duration, peacend)~fragmentation, data=frag)

knitreg(list(model_naive_logit, model_exp, model_cox))

fit <- survfit(Surv(duration, peacend)~fragmentation, data=frag)
ggsurvplot(fit)
