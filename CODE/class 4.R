

############Tidyverse######################################################

############################################################################
library(tidyverse)
#tidyverse commands
select()
filter()
arrange()
mutate()
summarise()
group_by()

data("ChickWeight")

ChickWeight %>%
  select(weight,Time,Diet)%>%
  filter(Diet==2)%>%
  head()


ChickWeight %>%
  select(.,weight,Time,Diet)%>%
  filter(.,Diet==2)%>%
  head() # same as above,, but a period specifies to use the dataset from first line


ChickWeight %>%
  select(weight:Diet)

ChickWeight %>%
  arrange(., -weight)%>%
  head(10)

ChickWeight %>%
  arrange(., -weight, -Time)%>%
  head(10)


cw1<-ChickWeight %>%
  mutate(Chick_name = as.character(Chick),
         weight=weight*0.0022,
         diet_time = paste(Diet, "_", Time))%>%
  head()

cw1
ChickWeight

summarized<-ChickWeight %>%
  summarise(count_chicks = n_distinct(Chick),
            avg_wt = mean(weight),
            last_time = last(Time))
summarized

ChickWeight %>%
  group_by(Diet)%>%
  summarise( count_chicks = n_distinct(Chick),
             average_wt = mean(weight))%>%
  arrange(average_wt)


ChickWeight%>%
ggplot( aes(x=Time, y=weight, color=Diet)) +
  geom_point(size=8)+ 
  theme_bw()


#######################################################################

yield <-  read.csv("Dat/agronomic_yields.csv")
library(tidyverse)


glimpse(yield)

nonasyield<-yield %>%
  filter(!is.na(yield))


sum(is.na(yield))

yield%>%
  summarise_all(., ~(sum(is.na(.))))

fun<- function (x,y){
  x^2 + y^2
}

fun(2,2)

nona<-yield%>%
  filter(., !is.na(yield$Yield_kg_ha) | !is.na(yield$Yield_bu_A)) %>%
  select(-Yield_kg_ha)

nona %>%
  arrange(desc(Yield_bu_A)) %>%
  head()

summ <-
  nona %>%
  summarise (aveyield = mean(Yield_bu_A),
             sdyield = sd(Yield_bu_A))

summ <-
  nona %>%
  group_by(description)%>%
  summarise (aveyield = mean(Yield_bu_A),
             sdyield = sd(Yield_bu_A),
             count= n()) %>%
  arrange(desc(aveyield))
