/*
 * Copyright 04-Mar-2016 ºDeme
 * GNU General Public License - V3 <http://www.gnu.org/licenses/>
 */

/// Some mathematical functions, rounding and numeric formats
package dm;

import dm.Json;

/// Some mathematical functions, rounding and numeric formats
class Dec {
  /// Number of decimal positions.
  public var scale (default, null) : Int;
  ///
  public var value (default, null) : Float;

  var intValue : Int;
  var intScale : Int;
  var sign : Int;

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
    intScale = 1;
    for (i in 0 ... scale) intScale *= 10;
    if (value < 0) {
      intValue = Math.round (-value * intScale + 0.000000001);
      if (intValue == 0) sign = 1;
      else sign = -1;
    } else {
      intValue = Math.round (value * intScale + 0.000000001);
      sign = 1;
    }
    this.value = intValue * sign / intScale;
  }

  /// Returns if [this] and [d] have the same value and scale
  public function eq (d : Dec) : Bool{
    return intValue == d.intValue
    && intScale == d.intScale
    && sign == d.sign
    ;
  }

  /// Returns if [this] and [d] have the same value. (Doesn't take into account
  /// their scales)
  public function eqValue (d : Dec) : Bool{
    return (scale > d.scale)
    ? eq (new Dec (d.value, scale))
    : (scale < d.scale)
      ? new Dec (value, d.scale).eq (d)
      : intValue * sign == d.intValue * d.sign
    ;
  }

  /// Returns 1, 0 or -1 depending on [this] was greater, equal or lesser than
  /// [d]. (Doesn't take into account their scales)
  public function compare (d : Dec) : Int {
    return (scale > d.scale)
    ? compare (new Dec (d.value, scale))
    : (scale < d.scale)
      ? new Dec (value, d.scale).compare (d)
      : intValue * sign - d.intValue * d.sign
    ;
  }

  function format (thousand : String, decimal : String) : String {
    var left = Std.string(intValue);
    var right = "";
    if (scale > 0) {
      while (left.length < scale + 1) left = "0" + left;
      var ix = left.length - scale;
      right = decimal + left.substring (ix);
      left = left.substring (0, ix);
    }
    var size = 3;
    while (left.length > size) {
      var ix = left.length - size;
      left = left.substring (0, ix) + thousand + left.substring (ix);
      size += 4;
    }
    return (sign == 1)? left + right : "-" + left + right;
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
    var r = Std.string (intValue);
    if (scale > 0) {
      while (r.length < scale + 1) r = "0" + r;
      var ix = r.length - scale;
      r = r.substring(0, ix) + "." + r.substring (ix);
    }
    return (sign == 1)? r : "-" + r;
  }

  ///
  public function serialize () : Array<Dynamic> {
    return [value, scale];
  }

  /// [s] must be in base format.
  public static function isNumber (s : String) : Bool {
    return untyped __js__ ("s && !isNaN(s)");
  }

  /// Test if [s] is in English format
  public static function isNumberEn (s : String) : Bool {
    return isNumber (StringTools.replace (s, ",", ""));
  }

  /// Test if [s] is in European format
  public static function isNumberEu (s : String) : Bool {
    return isNumber (StringTools.replace (StringTools.replace (
      s, ".", ""), ",", "."));
  }

  /// Returns 's' (base format) converted to Float o null if 's' is not a
  /// number
  public static function toFloat (s : String) : Float {
    return isNumber(s) ? Std.parseFloat(s) : null;
  };

  /// Returns 's' (English format) converted to Float o null if 's' is not a
  /// number
  public static function toFloatEn (s : String) : Float {
    s = StringTools.replace (s, ",", "");
    return isNumber(s) ? Std.parseFloat(s) : null;
  };

  /// Returns 's' (base format) converted to Float o null if 's' is not a
  /// number
  public static function toFloatEu (s : String) : Float {
    s = StringTools.replace (StringTools.replace (s, ".", ""), ",", ".");
    return isNumber(s) ? Std.parseFloat(s) : null;
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
