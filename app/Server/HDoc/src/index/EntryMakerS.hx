/*
 * Copyright 12-Mar-2017 ºDeme
 * GNU General Public License - V3 <http://www.gnu.org/licenses/>
 */

import dm.It;
import dm.Io;
import Fields;

/// Make index
class EntryMakerS {

  static function mkIndexFile(path:String, ixf:IndexEnum):IndexEnum {
    switch (ixf) {
      case IndexFile(name, time, help) : {
        var f = Io.file(path);
        var lastModified = f.lastModified();
        if (lastModified > time) {
          return IndexFile(
            name, lastModified, ProcessText.run(Io.read(path)));
        }
        return ixf;
      }
      case _ : throw ("ixf must be IndexFile");
    }
  }

  public static function mkEmpty(path:String):IndexEnum {
    var name = Io.file(path).getName();
    if (Io.isDirectory(path)) {
      return IndexDir(
        name,
        Io.dirNames(path)
        .map(It.f(mkEmpty(Io.cat([path, _1]))))
        .filter(It.f(_1 != null)).to()
      );
    }
    if (StringTools.endsWith(name, ".hx")) {
      return mkIndexFile(
        path,
        IndexFile(name.substring(0, name.length - 3), 0, "")
      );
    }
    return null;
  }

  public static function mk(path:String, ie:IndexEnum):IndexEnum {
    switch(ie) {
      case IndexFile(name, time, help): {
        return mkIndexFile(path, ie);
      }
      case IndexDir(name, tree): {
        var ntree:Array<IndexEnum> = [];
        Io.dir(path).each(function (f) {
          var npath = Io.cat([path, f.name]);
          if (f.isDir) {
            var ienum = It.from(tree).find(It.f(
              switch(_1) {
                case IndexFile(_, _, _) : false;
                case IndexDir(name, _): name == f.name;
              }
            ));
            ntree.push(ienum == null
              ? mkEmpty(npath)
              : mk(npath, ienum)
            );
          } else if (StringTools.endsWith(f.name, ".hx")) {
            var ienum = It.from(tree).find(It.f(
              switch(_1) {
                case IndexFile(name, _, _) :
                  name == f.name.substring(0, f.name.length - 3);
                case IndexDir(_, _): false;
              }
            ));
            ntree.push(ienum == null
              ? mkEmpty(npath)
              : mkIndexFile(npath, ienum)
            );
          }
        });
        return IndexDir(
          name,
          ntree
        );
      }
    }
  }
}
