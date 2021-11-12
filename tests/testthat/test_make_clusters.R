output <- make_clusters(n_clust = 3,
                        centers = "random",
                        c_range = c(-10, 10),
                        radii = c(1, 5),
                        density = 500,
                        categorical = F,
                        seed = 1)

test_that("output looks good", {
  expect_s3_class(output, "data.frame")
  expect_equal(ncol(output), 3)
  expect_equal(length(unique(output$y_true)), 3)
})


