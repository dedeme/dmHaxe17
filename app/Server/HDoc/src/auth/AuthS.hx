/*
 * Copyright 07-Mar-2017 ºDeme
 * GNU General Public License - V3 <http://www.gnu.org/licenses/>
 */

/// Entry class
class AuthS {
  /// Function enumeration to avoid their removal
  public static function main() {
    var fs = [
      authentication
    ];
  }
  @:expose("authentication")
  /// Initialization function
  public static function authentication (data : String):String {
    var server = Global.server();
    return server.authRp(data);
  }
}
