/*
 * Copyright 04-Mar-2016 ºDeme
 * GNU General Public License - V3 <http://www.gnu.org/licenses/>
 */

package dm;

/// Class for codifiyng data
class B41 {
  static var chars =
    "RSTUVWXYZa" +
    "bcdefghijk" +
    "lmnopqrstu" +
    "vwxyzABCDE" +
    "F";

  /// Returns the number of code B41 'b'
  inline public static function b2n (b:String):Int {
    return chars.indexOf(b);
  }

  /// Returns the B41 code whose number is 'n'
  inline public static function n2b (n:Int):String {
    return chars.charAt(n);
  }

  /// Encodes a string in B41
  public static function encode (s:String):String {
    var r = "";
    var i;
    for (i in 0...s.length) {
      var n = s.charCodeAt(i);
      var n1 = Math.floor(n / 41);
      r += chars.charAt(Math.floor(n1 / 41)) +
        chars.charAt(n1 % 41) +
        chars.charAt(n % 41);
    }
    return r;
  }

  /// Decodes a string codified with encode
  public static function decode (c:String):String {
    var r = "";
    var i = 0;
    while (i < c.length) {
      var n1 = chars.indexOf(c.charAt(i++));
      var n2 = chars.indexOf(c.charAt(i++));
      var n3 = chars.indexOf(c.charAt(i++));
      r += String.fromCharCode(1681 * n1 + 41 * n2 + n3);
    }
    return r;
  }

  /// Encodes an Array<Int> in B41
  public static function encodeBytes (bs:Array<Int>):String {
    var lg = bs.length;
    var odd = false;
    if (lg % 2 != 0) {
      odd = true;
      --lg;
    }
    var r = "";
    var i = 0;
    while (i < lg) {
      var n = bs[i]  * 256 + bs[i + 1];
      var n1 = Math.floor(n / 41);
      r += chars.charAt(Math.floor(n1 / 41)) +
        chars.charAt(n1 % 41) +
        chars.charAt(n % 41);
      i += 2;
    }
    if (odd) {
      var n = bs[i];
      r += chars.charAt(Math.floor(n / 41)) + chars.charAt(n % 41);
    }

    return r;
  }

  /// Decodes an Array<Int> codified with encodeBytes
  public static function decodeBytes (c:String):Array<Int> {
    var lg = c.length;
    var odd = false;
    if (lg % 3 != 0) {
      odd = true;
      lg -= 2;
    }
    var r = [];
    var i = 0;
    while (i < lg) {
      var n1 = chars.indexOf(c.charAt(i++));
      var n2 = chars.indexOf(c.charAt(i++));
      var n3 = chars.indexOf(c.charAt(i++));
      var n = 1681 * n1 + 41 * n2 + n3;
      r.push(Math.floor(n / 256));
      r.push(n % 256);
    }
    if (odd) {
      var n1 = chars.indexOf(c.charAt(i++));
      var n2 = chars.indexOf(c.charAt(i++));
      var n = 41 * n1 + n2;
      r.push(n);
    }
    return r;
  }

  /// Compressing a B41 code. It is usefull to codify strings.
  public static function compress (s:String):String {
    var c = encode(s);
    var n = 0;
    var i = 0;
    var tmp = "";
    var r = "";
    while (i < c.length) {
      if (c.substring(i, i + 2) == "RT") {
        ++n;
        tmp += c.charAt(i + 2);
        if (n == 10) {
          r += (n - 1) + tmp;
          tmp = "";
          n = 0;
        }
      } else {
        if (n > 0) {
          r += (n - 1) + tmp;
          tmp = "";
          n = 0;
        }
        r += c.substring(i, i + 3);
      }
      i += 3;
    }
    if (n > 0) {
      r += (n - 1) + tmp;
    }
    return r;
  }

  /// Decompress a B41 code compressed with compress
  public static function decompress (c:String):String {
    var r = "";
    var i = 0;
    while (i < c.length) {
      var ch = c.charAt(i++);
      if (ch >= "0" && ch <= "9") {
        var n = Std.parseInt(ch) + 1;
        for (j in 0...n) {
          ch = c.charAt(i++);
          r += "RT" + ch;
        }
      } else {
        r += ch;
        for (j in 0...2) {
          ch = c.charAt(i++);
          r += ch;
        }
      }
    }
    return decode(r);
  }

}
