/*
 * Copyright 22-Mar-2017 ºDeme
 * GNU General Public License - V3 <http://www.gnu.org/licenses/>
 */

import dm.Worker;
import Model;

class SudokuMaker {

  /// Worker entry point
  public static function main() {
    Worker.onRequest(function (e) {
      var rq : WorkerRequest = e.data;
      var rp : WorkerResponse = {
        isCache    : rq.isCache,
        level      : rq.level,
        sudokuData : Sudoku.mkLevel(rq.level)
      }
      Worker.sendResponse(rp);
    });
  }
}
