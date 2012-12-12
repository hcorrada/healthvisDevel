require(healthvisDevel)

pythonbin="/opt/local/Library/Frameworks/Python.framework/Versions/2.7/bin/python2.7"
healthvisDevel::setup(python_binary=pythonbin)
url=healthvisDevel::startServer()
browseURL(url)

n = 50;
xRange = runif(1) * 1000
yRange = runif(1) * 1000
zRange = runif(1) * 1000

x = runif(n,max=xRange)
y = runif(n,max=yRange)
z = runif(n,max=zRange)
class = factor(sample(c("A","B","C"),n,replace=TRUE))

scatterVis=function(x,y,z,class,plot.title="My scatterplot", url=healthvisDevel::getURL(), plot=TRUE) {
  d3Params=list(x=x,
                y=y,
                z=z,
                class=class,
                colors=RColorBrewer::brewer.pal(nlevels(class),"Dark2"),
                xRange=xRange,
                yRange=yRange,
                zRange=zRange,
                levels=levels(class))
  
  varType=c("continuous", "factor")
  vars=list(size=c(0,max(z)),
            class=levels(class))
  
  healthvisObj = new("healthvis",
                     plotType="scatterplot",
                     plotTitle=plot.title,
                     varType=varType,
                     varList=vars,
                     d3Params=d3Params,
                     url=url)  
  
  if (plot) {
    plot(healthvisObj)
  }
  return(healthvisObj)
}

obj=scatterPlotVis(x,y,z,class,plot=FALSE)

#healthvisDevel::stopServer()
