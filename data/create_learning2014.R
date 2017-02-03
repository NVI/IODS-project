# Niko Ilomäki
# Feb 3, 2017
# Downloads the full dataset and parses it to given format.

library(magrittr)
library(dplyr)

# using magrittr operators:
# %>% passes result of left-hand side to right-hand side as first argument and returns RHS
# %T>% works similarly, but returns LHS

learning2014 <-
  read.delim("http://www.helsinki.fi/~kvehkala/JYTmooc/JYTOPKYS3-data.txt") %>%
  mutate(deep = (D03 + D06 + D07 + D11 + D14 + D15 + D19 + D22 + D23 + D27 + D30 + D31)/12,
         surf = (SU02 + SU05 + SU08 + SU10 + SU13 + SU16 + SU18 + SU21 + SU24 + SU26 + SU29 + SU32)/12,
         stra = (ST01 + ST04 + ST09 + ST12 + ST17 + ST20 + ST25 + ST28)/8,
         attitude = Attitude / 10) %>%
  select(gender, age = Age, attitude, deep, stra, surf, points = Points) %>%
  filter(points != 0) %T>%
  write.csv("data/learning2014.csv", row.names = FALSE)

# full dataset is 183 observations of 60 variables
# final dataset is 166 observations of 7 variables

# read the data from csv
# learning2014 <- read.csv("data/learning2014.csv")
# investigate the data
# str(learning2014)
