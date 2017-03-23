/*
 * Copyright 19-Mar-2017 ºDeme
 * GNU General Public License - V3 <http://www.gnu.org/licenses/>
 */

import dm.It;
import dm.DomObject;
import dm.Ui;
import dm.Ui.Q;
import Model;


class Big {
  public var element(default, null):DomObject;

  var data:SudokuData;
  var cells:Array<Array<DomObject>> = [];

  public function new (data:SudokuData) {
    this.data = data;

    element = Q("table").klass("sudoku")
      .addIt(It.range(9).map(function (row) {
        cells[row] = [];
        return Q("tr")
          .addIt(It.range(9).map(function (col) {
            var n = data.user[row][col];
            var td = Q("td").klass("bsudoku")
              .html(n == -1 ? "&nbsp;" : Std.string(n));

            if (data.base[row][col] == -1) {
              td.on(CLICK, function (ev) { Main.sudokuClick(row, col); });
            }
            cells[row][col] = td;
            return td;
          }));
      }));
  }

  public function select(row: Int, col:Int) {
    for (r in 0...9) {
      for (c in 0...9) {
        if (data.base[r][c] == -1) {
          if (r == row && c == col) {
            cells[r][c].style(
              findBorder(r, c) + "background-color : rgb(230, 240, 250);" +
              "color:" + (data.pencil[r][c] ? "#a08000" : "#000000")
            );
          } else {
            cells[r][c].style(
              findBorder(r, c) + "background-color : rgb(250, 250, 250);" +
              "color:" + (data.pencil[r][c] ? "#a08000" : "#000000")
            );
          }
        } else {
          cells[r][c].style(
              findBorder(r, c) + "background-color : rgb(230, 230, 230);"
          );
        }
      }
    }
  }

  public function cursor(dir:CursorMove, row:Int, col:Int) {
    function move(go, r, c) {
      if (go) Ui.beep();
      else if (data.base[r][c] == -1) Main.sudokuClick(r, c);
      else cursor(dir, r, c);
    }
    switch (dir) {
      case CursorUp: move(row == 0, row - 1, col);
      case CursorDown: move(row == 8, row + 1, col);
      case CursorLeft: move(col == 0, row, col - 1);
      case CursorRight: move(col == 8, row, col + 1);
    }
  }

  public function set(row:Int, col:Int, n:Int) {
    Model.last.pencil[row][col] = Model.data.pencil;
    data.user[row][col] = n;
    Main.sudokuClick(row, col);
  }

  public function clear() {
    for (r in 0...9) {
      for (c in 0...9) {
        var del = data.base[r][c] == -1 && (Model.data.pencil
          ? Model.last.pencil[r][c]
          : true);
        if (del) {
          data.user[r][c] = -1;
          cells[r][c].html("&nbsp;");
        }
      }
    }

  }

  public function markErrors() {
    It.from(new Sudoku(data.user).errors()).each(function (coor) {
      var r = coor[0];
      var c = coor[1];
      cells[r][c].style(
        findBorder(r, c) + "background-color : rgb(250, 250, 250);" +
          "color: rgb(120, 0, 0);"
      );
    });
  }

  public function markSolved() {
    for (r in 0...9) {
      for (c in 0...9) {
        if (data.base[r][c] != -1) {
          cells[r][c].style(
            findBorder(r, c) + "background-color : rgb(230, 230, 230);"
          );
        } else {
          if (data.user[r][c] == data.sudoku[r][c]){
            cells[r][c].style(
              findBorder(r, c) + "background-color : rgb(250, 250, 250);"
            );
          } else {
            cells[r][c].style(
              findBorder(r, c) + "background-color : rgb(250, 250, 250);" +
                "color: rgb(120, 0, 0);"
            );
          }
          cells[r][c].html(Std.string(data.sudoku[r][c]));
        }
      }
    }
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
