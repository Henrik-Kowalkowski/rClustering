#' Create a 2-d circular Boolean mask
#'
#' @param center Cartesian center of the blob specified as c(x, y).
#' @param n_clust An integer number of clusters to fit.
#' @param pts Dataframe of Cartesian point coordinates to draw from.
#' @return Boolean mask when applied forms a circle from a point cloud.
#' @importFrom magrittr "%>%"
#' @export
get_mean_clusters <- function(data, n_clust, iter, n_start, clust_order, seed=NULL){
  set.seed(seed)
  fit_data <- data %>% select(x, y) %>% mutate_all(~scale(.) %>% as.vector())

  start <- Sys.time()
}
