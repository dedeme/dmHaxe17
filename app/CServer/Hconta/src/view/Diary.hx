/*
 * Copyright 20-May-2017 ºDeme
 * GNU General Public License - V3 <http://www.gnu.org/licenses/>
 */

/// Diary entries page
package view;

import dm.DomObject;
import dm.Ui;
import dm.Ui.Q;
import dm.I18n;
import dm.I18n._;
import dm.It;
import dm.DateDm;
import dm.DatePicker;
import model.Dentry;
import model.PyG;
import model.Balance;

class Diary {

  // Model -----------------------------

  var control: Control;
  var model:Model;

  var date: DateDm;
  function getDate() {
    return date;
  }
  function formatDate(d:DateDm):String {
    return model.language == "en" ? d.format("%M/%D/%Y") : d.format("%D/%M/%Y");
  }


  // View ------------------------------

  function helpArea (){
    var tx = "Una cuenta muy larga para todos ...";
    return Q("td").klass("frame").style("width:250px;vertical-align:top;")
      .html(Dom0.textAdjust(tx, 247));
  }

  // dnum: Number of Annotation (base 1). a new annotation has the number 0.
  function annotationArea(dnum:Int) {
    var isNew = true;
    var datePicker = new DatePicker();
    var dateObj = Q("input").style("width:80px;text-align:center;");
    var descObj = Q("input").style("width:450px;");
    if (dnum != 0) {
      isNew = false;
      var entry:Dentry = model.diary[dnum];
      date = entry.date;
      dateObj.value(formatDate(date)).disabled(true);
    } else {
      dnum = model.diary.length + 1;
      if (dnum > 1) {
        var entry:Dentry = model.diary[dnum - 1];
        date = entry.date;
      } else {
        date = DateDm.now();
      }
      var lastDate = date;
      datePicker.lang = model.language;
      datePicker.setDate(date);
      datePicker.action = function (sd:String) {
        var d = DateDm.fromStr(sd);
        if (d.df(lastDate) < 0) {
          Ui.alert(I18n.format(
            _("Date can not be previous to %0"), [formatDate(lastDate)]));
          var d0 = getDate();
          datePicker.setDate(d0);
          dateObj.value(formatDate(d0));
        } else {
          date = d;
        }
      }

    }

    var rows = [];
    rows.push(Q("tr")
      .add(Q("td"))
      .add(Q("td").att("colspan", 3)
        .add(Q("span").html(
          _("Nº:") + " " + Std.string(dnum) +
          (isNew
            ? "&nbsp;&nbsp;&nbsp;&nbsp;"
            : "&nbsp;&nbsp;&nbsp;&nbsp;<b>" +
              _("Modification") +
              "</b>&nbsp;&nbsp;&nbsp;&nbsp;")
        ))
        .add(isNew ? datePicker.makeText(dateObj) : dateObj)
      )
      .add(Q("td"))
    );
    rows.push(Q("tr")
      .add(Q("td").att("colspan", 5).add(descObj))
    );
    rows.push(Q("tr")
      .add(Q("td").att("colspan", 2).style("text-align:left;")
        .add(Q("span").html(_("Debit")))
        .add(Q("span").html("&nbsp;&nbsp;"))
        .add(Q("span").html("B1"))
        .add(Q("span").html("&nbsp;&nbsp;"))
        .add(Q("span").html("B2"))
        .add(Q("span").html("&nbsp;&nbsp;"))
        .add(Q("span").html("B3")))
      .add(Q("td"))
      .add(Q("td").att("colspan", 2).style("text-align:right;")
        .add(Q("span").html("B1"))
        .add(Q("span").html("&nbsp;&nbsp;"))
        .add(Q("span").html("B2"))
        .add(Q("span").html("&nbsp;&nbsp;"))
        .add(Q("span").html("B3"))
        .add(Q("span").html("&nbsp;&nbsp;"))
        .add(Q("span").html(_("Credit"))))
    );
    rows.push(Q("tr")
      .add(Q("td").att("colspan", 5).add(Q("hr")))
    );
    rows.push(Q("tr")
      .add(Q("td").html("DAmmount"))
      .add(Q("td").html("DAcc"))
      .add(Q("td").html("Separator"))
      .add(Q("td").html("HAcc"))
      .add(Q("td").html("HAmmount"))
    );
    rows.push(Q("tr")
      .add(Q("td").att("colspan", 5).html("Buttons"))
    );
    return It.from(rows);
  }

  function historicArea() {
    var rows = [];
    rows.push(Q("tr").add(Q("td").html("HistoricArea")));
    return It.from(rows);
  }

  // dnum: Number of Annotation (base 1). a new annotation has the number 0.
  function entryArea(dnum:Int) {
    return Q("td").style("text-align:center;vertical-align:top;")
      .add(Q("table").att("align", "center").klass("frame")
        .addIt(annotationArea(dnum))
        .addIt(historicArea())
      );
  }

  // dnum: Number of Annotation (base 1). a new annotation has the number 0.
  function show(dnum:Int) {
    Dom1.show(control, "diary",
      Q("table").klass("main").add(Q("tr")
        .add(helpArea())
        .add(entryArea(dnum))
      )
    );
  }

  // Control ---------------------------

  public function new(control:Control) {
    this.control = control;
    this.model = control.model;

    show(0);
  }

}

