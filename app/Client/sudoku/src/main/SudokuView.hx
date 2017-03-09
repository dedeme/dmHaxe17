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

import dm.DomObject;
import dm.Ui.Q;
import dm.It;

class SudokuView {

  var sudoku:Sudoku;

  static var s3 = "border-right-style:solid;" +
    "border-right-width:1px;" +
    "border-right-color:#000000;" +
    "border-bottom-style:solid;" +
    "border-bottom-width:1px;" +
    "border-bottom-color:#000000;";

  static var s2 = s3 +
    "border-left-style:solid;" +
    "border-left-width:1px;" +
    "border-left-color:#000000;";

  static var s1 = s3 +
    "border-top-style:solid;" +
    "border-top-width:1px;" +
    "border-top-color:#000000;";

  static var s0 = s2 +
    "border-top-style:solid;" +
    "border-top-width:1px;" +
    "border-top-color:#000000;";


  var mkTd0 = function () { return Q("td").att("style", s0); };
  var mkTd1 = function () { return Q("td").att("style", s1); };
  var mkTd2 = function () { return Q("td").att("style", s2); };
  var mkTd3 = function () { return Q("td").att("style", s3); };

  public function new (sudoku:Sudoku) {
    this.sudoku = sudoku;
  }

  public function makeBoard ():DomObject {
    var firstLine = true;
    return It.from(sudoku.board).reduce(
      Q("table").att("border", "0"),
      function (table, line) {
        var firstCell = true;
        if (firstLine) {
          firstLine = false;
          return table.add(It.from(line).reduce(
            Q("tr"),
            function (tr, i) {
              if (firstCell) {
                firstCell = false;
                return tr.add(mkTd0().text(Std.string(i)));
              }
              return tr.add(mkTd1().text(Std.string(i)));
            }
          ));
        }
        return table.add(It.from(line).reduce(
          Q("tr"),
          function (tr, i) {
            if (firstCell) {
              firstCell = false;
              return tr.add(mkTd2().text(Std.string(i)));
            }
            return tr.add(mkTd3().text(Std.string(i)));
          }
        ));
      }
    );
  }
}
