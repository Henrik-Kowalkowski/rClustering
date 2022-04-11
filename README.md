
<!-- README.md is generated from README.Rmd. Please edit that file -->

# rClustering

The goal of rClustering is to demonstrate how to generate random
circular clusters and illustrate how to apply K-means and K-prototypes
clustering.

## Installation

`install_github("hkowalkowski/rClustering@v1.0")`

## Example

How to generate synthetic 2-d circular clusters:

``` r
library(rClustering)
clusts <- make_clusters(4, c_range = 20, density = 500, categorical = F, seed = 1)
```
