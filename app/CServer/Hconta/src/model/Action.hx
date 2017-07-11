/*
 * Copyright 09-Jul-2017 ºDeme
 * GNU General Public License - V3 <http://www.gnu.org/licenses/>
 */

package model;

using StringTools;

import dm.It;

enum Action {
  Nop;
  AddSubgroup(id:String, name:String);
  AddAccount(id:String, name:String, summary:String);
  AddSubaccount(id:String, name:String);
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
          s.substring(5, ix),
          s.substring(ix + 1, s.length)
        );
      } else if (s.startsWith("SAA")) {
        return AddSubaccount(s.substring(3, 8), s.substring(8, s.length));
      } else {
        throw('$s: Uknown action');
      }
    });
  }

}
