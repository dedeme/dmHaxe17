/*
 * Copyright 06-Aug-2017 ºDeme
 * GNU General Public License - V3 <http://www.gnu.org/licenses/>
 */

import js.html.FileReader;
import dm.I18n;
import dm.I18n._;
import dm.Ui;
import dm.B64;

class Control {

  public var model(default, null):Model;
  var view:View;

  public function new() {
    model = Model.mk();
    var dic = model.language == "en" ? I18nData.en() : I18nData.es();
    I18n.init(dic);
  }

  public function run() {
    view = new View(this);
    view.show();
    draw();
  }

  public function language(lang:String) {
    model.setLanguage(lang);
    var dic = lang == "en" ? I18nData.en() : I18nData.es();
    I18n.init(dic);
    run();
  }

  public function setPrecodeShow(value:Bool) {
    model.setPrecodeShow(value);
    run();
  }

  public function draw() {
    view.viewer.draw();
    model.fcPush();
  }

  public function canvasSize(size:Int) {
    model.setCanvasSize(size);
    run();
  }

  public function save() {
    var file = Ui.prompt(_("File name") + ":", "");
    if (file != null && file != "") {
      var hidden = dm.Ui.Q("a")
        .att("href", "data:text/csv;charset=utf-8," + model.saveFs())
        .att("download", file)
        .att("target", "_blank");
      hidden.e.click();
    }
  }

  public function load(files:Dynamic) {
    if (files.length != 1) {
      Ui.alert(_("Only can be uploaded one file"));
      return;
    }

    var reader = new FileReader();
    reader.onload = function (e) {
      model.loadFs(reader.result);
      run();
    };
    reader.readAsText(files[0]);
  }

  public function redoPrecode() {
    model.precodeRedo();
    run();
  }

  /// Colors are: 0-Red, 1-Green  and 2-Blue
  public function redoColor(color:Int) {
    model.fcRedo(color);
    run();
  }

  public function undoPrecode() {
    model.precodeUndo();
    run();
  }

  /// Colors are: 0-Red, 1-Green  and 2-Blue
  public function undoColor(color:Int) {
    model.fcUndo(color);
    run();
  }

  /// Colors are: 0-Red, 1-Green  and 2-Blue
  public function changeColor(source:Int, target:Int) {
    model.fcChange(source, target);
    run();
  }

  /// x e y are in pixels
  public function setCoor(x:Float, y:Float) {
    model.setCoor(x, y);
    view.menu.setCoor();
  }

}
