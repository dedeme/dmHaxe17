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

import Dom;

class View {
  var control:Control;
  public var dom(default, null):Dom;

  public function new (control:Control) {
    this.control = control;
    dom = new Dom(0);
    dom.bodyTitle = "<span class='title'>" +
    "Sudoku</span>";
    dom.version = "- &copy; &deg;Deme. sudoku (0.0.0) -";
  }



  public function show () {
    dom.show();
    dom.bodyDiv.removeAll()
      .add(new SudokuView(control.sudoku).makeBoard());
  }
}
