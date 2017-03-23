/*
 * Copyright 18-Mar-2017 ºDeme
 * GNU General Public License - V3 <http://www.gnu.org/licenses/>
 */

import dm.DateDm;

class Model {
  /// Saved in store
  public static var last:SudokuData;
  /// Saved in store
  public static var data:Data = null;
  /// User definied new sudoku
  public static var copy:SudokuData;
  /// Its value is 'true' if the program is in the main page.
  public static var page = MainPage;
  /// If its value is 'true' sudoku has wrong numbers on red.
  public static var correction = false;

  /// Sequence steps according to next rules:
  ///   1. Starts calling 'next()'. If next() result is true, calls forward().
  ///      Otherwise calls backward()
  ///   2. If forward() returns 'true', calls next(). Otherwise finishes
  ///      returning 'true'
  ///   3. If backward() retuns 'true', calls next(). Otherwise finishes
  ///      returning 'false'
  public static function linearGame(
    backward:Void->Bool, next:Void->Bool, forward:Void->Bool
  ):Bool {
    while (true) {
      if (next()) {
        if (!forward()) return true;
      } else {
        if (!backward()) return false;
      }
    }
  }

  /// Returns the game number of solutions. Parameters are like in
  /// 'linearGame()'
  public static function linearGameSolutions(
    backward:Void->Bool, next:Void->Bool, forward:Void->Bool
  ):Int {
    var r = 0;
    while (true) {
      if (next()) {
        if (!forward()) {
          ++r;
          if (!backward()) return r;
        }
      } else {
        if (!backward()) return r;
      }
    }
  }
  /// Returns 0 if there not is any solution, 1 if there is only one and 2
  /// if there are meny of them.
  public static function linearGameSingle(
    backward:Void->Bool, next:Void->Bool, forward:Void->Bool
  ):Int {
    var r = 0;
    while (true) {
      if (next()) {
        if (!forward()) {
          ++r;
          if (r > 1 || !backward()) return r;
        }
      } else {
        if (!backward()) return r;
      }
    }
  }

  public static function mkDate(lang:String, d:DateDm) {
    if (lang == "es") {
      return d.format("%D-%b-%Y");
    }
    var months = DateDm.months;
    DateDm.months = [
      "Jan", "Feb", "Mar", "Apr", "May", "Jun",
      "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
    ];
    var r = d.format("%D-%b-%Y");
    DateDm.months = months;
    return r;
  }

  public static function formatScs(s:Float):String {
    var arr = convertScs(s);
    return arr[0] + ":" + arr[1] + ":" + arr[2];
  }

  public static function convertScs(s:Float):Array<String> {
    function n2 (n:Float):String {
      var r = Std.string(n);
      if (r.length < 2) return "0" + r;
      return r;
    }
    var m = Math.floor(s / 60);
    var h = Math.floor(m / 60);
    return [Std.string(h), n2(m - h * 60), n2(s - m * 60)];
  }

}

enum PageType { MainPage; CopyPage; LoadPage; SolvePage; WinPage; }

enum CursorMove { CursorUp; CursorDown; CursorLeft; CursorRight; }

typedef SudokuData = {
  id    :Float,
  date  :Array<Int>,  // DateDm serialized
  time  :Float,
  cell  :Array<Int>,  // activated [row, column]
  sudoku:Array<Array<Int>>,
  base  :Array<Array<Int>>,
  user  :Array<Array<Int>>,
  pencil:Array<Array<Bool>>
}

typedef Data = {
  memo  : Array<SudokuData>,
  lang  : String, // "en" or "es"
  level : Int, // 1 to 5 inclusive
  pencil: Bool // If pencil is activated
}

/// Counter for bidimentsional arrays
class BiCounter {
    public var rowSize(default, null):Int;
    public var colSize(default, null):Int;
    var rowLimit:Int;
    var colLimit:Int;
    /// Initial value = 0
    public var row(default, null):Int;
    /// Initial value = 0
    public var col(default, null):Int;

    /// Create the counter.
    ///   rowLimit: Maximun row value (exclusive)
    ///   colLimit: Maximun column value (exclusive)
    public function new(rowSize:Int, colSize:Int) {
      this.rowSize = rowSize;
      this.colSize = colSize;
      rowLimit = rowSize - 1;
      colLimit = colSize - 1;
      row = 0;
      col = 0;
    }

    /// Increments counter, returning 'false' if it is not possible.
    public function inc():Bool {
      ++col;
      if (col == colSize) {
        if (row == rowLimit) return false;
        col = 0;
        ++row;
      }
      return true;
    }

    /// Decrements counter, returning 'false' if it is not possible.
    public function dec():Bool {
      --col;
      if (col == -1) {
        if (row == 0) return false;
        col = colLimit;
        --row;
      }
      return true;
    }

}
