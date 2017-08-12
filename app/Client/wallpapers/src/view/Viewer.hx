/*
 * Copyright 06-Aug-2017 ºDeme
 * GNU General Public License - V3 <http://www.gnu.org/licenses/>
 */

package view;

import dm.DomObject;
import dm.Ui;
import dm.Ui.Q;

class Viewer {
  public var control:Control;
  public var model:Model;

  var divCanvas = Q("div").style("text-align:center;");
  public var canvas:DomObject;

  public function new(control:Control) {
    this.control = control;
    model = control.model;

    canvas = Q("canvas");
    var cv:Dynamic = canvas.e;
    cv.width = model.canvasw;
    cv.height = model.canvash;
    cv.onclick = function (ev) {
      var rect = cv.getBoundingClientRect();
      control.setCoor(ev.clientX - rect.left, ev.clientY - rect.top);
    }
  }

  public function mk() {
    var cv:Dynamic = canvas.e;
    divCanvas.removeAll()
      .add(Q("table").att("align", "center").add(Q("tr")
        .add(Q("td").style(
          "background-color: rgb(250, 250, 250);" +
          "border: 1px solid rgb(110,130,150);" +
          "padding: 4px 4px 0px 4px;border-radius: 4px;"
        ).add(canvas))));
    return divCanvas;
  }

  public function draw() {
    var fCalc = model.fCalc;
    var cv:Dynamic = canvas.e;
    var ctx = cv.getContext("2d");
    var w = model.canvaspw;
    var h = model.canvasph;
    var maxy = model.canvash - 1;

    function plot(partx, party) {
      var idata = ctx.createImageData(w, h);
      var data = idata.data;
      for (y in 0...h) {
        var y2 = maxy - party * h - y;
        for (x in 0...w) {
          var x2 = partx * w + x;
          var px = (y * w + x) * 4;

          data[px] = fCalc(0, x2, y2);
          data[px + 1] = fCalc(1, x2, y2);
          data[px + 2] = fCalc(2, x2, y2);
          data[px + 3] = 255;
        }
      }
      ctx.putImageData(idata, partx * w, party * h);
    }

    var partx = 0;
    var party = 0;
    var timer = new haxe.Timer(100);
    timer.run = function () {
      plot(partx, party);
      ++partx;
      if (partx == model.canvaspx) {
        partx = 0;
        ++party;
        if (party == model.canvaspy) {
          timer.stop();
        }
      }
    }
  }

}

