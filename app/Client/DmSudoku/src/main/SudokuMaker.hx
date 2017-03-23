/*
 * Copyright 22-Mar-2017 ºDeme
 * GNU General Public License - V3 <http://www.gnu.org/licenses/>
 */

import dm.Worker;

class SudokuMaker {

  /// Worker entry point
  public static function main() {
    Worker.onRequest(function (e) {
      Worker.postRequest(Sudoku.mkLevel(e.data));
    });
  }
}
