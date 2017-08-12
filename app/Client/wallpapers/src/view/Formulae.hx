/*
 * Copyright 06-Aug-2017 ºDeme
 * GNU General Public License - V3 <http://www.gnu.org/licenses/>
 */

package view;

import dm.It;
import dm.DomObject;
import dm.Ui;
import dm.Ui.Q;
import dm.I18n._;

class Formulae {
  public var control:Control;
  public var model:Model;

  public var fcs:Array<DomObject>;

  public function new(control:Control) {
    this.control = control;
    model = control.model;

    fcs = It.range(3).map(function (i) {
      return mkTextEntry()
        .value(model.fcs[i][0])
        .on(CHANGE, function (ev) { model.fcSet(i, fcs[i].getValue()); });
    }).to();
  }

  function mkTextEntry() {
    return Q("textarea").att("rows", 15).att("cols", "30");
  }

  public function mk() {
    function mkTd() {
      return Q("td").style("text-align:center;vertical-align:top;width:10px;");
    }

    return [
      mkTd().add(fcs[0]),
      mkTd().add(fcs[1]),
      mkTd().add(fcs[2])
    ];
  }

}
