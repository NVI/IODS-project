# Niko Ilomäki
# Feb 17, 2017

# Load libraries
library(magrittr) # %<>% : <- + %>%
library(dplyr)

# Load datasets
hd <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/human_development.csv", stringsAsFactors = F)
gii <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/gender_inequality.csv", stringsAsFactors = F, na.strings = "..")

# View structure of datasets
str(hd) # 195 x 8
str(gii) # 195 x 10

# Summarize datasets
summary(hd)
summary(gii)

# Rename existing variables
hd %<>%
  rename(
    hdi_rank = HDI.Rank,
    country = Country,
    hdi = Human.Development.Index..HDI.,
    life_expectancy = Life.Expectancy.at.Birth,
    expected_education = Expected.Years.of.Education,
    observed_education = Mean.Years.of.Education,
    gni_per_capita = Gross.National.Income..GNI..per.Capita,
    gni_hdi_rank_difference = GNI.per.Capita.Rank.Minus.HDI.Rank
  )

gii %<>%
  rename(
    gii_rank = GII.Rank,
    country = Country,
    gii = Gender.Inequality.Index..GII.,
    maternal_mortality = Maternal.Mortality.Ratio,
    adolescent_birth = Adolescent.Birth.Rate,
    parliamentary_representation = Percent.Representation.in.Parliament,
    secondary_education_female = Population.with.Secondary.Education..Female.,
    secondary_education_male = Population.with.Secondary.Education..Male.,
    labour_force_female = Labour.Force.Participation.Rate..Female.,
    labour_force_male = Labour.Force.Participation.Rate..Male.
  )

# Add new variables
gii %<>%
  mutate(
    secondary_education_rate = secondary_education_female / secondary_education_male,
    labour_force_rate = labour_force_female / labour_force_male
  )

# Join datasets
human <- inner_join(hd, gii, by = "country")

# Save joined data in serialized R object format
human %>% saveRDS("data/human.Rds")

# Load data again
# human <- readRDS("data/human.Rds")
