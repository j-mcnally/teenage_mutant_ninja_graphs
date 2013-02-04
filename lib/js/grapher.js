var Grapher;

Grapher = (function() {

  Grapher.prototype.drawGraph = function(id, index) {
    var r;
    r = new Raphael(id);
    if (index % 2) {
      return this.drawLineGraph(r);
    } else if (index % 3) {
      return this.drawBarGraph(r);
    } else {
      return this.drawPieGraph(r);
    }
  };

  Grapher.prototype.prepare = function() {
    var _this = this;
    return $(".graph").each(function(i, e) {
      return _this.drawGraph($(e).attr("id"), i);
    });
  };

  Grapher.prototype.drawLegend = function(chart, raph, labels, type) {
    var clr, h, i, longest, sy, txt, txtattr, x, _i, _ref, _results;
    if (labels == null) {
      labels = ['some var 1', 'some var 2'];
    }
    if (type == null) {
      type = 'line';
    }
    txtattr = {
      font: "12px sans-serif"
    };
    chart.labels = raph.set();
    x = 200;
    h = 160;
    sy = h;
    longest = _.max(labels, function(l) {
      return l.length;
    });
    raph.rect(x - 10, sy - 10, 9 * longest.length, 20 * labels.length).attr({
      fill: "rgba(255,255,255,.7)",
      stroke: "#000"
    });
    _results = [];
    for (i = _i = 0, _ref = labels.length; 0 <= _ref ? _i < _ref : _i > _ref; i = 0 <= _ref ? ++_i : --_i) {
      if (type === 'line') {
        clr = chart.lines[i].attr("stroke");
      } else if (type === 'bar') {
        clr = chart.bars[i][0].attr("fill");
      }
      chart.labels.push(raph.set());
      chart.labels[i].push(raph.circle(x, h, 5, 10).attr({
        fill: clr,
        stroke: "none"
      }));
      chart.labels[i].push(txt = raph.text(x + 10, h, labels[i]).attr(txtattr).attr({
        fill: "#000",
        "text-anchor": "start"
      }));
      _results.push(h += chart.labels[i].getBBox().height * 1.2);
    }
    return _results;
  };

  Grapher.prototype.drawLineGraph = function(r) {
    var lines, txtattr;
    txtattr = {
      font: "12px sans-serif"
    };
    lines = r.linechart(10, 10, 280, 200, [[1, 2, 3, 4, 5, 6, 7], [3.5, 4.5, 5.5, 6.5, 7, 8]], [[12, 32, 23, 15, 17, 27, 22], [10, 20, 30, 25, 15, 28]], {
      nostroke: false,
      axis: "0 0 1 1",
      symbol: "circle",
      smooth: false
    }).hoverColumn(function() {
      var i, _i, _ref, _results;
      this.tags = r.set();
      _results = [];
      for (i = _i = 0, _ref = this.y.length; 0 <= _ref ? _i < _ref : _i > _ref; i = 0 <= _ref ? ++_i : --_i) {
        _results.push(this.tags.push(r.tag(this.x, this.y[i], this.values[i], 200, 10).insertBefore(this).attr([
          {
            fill: "#fff"
          }, {
            fill: this.symbols[i].attr("fill")
          }
        ])));
      }
      return _results;
    }, function() {
      return this.tags && this.tags.remove();
    });
    lines.symbols.attr({
      r: 6
    });
    return this.drawLegend(lines, r, null, "line");
  };

  Grapher.prototype.drawPieGraph = function(r) {
    var pie;
    pie = r.piechart(110, 110, 80, [25, 55, 20], {
      legend: ["Some var 1", "Some var 2", "Some var 3"],
      legendpos: "east"
    });
    return pie.hover(function() {
      this.sector.stop();
      this.sector.scale(1.1, 1.1, this.cx, this.cy);
      if (this.label) {
        this.label[0].stop();
        this.label[0].attr({
          r: 7.5
        });
        this.label[1].attr({
          "font-weight": 800
        });
      }
      return this.flag = r.popup(this.cx, this.cy, this.sector.value.value || "0").insertAfter(this.sector);
    }, function() {
      this.sector.animate({
        transform: 's1 1 ' + this.cx + ' ' + this.cy
      }, 500, "bounce");
      this.flag.animate({
        opacity: 0
      }, 300, function() {
        return this.remove();
      });
      if (this.label) {
        this.label[0].animate({
          r: 5
        }, 500, "bounce");
        return this.label[1].attr({
          "font-weight": 400
        });
      }
    });
  };

  Grapher.prototype.drawBarGraph = function(r) {
    var bc, txtattr;
    txtattr = {
      font: "12px sans-serif"
    };
    bc = r.barchart(30, 0, 250, 234, [[12, 32, 23, 15, 17, 27, 22], [10, 20, 30, 25, 15, 28]], 0, {
      type: "sharp"
    }).hover(function() {
      return this.flag = r.popup(this.bar.x, this.bar.y, this.bar.value || "0").insertBefore(this);
    }, function() {
      return this.flag.animate({
        opacity: 0
      }, 300, function() {
        return this.remove();
      });
    });
    Raphael.g.axis(25, 212, 190, 0, 32, 4, 1, null, "|", 2, r);
    return this.drawLegend(bc, r, null, "bar");
  };

  function Grapher() {
    this.prepare();
  }

  return Grapher;

})();

$(document).ready(function() {
  var grapher;
  return grapher = new Grapher();
});
