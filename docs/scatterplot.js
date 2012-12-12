function HealthvisScatterplot() {
	var w = 700;
	var h = 400;
	var padding = 30;

	this.init = function(elementId, d3Params) {
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
            .range([2, 5]);

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
0
        this.vis.append("g")
            .attr("class", "axis")
            .attr("transform", "translate(" + padding + ",0)")
            .call(yAxis);
	}

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
}

healthvis.register(new HealthvisScatterplot());
