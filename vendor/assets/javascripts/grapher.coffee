Grapher = (->
  Grapher = ->
    
  Grapher::drawGraph = (id, index) ->
    r = undefined
    r = new Raphael(id)
    if index % 2
      @drawLineGraph r
    else if index % 3
      @drawBarGraph r
    else
      @drawPieGraph r



  Grapher::transform = (element_id) ->

    r = new Raphael(element_id)

    _this = @

    $("#" + element_id + ".line_graph").each () ->
      _this.drawLineGraph r, $(this)

    $("#" + element_id + ".bar_graph").each () ->
      _this.drawLineGraph r, $(this)

    $("#" + element_id + ".pie_graph").each () ->
      _this.drawLineGraph r, $(this)




  Grapher::drawLegend = (chart, raph, labels, type, elem) ->

    clr = undefined
    h = undefined
    i = undefined
    longest = undefined
    sy = undefined
    txt = undefined
    txtattr = undefined
    x = undefined
    _i = undefined
    _ref = undefined
    _results = undefined
    labels = ["some var 1"]  unless labels?
    type = "line"  unless type?
    txtattr = font: "12px sans-serif"
    chart.labels = raph.set()
    h = raph.height - 124
    sy = h
    longest = _.max(labels, (l) ->
      l.length
    )

    x = $(elem).width()-(9 * longest.length)

    raph.rect(x - 10, sy - 10, 9 * longest.length, 20 * labels.length).attr
      fill: "rgba(255,255,255,.7)"
      stroke: "#000"

    _results = []
    i = _i = 0
    _ref = labels.length


    while (if 0 <= _ref then _i < _ref else _i > _ref)
      if type is "line"
        clr = chart.lines[i].attr("stroke")
      else clr = chart.bars[i][0].attr("fill")  if type is "bar"
      chart.labels.push raph.set()
      chart.labels[i].push raph.circle(x, h, 5, 10).attr(
        fill: clr
        stroke: "none"
      )
      chart.labels[i].push txt = raph.text(x + 10, h, labels[i]).attr(txtattr).attr(
        fill: "#000"
        "text-anchor": "start"
      )
      _results.push h += chart.labels[i].getBBox().height * 1.2
      i = (if 0 <= _ref then ++_i else --_i)
    _results

  Grapher::numericMapping = (ary, possibleX) ->

    _.map ary, (i) -> 
      possibleX.indexOf(i)
    


  Grapher::drawLineGraph = (r, elem) ->

    yset = $(elem).data("yset");
    xset = $(elem).data("xset");
    labels = $(elem).data("labels");
    #if x coords are not number map them to a numeric index

    #assign each possible x value a numerical index
    possibleX = _.unique(_.flatten(xset))



    xdata = [];

    txset = _.map xset, (ary) =>
      return @numericMapping(ary, possibleX)



    console.log(txset)

    ycoords = yset;
    xcoords = txset

    console.log $(elem)
    lines = undefined
    txtattr = undefined
    txtattr = font: "12px sans-serif"
    lines = r.linechart(20, 10, $(elem).width()-20, 260, xcoords, ycoords,
      nostroke: false
      axis: "0 0 1 1"
      symbol: "circle"
      smooth: false
    ).hoverColumn(->
      i = undefined
      _i = undefined
      _ref = undefined
      _results = undefined
      @tags = r.set()
      _results = []
      i = _i = 0
      _ref = @y.length

      while (if 0 <= _ref then _i < _ref else _i > _ref)
        _results.push @tags.push(r.tag(@x, @y[i], @values[i], 260, 10).insertBefore(this).attr([
          fill: "#fff"
        ,
          fill: @symbols[i].attr("fill")
        ]))
        i = (if 0 <= _ref then ++_i else --_i)
      _results
    , ->
      @tags and @tags.remove()
    )
    lines.symbols.attr r: 6
    
    @customizeXAxis lines, r, elem, possibleX

    @drawLegend lines, r, labels, "line", elem

  
  Grapher::customizeXAxis = (lines, r, elem, possibleX) ->
    xpoints = lines.axis[0].text.items

    r.setSize(r.width + 60, r.height);

    for item in xpoints
      index = item.attr("text")
      if index % 1 == 0
        item.attr("text", possibleX[index])
        item.attr({transform: "r45"});
        item.attr({x: item.attr("x") + 25});
      else
        item.attr("text", "")


  Grapher::drawPieGraph = (r) ->
    pie = undefined
    pie = r.piechart(110, 110, 80, [25, 55, 20],
      legend: ["Some var 1", "Some var 2", "Some var 3"]
      legendpos: "east"
    )
    pie.hover (->
      @sector.stop()
      @sector.scale 1.1, 1.1, @cx, @cy
      if @label
        @label[0].stop()
        @label[0].attr r: 7.5
        @label[1].attr "font-weight": 800
      @flag = r.popup(@cx, @cy, @sector.value.value or "0").insertAfter(@sector)
    ), ->
      @sector.animate
        transform: "s1 1 " + @cx + " " + @cy
      , 500, "bounce"
      @flag.animate
        opacity: 0
      , 300, ->
        @remove()

      if @label
        @label[0].animate
          r: 5
        , 500, "bounce"
        @label[1].attr "font-weight": 400


  Grapher::drawBarGraph = (r) ->
    bc = undefined
    txtattr = undefined
    txtattr = font: "12px sans-serif"
    bc = r.barchart(30, 0, 250, 234, [[12, 32, 23, 15, 17, 27, 22], [10, 20, 30, 25, 15, 28]], 0,
      type: "sharp"
    ).hover(->
      @flag = r.popup(@bar.x, @bar.y, @bar.value or "0").insertBefore(this)
    , ->
      @flag.animate
        opacity: 0
      , 300, ->
        @remove()

    )
    Raphael.g.axis 25, 212, 190, 0, 32, 4, 1, null, "|", 2, r
    @drawLegend bc, r, null, "bar"

  Grapher
)()


window.grapher = new Grapher()