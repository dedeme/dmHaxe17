/*
 * Copyright 04-Mar-2016 ºDeme
 * GNU General Public License - V3 <http://www.gnu.org/licenses/>
 */

/// Static functions to manipulate the web local store.
package dm;

import dm.It;
import dm.DateDm;

/// Static functions to manipulate the web local store.
class Store {
  /// Removes all keys of local storage
  public static function clear () : Void {
    untyped __js__("localStorage.clear()");
  }

  /// Removes the key [key]  of local storage
  public static function del (key : String) : Void {
    untyped __js__("localStorage.removeItem(key)");
  }

  /**
  Removes some [keys] past the time [time] since it was called itself.<p>
  If it has not called ever delete keys too.
    name : Storage key for saving the time
    keys : Array with the keys to remove
    time : Time in hours
  */
  public static function expires (
    name : String, keys : Array<String>, time : Float
  ) : Void {
    var dt : Float = Date.now ().getTime ();
    var ks : String = get (name);
    if (ks == null || dt > Std.parseFloat (ks))
      It.from (keys).each ( function (k) { del (k); } );
    put (name, Std.string (dt + time * 3600000.));
  }

  /// Returns the value of key [key] or <b>null</b> if it does not exists
  /// of local storage
  public static function get (key : String) : Null<String> {
    return untyped __js__("localStorage.getItem(key)");
  }

  /// Returns the key in position [ix] of local storage
  public static function key (ix : Int) : String {
    return untyped __js__("localStorage.key(ix)");
  }

  /// Returns a It with all keys of local storage
  public static function keys () : It<String> {
    var sz = size ();
    var c = 0;
    return new It (
      function () { return c < sz; }
    , function () { return key (c++); }
    );
  }

  /// Puts a new value in local storage
  public static function put (key : String, value : String) : Void {
    untyped __js__("localStorage.setItem(key, value)");
  }

  /// Returns the number of elements of local storage
  public static function size () : Int {
    return untyped __js__("localStorage.length");
  }

  /// Returns a It with all values of local storage
  public static function values () : It<String> {
    return keys ().map (function (e) { return get (e); });
  }

  /// Removes all keys of session storage
  public static function sessionClear () : Void {
    untyped __js__("sessionStorage.clear()");
  }

  /// Removes the key [key] of session storage
  public static function sessionDel (key : String) : Void {
    untyped __js__("sessionStorage.removeItem(key)");
  }

  /// Returns the value of key [key] or <b>null</b> if it does not exists
  /// of session storage
  public static function sessionGet (key : String) : Null<String> {
    return untyped __js__("sessionStorage.getItem(key)");
  }

  /// Returns the key in position [ix] of session storage
  public static function sessionKey (ix : Int) : String {
    return untyped __js__("sessionStorage.key(ix)");
  }

  /// Returns a It with all keys of session storage
  public static function sessionKeys () : It<String> {
    var sz = sessionSize ();
    var c = 0;
    return new It (
      function () { return c < sz; }
    , function () { return sessionKey (c++); }
    );
  }

  /// Puts a new value in session storage
  public static function sessionPut (key : String, value : String) : Void {
    untyped __js__("sessionStorage.setItem(key, value)");
  }

  /// Returns the number of elements of session storage
  public static function sessionSize () : Int {
    return untyped __js__("sessionStorage.length");
  }

  /// Returns a It with all values of session storage
  public static function sessionValues () : It<String> {
    return sessionKeys().map(function (e) { return sessionGet(e); });
  }

}
