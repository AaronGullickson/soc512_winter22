library(ggplot2)
load("example_data/earnings.RData")

pre_df <- data.frame(age=18:65)

model_linear <- lm(wages~age, data=earnings)
pre_df$wages_linear <- predict(model_linear, pre_df)

model_quad <- lm(wages~age+I(age^2), data=earnings)
pre_df$wages_quad <- predict(model_quad, pre_df)

model_log <- lm(log(wages)~log(age), data=earnings)
pre_df$wages_log <- exp(predict(model_log, pre_df))

earnings$spline <- ifelse(earnings$age<35, 0, earnings$age-35)
model_spline <- lm(wages~age+spline, data=earnings)
pre_df$spline <- ifelse(pre_df$age<35, 0, pre_df$age-35)
pre_df$wages_spline <- predict(model_spline, pre_df)

earnings$spline45 <- ifelse(earnings$age<45, 0, earnings$age-45)
model_spline45 <- lm(wages~age+spline45, data=earnings)
pre_df$spline45 <- ifelse(pre_df$age<45, 0, pre_df$age-45)
pre_df$wages_spline45 <- predict(model_spline45, pre_df)


ggplot(earnings, aes(x=age, y=wages))+
  geom_jitter(alpha=0.05)+
  geom_line(data=pre_df, aes(y=wages_linear), color="blue",
            size=1.5)+
  geom_line(data=pre_df, aes(y=wages_quad), color="red",
            size=1.5)+
  geom_line(data=pre_df, aes(y=wages_log), color="darkgreen",
            size=1.5)+
  geom_line(data=pre_df, aes(y=wages_spline), color="orange",
            size=1.5)+
  geom_line(data=pre_df, aes(y=wages_spline45), color="yellow",
            size=1.5)+
  theme_bw()
