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
  public static function encode(s:String):String {
    return encodeBytes(Bytes.ofString(s));
  }

  /// Decodes a string codified with encode
  public static function decode(c:String):String {
    return decodeBytes(c).toString();
  }

  /// Encodes a Bytes in B64.<p>
  /// To encode an UInt8Array you can write:
  ///   encodeBytes(Bytes.ofData(cast(u8)));
  public static inline function encodeBytes(bs:Bytes):String {
    return Base64.encode(bs);
  }

  /// Decodes a string codified with encodeBytes.<p>
  /// To decode to an UInt8Array you can write:
  ///   var bs:Dynamic = decodeBytes(c);
  ///   var u8 = bs.b;
  public static function decodeBytes(c:String):Bytes {
    return Base64.decode(c);
  }

  /// Generates a B64 random key of a length 'lg'
  public static function genK(lg:Int):String {
    var arr = Bytes.alloc(lg);
    for (i in 0...lg) {
      arr.set(i, Math.floor(Math.random() * 256));
    }
    return encodeBytes(arr).substring(0, lg);
  }

  /// Returns 'k' codified in irreversible way, using 'lg' B64 digits.
  ///   k     : String to codify
  ///   lg    : Length of result
  ///   return: 'lg' B64 digits
  public static function key(k:String, lg:Int):String {
    var lg2 = k.length * 2;
    if (lg2 < lg * 2) {
      lg2 = lg * 2;
    }

    var k = k + "codified in irreversibleDeme is good, very good!\n\r8@@";
    while (k.length < lg2) {
      k += k;
    }
    var dt = decodeBytes(encode(k));
    lg2 = dt.length;

    var sum = 0;
    var i = 0;
    while (i < lg2) {
      sum = (sum + dt.get(i)) % 256;
      dt.set(i, (sum + i + dt.get(i)) % 256);
      ++i;
    }
    while (i > 0) {
      --i;
      sum = (sum + dt.get(i)) % 256;
      dt.set(i, (sum + i + dt.get(i)) % 256);
    }

    return encodeBytes(dt).substring(0, lg);
  }

  /// Encodes 'm' with key 'k'.
  ///   k     : Key for encoding
  ///   m     : Message to encode
  ///   return: 'm' codified in B64 digits.
  public static function cryp(k:String, m:String):String {
    var m = encode(m);
    var lg = m.length;
    var k = key(k, lg);
    var mb = Bytes.ofString(m);
    var kb = Bytes.ofString(k);
    var r = Bytes.alloc(lg);
    for (i in 0...lg) {
      r.set(i, mb.get(i) + kb.get(i));
    }
    return encodeBytes(r);
  }

  /// Decodes 'c' using key 'k'. 'c' was codified with cryp().
  ///   k     : Key for decoding
  ///   c     : Text codified with cryp()
  ///   return: 'c' decoded.
  public static function decryp(k:String, c:String):String {
    var mb = decodeBytes(c);
    var lg = mb.length;
    var k = key(k, lg);
    var kb = Bytes.ofString(k);
    var r = Bytes.alloc(lg);
    for (i in 0...lg) {
      r.set(i, mb.get(i) - kb.get(i));
    }
    return decode(r.toString());
  }

}
