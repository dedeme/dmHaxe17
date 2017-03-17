/*
 * Copyright 05-Mar-2017 ºDeme
 * GNU General Public License - V3 <http://www.gnu.org/licenses/>
 */

/// Application entry
import dm.Ui;

/// Entry class
class Main {
  /// Entry point
  public static function main() {
    var client = Global.client();
    client.send("main/index.js", "pagePath", "", function (path:String) {
      if (path == "") {
        Dom.go("../conf/index.html");
      } else if (path.indexOf("@") == -1) {
        Dom.go("../index/index.html?" + path);
      } else {
        if (path.indexOf("&") == -1) {
          Dom.go("../module/index.html?" + path);
        } else {
          Dom.go("../code/index.html?" + path);
        }
      }
    });
  }
}
