# Niko Ilomäki
# Feb 10, 2017
# Downloads the full dataset and parses it to given format.
# Data available at https://archive.ics.uci.edu/ml/datasets/STUDENT+ALCOHOL+CONSUMPTION

library(magrittr)
library(dplyr)
library(lazyeval)

# using magrittr operators:
# %>% passes result of left-hand side to right-hand side as first argument and returns RHS
# %T>% works similarly, but returns LHS
# %<>% combines <- and %>%

mat <- read.csv2("data/student-mat.csv") # 395 x 33
por <- read.csv2("data/student-por.csv") # 649 x 33

join_by <- c("school", "sex", "age", "address", "famsize", "Pstatus", "Medu", "Fedu", "Mjob", "Fjob", "reason", "nursery","internet")
join_suffix <- c(".mat", ".por")

alc <- inner_join(mat, por, by = join_by, suffix = join_suffix) # 382 x 53

# the dataset is not "tidy" in tidyverse sense so standard dplyr idioms don't appear to work here; this does
# uses standard evaluation verb mutate_ with interp from lazyeval package
# unnecessarily complicated, but done for the sake of exercise
for (col in colnames(mat)[!colnames(mat) %in% join_by]){
  if(!is.factor(mat[[col]])) {
    alc %<>% mutate_(.dots = setNames(list(
      interp(
        "as.integer(round((.mat + .por)/2))",
        .mat = as.name(paste0(col,".mat")),
        .por = as.name(paste0(col,".por"))
      )
    ), col))
  } else {
    alc %<>% mutate_(.dots = setNames(list(
      interp(
        ".mat",
        .mat = as.name(paste0(col,".mat"))
      )
    ), col))
  }
}

alc <-
  alc %>%
  select(-ends_with(".mat"),-ends_with(".por")) %>%
  mutate(alc_use = (Dalc + Walc) / 2, high_use = (alc_use > 2)) %T>%
  write.csv("data/alc.csv", row.names = FALSE)

glimpse(alc) # 382 x 35
