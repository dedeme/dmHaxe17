/*
 * Copyright 07-Mar-2017 ºDeme
 * GNU General Public License - V3 <http://www.gnu.org/licenses/>
 */

import dm.Client;
import dm.I18n._;
import dm.Cryp;
import Global;

/// Entry class
class Auth {
  var client:Client;
  var view:AuthView;

  public function new() {
    client = Global.client();
  }

  /// Entry point
  public static function main() {
    Global.setLanguage(Global.getLanguage());
    var auth = new Auth();
    auth.view = new AuthView(auth);
    auth.view.show();
  }

  /// Change language selected
  public function changeLanguage(ev:Dynamic) {
    Global.getLanguage() == "en"
      ? Global.setLanguage("es")
      : Global.setLanguage("en");
    main();
  }

  /// Accept button pressed
  public function accept() {
    if (AuthModel.user == "") {
      js.Browser.alert(_("User name is missing"));
      return;
    }
    if (AuthModel.pass == "") {
      js.Browser.alert(_("Password is missing"));
      return;
    }
    client.authSend(
      "auth/index.js",
      "authentication",
      new AuthRequest(
        AuthModel.user,
        Cryp.key(AuthModel.pass, 120),
        AuthModel.persistent
      ),
      function () {
        if (client.getSessionId() == "") {
          view.incCounter();
          js.Browser.location.assign("../auth/index.html");
        } else {
          view.resetCounter();
          js.Browser.location.assign("../main/index.html");
        }
      }
    );
  }

}
