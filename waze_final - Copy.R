library(data.table)
library(dplyr)
library(stringr)
library(ggplot2)
library(googleVis)
library(tidyverse)
library(plotly)
library(wesanderson)


waze= fread('C:\\Users\\Shani Fisher\\Documents\\Bootcamp\\Web Scraping proj\\data\\Waze_reviews3.csv')

waze$Stars=str_extract(waze$Stars, "[0-9]+")

waze$Stars=as.numeric(waze$Stars)
summary(waze)

waze  = waze %>% mutate(Years= as.Date(waze$Date,
                                       format = "%d-%b-%y"))
waze = waze %>% mutate(only_months=substring(waze$Years,6,7))
waze = waze %>% mutate(n_stars = as.numeric(Stars))








Cal <- gvisCalendar(waze, 
                    datevar="Years", 
                    numvar="Stars",
                    options=list(
                      title="Waze Ratings Per Day",
                      height=320,
                      calendar="{yearLabel: { fontName: 'Times-Roman',
                      fontSize: 32, color: '#1A8763', bold: true},
                      cellSize: 10,
                      cellColor: { stroke: 'red', strokeOpacity: 0.2 },
                      focusedCellColor: {stroke:'red'}}")
                    )
plot(Cal)


line.new = dcast(waze, Helpful ~ n_stars, value.var='only_months')
line = gvisLineChart(line.new, options=list(hAxes="[{logScale:true}]",
                                            width=550, height=500))

plot(line)



ggplot(waze, aes(x=Stars, fill=only_months))+geom_bar(position='dodge')

p <- ggplot(maps, aes(x=n_stars, color=only_months)) + 
  geom_histogram(aes(y=..density..), colour="black", fill="grey", bins=5, alpha=0.5)+
  geom_density()+
  labs(x="Number of Stars")

p

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
plot_ly(waze, x = ~only_months, y = ~n_stars, color = ~only_months, type = "box") %>% 
  layout(xaxis = x, yaxis = y)

