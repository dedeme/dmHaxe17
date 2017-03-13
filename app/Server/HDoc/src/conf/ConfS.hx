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
      PathsEntry.mkNoDb().modify(It.f(
        _1.name == rq.name
          ? new PathsEntry(_1.name, _1.path, rq.selected)
          : _1
      ));
      return "";
    });
  }

  @:expose("del")
  ///
  public static function del (data:String):String {
    return Global.server().rp(data, function (rq:DelRq):String {
      PathsEntry.mkNoDb().del(It.f(_1.name == rq.name));
      return "";
    });
  }

  @:expose("modify")
  ///
  public static function modify (data:String):String {
    return Global.server().rp(data, function (rq:ModifyRq):String {
      PathsEntry.mkNoDb().modify(It.f(
        _1.name == rq.oldName
          ? new PathsEntry(rq.newName, rq.path, _1.visible)
          : _1
      ));
      return "";
    });
  }
}
