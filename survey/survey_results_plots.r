library(ggplot2)
library(reshape2)
library(RColorBrewer)
library(dplyr)
library(ggthemes)
library(stringr)

data<-read.csv("surveyResults.csv",header=TRUE)
tab<-data

mytitle<-"Barriers and liminations"
# For current users and those who have tried to learn how to use bioinformatics software,
# which of the following have you encountered:
mylevels<-c("Strongly agree", "Agreee", "Neutral", "Disagree",  "Strongly disagree")
#mylevels<-c("Strongly disagree", "Somewhat disagree", "Somewhat agree",  "Strongly agree")


numlevels<-length(tab[1,])-1
point1<-2
point2<-((numlevels)/2)+1
point3<-point2+1
point4<-numlevels+1
tab2<-tab
mymin<-(ceiling(max(rowSums(tab2[,point1:point2]))*4)/4)*-100
mymax<-(ceiling(max(rowSums(tab2[,point3:point4]))*4)/4)*100
point1;point2;point3;point4;mymin;mymax


numlevels<-length(tab[1,])-1
temp.rows<-length(tab2[,1])
pal<-brewer.pal((numlevels),"PuOr")
legend.pal<-pal

tab3<-melt(tab2,id="outcome")
tab3$col<-rep(pal,each=temp.rows)
tab3$value<-tab3$value*100
tab3$outcome<-factor(tab3$outcome, levels = tab2$outcome[order(-(tab2[,4]+tab2[,5]))])
tab3$outcome<-str_wrap(tab3$outcome, width = 40)
highs<-na.omit(tab3[(length(tab3[,1])/2)+1:length(tab3[,1]),])
lows<-na.omit(tab3[1:(length(tab3[,1])/2),])
lows <- lows[rev(rownames(lows)),]

ggplot() + geom_bar(data=highs, aes(x = outcome, y=value, fill=col), position="stack", stat="identity") +
  geom_bar(data=lows, aes(x = outcome, y=-value, fill=col), position="stack", stat="identity") +
  geom_hline(yintercept = 0, color =c("black")) +
  scale_fill_identity("Percent", labels = mylevels, breaks=legend.pal, guide="legend") + 
  theme_fivethirtyeight() + 
  coord_flip() +
  labs(title=mytitle, y="",x="") +
  theme(plot.title = element_text(size=14, hjust=0.5)) +
  theme(axis.text.y = element_text(hjust=0)) +
  theme(legend.position = "bottom") +
  scale_y_continuous(breaks=seq(mymin,mymax,25), limits=c(mymin,mymax))

