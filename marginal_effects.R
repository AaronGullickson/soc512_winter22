load("titanic.RData")
library(margins)
library(tidyverse)
library(ggplot2)


model <- glm(I(survival=="Survived")~fare+age+sex, data=titanic, 
             family=binomial)
lodds_base <- predict(model)
prob_base <- exp(lodds_base)/(1+exp(lodds_base))

fake_data <- titanic %>%
  select(fare, age, sex) %>%
  mutate(fare=fare+1)
lodds_fare <- predict(model, newdata = fake_data)
prob_fare <- exp(lodds_fare)/(1+exp(lodds_fare))
diff_prob_fare <- prob_fare-prob_base
ggplot(data.frame(diff=diff_prob_fare), aes(x=diff))+geom_histogram()
ame_fare <- mean(diff_prob_fare)

fake_data <- titanic %>%
  select(fare, age, sex) %>%
  mutate(age=age+1)
lodds_age <- predict(model, newdata = fake_data)
prob_age <- exp(lodds_age)/(1+exp(lodds_age))
diff_prob_age <- prob_age-prob_base
ggplot(data.frame(diff=diff_prob_age), aes(x=diff))+geom_histogram()
ame_age <- mean(diff_prob_age)

data_male <- titanic %>%
  select(fare, age, sex) %>%
  mutate(sex="Male")
lodds_men <- predict(model, newdata = data_male)
prob_men <- exp(lodds_men)/(1+exp(lodds_men))
data_female <- titanic %>%
  select(fare, age, sex) %>%
  mutate(sex="Female")
lodds_women <- predict(model, newdata = data_female)
prob_women <- exp(lodds_women)/(1+exp(lodds_women))
diff_prob_female <- prob_women-prob_men
ggplot(data.frame(diff=diff_prob_female), aes(x=diff))+geom_histogram()
ame_female <- mean(diff_prob_female)

summary(margins(model))

## Its the same!!!

model1 <- glm(I(survival=="Survived")~(sex=="Female"), data=titanic, 
              family=binomial)
model2 <- glm(I(survival=="Survived")~(sex=="Female")+
                (pclass=="Second")+(pclass=="Third"), data=titanic, 
              family=binomial)
model3 <- glm(I(survival=="Survived")~(sex=="Female")*
                ((pclass=="Second")+(pclass=="Third")), data=titanic, 
              family=binomial)
library(texreg)
knitreg(lapply(list(model1, model2, model3), margins))
