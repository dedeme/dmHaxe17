/*
 * Copyright 07-Mar-2017 ºDeme
 * GNU General Public License - V3 <http://www.gnu.org/licenses/>
 */

import dm.Ui;
import dm.Ui.Q;
import dm.DateDm;
import dm.Captcha;
import dm.Store;
import dm.I18n._;
import dm.It;
import Dom0;

class AuthView {
  var auth:Auth;

  // Captcha configuration ---------------------------------

  var storeId = "HDoc_auth";
  function getCounter():Int {
    function ret(n) {
      Store.put(storeId + "_counter", n);
      Store.put(storeId + "_time", Std.string(DateDm.now().toTime()));
      return Std.parseInt(n);
    }

    var c = Store.get(storeId + "_counter");
    if (c == null) return ret("0");

    var t = Std.parseInt(Store.get(storeId + "_time"));
    if (DateDm.now().toTime() - t > 900000) return ret("0");

    return Std.parseInt(c);
  }

  public function incCounter() {
    var c = Std.parseInt(Store.get(storeId + "_counter"));
    Store.put(storeId + "_counter", Std.string(c + 1));
    Store.put(storeId + "_time", Std.string(DateDm.now().toTime()));
  }

  public function resetCounter() {
    Store.del(storeId + "_counter");
    Store.del(storeId + "_time");
  }

  var counter:Int;
  var captcha = new Captcha();
  var counterLimit:Int = 2;

  // End captcha configuration -----------------------------

  var user = Ui.field("pass");
  var pass = Ui.pass("accept").att("id", "pass");
  var persistent = Q("input")
    .att("type", "checkbox")
    .style("vertical-align: middle");

  var accept = Q("input")
    .att("type", "button")
    .style("width:90px;")
    .att("id", "accept")
    .value(_("Accept"));

  public function new(auth:Auth) {
    this.auth = auth;

    captcha.zeroColor = "#f0f0f0";
    captcha.oneColor = "#c0c0c0";
    counter = getCounter();
    accept.on(CLICK, function (ev) {
      if (counter > counterLimit) {
        if (!captcha.match()) {
          js.Browser.alert(_("Grey squares checks are wrong"));
          js.Browser.location.assign("../auth/index.html");
          return;
        }
      }
      AuthModel.user = user.getValue().trim();
      AuthModel.pass = pass.getValue().trim();
      AuthModel.persistent = persistent.getChecked();
      auth.accept();
    });

  }


  function body() {
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
                .add(Ui.link(auth.changeLanguage).att("class", "link")
                  .html(AuthModel.lang() == "en" ? "ES" : "EN")))
              .add(Q("td").att("align", "right").add(accept)))))
    ];

    if (counter > 0) {
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

    if (counter > counterLimit) {
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
          .html("<big><big><b>" + _("Login") + "</big></big></b>")))
      .addIt(It.from(rows));
  }

  public function show() {

    Dom0.show(
      Q("div")
        .add(Q("div").klass("title").html("&nbsp;<br>HDoc<br>&nbsp;"))
        .add(Q("div").add(body()))
    );
    user.e.focus();
  }

}

