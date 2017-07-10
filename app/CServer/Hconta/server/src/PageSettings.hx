/*
 * Copyright 06-Jul-2017 ºDeme
 * GNU General Public License - V3 <http://www.gnu.org/licenses/>
 */

import Db;

/// Settings page.<p>
/// Although this page include "change password", this option is processed
/// by dm.Cgi.
class PageSettings {
  /// Main page response
  public static function response(
    rq:Map<String, Dynamic>
  ):Map<String, Dynamic> {
    switch(rq.get("setting")) {
      case "lang": {
        Db.chageLang();
        return new Map();
      }
      case op:
        throw ('Setting option "$op" is unknown');
    }
  }
}

