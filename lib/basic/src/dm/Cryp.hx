/*
 * Copyright 04-Mar-2016 ºDeme
 * GNU General Public License - V3 <http://www.gnu.org/licenses/>
 */

/// Cryptographic functions
package dm;

import dm.B41;

/// Static cryptographic functions.<p>
class Cryp {

  /// Encodes a string to B41
  inline public static function s2b (s:String):String {
    return B41.compress(s);
  }

  /// Decodes a string codified with s2b()
  inline public static function b2s (c:String):String {
    return B41.decompress(c);
  }

  /// Generates a B41 random key of a length 'lg'
  public static function genK (lg:Int):String {
    return It.join(It.range(lg).map(function (i) {
      return B41.n2b(Math.floor(Math.random() * 41));
    }));
  }

  /// Encodes a string to url (encodeURIComponent)
  public static function s2u (s:String):String {
    return untyped __js__ ("encodeURIComponent(s)");
  }

  /// Decodes a url encoded string (decodeURIComponent)
  public static function u2s (url:String):String {
    return untyped __js__ ("decodeURIComponent(url)");
  }

  /**
  Returns 'k' codified in irreversible way, using 'lg' B41 digits.
    k     : String to codify
    lg    : Length of result
    return: 'lg' B41 digits
  */
  public static function key (k:String, lg:Int):String {
    var lg2 = k.length * 2;
    if (lg2 < lg * 2) {
      lg2 = lg * 2;
    }
    k = k + "codified in irreversibleDeme is good, very good!\n\r8@@";
    while (k.length < lg2) {
      k += k;
    }
    k = k.substring(0, lg2);
    var dt = B41.decodeBytes(B41.encode(k));
    lg2 = dt.length;

    var sum = 0;
    var i = 0;
    while (i < lg2) {
      sum = (sum + dt[i]) % 256;
      dt[i] = (sum + i + dt[i]) % 256;
      ++i;
    }
    while (i > 0) {
      --i;
      sum = (sum + dt[i]) % 256;
      dt[i] = (sum + i + dt[i]) % 256;
    }

    return B41.encodeBytes(dt).substring(0, lg);
  }

  /**
  Encodes 'm' with key 'k'.
    k     : Key for encoding
    m     : Message to encode
    return: 'm' codified in B41 digits.
  */
  public static function cryp (k:String, m:String):String {
    m = B41.encode(m);
    k = key(k, m.length);
    return It.join(It.range(m.length).map(function (i) {
      return B41.n2b((B41.b2n(m.charAt(i)) + B41.b2n(k.charAt(i))) % 41);
    }));
  }

  /**
  Decodes 'c' using key 'k'. 'c' was codified with cryp().
    k     : Key for decoding
    c     : Text codified with cryp()
    return: 'c' decoded.
  */
  public static function decryp (k:String, c:String):String {
    k = key(k, c.length);
    return B41.decode(It.join(It.range(c.length).map(function (i) {
      var n = B41.b2n(c.charAt(i)) - B41.b2n(k.charAt(i));
      return B41.n2b((n >= 0) ? n : n + 41);
    })));
  }

  /**
  Encodes automatically 'm' with a random key of 'nk' digits.
    nK    : Number of digits for random key (1 to 40 both inclusive)
    m     : Text for enconding
    return: 'm' encoded in B41 digits
  */
  public static function autoCryp (nK:Int, m:String):String {
    var k1 = Math.floor(Math.random() * 41);
    var n = B41.n2b((nK + k1) % 41);
    var k = genK(nK);
    return B41.n2b(k1) +
      n +
      k +
      cryp(k, m);
  }

  /**
  Decodes a text codified with autoCryp()
    c     :Codified text
    return: Decoded text
  */
  public static function autoDecryp (c:String):String {
    var c1 = B41.b2n(c.charAt(1)) - B41.b2n(c.charAt(0));
    var nK = (c1 >= 0) ? c1 : c1 + 41;
    return decryp(c.substr(2, nK), c.substr(2 + nK));
  }

  /**
  Encodes 'm' whith key 'k' and an autoKey of length 'nK'
    k     : Key for encoding
    mK    : Digits to generate autoKey (1 to 40 both inclusive)
    m     : Message to encode
    return: 'm' codified in B41 digits.
  */
  inline public static function encode (k:String, nK:Int, m:String):String {
    return cryp(k, autoCryp(nK, m));
  }

  /**
  Decodes a string codified with encode()
    k     : Key for encoding
    c     : Message encoded with encode()
    return: 'c' decoded.
  */
  inline public static function decode (k:String, c:String):String {
    return autoDecryp(decryp(k, c));
  }
}

