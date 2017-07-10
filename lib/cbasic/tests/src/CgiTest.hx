/*
 * Copyright 04-Jul-2017 ºDeme
 * GNU General Public License - V3 <http://www.gnu.org/licenses/>
 */

import dm.Test;
import dm.Cgi;
import dm.App;
import dm.Io;
using StringTools;

class CgiTest {
  public static function run () {
    var t = new Test("Cgi");

    App.init("CbasicTests/cgi");
    Cgi.init();

    t.eq(Cgi.app, "cgi");

    if (App.home.endsWith("/cgi")) {
      Io.del(App.home);
    }

    t.log();
  }
}
