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

class Sudoku {

  public var board(default, null):Array<Array<Int>>;

  function makeRandomLine ():Array<Int>{
    var r = It.range(1, 10).toArray();
    It.range(9).each(function (i) {
      var change = Std.random(9);
      var tmp = r[i];
      r[i] = r[change];
      r[change] = tmp;
    });
    return r;
  }

  function value(board:Array<Array<Int>>, x, y) {
    return board[y][x];
  }

  function valid(board:Array<Array<Int>>, c:Coor, tried:Int):Bool {
    for (i in 0...9) {
      if (value(board, c.x, i) == tried) {
        return false;
      }
      if (value(board, i, c.y) == tried) {
        return false;
      }
    }
    var sx:Int = Std.int(c.x / 3) * 3;
    var sy:Int = Std.int(c.y / 3) * 3;
    for (i in 0...3) {
      for (j in 0...3) {
        if (value(board, sx + i, sy + j) == tried) {
          return false;
        }
      }
    }
    return true;
  }

  public function new () {
  }

  public function make() {
    board = It.range(9).map(function (i) {
      return It.range(9).map(function (i) {
        return 0;
      }).toArray();
    }).toArray();

    var repository = It.range(81).map(function (i) {
      return new Array<Int>();
    }).toArray();

    var step = 0;
    repository[step] = makeRandomLine();
    while (step < 81) {
      var c = new Coor(step);
      if (repository[step].length == 0) {
        board[c.y][c.x] = 0;
        step--;
        continue;
      }
      var tried = repository[step].shift();
      if (valid(board, c, tried)) {
        board[c.y][c.x] = tried;
        step++;
        if (step < 81) {
          repository[step] = makeRandomLine();
        }
      }
    }
  }
}

class Coor {
  public var x(default, null):Int;
  public var y(default, null):Int;

  public function new (step:Int) {
    x = step % 9;
    y = Std.int(step / 9);
  }
}
