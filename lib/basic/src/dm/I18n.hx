/*
 * Copyright 04-Mar-2016 ºDeme7
 * GNU General Public License - V3 <http://www.gnu.org/licenses/>
 */

/// Utility for translations
package dm;

import dm.It;

/**
 * This class should be used:
 *   1. Creating o generating a file like:
 *     class I18nData {
 *       public static function en ():String {
 *         return "" +
 *           "Change = Change\n" +
 *           ...
 *       }
 *       public static function es ():String {
 *         return "" +
 *           "Change = Cambiar\n" +
 *           ...
 *       }
 *     }
 *   2. When a application is started it is necessary to call 'init()':
 *     ...
 *     var tx = vars.conf().lang() == "en" ? I18nData.en() : I18nData.es();
 *     I18n.init(tx.split("\n"));
 *     ...
 *   3. Afther that it is possible to call '_()'.
 * 'format()' is a helper function for working with templates.
 */
class I18n {

  static var dic:Map<String, String>;

  /// Initializes dictionary
  public static function init (text : Array<String>) {
    dic = new Map();
    It.from(text).each(function (l) {
      l = StringTools.ltrim(l);
      if (l == "" || l.charAt(0) == "#") {
        return;
      }
      var ix = l.indexOf("=");
      if (ix == -1) {
        return;
      }
      dic.set(
        StringTools.rtrim(l.substring(0, ix)),
        StringTools.replace(
          StringTools.ltrim(l.substring(ix + 1)),
          "\\n", "\n")
      );
    });
  }

  /// Helper function for working with templates
  public static function format (template:String, args:Array<String>):String {
    var bf = new StringBuf ();
    var isCode = false;
    var c = 0;

    for (ix in 0 ... template.length) {
      var ch = template.charAt (ix);
      if (isCode) {
        switch ch {
          case "0" : bf.add (args[0]);
          case "1" : bf.add (args[1]);
          case "2" : bf.add (args[2]);
          case "3" : bf.add (args[3]);
          case "4" : bf.add (args[4]);
          case "5" : bf.add (args[5]);
          case "6" : bf.add (args[6]);
          case "7" : bf.add (args[7]);
          case "8" : bf.add (args[8]);
          case "9" : bf.add (args[9]);
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

  /// Call to dictionary
  public static function _ (key:String) : String {
    var v = dic.get(key);

    return (v == null) ? key : v;
  }
}
