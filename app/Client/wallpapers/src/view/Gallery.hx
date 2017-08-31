/*
 * Copyright 06-Aug-2017 ºDeme
 * GNU General Public License - V3 <http://www.gnu.org/licenses/>
 */

package view;

import dm.Ui;
import dm.Ui.Q;
import dm.It;
import dm.I18n._;

class Gallery {
  var control:Control;

  public function new(control:Control) {
    this.control = control;
  }

  public function mkGoBack() {
    return Q("table").att("align", "center").add(Q("tr")
      .add(Q("td").klass("frame")
        .add(Ui.link(function (ev) { return control.run(); })
          .klass("link").html(_("Go back")))));
  }

  public function mk() {
    var map = GalleryAux.getData();

    function span() {
      return Q("span").style("padding-right:4px;padding-bottom:4px");
    }
    var entries = It.keys(map).map(function (k) {
      return Q("li")
        .html("<a href='#' onclick='return false;'>" + k + "</a>")
        .add(Q("ul").att("id", "hlist")
          .style("list-style:none;padding-left:20px;padding-top:8px;")
          .add(Q("li").add(Q("div")
            .addIt(It.from(map.get(k)).map(function (e) {
              var p = "stock/" + k + "/" + e;
              return span().add(Ui.link(function (ev) {
                  return control.getGallery(p);
                }).add(Q("img")
                  .klass("frame")
                  .att("src", p + ".png")));
            })
        ))));
      });

    return Q("div")
      .add(Q("ul").style("list-style:none;padding-left:0px;margin-top:0px;")
        .addIt(entries)
      );
  }
}
