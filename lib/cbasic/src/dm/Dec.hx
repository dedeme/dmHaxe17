/*
 * Copyright 02-Jul-2017 ºDeme
 * GNU General Public License - V3 <http://www.gnu.org/licenses/>
 */

/// Some mathematical functions, rounding and numeric formats
package dm;

import dm.Json;
using StringTools;

/// Some mathematical functions, rounding and numeric formats
class Dec {
  static inline var err = 0.000000001;
  /// Number of decimal positions.
  public var scale (default, null) : Int;
  ///
  public var value (default, null) : Float;

  /**
  Constructor.
    value : A float value.
    scale : Number of decimal positions.
  */
  public function new (?value : Float, ?scale : Int) {
    if (value == null) {
      value = 0;
    }
    if (scale == null) {
      scale = 0;
    }
    this.scale = scale;
    var intScale = 1;
    for (i in 0 ... scale) intScale *= 10;
    var v2 = value * intScale;
    var intValue;
    if (value < 0) {
      intValue = Math.fceil(v2);
      if (intValue - v2 + 0.000000001 >= 0.5) {
        intValue -= 1;
      }
    } else {
      intValue = Math.ffloor(v2);
      if (v2 - intValue + err >= 0.5) {
        intValue += 1;
      }
    }
    this.value = intValue / intScale;
    if (this.value + err > 0 && this.value - err < 0) {
      this.value = 0;
    }
  }

  /// Returns if [this] and [d] have the same value and scale
  public function eq (d : Dec) : Bool{
    return scale == d.scale && value + err > d.value && value - err < d.value;
  }

  /// Returns if [this] and [d] have the same value. (Doesn't take into account
  /// their scales)
  public function eqValue (d : Dec) : Bool{
    return value + err > d.value && value - err < d.value;
  }

  /// Returns 1, 0 or -1 depending on [this] was greater, equal or lesser than
  /// [d]. (Doesn't take into account their scales)
  public function compare (d : Dec) : Int {
    return eqValue(d) ? 0 : value > d.value ? 1 : -1;
  }

  function format (thousand : String, decimal : String) : String {
    var sv = Std.string(value);
    var ix = sv.indexOf(".");
    var dec;
    var int;
    if (ix == -1) {
      dec = "";
      int = sv;
    } else {
      dec = sv.substring(ix + 1);
      int = sv.substring(0, ix);
    }
    dec = (dec + "0000000000").substring(0, scale);
    var th = thousand.fastCodeAt(0);
    var bf = new StringBuf();
    var count = 0;
    for (i in -int.length+1...1) {
      var ch = int.fastCodeAt(-i);
      if (count > 2) {
        if (ch != 45) {
          bf.addChar(th);
        }
        count = 0;
      }
      bf.addChar(ch);
      ++count;
    }

    int = bf.toString();
    bf = new StringBuf();
    for (i in -int.length+1...1) {
      bf.addChar(int.fastCodeAt(-i));
    }

    return bf.toString() + (dec.length > 0 ? decimal + dec : "");
  }

  /// European format, with point of thousand and decimal comma.
  inline public function toEs () : String {
    return format (".", ",");
  }

  /// English format, with comma of thousand  and decimal point.
  inline public function toEn () : String {
    return format (",", ".");
  }

  /// Return [this] in base format.
  public function toString () : String {
    var sv = Std.string(value);
    var ix = sv.indexOf(".");
    var dec;
    var int;
    if (ix == -1) {
      dec = "";
      int = sv;
    } else {
      dec = sv.substring(ix + 1);
      int = sv.substring(0, ix);
    }
    dec = (dec + "0000000000").substring(0, scale);

    return int + (dec.length > 0 ? "." + dec : "");
  }

  ///
  public function serialize () : Array<Dynamic> {
    return [value, scale];
  }

  /// Returns 's' (base format) converted to Float o NaN if 's' is not a
  /// number
  public static function toFloat (s : String) : Float {
    return Std.parseFloat(s);
  };

  /// Returns 's' (English format) converted to Float o NaN if 's' is not a
  /// number
  inline public static function toFloatEn (s : String) : Float {
    return toFloat(StringTools.replace (s, ",", ""));
  };

  /// Returns 's' (base format) converted to Float o null if 's' is not a
  /// number
  inline public static function toFloatEu (s : String) : Float {
    return toFloat(
      StringTools.replace (StringTools.replace (s, ".", ""), ",", ".")
    );
  };

  /// [s] must be in English format.
  public static function newEn (s : String, scale : Int) : Dec {
    return new Dec (Std.parseFloat (
      StringTools.replace (s, ",", "")
    ), scale);
  }

  /// [s] must be in European format.
  public static function newEu (s : String, scale : Int) : Dec {
    return new Dec (Std.parseFloat (
      StringTools.replace (StringTools.replace (s, ".", ""), ",", ".")
    ), scale);
  }

  /// [s] must be in base format.
  inline public static function newStr (s : String, scale : Int) : Dec {
    return new Dec (Std.parseFloat (s), scale);
  }

  ///
  public static function restore (s : Array<Dynamic>) : Dec {
    return new Dec(s[0], s[1]);
  }

  /// Return a random integer between 0 included and n excluded
  inline public static function rnd (n : Int) : Int {
    return Std.random (n);
  }

  /// Return a number between [0-1)
  inline public static function rnd0 () : Float {
    return Math.random ();
  }

  /// Return a random integer between n1 included and n2 included.
  ///   n1 can be upper or lower than n2.
  public static function rndInt (n1: Int, n2 : Int) : Int {
    var dif = n2 - n1;
    return (dif > 0)? n1 + Dec.rnd (dif + 1) : n2 + Dec.rnd (-dif + 1);
  }

  /// Return a random integer between n1 included and n2 included.
  ///   n1 can be upper or lower than n2.
  ///   Result has a scale equals to that which had more one.
  public static function rndDec (n1 : Dec, n2 : Dec) : Dec {
    var sc = n2.scale;
    if (n1.scale > n2.scale) sc = n2.scale;

    var dif = n2.value - n1.value;
    return (dif > 0)
    ? new Dec (n1.value + Dec.rnd0 () * dif, sc)
    : new Dec (n2.value + Dec.rnd0 () * -dif, sc)
    ;
  }

  /// Return a random integer between n1 included and n2 included.
  ///   n1 can be upper or lower than n2.
  ///   Result has a scale equals to that which had more one.
  public static function rndFloat (n1 : Float, n2 : Float, scale:Int) : Dec {
    var dif = n2 - n1;
    return (dif > 0)
    ? new Dec (n1 + Dec.rnd0 () * dif, scale)
    : new Dec (n2 + Dec.rnd0 () * -dif, scale)
    ;
  }

}
