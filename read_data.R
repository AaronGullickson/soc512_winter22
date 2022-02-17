# Reading data


# Load libraries ----------------------------------------------------------

library(readr)
library(haven)
library(readxl)

# Read delimited files ----------------------------------------------------

# nice clean file
read_csv("data_examples/data.csv", col_names=TRUE)

# not so clean file
read_csv("data_examples/data_messy.csv", comment="*", skip=3,
         col_names=TRUE, na="na")

# tab-delimited file
read_delim("data_examples/data_tab.txt", delim = "\t")
read_delim("data_examples/data.csv", delim=",")

my_data <- read_csv("data_examples/data_messy.csv", 
                    na = "na", comment = "*", skip = 3)


# Read fixed-width files --------------------------------------------------

# toy example
read_fwf("data_examples/data_fw.txt",
         col_positions = fwf_positions(start = c(1, 6,16,21,27),
                                       end   = c(5,15,20,26,28),
                                       col_names=c("name","location",
                                                   "race","gender","yrsed")))

# real example
ipums <- read_fwf("data_examples/usa_00084.dat.gz",
                  col_positions = fwf_positions(start = c(1,32,55,74,84,85,88,94),
                                                end =   c(4,41,56,83,84,87,91,96),
                                                col_names=c("year","hhwt","statefip",
                                                            "perwt","sex","age","yrmarr",
                                                            "educd")),
                  progress=TRUE,
                  col_types = cols(.default = "i"))

# Binary files ------------------------------------------------------------

# read Stata DTA file using haven
read_dta("data_examples/data.dta")

# read Excel file using readxl
read_excel("data_examples/data.xlsx")
