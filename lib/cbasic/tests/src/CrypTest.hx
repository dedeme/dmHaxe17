/*
 * Copyright 04-Mar-2016 ºDeme
 * GNU General Public License - V3 <http://www.gnu.org/licenses/>
 */

import haxe.io.Bytes;
import dm.Test;
import dm.It;
import dm.Cryp;
import dm.Tuple;

class CrypTest {
  public static function run () {
    var t = new Test("Cryp");

    t.eq(Cryp.key("deme", 6), "wiWTB9");
    t.eq(Cryp.genK(12).length, 12);
    t.eq(Cryp.cryp("deme", "Cañón€%ç"), "v12ftuzYeq2Xz7q7tLe8tNnHtqY=");
    t.eq(Cryp.decryp("deme", Cryp.cryp("deme", "Cañón€%ç")), "Cañón€%ç");
    t.eq(Cryp.decryp("deme", Cryp.cryp("deme", "1")), "1");
    t.eq(Cryp.decryp("deme", Cryp.cryp("deme", "")), "");
    t.eq(Cryp.decryp("", Cryp.cryp("", "Cañón€%ç")), "Cañón€%ç");
    t.eq(Cryp.decryp("", Cryp.cryp("", "1")), "1");
    t.eq(Cryp.decryp("", Cryp.cryp("", "")), "");

    t.eq(6, Cryp.genK(6).length);
    t.eq(Cryp.key("Generaro", 5), "Ixy8I");
    t.eq(Cryp.key("Generara", 5), "0DIih");

    t.eq(Cryp.decryp("abc", Cryp.cryp("abc", "01")), "01");
    t.eq(Cryp.decryp("abcd", Cryp.cryp("abcd", "11")), "11");
    t.eq(Cryp.decryp("abc", Cryp.cryp("abc", "")), "");
    t.eq(Cryp.decryp("c", Cryp.cryp("c", "a")), "a");
    t.eq(Cryp.decryp("xxx", Cryp.cryp("xxx", "ab c")), "ab c");
    t.eq(Cryp.decryp("abc", Cryp.cryp("abc", "\n\ta€b c")), "\n\ta€b c");

    t.log();
  }
}
