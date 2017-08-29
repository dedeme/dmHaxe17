/*
 * Copyright 04-Mar-2016 ºDeme
 * GNU General Public License - V3 <http://www.gnu.org/licenses/>
 */

import dm.Test;
import dm.Cryp;
import dm.Str;
import dm.Tuple;
import dm.It;

class StrTest {
  public static function run () {
    var t = new Test("Str");

    t.tests([
      new Tp2("  ", ""),
      new Tp2(" a", "a"),
      new Tp2("a   ", "a"),
      new Tp2("\na\t\t", "a"),
      new Tp2(" \na n c\t\t ", "a n c")
    ], StringTools.trim);

    t.eq("a22c", Str.format("a%sc", ["22"]));
    t.eq("a22%1c", Str.format("a%s%1c", ["22"]));
    t.eq("a22c", Str.format("a%vc", [22]));
    t.eq("a[22,12]c", Str.format("a%vc", [[22, 12]]));
    t.eq("ac", Str.format("a%sc", [""]));
    t.eq("a1c2", Str.format("a%vc%v", [1, 2]));
    t.eq("2a1c", Str.format("%va%vc", [2, 1]));

    t.eq("", StringTools.trim(" \n\t "));
    t.eq("", StringTools.ltrim(" \n\t "));
    t.eq("", StringTools.rtrim(" \n\t "));

    t.eq("abc", StringTools.trim(" \nabc\t "));
    t.eq("abc\t ", StringTools.ltrim(" \nabc\t "));
    t.eq(" \nabc", StringTools.rtrim(" \nabc\t "));

    t.yes(StringTools.startsWith("", ""));
    t.yes(StringTools.startsWith("abc", ""));
    t.yes(!StringTools.startsWith("", "abc"));
    t.yes(StringTools.startsWith("abc", "a"));
    t.yes(StringTools.startsWith("abc", "abc"));
    t.yes(!StringTools.startsWith("abc", "b"));

    t.yes(StringTools.endsWith("", ""));
    t.yes(StringTools.endsWith("abc", ""));
    t.yes(!StringTools.endsWith("", "abc"));
    t.yes(StringTools.endsWith("abc", "c"));
    t.yes(StringTools.endsWith("abc", "abc"));
    t.yes(!StringTools.endsWith("abc", "b"));

    var arr = ["pérez", "pera", "p zarra", "pizarra"];
    var arr2 = It.from(arr).sort(Str.compare).to();
    t.eq(["p zarra", "pera", "pizarra", "pérez"].toString(), arr2.toString());
    arr2 = It.from(arr).sort(Str.localeCompare).to();
    t.eq(["p zarra", "pera", "pérez", "pizarra"].toString(), arr2.toString());

    t.eq ("a b", Str.replace("a  \t\n  b", ~/\s+/g, " "));

    t.log();

    // Old tests
    t = new Test("Str-old");

    t.eq (Str.cutLeft ("", 3), "");
    t.eq (Str.cutLeft ("ab", 3), "ab");
    t.eq (Str.cutLeft ("abcde", 4), "...e");
    t.eq (Str.cutLeft ("abcd", 3), "...");
    t.eq (Str.cutLeft ("abcd", 1), "...");

    t.eq (Str.cutRight ("", 3), "");
    t.eq (Str.cutRight ("ab", 3), "ab");
    t.eq (Str.cutRight ("abcde", 4), "a...");
    t.eq (Str.cutRight ("abcd", 3), "...");
    t.eq (Str.cutRight ("abcd", 1), "...");

    t.eq (Str.html ("a'bc<"), "a&#039;bc&lt;");

    t.yess ([
      !Str.isSpace ("")
    , Str.isSpace (" ")
    , !Str.isSpace ("v")
    , !Str.isSpace ("_")
    , !Str.isSpace ("2")
    , !Str.isSpace (".")
    , !Str.isSpace ("v-")
    , !Str.isSpace ("_-")
    , !Str.isSpace ("2-")
    , !Str.isSpace (".-")
    ]);

    t.yess ([
      !Str.isLetter ("")
    , !Str.isLetter (" ")
    , Str.isLetter ("v")
    , Str.isLetter ("_")
    , !Str.isLetter ("2")
    , !Str.isLetter (".")
    , Str.isLetter ("v-")
    , Str.isLetter ("_-")
    , !Str.isLetter ("2-")
    , !Str.isLetter (".-")
    ]);

    t.yess ([
      !Str.isDigit ("")
    , !Str.isDigit (" ")
    , !Str.isDigit ("v")
    , !Str.isDigit ("_")
    , Str.isDigit ("2")
    , !Str.isDigit (".")
    , !Str.isDigit ("v-")
    , !Str.isDigit ("_-")
    , Str.isDigit ("2-")
    , !Str.isDigit (".-")
    ]);

    t.yess ([
      !Str.isLetterOrDigit ("")
    , !Str.isLetterOrDigit (" ")
    , Str.isLetterOrDigit ("v")
    , Str.isLetterOrDigit ("_")
    , Str.isLetterOrDigit ("2")
    , !Str.isLetterOrDigit (".")
    , Str.isLetterOrDigit ("v-")
    , Str.isLetterOrDigit ("_-")
    , Str.isLetterOrDigit ("2-")
    , !Str.isLetterOrDigit (".-")
    ]);

    t.eq (Str.format ("%v: %s", [33, "therty three"]), "33: therty three");
    t.eq (Str.format ("%v: %s", [new dm.Dec (33.345, 2), "therty three"])
    , "33.35: therty three");
    t.eq (Str.format ("%v: %v"
      , [new dm.Dec (33, 2), dm.DateDm.fromStr("20121232").toString()]
      ), "33.00: 01/01/2013"
    );

    t.eq (Str.sub ("", -100), "");
    t.eq (Str.sub ("", -2), "");
    t.eq (Str.sub ("", 0), "");
    t.eq (Str.sub ("", 2), "");
    t.eq (Str.sub ("", 100), "");
    t.eq (Str.sub ("a", -100), "a");
    t.eq (Str.sub ("a", -2), "a");
    t.eq (Str.sub ("a", 0), "a");
    t.eq (Str.sub ("a", 2), "");
    t.eq (Str.sub ("a", 100), "");
    t.eq (Str.sub ("12345", -100), "12345");
    t.eq (Str.sub ("12345", -2), "45");
    t.eq (Str.sub ("12345", 0), "12345");
    t.eq (Str.sub ("12345", 2), "345");
    t.eq (Str.sub ("12345", 100), "");

    t.eq (Str.sub ("", -100, -100), "");
    t.eq (Str.sub ("", -2, -100), "");
    t.eq (Str.sub ("", 0, -100), "");
    t.eq (Str.sub ("", 2, -100), "");
    t.eq (Str.sub ("", 100, -100), "");

    t.eq (Str.sub ("", -100, -2), "");
    t.eq (Str.sub ("", -2, -2), "");
    t.eq (Str.sub ("", 0, -2), "");
    t.eq (Str.sub ("", 2, -2), "");
    t.eq (Str.sub ("", 100, -2), "");

    t.eq (Str.sub ("", -100, 0), "");
    t.eq (Str.sub ("", -2, 0), "");
    t.eq (Str.sub ("", 0, 0), "");
    t.eq (Str.sub ("", 2, 0), "");
    t.eq (Str.sub ("", 100, 0), "");

    t.eq (Str.sub ("", -100, 2), "");
    t.eq (Str.sub ("", -2, 2), "");
    t.eq (Str.sub ("", 0, 2), "");
    t.eq (Str.sub ("", 2, 2), "");
    t.eq (Str.sub ("", 100,2), "");

    t.eq (Str.sub ("", -100, 100), "");
    t.eq (Str.sub ("", -2, 100), "");
    t.eq (Str.sub ("", 0, 100), "");
    t.eq (Str.sub ("", 2, 100), "");
    t.eq (Str.sub ("", 100, 100), "");

    t.eq (Str.sub ("a", -100, -100), "");
    t.eq (Str.sub ("a", -2, -100), "");
    t.eq (Str.sub ("a", 0, -100), "");
    t.eq (Str.sub ("a", 2, -100), "");
    t.eq (Str.sub ("a", 100, -100), "");

    t.eq (Str.sub ("a", -100, -2), "");
    t.eq (Str.sub ("a", -2, -2), "");
    t.eq (Str.sub ("a", 0, -2), "");
    t.eq (Str.sub ("a", 2, -2), "");
    t.eq (Str.sub ("a", 100, -2), "");

    t.eq (Str.sub ("a", -100, 0), "");
    t.eq (Str.sub ("a", -2, 0), "");
    t.eq (Str.sub ("a", 0, 0), "");
    t.eq (Str.sub ("a", 2, 0), "");
    t.eq (Str.sub ("a", 100, 0), "");

    t.eq (Str.sub ("a", -100, 2), "a");
    t.eq (Str.sub ("a", -2, 2), "a");
    t.eq (Str.sub ("a", 0, 2), "a");
    t.eq (Str.sub ("a", 2, 2), "");
    t.eq (Str.sub ("a", 100,2), "");

    t.eq (Str.sub ("a", -100, 100), "a");
    t.eq (Str.sub ("a", -2, 100), "a");
    t.eq (Str.sub ("a", 0, 100), "a");
    t.eq (Str.sub ("a", 2, 100), "");
    t.eq (Str.sub ("a", 100, 100), "");

    t.eq (Str.sub ("12345", -100, -100), "");
    t.eq (Str.sub ("12345", -2, -100), "");
    t.eq (Str.sub ("12345", 0, -100), "");
    t.eq (Str.sub ("12345", 2, -100), "");
    t.eq (Str.sub ("12345", 100, -100), "");

    t.eq (Str.sub ("12345", -100, -2), "123");
    t.eq (Str.sub ("12345", -2, -2), "");
    t.eq (Str.sub ("12345", 0, -2), "123");
    t.eq (Str.sub ("12345", 2, -2), "3");
    t.eq (Str.sub ("12345", 100, -2), "");

    t.eq (Str.sub ("12345", -100, 0), "");
    t.eq (Str.sub ("12345", -2, 0), "");
    t.eq (Str.sub ("12345", 0, 0), "");
    t.eq (Str.sub ("12345", 2, 0), "");
    t.eq (Str.sub ("12345", 100, 0), "");

    t.eq (Str.sub ("12345", -100, 2), "12");
    t.eq (Str.sub ("12345", -2, 2), "");
    t.eq (Str.sub ("12345", 0, 2), "12");
    t.eq (Str.sub ("12345", 2, 2), "");
    t.eq (Str.sub ("12345", 100,2), "");

    t.eq (Str.sub ("12345", -100, 100), "12345");
    t.eq (Str.sub ("12345", -2, 100), "45");
    t.eq (Str.sub ("12345", 0, 100), "12345");
    t.eq (Str.sub ("12345", 2, 100), "345");
    t.eq (Str.sub ("12345", 100, 100), "");

    t.log();

  }
}
