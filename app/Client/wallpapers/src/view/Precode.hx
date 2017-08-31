/*
 * Copyright 12-Aug-2017 ºDeme
 * GNU General Public License - V3 <http://www.gnu.org/licenses/>
 */

package view;

import dm.It;
import dm.DomObject;
import dm.Ui;
import dm.Ui.Q;
import dm.I18n._;

class Precode {
  var control:Control;
  var model:Model;
  var buttonsDiv = Q("div").style("text-align:center");
  var codeDiv = Q("div");

  public function new(control:Control) {
    this.control = control;
    model = control.model;
  }

  function updateButtons() {
    function separator() {
      return Q("span").html("&nbsp;");
    }
    function mkUndo() {
      return Ui.link(function (ev) { return control.undoPrecode(); })
        .add(Ui.img("undo"));
    }
    function mkRedo() {
      return Ui.link(function (ev) { return control.redoPrecode(); })
        .add(Ui.img("redo"));
    }

    buttonsDiv.removeAll();
    if (model.precodeShow) {
      buttonsDiv.add(mkUndo()).add(separator()).add(mkRedo());
    }
  }

  function updateCode() {
    function mkTextEntry() {
      return Q("textarea").att("rows", 15).att("cols", "30");
    }

    codeDiv.removeAll();
    if (model.precodeShow) {
      var entry = mkTextEntry().value(model.precode[0]);
      entry.on(CHANGE, function (ev) { model.precodeSet(entry.getValue()); });
      codeDiv.add(entry);
    }
  }

  public function update() {
    buttonsDiv.removeAll();
    codeDiv.removeAll();
  }

  public function mkButtons() {
    updateButtons();
    return buttonsDiv;
  }

  public function mkCode() {
    updateCode();
    return codeDiv;
  }

}
