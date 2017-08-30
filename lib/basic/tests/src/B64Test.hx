/*
 * Copyright 16-Aug-2017 ºDeme
 * GNU General Public License - V3 <http://www.gnu.org/licenses/>
 */

import dm.Test;
import dm.B64;

import dm.Cryp;

class B64Test {
  public static function run () {
    var t = new Test("B64 : B64");

    t.eq(B64.encode("Cañónç世界"), "Q2HDscOzbsOn5LiW55WM");
    t.eq(B64.encodeBytes(B64.decodeBytes("AQIDBA==")), "AQIDBA==");
    t.eq(B64.decode(B64.encode("Cañón")), "Cañón");

    t.log();
  }
}


