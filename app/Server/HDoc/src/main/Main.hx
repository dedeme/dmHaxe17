/*
 * Copyright 05-Mar-2017 ºDeme
 * GNU General Public License - V3 <http://www.gnu.org/licenses/>
 */

import Global;

/// Entry class
class Main {
  /// Entry point
  public static function main() {
    var client = Global.client();
    client.send("main/index.js", "pagePath", {}, function (path:String) {
      if (path == "") {
        js.Browser.location.assign("../conf/index.html");
      } else {
        throw "Bad page path.";
      }
    });
  }
}
