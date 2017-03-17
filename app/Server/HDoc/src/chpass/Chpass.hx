/*
 * Copyright 09-Mar-2017 ºDeme
 * GNU General Public License - V3 <http://www.gnu.org/licenses/>
 */

/// Change password main file.
import dm.Client;
import dm.I18n._;
import dm.Cryp;
import Fields;
import ChpassCm;

/// Entry class
class Chpass {
  var client:Client;
  var view:ChpassView;

  public function new() {
    client = Global.client();
  }

  ///
  public static function main() {
    var chpass = new Chpass();
    chpass.client.send("lib/index.js", "getConf", {}, function (rp:Dynamic) {
      var conf = ConfEntry.restore(rp[0]);
      Global.setLanguage(conf.lang);

      chpass.view = new ChpassView(chpass);
      chpass.view.show();
    });
  }

  public function accept() {
    var Model = ChpassModel;

    if (Model.oldPass == "") {
      js.Browser.alert(_("Current password is missing"));
      view.pass.value("");
      view.pass.e.focus();
      return;
    }
    if (Model.newPass == "") {
      js.Browser.alert(_("New password is missing"));
      view.newPass.value("");
      view.newPass.e.focus();
      return;
    }
    if (Model.newPass2 == "") {
      js.Browser.alert(_("Confirm password is missing"));
      view.newPass2.value("");
      view.newPass2.e.focus();
      return;
    }
    if (Model.newPass != Model.newPass2) {
      js.Browser.alert(_("New password and confirm password do not match"));
      view.newPass.value("");
      view.newPass2.value("");
      view.newPass.e.focus();
      return;
    }

    client.send(
      "chpass/index.js",
      "changePass",
      {
        user    : client.getUser(),
        oldPass : Cryp.key(Model.oldPass, 120),
        newPass : Cryp.key(Model.newPass, 120)
      },
      function (rp:ChRp) {
        if (rp.success) {
          js.Browser.alert(_("Password successfully changed"));
          view.resetCounter();
          js.Browser.location.assign("../conf/index.html");
        } else {
          view.incCounter();
          js.Browser.location.assign("../chpass/index.html");
        }
      }
    );

  }
}
