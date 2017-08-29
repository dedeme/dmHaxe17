// Copyright 19-Mar-2017 ºDeme
// GNU General Public License - V3 <http://www.gnu.org/licenses/>

import dm.Ui;
import dm.Ui.Q;
import dm.Cryp;
import dm.It;

class Main {
  static var div = Q("div");

  static function showText(k, text) {
    var area = Q("textarea").att("rows", 30).att("cols", 100)
      .text(Cryp.decryp(k, text));
    var close = Q("input")
      .att("type", "button")
      .style("width:90px;")
      .att("id", "close");
    close.value("Close");
    close.on(CLICK, function(ev) {
      text = "";
      js.Browser.location.assign("");
    });
    var save = Q("input")
      .att("type", "button")
      .style("width:90px;")
      .att("id", "save");
    save.value("Save");
    save.on(CLICK, function(ev) {
      Ui.download("data", Cryp.cryp(k, area.getValue()));
    });

    div.removeAll()
      .add(Q("div").klass("title").html('&nbsp;<br>fcrypt<br>&nbsp;'))
      .add(Q("div")
        .add(Q("table")
          .att("align", "center")
          .style(
            "border-collapse: collapse;" +
            "padding: 10px;" +
            "border: 1px solid rgb(110,130,150);")
          .add(Q("tr")
            .add(Q("td")
              .add(area)))
          .add(Q("tr")
            .add(Q("td").style("text-align:right;")
              .add(close)
              .add(Q("span").html("&nbsp;&nbsp;"))
              .add(save)))
      ));
  }

  public static function main() {
    var user = Ui.field("pass");
    var pass = Ui.pass("accept").att("id", "pass");
    var accept = Q("input")
      .att("type", "button")
      .style("width:90px;")
      .att("id", "accept");
    accept.value("Accept");

    Ui.upload("data", function(text){
      accept.on(CLICK, function (ev) {
        var u = user.getValue().trim();
        var p = pass.getValue().trim();
        if (u == "") {
          Ui.alert("User is missing");
          return;
        }
        if (p == "") {
          Ui.alert("password is missing");
          return;
        }
        showText(Cryp.key(u + p, 2500), text);
      });
      Ui.QQ("body").next().removeAll().add(div);
      div
        .add(Q("div").klass("title").html('&nbsp;<br>fcrypt<br>&nbsp;'))
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
                .html("<big><big><b>Login</big></big></b>")))
            .add(Q("tr")
              .add(Q("td")
                .style("padding: 10px 0px 0px 10px;text-align:right;")
                .html("User"))
              .add(Q("td").style("padding: 10px 10px 0px 10px;").add(user)))
            .add(Q("tr")
              .add(Q("td")
                .style("padding: 10px 0px 0px 10px;text-align:right;")
                .html("Password"))
              .add(Q("td").style("padding: 10px 10px 5px 10px;").add(pass)))
            .add(Q("tr")
              .add(Q("td"))
              .add(Q("td").att("align", "right").add(accept)))
        ));
      user.e.focus();
    });
  }
}
