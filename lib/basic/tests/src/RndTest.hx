/*
 * Copyright 04-Mar-2016 ºDeme7
 * GNU General Public License - V3 <http://www.gnu.org/licenses/>
 */

import dm.Test;
import dm.Rnd;
import dm.It;
import dm.Tuple;

class RndTest {
  public static function run () {
    var t = new Test("Rnd");

    It.range(10).each(function (i) {
      t.yes(Rnd.i(4) >= 0 && Rnd.i(4) < 4);
    });

    It.range(10).each(function (i) {
      t.yes(
        Rnd.dec(2, 4, 0).value >= 0 && Rnd.dec(2, 4, 0).value <= 4
      );
    });

    It.range(10).each(function (i) {
      t.yes(
        Rnd.dec(0, 4, 8).value >= 4 && Rnd.dec(0, 4, 8).value <= 8
      );
    });

    var box = new Box(["a", "b", "c"]);
    var v = box.next();
    t.yes(v == "a" || v == "b" || v == "c");
    t.yes(box.box.length == 2);
    v = box.next();
    t.yes(v == "a" || v == "b" || v == "c");
    t.yes(box.box.length == 1);
    v = box.next();
    t.yes(v == "a" || v == "b" || v == "c");
    t.yes(box.box.length == 0);
    v = box.next();
    t.yes(v == "a" || v == "b" || v == "c");
    t.yes(box.box.length == 2);
    v = box.next();
    t.yes(v == "a" || v == "b" || v == "c");
    t.yes(box.box.length == 1);
    v = box.next();
    t.yes(v == "a" || v == "b" || v == "c");
    t.yes(box.box.length == 0);
    v = box.next();
    t.yes(v == "a" || v == "b" || v == "c");
    t.yes(box.box.length == 2);

    box = Rnd.mkBox([new Tp2("a", 2), new Tp2("b", 1)]);
    v = box.next();
    t.yes(v == "a" || v == "b");
    t.yes(box.box.length == 2);
    v = box.next();
    t.yes(v == "a" || v == "b");
    t.yes(box.box.length == 1);
    v = box.next();
    t.yes(v == "a" || v == "b");
    t.yes(box.box.length == 0);
    v = box.next();
    t.yes(v == "a" || v == "b");
    t.yes(box.box.length == 2);
    v = box.next();
    t.yes(v == "a" || v == "b");
    t.yes(box.box.length == 1);
    v = box.next();
    t.yes(v == "a" || v == "b");
    t.yes(box.box.length == 0);
    v = box.next();
    t.yes(v == "a" || v == "b");
    t.yes(box.box.length == 2);

    t.log();
  }
}
