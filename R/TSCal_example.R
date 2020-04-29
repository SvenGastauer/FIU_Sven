# we need some plotting libraries
# pals and scales could easily be dropped...this is just because I want certain colormaps...

library(ggplot2)
library(pals)
library(scales)

#load the ts.cal function
source('./R/TSCal.R')

results <- ts.cal(freq=seq(90,170,by=1),c=1480,plot="yes")

#raster of sound speed variation
results <- ts.cal(freq=seq(18,300,by=1),c=seq(1403,1550,by=10),plot="no")
ggplot(data=results,aes(x=F,y=c,fill=TS))+
  geom_raster()+
  xlab('Frequency [kHz]')+
  ylab('Sound speed [m/s]')+
  scale_x_continuous(expand=c(0,0))+
  scale_y_continuous(expand=c(0,0))+
  scale_fill_gradientn(colors=pals::parula(12),limit=c(-45,-37),oob=scales::squish)+
  theme_classic()+
  theme(text = element_text(size=16))


#line plots for different ambient sound speeds
results <- ts.cal(freq=seq(90,170,by=1),c=c(1450,1500,1550),plot="no")
tsize=16
ggplot(data=results,aes(x=F,y=TS,group=factor(c),col=factor(c)))+
  geom_line(lwd=1.2)+
  scale_color_grey(name="f [kHz]")+
  xlab("c [m/s]")+
  ylab("TS [dB]")+
  theme_classic()+
  theme(legend.position='top',
        text = element_text(size=tsize),axis.text = element_text(size=tsize))


#compare sea water with c 1480 to fresh water
cc=1403 #freshwater at 0 degrees

res <- ts.cal(freq=seq(38,120),c=c(cc,1480),plot="yes")
