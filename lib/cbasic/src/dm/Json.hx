/*
 * Copyright 02-Jul-2017 ºDeme
 * GNU General Public License - V3 <http://www.gnu.org/licenses/>
 */

/// JSON functions
package dm;

/// Utilities for encoding and decoding Json objects
class Json {

  ///
  inline public static function from (s : Dynamic) : String {
    return haxe.Json.stringify(s);
  }

  /// When result comes from a Map and its keys are valid identifiers, they can
  /// be read with
  ///   Json.to(j).key
  /// But if a key is not a valid identifier, it must be read with
  ///   Reflect.field(Json.to(j), "not id")
  inline public static function to (j : String) : Dynamic {
    return haxe.Json.parse(j);
  }

  public static function toMap(j: String): Map<String, Dynamic> {
    var r = new Map<String, Dynamic>();
    var v = to(j);
    It.from(Reflect.fields(v)).each(function (k) {
      r.set(k, Reflect.field(v, k));
    });
    return r;
  }

}
