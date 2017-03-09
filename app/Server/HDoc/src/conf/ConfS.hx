/*
 * Copyright 09-Mar-2017 ºDeme
 * GNU General Public License - V3 <http://www.gnu.org/licenses/>
 */

import ConfCm;
import dm.Server;
import dm.Io;
import dm.It;
import dm.Json;
import Fields;

///
class ConfS {
  ///
  public static function main() {
    var fs = [
      add,
      sel,
      del,
      modify
    ];
  }

  @:expose("add")
  ///
  public static function add (data : String):String {
    return Global.server().rp(data, function (rq:AddRq):String {
      PathsEntry.mkNoDb().add(new PathsEntry(
        rq.name, rq.path, true
      ));
      return "";
    });
  }

  @:expose("sel")
  ///
  public static function sel (data:String):String {
    return Global.server().rp(data, function (rq:SelRq):String {
      PathsEntry.mkNoDb().modify(function (p:PathsEntry) {
        if (p.name == rq.name) {
          return new PathsEntry(p.name, p.path, rq.selected);
        }
        return p;
      });
      return "";
    });
  }

  @:expose("del")
  ///
  public static function del (data:String):String {
    return Global.server().rp(data, function (rq:DelRq):String {
      PathsEntry.mkNoDb().del(function (e:PathsEntry) {
        return e.name == rq.name;
      });
      return "";
    });
  }

  @:expose("modify")
  ///
  public static function modify (data:String):String {
    return Global.server().rp(data, function (rq:ModifyRq):String {
      PathsEntry.mkNoDb().modify(function (p:PathsEntry) {
        if (p.name == rq.oldName) {
          return new PathsEntry(rq.newName, rq.path, p.visible);
        }
        return p;
      });
      return "";
    });
  }
}
