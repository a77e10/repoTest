##use of PIPE %>%
mpg %>% 
  filter(manufacturer=="audi") %>% 
  group_by(model) %>% 
  summarise(hwy_mean = mean(hwy))

starwars %>% 
  filter( 
    species == "Human", 
    height >= 190
  )
##remove the NAs, ojo que lo saca y lo vemos, pero si vamos a la base sigue completa
starwars %>%
  filter(!is.na(height))

starwars %>% 
  select(name:eye_color) %>% 
  mutate_if(is.character, toupper) 
##Si es character lo pasa a Uppercase
%>% head(5) 
##elige las primeras 5 líneas solamente

starwars %>% 
  group_by(species, gender) %>% 
  summarise(mean_height = mean(height, na.rm = T))
# na.rm = T , no considera los na para los calculos

##webscrap
library(rvest)
m100 <- read_html("http://en.wikipedia.org/wiki/Men%27s_100_metres_world_record_progression") 
m100

pre_iaaf2 <-
  m100 %>%
  html_nodes("#mw-content-text > div > table:nth-child(14)") %>%
  html_table(fill=TRUE) 

pre_iaaf2 <- 
  pre_iaaf2 %>%
  bind_rows() %>%
  as_tibble()
pre_iaaf2

pre_iaaf2 <-
  pre_iaaf2 %>%
  clean_names()
pre_iaaf2

pre_iaaf2 <-
  pre_iaaf2 %>%
  mutate(athlete = ifelse(, athlete, lag(athlete)))


