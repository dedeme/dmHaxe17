/*
 * Copyright 18-Mar-2017 ºDeme
 * GNU General Public License - V3 <http://www.gnu.org/licenses/>
 */

import dm.It;
import dm.Store;
import dm.DateDm;
import dm.Json;
import dm.I18n;
import dm.I18n._;
import dm.Ui;
import Sudoku;
import Model;

/// Entry class
class Main {
  static var alert = dm.Ui.alert;
  static var lastId = "__Sudoku_store_last";
  static var dataId = "__Sudoku_store_data";

  static function saveData() {
    Store.put(dataId, Json.from(Model.data));
  }

  static function saveLast() {
    Store.put(lastId, Json.from(Model.last));
  }

  /// Entry point
  public static function main() {
    var jdata = Store.get(dataId);
    if (jdata == null) {
      Model.data = {
        memo  : [],
        lang  : "en",
        level : 3,
      }
      saveData();
    } else {
      Model.data = Json.to(jdata);
    }

    var jlast = Store.get(lastId);
    if (jlast == null) {
      Model.last = Sudoku.mkLevel(Model.data.level);
      saveLast();
    } else {
      Model.last = Json.to(jlast);
    }
//Store.del(lastId);

    var dic = Model.data.lang == "es" ? I18nData.en() : I18nData.es();
    I18n.init(dic.split("\n"));

    View.dom();

    js.Browser.document.addEventListener('keydown', function(event) {
      var sData:SudokuData = null;
      var pageGo:Void->Void = null;
      var sData = switch (Model.page) {
        case MainPage: Model.last;
        case CopyPage: sData = Model.copy;
        case _ : null;
      }

      if (sData != null) {
        var board = View.board;
        switch (event.keyCode) {
          case 37: board.cursor(CursorLeft, sData.cell[0], sData.cell[1]);
          case 38: board.cursor(CursorUp, sData.cell[0], sData.cell[1]);
          case 39: board.cursor(CursorRight, sData.cell[0], sData.cell[1]);
          case 40: board.cursor(CursorDown, sData.cell[0], sData.cell[1]);
          case 8 | 32 | 46:
            board.set(sData.cell[0], sData.cell[1], -1);
          case k if (k > 96 && k < 106):
            board.set(sData.cell[0], sData.cell[1], k - 96);
          case k if (k > 48 && k < 58):
            board.set(sData.cell[0], sData.cell[1], k - 48);
          case _ : return;
        }
        event.preventDefault();
      }
    });

    View.mainShow();

    var timer = new haxe.Timer(1000);
    timer.run = function() {
      ++Model.last.time;
      saveLast();
      View.timeCell.html(Model.formatScs(Model.last.time));
    }

  }

  // Main menu ---------------------------------------------

  public static function newSudoku(ev) {
    Model.last = Sudoku.mkLevel(Model.data.level);
    saveLast();
    View.mainShow();
  }

  public static function copySudoku(ev) {
    Model.copy = {
      id: 0,
      date : [],
      time : 0,
      cell : [0, 0],
      sudoku : Sudoku.mkEmpty().board,
      base : Sudoku.mkEmpty().board,
      user : Sudoku.mkEmpty().board
    };
    View.copyShow();
  }

  public static function readSudoku(ev) {
    View.loadShow();
  }

  public static function saveSudoku(ev) {
    var data = Model.last;
    Model.data.memo = It.from(Model.data.memo)
      .filter(It.f(data.id != _1.id))
      .add0(data)
      .take(9)
      .to();
    saveData();
    alert(_("Sudoku has been saved"));
  }

  public static function upLevel(ev) {
    if (Model.data.level < 5) ++Model.data.level;
    saveData();
    View.mkMainMenu();
  }

  public static function downLevel(ev) {
    if (Model.data.level > 1) --Model.data.level;
    saveData();
    View.mkMainMenu();
  }

  public static function clearSudoku(ev) {
    if (Ui.confirm(_("Clear sudoku.\nContinue?"))) {
      View.board.clear();
      saveLast();
    }
  }

  public static function helpSudoku(ev) {
    View.board.markErrors();
  }

  public static function solveSudoku(ev) {
    if (Ui.confirm(_("Solve sudoku.\nContinue?"))) {
      View.solveShow();
    }
  }

  public static function changeLang(ev) {
    Model.data.lang = Model.data.lang == "en" ? "es" : "en";
    saveData();
    View.mainShow();
  }

  // Copy menu ---------------------------------------------

  public static function copyAccept(ev) {
    var s = Model.copy.user;
    var sudoku = new Sudoku(s);
    if (sudoku.errors().length > 0) {
      alert(I18n.format(
        "There are %0 errors in data", [Std.string(sudoku.errors().length)]
      ));
      View.board.markErrors();
      return;
    }
    var cells = sudoku.cellsSet();
    if (cells < 27 || cells > 50 ) {
      alert(I18n.format(
        "Sudoku has %0 numbers and the (minimun-maximun) allowed is (27-50)",
        [Std.string(sudoku.cellsSet())]
      ));
      return;
    };
    var sols = sudoku.solutions();
    if (sols == 0) {
      alert(_("Sudoku has no sulution"));
      return;
    }
    if (sols == 2) {
      if (!Ui.confirm(_("Sudoku has more than one solution.\nContinue?"))) {
        return;
      }
    }

    var ix = 0;
    while (s[0][ix] != -1) {
      ++ix;
    }
    Model.last = {
      id: Date.now().getTime(),
      date : DateDm.now().serialize(),
      time : 0,
      cell : [0, ix],
      sudoku : sudoku.solve().board,
      base : It.from(s).map(It.f(It.from(_1).map(It.f(_1)).to())).to(),
      user : s

    }
    saveLast();
    View.mainShow();
  }

  public static function copyCancel(ev) {
    View.mainShow();
  }

  // Load menu ---------------------------------------------

  public static function loadSelect(data:SudokuData) {
    Model.last = data;
    saveData();
    View.mainShow();
  }

  public static function loadCancel(ev) {
    View.mainShow();
  }

  // Solve menu --------------------------------------------

  public static function solveNewSudoku() {
    Model.last = Sudoku.mkLevel(Model.data.level);
    saveLast();
  }

  public static function solveAccept(ev) {
    View.mainShow();
  }

  // Big sudoku --------------------------------------------

  public static function sudokuClick(row:Int, col:Int) {
    switch(Model.page) {
      case MainPage: {
        Model.last.cell = [row, col];
        saveLast();
        View.mainShow();
      }
      case CopyPage: {
        Model.copy.cell = [row, col];
        View.copyShow();
      }
      case _ : {}
    }
  }



}
