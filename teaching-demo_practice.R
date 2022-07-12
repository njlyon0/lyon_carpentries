## ------------------------------------------ ##
            # Teaching Demo Practice
## ------------------------------------------ ##
## Written by Nick J Lyon

# Introduction to R ----------------------------
# datacarpentry.org/R-ecology-lesson/01-intro-to-r.html
rm(list = ls())

# At its most fundamental, R/RStudio can be used as a calculator
5 + 7
51 / 17

# R can also define "objects" using the arrow `<-`
weight_kg <- 55
weight_kg
## R's "objects" are known as "variables" in other programming languages
## In R, a "variable" is typically a column in a data table

# Objects can be used in lieu of what they contain
weight_lb <- weight_kg * 2.2

# R does not print its output by default but surrounding something with parentheses will make it print as it works
(test <- 2 * 40)
test

# Functions in R are "canned" scripts that allow you to avoid needing to reinvent the wheel for every arithmetic operation
## You can take the square root of a number using the `sqrt` function
sqrt(100)

# Functions can contain multiple "arguments" that allow you to modify multiple parameters of the function
## For instance, the `round` function lets you round *something* (first argument) to a certain number of digits (second argument)
round(x = 3.14159, digits = 0)
round(x = 3.14159, digits = 2)

# If you don't know what arguments are in a function, you can use `?` to access the help file
?round

# If you know the order of the arguments you don't need to specify them
round(3.14159, 4)
## This is somewhat opaque though and makes it difficult for those less familiar to follow what a given script does

# If you *do* name the arguments you can modify their order
round(digits = 3, x = 3.14159)

# R allows you to separately put several things in the same object as a "vector"
(weight_kg <- c(10, 12, 14, 18))

# Vectors can also contain "characters" (i.e., text)
(animals <- c("bat", "mouse", "kangaroo"))

# You can perform some operation to each element of a vector
weight_kg * 2

# Many functions accept vectors and can tell you something about them
## `length` tells you how many things are in a given vector
length(weight_kg)

# `class` can tell you what type of object you're dealing with
class(weight_kg)
class(animals)

# `str` tells you about the structure of an object
str(animals)
str(weight_g)

# You can also use the `c` function to add to a vector
## `c` is short for "concatenate"
(animals_v2 <- c(animals, "walrus"))

# You can subset a vector using bracket and the numbers for which part of the vector you want
## Here we can ask for the second thing in the "animals_v2" vector
animals_v2[2]

# You can also ask for several things (in any order) using the `c` function
animals_v2[c(4, 2)]

# You can even ask for the same thing several times
animals_v2[c(1, 1, 1, 1)]

# You can also use "conditionals" to determine whether a given statement is true or false for an element of a vector
weight_kg
weight_kg > 13

# You can combine this conditional with the brackets to subset a vector
(weight_subset <- weight_kg[weight_kg > 13])

# "Either/or" and "and" conditionals can also be used
weight_kg < 12 | weight_kg > 13 ## `|` is "OR"
weight_kg > 12 & weight_kg > 13 ## `&` is "AND"

# If you ask for condition that nothing in the vector meets, you'll get an empty object
(weight_subset_v2 <- weight_kg[weight_kg > 30])

# Starting with Data ---------------------------
# datacarpentry.org/R-ecology-lesson/02-starting-with-data.html
rm(list = ls())

# Create a folder to save the data to
dir.create("data", showWarnings = FALSE)

# Download some test data to practice manipulating it
# download.file(url = "https://ndownloader.figshare.com/files/2292169",
#               destfile = file.path("data", "portal_data_joined.csv"))

# Load tidyverse library
library(tidyverse)

# Read in the data
surveys <- read_csv(file.path("data", "portal_data_joined.csv"))

# Let's take a look at the first few lines of code with `head`
head(surveys)

# You can also view the whole data table with `view`
view(surveys)

# Checking the structure of the data with `str` can be a good way of getting a feel for how R "sees" your data
str(surveys)

# Similarly to vectors we can subset a data frame using brackets

# If rows are desired they should be placed to the left of a comma
surveys[1,] ## first row

# If columns are desired, they should be placed to the right of a comma
surveys[,1] ## first column

# A number without a comma is assumed to be a column
surveys[1]

# You can grab a specific cell by specifying its row/column address
surveys[4, 5] # fourth row, fifth column

# Can also use the `c` function to select several rows/columns
surveys[c(1:3), c(1:3)] # first through third rows and columns

# Can exclude columns/rows with a "-" minus sign
surveys[,-1]

# You can grab a column by its name if you know it
surveys["plot_id"]

# Factors are vectors that have distinct groups (called "levels")
surveys$sex <- factor(surveys$sex)
summary(surveys$sex)

# R defaults to sorting factors alphabetically
sex <- factor(c("male", "female", "female", "male"))
levels(sex)
nlevels(sex)

# The 'actual' order is as we entered it but the levels are different
sex

# We can modify the level order manually if desired
sex <- factor(sex, levels = c("male", "female"))
sex

# You can force a factor back into a simpler character if desired
as.character(sex)

# Formatting dates with `lubridate`
library(lubridate)

# `lubridate` has a host of functions for different date formats
my_date <- ymd("2015-01-01")
str(my_date)

# Manipulating Data ----------------------------
# datacarpentry.org/R-ecology-lesson/03-dplyr.html
rm(list = ls())

# Data downloading steps
# dir.create("data", showWarnings = FALSE)
# download.file(url = "https://ndownloader.figshare.com/files/2292169",
#               destfile = file.path("data", "portal_data_joined.csv"))
surveys <- read_csv(file.path("data", "portal_data_joined.csv"))

# Another way of manipulating data is with the `tidyverse` packages
library(tidyverse)

# The `dplyr` package in particular is very useful for managing data

# You can select specific columns by their names with `select`
select(surveys, plot_id, species_id, weight)

# You can also use select to exclude columns with the "-" sign
select(surveys, -record_id, -species_id)

# You can subset based on conditions using `filter`
filter(surveys, year == 1995)

# In the `magrittr` package you can use the "pipe" function (`%>%`) to chain together multiple operations
## Step-wise change
surveys2 <- filter(surveys, weight < 5)
surveys_sml <- select(surveys2, species_id, sex, weight)

# With the pipe
surveys %>%
  filter(weight < 5) %>%
  select(species_id, sex, weight)

# `mutate` allows for creating new columns
surveys %>%
  filter(!is.na(weight)) %>%
  mutate(weight_kg = weight / 1000,
         weight_lb = weight_kg * 2.2)

# Groupwise operations can use `group_by` in conjunction with `summarise`
surveys %>%
  filter(!is.na(sex)) %>%
  group_by(sex, species_id) %>%
  summarize(mean_weight = mean(weight, na.rm = TRUE)) %>%
  tail()

# You can also reshape data from long format (more rows than columns) to wide format (more columns than row) and vice versa

# From long to wide format uses `pivot_wider` from the `tidyr` package
surveys_wide <- surveys %>%
  filter(!is.na(weight)) %>%
  group_by(plot_id, genus) %>%
  summarize(mean_weight = mean(weight)) %>%
  pivot_wider(names_from = genus, values_from = mean_weight)
surveys_wide

# Can pivot back to long format with `pivot_longer`
surveys_long <- surveys_wide %>%
  pivot_longer(names_to = "genus",
               values_to = "mean_weight",
               cols = -plot_id)
surveys_long

# Visualizing Data -----------------------------
# datacarpentry.org/R-ecology-lesson/04-visualization-ggplot2.html
rm(list = ls())

# Data downloading steps
# dir.create("data", showWarnings = FALSE)
# download.file(url = "https://ndownloader.figshare.com/files/2292169",
#               destfile = file.path("data", "portal_data_joined.csv"))
surveys <- read_csv(file.path("data", "portal_data_joined.csv"))

# Load tidyverse packages
library(tidyverse)

# `ggplot2` is the `tidyverse` package answer to all things data visualization
# It accepts a `data` argument and a `mapping` set of arguments (within the `aes` aesthetics function)
ggplot(data = surveys, mapping = aes(x = weight, y = hindfoot_length))

# When you ran the above you can see a plot show up in your RStudio but it doesn't actually show the data! What gives?

# `ggplot2` allows you to specify plot type by typing in different `geom_...` functions and combining them with that first `ggplot` function call with plus signs ("+")
ggplot(data = surveys, mapping = aes(x = weight, y = hindfoot_length)) +
  geom_point()

# This allows for saving part of your plot to an object and then adding things *to that object*
surveys_plot <- ggplot(data = surveys,
                       mapping = aes(x = weight, y = hindfoot_length))

surveys_plot +
  geom_point()

# Note that the plus sign must be on the same line as the first plotting line (without it R won't know that it needs to run the next line too)

# Each `geom...` can be modified within itself if desired
surveys_plot + 
  geom_point(alpha = 0.1, color = "blue")

# You can also modify aesthetics based on a grouping column!
surveys_plot + 
  geom_point(alpha = 0.1, aes(color = species_id))
## Note that you needed a new `aes` call to specify the grouping column

# You can make boxplots in `ggplot` just as quickly
ggplot(data = surveys,
       mapping = aes(x = species_id, y = weight)) +
  geom_boxplot()

# You can even add multiple different geoms to the same plot!
ggplot(data = surveys,
       mapping = aes(x = species_id, y = weight)) +
  geom_jitter(alpha = 0.1, color = "tomato", width = 0.25) +
  geom_boxplot(alpha = 0)
## Note that order matters! In the above plot, the boxplots are only on top of the scattered orange points because the boxplot geometry was added *after* the jittered points geometry
ggplot(data = surveys,
       mapping = aes(x = species_id, y = weight)) +
  geom_boxplot(alpha = 0) +
  geom_jitter(alpha = 0.1, color = "tomato", width = 0.25)
## See?

# R and SQL ------------------------------------
# datacarpentry.org/R-ecology-lesson/05-r-and-databases.html
rm(list = ls())

# We need different libraries to deal with SQL within R
librarian::shelf(dbplyr, RSQLite)

# Data downloading steps
# dir.create("data", showWarnings = FALSE)
# download.file(url = "https://ndownloader.figshare.com/files/2292171",
#               destfile = file.path("data", "portal_mammals.sqlite"),
#               mode = "wb")
mammals <- DBI::dbConnect(drv = RSQLite::SQLite(),
                          file.path("data", "portal_mammals.sqlite"))

# Let's take a closer look at the database we just connected to
src_dbi(mammals)
## This database includes the tables ("tbls") listed at the bottom

# The `dbplyr` package wants SQL syntax but can query from these databases
tbl(mammals, sql("SELECT year, species_id, plot_id FROM surveys"))

# Fortunately, you can begin with a database query and switch to R if that is more comfortable for you
surveys <- tbl(mammals, "surveys")
surveys %>%
  select(year, species_id, plot_id)


# End ----
