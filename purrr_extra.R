
---
  # From purrr cheatsheet
  
  
  > List column workflow

- Make a list column
- Work with list column
- Simplify the list column



```{r list_column_workflow, echo = F, eval = T}
# linear modeling function
mod_fun <- function(df) lm(Sepal.Length ~ ., data = df) 
# returns coefficients of the model
b_fun <- function(mod) coefficients(mod)[[1]]
iris %>% 
  group_by(Species) %>% 
  nest() %>% # Make a list column
  mutate(model = map(data, mod_fun)) %>%  
  mutate(beta_0 = map_dbl(model, b_fun)) -> 
  iris_mods
```



---
  
  `r chunk_reveal("list_column_workflow", widths = c(59,40))`


---
  
  # Looking inside a list-column
  
  ```{r}
iris_mods$model 
```

---
  
  # Looking at an element in a list-column
  
  
  ```{r}
iris_mods$data[[3]]
```


---
  # Greater detail and examples
  
  > MAKE A LIST COLUMN - You can create list columns with functions in the tibble and dplyr packages, as well as tidyr’s nest()

---
  
  > tibble::tribble(...)
Makes list column when needed


```{r}
tribble( ~max, ~seq, 
         3, 1:3,
         4, 1:4, 
         5, 1:5)
```
---
  
  > tibble::tibble(...)
Saves list input as list columns

```{r}
tibble(max = c(3, 4, 5), 
       seq = list(1:3, 1:4, 1:5))
```

---
  
  > tibble::enframe(x, name="name", value="value") Converts multi-level list to tibble with list cols


```{r}
enframe(list('3' = 1:3, '4' = 1:4, '5' = 1:5), 
        'max', 'seq')
```

---
  
  dplyr::mutate(.data, ...) Also transmute() Returns list col when result returns list.

```{r}
mtcars %>% 
  mutate(seq = map(cyl, seq))
```


---
  
  dplyr::summarise(.data, ...)
Returns list col when result is wrapped with list()

```{r}
mtcars %>% 
  group_by(cyl) %>% 
  summarise(q = list(quantile(mpg)))
```


---
  ## 2 WORK WITH LIST COLUMNS - Use the purrr functions map(), map2(), and pmap() to apply a function that returns a result element-wise to the cells of a list column. walk(), walk2(), and pwalk() work the same way, but return a side effect.
  
  ---
  
  # set up
  ```{r}
n_iris <- iris %>% 
  group_by(Species) %>% 
  nest()
mod_fun <- function(df) lm(Sepal.Length ~ ., data = df)
m_iris <- n_iris %>%
  mutate(model = map(data, mod_fun))
```


---
  
  
  <!-- purrr::map(.x, .f, ...) -->
  <!-- Apply .f element-wise to .x as .f(.x)  -->
  
  ```{r wwlc1, echo= F, eval = F}
n_iris %>% 
  mutate(n = map(data, dim))
```

r chunk_reveal("wwlc1", widths = c(59,40))`

---
  
  <!-- purrr::map2(.x, .y, .f, ...) -->
  <!-- Apply .f element-wise to .x and .y as .f(.x, .y)  -->
  
  ```{r wwlc2, echo= F, eval = F}
m_iris %>% 
  mutate(n = map2(data, model, list))
```

r chunk_reveal("wwlc2", widths = c(59,40))`


---
  
  
  <!-- purrr::pmap(.l, .f, ...) -->
  <!-- Apply .f element-wise to vectors saved in .l  -->
  
  ```{r wwlc3, echo= F, eval = F}
m_iris %>%
  mutate(n = pmap(list(data, model, data), list))
```  

<!-- r chunk_reveal("wwlc3", widths = c(59,40))` -->
  
  
  <!-- --- -->
  
  
  <!-- 3. SIMPLIFY THE LIST COLUMN (into a regular column) -->
  
  <!-- Use the purrr functions map_lgl(), map_int(), map_dbl(), map_chr(), as well as tidyr’s unnest() to reduce a list column into a regular column. -->
  
  <!-- --- -->
  
  <!-- purrr::map_lgl(.x, .f, ...) -->
  <!-- Apply .f element-wise to .x, return a logical vector  -->
  
  ```{r slc1, echo = F, eval = F}
n_iris %>% 
  transmute(n = map_lgl(data, is.matrix))
```

<!-- r chunk_reveal("slc1", widths = c(59,40))` -->
  
  
  ---
  
  <!-- purrr::map_int(.x, .f, ...) -->
  <!-- Apply .f element-wise to .x, return an integer vector  -->
  
  ```{r slc2, echo = F, eval = F}
n_iris %>% 
  transmute(n = map_int(data, nrow))
```

<!-- r chunk_reveal("slc2", widths = c(59,40))` -->
  
  
  ---
  
  <!-- purrr::map_dbl(.x, .f, ...) -->
  <!-- Apply .f element-wise to .x, return a double vector -->
  
  ```{r slc3, echo = F, eval = F}
n_iris %>% 
  transmute(n = map_dbl(data, nrow))
```

r chunk_reveal("slc3", widths = c(59,40))`


---
  
  
  
  <!-- purrr::map_chr(.x, .f, ...) -->
  <!-- Apply .f element-wise to .x, return a character vector  -->
  
  
  ```{r slc4, echo = F, eval = F}
n_iris %>% 
  transmute(n = map_chr(data, nrow))
```

r chunk_reveal("slc4", widths = c(59,40))`


---
  
  
  
  ```{r}
mtcars %>% 
  select(mpg, cyl) %>% 
  distinct() %>% 
  mutate(seq = map(cyl, seq)) %>% 
  unnest()
```

```{r}
mtcars %>% 
  group_by(cyl) %>% 
  summarise(quantiles = list(quantile(mpg))) %>% 
  unnest()
```





```{r}
iris %>%
  group_by(Species) %>%
  nest() %>% 
  mutate(dimensions = map(data, dim)) %>% 
  mutate(rows = dimensions[[1]][1]) %>% 
  mutate(columns = dimensions[[1]][2]) %>% 
  select(-data) %>% 
  unnest()
```

---
  # List Column
  
  ```{r list_column}
iris %>% 
  group_by(Species) %>% 
  nest() %>%
  mutate(model = map(data, mod_fun))  %>% 
  mutate(n = map2(data, model, list)) ->
  iris_more_mod

iris_more_mod$n

iris %>% 
  group_by(Species) %>% 
  nest() %>%
  mutate(model = map(data, mod_fun)) %>%
  mutate(n = pmap(list(data, model, data), list)) ->
  more_manipulations

more_manipulations$n


```









