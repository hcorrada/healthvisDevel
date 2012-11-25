#Getting Started with healthvisDevel

##Setup

First we need to setup the healthvisDevel environment. Running the following code in the current directory will download all required python modules required.

 > healthvisDevel::setup()

You can test that the setup is correct by starting and stopping the web server:

 > url=healthvisDevel::startServer()
 > browseURL(url)
 > healthvisDevel::stopServer()

##The example

We'll be using the scatterplot example from this [tutorial](http://alignedleft.com/tutorials/d3/) as an example. You can download the example html from here [`http://alignedleft.com/content/3.tutorials/10.d3/160.axes/demo/6.html`](http://alignedleft.com/content/3.tutorials/10.d3/160.axes/demo/6.html)

Our goal will be to make a `scatterVis` function that makes a scatterplot of this type from arbitrary data. We will test it generating data at random as in the tutorial. We will also add a form to the plot that allows to filter data based on values and select point colors. Before you continue, you should make sure you understand what the JavaScript code is doing.

##The framework

Visualizatinos in healthvisDevel are organized in a fairly straightforward manner. After running the `setup` code above you will see a healthvis directory with the following structure:

INSERT FILE STRUCTURE DIAGRAM HERE

Your JavaScript code will go in the application/static directory. Your R code can be anywhere you like. 

##Preparing

CSS and JavaScript are kept separately in the directory. First we will take the CSS portion in the scatterplot file and create a new css file `basic_scatterplot.css` with the following content:

INCLUDE CSS HERE

Next, we will create a JavaScript file `basic_scatterplot.js` which contains the actual rendering code.

INCLUDE JS HERE

The mechanism used in healthvis is that whatever data and parameters used by JavaScript are passed from R in a JSON string. The first step is to identify what data should be passed from R in this case. In this case we will only pass the x and y vectors themselves.


##The R side

We want to replicate the data generation on the R side which we can do as follows:

INSERT R CODE HERE

We want to add two controls on the form, we do this by passing information on varType and varList. Create a healthvis object as follows:

INSERT OBJECT CODE CREATION CODE HERE

##The d3 side

Now we just need to receive that data passed as d3Params. First we wrap our visualization code around a callback function, and get the process started from a d3.json call.

INSERT EXAMPLE HERE

The x and y vectors are parsed from the d3Params and the plot is done. You can view the plot now by using the plot method on the object we created previously.

INSERT PLOT CALL HERE

The plot is done except that changes on the form has no effect.

##The form

The way healthvis deals with the form is by calling function `updateVis` which should be defined in the js file. Here we implement the function as such:

INSERT updateVis function HERE

We are done.



