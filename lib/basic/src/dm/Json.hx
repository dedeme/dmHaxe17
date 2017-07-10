/*
 * Copyright 04-Mar-2016 ºDeme
 * GNU General Public License - V3 <http://www.gnu.org/licenses/>
 */

/// JSON functions
package dm;

import dm.It;

/// Utilities for encoding and decoding Json objects
class Json {

  /// Serializes a map
  public static function smap(m : Map<String, Dynamic>) : Dynamic {
    var r = untyped __js__ ("{}");
    It.fromIterator(m.keys()).each(function (k) {
      var v = m.get(k);
      untyped __js__ ("r[k] = v");
    });
    return r;
  }

  /// 'Jsonizes' m. If 'm' has elements which are also Maps, these will not
  /// be serialized directly. For that it is necessary to serialize them with
  /// 'smap'
  inline public static function fromMap(m : Map<String, Dynamic>) : String {
    return from(smap(m));
  }

  ///
  public static function from(s : Dynamic) : String {
    return untyped __js__ ("JSON.stringify(s)");
  }

  /// Restores a map serialized with smap
  public static function rmap(o : Dynamic) : Map<String, Dynamic> {
    var r = new Map<String, Dynamic>();
    var ks = untyped __js__ ("Object.keys(o)");
    It.from(ks).each(function (k) {
      r.set(k, untyped __js__ ("o[k]"));
    });
    return r;
  }

  /// If 'j' contains other Maps nested, these must be restored with 'rmap'
  inline public static function toMap(j : String) : Map<String, Dynamic> {
    return rmap(to(j));
  }

  ///
  public static function to(j : String) : Dynamic {
    return untyped __js__ ("JSON.parse(j)");
  }
}
