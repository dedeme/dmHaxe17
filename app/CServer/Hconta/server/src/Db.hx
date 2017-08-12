/*
 * Copyright 05-Jul-2017 ºDeme
 * GNU General Public License - V3 <http://www.gnu.org/licenses/>
 */

using StringTools;
import dm.It;
import dm.Io;
import dm.App;
import dm.Json;

///
class Db {
  static inline var dataRoot = "data";

  static inline function root() {
    return Io.cat([App.home, dataRoot]);
  }

  static inline function fconf() {
    return Io.cat([root(), "conf.db"]);
  }

  static inline function fyear(year:String) {
    return Io.cat([root(), 'ac$year.db']);
  }

  static function dbwrite(file:String, data:String) {
    Io.write(file, data);
  }

  static function dbappend(file:String, data:String) {
    Io.append(file, data);
  }

  static function dbread(file:String):String {
    return Io.read(file);
  }

  /// Reads all data of conf.year.<p>
  /// Initializes database if it is necessary.
  public static function read():Map<String, Dynamic> {
    if (!Io.exists(root())) {
      var year = Std.string(Date.now().getFullYear());
      Io.mkdir(root());
      var c = new Map<String, Dynamic>();
      c.set("dbVersion", "1");
      c.set("language", "es");
      c.set("page", "plan");
      c.set("year", year);
      dbwrite(fconf(), Json.from(c));
      dbwrite(fyear(year),
        "SGA57Tesorería" + "\n" +
        "AA574BABVI;Bancos, ctas. de ahorro" + "\n" +
        "SAA57401Bankia"
      );
    }

    var r = Json.toMap(dbread(fconf()));
    var year = r.get("year");

    var maxFYear = It.from(Io.dir(root())).filter(function (f) {
      return f.startsWith("ac");
    }).reduce("", function (seed, f) {
      return f > seed ? f : seed;
    });

    r.set("isLastYear", maxFYear == 'ac${year}.db');

    r.set("actions", dbread(fyear(year)));

    return r;
  }

  // Conf ------------------------------

  /// Sets configuration values (conf.db)
  public static function setConf(
    rq:Map<String, Dynamic>
  ):Map<String, Dynamic> {
    var cf = read();
    cf.set(rq.get("key"), rq.get("value"));
    dbwrite(fconf(), Json.from(cf));
    return new Map();
  }

  /// Sets page values and returns conf.db data.
  public static function setPage(
    vpage:String, vsubpage:String
  ):Map<String,Dynamic> {
    var cf = read();
    cf.set("page", vpage);
    dbwrite(fconf(), Json.from(cf));
    return cf;
  }

  /// Switchs language between "en" and "es" and returns conf.db data.
  public static function chageLang():Map<String,Dynamic> {
    var cf = read();
    cf.set("language", cf.get("language") == "es" ? "en" : "es");
    dbwrite(fconf(), Json.from(cf));
    return cf;
  }

  // ac$year ---------------------------

  /// Adds an action
  public static function action(
    rq:Map<String,Dynamic>
  ):Map<String,Dynamic> {
    dbappend(fyear(rq.get("year")), "\n" + rq.get("note"));
    return new Map();
  }

}
