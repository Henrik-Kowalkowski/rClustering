#' Add together two numbers
#'
#' @param center Cartesian center of the blob specified as c(x, y).
#' @param r Radius of the blob.
#' @param pts Dataframe of cartesian point coordinates to draw from.
#' @return Vector of points in the shape of a circle with radius r and center (x,y).
#' @export
make_circle <- function(center, r, pts) {
  circle_mask <- apply(pts, 1,
    function(pts, center, r) (center[1] - pts[1])^2 + (center[2] - pts[2])^2 < r^2,
    center = center, r = r
  )
}


# x <- runif(n=100, min=1-4, max=1+4)
# y <- runif(n=100, min=1-4, max=1+4)
# coords <- data.frame(x=x, y=y)

# circle_mask <- make_circle(center=c(1,1), r=4, pts=coords)
