/*
 * Copyright 15-Mar-2017 ºDeme
 * GNU General Public License - V3 <http://www.gnu.org/licenses/>
 */

using dm.Str;

class ModuleModel {
  static function countBlanks(l:String):Int {
    var ix = 0;
    while (ix < l.length) {
      if (l.charAt(ix) > " ") return ix;
      ++ix;
    }
    return ix;
  }

  public static function mkHelp(tx:String):String {
    var r = new StringBuf();
    var blanks = -1;
    var preBlanks = -1;
    var isPre = false;
    for (l in tx.split("\n")) {
      var lblanks = countBlanks(l);
      if (blanks < 0) blanks = lblanks;

      if (lblanks > blanks) {
        if (!isPre) {
          r.add("<table><tr><td><pre>");
          preBlanks = lblanks;
          isPre = true;
          r.add(l.substring(lblanks));
        } else {
          r.add("\n" + "&nbsp;".repeat(lblanks - preBlanks) +
            l.substring(lblanks));
        }
      } else {
        if (isPre) {
          r.add("</pre></td></tr></table>");
          isPre = false;
        }
        r.add(l);
      }
    }
    if (isPre) r.add("</pre></td></tr></table>");
    return r.toString();
  }
}
