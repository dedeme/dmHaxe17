/*
 * Copyright 17-Jun-2017 ºDeme
 * GNU General Public License - V3 <http://www.gnu.org/licenses/>
 */

/// Widget to select dates
package dm;

import dm.DateDm;
import dm.DomObject;
import dm.Ui;
import dm.Ui.Q;

/// DatePciker is designed for 'es' and 'en' languages.
class DatePicker {
  /// Valid values are "es" (default) and "en"
  public var lang = "es";
  /// Current date. For changing its value use 'setDate'.
  public var date(default, null):DateDm;
  /// Sets action to do when a date is selected.
  ///   action: Takes a string in format "yyyymmdd" o an empty string.
  public var action:String->Void = function (s) {
    Ui.alert('"$s" was clicked');
  }

  // First day of current month.
  var dateView:DateDm;
  //If DatePicker is style floating.
  var floating: Bool;
  // [span] to show the calendar month.
  var monthEl:DomObject;
  // [span] to show the calendar year.
  var yearEl:DomObject;
  // Array<Array<[td]>> to show the calendar days.
  var dayEls:Array<Array<DomObject>>;
  // [tr] 6th. row of calendar.
  var trEx:DomObject;
  // [tr] Last row of calendar
  var tr4:DomObject;
  // [table] Table of days.
  var tb:DomObject;

  function months () {
    return (lang == "en")
      ? ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul",
          "Aug", "Sep", "Oct", "Nov", "Dec"]
      : ["ene", "feb", "mar", "abr", "may", "jun", "jul",
          "ago", "sep", "oct", "nov", "dic"];
  }
  function weekDays () {
    return (lang == "en")
      ? ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
      : ["dom", "lun", "mar", "mié", "jue", "vie", "sáb"];
  }
  function i18n () {
    return (lang == "en")
      ? {firstWeekDay : 0, today : "Today", none : "None"}
      : {firstWeekDay : 1, today : "Hoy", none : "Nada"};
  }

  function previousMonth() {
    dateView = new DateDm(1, dateView.month() - 1, dateView.year());
    load();
  }
  function nextMonth() {
    dateView = new DateDm(1, dateView.month() + 1, dateView.year());
    load();
  }
  function previousYear() {
    dateView = new DateDm(1, dateView.month(), dateView.year() - 1);
    load();
  }
  function nextYear() {
    dateView = new DateDm(1, dateView.month(), dateView.year() + 1);
    load();
  }
  // Make calback to click on today.
  function today (ev) {
    var today = DateDm.now();
    dateView = new DateDm(1, today.month(), today.year());
    load();
  }
  // Make calback to click on none.
  function none (ev) {
    date = null;
    load();
    action("");
  }
  // Make calback to click on days.
  function mkDayFunction(d:DateDm) {
    date = d;
    load();
    action(date.base());
  };
  // Reload the DataPicker.
  function load() {
    monthEl.html(months()[dateView.month() - 1]);
    yearEl.html(Std.string(dateView.year()));

    var ix = dateView.toDate().getDay() - i18n().firstWeekDay;
    ix = ix < 0 ? 7 + ix : ix;
    var month = dateView.month();
    var date1 = new DateDm(dateView.day() - ix, month, dateView.year());

    var today = DateDm.now();
    var tyear = today.year();
    var tmonth = today.month();
    var tday = today.day();

    var dyear = tyear;
    var dmonth = tmonth;
    var dday = tday;

    if (date != null) {
      dyear = date.year();
      dmonth = date.month();
      dday = date.day();
    }

    var extraRow = false;
    It.range(6).each(function (i) {
      if (i == 5 && date1.month() == month) {
        extraRow = true;
      }
      It.range(7).each(function (j) {
        var d = dayEls[i][j];
        var year1 = date1.year();
        var month1 = date1.month();
        var day1 = date1.day();
        if (day1 == dday && month1 == dmonth && year1 == dyear) {
          d.klass("select");
        } else {
          d.klass("day");
          if (date1.month() != month) {
            d.klass("dayOut");
          }
          if (date1.toDate().getDay() == 6 || date1.toDate().getDay() == 0) {
            d.klass("weekend");
            if (date1.month() != month) {
              d.klass("weekendOut");
            }
          }
        }
        if (day1 == tday && month1 == tmonth && year1 == tyear) {
          d.klass("today");
        }

        var ddate1 = date1;
        d.html('<span class="day">${ddate1.day()}</span>');
        d.e.onclick = function (ev) { mkDayFunction(ddate1); };

        date1 = new DateDm(date1.day() + 1, date1.month(), date1.year());
      });
    });

    if (tb.getAtt("hasTrEx") == "true") {
      tb.e.removeChild(trEx.e);
      tb.att("hasTrEx", "false");
    }

    if (extraRow) {
      tb.e.removeChild(tr4.e);

      tb.e.appendChild(trEx.e);
      tb.e.appendChild(tr4.e);
      tb.e.setAttribute("hasTrEx", "true");
    }
  }

  public function new () {
    setDate(DateDm.now());
  }

  /// Changes date, but it does not modify the view.
  public function setDate(d:DateDm) {
    date = d;
    dateView = new DateDm(1, date.month(), date.year());
  }

  /// Returns the DOMElement which match 'this'
  public function make():DomObject {
    function mkArrow(tx:String, f:Void->Void):DomObject {
      return Q("td").klass("arrow")
        .add(Q("span").html(tx).on(CLICK, It.f(f())));
    }
    function mkHeader(colspan, txarr1, farr1, element, txarr2, farr2) {
      return Q("td").att("colspan", colspan)
        .add(Q("table").klass("in")
          .add(Q("tr")
            .add(mkArrow(txarr1, farr1))
            .add(Q("td").add(element.klass("title")))
            .add(mkArrow(txarr2, farr2))));
    }
    monthEl = Q("span");
    yearEl = Q("span");
    dayEls = [];

    tr4 = Q("tr")
      .add(Q("td").att("colspan", 4).klass("left")
        .add(Q("span").klass("link").html(i18n().today).on(CLICK, today)))
      .add(Q("td").att("colspan", 3).klass("right")
        .add(Q("span").klass("link").html(i18n().none).on(CLICK, none)));

    tb = Q("table")
      .att("hasTrEx", "false")
      .klass("dmDatePicker")
      .add(Q("tr")
        .add(mkHeader(
            4, "&laquo", previousMonth, monthEl, "&raquo;", nextMonth
          ))
        .add(mkHeader(
            3, "&laquo", previousYear, yearEl, "&raquo;", nextYear
          )))
      .add(Q("tr")
        .addIt(It.range(7).map(function (i) {
            var ix = i + i18n().firstWeekDay;
            ix = ix > 6 ? ix - 7 : ix;
            return Q("td").html(weekDays()[ix]);
          })))
      .addIt(function () {
          var rows = It.range(5).map(function (i) {
            var tds = [];
            var tr = Q("tr").addIt(It.range(7).map(function (j) {
              var td = Q("td");
              tds.push(td);
              return td;
            }));
            dayEls.push(tds);
            return tr;
          }).to();
          var tds = [];
          trEx = Q("tr").addIt(It.range(7).map(function (j) {
              var td = Q("td");
              tds.push(td);
              return td;
            }));
          dayEls.push(tds);
          return It.from(rows);
        }())
      .add(tr4);
    load();
    return Q("div").style(floating ? "position:absolute" : "position:relative")
      .add(tb);

  }

  /// Makes a DatePicker which depends on a button.
  public function makeButton(button:DomObject):DomObject {
    var span = Q("span");
    var isShow = false;

    var btAction = function(ev) {
      if (!isShow) {
        span.add(make());
        isShow = true;
        return;
      }
      span.e.removeChild(span.e.lastChild);
      isShow = false;
    }
    button.e.onclick = btAction;

    var previousAction = action;
    action = function (s) {
      previousAction(s);
      span.e.removeChild(span.e.lastChild);
      isShow = false;
    }

    floating = true;
    return Q("span").add(button).add(span);
  }

  /// Makes a DatePicker which depends on a text field.
  public function makeText(textInput:DomObject):DomObject {
    function format(s) {
      var d = DateDm.fromStr(s);
      return lang == "en"
        ? d.format("%M/%D/%Y")
        : d.format("%D/%M/%Y");
    }
    var span = Q("span");
    var isShow = false;

    var btAction = function(ev) {
      if (!isShow) {
        span.add(make());
        isShow = true;
        return;
      }
      span.e.removeChild(span.e.lastChild);
      isShow = false;
    }
    textInput.value(format(date.base()));
    textInput.e.onclick = btAction;
    textInput.e.onkeydown = function (e) { e.preventDefault(); };

    var previousAction = action;
    action = function (s) {
      textInput.value(s == "" ? "" : format(s));
      previousAction(s);
      span.e.removeChild(span.e.lastChild);
      isShow = false;
    }

    floating = true;
    return Q("span").add(textInput).add(span);
  }
}
