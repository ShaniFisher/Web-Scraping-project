library(data.table)
library(dplyr)
library(stringr)
library(ggplot2)
library(googleVis)
library(tidyverse)
library(plotly)


maps= fread('C:\\Users\\Shani Fisher\\Documents\\Bootcamp\\Web Scraping proj\\data\\Google_maps_new.csv')

maps$Stars=str_extract(maps$Stars, "[0-9]+")

maps$Stars=as.numeric(maps$Stars)
summary(maps)

maps  = maps %>% mutate(Years= as.Date(maps$Date,
                                       format = "%d-%b-%y"))
maps = maps %>% mutate(only_months=substring(maps$Years,6,7))
maps = maps %>% mutate(n_stars = as.numeric(Stars))








Cal <- gvisCalendar(maps, 
                    datevar="Years", 
                    numvar="Stars",
                    options=list(
                      title="Google Ratings per day",
                      height=320,
                      calendar="{yearLabel: { fontName: 'Times-Roman',
                      fontSize: 32, color: '#1A8763', bold: true},
                      cellSize: 10,
                      cellColor: { stroke: 'red', strokeOpacity: 0.2 },
                      focusedCellColor: {stroke:'red'}}")
                    )
plot(Cal)


line.new = dcast(maps, Helpful ~ only_months, value.var='n_stars')
line = gvisLineChart(line.new, options=list(hAxes="[{logScale:true}]",
                                            width=550, height=500))

plot(line)

p <- ggplot(maps, aes(x=n_stars, color=n_stars)) + 
  #geom_histogram(aes(y=..density..), colour="black", fill="white")+
  geom_density()
p


ggplot(maps, aes(x=Stars, fill=only_months))+geom_bar(position='dodge') %>% 
  brewer.pal('Dark2')


f <- list(
  family = "Courier New, monospace",
  size = 18,
  color = "#7f7f7f"
)
x <- list(
  title = "Months of the Year",
  titlefont = f
)
y <- list(
  title = "Number of Stars",
  titlefont = f
)
plot_ly(maps, x = ~only_months, y = ~n_stars, color = ~only_months, type = "box") %>% 
  layout(xaxis = x, yaxis = y)
