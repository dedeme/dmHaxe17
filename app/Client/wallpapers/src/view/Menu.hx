/*
 * Copyright 06-Aug-2017 ºDeme
 * GNU General Public License - V3 <http://www.gnu.org/licenses/>
 */

package view;

import dm.Ui;
import dm.Ui.Q;
import dm.It;
import dm.I18n._;

class Menu {
  var coorDiv = Q("div");

  var control:Control;
  var model:Model;

  public function new(control:Control) {
    this.control = control;
    model = control.model;
  }

  public function setCoor() {
    function format(x:Float):String {
      var v = Std.string(Math.abs(x));
      return (x < 0 ? "-= " : "+= ") + (v.length > 6 ? v.substring(0, 6) : v);
    }

    var x = "x " + format(model.lastx - 0.5) + ";";
    var y = "y " + format(model.lasty - 0.5) + ";";

    coorDiv.removeAll().add(Q("span").html('<code>$x<br>$y</code>'));
  }

  function mkTd() {
    return Q("td").style("text-align:left;white-space: nowrap;");
  }

  function mkTdc() {
    return Q("td").style("text-align:center;white-space: nowrap;");
  }

  function mkOptions(active:String, values:Array<String>, f:String->Void) {
    function mkOption(value:String) {
      if (value == active) {
        return Q("span").html("<b>" + value + "</b>");
      }
      return Ui.link(It.f(f(value))).klass("link").html(value);
    }

    var r = mkTdc();
    r.add(mkOption(values[0]));
    for (i in 1...values.length) {
      r.add(Q("span").html(" · ")).add(mkOption(values[i]));
    }
    return r;
  }

  function separator() {
    return Q("td").html("<hr>");
  }

  function mkLabel(value:String) {
    return mkTd().html("<i>" + value + "</i>");
  }

  function mkDraw() {
    return mkTd()
      .add(Ui.link(It.f(control.draw())).klass("link").html(_("Draw")));
  }

  function mkCanvasSize() {
    var act = " " + Std.string(model.canvasSize) + " ";
    return mkOptions(act, [" 1 ", " 2 ", " 3 ", " 4 ", " 5 "], function (v) {
      control.canvasSize(Std.parseInt(v));
    });
  }

  function mkDownload() {
    var sizes = [
      "640x480", "800x600", "1024x768", "1280x800", "1280x960",
      "1280x1024", "1400x1050", "1600x1200"
    ];
    return mkTd()
      .add(Q("ul").style("list-style:none;padding-left:0px;margin-top:0px;")
        .add(Q("li")
          .html("<a href='#' onclick='return false;'>" + _("Download") + "</a>")
          .add(Q("ul").att("id", "hlist")
            .style("list-style:none;padding-left:10px;")
            .addIt(It.from(sizes).map(function (sz) {
              return Q("li")
                .add(Ui.link(function (ev) {
                  var n = It.from(sizes).index(sz);
                  control.canvasSize(n + 6);
                }).klass("link").html("<code>" + sz + "</code>"));
            })))));
  }

  function mkCoor() {
    setCoor();
    return mkTd().add(coorDiv);
  }

  function mkPrecode() {
    var act = model.precodeShow
      ? _("On")
      : _("Off");
    return mkOptions(act, [_("On"), _("Off")], function (v) {
      control.setPrecodeShow(v == _("On"));
    });
  }

  function mkSave() {
    return mkTd()
      .add(Ui.link(It.f(control.save())).klass("link")
        .html(_("Save Functions")));
  }

  function mkGallery() {
    return mkTd()
      .add(Ui.link(It.f(control.gallery())).klass("link")
        .html(_("Gallery")));
  }

  function mkLoad() {
    function drag(e) {
      e.stopPropagation();
      e.preventDefault();
    }

    function drop(e) {
      e.stopPropagation();
      e.preventDefault();

      var dt = e.dataTransfer;
      var files = dt.files;

      control.load(files);
    }

    var dropbox = Q("div").klass("frame").style("width:120px;height:40px;");
    dropbox.e.addEventListener("dragenter", drag, false);
    dropbox.e.addEventListener("dragover", drag, false);
    dropbox.e.addEventListener("drop", drop, false);

    return Q("td").style("text-align:center;").add(dropbox);
  }

  function mkLang() {
    var act = model.language.toUpperCase();
    return mkOptions(act, ["EN", "ES"], function (v) {
      control.language(v.toLowerCase());
    });
  }

  public function mk() {
    return Q("table").klass("frame")
      .add(Q("tr").add(mkDraw()))
      .add(Q("tr").add(mkLabel(_("Preview"))))
      .add(Q("tr").add(mkCanvasSize()))
      .add(Q("tr").add(mkDownload()))
      .add(Q("td").add(Q("hr").style("height:0px;margin-top:-10px")))
      .add(Q("tr").add(mkLabel(_("Coordinates"))))
      .add(Q("tr").add(mkCoor()))
      .add(Q("tr").add(mkLabel(_("Precode"))))
      .add(Q("tr").add(mkPrecode()))
      .add(separator())
      .add(Q("tr").add(mkSave()))
      .add(Q("tr").add(mkLabel(_("Load Functions"))))
      .add(Q("tr").add(mkLoad()))
      .add(Q("tr").add(mkGallery()))
      .add(separator())
      .add(Q("tr").add(mkLabel(_("Language"))))
      .add(Q("tr").add(mkLang()))
    ;
  }
}

