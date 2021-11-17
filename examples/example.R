devtools::load_all()
library(dplyr)
library(tidyselect)
library(tidyr)
library(stringr)
library(ggplot2)
library(gridExtra)


# Visualize clusters

clusts <- make_clusters(4, c_range = c(-20, 20), density = 500, categorical = F, seed = 1)

clust_positions <- clusts %>%
  group_by(y_true) %>%
  summarize_all(list(min = min, max = max, mean = mean)) %>%
  select(sort(peek_vars()))

clust_plot_data <- clust_positions %>%
  pivot_longer(cols = !y_true) %>%
  mutate(coord = if_else(str_detect(name, "^y_"), "y", "x")) %>%
  mutate(name = str_sub(name, start = 3)) %>%
  pivot_wider(names_from = coord, values_from = value) %>%
  mutate(center = factor(name == "mean"))

shapes <- c(16, 3)
names(shapes) <- c(F, T)
sizes <- c(3, 10)
names(sizes) <- c(F, T)


p1 <- clust_plot_data %>% ggplot(aes(x = x, y = y, col = y_true, shape = center, size = center)) +
  geom_point() +
  coord_cartesian(xlim = c(-20, 20), ylim = c(-20, 20)) +
  scale_shape_manual(values = shapes) +
  scale_size_manual(values = sizes) +
  theme(legend.position = "none")

p2 <- clusts %>% ggplot(aes(x = x, y = y, col = y_true)) +
  geom_point() +
  coord_cartesian(xlim = c(-20, 20), ylim = c(-20, 20))

grid.arrange(p1, p2, ncol = 2)

# Fit Kmeans
clusts <- make_clusters(4, c_range = c(-20, 20), density = 500, categorical = F, seed = 2)

vals <- setNames(data.frame(expand.grid(c(5, 10, 20), c(1, 10, 20))), c("n_iter", "n_start"))
vals$n_clust <- 4
vals$fit_name <- rep(c("A", "B", "C"), 3)

out <- mapply(get_mean_clusters,
  fit_name = vals$fit_name,
  n_clust = vals$n_clust,
  iter = vals$n_iter,
  n_start = vals$n_start,
  MoreArgs = list(data = clusts, seed = 1),
  SIMPLIFY = F
) %>%
  bind_rows() %>%
  mutate(y_pred = factor(y_pred))

ggplot(out, aes(x = x, y = y, col = y_pred)) +
  geom_point(size = 0.5) +
  facet_wrap(~title) +
  ggtitle("Kmeans", subtitle = "Varying Iterations and Starts")
