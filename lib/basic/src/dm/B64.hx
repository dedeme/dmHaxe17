/*
 * Copyright 10-Aug-2017 ºDeme
 * GNU General Public License - V3 <http://www.gnu.org/licenses/>
 */

package dm;

import haxe.io.Bytes;
import haxe.crypto.Base64;

/// Class for codifiyng data
class B64 {
  /// Encodes a string in B64
  public static inline function encode(s:String):String {
    return encodeBytes(Bytes.ofString(s));
  }

  /// Decodes a string codified with encode
  public static function decode(c:String):String {
    return decodeBytes(c).toString();
  }

  /// Encodes a Bytes in B64
  public static inline function encodeBytes(bs:Bytes):String {
    return Base64.encode(bs);
  }

  /// Decodes a string codified with encodeBytes
  public static function decodeBytes(c:String):Bytes {
    return Base64.decode(c);
  }
}
