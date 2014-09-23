#A usefull function for plotting igrap objects returned from MakeGrapeObject()

###
#Parameters
###

# G a list

require(igraph)
require(scales)

plotg<-function(G,wlim=NULL,col="black",cex=0.4,lwd=.5,bg="white",seg.col="black",...){
  
  #e=get.edgelist(GG,names=F)+1
  e=get.edgelist(G$G,names=F)
  w=E(G$G)$weight
  if (!is.null(wlim)) {e=e[w>wlim,]; w=w[w>wlim]}
  X0=G$L[e[,1],1]
  Y0=G$L[e[,1],2]
  X1=G$L[e[,2],1]
  Y1=G$L[e[,2],2]
  par(bg=bg)
  plot(range(G$L[,1]),range(G$L[,2]),xlab="",ylab="",axes=F,type="n",)
  brv=col
  segments(X0,Y0,X1,Y1,lwd=lwd,col=seg.col)
  points(G$L,pch=1,cex=cex+0.1,col="black",...)
  points(G$L,pch=19,cex=cex,col=alpha(G$C, 0.5),...)
  par(bg="white")
}
