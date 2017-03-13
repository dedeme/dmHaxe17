/*
 * Copyright 10-Mar-2017 ºDeme
 * GNU General Public License - V3 <http://www.gnu.org/licenses/>
 */

import dm.Io;
import dm.It;
import dm.B41;
import IndexCm;
import Fields;

/// Entry class
class IndexS {
  /// Function enumeration to avoid their removal
  public static function main() {
    var fs = [
      list
    ];
  }

  @:expose("list")
  /// Returns list of files and directories.
  public static function list (data : String):String {
    var server = Global.server();

    var indexPath = Io.cat([server.root, "data", "index"]);

    return server.rp(data, function (pack:String):ListRp {
      if (pack == null || pack.indexOf("@") != -1) {
        FnS.setConfPath("");
        return { error : true, packs : [], tree : [] }
      }

      var paths:Array<PathsData> = FnS.getPaths().to();
      var path = It.from(paths).find(It.f(_1.name == pack));
      if (path == null || !path.visible || !Io.isDirectory(path.path)) {
        FnS.setConfPath("");
        return { error : true, packs : [], tree : [] }
      }

      var indexDb = IndexEntry.mkNoDb(pack);
      var ie:It<IndexEntry> = indexDb.read();
      var ne = ie.hasNext()
          ? new IndexEntry(EntryMakerS.mk(path.path, ie.next().tree))
          : new IndexEntry(EntryMakerS.mkEmpty(path.path));
      indexDb.write(It.empty().add(ne));

      // Clears indexDb
      Io.dirNames(indexPath)
        .map(It.f(B41.decompress(_1)))
        .each(function (n) {
          if (!It.from(paths).containsf(It.f(_1.name == n)))
            Io.del(Io.cat([indexPath, B41.compress(n)]));
        });

      FnS.setConfPath(pack);
      return {
        error : false,
        packs : It.from(paths).map(It.f(_1.serialize())).to(),
        tree  : ne.serialize()
      };
    });
  }
}
