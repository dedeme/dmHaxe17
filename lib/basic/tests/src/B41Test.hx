/*
 * Copyright 04-Mar-2016 ºDeme
 * GNU General Public License - V3 <http://www.gnu.org/licenses/>
 */

import dm.Test;
import dm.B41;

class B41Test {
  public static function run () {
    var t = new Test("B41");

    t.eq("R", B41.n2b(B41.b2n("R")));
    t.eq("f", B41.n2b(B41.b2n("f")));
    t.eq("F", B41.n2b(B41.b2n("F")));
    t.eq(0, B41.b2n("R"));
    t.eq(14, B41.b2n("f"));
    t.eq(40, B41.b2n("F"));
    t.eq("R", B41.n2b(0));
    t.eq("f", B41.n2b(14));
    t.eq("F", B41.n2b(40));

    var s:String = "ARazrmona Gómez, Antonio (€)";
    t.eq("RSpRTRRTgRTFRTxRTsRTuRTtRTgRRxRSvRWDRTsRTkRTFRSURRxRSpRTt" +
      "RTzRTuRTtRToRTuRRxRRFVFRRSR", B41.encode(s));
    t.eq(s, B41.decode(B41.encode(s)));
    t.eq("RSp7RgFxsutgRRxRSvRWD2skFRSURRxRSp5tzutouRRxRRFVFRRSR",
      B41.compress(s));
    t.eq(s, B41.decompress(B41.compress(s)));

    var a:Array<Int> = [0, 23, 116, 225];
    t.eq("RRoixx", B41.encodeBytes(a));
    t.eq(a, B41.decodeBytes(B41.encodeBytes(a)));

    var a2:Array<Int> = [0, 23, 5, 116, 225];
    t.eq("RRoRzTWl", B41.encodeBytes(a2));
    t.eq(a2, B41.decodeBytes(B41.encodeBytes(a2)));


    t.log();
  }
}

