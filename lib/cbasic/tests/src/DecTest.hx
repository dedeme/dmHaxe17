/*
 * Copyright 02-Jul-2017 ºDeme
 * GNU General Public License - V3 <http://www.gnu.org/licenses/>
 */

import dm.Test;
import dm.Dec;

class DecTest {
  public static function run () {
    var t = new Test("Dec");

    t.yes(new Dec().eq(new Dec(0)));
    t.yes(new Dec().eq(new Dec(0, 0)));

    t.yes(new Dec(-3.25, 2).eq(new Dec(-3.25499, 2)));
    t.eq(2, new Dec(-3.248, 2).scale);

    t.yes(new Dec(3.25, 2).eq(new Dec(3.245, 2)));
    t.eq(2, new Dec(3.245, 2).scale);

    t.yes(new Dec(0.).eq(new Dec(-0)));
    t.yes(new Dec(0.).eq(new Dec(-0.0)));
    t.yes(new Dec(0.).eq(new Dec(0.0)));
    t.yes(new Dec(0.).eq(new Dec(.0)));
    t.yes(new Dec(0.).eq(new Dec(-.0)));

    t.eq(1.28, new Dec(1.275, 2).value);
    t.eq(0.1, new Dec(0.09, 1).value);
    t.eq(1.27, new Dec(1.27499, 2).value);
    t.eq(new Dec(3216234125.124, 2).value, 3216234125.12);
    t.eq("3.216.234.125,12", new Dec(3216234125.124, 2).toEs());

    t.eq("0", new Dec().toString());
    t.eq("0", new Dec().toEs());

    t.eq("-3.25", new Dec(-3.25499, 2).toString());
    t.eq("-16234125.12", new Dec(-16234125.124, 2).toString());
    t.eq("3", new Dec(3.25499, 0).toString());
    t.eq("16234125", new Dec(16234125.124, 0).toString());
    t.eq("1.35",new Dec(1.345, 2).toString());

    t.eq("-3,25", new Dec(-3.25499, 2).toEs());
    t.eq("-16.234.125,12", new Dec(-16234125.124, 2).toEs());
    t.eq("3", new Dec(3.25499, 0).toEs());
    t.eq("16.234.125", new Dec(16234125.124, 0).toEs());
    t.eq("16.234.125,10", new Dec(16234125.1, 2).toEs());
    t.eq("16.234.125,00", new Dec(16234125, 2).toEs());

    t.eq(-3.25, Dec.newStr("-3.25499", 2).value);
    t.eq(-16234125.12, Dec.newStr("-16234125.124", 2).value);
    t.eq(3., Dec.newStr("3.25499", 0).value);
    t.eq(16234125., Dec.newStr("16234125.124", 0).value);
    t.eq("3.424.362,76",
      new Dec(
        new Dec(25713.54, 2).value/new Dec(0.007509, 8).value, 2)
        .toEs());

    t.yes(new Dec(0.).eqValue(Dec.newStr(".0", 2)));
    t.yes(new Dec(0.).eqValue(Dec.newEu(",0", 2)));

    t.eq(-3.25, Dec.newStr("-3.25499", 2).value);
    t.eq(-16234125.12, Dec.newEu("-16.234.125,124", 2).value);
    t.eq(3., Dec.newStr("3.25499", 0).value);
    t.eq(16234125., Dec.newEu("16.234.125,124", 0).value);
    t.eq(16234125.1, Dec.newEu("16.234.125,10", 2).value);
    t.eq(16234125., Dec.newEu("16.234.125,00", 2).value);

    t.eq(-3.25, Dec.newEn("-3.25499", 2).value);
    t.eq(-16234125.12, Dec.newEn("-16,234,125.124", 2).value);
    t.eq(3., Dec.newEn("3.25499", 0).value);
    t.eq(16234125., Dec.newEn("16,234,125.124", 0).value);
    t.eq(16234125.1, Dec.newEn("16,234,125.10", 2).value);
    t.eq(16234125., Dec.newEn("16,234,125.00", 2).value);

    t.yes(Dec.rndInt(-3, -2) >= -3);
    t.yes(Dec.rndInt(-3, -2) <= -2);
    t.yes(Dec.rndInt(3, 2) >= 2);
    t.yes(Dec.rndInt(3, 2) <= 3);

    t.yes(Dec.rndInt(-3, -1) >= -3);
    t.yes(Dec.rndInt(-3, -1) <= -1);
    t.yes(Dec.rndInt(3, 1) >= 1);
    t.yes(Dec.rndInt(3, 1) <= 3);

    t.yes(new Dec().eq(Dec.restore(new Dec().serialize())));
    t.yes(new Dec(.0).eq(Dec.restore(new Dec(.0).serialize())));
    t.yes(new Dec(-0).eq(Dec.restore(new Dec(-0).serialize())));
    t.yes(new Dec(-3.25, 2).eq(
      Dec.restore(new Dec(-3.25, 2).serialize())
    ));
    t.yes(new Dec(3.25).eq(
      Dec.restore(new Dec(3.25).serialize())
    ));
    t.yes(new Dec(-16234125.12, 2).eq(
      Dec.restore(new Dec(-16234125.12, 2).serialize())
    ));
    t.yes(new Dec(16234125.12, 2).eq(
      Dec.restore(new Dec(16234125.12, 2).serialize())
    ));
    t.yes(new Dec(-16234125.12).eq(
      Dec.restore(new Dec(-16234125.12).serialize())
    ));

    t.log();

    // Old Dec -------------------------
    t = new Test("Dec-old");

    t.yes(new Dec(12.45, 1).eq(new Dec(12.5, 1)));
    t.yes(new Dec(12.44, 1).eq(new Dec(12.4, 1)));
    t.yes(new Dec(.45, 1).eq(new Dec(.5, 1)));
    t.yes(new Dec(.44, 1).eq(new Dec(.4, 1)));
    t.yes(new Dec(0.).eq(new Dec(-0)));
    t.yes(new Dec(0.).eq(new Dec(-0)));
    t.yes(new Dec(0.).eq(new Dec(-0)));
    t.yes(new Dec(0.).eq(new Dec(-0)));
    t.yes(new Dec(0.).eq(new Dec(-0)));
    t.yes(new Dec(0.).eq(new Dec(-0)));
    t.yes(new Dec(0.).eq(new Dec(-0)));
    t.yes(new Dec(0.).eq(new Dec(-0)));
    t.yes(new Dec(0.).eq(new Dec(-0)));
    t.yes(new Dec(0.).eq(new Dec(-0)));

    t.eq (new Dec (-12.45, 1).value, -12.5);
    t.eq (new Dec (-12.44, 1).value, -12.4);
    t.eq (new Dec (-.45, 1).value, -.5);
    t.eq (new Dec (-.44, 1).value, -.4);
    t.eq (new Dec (12.5, 0).value, 13.0);
    t.eq (new Dec (12.4, 0).value, 12.0);
    t.eq (new Dec (.5, 0).value, 1.0);
    t.yes(new Dec(.4, 0).eq(new Dec(0)));
    t.yes(new Dec(-0.0).eq(new Dec(0)));
    t.eq (new Dec (-.5, 0).value, -1.0);

    t.yes(new Dec(-.4, 0).eq(new Dec(0.0)));

    t.yess([
      new Dec(0, 0).eqValue(new Dec (-0, 0))
    , new Dec(0, 1).eqValue(new Dec (-0, 0))
    , new Dec(3.34, 0).eqValue(new Dec (3, 5))
    , new Dec(3.34, 1).eqValue(new Dec (3.3, 5))
    ]);

    t.yess([
      new Dec(0, 0).eq(new Dec (-0, 0))
    , !new Dec(0, 1).eq(new Dec (-0, 0))
    , !new Dec(3.34, 0).eq(new Dec (3, 5))
    , !new Dec(3.34, 1).eq(new Dec (3.3, 5))
    ]);

    t.eq (new Dec(0, 0).compare(new Dec (-0, 0)), 0);
    t.eq (new Dec(0, 1).compare(new Dec (-0, 0)), 0);
    t.eq (new Dec(3.34, 0).compare(new Dec (3, 5)), 0);
    t.eq (new Dec(3.34, 1).compare(new Dec (3.3, 5)), 0);
    t.yes (new Dec(1, 0).compare(new Dec (-0, 0)) > 0);
    t.yes (new Dec(-4, 0).compare(new Dec (-0, 0)) < 0);
    t.yes (new Dec(3.34, 0).compare(new Dec (2.99999, 5)) > 0);
    t.yes (new Dec(3.34, 1).compare(new Dec (3.30001, 5)) < 0);
    t.yes (new Dec(-3.34, 0).compare(new Dec (2.99999, 5)) < 0);
    t.yes (new Dec(3.34, 1).compare(new Dec (-3.30001, 5)) > 0);

    t.eq (new Dec (0, 0).toString (), "0");
    t.eq (new Dec (-0, 0).toString (), "0");
    t.eq (new Dec (0, 2).toString (), "0.00");
    t.eq (new Dec (-0, 2).toString (), "0.00");
    t.eq (new Dec (0.1, 2).toString (), "0.10");
    t.eq (new Dec (-0.1, 2).toString (), "-0.10");
    t.eq (new Dec (0.1, 0).toString (), "0");
    t.eq (new Dec (-0.1, 0).toString (), "0");
    t.eq (new Dec (3.112, 2).toString (), "3.11");
    t.eq (new Dec (-3.115, 2).toString (), "-3.12");
    t.eq (new Dec (3.112, 0).toString (), "3");
    t.eq (new Dec (3.115, 0).toString (), "3");

    t.eq (new Dec (0, 0).toEs (), "0");
    t.eq (new Dec (-0, 0).toEs (), "0");
    t.eq (new Dec (0, 2).toEs (), "0,00");
    t.eq (new Dec (-0, 2).toEs (), "0,00");
    t.eq (new Dec (0.1, 2).toEs (), "0,10");
    t.eq (new Dec (-0.1, 2).toEs (), "-0,10");
    t.eq (new Dec (0.1, 0).toEs (), "0");
    t.eq (new Dec (-0.1, 0).toEs (), "0");
    t.eq (new Dec (3.112, 2).toEs (), "3,11");
    t.eq (new Dec (-3.115, 2).toEs (), "-3,12");
    t.eq (new Dec (3.112, 0).toEs (), "3");
    t.eq (new Dec (3.115, 0).toEs (), "3");
    t.eq (new Dec (12233.112, 2).toEs (), "12.233,11");
    t.eq (new Dec (-12233.115, 2).toEs (), "-12.233,12");
    t.eq (new Dec (345112233.112, 0).toEs ()
    , "345.112.233");
    t.eq (new Dec (345112233.115, 0).toEs ()
    , "345.112.233");
    t.eq (new Dec (5112233.112, 2).toEs ()
    , "5.112.233,11");
    t.eq (new Dec (-5112233.115, 2).toEs ()
    , "-5.112.233,12");
    t.eq (new Dec (345112233.112, 0).toEs ()
    , "345.112.233");
    t.eq (new Dec (345112233.115, 0).toEs ()
    , "345.112.233");

    t.eq (new Dec (0, 0).toEn (), "0");
    t.eq (new Dec (-0, 0).toEn (), "0");
    t.eq (new Dec (0, 2).toEn (), "0.00");
    t.eq (new Dec (-0, 2).toEn (), "0.00");
    t.eq (new Dec (0.1, 2).toEn (), "0.10");
    t.eq (new Dec (-0.1, 2).toEn (), "-0.10");
    t.eq (new Dec (0.1, 0).toEn (), "0");
    t.eq (new Dec (-0.1, 0).toEn (), "0");
    t.eq (new Dec (3.112, 2).toEn (), "3.11");
    t.eq (new Dec (-3.115, 2).toEn (), "-3.12");
    t.eq (new Dec (3.112, 0).toEn (), "3");
    t.eq (new Dec (3.115, 0).toEn (), "3");
    t.eq (new Dec (12233.112, 2).toEn (), "12,233.11");
    t.eq (new Dec (-12233.115, 2).toEn (), "-12,233.12");
    t.eq (new Dec (345112233.112, 0).toEn ()
    , "345,112,233");
    t.eq (new Dec (345112233.115, 0).toEn ()
    , "345,112,233");
    t.eq (new Dec (5112233.112, 2).toEn ()
    , "5,112,233.11");
    t.eq (new Dec (-5112233.115, 2).toEn ()
    , "-5,112,233.12");
    t.eq (new Dec (345112233.112, 0).toEn ()
    , "345,112,233");
    t.eq (new Dec (345112233.115, 0).toEn ()
    , "345,112,233");

    t.eq(Std.parseFloat(" 0"), 0.0);
    t.eq (Std.parseFloat(" .0"), 0.);
    t.eq (Std.parseFloat(" 0."), 0.);
    t.eq (Std.parseFloat(" -0"), -0.);
    t.eq (Std.parseFloat(" +0."), 0.);
    t.eq (Std.parseFloat(" 3."), 3.);
    t.eq (Std.parseFloat(" -3.4"), -3.4);
    t.eq (Std.parseFloat(" 234.354"), 234.354);
    t.eq (Std.parseFloat(" +234.354"), 234.354);

    t.eq (Dec.toFloat("+0"), 0.);
    t.eq (Dec.toFloat("3 ."), 3.);
    t.eq (Dec.toFloatEu("+210.512,01234"), 210512.01234);
    t.eq (Dec.toFloat("j210.512,012.34"), Math.NaN);
    t.eq (Dec.toFloatEn("+210,512.01234"), 210512.01234);
    t.eq (Dec.toFloat("j210,512.012,34"), Math.NaN);

    t.eq (Dec.newStr ("0", 0).toEs (), "0");
    t.eq (Dec.newStr ("-0", 0).toEs (), "0");
    t.eq (Dec.newStr ("0", 2).toEs (), "0,00");
    t.eq (Dec.newStr ("-0", 2).toEs (), "0,00");
    t.eq (Dec.newStr ("0.1", 2).toEs (), "0,10");
    t.eq (Dec.newStr ("-0.1", 2).toEs (), "-0,10");
    t.eq (Dec.newStr ("0.1", 0).toEs (), "0");
    t.eq (Dec.newStr ("-0.1", 0).toEs (), "0");
    t.eq (Dec.newStr ("3.112", 2).toEs (), "3,11");
    t.eq (Dec.newStr ("-3.115", 2).toEs (), "-3,12");
    t.eq (Dec.newStr ("3.112", 0).toEs (), "3");
    t.eq (Dec.newStr ("3.115", 0).toEs (), "3");
    t.eq (Dec.newStr ("12233.112", 2).toEs (), "12.233,11");
    t.eq (Dec.newStr ("-12233.115", 2).toEs (), "-12.233,12");
    t.eq (Dec.newStr ("00345112233.112", 0).toEs ()
    , "345.112.233");
    t.eq (Dec.newStr ("00345112233.115", 0).toEs ()
    , "345.112.233");
    t.eq (Dec.newStr ("005112233.112", 2).toEs ()
    , "5.112.233,11");
    t.eq (Dec.newStr ("-005112233.115", 2).toEs ()
    , "-5.112.233,12");
    t.eq (Dec.newStr ("00345112233.112", 0).toEs ()
    , "345.112.233");
    t.eq (Dec.newStr ("00345112233.115", 0).toEs ()
    , "345.112.233");

    t.eq (Dec.newEn ("0", 0).toEs (), "0");
    t.eq (Dec.newEn ("-0", 0).toEs (), "0");
    t.eq (Dec.newEn ("0", 2).toEs (), "0,00");
    t.eq (Dec.newEn ("-0", 2).toEs (), "0,00");
    t.eq (Dec.newEn ("0.1", 2).toEs (), "0,10");
    t.eq (Dec.newEn ("-0.1", 2).toEs (), "-0,10");
    t.eq (Dec.newEn ("0.1", 0).toEs (), "0");
    t.eq (Dec.newEn ("-0.1", 0).toEs (), "0");
    t.eq (Dec.newEn ("3.112", 2).toEs (), "3,11");
    t.eq (Dec.newEn ("-3.115", 2).toEs (), "-3,12");
    t.eq (Dec.newEn ("3.112", 0).toEs (), "3");
    t.eq (Dec.newEn ("3.115", 0).toEs (), "3");
    t.eq (Dec.newEn ("12,233.112", 2).toEs (), "12.233,11");
    t.eq (Dec.newEn ("-12,233.115", 2).toEs (), "-12.233,12");
    t.eq (Dec.newEn ("00,345,112,233.112", 0).toEs ()
    , "345.112.233");
    t.eq (Dec.newEn ("00345,112,233.115", 0).toEs ()
    , "345.112.233");
    t.eq (Dec.newEn ("005,112,233.112", 2).toEs ()
    , "5.112.233,11");
    t.eq (Dec.newEn ("-005,112,233.115", 2).toEs ()
    , "-5.112.233,12");
    t.eq (Dec.newEn ("00345112,233.112", 0).toEs ()
    , "345.112.233");
    t.eq (Dec.newEn ("003,451,,12,233.115", 0).toEs ()
    , "345.112.233");

    t.eq (Dec.newEu ("0", 0).toEs (), "0");
    t.eq (Dec.newEu ("-0", 0).toEs (), "0");
    t.eq (Dec.newEu ("0", 2).toEs (), "0,00");
    t.eq (Dec.newEu ("-0", 2).toEs (), "0,00");
    t.eq (Dec.newEu ("0,1", 2).toEs (), "0,10");
    t.eq (Dec.newEu ("-0,1", 2).toEs (), "-0,10");
    t.eq (Dec.newEu ("0,1", 0).toEs (), "0");
    t.eq (Dec.newEu ("-0,1", 0).toEs (), "0");
    t.eq (Dec.newEu ("3,112", 2).toEs (), "3,11");
    t.eq (Dec.newEu ("-3,115", 2).toEs (), "-3,12");
    t.eq (Dec.newEu ("3,112", 0).toEs (), "3");
    t.eq (Dec.newEu ("3,115", 0).toEs (), "3");
    t.eq (Dec.newEu ("12.233,112", 2).toEs (), "12.233,11");
    t.eq (Dec.newEu ("-12.233,115", 2).toEs (), "-12.233,12");
    t.eq (Dec.newEu ("00.345.112.233,112", 0).toEs ()
    , "345.112.233");
    t.eq (Dec.newEu ("00345.112.233,115", 0).toEs ()
    , "345.112.233");
    t.eq (Dec.newEu ("005.112.233,112", 2).toEs ()
    , "5.112.233,11");
    t.eq (Dec.newEu ("-005.112.233,115", 2).toEs ()
    , "-5.112.233,12");
    t.eq (Dec.newEu ("00345112.233,112", 0).toEs ()
    , "345.112.233");
    t.eq (Dec.newEu ("003.451..12.233,115", 0).toEs ()
    , "345.112.233");

    t.log();
  }
}
