/*
 * Copyright 15-Mar-2017 ºDeme
 * GNU General Public License - V3 <http://www.gnu.org/licenses/>
 */

import dm.Ui;
import dm.It;
import text.MkModule;
import Fields;
import ModuleCm;

/// Module help
class Module {
  /// Entry point
  public static function main() {
    var client = Global.client();
    var path = Ui.url().get("0");

    var ix = path.indexOf("#");
    if (ix != -1) {
      path = path.substring(0, ix);
    }

    client.send("module/index.js", "readFile", path, function (rp:PageRp) {
      if (rp.error) Dom.go("../main/index.html");

      ModuleView.show(
        client,
        It.from(rp.packs).map(It.f(PathsData.restore(_1))).to(),
        rp.selected,
        MkModule.run(rp.path, rp.page)
      );
    });
  }
}
