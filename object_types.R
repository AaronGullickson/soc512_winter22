# Object Types

# Atomic types --------

# numeric

x <- 1

# character

y <- "Bob"

# logical - boolean (TRUE/FALSE)

z1 <- TRUE
z2 <- FALSE

# re-casting

as.character(x)
as.character(z1)
as.numeric(z1)
as.numeric(z2)
as.numeric(y)

as.numeric("5")
as.logical("TRUE")

# Vector -------

age <- c(23,18,64,52,46)
gender <- c("M","F","X","M","F")
ate_breakfast <- c(TRUE,TRUE,FALSE,TRUE,FALSE)

mean(age)
mean(gender)
mean(ate_breakfast)

# indexing
age[3]
gender[4]
ate_breakfast[2]

# get 3rd and 5th person
age[c(3,5)]

# 1st through 3rd
age[c(1,2,3)]
age[1:3]

# the age of everyone who ate breakfast
age[ate_breakfast]

# Matrices -----

a <- cbind(c(3,5,7), c(10,9,0), c(5,1,2))

b <- cbind(c(3,5,7), c("cat","fish","dog"), c(5,1,2))

# first row, second column
a[1,2]

a[2:3,1]

# entire third column
a[,3]

# Factors -----

gender_fctr <- factor(gender)

# specify levels
gender_fctr <- factor(gender, levels=c("X","F","M"))

# specify labels
gender_fctr <- factor(gender, levels=c("X","F","M"),
                      labels=c("Non-binary","Female","Male"))

levels(gender_fctr)

# Boolean statements ----

gender=="M"
gender_fctr=="Male"
gender!="M"
age > 45
age < 20
age >= 25
age <= 18

# AND/OR statements

# all the men who are 45 and older
gender=="M" & age>=45

# all the cases that are men Or 45 and older
gender=="M" | age>=45

gender=="M" & age>=45 | ate_breakfast

(gender=="M" & age>=45) | ate_breakfast
gender=="M" & (age>=45 | ate_breakfast)

# who did not eat breakfast
!ate_breakfast

# Missing Values -----

age[4] <- NA

mean(age)
mean(age, na.rm = TRUE)

# checking for missing values
is.na(age)
!is.na(age)

# Lists -------

my_list <- list(age, gender, ate_breakfast)

# indexing list

# get the first item in the list
my_list[[1]]
my_list[[2]]
my_list[[1]][3]

# named lists

my_list <- list(age=age, gender=gender_fctr, breakfast=ate_breakfast, bob=TRUE)

my_list$gender

# Data.frame -----

my_df <- data.frame(age=age, gender=gender_fctr, breakfast=ate_breakfast)

# reference variable by name or index
my_df$age
my_df[,1]
my_df[,"age"]

my_df[2,3]

# summary command also knows what to do with it
summary(my_df)

# subset my dataset to just those under 30
subset(my_df, age<30)

# subset my dataset by variables
subset(my_df, select = c("age", "gender"))


# you can turn into a tibble
library(tidyverse)

my_tibble <- as_tibble(my_df)
