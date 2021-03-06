g + 
  theme_minimal(base_size = 12) +
  aes(size = dist) +
  aes(color = dist) +
  scale_color_viridis_c() +
  geom_smooth() +
  theme(legend.position = 
          "none") +
  labs(x = "distance") +
  labs(y = "Speed") +
  labs(title = "Cool plot!") +
  theme(plot.title.position = 
          "plot")
