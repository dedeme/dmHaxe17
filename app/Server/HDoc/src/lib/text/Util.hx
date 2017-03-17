/*
 * Copyright 13-Mar-2017 ºDeme
 * GNU General Public License - V3 <http://www.gnu.org/licenses/>
 */

/// Utilities to process text
package text;

import dm.It;
using dm.Str;

class Util {
  /// Returns the position with the least number different to -1. If all the
  /// numbers are -1 returns -1.
  public static function min(ns:Array<Int>):Int {
    var m = 200000;
    var r = -1;
    It.from(ns).eachIx(function (e, ix) {
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

  /// Returns left part of 's' when it is cut at the first ocurrence of any
  /// string in 'subs'.
  public static function leftMin(s:String, subs:Array<String>) {
    var ixs = It.from(subs).map(It.f(s.indexOf(_1))).to();
    var min = min(ixs);
    return min == -1 ? s : s.substring(0, ixs[min]);
  }

  /// Returns last word of 'tx'. 'tx' only use blank as separator.
  public static function lastWord(tx:String):String {
    tx = tx.trim();
    var ix = tx.lastIndexOf(" ");
    return ix == -1 ? tx : tx.substring(ix + 1);
  }

  /// Returns if 'tx' include 'word'. 'tx' only use blanks as separator.
  public static function existsWord(tx:String, word:String):Bool {
    tx = " " + tx + " ";
    var ix = tx.indexOf(" " + word + " ");
    return ix == -1 ? false : true;
  }

  /// Change symbols '&lt;' and '&amp,'
  public static function html(tx:String) {
    return tx.replace(~/&/g, "&amp;")
      .replace(~/</g, "&lt;")
      .trim();
  }
}
