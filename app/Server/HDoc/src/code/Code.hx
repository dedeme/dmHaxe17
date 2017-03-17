/*
 * Copyright 17-Mar-2017 ºDeme
 * GNU General Public License - V3 <http://www.gnu.org/licenses/>
 */

import dm.Ui;
import dm.It;
import text.MkCode;
import Fields;
import CodeCm;

/// Generation of source code: Controler
class Code {
  /// Entry point
  public static function main() {
    var client = Global.client();
    var path = Ui.url().get("0");
    var anchor = Ui.url().get("1");

    client.send("code/index.js", "readFile", path, function (rp:PageRp) {
      if (rp.error) Dom.go("../main/index.html");

      CodeView.show(
        client,
        It.from(rp.packs).map(It.f(PathsData.restore(_1))).to(),
        rp.selected,
        rp.path,
        MkCode.run(rp.page),
        anchor
      );
    });
  }
}
