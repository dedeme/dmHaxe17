// Copyright 04-Mar-2016 ºDeme
// GNU General Public License - V3 <http://www.gnu.org/licenses/>

/// Cryptographic functions
package dm;

import haxe.io.Bytes;
import dm.B64;

/// Static cryptographic functions.<p>
class Cryp {

  /// Encodes a string to url (encodeURIComponent)
  public static function s2u (s:String):String {
    return untyped __js__ ("encodeURIComponent(s)");
  }

  /// Decodes a url encoded string (decodeURIComponent)
  public static function u2s (url:String):String {
    return untyped __js__ ("decodeURIComponent(url)");
  }

  /// Generates a B64 random key of a length 'lg'
  public static function genK(lg:Int):String {
    var arr = Bytes.alloc(lg);
    for (i in 0...lg) {
      arr.set(i, Math.floor(Math.random() * 256));
    }
    return B64.encodeBytes(arr).substring(0, lg);
  }

  /// Returns 'k' codified in irreversible way, using 'lg' B64 digits.
  ///   k     : String to codify
  ///   lg    : Length of result
  ///   return: 'lg' B64 digits
  public static function key(k:String, lg:Int):String {
    var k = B64.decodeBytes(B64.encode(
      k + "codified in irreversibleDeme is good, very good!\n\r8@@"
    ));

    var lenk = k.length;
    var sum = 0;
    for (i in 0...lenk) {
      sum += k.get(i);
    }
    var lg2 = lg + lenk;
    var r = Bytes.alloc(lg2);
    var r1 = Bytes.alloc(lg2);
    var r2 = Bytes.alloc(lg2);
    var ik = 0;
    for (i in 0...lg2) {
      var v1 = k.get(ik);
      var v2 = v1 + k.get(v1 % lenk);
      var v3 = v2 + k.get(v2 % lenk);
      var v4 = v3 + k.get(v3 % lenk);
      sum = (sum + i + v4) % 256;
      r1.set(i, sum);
      r2.set(i, sum);
      ++ik;
      if (ik == lenk) {
        ik = 0;
      }
    }
    for (i in 0...lg2) {
      var v1 = r2.get(i);
      var v2 = v1 + r2.get(v1 % lg2);
      var v3 = v2 + r2.get(v2 % lg2);
      var v4 = v3 + r2.get(v3 % lg2);
      sum = (sum + v4) % 256;
      r2.set(i, sum);
      r.set(i, (sum + r1.get(i)) % 256);
    }

    return B64.encodeBytes(r).substring(0, lg);
  }

  /// Encodes 'm' with key 'k'.
  ///   k     : Key for encoding
  ///   m     : Message to encode
  ///   return: 'm' codified in B64 digits.
  public static function cryp(k:String, m:String):String {
    var m = B64.encode(m);
    var lg = m.length;
    var k = key(k, lg);
    var mb = Bytes.ofString(m);
    var kb = Bytes.ofString(k);
    var r = Bytes.alloc(lg);
    for (i in 0...lg) {
      r.set(i, mb.get(i) + kb.get(i));
    }
    return B64.encodeBytes(r);
  }

  /// Decodes 'c' using key 'k'. 'c' was codified with cryp().
  ///   k     : Key for decoding
  ///   c     : Text codified with cryp()
  ///   return: 'c' decoded.
  public static function decryp(k:String, c:String):String {
    try {
      var mb = B64.decodeBytes(c);
      var lg = mb.length;
      var k = key(k, lg);
      var kb = Bytes.ofString(k);
      var r = Bytes.alloc(lg);
      for (i in 0...lg) {
        r.set(i, mb.get(i) - kb.get(i));
      }
      return B64.decode(r.toString());
    } catch (e:Dynamic) {
      return cryp(genK(256), c);
    }
  }
}

