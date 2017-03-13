/*
 * Copyright 13-Mar-2017 ºDeme
 * GNU General Public License - V3 <http://www.gnu.org/licenses/>
 */

/// Utilities to process text
package text;

import dm.It;

class Util {
  /// Returns the position with the least number different to -1. If all the
  /// numbers are -1 returns -1.
  public static function min(ns:Array<Int>):Int {
    var m = 200000;
    var r = -1;
    It.from(ns).eachIx(function (ix, e) {
      if (r == -1) {
        if (e != -1) {
          m = e;
          r = ix;
        }
      } else if (e != -1 && e < m){
        m = e;
        r = ix;
      }
    });
    return r;
  }
}
