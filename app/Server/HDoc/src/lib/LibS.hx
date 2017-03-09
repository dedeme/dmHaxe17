/*
 * Copyright 09-Mar-2017 ºDeme
 * GNU General Public License - V3 <http://www.gnu.org/licenses/>
 */

import dm.Server;
import dm.Io;
import dm.Json;
import Fields;

///
class LibS {
  ///
  public static function main() {
    var fs = [
      getPaths,
      getConf,
      setConf,
      getConfPaths,
      readFile
    ];
  }

  @:expose("getPaths")
  ///
  public static function getPaths (data : String):String {
    return Global.server().rp(data, function (rq):Array<Dynamic> {
      return PathsEntry.mkNoDb().read().map(function (e:PathsEntry) {
        var ex = Io.exists(e.path);
        return new PathsData(
          e.name, e.path, e.visible && ex, ex
        ).serialize();
      }).to();
    });
  }

  @:expose("getConf")
  ///
  public static function getConf (data:String):String {
    return Global.server().rp(data, function (rq):Array<Dynamic> {
      return ConfEntry.mkNoDb().read().map(function (e:ConfEntry) {
        return e.serialize();
      }).to();
    });
  }

  @:expose("setConf")
  ///
  public static function setConf (data:Dynamic):String {
    return Global.server().rp(data, function (rq:Dynamic):String {
      var cf = ConfEntry.mkNoDb();
      cf.del(function (e) { return true; });
      cf.add(ConfEntry.restore(rq));
      return "";
    });
  }

  @:expose("getConfPaths")
  ///
  public static function getConfPaths (data:String):String {
    return Global.server().rp(data, function (rq):Array<Dynamic> {
      return new ConfData(
        ConfEntry.mkNoDb().read().next(),
        PathsEntry.mkNoDb().read().map(function (e:PathsEntry) {
          var ex = Io.exists(e.path);
          return new PathsData(e.name, e.path, e.visible && ex, ex);
        }).to()
      ).serialize();
    });
  }

  @:expose("readFile")
  ///
  public static function readFile (data:String):String {
    return Global.server().rp(data, function (rq:FileRq):FileRp {
      return Io.exists(rq.path)
        ? { error : false, code : Io.read(rq.path) }
        : { error : true, code : "" };
    });
  }

}
