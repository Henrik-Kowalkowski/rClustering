devtools::load_all()
library(dplyr)
library(tidyselect)
library(tidyr)
library(stringr)
library(ggplot2)
library(gridExtra)

clusts <- make_clusters(4, c_range = 20, density = 500, categorical = F, seed = 1)

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


p1 <- clust_plot_data %>% ggplot(aes(x = x, y = y, col = y_true, shape = center, size=center)) +
  geom_point() +
  coord_cartesian(xlim = c(-20, 20), ylim = c(-20, 20)) +
  scale_shape_manual(values = shapes) + scale_size_manual(values = sizes) +
  theme(legend.position = "none")

p2 <- clusts %>% ggplot(aes(x=x, y=y, col=y_true)) + geom_point() + coord_cartesian(xlim = c(-20, 20), ylim = c(-20, 20))

grid.arrange(p1, p2, ncol=2)
