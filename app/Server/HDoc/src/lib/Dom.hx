/*
 * Copyright 09-Mar-2017 ºDeme
 * GNU General Public License - V3 <http://www.gnu.org/licenses/>
 */

import dm.DomObject;
import dm.Ui;
import dm.Ui.Q;
import dm.It;
import dm.Client;
import Fields;

class Dom {
  ///
  public static var body(default, null) = Q("div");

  ///
  public static function show (
    client:Client, paths:Array<PathsData>, selected:String
  ) {
    Dom0.show(
      Q("table").att("class", "main")
        .add(Q("tr")
          .add(Q("td").add(mkMenu(client, paths, selected))))
        .add(Q("tr")
          .add(Q("td").add(Q("hr"))))
        .add(Q("tr")
          .add(Q("td").add(body))));
  }

  ///
  static function mkMenu (
    client:Client, paths:Array<PathsData>, selected:String
  ):DomObject {
    return
      Q("table").att("border", "0").att("width", "100%")
        .add(Q("tr")
          .add(Q("td")
            .add((selected == ""
              ? Q("a").att("class", "frame").att("href", "../conf/index.html")
              : Q("a").att("href", "../conf/index.html")
              )
              .add(img("asterisk").att("align", "top")))
            .addIt(
              It.from(paths).filter(function (r) {
                return r.visible;
              }).sort(function (r1, r2) {
                return dm.Str.compare(r1.name, r2.name);
              }).map(function (row) {
                var sourceName = row.name;
                return Q("span").text(" · ")
                  .add(
                    (selected == sourceName
                    ? Q("span").att("class", "frame")
                      .add(Q("a")
                        .att("href", "../index/index.html?" + sourceName)
                        .text(sourceName))
                    : Q("a").att("href", "../index/index.html?" + sourceName)
                      .text(sourceName)
                    )
                  );
              })))
          .add(Q("td").style("text-align:right;")
            .add(Ui.link(function (ev) {
                go("../logout/index.html");
              })
              .add(img("cross").att("align", "middle")))));
  }

  ///
  static public function img (name:String):DomObject {
    name = StringTools.endsWith(name, ".gif") ? name : name + ".png";
    return Q("img").att("src", "../img/" + name).att("border", "0");
  }

  ///
  static public function lightImg (name:String):DomObject {
    return img(name).att("style", "opacity:0.4");
  }

  ///
  static public function go (address:String) {
    js.Browser.location.assign(address);
  }
}
