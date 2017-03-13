/*
 * Copyright 09-Mar-2017 ºDeme
 * GNU General Public License - V3 <http://www.gnu.org/licenses/>
 */

import dm.It;
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
  public static function getPaths(data : String):String {
    return Global.server().rp(data, function (rq):Array<Dynamic> {
      return FnS.getPaths().map(It.f(_1.serialize())).to();
    });
  }

  @:expose("getConf")
  ///
  public static function getConf(data:String):String {
    return Global.server().rp(data, function (rq):Array<Dynamic> {
      return ConfEntry.mkNoDb().read().map(It.f(_1.serialize())).to();
    });
  }

  @:expose("setConf")
  ///
  public static function setConf(data:Dynamic):String {
    return Global.server().rp(data, function (rq:Dynamic):String {
      var cf = ConfEntry.mkNoDb();
      cf.clear();
      cf.add(ConfEntry.restore(rq));
      return "";
    });
  }

  @:expose("getConfPaths")
  ///
  public static function getConfPaths(data:String):String {
    return Global.server().rp(data, function (path:String):Array<Dynamic> {
      var tconf = ConfEntry.mkNoDb();
      var vconf = tconf.read().next();
      tconf.clear();
      var ce = new ConfEntry(path, vconf.visible, vconf.lang);
      tconf.add(ce);
      return new ConfData(
        ce,
        FnS.getPaths().to()
      ).serialize();
    });
  }

  @:expose("readFile")
  ///
  public static function readFile(data:String):String {
    return Global.server().rp(data, function (rq:FileRq):FileRp {
      return FnS.isInRoot(rq.path) && Io.exists(rq.path)
        ? { error : false, code : Io.read(rq.path) }
        : { error : true, code : "" };
    });
  }

}
