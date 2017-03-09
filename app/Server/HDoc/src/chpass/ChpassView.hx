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

class ChpassView {
  var chpass:Chpass;

  // Captcha configuration ---------------------------------

  var storeId = "HDoc_chpass";
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

  public var pass = Ui.pass("newPass");
  public var newPass = Ui.pass("newPass2").att("id", "newPass");
  public var newPass2 = Ui.pass("accept").att("id", "newPass2");
  var cancel = Q("input")
    .att("type", "button")
    .style("width:90px;")
    .att("id", "cancel")
    .value(_("Cancel"));
  var accept = Q("input")
    .att("type", "button")
    .style("width:90px;")
    .att("id", "accept")
    .value(_("Accept"));

  public function new(chpass:Chpass) {
    this.chpass = chpass;

    captcha.zeroColor = "#f0f0f0";
    captcha.oneColor = "#c0c0c0";
    counter = getCounter();

    cancel.on(CLICK, function (ev) { Dom.go("../conf/index.html"); });
    accept.on(CLICK, function (ev) {
      if (counter > counterLimit) {
        if (!captcha.match()) {
          js.Browser.alert(_("Grey squares checks are wrong"));
          js.Browser.location.assign("../chpass/index.html");
          return;
        }
      }
      ChpassModel.oldPass = pass.getValue().trim();
      ChpassModel.newPass = newPass.getValue().trim();
      ChpassModel.newPass2 = newPass2.getValue().trim();
      chpass.accept();
    });
  }

  function body() {

    var rows = [
      Q("tr")
        .add(Q("td")
          .att("style", "padding: 10px 0px 0px 10px;text-align:right;")
          .html(_("Current password")))
        .add(Q("td").att("style", "padding: 10px 10px 0px 10px;")
          .add(pass)),
      Q("tr")
        .add(Q("td")
          .att("style", "padding: 5px 0px 0px 10px;text-align:right;")
          .html(_("New password")))
        .add(Q("td").att("style", "padding: 5px 10px 0px 10px;")
          .add(newPass)),
      Q("tr")
        .add(Q("td")
          .att("style", "padding: 5px 0px 10px 10px;text-align:right;")
          .html(_("Confirm password")))
        .add(Q("td").att("style", "padding: 5px 10px 10px 10px;")
          .add(newPass2)),
      Q("tr")
        .add(Q("td")
          .att("colspan", 2)
          .att("style",
            "border-top:1px solid #c9c9c9;" +
            "padding: 10px 10px 10px;text-align:right;")
          .add(Q("span")
            .add(cancel
              .value(_("Cancel"))
              .att("style", "width:90px"))
            .add(Q("span").text("  "))
            .add(accept
              .value(_("Accept"))
              .att("style", "width:90px"))))
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
                .add(Q("td").html(_("Chpass.body-changePasswordError"))))))
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
          .html("<big><big><b>" + _("Change Password") + "</big></big></b>")))
      .addIt(It.from(rows));
  }

  public function show() {
    Dom0.show(
      Q("div")
        .add(Q("div").klass("title").html("&nbsp;<br>HDoc<br>&nbsp;"))
        .add(Q("div").add(body()))
    );
    pass.e.focus();
  }

}

