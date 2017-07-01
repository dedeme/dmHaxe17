/*
 * Copyright 23-Jun-2017 ºDeme
 * GNU General Public License - V3 <http://www.gnu.org/licenses/>
 */

import dm.Ui;
import dm.Ui.Q;
import dm.I18n._;
import dm.I18n;
import dm.CClient;
import lib.Dom0;

/// Good By page.
class By {
  ///
  public function new(client:CClient):Void {
    var appName = client.appName;
    client.close();
    Dom0.show(
        Q("div")
          .add(Q("div").klass("title").html('&nbsp;<br>$appName<br>&nbsp;'))
          .add(Q("div")
            .add(Q("table")
              .att("class", "border")
              .att("width", "100%")
              .att("style",
                "background-color: #f8f8f8;" +
                "border-collapse: collapse;")
              .add(Q("tr")
                .add(Q("td")
                  .att("style", "padding:0px 10px 0px 10px;")
                  .html(I18n.format(_("Logout-message"), [appName]))))))
      );
  }
}
