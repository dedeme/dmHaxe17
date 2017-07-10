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

    t.eq ("Ls:[]", i0.toString());
    t.eq ("Ls:[1]", i1.toString());
    t.eq ("Ls:[1,2,3]", i2.toString());

    t.eq ("", i0.toArray().toString());
    t.eq ("1", i1.toArray().toString());
    t.eq ("1,2,3", i2.toArray().toString());

    t.log();

    // Lazy ----------------------------
    var t = new Test("Ls : lazy");

    t.eq("Ls:[1,2,3,1]", i2.add(i1).toString());
    t.eq("Ls:[1,1,2,3]", i2.add(i1, 1).toString());
    t.eq("Ls:[1,2,3]", i2.add(i0).toString());
    t.eq("Ls:[1,2,3]", i2.add(i0, 1).toString());
    t.eq("Ls:[]", i0.add(i0).toString());
    t.eq("Ls:[1,2,3]", i0.add(i2, 1).toString());

    t.eq("Ls:[]", Ls.empty().add(i0).toString());
    t.eq("Ls:[1,2,3]", Ls.empty().add(i2, 1).toString());

    var pr1 = function  (e) { return e < 2; };

    t.eq("Ls:[one,two,three]", s2.drop(0).toString());
    t.eq("Ls:[two,three]", s2.drop(1).toString());
    t.eq("Ls:[]", s2.drop(10).toString());
    t.eq("Ls:[1,2,3]", i2.drop(0).toString());

    var even = function  (e) { return e % 2 == 0; };
    var neven = function  (e) { return e % 2 != 0; };

    t.eq ("Ls:[]", i0.filter(even).toString());
    t.eq ("Ls:[]", i1.filter(even).toString());
    t.eq ("Ls:[2]", i2.filter(even).toString());
    t.eq ("Ls:[]", i0.filter(neven).toString());
    t.eq ("Ls:[1]", i1.filter(neven).toString());
    t.eq ("Ls:[1,3]", i2.filter(neven).toString());

    var mul2 = function  (e) { return e * 2; };

    t.eq("Ls:[]", i0.map(mul2).toString());
    t.eq("Ls:[2]", i1.map(mul2).toString());
    t.eq("Ls:[2,4,6]", i2.map(mul2).toString());

    t.eq("Ls:[]", s2.take(0).toString());
    t.eq("Ls:[one]", s2.take(1).toString());
    t.eq("Ls:[one,two,three]", s2.take(10).toString());
    t.eq("Ls:[1,2,3]", i2.take(1000).toString());

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

    t.eq(0, s0.count(ftrue));
    t.eq(1, s1.count(ftrue));
    t.eq(3, s2.count(ftrue));

    t.eq(0, i0.finds(even).length);
    t.eq(0, i1.finds(even).length);
    t.eq(2, i2.finds(even)[0]);
    t.eq(0, i0.finds(neven).length);
    t.eq(1, i1.finds(neven)[0]);
    t.eq(1, i2.finds(neven)[0]);

    t.eq(null, i0.find(even));
    t.eq(null, i1.find(even));
    t.eq(2, i2.find(even));
    t.eq(null, i0.find(neven));
    t.eq(1, i1.find(neven));
    t.eq(1, i2.find(neven));

    t.eq(null, i0.findLast(even));
    t.eq(null, i1.findLast(even));
    t.eq(2, i2.findLast(even));
    t.eq(null, i0.findLast(neven));
    t.eq(1, i1.findLast(neven));
    t.eq(3, i2.findLast(neven));

    t.eq(-1, i0.indexf(even));
    t.eq(-1, i1.indexf(even));
    t.eq(1, i2.indexf(even));
    t.eq(-1, i0.indexf(neven));
    t.eq(0, i1.indexf(neven));
    t.eq(0, i2.indexf(neven));

    t.eq(-1, i0.index(3));
    t.eq(-1, i1.index(3));
    t.eq(0, i1.index(1));
    t.eq(-1, i2.index(5));
    t.eq(0, i2.index(1));
    t.eq(2, i2.index(3));

    t.log();

    // In block ------------------------
    var t = new Test("Ls : in block");

    t.eq("Ls:[]", i0.reverse().toString());
    t.eq("Ls:[1]", i1.reverse().toString());
    t.eq("Ls:[3,2,1]", i2.reverse().toString());

    t.log();

    // Static constructors -------------
    var t = new Test("Ls : static constructors");

    t.eq("", Ls.join(Ls.fromArray([]), "-"));
    t.eq("--", Ls.join(Ls.fromArray(["", "", ""]), "-"));
    t.eq("-a-cba", Ls.join(Ls.fromArray(["", "a", "cba"]), "-"));
    t.eq("", Ls.join(Ls.fromArray([])));
    t.eq("", Ls.join(Ls.fromArray(["", "", ""])));
    t.eq("acba", Ls.join(Ls.fromArray(["", "a", "cba"])));

    var sum = 0;
    i0.each (function (e) { sum += e; });
    t.eq (0, sum);
    i1.each (function (e) { sum += e; });
    t.eq (1, sum);
    i2.each (function (e) { sum += e; });
    t.eq (7, sum);

    var sum2 = 0;
    sum = 0;
    i0.eachIx (function (e, ix) { sum += e; sum2 += ix;});
    t.eq (0, sum);
    t.eq (0, sum2);
    i1.eachIx (function (e, ix) { sum += e; sum2 += ix;});
    t.eq (1, sum);
    t.eq (0, sum2);
    i2.eachIx (function (e, ix) { sum += e; sum2 += ix;});
    t.eq (7, sum);
    t.eq (3, sum2);

    t.log();

  }
}
