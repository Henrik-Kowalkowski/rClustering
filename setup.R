# Build package
usethis::create_package(path=here::here())
usethis::use_mit_license(copyright_holder = NULL)

# Imports and depends
usethis::use_package("clustMixType", type="imports")
usethis::use_package("magrittr", type="imports")
usethis::use_package("glue", type="imports")
usethis::use_package("cluster", type="imports")

# Create site
usethis::use_readme_rmd()
usethis::use_news_md()
usethis::use_vignette("rClustering")
usethis::use_github_links()
usethis::use_pkgdown()

# Create testing framework
usethis::use_testthat()

# Create documentation
devtools::document()
devtools::build_readme()
pkgdown::build_site()

# Run tests
devtools::test()
