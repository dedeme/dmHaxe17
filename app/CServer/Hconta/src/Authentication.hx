/*
 * Copyright 24-May-2017 ºDeme
 * GNU General Public License - V3 <http://www.gnu.org/licenses/>
 */

/// Authentication page

import dm.Ui;
import dm.Ui.Q;
import dm.DateDm;
import dm.Captcha;
import dm.Store;
import dm.I18n;
import dm.I18n._;
import dm.It;
import dm.Cryp;
import dm.CClient;
import lib.Dom0;
import I18nData;

class Authentication {
  // Model -----------------------------
  var executable:String;
  var appName:String;
  var langStore:String;
  var lang:String;
  var captcha:Captcha;

  // View ------------------------------

  function show(appName) {
    var user = Ui.field("pass");
    var pass = Ui.pass("accept").att("id", "pass");
    var persistent = Q("input")
      .att("type", "checkbox")
      .style("vertical-align: middle");
    var accept = Q("input")
      .att("type", "button")
      .style("width:90px;")
      .att("id", "accept");

    accept.value(_("Accept"));
    accept.on(CLICK, function (ev) {
      if (captcha.counter > captcha.counterLimit) {
        if (!captcha.match()) {
          Ui.alert(_("Grey squares checks are wrong"));
          Main.main();
          return;
        }
      }

      faccept(
        user.getValue().trim(),
        pass.getValue().trim(),
        persistent.getChecked()
      );

      user.value("");
      pass.value("");
      persistent.checked(false);
    });

    var rows = [
      Q("tr")
        .add(Q("td")
          .style("padding: 10px 0px 0px 10px;text-align:right;")
          .html(_("User")))
        .add(Q("td").style("padding: 10px 10px 0px 10px;").add(user)),
      Q("tr")
        .add(Q("td")
          .style("padding: 10px 0px 0px 10px;text-align:right;")
          .html(_("Password")))
        .add(Q("td").style("padding: 10px 10px 5px 10px;").add(pass)),
      Q("tr")
        .add(Q("td")
          .att("colspan", 2)
          .style('border-top:1px solid #c9c9c9;' +
            "padding: 5px 10px 10px;text-align:right;")
          .add(Q("table")
            .style(
              "border-collapse : collapse;" +
              "border : 0px;" +
              "width : 100%;")
            .add(Q("tr")
              .add(Q("td").att("align", "center").att("colspan", 2)
                .add(persistent)
                .add(Q("span").html("&nbsp;" + _("Keep connected")))))
            .add(Q("tr")
              .add(Q("td")
                .add(Ui.link(changeLanguage).att("class", "link")
                  .html(lang == "en" ? "ES" : "EN")))
              .add(Q("td").att("align", "right").add(accept)))))
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
                .add(Q("td").html(_("Wrong password"))))))
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

    Dom0.show(
      Q("div")
        .add(Q("div").klass("title").html('&nbsp;<br>$appName<br>&nbsp;'))
        .add(Q("div")
          .add(Q("table")
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
                .html("<big><big><b>" + _("Login") + "</big></big></b>")))
            .addIt(It.from(rows))))
    );
    user.e.focus();
  }

  // Control ---------------------------

  /// Makes an authentication page
  ///   exec: Path to 'c' executable (e.g. /home/app/hconta/bin/hconta)
  ///   appN: Application name
  ///   languageKey
  public function new(exec:String, appN:String, languageKey:String) {
    executable = exec;
    appName = appN;
    langStore = languageKey;
    lang = Store.get(languageKey);
    lang = lang == null ? "en" : lang;
    captcha = new Captcha("Hconta__Captcha", 2);

    setDictionay();

    show(appN);
  }

  function faccept(u:String, p:String, persistent:Bool) {
    var expiration = persistent ? 2592000 : 900;

    if (u == "") {
      Ui.alert(_("User name is missing"));
      new Authentication(executable, appName, langStore);
      return;
    }
    if (p == "") {
      Ui.alert(_("Password is missing"));
      new Authentication(executable, appName, langStore);
      return;
    }

    p = Cryp.key(p, 120);

    CClient.authentication(
      executable,
      appName,
      u,
      p,
      expiration,
      function (ok) {
        if (ok) {
          captcha.resetCounter();
        } else {
          captcha.incCounter();
        }
        js.Browser.location.assign("");
      }
    );
  }

  function changeLanguage(ev:Dynamic) {
    lang = lang == "en" ? "es" : "en";
    Store.put(langStore, lang);
    setDictionay();
    new Authentication(executable, appName, langStore);
  }

  function setDictionay() {
    var dic = lang == "en" ? I18nData.en() : I18nData.es();
    I18n.init(dic);
  }

}
