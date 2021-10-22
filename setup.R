# Build package
usethis::create_package(path=here::here(), check_name=FALSE)

# Create site
usethis::use_readme_rmd()
usethis::use_news_md
usethis::use_vignette("r_clustering")
usethis::use_github_links()
usethis::use_pkgdown()

# Create testing framework
usethis::use_testthat()

# Create documentation
devtools::document()
devtools::build_readme()
pkgdown::build_site(devel = T)

# Run tests
devtools::test()
