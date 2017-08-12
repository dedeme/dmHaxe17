/*
 * Copyright 09-Jul-2017 ºDeme
 * GNU General Public License - V3 <http://www.gnu.org/licenses/>
 */

package model;

using StringTools;

import dm.It;
import model.Dentry;
import dm.Json;

enum Action {
  Nop;
  AddSubgroup(id:String, name:String);
  AddAccount(id:String, name:String, summary:String);
  AddSubaccount(id:String, name:String);
  ModSubgroup(id:String, name:String);
  ModAccount(id:String, name:String, summary:String);
  ModSubaccount(id:String, name:String);
  DelSubgroup(id:String);
  DelAccount(id:String);
  DelSubaccount(id:String);
  AddDiary(entry:Dentry);
}

class Actions {

  public static function serialize(action:Action) {
    return switch (action) {
      case Nop: "";
      case AddSubgroup(id, name):
        return "SGA" + id + name;
      case AddAccount(id, name, summary):
        return "AA" + id + summary + ";" + name;
      case AddSubaccount(id, name):
        return "SAA" + id + name;
      case ModSubgroup(id, name):
        return "SGM" + id + name;
      case ModAccount(id, name, summary):
        return "AM" + id + summary + ";" + name;
      case ModSubaccount(id, name):
        return "SAM" + id + name;
      case DelSubgroup(id):
        return "SGD" + id;
      case DelAccount(id):
        return "AD" + id;
      case DelSubaccount(id):
        return "SAD" + id;
      case AddDiary(entry):
        return "DA" + Json.from(entry.serialize());

    };
  }

  public static function restore(serial:String):It<Action> {
    return It.from(serial.split("\n")).map(function (s) {
      if (s == "") {
        return Nop;
      } else if (s.startsWith("SGA")) {
        return AddSubgroup(s.substring(3, 5), s.substring(5, s.length));
      } else if (s.startsWith("AA")) {
        var ix = s.indexOf(";");
        return AddAccount(
          s.substring(2, 5),
          s.substring(ix + 1, s.length),
          s.substring(5, ix)
        );
      } else if (s.startsWith("SAA")) {
        return AddSubaccount(s.substring(3, 8), s.substring(8, s.length));
      } else if (s.startsWith("SGM")) {
        return ModSubgroup(s.substring(3, 5), s.substring(5, s.length));
      } else if (s.startsWith("AM")) {
        var ix = s.indexOf(";");
        return ModAccount(
          s.substring(2, 5),
          s.substring(ix + 1, s.length),
          s.substring(5, ix)
        );
      } else if (s.startsWith("SAM")) {
        return ModSubaccount(s.substring(3, 8), s.substring(8, s.length));
      } else if (s.startsWith("SGD")) {
        return DelSubgroup(s.substring(3, s.length));
      } else if (s.startsWith("AD")) {
        return DelAccount(s.substring(2, s.length));
      } else if (s.startsWith("SAD")) {
        return DelSubaccount(s.substring(3, s.length));
      } else if (s.startsWith("DA")) {
        return AddDiary(Dentry.restore(Json.to(s.substring(2, s.length))));
      } else {
        throw('$s: Uknown action');
      }
    });
  }

}
