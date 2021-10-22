#' Create a 2-d circular Boolean mask
#'
#' @param center Cartesian center of the blob specified as c(x, y).
#' @param r Radius of the blob.
#' @param pts Dataframe of Cartesian point coordinates to draw from.
#' @return Boolean mask when applied forms a circle from a point cloud.
#' @export
make_circle <- function(center, r, pts) {
  # Calculate the points that fall in a circle
  circle_mask <- apply(pts, 1,
    function(pts, center, r) (center[1] - pts[1])^2 + (center[2] - pts[2])^2 < r^2,
    center = center, r = r
  )
  return(circle_mask)
}


#' Extract a circular cluster from a square point field
#'
#' @param center Cartesian center of the blob specified as c(x, y).
#' @param r Radius of the blob.
#' @param n_pts Number of points in the cluster.
#' @return Vector of points in the shape of a circle with radius r and center (x,y).
#' @export
make_cluster <- function(center, r, n_pts) {
  x <- center[1]
  y <- center[2]

  # A square point space
  x <- runif(n = n_pts, min = x - r, max = x + r)
  y <- runif(n = n_pts, min = y - r, max = y + r)
  coords = data.frame(x=x, y=y)

  # Carve a circle from it
  mask <- make_circle(center, r, coords)
  out <- data.frame(x = coords[, 1][mask], y = coords[, 2][mask])
  return(out)
}

#' Make circular clusters
#'
#' @param n_clust An integer number of clusters to generate.
#' @param centers If "random" then centers are randomly generated from the c_range sequence. Otherwise, a list of cartesian coordinates for cluster centers should be provided.
#' @param c_range Square Cartesian space from which centers can be drawn. Expressed as a vector of two integers.
#' @param radii A vector of two integers, the range to choose the radius of each cluster from.
#' @param density The relative number of points per cluster. A function of the cluster radius and beta distribution.
#' @param categorical A fractional value if provided. Determines how useful a categorical variable should be with 1 being the most useful.
#' @param seed Random seed to use to make the results reproducible.
#' @return Dataframe, a set of labeled 2-d clusters.
#' @importFrom magrittr "%>%"
#' @export
make_clusters <- function(n_clust, centers = "random", c_range, radii = c(1, 5), density, categorical = FALSE, seed = NULL) {
  # Make random results reproducible
  set.seed(seed)

  # Generate random x and y for cluster center
  if (!is.list(centers)) {
    centers <- lapply(1:n_clust, function(x) runif(2, -c_range, c_range))
  }

  # Set scale of cluster
  radii <- runif(n_clust, radii[1], radii[2])

  # Set cluster densities as a function of cluster size
  ## Beta distribution varies the density randomly to be extremely dense or not dense (U shape)
  densities <- radii * density * (rbeta(n_clust, shape1 = 0.5, shape2 = 0.5) + 0.1)

  clusters <- mapply(make_cluster, centers, radii, densities, SIMPLIFY = FALSE) %>% dplyr::bind_rows(.id = "y_true")

  # Create a correlated categorical variable if appropriate
  if (categorical) {
    # The higher prob is the more correlated the categorical feature will be
    clusters$cat_feature <- as.integer(clusters$y_true) * rbinom(nrow(n_clusters), size = 1, prob = categorical)

    # Add noise to the cluster categorical feature based on the amount of 0s in the categorical feature
    clusters$cat_feature[cluters$cat_feature == 0] <- sample(1:n_clust, sum(clusters$cat_feature == 0), replace = TRUE)

    # Convert the categorical feature to factor
    clusters$cat_feature <- factor(clusters$cat_feature)
  }
  return(clusters)
}
