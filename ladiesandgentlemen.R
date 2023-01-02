### ladies and gentlemen, the weeknd ###
setwd(dirname(rstudioapi::getSourceEditorContext()$path)) 

library(tidyverse)
library(magrittr)
library(lubridate)
library(rtweet)
library(showtext) 

# add font
font_add_google(name = "Roboto Mono", family = "Roboto Mono")
showtext_auto()

timeline <- get_timeline("@craigweekend", n = 3200)

# get rid of replies and retweets
timeline_clean <- filter(timeline, is.na(in_reply_to_status_id) & retweeted == 'FALSE')

timeline_clean$created_at <- as.Date(timeline_clean$created_at)
timeline_clean$week <- floor_date(timeline_clean$created_at, "week")
timeline_select <- filter(timeline_clean, created_at > '2021-01-01')

# plot

ggplot(data = timeline_select) +
  #geom_segment(aes(x = min(week), xend = min(week), y = 90000, yend = 130000), color = 'orangered', size = 1) +
  geom_line(aes(x = week, y = favorite_count)) +
  #geom_smooth(aes(x = week, y = favorite_count), method='loess', se=F, color = 'orangered') +
  geom_segment(aes(x = week, xend = week, y = 0, yend = favorite_count)) +
  scale_x_date(date_breaks = "months", date_labels = "%b-%y") +
  theme(plot.background = element_rect(fill = 'grey90', color = NA),
        panel.background = element_rect(fill='grey90', color = NA),
        axis.text.y = element_blank(),
        axis.ticks = element_blank(),
        axis.title = element_blank(),
        axis.text.x = element_text(family = 'Roboto Mono',vjust=-10, 
                                   size = 20, color='orangered')
        ) +
  coord_polar(clip='off') 

ggsave('theweekend_polar.png', width = 4, height = 4, dpi = 300)
