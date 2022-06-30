# Load needed libraries
install.packages("tidyverse")
library(tidyverse)

# Can use pre-loaded data called "iris"
## `head()` returns first 6 rows of all columns
head(iris)


?`%>%`

dplyr::select(.data = iris, Petal.Length)


iris %>%
  dplyr::select(Petal.Length)


iris %>%
  dplyr::select(Petal.Length) %>%
  head()




