## ------------------------------------------ ##
            # Teaching Demo Actual
## ------------------------------------------ ##
## Written by Nick J Lyon

# Housekeeping --------------------------------

# Load needed libraries
library(tidyverse)

# Create a folder to save test data
dir.create("data", showWarnings = FALSE)

# Download some test data to practice manipulating it
# download.file(url = "https://ndownloader.figshare.com/files/2292169",
#               destfile = file.path("data", "portal_data_joined.csv"))

# Read in the data
surveys <- read_csv(file.path("data", "portal_data_joined.csv"))

# Actual Live Coding ---------------------------

# Check structure
str(surveys)

# Look at first rows of data
head(surveys)

# First column of data
surveys[, 1]

# First row
surveys[1,]

# Specific cell
surveys[3, 10]

# Assign to a new object
surveys_v2 <- surveys[, 1:5]










# End ----
