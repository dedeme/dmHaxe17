/*
 * Copyright 06-Aug-2017 ºDeme
 * GNU General Public License - V3 <http://www.gnu.org/licenses/>
 */

package view;

import dm.It;
import dm.DomObject;
import dm.Ui;
import dm.Ui.Q;

class Buttons {
  var control:Control;

  public function new(control:Control) {
    this.control = control;
  }

  function separator() {
    return Q("span").html("&nbsp;");
  }

  function mkUndo(color:Int) {
    return Ui.link(function (ev) { return control.undoColor(color); })
      .add(Ui.img("undo"));
  }

  function mkRedo(color:Int) {
    return Ui.link(function (ev) { return control.redoColor(color); })
      .add(Ui.img("redo"));
  }

  function mkColor(color:Int) {
    return Ui.img(
      color == 0 ? "redColor" : color == 1 ? "greenColor" : "blueColor"
    );
  }

  function mkLed(source:Int, target:Int) {
    return Ui.link(function (ev) {
        return control.changeColor(source, target);
      }).add(Ui.img(
        target == 0 ? "redPin" : target == 1 ? "greenPin" : "bluePin"
      ));
  }

  public function mk():Array<DomObject> {
    function mkTd(c:Int) {
      var undo = mkUndo(c);
      var redo = mkRedo(c);
      var color = mkColor(c);
      var led1 = mkLed(c, 2);
      var led2 = mkLed(c, 1);
      if (c == 1) {
        led1 = mkLed(c, 0);
        led2 = mkLed(c, 2);
      } else if (c == 2) {
        led1 = mkLed(c, 1);
        led2 = mkLed(c, 0);
      }
      return Q("td").style("text-align:center;width:10px;")
        .add(undo)
        .add(separator())
        .add(redo)
        .add(separator())
        .add(color)
        .add(separator())
        .add(led1)
        .add(separator())
        .add(led2)
      ;
    }

    return [mkTd(0), mkTd(1), mkTd(2)];
  }
}
