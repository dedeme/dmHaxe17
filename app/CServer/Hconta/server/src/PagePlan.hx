/*
 * Copyright 06-Jul-2017 ºDeme
 * GNU General Public License - V3 <http://www.gnu.org/licenses/>
 */

/// Plan page
class PagePlan {
  /// Main page response
  public static function response(
    rq:Map<String, Dynamic>
  ):Map<String, Dynamic> {
    return Db.confRead();
  }
}

