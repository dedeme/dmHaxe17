/*
 * Copyright 15-Mar-2017 ºDeme
 * GNU General Public License - V3 <http://www.gnu.org/licenses/>
 */

import dm.It;
import dm.Io;
import Fields;
import ModuleCm;

/// Entry class
class ModuleS {
  /// Function enumeration to avoid their removal
  public static function main() {
    var fs = [
      readFile
    ];
  }

  @:expose("readFile")
  /// Reads source code. If it is no possible to read code, it returns 'null'
  public static function readFile (data : String):String {
    var error:PageRp = {
      error : true, packs : [], selected: "", path: "", page : ""
    }
    var server = Global.server();

    return server.rp(data, function (path:String):PageRp {
      FnS.setConfPath("");
      if (path == null || path.indexOf("@") == -1) return error;

      var ix = path.indexOf("@");
      var pack = path.substring(0, ix);
      var rpath = path.substring(ix + 1);

      var paths:Array<PathsData> = FnS.getPaths().to();
      var root = It.from(paths).find(It.f(_1.name == pack));
      if (root == null) return error;

      var apath = root.path + "/" + rpath + ".hx";
      if (!FnS.isInRoot(apath)) {
        FnS.setConfPath("");
        return error;
      }

      try {
        FnS.setConfPath(path);
        return {
          error   : false,
          packs   : It.from(paths).map(It.f(_1.serialize())).to(),
          selected: pack,
          path    : rpath,
          page    : Io.read(apath)
        }
      } catch (e:Dynamic) {
        return error;
      }
    });
  }
}
