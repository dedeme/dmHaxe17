/*
 * Copyright 04-Mar-2016 ºDeme
 * GNU General Public License - V3 <http://www.gnu.org/licenses/>
 */

import dm.Test;
import dm.DateDm;

class DateDmTest {
  public static function run () {
    var t = new Test("Date");

    var d1 = new DateDm(29, 2, 2013);
    var d2 = new DateDm(6, 3, 2013);
    var d3 = new DateDm(30, 4, 2013);

    t.yes(d1.eq(DateDm.fromEn("2-29-2013")));
    t.yes(d1.eq(DateDm.fromEn("2/29/2013")));
    t.yes(d2.eq(DateDm.fromEn("3-6-2013")));
    t.yes(d2.eq(DateDm.fromEn("3/6/2013")));

    t.yes(d1.add(5).eq(d2));
    t.yes(d2.eq(d3.add(-55)));
    t.eq(-5, d1.df(d2));
    t.eq(55, d3.df(d2));

    t.eq(d1.format("%%:%1, %d/%m/%y"), "%:V, 1/3/13");
    t.eq("%viernes%, 01/03/2013", d1.format("%%%A%%, %D/%M/%Y"));
    t.eq("abr, 30-abr-13", d3.format("%b, %d-%b-%y"));
    t.eq("Madrid, a 1 de marzo de 2013.",
      d1.format("Madrid, a %d de %B de %Y."));

    t.eq("20130301", d1.base());
    t.eq("20130306", d2.base());
    t.eq("20130430", d3.base());

    t.eq(1, d1.day ());
    t.eq(6, d2.day ());
    t.eq(30, d3.day ());
    t.eq(3, d1.month ());
    t.eq(3, d2.month ());
    t.eq(4, d3.month ());
    t.eq(2013, d1.year ());
    t.eq(2013, d2.year ());
    t.eq(2013, d3.year ());

    t.yes(DateDm.fromEu("1/3/2013").eq(d1));
    t.yes(DateDm.fromEu("1-3-2013").eq(d1));
    t.yes(DateDm.fromEu("01/3/2013").eq(d1));
    t.yes(DateDm.fromEu("1/03/2013").eq(d1));
    t.yes(DateDm.fromEu("01-03-2013").eq(d1));
    t.yes(DateDm.fromStr("20130301").eq(d1));
    t.yes(DateDm.fromDate(new Date(2013, 2, 1, 0, 0, 0)).eq(d1));

    t.yes(d1.eq(DateDm.restore(d1.serialize())));
    t.yes(d2.eq(DateDm.restore(d2.serialize())));
    t.yes(d3.eq(DateDm.restore(d3.serialize())));

    t.log();
  }
}
