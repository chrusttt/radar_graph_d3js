define ['d3'], () ->
	class RadarGraph
		center: 0
		MAX_DATA = 3
		lines = 0
		constructor:  (selector, @height, @width, @dimension) ->
			#TODO constructor
			@_prepareSvg(selector, @height, @width)
			@_drawAxis(@dimension)
			

		drawLine: (data) ->
			if data.length = @dimension and lines <= MAX_DATA
				@center.append("path")
					   .attr("d", @_line(data))
					   .attr("opacity", 0.2)
				lines+=1

		_prepareSvg: (selector, height, width) ->
			svgGraph = d3.select(selector)
				 .append('svg:svg')
				 .attr('height', height)
				 .attr('width', width)
				 .on('click', console.log "SIEMA")

			@center = svgGraph.append('g')
				     .attr("transform", "translate("+height/2+","+width/2+")")

		

		_drawAxis: (number) ->
			@axisScale = d3.scale.linear()
	                    .domain([0, 5])
	                    .range([0, 250])
	                    .nice()

			axis = d3.svg.axis()
				         .scale(@axisScale)
				         .orient("left")
				         .tickValues([5])
				         .tickSize(0)
			
			for i in [0...number]
				axis[i] = @center.append('g')
		               .attr("transform", "rotate("+ @_angle(number, i) + ")")
		               .attr("class", "axis")
		               .call(axis)

		_angle: (length, i) -> 
			return i*360/length

		_line: d3.svg.line()
				 .x((d, i) ->
						@axisScale(@_point(d, i)[0]))
				 .y((d, i) ->
						@axisScale(@_point(d, i)[1]))
				 .interpolate("cardinal-closed")

		_point: (value, i) ->
			alfa = @_angle(@dimension, i)*Math.PI/180
			x = value*Math.cos(alfa)
			y = value*Math.sin(alfa)
			return [y, x]