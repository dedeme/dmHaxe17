/*
 * Copyright 04-Mar-2016 ºDeme7
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

    t.eq("0g", Cryp.s2b("a"));
    t.eq("a", Cryp.b2s(Cryp.s2b("a")));
    t.eq("1ghRRx0iRWBRWr", Cryp.s2b("ab cñç"));
    t.eq("ab cñç", Cryp.b2s(Cryp.s2b("ab cñç")));
    t.eq("RRbRRa0gVFR0hRRx0i", Cryp.s2b("\n\ta€b c"));
    t.eq("\n\ta€b c", Cryp.b2s(Cryp.s2b("\n\ta€b c")));
    t.eq(6, Cryp.genK(6).length);
    t.eq("WpYzY", Cryp.key("Generaro", 5));
    t.eq("VTlxr", Cryp.key("Generara", 5));

    t.eq("01", Cryp.decryp("abc", Cryp.cryp("abc", "01")));
    t.eq("11", Cryp.decryp("abcd", Cryp.cryp("abcd", "11")));
    t.eq("", Cryp.decryp("abc", Cryp.cryp("abc", "")));
    t.eq("a", Cryp.decryp("c", Cryp.cryp("c", "a")));
    t.eq("ab c", Cryp.decryp("xxx", Cryp.cryp("xxx", "ab c")));
    t.eq("\n\ta€b c", Cryp.decryp("abc", Cryp.cryp("abc", "\n\ta€b c")));

    t.eq("01", Cryp.autoDecryp(Cryp.autoCryp(8, "01")));
    t.eq("11", Cryp.autoDecryp(Cryp.autoCryp(4, "11")));
    t.eq("", Cryp.autoDecryp(Cryp.autoCryp(2, "")));
    t.eq("a", Cryp.autoDecryp(Cryp.autoCryp(8, "a")));
    t.eq("ab c", Cryp.autoDecryp(Cryp.autoCryp(4, "ab c")));
    t.eq("\n\ta€b c", Cryp.autoDecryp(Cryp.autoCryp(2, "\n\ta€b c")));

    t.eq("01", Cryp.decode("abc", Cryp.encode("abc", 2, "01")));
    t.eq("11", Cryp.decode("abcd", Cryp.encode("abcd", 1, "11")));
    t.eq("", Cryp.decode("abc", Cryp.encode("abc", 2, "")));
    t.eq("a", Cryp.decode("c", Cryp.encode("c", 6, "a")));
    t.eq("ab c", Cryp.decode("xxx", Cryp.encode("xxx", 40, "ab c")));
    t.eq("\n\ta€b c", Cryp.decode("abc", Cryp.encode("abc", 2, "\n\ta€b c")));

    t.eq("01", Cryp.u2s(Cryp.s2u("01")));
    t.eq("W", Cryp.s2u ("W"));
    t.eq (Cryp.u2s (Cryp.s2u ("W")), "W");
    t.eq("", Cryp.s2u (""));
    t.eq ("", Cryp.u2s (Cryp.s2u ("")));
    t.eq("ab", Cryp.s2u ("ab"));
    t.eq (Cryp.u2s (Cryp.s2u ("ab")), "ab");
    t.eq("ab%20c", Cryp.s2u ("ab c"));
    t.eq (Cryp.u2s (Cryp.s2u ("ab c")), "ab c");
    t.eq("%0A%09a%E2%82%ACb%20c", Cryp.s2u ("\n\ta€b c"));
    t.eq (Cryp.u2s (Cryp.s2u ("\n\ta€b c")), "\n\ta€b c");

    t.log();
  }
}
