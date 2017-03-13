/*
 * Copyright 04-Mar-2016 ºDeme7
 * GNU General Public License - V3 <http://www.gnu.org/licenses/>
 */

import dm.Test;
import dm.It;
using dm.Tuple;

class ItTest {
  public static function run () {
    // Constructors --------------------
    var t = new Test("It : constructors");

    var i0 = [];
    var i1 = [1];
    var i2 = [1, 2, 3];
    var s0 = [];
    var s1 = ["one"];
    var s2 = ["one", "two", "three"];

    t.yes (It.from(i0).eq(It.from(i0)));
    t.yes (!It.from(i0).eq(It.from(i1)));
    t.yes (It.from(i1).eq(It.from(i1)));
    t.yes (!It.from(i1).eq(It.from(i0)));
    t.yes (It.from(i2).eq(It.from(i2)));
    t.yes (!It.from(i2).eq(It.from(i1)));
    t.yes (!It.from(i1).eq(It.from(i2)));

//    t.yes (!It.from(i0).eq(It.from(s0)));

    t.eq ("[]", It.from(i0).toString());
    t.eq ("[1]", It.from(i1).toString());
    t.eq ("[1, 2, 3]", It.from(i2).toString());

    t.eq ("", It.from(i0).to().toString());
    t.eq ("1", It.from(i1).to().toString());
    t.eq ("1,2,3", It.from(i2).to().toString());

    t.eq ("[]", It.fromStr("").toString());
    t.eq ("[a]", It.fromStr("a").toString());
    t.eq ("[a, b, c]", It.fromStr("abc").toString());

    t.eq ("[]", It.keys(new Map<String, Int>()).toString());
    var itMap = It.keys(["one"=>1, "two"=>2]);
    t.eq ("one", itMap.next().toString());
    t.eq ("two", itMap.next().toString());
    t.yes (!itMap.hasNext());

    t.log();

    // Lazy ----------------------------
    var t = new Test("It : lazy");

    t.eq("[1]", It.from(i0).add(1).toString());
    t.eq("[1]", It.from(i0).add0(1).toString());
    t.eq("[1, 2, 3, 1]", It.from(i2).add(1).toString());
    t.eq("[1, 1, 2, 3]", It.from(i2).add0(1).toString());
    t.eq("[1, 1, 2, 3]", It.from(i2).add(1, 1).toString());
    t.eq("[1, 2, 3, 1]", It.from(i2).addIt(It.from(i1)).toString());
    t.eq("[1, 1, 2, 3]", It.from(i2).addIt(It.from(i1), 1).toString());
    t.eq("[1, 2, 3]", It.from(i2).addIt(It.from(i0)).toString());
    t.eq("[1, 2, 3]", It.from(i2).addIt(It.from(i0), 1).toString());
    t.eq("[]", It.from(i0).addIt(It.from(i0)).toString());
    t.eq("[1, 2, 3]", It.from(i0).addIt(It.from(i2), 1).toString());

    t.eq("[1]", It.empty().add(1).toString());
    t.eq("[1]", It.empty().add0(1).toString());
    t.eq("[]", It.empty().addIt(It.from(i0)).toString());
    t.eq("[1, 2, 3]", It.empty().addIt(It.from(i2), 1).toString());

    var pr1 = function  (e) { return e < 2; };

    t.eq("[one, two, three]", It.from(s2).drop(0).toString());
    t.eq("[two, three]", It.from(s2).drop(1).toString());
    t.eq("[]", It.from(s2).drop(10).toString());
    t.eq("[1, 2, 3]", It.from(i2).drop(0).toString());
    t.eq("[]", It.from(i0).dropWhile(pr1).toString());
    t.eq("[]", It.from(i1).dropWhile(pr1).toString());
    t.eq("[2, 3]", It.from(i2).dropWhile(pr1).toString());

    var even = function  (e) { return e % 2 == 0; };
    var neven = function  (e) { return e % 2 != 0; };

    t.eq ("[]", It.from(i0).filter(even).toString());
    t.eq ("[]", It.from(i1).filter(even).toString());
    t.eq ("[2]", It.from(i2).filter(even).toString());
    t.eq ("[]", It.from(i0).filter(neven).toString());
    t.eq ("[1]", It.from(i1).filter(neven).toString());
    t.eq ("[1, 3]", It.from(i2).filter(neven).toString());

    var mul2 = function  (e) { return e * 2; };

    t.eq("[]", It.from(i0).map(mul2).toString());
    t.eq("[2]", It.from(i1).map(mul2).toString());
    t.eq("[2, 4, 6]", It.from(i2).map(mul2).toString());

    t.eq("[]", It.from(s2).take(0).toString());
    t.eq("[one]", It.from(s2).take(1).toString());
    t.eq("[one, two, three]", It.from(s2).take(10).toString());
    t.eq("[1, 2, 3]", It.from(i2).take(1000).toString());
    t.eq("[]", It.from(i0).takeWhile(pr1).toString());
    t.eq("[1]", It.from(i1).takeWhile(pr1).toString());
    t.eq("[1]", It.from(i2).takeWhile(pr1).toString());

    t.log();

    // Progresive ----------------------
    var t = new Test("It : progresive");

    var ftrue = function (e) { return true; };
    var feq = function (a) { return function (e) { return a == e; }; };

    t.yes(It.from(i0).all(feq(1)));
    t.yes(It.from(i1).all(feq(1)));
    t.yes(!It.from(i2).all(feq(1)));
    t.yes(!It.from(i0).any(feq(1)));
    t.yes(It.from(i2).any(feq(1)));
    t.yes(!It.from(i2).any(feq(9)));

    t.eq(0, It.from(s0).count(ftrue));
    t.eq(1, It.from(s1).count(ftrue));
    t.eq(3, It.from(s2).count(ftrue));

    t.eq(0, It.from(i0).finds(even).length);
    t.eq(0, It.from(i1).finds(even).length);
    t.eq(2, It.from(i2).finds(even)[0]);
    t.eq(0, It.from(i0).finds(neven).length);
    t.eq(1, It.from(i1).finds(neven)[0]);
    t.eq(1, It.from(i2).finds(neven)[0]);

    t.eq(null, It.from(i0).find(even));
    t.eq(null, It.from(i1).find(even));
    t.eq(2, It.from(i2).find(even));
    t.eq(null, It.from(i0).find(neven));
    t.eq(1, It.from(i1).find(neven));
    t.eq(1, It.from(i2).find(neven));

    t.eq(null, It.from(i0).findLast(even));
    t.eq(null, It.from(i1).findLast(even));
    t.eq(2, It.from(i2).findLast(even));
    t.eq(null, It.from(i0).findLast(neven));
    t.eq(1, It.from(i1).findLast(neven));
    t.eq(3, It.from(i2).findLast(neven));

    t.eq(-1, It.from(i0).indexf(even));
    t.eq(-1, It.from(i1).indexf(even));
    t.eq(1, It.from(i2).indexf(even));
    t.eq(-1, It.from(i0).indexf(neven));
    t.eq(0, It.from(i1).indexf(neven));
    t.eq(0, It.from(i2).indexf(neven));

    t.eq(-1, It.from(i0).index(3));
    t.eq(-1, It.from(i1).index(3));
    t.eq(0, It.from(i1).index(1));
    t.eq(-1, It.from(i2).index(5));
    t.eq(0, It.from(i2).index(1));
    t.eq(2, It.from(i2).index(3));

    t.eq(-1, It.from(i0).lastIndexf(even));
    t.eq(-1, It.from(i1).lastIndexf(even));
    t.eq(1, It.from(i2).lastIndexf(even));
    t.eq(-1, It.from(i0).lastIndexf(neven));
    t.eq(0, It.from(i1).lastIndexf(neven));
    t.eq(2, It.from(i2).lastIndexf(neven));

    t.eq(-1, It.from(i0).lastIndex(3));
    t.eq(-1, It.from(i1).lastIndex(3));
    t.eq(0, It.from(i1).lastIndex(1));
    t.eq(-1, It.from(i2).lastIndex(5));
    t.eq(0, It.from(i2).lastIndex(1));
    t.eq(2, It.from(i2).lastIndex(3));

    t.log();

    // In block ------------------------
    var t = new Test("It : in block");

    var ficp = function (a:Int, b) { return a - b; };

    var tpS = It.from(s0).duplicate();
    t.yes(It.from(s0).eq(tpS._1));
    t.yes(It.from(s0).eq(tpS._2));
    tpS = It.from(s1).duplicate();
    t.yes(It.from(s1).eq(tpS._1));
    t.yes(It.from(s1).eq(tpS._2));
    tpS = It.from(s2).duplicate();
    t.yes(It.from(s2).eq(tpS._1));
    t.yes(It.from(s2).eq(tpS._2));

    t.eq("[]", It.from(i0).reverse().toString());
    t.eq("[1]", It.from(i1).reverse().toString());
    t.eq("[3, 2, 1]", It.from(i2).reverse().toString());

    t.eq("[]", It.sortStr(It.from(s0)).toString());
    t.eq("[one]", It.from(s1).reverse().toString());
    t.eq("[three, two, one]", It.from(s2).reverse().toString());

    t.eq("[]", It.sortStr(It.from(s0)).toString());
    t.eq("[1]", It.from(i1).sort(ficp).toString());
    t.eq("[1, 2, 3]"
    , It.from(i2).sort(ficp).reverse().sort(ficp).toString());

    var arr = (["pérez", "pera", "p zarra", "pizarra"]);
    var arr2 = It.sortStr(It.from(arr)).to();
    t.eq(["p zarra", "pera", "pizarra", "pérez"].toString(), arr2.toString());

    arr2 = It.sortStrLocale(It.from(arr)).to();
    t.eq(["p zarra", "pera", "pérez", "pizarra"].toString(), arr2.toString());

    t.eq("[]", It.from(s0).shuffle().toString());

    t.log();

    // Static constructors -------------
    var t = new Test("It : static constructors");

    t.eq("[0, 1, 2, 3, 4]", It.range(5).toString());
    t.eq("[2, 3, 4]", It.range(2, 5).toString());
    t.eq("[]", It.range(0).toString());
    t.eq("[]", It.range(2, 2).toString());

    t.eq("[]", It.zip(It.from(s0), It.from(s2)).toString());
    t.eq("[{\n\t_1 : one, \n\t_2 : one\n}]"
    , It.zip(It.from(s1), It.from(s2)).toString()
    );
    t.eq("[{\n\t_1 : 1, \n\t_2 : one\n}]"
    , It.zip(It.from(i1), It.from(s2)).toString())
    ;
    t.eq("[{\n\t_1 : 1, \n\t_2 : 1\n}, {"
      + "\n\t_1 : 2, \n\t_2 : 2\n}, {"
      + "\n\t_1 : 3, \n\t_2 : 3\n}]"
    , It.zip(It.from(i2), It.from(i2)).toString()
    );

    t.eq("[]", It.flat(
      It.from ([[]]).map(function (e) { return It.from(e); })
    ).toString());
    t.eq("[]", It.flat(
      It.from ([[],[],[]]).map(function (e) { return It.from(e); })
    ).toString());
    t.eq("[1, 3, 2, 1]", It.flat(
      It.from ([[], [1], [3, 2, 1]]).map(function (e) { return It.from(e); })
    ).toString());

    t.eq("", It.join(It.flat(It.from ([]))));
    t.eq("", It.join(It.flatStr(It.from (["", "", ""]))));
    t.eq("acba", It.join(It.flatStr(It.from (["", "a", "cba"]))));

    var sum = 0;
    It.from(i0).each (function (e) { sum += e; });
    t.eq (0, sum);
    It.from(i1).each (function (e) { sum += e; });
    t.eq (1, sum);
    It.from(i2).each (function (e) { sum += e; });
    t.eq (7, sum);

    var sum2 = 0;
    sum = 0;
    It.from(i0).eachIx (function (e, ix) { sum += e; sum2 += ix;});
    t.eq (0, sum);
    t.eq (0, sum2);
    It.from(i1).eachIx (function (e, ix) { sum += e; sum2 += ix;});
    t.eq (1, sum);
    t.eq (0, sum2);
    It.from(i2).eachIx (function (e, ix) { sum += e; sum2 += ix;});
    t.eq (7, sum);
    t.eq (3, sum2);

    t.log();

    // Old tests -----------------------
    var t = new Test("It : old tests");

    var s0 : Array<String> = [];
    var s1 = ["one"];
    var s2 = ["one", "two", "three"];

    var i0 : Array<Int> = [];
    var i1 = [1];
    var i2 = [1, 2, 3];

    t.yes (It.from (s0).eq (It.empty ()));
    t.yes (It.from (i0).eq (It.empty ()));
    t.yes (It.from (s0).eq (It.from (s0)));
    t.yes (It.from (s1).eq (It.from (s1)));
    t.yes (It.from (s2).eq (It.from (s2)));
    t.yes (It.from (i0).eq (It.from (i0)));
    t.yes (It.from (i1).eq (It.from (i1)));
    t.yes (It.from (i2).eq (It.from (i2)));
    t.yes (!It.from (s1).eq (It.empty ()));
    t.yes (!It.from (s0).eq (It.from (s1)));
    t.yes (!It.from (s1).eq (It.from (s2)));

    // add, add0, addIt
    t.eq (It.from(s2).toString(), "[one, two, three]");
    t.eq (It.from(i1).toString(), "[1]");
    t.eq (It.from(i0).toString(), "[]");
    t.eq (It.from(i0).add (1).toString(), "[1]");
    t.eq (It.from(i0).add0 (1).toString(), "[1]");
    t.eq (It.from(i2).add (1).toString(), "[1, 2, 3, 1]");
    t.eq (It.from(i2).add0 (1).toString(), "[1, 1, 2, 3]");
    t.eq (
      It.from (s0).addIt (It.from (s1)).addIt (It.from (s2)).toString()
    , "[one, one, two, three]"
    );
    t.eq (It.from(i2).add (1).to().length, 4);
    t.eq (It.from(i2).add (1).toList ().length, 4);
    t.eq (It.from(It.from(i2).add0 (1).toList ()).toString(), "[1, 1, 2, 3]");

    // contains
    t.eq (It.from (i0).contains (1), false);
    t.eq (It.from (i2).contains (1), true);
    t.eq (It.from (i2).contains (9), false);

    // containsf
    t.eq (It.from (i0).containsf (function (n) { return n % 2 == 1; }), false);
    t.eq (It.from (i2).containsf (function (n) { return n % 2 == 1; }), true);
    t.eq (It.from (i2).containsf (function (n) { return n == 12; }), false);

    // count
    t.eq (It.from (i0).count (function (n) { return n < 2; }), 0);
    t.eq (It.from (i2).count (function (n) { return n % 2 == 0; }), 1);
    t.eq (It.from (i2).count (function (n) { return n % 2 == 1; }), 2);

    // eachIx
    var sum = 0;
    It.from (i0).eachIx (function (i, n) { sum += i * n; });
    t.eq (sum, 0);
    It.from (i2).eachIx (function (i, n) { sum += i * n; });
    t.eq (sum, 8);

    // drop
    t.eq (It.from(s2).drop (0).toString(), "[one, two, three]");
    var itS = It.from(s2);
    t.eq (itS.drop (1).toString(), "[two, three]");
    t.eq (It.from(s2).drop (10).toString(), "[]");
    t.eq (It.from(i2).drop (0).toString(), "[1, 2, 3]");

    // dropWhile
    t.eq (It.from (i0).dropWhile (function (n) {
      return n < 2;
    }).toString(), "[]");
    t.eq (It.from (i2).dropWhile (function (n) {
      return n < 2;
    }).toString(), "[2, 3]");
    t.eq (It.from (i2).dropWhile (function (n) {
      return n < 12;
    }).toString(), "[]");

    // dropUntil
    t.eq (It.from (i0).dropUntil (function (n) {
      return n > 2;
    }).toString(), "[]");
    t.eq (It.from (i2).dropUntil (function (n) {
      return n > 2;
    }).toString(), "[3]");
    t.eq (It.from (i2).dropUntil (function (n) {
      return n > 12;
    }).toString(), "[]");

    // insert
    t.eq (It.from (i0).insert (9, function (n) {
      return n > 1;
    }).toString(), "[9]");
    t.eq (It.from (i2).insert (9, function (n) {
      return n > -1;
    }).toString (), "[9, 1, 2, 3]");
    t.eq (It.from (i2).insert (9, function (n) {
      return n > 1;
    }).toString(), "[1, 9, 2, 3]");
    t.eq (It.from (i2).insert (9, function (n) {
      return n > 12;
    }).toString(), "[1, 2, 3, 9]");

    // insetIx
    t.eq (It.from (i0).insertIx (2, 9).toString(), "[9]");
    t.eq (It.from (i2).insertIx (-1, 9).toString (), "[9, 1, 2, 3]");
    t.eq (It.from (i2).insertIx (1, 9).toString (), "[1, 9, 2, 3]");
    t.eq (It.from (i2).insertIx (12, 9).toString (), "[1, 2, 3, 9]");

    // insetIt
    t.eq (It.from (i0).insertIt (2, It.from ([9])).toString (), "[9]");
    t.eq (It.from (i2).insertIt
      (-1, It.from ([9])).toString (), "[9, 1, 2, 3]");
    t.eq (It.from (i2).insertIt (1, It.from ([9])).toString (), "[1, 9, 2, 3]");
    t.eq (It.from (i2).insertIt
      (12, It.from ([9])).toString (), "[1, 2, 3, 9]");
    t.eq (It.from (i0).insertIt (2, It.from ([])).toString (), "[]");
    t.eq (It.from (i2).insertIt (-1, It.from ([])).toString (), "[1, 2, 3]");
    t.eq (It.from (i2).insertIt (1, It.from ([])).toString (), "[1, 2, 3]");
    t.eq (It.from (i2).insertIt (12, It.from ([])).toString (), "[1, 2, 3]");

    // each
    var sum = 0;
    It.from (i0).each (function (n) { sum += n; });
    t.eq (sum, 0);
    It.from (i2).each (function (n) { sum += n; });
    t.eq (sum, 6);

    // filter
    sum = 0;
    It.from (i0).filter (function (n) {
      return n % 2 == 1;
    }).each (function (n) { sum += n; });
    t.eq (sum, 0);
    It.from (i2).filter (function (n) {
      return n % 2 == 1;
    }).each (function (n) { sum += n; });
    t.eq (sum, 4);

    // finds
    t.eq (0, It.from (i0).finds(function (n) { return n % 2 == 1; }).length);
    t.eq (1, It.from (i2).finds(function (n) { return n % 2 == 1; })[0]);

    // find
    t.eq (null, It.from (i0).find(It.f(_1 % 2 == 1)));
    t.eq (1, It.from (i2).find(It.f(_1 % 2 == 1)));

    // findLast
    t.eq (null, It.from (i0).findLast(It.f(_1 % 2 == 1)));
    t.eq (3, It.from (i2).findLast (It.f(_1 % 2 == 1)));

    // folder
    t.eq (It.from (i0).reduce (0, function (r, n) {
      return r + n;
    }), 0);
    t.eq (It.from (i2).reduce (0, function (r, n) {
      return r + n;
    }), 6);

    // forAll
    t.yes (It.from (i0).all (function (n) { return n % 2 == 0; }));
    t.yes (!It.from (i2).all (function (n) { return n % 2 == 0; }));

    // forAny
    t.yes (!It.from (i0).any (function (n) { return n % 2 == 0; }));
    t.yes (It.from (i2).any (function (n) { return n % 2 == 0; }));

    // index
    t.eq (It.from (i0).index (1), -1);
    t.eq (It.from (i2).index (1), 0);
    t.eq (It.from (i2).index (9), -1);

    // indexf
    t.eq (It.from (i0).indexf (function (n) { return n % 2 == 1; }), -1);
    t.eq (It.from (i2).indexf (function (n) { return n % 2 == 1; }), 0);
    t.eq (It.from (i2).indexf (function (n) { return n == 12; }), -1);

    // index
    t.eq (It.from (i0).lastIndex (1), -1);
    t.eq (It.from (i2).add (1).lastIndex (1), 3);
    t.eq (It.from (i2).lastIndex (9), -1);

    // lastIndex
    t.eq (It.from (i0).lastIndexf (function (n) { return n % 2 == 1; }), -1);
    t.eq (It.from (i2).lastIndexf (function (n) { return n % 2 == 1; }), 2);
    t.eq (It.from (i2).lastIndexf (function (n) { return n == 12; }), -1);

    // map
    t.eq (It.from (i0).map (function (n) {
      return n * 2;
    }).toString(), "[]");
    t.eq (It.from (i2).map (function (n) {
      return n * 2;
    }).toString (), "[2, 4, 6]");

    // map2
    t.eq (It.from (i0).map2 (function (n) {
      return n * 3;
    }
    , function (n) {
      return n * 2;
    }).toString (), "[]");
    t.eq (It.from (i2).map2 (function (n) {
      return n * 3;
    }
    , function (n) {
      return n * 2;
    }).toString (), "[3, 4, 6]");

    // take
    t.eq (It.from(s2).take (0).toString (), "[]");
    var itS = It.from(s2);
    t.eq (itS.take (1).toString (), "[one]");
    t.eq (itS.toString (), "[two, three]");
    t.eq (It.from(s2).take (1).toString (), "[one]");
    t.eq (It.from(i2).take (20).toString (), "[1, 2, 3]");

    // takeWhile
    t.eq (It.from (i0).takeWhile (function (n) {
      return n < 2;
    }).toString (), "[]");
    t.eq (It.from (i2).takeWhile (function (n) {
      return n < 2;
    }).toString (), "[1]");
    t.eq (It.from (i2).takeWhile (function (n) {
      return n < 12;
    }).toString (), "[1, 2, 3]");

    // takeUntil
    t.eq (It.from (i0).takeUntil (function (n) {
      return n > 2;
    }).toString (), "[]");
    t.eq (It.from (i2).takeUntil (function (n) {
      return n > 2;
    }).toString (), "[1, 2]");
    t.eq (It.from (i2).takeUntil (function (n) {
      return n > 12;
    }).toString (), "[1, 2, 3]");

    // toList
    t.yes (It.from (s0).eq (It.from (It.from (s0).toList ())));
    t.yes (It.from (s1).eq (It.from (It.from (s1).toList ())));
    t.yes (It.from (s2).eq (It.from (It.from (s2).toList ())));
    t.yes (It.from (i0).eq (It.from (It.from (i0).toList ())));
    t.yes (It.from (i1).eq (It.from (It.from (i1).toList ())));
    t.yes (It.from (i2).eq (It.from (It.from (i2).toList ())));

    // empty
    t.yes (It.from (s0).eq (It.empty ()));
    t.yes (It.from (i0).eq (It.empty ()));

    // flat, flatBytes, flatStr, fromBytes, fromStr, toBytes
    var bs = It.toBytes (It.from (i2));
    t.eqs ([[bs.get(0), i2[0]], [bs.get(1), i2[1]], [bs.get(2), i2[2]]]);
    t.eq (It.fromBytes (bs).toString (), "[1, 2, 3]");

    var chs = It.toStr (It.fromStr ("abc"));
    t.eqs ([[chs.charAt(0), "a"], [chs.charAt(1), "b"], [chs.charAt(2), "c"]]);
    t.eq (It.fromStr ("abc").toString (), "[a, b, c]");

    var abs = [bs, bs];
    t.eq (It.flatBytes (It.from (abs)).toString (), "[1, 2, 3, 1, 2, 3]");
    var ast = ["abc", "de"];
    t.eq (It.flatStr (It.from (ast)).toString (), "[a, b, c, d, e]");

    // join
    t.eq (It.fromStr ("abc").toString (), "[a, b, c]");
    t.eq (It.join (It.fromStr ("abc"), ""), "abc");

    // range0, range, rangeStep
    t.eq (It.range (-1).toString(), "[]");
    t.eq (It.range (0).toString(), "[]");
    t.eq (It.range (2).toString(), "[0, 1]");
    t.eq (It.range (-1, -1).toString(), "[]");
    t.eq (It.range (0, -1).toString(), "[]");
    t.eq (It.range (0, 2).toString(), "[0, 1]");
    t.eq (It.range (-1, 1).toString(), "[-1, 0]");
    t.eq (It.range (-1, -1, 1).toString(), "[]");
    t.eq (It.range (0, -1, 1).toString(), "[]");
    t.eq (It.range (0, 2, 1).toString(), "[0, 1]");
    t.eq (It.range (-1, 1, 1).toString(), "[-1, 0]");
    t.eq (It.range (-1, -1, -1).toString(), "[]");
    t.eq (It.range (0, -1, -1).toString(), "[0]");
    t.eq (It.range (1, -2, -1).toString(), "[1, 0, -1]");
    t.eq (It.range (-1, 1, -1).toString(), "[]");
    t.eq (It.range (1, 2, 0).take (3).toString(), "[]");

    // size
    t.eq (It.from (s0).size (), 0);
    t.eq (It.from (s1).size (), 1);
    t.eq (It.from (s2).size (), 3);

// statics ----------------------------------------------------------

    // duplicate
    t.yess ([
      It.from (i0).duplicate()._1.eq(It.from (i0).duplicate()._2)
    , It.from (i1).duplicate()._1.eq(It.from (i1).duplicate()._2)
    , It.from (i2).duplicate()._1.eq(It.from (i2).duplicate()._2)
    ]);

    // reverse
    t.eq (It.from (i0).reverse().toString(), "[]");
    t.eq (It.from (i1).reverse().toString(), "[1]");
    t.eq (It.from (i2).reverse().toString(), "[3, 2, 1]");

    // sort, suffle
    t.eq (It.from ([2,3,1,2,2,1]).sort(function (e1, e2) {
      return e1 - e2;
    }).toString(), "[1, 1, 2, 2, 2, 3]");
    t.eq (It.from ([2,3,1,2,2,1]).sort(function (e1, e2) {
      return e2 - e1;
    }).toString(), "[3, 2, 2, 2, 1, 1]");
    t.eq (It.from ([]).sort(function (e1, e2) {
      return e1 - e2;
    }).toString(), "[]");
    t.eq (It.range (-1, 3).shuffle().sort(function (e1, e2) {
      return e1 - e2;
    }).toString(), "[-1, 0, 1, 2]");

    // zip / Unzip
    t.eq (It.zip (It.from (s0), It.from (s2)).toString(), "[]");
    t.eq (It.unzip (It.zip (It.from (s0), It.from (s2)))._1.toString(), "[]");
    t.eq (It.unzip (It.zip (It.from (s0), It.from (s2)))._2.toString(), "[]");
    t.eq (It.zip3 (It.from (s0), It.from (s1), It.from (s2)).toString(), "[]");
    t.eq (It.unzip3 (It.zip3 (It.from (s0), It.from (s2), It.from (s2))
    )._3.toString(), "[]");
    t.eq (It.zip (It.from (s1), It.from (s2)).toString ()
    , "[{\n\t_1 : one, \n\t_2 : one\n}]");
    t.eq (It.unzip(It.zip (It.from (s2), It.from (s2))
    )._1.toString(), "[one, two, three]");
    t.eq (It.unzip3(It.zip3 (It.from (s2), It.from (s2), It.from (s2))
    )._3.toString(), "[one, two, three]");

    t.log();
  }
}
