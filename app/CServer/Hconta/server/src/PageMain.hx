/*
 * Copyright 05-Jul-2017 ºDeme
 * GNU General Public License - V3 <http://www.gnu.org/licenses/>
 */

import Db;

/// Main page
class PageMain {
  /// Main page response
  public static function response(
    rq:Map<String, Dynamic>
  ):Map<String, Dynamic> {
    var r = Db.read();
    return r;
  }
}
