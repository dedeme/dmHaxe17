/*
 * Copyright 21-Jul-2015 ºDeme
 *
 * This file is part of 'sudoku'.
 *
 * 'sudoku' is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * 'sudoku' is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with 'sudoku'.  If not, see <http://www.gnu.org/licenses/>.
 */

import dm.Ui.Q;
import dm.Ui;
import dm.It;
import dm.DomObject;
import dm.Store;
import Dom;



class View {
  var hexa = "0123456789ABCDEF";
  var control:Control;
  public var dom(default, null):Dom;

  var hexval = Q("div").att("style", "text-align:center;")
    .att("title", "Hexadecimal Value");
  var decval = Q("div").att("style", "text-align:center;")
    .att("title", "Dexadecimal Value");
  var cvalue = Q("div").att("style", "text-align:center;");
  var hvalue = Q("div").att("style", "text-align:center;");
  var symbol = Q("div").att("style", "text-align:center;font-size:x-large;");
  var tables = Q("div").att("style", "text-align:center;");

  public function new (control:Control) {
    this.control = control;
    dom = new Dom(0);
    dom.bodyTitle = "<span class='title'>" +
      "Unicode-dm</span>";
    dom.version = "- &copy; &deg;Deme. unicodedm (0.1.0) -";
  }

  public function show () {
    dom.show();
    dom.bodyDiv.removeAll()
    .add(Q("table").att("width", "100%").add(Q("tr").add(Q("td")
      .add(Q("table").att("align", "center").add(Q("tr")
        .add(Q("td").add(Ui.img("../../img/world")))
        .add(Q("td")
          .add(Q("table").att("align", "center")
            .att("style",
              "border: solid 1px;background-color:#ffffff;")
            .add(Q("tr").add(Q("td").add(hexval)))))
        .add(Q("td")
          .add(Q("table").att("align", "center")
            .att("style",
              "border-colapse:colapse;" +
              "border: solid 1px;background-color:#ffffff;")
            .add(Q("tr").add(Q("td").att("style", "border: solid 1px;")
              .add(cvalue)))
            .add(Q("tr").add(Q("td").att("style", "border: solid 1px;")
              .add(symbol)))
            .add(Q("tr").add(Q("td").att("style", "border: solid 1px;")
              .add(hvalue)))))
        .add(Q("td")
          .add(Q("table").att("align", "center")
            .att("style",
              "border: solid 1px;background-color:#ffffff;")
            .add(Q("tr").add(Q("td").add(decval)))))
        .add(Q("td").add(Ui.img("../../img/word")))))
      .add(Q("hr"))
      .add(Q("p").att("style", "text-align:center;").add(tables))
    )));
    refresh();
  }

  function refresh() {
    putSymbol ();
    put2tables();
  }

  function putSymbol () {
    hexval.text(control.group + control.code);
    decval.text(Std.string(Std.parseInt("0x" + control.group + control.code)));
    cvalue.text("\\u" + control.group + control.code);
    symbol.html("&#x" + control.group + control.code + ";");
    hvalue.text("&#x" + control.group + control.code + ";");
  }

  function put2tables () {
    tables.removeAll().add(make2tables());
  }

  function make2tables () {
    return Q("table").att("align", "center")
      .add(Q("tr")
        .add(Q("td").att("align", "center").html("<b><tt>Group</tt</b>"))
        .add(Q("td").att("align", "center").html("<b><tt>Code</tt</b>")))
      .add(Q("tr")
        .add(Q("td").add(makeLeftTable()))
        .add(Q("td").style("vertical-align:top;").add(makeRigthTable()))
    );
  }

  function makeLeftTable () {
    var t = Q("table").att("style",
      "border-collapse:collapse;" +
      "border: solid 1px;"
    );
    It.fromStr(hexa).each(function (y) {
      var tr = Q("tr");
      It.fromStr(hexa).each(function (x) {
        if (control.group == y + x) {
          tr.add(makeTdSel().text(y + x));
        } else {
          tr.add(makeTd().add(
            makeHexaBt().text(y + x).on(CLICK, function (e) {
              control.group = y + x;
              Store.put("unicodedm_group", control.group);
              refresh();
            })
          ));
        }
      });
      t.add(tr);
    });
    return t;
  }

  function makeRigthTable () {
    var t = Q("table").att("style",
      "border-collapse:collapse;" +
      "border: solid 1px;"
    );
    It.fromStr(hexa).each(function (y) {
      var tr = Q("tr");
      It.fromStr(hexa).each(function (x) {
        if (control.code == y + x) {
          tr.add(makeTdSel().html(sym(control.group, y + x)));
        } else {
          tr.add(makeTd().add(makeSymBt()
            .html(sym(control.group, y + x))
            .on(CLICK, function (e) {
              control.code = y + x;
              Store.put("unicodedm_code", control.code);
              refresh();
            })
          ));
        }
      });
      t.add(tr);
    });
    return t;
  }

  function makeTd () {
    return Q("td").att("style",
      "font-family:monospace;" +
      "padding:0px;"
    );
  }

  function makeTdSel () {
    return Q("td").att("style",
      "font-family:monospace;" +
      "padding:0px;" +
      "background-color:#fffff0;" +
      "border: solid 1px;"
    );
  }

  function makeHexaBt () {
    return Q("button").att("style",
      "font-family:monospace;" +
      "padding:0px;"
    );
  }

  function makeSymBt () {
    return Q("button").att("style",
      "font-family:monospace;" +
      "padding:0px;" +
      "width:22px;height:22px"
    );
  }

  function sym (group:String, code:String) {
    var base = "&#x" + group + code + ";";
    var c2 = code +  " ";
    if (group == "00") {
      if (code <= "20" || code == "AD") {
        return "&nbsp;";
      }
    }
    return base;
  }
}
