/*
 * Copyright 18-Mar-2017 ºDeme
 * GNU General Public License - V3 <http://www.gnu.org/licenses/>
 */

import dm.It;
import dm.Tuple;
import dm.Rnd;
import dm.DateDm;
import Model;

class Sudoku {
  /// Array of 9 x 9 with values between -1 and 9, both inclusive.
  public var board:Array<Array<Int>>;
  /// board is an array of 9 x 9 ints
  public function new(board:Array<Array<Int>>) {
    this.board = board;
  }

  function isRightValue(row:Int, col:Int, value:Int):Bool {
    var row2 = Math.floor(row / 3) * 3;
    var col2 = Math.floor(col / 3) * 3;

    for (r in 0...9) {
      if (r != row && board[r][col] == value) return false;
    }
    for (c in 0...9) {
      if (c != col && board[row][c] == value) return false;
    }
    for (r in row2...row2 + 3) {
      for (c in col2...col2 + 3) {
        if ((r != row || c != col) && board[r][c] == value) return false;
      }
    }

    return true;
  }

  /// Returns a new solved sudoku or null if is not posible to solve it
  public function solve():Sudoku {
    var c = new BiCounter(9, 9);
    var su = mkEmpty();
    var boxes = It.range(9).map(function (row) {
      return It.range(9).map(function (col) {
        var n = board[row][col];
        if (n == -1) {
          return It.from([1, 2, 3, 4, 5, 6, 7, 8, 9]);
        } else {
          su.board[row][col] = n;
          return It.from([n]);
        }
      }).to();
    }).to();

    function backward():Bool {
      var n = board[c.row][c.col];
      su.board[c.row][c.col] = n;
      boxes[c.row][c.col] = n == -1
        ? It.from([1, 2, 3, 4, 5, 6, 7, 8, 9])
        : It.from([n]);
      return c.dec();
    }

    function next():Bool {
      var it = boxes[c.row][c.col];
      while (it.hasNext()) {
        var nx = it.next();
        var r = su.isRightValue(c.row, c.col, nx);
        if (r) {
          su.board[c.row][c.col] = nx;
          return true;
        }
      }
      return false;
    }

    function forward():Bool {
      return c.inc();
    }

    if (Model.linearGame(backward, next, forward))
      return su;
    return null;
  }


  /// Returns 0 if there not is any solution, 1 if there is only one and 2
  /// if there are meny of them.
  public function solutions():Int {
    var c = new BiCounter(9, 9);
    var su = mkEmpty();
    var boxes = It.range(9).map(function (row) {
      return It.range(9).map(function (col) {
        var n = board[row][col];
        if (n == -1) {
          return It.from([1, 2, 3, 4, 5, 6, 7, 8, 9]);
        } else {
          su.board[row][col] = n;
          return It.from([n]);
        }
      }).to();
    }).to();

    function backward():Bool {
      var n = board[c.row][c.col];
      su.board[c.row][c.col] = n;
      boxes[c.row][c.col] = n == -1
        ? It.from([1, 2, 3, 4, 5, 6, 7, 8, 9])
        : It.from([n]);
      return c.dec();
    }

    function next():Bool {
      var it = boxes[c.row][c.col];
      while (it.hasNext()) {
        var nx = it.next();
        var r = su.isRightValue(c.row, c.col, nx);
        if (r) {
          su.board[c.row][c.col] = nx;
          return true;
        }
      }
      return false;
    }

    function forward():Bool {
      return c.inc();
    }

    return Model.linearGameSingle(backward, next, forward);
  }

  /// Puts 'value' at row-column if 'value' is a valid number. Otherwise board
  /// is not modified and it returns 'false'. Values are put from top-left to
  /// bottom-right
  public function putSeq(row:Int, col:Int, value:Int):Bool {
    function isRight(row:Int, col:Int, value:Int):Bool {
      var row2 = Math.floor(row / 3) * 3;
      var col2 = Math.floor(col / 3) * 3;

      for (r in 0...row) {
        if (board[r][col] == value) return false;
      }
      for (c in 0...col) {
        if (board[row][c] == value) return false;
      }
      for (r in row2...row) {
        for (c in col2...col) {
          if (board[r][c] == value) return false;
        }
      }
      for (r in row2...row) {
        for (c in col...col2 + 3) {
          if (board[r][c] == value) return false;
        }
      }

      return true;
    }
    var r = isRight(row, col, value);
    if (r) board[row][col] = value;
    return r;
  }

  /// Returns pairs [row, col] of coordinates with error.
  public function errors():Array<Array<Int>> {
    var rs = [];
    for (r in 0...9) {
      for (c in 0...9) {
        var v = board[r][c];
        if (v != -1 && !isRightValue(r, c, v))
          rs.push([r, c]);
      }
    }
    return rs;
  }

  /// Returns the number of cells set
  public function cellsSet():Int {
    return It.from(board).reduce(0, function (seed, row) {
      return seed + It.from(row).reduce(0, function (seed, v) {
        return v == -1 ? seed : seed + 1;
      });
    });
  }

  /// Returns 'true' if the sudoku is finished
  public function isCompleted():Bool {
    for (r in 0...9) {
      for (c in 0...9) {
        if (board[r][c] == -1) return false;
      }
    }
    return errors().length == 0;
  }

  public function toString():String  {
    var r = new StringBuf();
    for (row in 0...9) {
      for (col in 0...9) {
        var v = board[row][col];
        r.add(v == -1 ? "-" : Std.string(v));
      }
      r.add("\n");
    }
    return r.toString();
  }

  public static function mkEmpty():Sudoku {
    return new Sudoku(It.range(9).map(function (i) {
      return It.range(9).map(function (j) { return -1;}).to();
    }).to());
  }

  public static function mkRandom():Sudoku {
    var c = new BiCounter(9, 9);
    var su = mkEmpty();
    var boxes = It.range(9).map(function (i) {
      return It.range(9).map(function (j) {
        return It.from([1, 2, 3, 4, 5, 6, 7, 8, 9]).shuffle();
      }).to();
    }).to();

    function backward():Bool {
      su.board[c.row][c.col] = -1;
      boxes[c.row][c.col] = It.from([1, 2, 3, 4, 5, 6, 7, 8, 9]).shuffle();
      return c.dec();
    }

    function next():Bool {
      var it = boxes[c.row][c.col];
      while (it.hasNext()) {
        var nx = it.next();
        if (su.putSeq(c.row, c.col, nx)) return true;
      }
      return false;
    }

    function forward():Bool {
      return c.inc();
    }

    Model.linearGame(backward, next, forward);

    return su;
  }

  /// Make a sudoku from a SudokuDefinition
  public static function mkDef(def:SudokuDef):SudokuData {
    var user = It.from(def.base).map(function (a) {
      return It.from(a).to();
    }).to();

    var ix = 0;
    while (user[0][ix] != -1) {
      ++ix;
    }
    return {
      id: Date.now().getTime(),
      date : DateDm.now().serialize(),
      time : 0,
      cell : [0, ix],
      sudoku : def.sudoku,
      base : def.base,
      user : user,
      pencil : It.range(9).map(function (i) {
          return It.range(9).map(function (j) { return false; }).to();
        }).to()
    }
  }

  /// 'l' go from 1 to 5 inclusives
  public static function mkLevel(l:Int):SudokuData {
    var s = mkRandom();
    var base = mkEmpty();
    var user = mkEmpty();

    var limit = l == 1 ? 0 : 25 + l;
    while (true) {
      for (r in 0...9) {
        var ixBox = new Box([0, 1, 2, 3, 4, 5, 6, 7, 8]);
        for (i in 0...4) {
          var c = ixBox.next();
          var n = s.board[r][c];
          base.board[r][c] = n;
          user.board[r][c] = n;
        }
      }
      if (base.solutions() == 1) break;
      base = mkEmpty();
      user = mkEmpty();
    }

    var i = 36;
    for (r in 0...9) {
      for (c in 0...9) {
        var v = base.board[r][c];
        if (v != -1) {
          base.board[r][c] = -1;
          if (base.solutions() == 1) {
            user.board[r][c] = -1;
            --i;
            if (i == limit) break;
          } else {
            base.board[r][c] = v;
          }
        }
      }
      if (i == limit) break;
    }

    var pbox = new Box([0, 1, 2]);
    var rbox = new Box([0, 1, 2]);
    var s0 = [];
    var b0 = [];
    var u0 = [];
    for (i in 0...3) {
      var part = pbox.next();
      for (j in 0...3) {
        var row = rbox.next();
        s0.push(s.board[part * 3 + row]);
        b0.push(base.board[part * 3 + row]);
        u0.push(user.board[part * 3 + row]);
      }
    }
    s = new Sudoku(s0);
    base = new Sudoku(b0);
    user = new Sudoku(u0);

    var ix = 0;
    while (base.board[0][ix] != -1) {
      ++ix;
    }
    return {
      id: Date.now().getTime(),
      date : DateDm.now().serialize(),
      time : 0,
      cell : [0, ix],
      sudoku : s.board,
      base : base.board,
      user : user.board,
      pencil : It.range(9).map(function (i) {
          return It.range(9).map(function (j) { return false; }).to();
        }).to()
    }
  }

}
