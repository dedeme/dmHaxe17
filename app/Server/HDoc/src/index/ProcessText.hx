/*
 * Copyright 12-Mar-2017 ºDeme
 * GNU General Public License - V3 <http://www.gnu.org/licenses/>
 */

import dm.It;
import dm.Tuple;
using dm.Str;
import text.Util;

class ProcessText {
  public static function run(tx:String):String {
    function fmin(ixs, ix):Tp2<Int, Int> {
      var ixs = It.from(ixs).map(It.f(tx.indexOf(_1, ix))).to();
      var min = Util.min(ixs);
      return min == -1 ? new Tp2(-1, -1) : new Tp2(min, ixs[min]);
    }
    var ix = 0;
    var c = 0;
    while (true) {
      c += 1;
      var tp = fmin(["///", "/**", "\"", "'"], ix);
      if (c > 5000) throw ("ProcessText infinite loop 1\n");
      switch (tp._1) {
        case -1: return "";
        case 0: { // "///"
          ix = tp._2 + 3;
          var tp2 = fmin(["\n", ". ", ".<", ".\n"], ix);
          return Util.html(switch (tp2._1) {
            case -1: "";
            case 0: tx.substring(ix, tp2._2);
            case _: tx.substring(ix, tp2._2 + 1);
          });
        }
        case 1: { // "/**"
          ix += tp._2 + 3;
          var tp2 = fmin(["*/", ". ", ".<", ".\n"], ix);
          return Util.html((switch (tp2._1) {
            case -1: "";
            case 0: tx.substring(ix, tp2._2);
            case _: tx.substring(ix, tp2._2 + 1);
          }).replace(~/\n\s*\*/g, " "));
        }
        case 2: { // '"'
          ix = tp._2 + 1;
          while (true) {
            c += 1;
            if (c > 5000) throw ("ProcessText infinite loop 2");
            var tp2 = fmin(["\\\"", "\""], ix);
            switch (tp2._1) {
              case -1: return "";
              case 0: ix = tp2._2 + 2;
              case 1: {
                ix = tp2._2 + 1;
                break;
              }
            }
          }
        }
        case 3: { // "'"
          ix = tp._2 + 1;
          while (true) {
            c += 1;
            if (c > 5000) throw ("ProcessText infinite loop 3");
            var tp2 = fmin(["\\'", "'"], ix);
            switch (tp2._1) {
              case -1: return "";
              case 0: ix = tp2._2 + 2;
              case 1: {
                ix = tp2._2 + 1;
                break;
              }
            }
          }
        }
      }
    }
  }
}
