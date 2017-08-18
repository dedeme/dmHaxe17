/*
 * Copyright 16-Aug-2017 ºDeme
 * GNU General Public License - V3 <http://www.gnu.org/licenses/>
 */

import dm.Test;
import dm.B64;

class B64Test {
  public static function run () {
    var t = new Test("B64 : B64");

    t.eq(B64.encodeBytes(B64.decodeBytes("AQIDBA==")), "AQIDBA==");
    t.eq(B64.decode(B64.encode("Cañón")), "Cañón");
    t.log();

    // Encription --------------------------------
    t = new Test("B64 : Encription");

    t.eq(B64.key("deme", 6), "XPxE/l");
    t.eq(B64.genK(12).length, 12);
    t.eq(B64.cryp("deme", "Cañón€%ç"), "qYLAiaLPhKyauKOqw4bBu8TcjIU=");
    t.eq(B64.decryp("deme", B64.cryp("deme", "Cañón€%ç")), "Cañón€%ç");
    t.eq(B64.decryp("deme", B64.cryp("deme", "1")), "1");
    t.eq(B64.decryp("deme", B64.cryp("deme", "")), "");
    t.eq(B64.decryp("", B64.cryp("", "Cañón€%ç")), "Cañón€%ç");
    t.eq(B64.decryp("", B64.cryp("", "1")), "1");
    t.eq(B64.decryp("", B64.cryp("", "")), "");

    t.log();
  }
}


