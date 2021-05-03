args = commandArgs(trailingOnly=TRUE)

#args[1] = wild type sample
#args[2] = tumor sample

myDataWT <- read.table(normalizePath(args[1]), col.names = c('chrmomosome', 'position', 'number_of_reads'))

myDataTU <- read.table(normalizePath(args[2]), col.names = c('chrmomosome', 'position', 'number_of_reads'))

position_read_depth <- function(wt, tu) { 
  z <- log2(tu / wt)
  return(z)
}

dataMerge <- merge(myDataWT, myDataTU, by = "position", all.y = TRUE, all.x = TRUE, suffixes = c(".wt",".tu"))


data_tu_div_wt_log = c(1:nrow(dataMerge))
for(i in 1:nrow(dataMerge)){
  read_dept <- position_read_depth(dataMerge[i,3],dataMerge[i,5])
  data_tu_div_wt_log[i] <- read_dept
}

dataMergeFrame <- data.frame( position = dataMerge[1],data_log = data_tu_div_wt_log
)

png(file="./read-depth-plot.png", width=1200, height = 400)
plot(x=dataMergeFrame$position, y=dataMergeFrame$data_log, pch=20,  bg="gray", 
  main = "Read depth plot",
  xlab = "Chromosome position",
  ylab = "Log_2 ration")
dev.off()

