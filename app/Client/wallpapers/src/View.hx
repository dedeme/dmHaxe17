/*
 * Copyright 06-Aug-2017 ºDeme
 * GNU General Public License - V3 <http://www.gnu.org/licenses/>
 */

import dm.Ui;
import dm.Ui.Q;
import dm.It;
import dm.I18n._;
import view.Menu;
import view.Buttons;
import view.Formulae;
import view.Viewer;
import view.Precode;
import view.Gallery;

class View {
  public var control:Control;
  public var model:Model;

  public var viewer:Viewer;
  public var menu:Menu;
  public var precode:Precode;

  var title = Q("div").style("text-align:center;font-size:35px;")
    .html("Wallpapers");

  public function new(control:Control) {
    this.control = control;
    model = control.model;
    viewer = new Viewer(control);
    menu = new Menu(control);
    precode = new Precode(control);
  }

  public function show() {
    var menu = this.menu.mk();
    var buttons = new Buttons(control).mk();
    var formulae = new Formulae(control).mk();
    Ui.QQ("body").next().removeAll().add(Q("table").klass("main")
      .add(Q("tr").add(Q("td").att("colspan", 6).add(title)))
      .add(Q("tr").add(Q("td").att("colspan", 6).html("<hr>")))
      .add(Q("tr")
        .add(Q("td"))
        .add(Q("td").add(precode.mkButtons()))
        .addIt(It.from(buttons))
        .add(Q("td")))
      .add(Q("tr")
        .add(Q("td").att("rowspan", 2).style("vertical-align:top;width:5px;")
          .add(menu))
        .add(Q("td").style("text-align:center;vertical-align:top;width:10px;")
          .add(precode.mkCode()))
        .addIt(It.from(formulae))
        .add(Q("td")))
      .add(Q("tr")
        .add(Q("td").att("colspan", 5).style("vertical-align:top;")
          .add(viewer.mk())))
    );
  }

  public function showGallery() {
    var gallery = new Gallery(control);
    Ui.QQ("body").next().removeAll().add(Q("table").klass("main")
      .add(Q("tr").add(Q("td").add(title)))
      .add(Q("tr").add(Q("td").html("<hr>")))
      .add(Q("tr").add(Q("td").add(gallery.mkGoBack())))
      .add(Q("tr").add(Q("td").html("<hr>")))
      .add(Q("tr").add(Q("td").add(gallery.mk())))
      .add(Q("tr").add(Q("td").html("<hr>")))
    );
  }
}
