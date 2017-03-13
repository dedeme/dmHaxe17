/*
 * Copyright 10-Mar-2017 ºDeme
 * GNU General Public License - V3 <http://www.gnu.org/licenses/>
 */

import dm.Io;
import dm.It;
import Fields;

/// Server utilities
class FnS {

  public static function setConfPath(path:String) {
    var tconf = ConfEntry.mkNoDb();
    var vconf = tconf.read().next();
    tconf.clear();
    tconf.add(new ConfEntry(path, vconf.visible, vconf.lang));
  }

  /// Returns true if path starts with '/deme/dmHaxe17/'
  public static function isInRoot(path:String):Bool {
    var root = "/deme/dmHaxe17/";
    return StringTools.startsWith(path, root);
  }

  /// Returns an array with paths
  public static function getPaths():It<PathsData> {
    return PathsEntry.mkNoDb().read().map(function (e:PathsEntry) {
      var ex = FnS.isInRoot(e.path) && Io.exists(e.path);
      return new PathsData(e.name, e.path, e.visible && ex, ex);
    });
  }

}
