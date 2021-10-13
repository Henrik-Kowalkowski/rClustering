library(here)
library(usethis)
library(devtools)

# Build directory
create_package(path=here(), check_name=FALSE)

# Create testing framework
use_testthat()

# Create documentation
document()

# Run tests
test()
