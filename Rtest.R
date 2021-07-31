##para actualizar el repo con  cambios q se hayan hecho en github, vamos a la carpeta en la TERMINAL
## con cd avancamos y cd.. volvemos (~ alejandronorton$ cd Test.\ Repo/), podemos por $ git status
## $ git pull origin master  Con esto actualizamos la carpeta local

library(dplyr)
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

nyc_trees <- 
  fromJSON("https://data.cityofnewyork.us/resource/nwxe-4ae8.json") %>%
  as_tibble()
nyc_trees

nyc_trees %>% 
  select(longitude, latitude, stump_diam, spc_common, spc_latin, tree_id) %>% 
  mutate_at(vars(longitude:stump_diam), as.numeric) %>% 
  ggplot(aes(x=longitude, y=latitude, size=stump_diam)) + 
  geom_point(alpha=0.5) +
  scale_size_continuous(name = "Stump diameter") +
  labs(
    x = "Longitude", y = "Latitude",
    title = "Sample of New York City trees",
    caption = "Source: NYC Open Data"
  )

## Definimos lo que vamos a buscar y en la proxima nos conectamos
endpoint = "series/observations"
params = list(
  api_key= "2d429190e1494b234ca323be8605ae9f", ## Change to your own key
  file_type="json", 
  series_id="GNPCA"
)

fred <- 
  httr::GET(
    url = "https://api.stlouisfed.org/", ## Base URL
    path = paste0("fred/", endpoint), ## The API endpoint
    query = params ## Our parameter list
  )

## extraemos el resultado
fred %>% 
  httr::content("text") %>%
  jsonlite::fromJSON() %>% ##listviewer::jsonedit() function, which allows for interactive inspection of list objects
  listviewer::jsonedit(mode = "view")

## after we check in the interactive list we know we want the OBSERVATIONS, so we rerun with that in mind
fred <-
  fred %>% 
  httr::content("text") %>%
  jsonlite::fromJSON() %>%
  purrr::pluck("observations") %>% ## Extract the "$observations" list element
  # .$observations %>% ## I could also have used this
  # magrittr::extract("observations") %>% ## Or this
  as_tibble() ## Just for nice formatting
fred

#JSON automatically converts everything to characters, so we change that now
fred <-
  fred %>%
  mutate_at(vars(realtime_start:date), ymd) %>%
  mutate(value = as.numeric(value)) 

fred %>%
  ggplot(aes(date, value)) +
  geom_line() +
  scale_y_continuous(labels = scales::comma) +
  labs(
    x="Date", y="2012 USD (Billions)",
    title="US Real Gross National Product", caption="Source: FRED"
  )

if (!require("pacman")) install.packages("pacman")
pacman::p_load(sf, tidyverse, hrbrthemes, lwgeom, rnaturalearth, maps, mapdata, spData, tigris, tidycensus, leaflet, tmap, tmaptools)
theme_set(hrbrthemes::theme_ipsum())

nc %>%
  filter(NAME %in% c("Camden", "Durham", "Northampton")) %>%
  mutate(AREA_1000 = AREA*1000) %>%
  select(NAME, contains("AREA"), everything())

nc %>% 
  select(county = NAME, BIR74, BIR79, -geometry) %>% 
  gather(year, births, BIR74, BIR79) %>% 
  mutate(year = gsub("BIR", "19", year)) %>%
  ggplot() +
  geom_sf(aes(fill = births), alpha=0.8, col="white") +
  scale_fill_viridis_c(name = "Births", labels = scales::comma) +
  facet_wrap(~year, ncol = 1) +
  labs(title = "Births by North Carolina county") 

nc %>% 
  st_union() %>% 
  ggplot() +
  geom_sf(fill=NA, col="black") +
  labs(title = "Outline of North Carolina") 
nc

library(tidycensus)