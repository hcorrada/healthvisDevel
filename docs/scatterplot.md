#Getting Started with healthvisDevel

##Setup

First we need to setup the healthvisDevel web server and environment. Running the following code in the current directory will download all required python modules and install the web server.

```r
require(healthvisDevel)
healthvisDevel::setup()
```
You can start and test the web server with :

```r
url=healthvisDevel::startServer()
browseURL(url)
healthvisDevel::stopServer()
```

##The example

We'll be using a slightly modified version of the scatterplot example from this [tutorial](http://alignedleft.com/tutorials/d3/). You can download the example html from here [`http://alignedleft.com/content/3.tutorials/10.d3/160.axes/demo/6.html`](http://alignedleft.com/content/3.tutorials/10.d3/160.axes/demo/6.html)

Our goal will be to make a `scatterVis` function that makes a scatterplot of this type from arbitrary data. We will test it generating data at random as in the tutorial. We will also add a form to the plot that allows to filter data based on values and select point colors. Before you continue, you should make sure you understand what the JavaScript code is doing.

We will make two changes to this example: 1) we will pass a vector `z` containing scatterplot point sizes (instead of using the y value to set size), and we will also define a factor variable `class`. We will use point color to indicate the class value. We will add a form to our page that let's us filter data by size and class.

##The framework

Visualizations in healthvisDevel are organized in a fairly straightforward manner. After running the `setup` code above you will see a `healthvisServer` directory with the following structure:

INSERT FILE STRUCTURE DIAGRAM HERE

Your JavaScript code will go in the `application/static/js` directory and css style file can go in `application/static/css`. 

##The R side

We first replicate the data generation on the R side which we do as follows:

```r
n = 50;
xRange = runif(1) * 1000
yRange = runif(1) * 1000
zRange = runif(1) * 1000

x = runif(n,max=xRange)
y = runif(n,max=yRange)
z = runif(n,max=zRange)
cls = factor(sample(c("A","B","C"),n,replace=TRUE))
```

Now we write our `scatterVis` function. It will take arguments `x` and `y` for point coordinates, and arguments `z` and `class` for point sizes and class. The remaining parameters are standard style in healthvis. 

The mechanism used in healthvis is that whatever data and parameters used by d3 are passed from R in a JSON string. We will construct a list `d3Params` containing data and parameters. You can include anything you will use on your d3 script, the framework will pass this along unmodified.

The remaining work for this function to do is to determine controls to include for modifying the plot. We want to add two controls on the form, one to filter by size (argument `z`) and one to filter by class. We do this by creating a `vars` list containing the variable range for the continious `size` variable, and the levels for the `class` factor. Finally, we create and return the object of class `healthvis`. The final form of the function is this:

```r
scatterVis=function(x, y, z, class, plot.title="My scatterplot", url=NULL, plot=TRUE) { 
  d3Params=list(x=x, 
                y=y, 
                z=z, 
                class=class,
                colors=RColorBrewer::brewer.pal(nlevels(class ),"Dark2"),
                xRange=xRange, 
                yRange=yRange, 
                zRange=zRange, 
                levels=levels( class))
    
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
```
Finally, we create and plot using:

```r
scatterVis(x,y,z,class,url=healthvisDevel::getURL())
```
##Style

CSS and JavaScript are kept separately in the `static` directory. First we will take the CSS portion in the scatterplot file and create a new css file `scatterplot.css` with the following content:

```css
.axis path,
.axis line {
    fill: none;
    stroke: black;
    shape-rendering: crispEdges;
}
             
.axis text {
    font-family: sans-serif;
    font-size: 11px;
}
```

##The d3 side

The healthvis framework uses a very simple API. Visualizations need to implement three functions: 
[`init`]: sets up data and plot elements  
[`visualize`]: renders the plot  
[`update`]: updates the plot in response to changes to form controls  

Finally, these functions are registered into the `healthvis` framework. The general structure will look like this:

```javascript
function HealthvisScatterplot() {
   this.init = function(elementId, d3Params) {}
   this.visualize = function() {}
   this.update = function(formData) {}
}

healthvis.register(new HealthvisScatterplot());
```
###Initializing

The purpose of the `init` function is to select the document element holding the plot and to setup data and plot elements. The first argument is the id of the `div` in the page where the plot will be shown. This can be passed to a `d3.select` call to setup the plot. The second argument is a JavaScript array resulting from parsing the JSON string that was created from the `d3Params` created in R.

```javascript
    this.init = function(elementId, d3Params) {
        var w = 700;
        var h = 400;
        var padding = 30;


        this.vis = d3.select(elementId)
                    .append('svg:svg')
                    .attr('height', h)
                    .attr('width', w);

        // read data from parameters
        var x = d3Params.x;
        var y = d3Params.y;
        var size = d3Params.z;
        var cls = d3Params.class;

        // zip into array of arrays
        this.data = d3.zip(x,y,size,cls);

        // read metadata from parameters
        var xRange = d3Params.xRange;
        var yRange = d3Params.yRange;
        var zRange = d3Params.zRange;
        var levels = d3Params.levels;
        this.colors = d3Params.colors;

        // make an associative array of level indexes
        this.levelMap = new Array(levels.length);
        for (var i=0; i<levels.length; i++) {
            this.levelMap[levels[i]]=i+1;
        }

        // scales and axes
        this.xScale = d3.scale.linear()
            .domain([0, xRange])
            .range([padding, w-padding*2]);

        this.yScale = d3.scale.linear()
            .domain([0, yRange])
            .range([h-padding, padding]);

        this.zScale = d3.scale.linear()
            .domain([0, zRange])
            .range([2, 10]);

        var xAxis = d3.svg.axis()
            .scale(this.xScale)
            .orient("bottom")
            .ticks(5);

        var yAxis = d3.svg.axis()
            .scale(this.yScale)
            .orient("left")
            .ticks(5);

        this.vis.append("g")
            .attr("class", "axis")
            .attr("transform", "translate(0," + (h-padding) + ")")
            .call(xAxis);

        this.vis.append("g")
            .attr("class", "axis")
            .attr("transform", "translate(" + padding + ",0)")
            .call(yAxis);
    }
```

###Visualizing

The actual plot is straightfoward now. We just add circles for each point in the scatterplot.

```javascript
this.visualize = function() {
        var xScale = this.xScale,
            yScale = this.yScale,
            zScale = this.zScale,
            colors = this.colors;

        this.circles = this.vis.selectAll("circle")
            .data(this.data)
            .enter()
            .append('svg:circle')
            .attr('cx', function(d) {
                return xScale(d[0]);
            })
            .attr('cy', function(d) {
                return yScale(d[1]);
            })
            .attr('r', function(d) {
                return zScale(d[2]);
            })
            .attr('fill', function(d) {
                return colors[d[3]-1];
            })
    }
```
###Updating

The last thing to do is to update the plot in response to changes in the form controls. We'll do this by setting the visibility argument of the points depending on their size and class.

```javascript
    this.update = function(formData) {
        var minSize=null,
            theClass=null;

        for (var i=0; i<formData.length; i++) {
            if (formData[i].name == "size") {
                minSize = parseFloat(formData[i].value);
            } else {
                theClass = this.levelMap[formData[i].value];
            }
        }

        this.circles.attr('visibility', function(d) {
            return d[3]==theClass && d[2] >= minSize ? 'visible' : 'hidden';
        });
    }
```

That does it. 