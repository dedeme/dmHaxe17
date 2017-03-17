/*
 * Copyright 12-Mar-2017 ºDeme
 * GNU General Public License - V3 <http://www.gnu.org/licenses/>
 */

package text;

import dm.It;
using dm.Str;
import text.Model;
import text.Util;

private enum CodeProcessorStates {
  InCode;
  ShortComment;
  LongComment;
  Quote1;
  Quote1Bar;
  Quote2;
  Quote2Bar;
  Number;
  Reserved;
  Klass;
}

private class CodeProcessor {
  public var leftBuffer (default, null) : StringBuf;
  public var rightBuffer (default, null) : StringBuf;
  var tmpBuffer : StringBuf;
  var container : String;
  var counter : Int;
  var state : CodeProcessorStates;

  public function new () {
    leftBuffer = new StringBuf ();
    rightBuffer = new StringBuf ();
    tmpBuffer = new StringBuf ();
    container = "";
    counter = 0;
    state = InCode;
  }

  function formatN (n : Int) : String {
    var r = Std.string (n);
    return if (r.length < 4) "    ".substring(r.length) + r else r;
  }


  public function process (line : String) {
    var reserved = " break callback case cast catch class continue default "
    + "do dynamic else enum extends extern false for function if implements "
    + "import in inline interface macro never new null override package "
    + "private public return static super switch this throw trace true try "
    + "typedef untyped using var while ";
    var reservedContainer = " class interface enum typedef abstract ";
    var reservedAnchor = " var function ";
    var l = StringTools.htmlEscape (line + "\n");
    var lg1 = l.length - 1;

    var previousReserved = "-";
    var anchor = "";
    var ch = " ";
    var ch1 = "";
    var skip = false;
    for (i in 0 ... l.length) {
      if (skip) {
        skip = false;
        continue;
      }
      ch = l.charAt(i);
      if (ch == " ") {
        ch = "&nbsp;";
      }
      ch1 = if (i < lg1) ch1 = l.charAt (i+1) else ch1 = "";
      if (state == InCode) {
        if (ch == "/" && (ch1 == "/" || ch1 == "*")) {
          if (ch1 == "/") {
            state = ShortComment;
            if (l.substring(i, i + 3) == "///") {
              rightBuffer.add ("<span class='docComment'>//");
            } else {
              rightBuffer.add ("<span class='comment'>//");
            }
            skip = true;
          } else {
            state = LongComment;
            if (l.substring(i, i + 3) == "/**") {
              rightBuffer.add ("<span class='docComment'>/*");
            } else {
              rightBuffer.add ("<span class='comment'>/*");
            }
            skip = true;
          }
        } else if (ch == "'") {
          state = Quote1;
          rightBuffer.add ("<span class='quote1'>'");
        } else if (ch == '"') {
          state = Quote2;
          rightBuffer.add ("<span class='quote2'>\"");
        } else if (Str.isLetter (ch)) {
          if (ch.toLowerCase () == ch) {
            state = Reserved;
            tmpBuffer = new StringBuf ();
            tmpBuffer.add (ch);
          } else {
            state = Klass;
            tmpBuffer = new StringBuf ();
            tmpBuffer.add (ch);
          }
        } else if (Str.isDigit (ch)) {
          state = Number;
          rightBuffer.add ("<span class='number'>");
          rightBuffer.add (ch);
        } else {
          rightBuffer.add(ch);
        }
      } else if (state == ShortComment) {
        if (ch1 == "") {
          state = InCode;
          rightBuffer.add (ch);
          rightBuffer.add ("</span>");
        } else {
          rightBuffer.add (ch);
        }
      } else if (state == LongComment) {
        if (ch == "*" && ch1 == "/") {
            state = InCode;
            rightBuffer.add ("*/</span>");
            skip = true;
        } else {
          rightBuffer.add (ch);
        }
      } else if (state == Quote1) {
        if (ch == "\\") {
          state = Quote1Bar;
        } else if (ch == "'") {
          state = InCode;
          rightBuffer.add ("'</span>");
        } else {
          rightBuffer.add (ch);
        }
      } else if (state == Quote1Bar) {
        rightBuffer.add ("\\" + ch);
        state = Quote1;
      } else if (state == Quote2) {
        if (ch == "\\") {
          state = Quote2Bar;
        } else if (ch == "\"") {
          state = InCode;
          rightBuffer.add ("\"</span>");
        } else {
          rightBuffer.add (ch);
        }
      } else if (state == Quote2Bar) {
        rightBuffer.add ("\\" + ch);
        state = Quote2;
      } else if (state == Number) {
        if (Str.isDigit (ch) || ch == ".") {
          rightBuffer.add (ch);
        } else {
          state = InCode;
          rightBuffer.add ("</span>");
          rightBuffer.add (ch);
        }
      } else if (state == Reserved) {
        if (Str.isLetterOrDigit (ch)) {
          tmpBuffer.add (ch);
        } else {
          state = InCode;
          var tmp = tmpBuffer.toString ();
          if (reserved.indexOf (" " + tmp + " ") != -1) {
            rightBuffer.add ("<span class='reserved'>");
            rightBuffer.add (tmp);
            rightBuffer.add ("</span>");
            if (tmp == "new" && previousReserved == " function ") {
              anchor = "hp:" + container + "." + tmp;
              previousReserved = "-";
            } else {
              previousReserved = " " + tmp + " ";
            }
          } else {
            rightBuffer.add (tmp);
            if (reservedContainer.indexOf (previousReserved) != -1) {
              container = tmp;
              anchor = "hp:" + tmp;
            } else if (reservedAnchor.indexOf (previousReserved) != -1) {
              anchor = "hp:" + container + "." + tmp;
            }
            previousReserved = "-";
          }
          rightBuffer.add (ch);
        }
      } else if (state == Klass) {
        if (Str.isLetterOrDigit (ch)) {
          tmpBuffer.add (ch);
        } else {
          state = InCode;
          var tmp = tmpBuffer.toString ();
            rightBuffer.add ("<span class='className'>");
            rightBuffer.add (tmp);
            rightBuffer.add ("</span>");
          rightBuffer.add (ch);
            if (reservedContainer.indexOf (previousReserved) != -1) {
              container = tmp;
              anchor = "hp:" + tmp;
            } else if (reservedAnchor.indexOf (previousReserved) != -1) {
              anchor = "hp:" + container + "." + tmp;
            }
            previousReserved = "-";
        }
      }
    }
    rightBuffer.add ("<br>");

    if (anchor != "") {
      leftBuffer.add ("<span id='" + anchor + "'></span>");
      anchor = "";
    }
    leftBuffer.add (
      "<a href='#' style='font-family: monospace;font-size: 12px;background-color: rgb(215, 215, 215);color: #998866;'>" +
      StringTools.replace(formatN (++counter), " ", "&nbsp;") +
      "</a>"
    );
    leftBuffer.add ("<br>");
  }

}


class MkCode {

  public static function run(tx:String):String {
    var formatN = function (n : Int) : String {
      var r = Std.string (n);
      return if (r.length < 4) "    ".substring(r.length) + r else r;
    }

    var lines = tx.split ("\n");
    var processor = new CodeProcessor ();
    for (l in lines) {
      processor.process(l);
    }

    return "<table border='0' width='100%' cellspacing='0'>"
    + "<tr><td class='prel' width='10px'>"
    + processor.leftBuffer.toString ()
    + "</td><td class='prer'>"
    + processor.rightBuffer.toString ()
    + "</td></tr></table>"
    ;
  }
}
