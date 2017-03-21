/*
 * Copyright 19-Mar-2017 ºDeme
 * GNU General Public License - V3 <http://www.gnu.org/licenses/>
 */

import dm.It;
import dm.Ui;
import dm.Ui.Q;
import Model;


class Little {
  public var element(default, null):dm.DomObject;

  public function new (data:SudokuData) {
    var board = data.user;

    element = Q("table").klass("sudoku")
      .addIt(It.range(9).map(function (row) {
        return Q("tr")
          .addIt(It.range(9).map(function (col) {
            var n = board[row][col];
            return Q("td").klass("lsudoku").style(
              findBorder(row, col)
            ).html(n == -1 ? "&nbsp;" : Std.string(n));
          }));
      }));
  }

  static function findBorder(row, col):String {
    var top = "border-top : 2px solid rgb(110,130,150);";
    var bottom = "border-bottom : 2px solid rgb(110,130,150);";
    var left = "border-left : 2px solid rgb(110,130,150);";
    var right = "border-right : 2px solid rgb(110,130,150);";
    var row3 = row - Math.floor(row / 3) * 3;
    var col3 = col - Math.floor(col / 3) * 3;
    return  row3 == 0
      ? col3 == 0
        ? top + left
        : col == 8
          ? top + right
          : top
      : row == 8
        ? col3 == 0
          ? bottom + left
          : col == 8
            ? bottom + right
            : bottom
        : col3 == 0
          ? left
          : col == 8
            ? right
            : ""
    ;
  }
}
