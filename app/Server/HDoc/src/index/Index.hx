/*
 * Copyright 10-Mar-2017 ºDeme
 * GNU General Public License - V3 <http://www.gnu.org/licenses/>
 */

import dm.It;
import dm.Ui;
import IndexCm;
import Fields;

/// Index of files
class Index {
  /// Entry point
  public static function main() {
    var client = Global.client();
    var pack = Ui.url().get("0");

    client.send("index/index.js", "list", pack, function (rp:ListRp) {
      if (rp.error) Dom.go("../main/index.html");

      IndexView.show(
        client,
        It.from(rp.packs).map(It.f(PathsData.restore(_1))).to(),
        pack,
        IndexEntry.restore(rp.tree).tree
      );
    });
  }
}
