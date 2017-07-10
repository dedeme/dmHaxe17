/*
 * Copyright 13-Mar-2016 ºDeme
 * GNU General Public License - V3 <http://www.gnu.org/licenses/>
 */

import dm.Test;
import dm.Ls;

class LsTest {
  public static function run () {
    // Constructors --------------------
    var t = new Test("Ls : constructors");

    var i0 = Ls.fromArray([]);
    var i1 = Ls.fromArray([1]);
    var i2 = Ls.fromArray([1, 2, 3]);
    var s0 = Ls.fromArray([]);
    var s1 = Ls.fromArray(["one"]);
    var s2 = Ls.fromArray(["one", "two", "three"]);

    t.yes (i0.eq(i0));
    t.yes (!i0.eq(i1));
    t.yes (i1.eq(i1));
    t.yes (!i1.eq(i0));
    t.yes (i2.eq(i2));
    t.yes (!i2.eq(i1));
    t.yes (!i1.eq(i2));

    t.eq (i0.toString(), "Ls:[]");
    t.eq (i1.toString(), "Ls:[1]");
    t.eq (i2.toString(), "Ls:[1,2,3]");

    t.eq (i0.toArray().toString(), "[]");
    t.eq (i1.toArray().toString(), "[1]");
    t.eq (i2.toArray().toString(), "[1,2,3]");

    t.log();

    // Lazy ----------------------------
    var t = new Test("Ls : lazy");

    t.eq(i2.add(i1).toString(), "Ls:[1,2,3,1]");
    t.eq(i2.add(i1, 1).toString(), "Ls:[1,1,2,3]");
    t.eq(i2.add(i0).toString(), "Ls:[1,2,3]");
    t.eq(i2.add(i0, 1).toString(), "Ls:[1,2,3]");
    t.eq(i0.add(i0).toString(), "Ls:[]");
    t.eq(i0.add(i2, 1).toString(), "Ls:[1,2,3]");

    t.eq(Ls.empty().add(i0).toString(), "Ls:[]");
    t.eq(Ls.empty().add(i2, 1).toString(), "Ls:[1,2,3]");

    var pr1 = function  (e) { return e < 2; };

    t.eq(s2.drop(0).toString(), "Ls:[one,two,three]");
    t.eq(s2.drop(1).toString(), "Ls:[two,three]");
    t.eq(s2.drop(10).toString(), "Ls:[]");
    t.eq(i2.drop(0).toString(), "Ls:[1,2,3]");

    var even = function  (e) { return e % 2 == 0; };
    var neven = function  (e) { return e % 2 != 0; };

    t.eq(i0.filter(even).toString(), "Ls:[]");
    t.eq(i1.filter(even).toString(), "Ls:[]");
    t.eq(i2.filter(even).toString(), "Ls:[2]");
    t.eq(i0.filter(neven).toString(), "Ls:[]");
    t.eq(i1.filter(neven).toString(), "Ls:[1]");
    t.eq(i2.filter(neven).toString(), "Ls:[1,3]");

    var mul2 = function  (e) { return e * 2; };

    t.eq(i0.map(mul2).toString(), "Ls:[]");
    t.eq(i1.map(mul2).toString(), "Ls:[2]");
    t.eq(i2.map(mul2).toString(), "Ls:[2,4,6]");

    t.eq(s2.take(0).toString(), "Ls:[]");
    t.eq(s2.take(1).toString(), "Ls:[one]");
    t.eq(s2.take(10).toString(), "Ls:[one,two,three]");
    t.eq(i2.take(1000).toString(), "Ls:[1,2,3]");

    t.log();

    // Progresive ----------------------
    var t = new Test("Ls : progresive");

    var ftrue = function (e) { return true; };
    var feq = function (a) { return function (e) { return a == e; }; };

    t.yes(i0.all(feq(1)));
    t.yes(i1.all(feq(1)));
    t.yes(!i2.all(feq(1)));
    t.yes(!i0.any(feq(1)));
    t.yes(i2.any(feq(1)));
    t.yes(!i2.any(feq(9)));

    t.eq(s0.count(ftrue), 0);
    t.eq(s1.count(ftrue), 1);
    t.eq(s2.count(ftrue), 3);

    t.eq(i0.finds(even).length, 0);
    t.eq(i1.finds(even).length, 0);
    t.eq(i2.finds(even)[0], 2);
    t.eq(i0.finds(neven).length, 0);
    t.eq(i1.finds(neven)[0], 1);
    t.eq(i2.finds(neven)[0], 1);

    t.eq(i0.find(even), null);
    t.eq(i1.find(even), null);
    t.eq(i2.find(even), 2);
    t.eq(i0.find(neven), null);
    t.eq(i1.find(neven), 1);
    t.eq(i2.find(neven), 1);

    t.eq(i0.findLast(even), null);
    t.eq(i1.findLast(even), null);
    t.eq(i2.findLast(even), 2);
    t.eq(i0.findLast(neven), null);
    t.eq(i1.findLast(neven), 1);
    t.eq(i2.findLast(neven), 3);

    t.eq(i0.indexf(even), -1);
    t.eq(i1.indexf(even), -1);
    t.eq(i2.indexf(even), 1);
    t.eq(i0.indexf(neven), -1);
    t.eq(i1.indexf(neven), 0);
    t.eq(i2.indexf(neven), 0);

    t.eq(i0.index(3), -1);
    t.eq(i1.index(3), -1);
    t.eq(i1.index(1), 0);
    t.eq(i2.index(5), -1);
    t.eq(i2.index(1), 0);
    t.eq(i2.index(3), 2);

    t.log();

    // In block ------------------------
    var t = new Test("Ls : in block");

    t.eq(i0.reverse().toString(), "Ls:[]");
    t.eq(i1.reverse().toString(), "Ls:[1]");
    t.eq(i2.reverse().toString(), "Ls:[3,2,1]");

    t.log();

    // Static constructors -------------
    var t = new Test("Ls : static constructors");

    t.eq(Ls.join(Ls.fromArray([]), "-"), "");
    t.eq(Ls.join(Ls.fromArray(["", "", ""]), "-"), "--");
    t.eq(Ls.join(Ls.fromArray(["", "a", "cba"]), "-"), "-a-cba");
    t.eq(Ls.join(Ls.fromArray([])), "");
    t.eq(Ls.join(Ls.fromArray(["", "", ""])), "");
    t.eq(Ls.join(Ls.fromArray(["", "a", "cba"])), "acba");

    var sum = 0;
    i0.each (function (e) { sum += e; });
    t.eq (sum, 0);
    i1.each (function (e) { sum += e; });
    t.eq (sum, 1);
    i2.each (function (e) { sum += e; });
    t.eq (sum, 7);

    var sum2 = 0;
    sum = 0;
    i0.eachIx (function (e, ix) { sum += e; sum2 += ix;});
    t.eq (sum, 0);
    t.eq (sum2, 0);
    i1.eachIx (function (e, ix) { sum += e; sum2 += ix;});
    t.eq (sum, 1);
    t.eq (sum2, 0);
    i2.eachIx (function (e, ix) { sum += e; sum2 += ix;});
    t.eq (sum, 7);
    t.eq (sum2, 3);

    t.log();

  }
}
