/*
 * Copyright 04-Mar-2016 ºDeme
 * GNU General Public License - V3 <http://www.gnu.org/licenses/>
 */

/// Utilities to manipulate dates.
package dm;

import dm.Str;

/// Utilities to manipulate dates.
///   If you require time functions, you must use the standard Date.
class DateDm {
  /// Inicializated as ["enero", "febrero", "marzo", "abril", "mayo", "junio",
  /// "julio", "agosto", "septiembre", "octubre", "noviembre",  "diciembre"]
  public static var months (default, default) : Array<String> = [
      "enero", "febrero", "marzo", "abril", "mayo", "junio",  "julio", "agosto"
    , "septiembre", "octubre", "noviembre",  "diciembre"
  ];
  /// Inicializated as ["domingo", "lunes", "martes", "miércoles", "jueves",
  /// "viernes", "sábado"]
  public static var week (default, default) : Array<String> = [
    "domingo", "lunes", "martes", "miércoles", "jueves",  "viernes", "sábado"
  ];
  /// Inicializated as "DLMXJVS"
  public static var week1 (default, default) : String = "DLMXJVS";

  var date : Date;

  /// Inicializates variables months, week and week1.
  ///   Note: Jan is 1, Dec is 12.
  public function new (day : Int, month : Int, year : Int) {
    date = new Date (year, month - 1, day, 12, 0, 0);
  }

  ///
  inline public function eq (d : DateDm) : Bool {
    return day () == d.day ()
    && month () == d.month ()
    && year () == d.year ()
    ;
  }

  ///
  public function compare (d : DateDm) : Int {
    return (year () == d.year ())
    ? (month () == d.month ())
      ? day () - d.day ()
      : month () - d.month ()
    : year () - d.year ()
    ;
  }

  /// Returns a new DataDm equals to [this] + [days]
  inline public function add (days : Int) : DateDm {
    return DateDm.fromTime (toTime () + days * 86400000.0);
  }

  /// Returns [this] - [d] in days.
  inline public function df (d : DateDm) : Int {
    return Math.round ((toTime () - d.toTime ()) / 86400000.0);
  }

  /**
  Returns a string that represents to [this]. <p>
  [template] is a kind <tt>printf</tt> with next sustitution
  variables:
    %d  Day in number 06 -> 6
    %D  Day with tow digits 06 -> 06
    %m  Month in number 03 -> 3
    %M  Month with two digits 03 -> 03
    %y  Year with two digits 2010 -> 10
    %Y  Year with four digits 2010 -> 2010
    %b  Month with three characters.
    %B  Month with all characters.
    %1 Week day with one character: L M X J V S D
    %a Week day with tree characters.
    %A  Week day withd all characters.
    %%  The sign %
  */
  public function format (template : String) : String {
    var r = function (code, value) : Void {
      template = StringTools.replace (template, code, value);
    }

    var d = Std.string (date.getDate ());
    var dw = date.getDay ();
    var w = week[dw];
    var mn = date.getMonth ();
    var m = Std.string (mn + 1);
    var ms = months[mn];
    var y = "0000" + Std.string (date.getFullYear ());

    r ("%d", d);
    r ("%D", (d.length == 1)? "0" + d : d);
    r ("%m", m);
    r ("%M", (m.length == 1)? "0" + m : m);
    r ("%y", Str.sub (y, -2));
    r ("%Y", Str.sub (y, -4));
    r ("%b", ms.substring (0, 3));
    r ("%B", ms);
    r ("%1", week1.charAt (dw));
    r ("%a", w.substring (0, 3));
    r ("%A", w);
    r ("%%", "%");

    return template;
  }

  /// Returns [this] in format "yyyymmdd"
  public function base () : String {
    var y = "0000" + Std.string (date.getFullYear ());
    var m = "00" + Std.string (date.getMonth () + 1);
    var d = "00" + Std.string (date.getDate ());
    return  Str.sub (y, -4)
    + Str.sub (m, -2)
    + Str.sub (d, -2)
    ;
  }

   /// In range 1-31
  inline public function day () : Int {
    return date.getDate ();
  }

  /// In range 1-12
  inline public function month () : Int {
    return date.getMonth () + 1;
  }

  ///
  inline public function year () : Int {
    return date.getFullYear ();
  }

  ///
  inline public function toDate () : Date {
    return date;
  }

  ///
  inline public function toTime () : Float {
    return date.getTime ();
  }

  ///
  public function toString () : String {
    var y = "0000" + Std.string (date.getFullYear ());
    var m = "00" + Std.string (date.getMonth () + 1);
    var d = "00" + Std.string (date.getDate ());
    return Str.sub(d, -2) + "/"
    + Str.sub (m, -2) + "/"
    + Str.sub (y, -4)
    ;
  }

  ///
  public static function fromDate (date : Date) : DateDm {
    return new DateDm (
      date.getDate (), date.getMonth () + 1, date.getFullYear ()
    );
  }

  /// [s] is in format yyyymmdd (mm in range 01-12)
  public static function fromStr (s : String) : DateDm {
    return new DateDm (Std.parseInt (s.substring (6))
    , Std.parseInt (s.substring (4, 6))
    , Std.parseInt (s.substring (0, 4))
    );
  }

  /// [s] is in format dd-mm-yyyy or dd-mm-yy or dd/mm/yyyy or dd/mm/yy
  /// (mm in range 01-12)
  public static function fromEu (s : String) : DateDm {
    var ps = s.split ("/");
    if (ps.length == 1) ps = ps[0].split ("-");
    return new DateDm (
      Std.parseInt (ps[0])
    , Std.parseInt (ps[1])
    , (ps[2].length == 2)? 2000 + Std.parseInt (ps[2])
      : Std.parseInt (ps[2])
    );
  }

  /// [s] is in format mm-dd-yyyy or mm-dd-yy or mm/dd/yyyy or mm/dd/yy
  /// (mm in range 01-12)
  public static function fromEn (s : String) : DateDm {
    var ps = s.split ("/");
    if (ps.length == 1) ps = ps[0].split ("-");
    return new DateDm (
      Std.parseInt (ps[1])
    , Std.parseInt (ps[0])
    , (ps[2].length == 2)? 2000 + Std.parseInt (ps[2])
      : Std.parseInt (ps[2])
    );
  }

  ///
  inline public static function fromTime (time : Float) : DateDm {
    return fromDate (Date.fromTime (time));
  }

  /// Returns the date-hour actual.
  inline public static function now () : DateDm {
    return fromDate (Date.now ());
  }

  ///
  inline public function serialize () : Array<Int> {
    return [day(), month(), year()];
  }

  ///
  inline public static function restore (serial:Array<Int>) : DateDm {
    return new DateDm(serial[0], serial[1], serial[2]);
  }

  ///
  public static function isLeap (year:Int):Bool {
    return ((year % 4 == 0) && (year % 100 != 0)) || (year % 400 == 0);
  }

}
