####
# An exmaple control script untlizing the function is this repo
####

#Simon Renny-Byfield, Iowa State university, September 2014

rm(list=ls(all=TRUE))
library(WGCNA)
library(igraph)
library(compiler)
library(MASS)

#alter the path to the correct source file
source("/Users/simonrenny-byfield/cotton/diploid_domestication/FiberTranscriptomeProject/scripts/MakeGrapObject.R")
source("/Users/simonrenny-byfield/cotton/diploid_domestication/FiberTranscriptomeProject/scripts/plotg.R")
#power<-20

#####################################
#Start the analysis
#####################################

#set the wd here
wdir<-"xxxx"
#wdir<-getwd()
setwd(wdir)

#grab the relavent files and load in the data, you need a network (WGCNA) object to load in
#and expression data
files <- list.files(getwd())
Rfiles <- files[grep(glob2rx("*.R"), files)]

for ( i in Rfiles) {
  load(i)
}#for

###############################################################
#Calculate adjacency
###############################################################

#for AD1 wild graph
matWild<-adjacency(multiExpr[[4]]$data)
write.matrix(matWild, file="AD1.wild.adj.matrix.txt")
#for AD1 dom graph...
mat<-adjacency(multiExpr[[3]]$data)
write.matrix(mat, file="AD1.Dom.adj.matrix.txt")


##
#Use a perl program to trim the data, removing weak edges and duplicates etc
##

#change the path appropriately
system(command="perl /Users/simonrenny-byfield/cotton/diploid_domestication/FiberTranscriptomeProject/scripts/edgeList.pl AD1.Dom.adj.matrix.txt AD1.Dom.adj.edges.txt")
system(command="perl /Users/simonrenny-byfield/cotton/diploid_domestication/FiberTranscriptomeProject/scripts/edgeList.pl AD1.wild.adj.matrix.txt AD1.wild.adj.edges.txt")

#load the data back in, with your own path
edgeTestDom<-read.table("AD1.Dom.adj.edges.txt", sep = "\t", header = FALSE)
edgeTestWild<-read.table("AD1.wild.adj.edges.txt", sep = "\t", header = FALSE)

######################################################
#Calculate the networks
######################################################

######
# Create graph
######

#define the colors
colorsWild<-labels2colors(AD1.wild.net$colors)
names(colorsWild)<-colnames(multiExpr[[2]]$data)

#make the grpah object
gWild<-MakeGraphObject(edgeTestWild, geneNames=colnames(multiExpr[[2]]$data), geneCols=colorsWild,minDegree=5)
gDom<-MakeGraphObject(edgeTestDom, geneNames=colnames(multiExpr[[2]]$data), geneCols=colorsWild,minDegree=5)
#plotg(gWild,lwd = 0.1 , cex = 0.65, bg = "white",seg.col="darkgrey")
#plotg(gDom,lwd = 0.1 , cex = 0.65, bg = "white",seg.col="darkgrey")

#print to pdf
pdf("AD1_wild_vs_Dom_igraph.pdf", height = 12, width =24)
par(mfrow=c(1,2))
plotg(gWild, lwd = 0.1 , cex = 0.9, bg = "white",seg.col="grey")
plotg(gDom, lwd = 0.1 , cex = 0.9, bg = "white",seg.col="grey")
dev.off()

####
# END
####
