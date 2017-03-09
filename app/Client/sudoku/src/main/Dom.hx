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

import dm.It;
import dm.DomObject;
import dm.Ui;
import dm.Ui.Q;

/// Basic page structure
class Dom {
  /// Depth in page logic tree
  public var deep(default, null):Int;
  /// Path of root. Ends with '/'
  public var root(default, null):String;

  /// Page title in head. Default "dedeme"
  public var headTitle(default, default):String;
  /// Array of .js files to charge, including extension .css.
  /// Default <tt>root + "dedeme.css"</tt>
  public var styleSheet(default, default):String;
  /// Page to go with back arrow. Default "../index.html"
  public var upperPage(default, default):String;
  /// Page title in body. Default "<i>dedeme</i>"
  public var bodyTitle(default, default):String;
  /// Text for versioning. Default "- &copy; &deg;Deme. -"
  public var version(default, default):String;

  /// Head object
  public var head(default, null):DomObject;
  /// Body object
  public var body(default, null):DomObject;
  /// Main place in body object
  public var bodyDiv(default, null):DomObject;

  var back:DomObject;

  /// Constructor
  ///   deep: Depth of page in pages logic tree.
  public function new (deep:Int) {
    this.deep = deep;
    root = It.join(
      It.range(deep).map(function (e) { return ".."; }),
      "/"
    );
    if (root != "") {
      root = root + "/";
    }

    headTitle = "dedeme";
    styleSheet = root + "dedeme.css";
    upperPage = "../index.html";
    bodyTitle = "<i>dedeme</i>";
    version = "- &copy; &deg;Deme. -";

    head = Ui.QQ("head").next();
    body = Ui.QQ("body").next();
    bodyDiv = Q("div");
  }

  /// Show page.<br>
  /// Previously you shoud initializate variables headTitle, styleSheet,
  /// upperPage, bodyTitle and version
  public function show () {
    head
    .add(Q("link")
      .att("rel", "icon")
      .att("type", "image/png")
      .att("href", root + "img/favicon.png"))
    .add(Q("link")
      .att("rel", "stylesheet")
      .att("type", "text/css")
      .att("media", "all")
      .att("href", styleSheet))
    .add(Q("title").text(headTitle));

    body
      .add(Q("table").att("class", "main")
        .add(Q("tr")
          .add(Q("td").att("style", "font-family:sans;")
            .html(bodyTitle))
          .add(Q("td")))
        .add(Q("tr")
          .add(Q("td").att("colspan", "2").html("<hr>")))
        .add(Q("tr")
          .add(Q("td"))
          .add(Q("td").add(bodyDiv)))
        .add(Q("tr")
          .add(Q("td").att("colspan", "2").html("<hr>"))))
      .add(Q("p").att("style",
        "text-align:right;font-size:10px;color:#808080;font-size:x-small;")
        .html(version));
  }
}
