cars %>% 
  ggplot() +
  aes(x = dist) +
  aes(y = speed) +
  geom_point() -> 
  # assign plot as object
  # and print
g; g 
