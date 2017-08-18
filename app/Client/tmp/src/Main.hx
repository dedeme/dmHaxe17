/*
 * Copyright 06-Aug-2017 ºDeme
 * GNU General Public License - V3 <http://www.gnu.org/licenses/>
 */

import js.html.Uint8Array;
import haxe.io.Bytes;
import haxe.io.BytesData;
import dm.B64;

class Main {
  public static function main() {
    trace(B64.encode("Now is the time for all good coders\nto learn Crystal"));
    trace(B64.decode("Tm93IGlzIHRoZSB0aW1lIGZvciBhbGwgZ29vZCBjb2RlcnMKdG8gbGVhcm4gQ3J5c3RhbA=="));

    var u8 = new Uint8Array([-23, 2, 3, 45896]);
    var code = B64.encodeBytes(Bytes.ofData(cast(u8)));
    trace(B64.encodeBytes(Bytes.ofData(cast(u8))));
    var bs:Dynamic = B64.decodeBytes("6QIDSA==");
    trace(u8);
    trace(bs.b);
  }
}
