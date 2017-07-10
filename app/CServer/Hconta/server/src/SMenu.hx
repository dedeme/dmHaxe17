/*
 * Copyright 06-Jul-2017 ºDeme
 * GNU General Public License - V3 <http://www.gnu.org/licenses/>
 */

import Db;

/// Reads menu data
class SMenu {
  /// Menu response
  public static function response(
    rq:Map<String, Dynamic>
  ):Map<String, Dynamic> {
    return Db.setPage(rq.get("go"), "");
  }
}

