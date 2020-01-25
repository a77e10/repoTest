# my first repoTest
prueba repo

Hello world!
library(tidyverse)
library(nycflights13)

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
asdfadfa
