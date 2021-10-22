library(here)
library(usethis)
library(devtools)

# Build directory
create_package(path=here(), check_name=FALSE)

# Create testing framework
use_testthat()

# Create documentation
document()

# Create site
use_pkgdown()

# Run tests
test()
