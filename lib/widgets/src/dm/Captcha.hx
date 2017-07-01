/*
 * Copyright 11-May-2015 ºDeme
 *
 * This file is part of 'hxlib'.
 *
 * 'hxlib' is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * 'hxlib' is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with 'hxlib'.  If not, see <http://www.gnu.org/licenses/>.
 */

/// System for controling authomatized login
package dm;

import dm.It;
import dm.DomObject;
import dm.Ui.Q;
import dm.Rnd;

/// System for controling authomatized login
class Captcha {
  // Model -----------------------------

  /// Error counter
  public var counter(default, null):Int;
  /// Maximun error number without captcha
  public var counterLimit(default, null):Int = 2;

  var storeId = "Hconta__Captcha";
  var captcha:OCaptcha;

  // View ------------------------------

  /// Return captcha object
  public function make():DomObject {
    return captcha.make();
  }

  // Control ---------------------------
  /// Constructor:
  ///   storeId     : Identifier for store Captcha data in local store.
  ///   counterLimit: Maximun error number without captcha.
  ///   zeroColor   : Color cells to not mark (Default: "#f0f0f0")
  ///   oneColor    : Color cells to mark (Default: "#c0c0c0")
  public function new(
    storeId:String,
    counterLimit:Int,
    zeroColor = "#f0f0f0",
    oneColor = "#c0c0c0"
  ) {
    this.storeId = storeId;
    this.counterLimit = counterLimit;
    captcha = new OCaptcha();
    captcha.zeroColor = zeroColor;
    captcha.oneColor = oneColor;
    counter = getCounter();
  }

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

  /// Increments counter
  public function incCounter() {
    var c = Std.parseInt(Store.get(storeId + "_counter"));
    Store.put(storeId + "_counter", Std.string(c + 1));
    Store.put(storeId + "_time", Std.string(DateDm.now().toTime()));
  }

  /// Restores counter value to zero
  public function resetCounter() {
    Store.del(storeId + "_counter");
    Store.del(storeId + "_time");
  }

  /// Indicates if user selection is valid
  public function match():Bool {
    return captcha.match();
  }
}


private class OCaptcha {
  // Captcha 0-1 distribution. Its order will be changed by make()
  var value(default, default):String = "11110000";
  // Color of squares with value 1
  public var oneColor(default, default):String = "#6060d0";
  // Color of squares with value 0
  public var zeroColor(default, default):String = "#d06060";

  var checks:Array<DomObject>;

  public function new () {}

  // Returns code selected by user
  function selection ():String {
    return It.join(It.from(checks).map(function (c) {
      return cast(c.e, js.html.InputElement).checked ? "1" : "0";
    }));
  }

  // Returns true if selection() == value
  public function match ():Bool {
    return selection() == value;
  }

  // Make captcha object
  public function make ():DomObject {
    checks = [];
    var tds = [];
    It.range(value.length).each(function (ix) {
      var back = zeroColor;
      if (value.charAt(ix) == "1") {
        back = oneColor;
      }
      var check = Q("input").att("type", "checkbox");
      checks.push(check);
      tds.push(Q("td")
        .att("style", "border: 1px solid;background-color: " + back)
        .add(check));
    });

    var box = new Box(tds);
    var tr1 = Q("tr");
    var tr2 = Q("tr");
    It.range(value.length).each(function (ix) {
      var tr = (ix < value.length / 2) ? tr1 : tr2;
      tr.add(box.next());
    });

    return Q("table").att("border", 0)
      .att("style", "border: 1px solid;background-color: #fffff0")
      .add(tr1)
      .add(tr2);
  }

}

