/*
 * Copyright 01-Jul-2017 ºDeme
 * GNU General Public License - V3 <http://www.gnu.org/licenses/>
 */

import dm.Test;
import dm.Io;
import dm.App;
import dm.Tuple;
using StringTools;

class IoTest {
  public static function run () {
    var t = new Test("Io");

    t.tests([
      new Tp2("", ""),
      new Tp2("/", null),
      new Tp2("ab", "ab"),
      new Tp2("/ab.c", "ab.c"),
      new Tp2("cd/", "cd"),
      new Tp2("cg/r/ab.c", "ab.c")
    ], Io.name);

    t.tests([
      new Tp2("", ""),
      new Tp2("/", null),
      new Tp2("ab", ""),
      new Tp2("/ab.c", ""),
      new Tp2("cd/", ""),
      new Tp2("cg/r/ab.c", "cg/r")
    ], Io.parent);

    t.tests([
      new Tp2("", ""),
      new Tp2("/", null),
      new Tp2("ab", ""),
      new Tp2("/ab.c", ".c"),
      new Tp2("cd/", ""),
      new Tp2("cg/r/ab.c", ".c"),
      new Tp2("cg/r/ab.", ".")
    ], Io.extension);

    t.tests([
      new Tp2("", ""),
      new Tp2("/", null),
      new Tp2("ab", "ab"),
      new Tp2("/ab.c", "ab"),
      new Tp2("cd/", "cd"),
      new Tp2("cg/r/ab.c", "ab"),
      new Tp2("cg/r/ab.", "ab")
    ], Io.onlyName);

    t.tests([
      new Tp2([""], ""),
      new Tp2(["", ""], "/"),
      new Tp2(["1"], "1"),
      new Tp2(["a", "bc"], "a/bc"),
      new Tp2(["", "a", "", "b"], "/a//b"),
      new Tp2(["/a", "", "b"], "/a//b"),
    ], Io.cat);

    App.init("CbasicTests");
    t.eq(App.user, App.cmd("whoami"));
    t.eq(App.uhome, App.cmd("echo $HOME"));
    t.yes(App.home.endsWith("/.dmHaxeApp/CbasicTests"));

//    var page = Io.http(
//      "http://es.finance.yahoo.com/q/hp?" +
//      "s=AMS.MC&b=29&a=03&c=2010&e=12&d=07&f=2015&g=d&z=66&y=132"
//    );
//    trace(page);


    t.log();
  }
}


