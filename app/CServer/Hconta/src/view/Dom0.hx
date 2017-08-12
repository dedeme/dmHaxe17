/*
 * Copyright 07-Mar-2017 ºDeme
 * GNU General Public License - V3 <http://www.gnu.org/licenses/>
 */

/// Root DOM
package view;

import dm.DomObject;
import dm.Ui;
import dm.Ui.Q;

class Dom0 {
  public static var appName: String;
  public static var version: String;

  public static function show(o:DomObject) {
    Ui.QQ("body").next().removeAll().add(
      Q("div")
        .add(o)
        .add(Q("p").html("&nbsp;"))
        .add(Q("hr"))
        .add(Q("table").klass("main")
          .add(Q("tr")
            .add(Q("td")
              .add(Q("a")
                .att("href", "doc/about.html")
                .att("target", "blank")
                .html("<small>Help & Credits</small>")))
            .add(Q("td")
              .style("text-align: right;font-size: 10px;" +
                "color:#808080;font-size:x-small;")
              .html('- © ºDeme. $appName ($version) -'))))
    );
  }

  /// Returns text width of a text of type "14px sans"
  public static function textWidth(tx:String):Int {
    var c = Q("canvas");
    var e:Dynamic = c.e;
    var ctx = e.getContext("2d");
    ctx.font = "14px sans";
    return ctx.measureText(tx).width;
  }

  /// Adjusts tx to 'px' pixels. Font family must be "14px sans"
  public static function textAdjust(tx:String, px:Int):String {
    if (textWidth(tx) < px) {
      return tx;
    }

    tx = tx.substring(0, tx.length - 3) + "...";
    while (textWidth(tx) >= px) {
      tx = tx.substring(0, tx.length - 4) + "...";
    }
    return tx;
  }
}
