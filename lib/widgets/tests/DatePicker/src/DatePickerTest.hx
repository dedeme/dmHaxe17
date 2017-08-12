/*
 * Copyright 17-Jun-2017 ºDeme
 * GNU General Public License - V3 <http://www.gnu.org/licenses/>
 */

import dm.Test;
import dm.DateDm;
import dm.Ui;
import dm.Ui.Q;
import dm.DatePicker;

class DatePickerTest {

  static function datePicker1() {
    var div = Q("div");
    var d = DateDm.now();
    d = d.add(2);
    var dp = new DatePicker();
    dp.setDate(d);
    dp.lang = "en";
    dp.action = function (d) {
      Ui.alert('picked date is "$d"');
    }

    return div
      .add(Q("h2").html("DatePicker 1"))
      .add(dp.make());
  }

  static function datePicker2() {
    var bt = Q("button").html("Date Picker");

    var div = Q("div");
    var d = DateDm.now();
    d = d.add(-2);
    var dp = new DatePicker();
    dp.setDate(d);
    dp.lang = "en";
    dp.action = function (d) {
      Ui.alert('picked date is "$d"');
    }

    return div
      .add(Q("h2").html("DatePicker 2"))
      .add(Q("p")
        .add(dp.makeButton(bt))
        .add(Q("span").html("Next Text")))
      .add(Q("h3").html("Some text"));
  }

  static function datePicker3() {
    var input = Q("input").att("type", "text");

    var div = Q("div");
    var d = DateDm.now();
    var dp = new DatePicker();
    dp.setDate(d);
    dp.action = function (d) {
      Ui.alert('picked date is "$d"');
    }

    return div
      .add(Q("h2").html("DatePicker 3"))
      .add(Q("p")
        .add(dp.makeText(input))
        .add(Q("span").html("Next Text")))
      .add(Q("h3").html("Some text"));
  }

  public static function run () {
    var t = new Test("DatePicker");

    Ui.QQ("body").next()
      .add(datePicker1())
      .add(datePicker2())
      .add(datePicker3());

    t.log();
  }
}

