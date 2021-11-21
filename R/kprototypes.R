#' Fit Kprototypes on globs
#'
#' @param data Dataframe of a 3-d space to fit on. Two continuous dimensions and one categorical dimension.
#' @param fit_name Name of kprototypes fit
#' @param n_clust An integer number of clusters to fit.
#' @param iter An integer number of max iterations for the kprototypes algorithm to converge to.
#' @param n_start An integer number of max iterations for the kprototypes algorithm to converge to
#' @param seed Random seed to use to make the results reproducible.
#' @return Dataframe of covariates, predictions, and title of fit.
#' @importFrom magrittr "%>%"
#' @importFrom clustMixType kproto
#' @export
get_proto_clusters <- function(data, fit_name, n_clust, iter, n_start, seed = NULL) {
  set.seed(seed)

  # Scale input vectors for kprototypes
  fit_data <- data %>%
    select(-y_true) %>%
    mutate_if(is.numeric, ~ scale(.) %>% as.vector())

  start <- Sys.time()
  # Fit kprototypes and extract cluster labels
  y_pred <- kproto(fit_data, n_clust, iter.max = iter, nstart = n_start, verbose=FALSE)$cluster
  t_time <- round(difftime(Sys.time(), start, units = "secs"), 3)
  km_data <- cbind(data, y_pred)

  # Create plot titles
  km_data$title <- glue::glue("{fit_name}, n_clust={n_clust}, n_iter={iter}, n_start={n_start}, time={t_time} secs")

  km_data
}
