rm(list = ls())
library(rstudioapi)
library(ggplot2)
library(cowplot)
currentPath <- getSourceEditorContext()$path
charLocations <- gregexpr('/',currentPath)[[1]]
currentPath <- substring(currentPath,1,charLocations[length(charLocations)]-1)
setwd(currentPath)

##==== Function ====##
theme_custom <- function(){
  myTheme <- theme(panel.background = element_blank(),
                   panel.grid = element_blank(),
                   legend.position = 'none',
                   plot.margin = margin(6,6,6,6),
                   plot.background = element_blank(),
                   axis.ticks = element_blank(),
                   axis.title.y = element_blank(),
                   axis.title.x = element_blank(),
                   axis.text.y = element_blank(),
                   axis.text.x = element_blank())
  return(myTheme)
}
CMYKtoRGB <- function(C,M,Y,K){
  Rc <- (1-C)*(1-K)
  Gc <- (1-M)*(1-K)
  Bc <- (1-Y)*(1-K)
  R <- as.character(as.hexmode((ceiling(Rc*255))))
  G <- as.character(as.hexmode((ceiling(Gc*255))))
  B <- as.character(as.hexmode((ceiling(Bc*255))))
  if(nchar(R) == 1){
    R <- paste0('0',R)
  }
  if(nchar(G) == 1){
    G <- paste0('0',G)
  }
  if(nchar(B) == 1){
    B <- paste0('0',B)
  }
  RGBColor <- paste0('#',R,G,B)
  return(RGBColor)
}
##==== Function ====##

dataMatrix_1 <- read.csv('Species_SR_Summary.csv')
dataMatrix_2 <- read.csv('Community_SR_Summary.csv')

##==== Species ====##
selectIDs_1 <- which(dataMatrix_1$SR == 2)
selectIDs_2 <- which((dataMatrix_1$SR == 3) | (dataMatrix_1$SR == 4))
selectIDs_3 <- which(dataMatrix_1$SR > 4)
tempSR <- c(2,3,5)
tempNum <- c(sum(dataMatrix_1$Num[selectIDs_3]),sum(dataMatrix_1$Num[selectIDs_2]),sum(dataMatrix_1$Num[selectIDs_1]))
drawMatrix <- data.frame(SR = tempSR,Num = tempNum)
drawMatrix$SR <- as.factor(drawMatrix$SR)
drawMatrix$Num <- drawMatrix$Num/sum(drawMatrix$Num)
fig_S5_1 <- ggplot()+
  geom_bar(data = drawMatrix,mapping = aes(x = '',y = Num,fill = SR),color = '#000000',size = 0.3,width = 1,stat = 'identity')+
  scale_fill_manual(values = c(CMYKtoRGB(0,0.38,0.96,0),CMYKtoRGB(0.82,0.20,0.93,0.24),CMYKtoRGB(0.84,0.67,0,0)))+
  coord_polar('y',start = 0)+
  theme_custom()
##==== Species ====##

##==== Community ====##
selectIDs_1 <- which(dataMatrix_2$SR == 2)
selectIDs_2 <- which((dataMatrix_2$SR == 3) | (dataMatrix_2$SR == 4))
selectIDs_3 <- which(dataMatrix_2$SR > 4)
tempSR <- c(2,3,5)
tempNum <- c(sum(dataMatrix_2$Num[selectIDs_3]),sum(dataMatrix_2$Num[selectIDs_2]),sum(dataMatrix_2$Num[selectIDs_1]))
drawMatrix <- data.frame(SR = tempSR,Num = tempNum)
drawMatrix$SR <- as.factor(drawMatrix$SR)
drawMatrix$Num <- drawMatrix$Num/sum(drawMatrix$Num)
fig_S5_2 <- ggplot()+
  geom_bar(data = drawMatrix,mapping = aes(x = '',y = Num,fill = SR),color = '#000000',size = 0.3,width = 1,stat = 'identity')+
  scale_fill_manual(values = c(CMYKtoRGB(0,0.38,0.96,0),CMYKtoRGB(0.82,0.20,0.93,0.24),CMYKtoRGB(0.84,0.67,0,0)))+
  coord_polar('y',start = 0)+
  theme_custom()
##==== Community ====##

##==== All ====##
dataMatrix_1 <- rbind(dataMatrix_1,dataMatrix_2)
uniqueSpeciesRichness <- unique(dataMatrix_1$SR)
dataMatrix_3 <- data.frame()
for(i in seq(1,length(uniqueSpeciesRichness))){
  tempSR <- uniqueSpeciesRichness[i]
  selectIDs <- which(dataMatrix_1$SR == tempSR)
  tempNum <- sum(dataMatrix_1$Num[selectIDs])
  dataMatrix_3 <- rbind(dataMatrix_3,data.frame(SR = tempSR,Num = tempNum))
}

selectIDs_1 <- which(dataMatrix_3$SR == 2)
selectIDs_2 <- which((dataMatrix_3$SR == 3) | (dataMatrix_3$SR == 4))
selectIDs_3 <- which(dataMatrix_3$SR > 4)
tempSR <- c(2,3,5)
tempNum <- c(sum(dataMatrix_3$Num[selectIDs_3]),sum(dataMatrix_3$Num[selectIDs_2]),sum(dataMatrix_3$Num[selectIDs_1]))
drawMatrix <- data.frame(SR = tempSR,Num = tempNum)
drawMatrix$SR <- as.factor(drawMatrix$SR)
drawMatrix$Num <- drawMatrix$Num/sum(drawMatrix$Num)
fig_S5_3 <- ggplot()+
  geom_bar(data = drawMatrix,mapping = aes(x = '',y = Num,fill = SR),color = '#000000',size = 0.3,width = 1,stat = 'identity')+
  scale_fill_manual(values = c(CMYKtoRGB(0,0.38,0.96,0),CMYKtoRGB(0.82,0.20,0.93,0.24),CMYKtoRGB(0.84,0.67,0,0)))+
  coord_polar('y',start = 0)+
  theme_custom()
##==== All ====##

##==== Combine ====##
fig_S5 <- ggdraw()+
  draw_plot(fig_S5_1,x = 0,y = 0,width = 0.333,height = 1)+
  draw_plot(fig_S5_2,x = 0.334,y = 0,width = 0.333,height = 1)+
  draw_plot(fig_S5_2,x = 0.667,y = 0,width = 0.333,height = 1)
outputFileName <- paste0(currentPath,'/fig_S5.pdf')
pdf(file = outputFileName,width = 3.5,height = 1,colormodel = 'cmyk')
print(fig_S5)
dev.off()
##==== Combine ====##