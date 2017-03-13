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
  /// Reads page path
  public static function pagePath (data : String):String {
    if (!Io.isDirectory(server.root)) {
      server.init();
      var conf = ConfEntry.mkNoDb();
      conf.add(new ConfEntry("", true, "en"));
      PathsEntry.mkNoDb();
      Io.mkdir(Io.cat([server.root, "data", "index"]));
    }
    return server.rp(data, dm.It.f(ConfEntry.mkNoDb().read().next().path));
  }
}
