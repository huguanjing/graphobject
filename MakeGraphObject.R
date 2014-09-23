#A function to make, return and plot a igraph object
#The function takes a list of edges, a vector of gene names, 
#and a vector of assocaited plotting colors for those gene. 
#Other parameters can be passed and they are listed below.

####
#Inputs and parameters
####
# 
# edgeList    A matrix (3 x edge number) listing the "from" and "to" 
#             genes (columsn one and two) as well as the associated weight.
#             In most cases this will be the correlation score, or something similar.
# 
# minDegree   The number of edges need to plot the node, nodes with fewer edges will be deleted
# 
# geneNames   A list of gene names that nake up the nodes of the graph
# 
# geneCols    A named vector of gene colors. Names should be the same as those in geneNames
# 
# delete      This parameter dictates the strenght of an adge that is needed to add to the plot.
#             Note that all supplied edges are used to calculate the layout, but those falling
#             the delete threshold will be excluded from the plot.

###
# Output
###

#returns a list where G=graph object, L=layout, C=colors

require(igraph)
source("/Users/simonrenny-byfield/cotton/diploid_domestication/FiberTranscriptomeProject/scripts/plotg.R")

MakeGraphObject<-function(edgeList,minDegree=1, geneNames,geneCols, delete = .5) {
  
  #Set up some necessary params  
  len<-length(unique(c(edgeList[,1], edgeList[,2])))
  names<-geneNames
  #create the graph
  g<-graph.empty(n=0, directed=FALSE)
  #add vertices, one for each gene
  g<-add.vertices(g,nv=length(names), name=names)
  #add edges
  g[from=as.character(edgeList[,1]),to=as.character(edgeList[,2]),attr="weight"]<-as.numeric(edgeList[,3])
  #remove nodes colored grey (no module membership)
  g<-delete.vertices(g, which(geneCols == "grey" ))
  #remove nodes with fewer edges than "minDegree"
  g<-delete.vertices(g, which(degree(g) < minDegree))
  #simplify
  g<-simplify(g)
  #calcualte node layout
  coord <- layout.fruchterman.reingold(g, dim = 3)
  #delete edges falling below the weight threshold "delete"
  g<-delete.edges(g, which(E(g)$weight < delete ))
  nomnom<-get.data.frame(g, what="vertices")
  #set graph color to each node
  colors<-geneCols[match(nomnom[,1],names(geneCols))]
  #pl<-plotg(g, lwd = 0.4 , cex = 0.65, bg = "white",seg.col="darkgrey")
  GL<-list("G"=g, "L"=coord,"C"=colors)
  return(GL)
}#MakeGraphObject
