/*
 * Copyright 05-Mar-2017 ºDeme
 * GNU General Public License - V3 <http://www.gnu.org/licenses/>
 */

import dm.Io;
import dm.NoDb;
import Fields;

/// Entry class
class MainS {
  static var server = Global.server();
  /// Function enumeration to avoid their removal
  public static function main() {
    var fs = [
      pagePath
    ];
  }
  @:expose("pagePath")
  /// Initialization function
  public static function pagePath (data : String):String {
    if (!Io.isDirectory(server.root)) {
      server.init();
      var conf = ConfEntry.mkNoDb();
      conf.add(new ConfEntry("", true, "en"));
      PathsEntry.mkNoDb();
    }
    return server.rp(data, function (d) {
      var conf = ConfEntry.mkNoDb();
      return conf.read().next().path;
    });
  }
}
