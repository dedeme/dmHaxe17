/*
 * Copyright 07-Mar-2017 ºDeme
 * GNU General Public License - V3 <http://www.gnu.org/licenses/>
 */

/**
 * Change password.<p>
 */
import dm.Ui;
import dm.Ui.Q;
import dm.DateDm;
import dm.Captcha;
import dm.Store;
import dm.I18n._;
import dm.It;
import dm.Cryp;
import dm.CClient;
import lib.Dom0;

class Chpass {
  // Model -----------------------------

  var client:CClient;
  var captcha:Captcha;

  // View ------------------------------

  function body() {
    var pass = Ui.pass("newPass").att("id", "pass");
    var newPass = Ui.pass("newPass2").att("id", "newPass");
    var newPass2 = Ui.pass("accept").att("id", "newPass2");

    var cancel = Q("input")
      .att("type", "button")
      .style("width:90px;")
      .att("id", "cancel")
      .value(_("Cancel"))
      .on(CLICK, fcancel);
    var accept = Q("input")
      .att("type", "button")
      .style("width:90px;")
      .att("id", "accept")
      .value(_("Accept"))
      .on(CLICK, function (ev) {
          if (captcha.counter > captcha.counterLimit) {
            if (!captcha.match()) {
              Ui.alert(_("Grey squares checks are wrong"));
              new Chpass(client);
              return;
            }
          }

          faccept(
            pass.getValue().trim(),
            newPass.getValue().trim(),
            newPass2.getValue().trim()
          );

          pass.value("");
          newPass.value("");
          newPass2.value("");
        });

    var rows = [
      Q("tr")
        .add(Q("td")
          .att("style", "padding: 10px 0px 0px 10px;text-align:right;")
          .html(_("Current password")))
        .add(Q("td").att("style", "padding: 10px 10px 0px 10px;")
          .add(pass.value(""))),
      Q("tr")
        .add(Q("td")
          .att("style", "padding: 5px 0px 0px 10px;text-align:right;")
          .html(_("New password")))
        .add(Q("td").att("style", "padding: 5px 10px 0px 10px;")
          .add(newPass.value(""))),
      Q("tr")
        .add(Q("td")
          .att("style", "padding: 5px 0px 10px 10px;text-align:right;")
          .html(_("Confirm password")))
        .add(Q("td").att("style", "padding: 5px 10px 10px 10px;")
          .add(newPass2.value(""))),
      Q("tr")
        .add(Q("td")
          .att("colspan", 2)
          .att("style",
            "border-top:1px solid #c9c9c9;" +
            "padding: 10px 10px 10px;text-align:right;")
          .add(Q("span")
            .add(cancel)
            .add(Q("span").text("  "))
            .add(accept)))
    ];

    if (captcha.counter > 0) {
      rows.push(
        Q("tr")
          .add(Q("td")
            .att("colspan", 2)
            .style('border-top:1px solid #c9c9c9;' +
              "padding: 10px 10px 10px;text-align:right;")
            .add(Q("table")
              .att("align", "center")
              .style("background-color: rgb(250, 250, 250);" +
                "border: 1px solid rgb(110,130,150);" +
                "font-family: sans;font-size: 14px;" +
                "padding: 4px;border-radius: 4px;")
              .add(Q("tr")
                .add(Q("td").html(_("Fail trying to change password"))))))
      );
    }

    if (captcha.counter > captcha.counterLimit) {
      rows.push(
        Q("tr")
          .add(Q("td").att("colspan", 2).att("align", "center")
            .add(captcha.make()))
      );
      rows.push(
        Q("tr")
          .add(Q("td")
            .att("colspan", 2)
            .style("padding: 5px 0px 5px 10px;text-align:center;")
            .html(_("Check gray squares")))
      );
    }

    return Q("table")
      .att("align", "center")
      .style(
        'background-color: #f8f8f8;' +
        "border-collapse: collapse;" +
        "padding: 10px;" +
        "border: 1px solid rgb(110,130,150);")
      .add(Q("tr")
        .add(Q("td")
          .att("colspan", 2)
          .style(
            'background-color:#e8e8e8;' +
            'border-bottom:1px solid #c9c9c9;' +
            "padding: 10px;" +
            'color:#505050;'
          )
          .html("<big><big><b>" + _("Change Password") + "</big></big></b>")))
      .addIt(It.from(rows))
      ;
  }

  function show() {
    Dom0.show(
      Q("div")
        .add(Q("div").klass("title")
          .html('&nbsp;<br>${client.appName}<br>&nbsp;'))
        .add(Q("div").add(body()))
    );
    Q("#pass").e.focus();
  }

  // Control ---------------------------

  public function new(client:CClient) {
    captcha = new Captcha("Hconta__Captcha_Chpass", 2);
    this.client = client;
    show();
  }

  function faccept(pass:String, newPass:String, newPass2:String) {
    if (pass == "") {
      Ui.alert(_("Current password is missing"));
      new Chpass(client);
      return;
    }
    if (newPass == "") {
      Ui.alert(_("New password is missing"));
      new Chpass(client);
      return;
    }
    if (newPass2 == "") {
      Ui.alert(_("Confirm password is missing"));
      new Chpass(client);
      return;
    }
    if (newPass != newPass2) {
      Ui.alert(_("Password and Confirm password do not match"));
      new Chpass(client);
      return;
    }

    client.chpass(Cryp.key(pass, 120), Cryp.key(newPass, 120), function (ok) {
      if (ok) {
        captcha.resetCounter();
        Ui.alert(_("Password successfully changed"));
        Main.main();
      } else {
        captcha.incCounter();
        new Chpass(client);
      }
    });
  }

  function fcancel(ev) {
    Main.start();
  }

}
