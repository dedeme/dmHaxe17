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
import dm.Tracker;
import dm.Worker;
import Sudoku;
import Model;

/// Entry class
class Main {
  public static var version = "0.0.1";
  static var timer:haxe.Timer = null;
  static var alert = dm.Ui.alert;
  static var versionId = "__Sudoku_store_version";
  static var lastId = "__Sudoku_store_last";
  static var dataId = "__Sudoku_store_data";
  static var sudokuMaker: Worker;

  static function saveData() {
    Store.put(dataId, Json.from(Model.data));
  }

  static function saveLast() {
    Store.put(lastId, Json.from(Model.last));
  }

  /// Entry point
  public static function main() {
    var storeVersion = Store.get(versionId);
    var versionOk = true;
    if (storeVersion == null || storeVersion != version) {
      Store.put(versionId, version);
      versionOk = false;
    }

    var jdata = Store.get(dataId);
    if (!versionOk || jdata == null) {
      Model.data = {
        cache   : [null, null, null, null, null],
        memo    : [],
        lang    : "es",
        level   : 5,    // Conected with initial definition of Model.last
        pencil  : false
      }
      saveData();
    } else {
      Model.data = Json.to(jdata);
    }
    var jlast = Store.get(lastId);
    if (!versionOk || jlast == null) {
      var sudoku = [
        [2,8,5,6,3,9,1,4,7],
        [9,1,7,4,2,8,6,3,5],
        [3,6,4,5,1,7,8,2,9],
        [8,9,6,2,4,5,3,7,1],
        [1,4,2,7,8,3,9,5,6],
        [5,7,3,1,9,6,2,8,4],
        [4,3,8,9,7,1,5,6,2],
        [6,2,9,8,5,4,7,1,3],
        [7,5,1,3,6,2,4,9,8]];
      var base = [
        [-1,-1,-1,-1,3,-1,-1,-1,7],
        [9,-1,-1,4,-1,-1,6,-1,-1],
        [-1,-1,-1,-1,-1,7,-1,-1,-1],
        [8,-1,-1,-1,-1,5,3,-1,1],
        [1,-1,-1,-1,8,-1,9,5,-1],
        [5,7,-1,1,-1,-1,-1,8,-1],
        [-1,3,-1,9,-1,-1,5,6,-1],
        [6,-1,9,8,-1,-1,-1,-1,3],
        [-1,5,1,3,-1,2,-1,-1,-1]];
      Model.last = Sudoku.mkDef({sudoku : sudoku, base : base});
      saveLast();
    } else {
      Model.last = Json.to(jlast);
    }
//Store.del(lastId);Store.del(dataId);
    var dic = Model.data.lang == "es" ? I18nData.es() : I18nData.en();
    I18n.init(dic);
    View.newLink.removeAll().add(Ui.link(Main.newSudoku)
      .add(View.imgMenu("filenew", _("New"))));
    View.dom();

    sudokuMaker = new Worker("sudokuMaker.js");
    sudokuMaker.onResponse(function(e) {
      var rp : WorkerResponse = e.data;
      if (rp.isCache) {
        Model.data.cache[rp.level - 1] = rp.sudokuData;
        saveData();
        View.newLink.removeAll().add(Ui.link(Main.newSudoku)
          .add(View.imgMenu("filenew", _("New"))));
      } else {
        Model.last = rp.sudokuData;
        saveLast();
        View.mainShow();
      }
    });

    js.Browser.document.addEventListener('keydown', function(event) {
      var sData:SudokuData = switch (Model.page) {
        case MainPage: Model.last;
        case CopyPage: Model.copy;
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

    if (timer == null) {
      timer = new haxe.Timer(1000);
      timer.run = function() {
        ++Model.last.time;
        saveLast();
        View.timeCell.html(Model.formatScs(Model.last.time));
      }
    }

    var cache = Model.data.cache;
    for (i in 0...5) {
      if (cache[i] == null) {
        if (i == Model.data.level - 1) {
          View.newLink.removeAll().add(View.imgMenu("filenew", _("New"), true));
        }
        var rq:WorkerRequest = {
          isCache : true,
          level   : i + 1
        }
        sudokuMaker.sendRequest(rq);
      }
    }
  }

  // Main menu ---------------------------------------------

  public static function newSudoku(ev) {
    var cache = Model.data.cache[Model.data.level - 1];
    if (cache == null) {
      var rq:WorkerRequest = {
        isCache : false,
        level   : Model.data.level
      }
      sudokuMaker.sendRequest(rq);
      View.newShow();
    } else {
      Model.last = Sudoku.mkDef(cache);
      saveLast();
      Model.data.cache[Model.data.level - 1] = null;
      saveData();
      main();
    }
  }

  public static function copySudoku(ev) {
    Model.copy = {
      id: 0,
      date : [],
      time : 0,
      cell : [0, 0],
      sudoku : Sudoku.mkEmpty().board,
      base : Sudoku.mkEmpty().board,
      user : Sudoku.mkEmpty().board,
      pencil : It.range(9).map(It.f(It.range(9).map(It.f(false)).to())).to()
    }
    View.copyShow();
  }

  public static function readSudoku(ev) {
    View.loadShow();
  }

  public static function saveSudoku(ev) {
    var data:SudokuData = Json.to(Json.from(Model.last));
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

    if (Model.data.cache[Model.data.level - 1] == null) {
      View.newLink.removeAll().add(View.imgMenu("filenew", _("New"), true));
    } else {
      View.newLink.removeAll().add(Ui.link(Main.newSudoku)
        .add(View.imgMenu("filenew", _("New"))));
    }
    View.mkMainMenu();
  }

  public static function downLevel(ev) {
    if (Model.data.level > 1) --Model.data.level;
    saveData();

    if (Model.data.cache[Model.data.level - 1] == null) {
      View.newLink.removeAll().add(View.imgMenu("filenew", _("New"), true));
    } else {
      View.newLink.removeAll().add(Ui.link(Main.newSudoku)
        .add(View.imgMenu("filenew", _("New"))));
    }
    View.mkMainMenu();
  }

  public static function changeDevice(ev) {
    Model.data.pencil = !Model.data.pencil;
    saveData();
    View.mkMainMenu();
  }

  public static function clearSudoku(ev) {
    var tx = Model.data.pencil
      ? _("Clear pencil.\nContinue?")
      : _("Clear all.\nContinue?");
    if (Ui.confirm(tx)) {
      View.board.clear();
      saveLast();
    }
  }

  public static function helpSudoku(ev) {
    if (Model.correction) {
      Model.correction = false;
      View.mainShow();
    } else {
      Model.correction = true;
      View.board.markErrors();
    }
  }

  public static function solveSudoku(ev) {
    if (Ui.confirm(_("Solve sudoku.\nContinue?"))) {
      View.solveShow();
    }
  }

  public static function changeLang(ev) {
    Model.data.lang = Model.data.lang == "en" ? "es" : "en";
    saveData();
    main();
  }

  // Copy menu ---------------------------------------------

  public static function copyAccept(ev) {
    var s = Model.copy.user;
    var sudoku = new Sudoku(s);
    if (sudoku.errors().length > 0) {
      alert(I18n.format(
        _("There are %0 errors in data"), [Std.string(sudoku.errors().length)]
      ));
      View.board.markErrors();
      return;
    }
    var cells = sudoku.cellsSet();
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
      user : s,
      pencil : It.range(9).map(It.f(It.range(9).map(It.f(false)).to())).to()
    }
    saveLast();
    View.mainShow();
  }

  public static function copyCancel(ev) {
    View.mainShow();
  }

  // Load menu ---------------------------------------------

  public static function loadSelect(data:SudokuData) {
    Model.last = Json.to(Json.from(data));
    Model.data.memo = It.from(Model.data.memo)
      .filter(It.f(_1.id != data.id))
      .add0(data)
      .to();
    saveLast();
    saveData();
    View.mainShow();
  }

  public static function loadCancel(ev) {
    View.mainShow();
  }

  // Solve menu --------------------------------------------

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

  // Control end -------------------------------------------

  public static function controlEnd() {
    var finished = It.zip(
      It.from(Model.last.sudoku),
      It.from(Model.last.user)).all(It.f(
        It.from(_1._1).eq(It.from(_1._2))
      ));
    if (finished) {
      View.endShow();
    }
  }

  // Numbers -----------------------------------------------

  public static function typeNumber(n:Int) {
    var sData:SudokuData = switch (Model.page) {
      case MainPage: Model.last;
      case CopyPage: Model.copy;
      case _ : null;
    }

    if (sData != null) {
      var board = View.board;
      switch(n) {
        case 0: board.set(sData.cell[0], sData.cell[1], -1);
        case _: board.set(sData.cell[0], sData.cell[1], n);
      }
    }
  }
}
