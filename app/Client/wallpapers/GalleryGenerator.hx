/*
 * Copyright 25-Aug-2017 ºDeme
 * GNU General Public License - V3 <http://www.gnu.org/licenses/>
 */

import dm.It;
import dm.Io;

class GalleryGenerator {
  public static function main() {
    var source = "www/stock";
    var target = "src/view/GalleryAux.hx";
    var tx = "" +
      "// File automatically generated by GalleryGenerator.hx.\n" +
      "// DON'T MODIFY.\n\n" +
      "package view;\n\n" +
      "class GalleryAux{\n" +
      "  public static function getData():Map<String, Array<String>> {\n" +
      "    var r = new Map<String, Array<String>>();\n";

    It.from(Io.dir(source)).sort(function (s1, s2) {
      var ss1 = s1.toUpperCase();
      var ss2 = s2.toUpperCase();
      return ss1 == ss2 ? 0 : ss1 < ss2 ? -1 : 1;
    }).each(function (d) {
      var dir = Io.cat([source, d]);
      if (Io.isDirectory(dir)) {
        tx += "" +
          "    r.set(\"" + d + "\", [\n";
        var first = true;

        It.from(Io.dir(dir)).filter(function (f) {
          return Io.exists(Io.cat([dir, f + ".png"]));
        }).sort(function (s1, s2) {
          var ss1 = s1.toUpperCase();
          var ss2 = s2.toUpperCase();
          return ss1 == ss2 ? 0 : ss1 < ss2 ? -1 : 1;
        }).each(function (f) {
          if (first) {
            first = false;
          } else {
            tx += ",\n";
          }
          var file = Io.cat([dir, f]);
          tx += "      \"" + f + "\"";
        });
        tx += "\n    ]);\n";

      }
    });

    tx += "    return r;\n" +
      "  }\n" +
      "}\n";

    Io.write(target, tx);
  }
}