/*
 * Copyright 04-Mar-2016 ºDeme7
 * GNU General Public License - V3 <http://www.gnu.org/licenses/>
 */

/// Cryptographic functions
package dm;

import dm.Json;
import dm.It;

/// Utilities for encoding and decoding Json objects
class Json {

  ///
  public static function fromMap (m : Map<String, Dynamic>) : String {
    var r = untyped __js__ ("{}");
    for (k in m.keys()) {
      var v = m.get(k);
      untyped __js__ ("r[k] = v");
    }
    return untyped __js__ ("JSON.stringify(r)");
  }

  ///
  public static function from (s : Dynamic) : String {
    return untyped __js__ ("JSON.stringify(s)");
  }

  ///
  public static function toMap (j : String) : Map<String, Dynamic> {
    var r = new Map<String, Dynamic>();
    var o = untyped __js__ ("JSON.parse(j)");
    var ks = untyped __js__ ("Object.keys(o)");
    It.from(ks).each(function (k) {
      r.set(k, untyped __js__ ("o[k]"));
    });
    return r;
  }

  ///
  public static function to (j : String) : Dynamic {
    return untyped __js__ ("JSON.parse(j)");
  }
}
