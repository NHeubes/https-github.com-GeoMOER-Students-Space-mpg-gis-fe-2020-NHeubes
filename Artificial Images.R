
# load packages
require(link2GI)
require(raster)
require(listviewer)
projRootDir=tempdir()
# link OTB note for linux use the argument searchLocation = "/usr/bin/"
otblink<-link2GI::linkOTB(ver_select = T,searchLocation = "C:/Users/nheub/Documents/~edu/mpg-envinsys-plygrnd/OTB-7.2.0-Win64")

# get some example data
data('rgb', package = 'link2GI')

# yes trees what else?
raster::plotRGB(rgb)
r<-raster::writeRaster(rgb, 
                       filename=file.path(projRootDir,"touzi.tif"),
                       format="GTiff", overwrite=TRUE)
## for the example we use the edge detection, 
algoKeyword<- "EdgeExtraction"

# parse the function for generating the command list 
cmd<-parseOTBFunction(algo = algoKeyword, gili = otblink)

# you will find the help online at 
# https://www.orfeo-toolbox.org/CookBook/Applications/app_EdgeExtraction.html
# you can also use the extracted command help of the choosen algorithm
# listviewer is a great nice tool to view lists in R
listviewer::jsonedit(cmd$help)

## define the mandantory arguments all other will be default
cmd$input  <- file.path(projRootDir,"touzi.tif")
cmd$filter <- "touzi"
cmd$channel <- 2
cmd$out <- file.path(projRootDir,paste0("out",cmd$filter,".tif"))

## run algorithm
retStack<-runOTB(cmd,gili = otblink)

## plot filter raster on the green channel
raster::plot(retStack)
