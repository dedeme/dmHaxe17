/*
 * Copyright 09-Mar-2017 ºDeme
 * GNU General Public License - V3 <http://www.gnu.org/licenses/>
 */

import ChpassCm;

/// Entry class
class ChpassS {
  /// Function enumeration to avoid their removal
  public static function main() {
    var fs = [
      changePass
    ];
  }
  @:expose("changePass")
  /// Initialization function
  public static function changePass (data : String):String {
    var server = Global.server();
    return server.rp(data, function (rq:ChRq):ChRp {
      return { success : server.changePass(rq.user, rq.oldPass, rq.newPass) };
    });
  }
}
