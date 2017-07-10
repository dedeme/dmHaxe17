/*
 * Copyright 04-Mar-2016 ºDeme
 * GNU General Public License - V3 <http://www.gnu.org/licenses/>
 */

/// Contains Str, StrBf
package dm;

import haxe.io.Bytes;
import dm.Cryp;

/// Static functions for string handling
class Str {
  /// Cuts [text] left, returning [width] positions at right.
  public static function cutLeft (text : String, width : Int) : String {
    if (text.length > width)
      return "..." + text.substring (text.length - width + 3);
    return text;
  }

  /// Cuts [text] right, returning [width] positions at left.
  public static function cutRight (text : String, width : Int) : String {
    if (text.length > width)
      return text.substring (0, width - 3) + "...";
    return text;
  }

  /**
  Formats a string in fashion C. Uses next replaces:
    %s     Is replaced by a string
    %v     Is replaced by a value different of string
    %%     Is replaced by %
  */
  public static function format (template : String, args : Array<Dynamic>)
  : String {
    var bf = new StringBuf ();
    var isCode = false;
    var c = 0;

    for (ix in 0 ... template.length) {
      var ch = template.charAt (ix);
      if (isCode) {
        switch ch {
          case "s" : bf.add (cast (args[c++], String));
          case "v" : bf.add (Std.string (args[c++]));
          case "%" : bf.add ("%");
          default  : bf.add ("%" + ch);
        }
        isCode = false;
      } else {
        if (ch == "%") isCode = true;
        else bf.add (ch);
      }
    }

    return bf.toString ();
  }

  /// Escapes single or double quotes too.
  inline public static function html (text : String) : String {
    return StringTools.htmlEscape (text, true);
  }

  /// Decodes [code] codified with 'toB41()'
  inline public static function fromB41 (code : String) : String {
    return Cryp.b2s(code);
  }

  /// Encode [text] in B41
  inline public static function toB41 (text : String) : String {
    return Cryp.s2b(text);
  }

  /// Indicates if text[0] is a space. if text length is 0, returns false.
  public static function isSpace (text : String) : Bool {
    return (text.length == 0)? false : StringTools.isSpace (text, 0);
  }

  /// Indicates if text[0] is a letter or '_'.
  /// if text length is 0, returns false.
  public static function isLetter (text : String) : Bool {
    if (text.length == 0) return false;

    var ch = text.charAt(0);
    return (ch >= "a" && ch <= "z") || (ch >= "A" && ch <= "Z" || ch == "_");
  }

  /// Indicates if text[0] is a digit. if text length is 0, returns false.
  public static function isDigit (text : String) : Bool {
    if (text.length == 0) return false;

    var ch = text.charAt(0);
    return (ch >= "0" && ch <= "9");
  }

  /// Indicates if text[0] is a letter, '_' or digit.
  /// if text length is 0, returns false.
  public static function isLetterOrDigit (text : String) : Bool {
    return isLetter (text) || isDigit (text);
  }

  /// Returns the index of first match of a character of [text] with
  /// whatever character of [match], or -1 if it has not match.
  public static function index (text, match : String) : Int {
    var lg = text.length;
    var ix = 0;
    while (ix < lg) {
      if (match.indexOf (text.charAt (ix)) != -1) return ix;
      ++ix;
    }
    return -1;
  }

  /// Returns s1 < s2 ? -1 : s1 > s2 ? 1 : 0;
  public static function compare (s1, s2 : String) : Int {
    return s1 < s2 ? -1 : s1 > s2 ? 1 : 0;
  }

  /// Returns s1 < s2 ? -1 : s1 > s2 ? 1 : 0; in locale
  public static function localeCompare (s1, s2 : String) : Int {
    return untyped __js__("s1.localeCompare(s2);");
  }

  /**
  Returns one new string, that is a substring of [s].
  Result includes the character [begin] and excludes the
  character [end]. If 'begin < 0' or 'end < 0' they are converted to
  's.length+begin' or 's.length+end'.<p>
  Next rules are applied in turn:
    If 'begin < 0' or 'end < 0' they are converted to 's.length+begin' or
       's.length+end'.
    If 'begin < 0' it is converted to '0'.
    If 'end > s.length' it is converted to 's.length'.
    If 'end <= begin' then returns a empty string.
  If prarameter [end] is missing, the return is equals to
  'sub(s, 0, begin)'.<p>
  <b>Parameters:</b>
    s      : String for extracting a substring.
    begin  : Position of first character, inclusive.
    end    : Position of last character, exclusive. It can be missing.
    return : A substring of [s]
  */
  public static function sub (s : String, begin : Int, ?end : Int) : String {
    if (end == null) end = s.length;
    var lg = s.length;
    if (begin < 0) begin += lg;
    if (end < 0) end += lg;
    if (begin < 0) begin = 0;
    if (end > lg) end = lg;
    if (end <= begin) return "";
    return s.substring (begin, end);
  }

  /// Returns 's' repeated 'times' times
  public static function repeat (s : String, times : Int):String {
    var bf = new StringBuf();
    for (n in 0 ... times) {
      bf.add(s);
    }
    return bf.toString();
  }

  /// Replace using a regular expression
  inline public static function replace(
    s:String, exp:EReg, repl:String)
  :String {
    return exp.replace(s, repl);
  }

  /// Remove starting and trailing spaces
  inline public static function trim(s:String):String {
    return StringTools.trim(s);
  }

  /// Returns 'true' if 's' starts with 'sub'
  inline public static function startsWith(s:String, sub:String):Bool {
    return StringTools.startsWith(s, sub);
  }

  /// Returns 'true' if 's' ends with 'sub'
  inline public static function endsWith(s:String, sub:String):Bool {
    return StringTools.endsWith(s, sub);
  }

}

/// Implements a buffer that alows to delete its contents.<p>
/// Adds function [clear()] and variable [length] to interface of [StringBuf]
class StrBf {
  /// To calculate length is need to convert [this] to String!
  public var length (get_length, null) : Int;
  function get_length () : Int {
    return bf.toString ().length;
  }
  var bf : StringBuf;

  ///
  inline public function new () {
    bf = new StringBuf ();
  }

  ///
  inline public function add (x : Dynamic) : Void {
    bf.add (x);
  }

  ///
  inline public function addChar (c : Int) : Void {
    bf.addChar (c);
  }

  ///
  inline public function addSub (s : String, pos : Int, ?len : Int) : Void {
    bf.addSub (s, pos, len);
  }

  ///
  inline public function toString () : String {
    return bf.toString ();
  }

  ///
  inline public function clear () : Void {
    bf = new StringBuf ();
  }
}
