/*
 * Copyright 19-Mar-2017 ºDeme
 * GNU General Public License - V3 <http://www.gnu.org/licenses/>
 */

import dm.It;
import dm.DateDm;
import dm.DomObject;
import dm.Ui;
import dm.Ui.Q;
import dm.Tracker;
import dm.I18n;
import dm.I18n._;
using dm.Str;

class View {
  static var tracker = new Tracker([
    "1", "2", "3", "4", "5",
    "k0", "k1", "k2", "k3", "k4", "k5", "k6", "k7", "k8", "k9",
    "edit-copy", "emblem-important", "en", "es", "filenew", "fileopen",
    "filesave", "gtk-add", "gtk-clear", "gtk-execute", "gtk-help",
    "gtk-remove", "levelen", "leveles", "pen", "pencil", "thinking.gif",
    "win0", "win1", "win2", "win3", "win4"
  ]);

  public static var board(default, null):Big;

  public static var timeCell(default,null) = Q("td").klass("lastR");

  static var menu = Q("div");
  static var body = Q("div");

  public static function imgMenu(
    img:String, tooltip:String, isGrey = false
  ):DomObject {
    var r = isGrey
      ? tracker.grey(img).addStyle("vertical-align:bottom;")
      : tracker.get(img).style("vertical-align:bottom;");
    if (tooltip != "") r.att("title", tooltip);
    return r;
  }

  public static function mkMainMenu() {
    menu.removeAll().add(
      Q("table").att("align", "center").add(Q("tr")
        .add(Q("td").klass("menu")
          .add(Ui.link(Main.newSudoku)
            .add(imgMenu("filenew", _("New")))
          )
          .add(Ui.link(Main.copySudoku)
            .add(imgMenu("edit-copy", _("Copy")))
          )
          .add(Ui.link(Main.readSudoku)
            .add(imgMenu("fileopen", _("Open")))
          )
          .add(Ui.link(Main.saveSudoku)
            .add(imgMenu("filesave", _("Save")))
          )
        )
        .add(Q("td").klass("menu").style("vertical-align:middle")
          .add(Ui.link(Main.changeLang)
            .add(imgMenu("level" + Model.data.lang, _("Change language"))))
          .add(Ui.link(Main.downLevel)
            .add(imgMenu("gtk-remove", _("Down level"), Model.data.level == 1))
          )
          .add(imgMenu(Std.string(Model.data.level), ""))
          .add(Ui.link(Main.upLevel)
            .add(imgMenu("gtk-add", _("Up level"), Model.data.level == 5))
          )
        )
        .add(Q("td").klass("menu")
          .add(Ui.link(Main.changeDevice)
            .add(Model.data.pencil
              ? imgMenu("pencil", _("Change to pen"))
              : imgMenu("pen", _("Change to pencil"))
            )
          )
          .add(Ui.link(Main.clearSudoku)
            .add(Model.data.pencil
              ? imgMenu("gtk-clear", _("Clear pencil"), true)
              : imgMenu("gtk-clear", _("Clear all"))
            )
          )
          .add(Ui.link(Main.helpSudoku)
            .add(imgMenu("emblem-important", _("Search mistakes")))
          )
          .add(Ui.link(Main.solveSudoku)
            .add(imgMenu("gtk-execute", _("Solve")))
          )
        )
      )
    );
  }

  public static function mkNewMenu() {
    menu.removeAll().add(
      Q("table").att("align", "center").add(Q("tr")
        .add(Q("td").klass("menu")
          .add(imgMenu("filenew", "").style("vertical-align:middle"))
          .add(Q("span").klass("menu").html(_("New sudoku")))
          .add(Q("span").style("padding-right:5px;"))
        )
      ));
  }

  public static function mkCopyMenu() {
    menu.removeAll().add(
      Q("table").att("align", "center").add(Q("tr")
        .add(Q("td").klass("menu")
          .add(Ui.img("edit-copy").style("vertical-align:middle"))
          .add(Q("span").klass("menu").html(_("Copy external sudoku")))
          .add(Q("button").text(_("Accept")).on(CLICK, Main.copyAccept))
          .add(Q("span").klass("menu").html(""))
          .add(Q("button").text(_("Cancel")).on(CLICK, Main.copyCancel))
          .add(Q("span").style("padding-right:5px;"))
        )
      ));
  }

  public static function mkLoadMenu() {
    menu.removeAll().add(
      Q("table").att("align", "center").add(Q("tr")
        .add(Q("td").klass("menu")
          .add(Ui.img("fileopen").style("vertical-align:middle"))
          .add(Q("span").klass("menu").html(_("Open sudoku")))
          .add(Q("button").text(_("Cancel")).on(CLICK, Main.loadCancel))
          .add(Q("span").style("padding-right:5px;"))
        )
      ));
  }

  public static function mkSolveMenu() {
    menu.removeAll().add(
      Q("table").att("align", "center").add(Q("tr")
        .add(Q("td").klass("menu")
          .add(Ui.img("gtk-execute").style("vertical-align:middle"))
          .add(Q("span").klass("menu").html(_("Solved sudoku")))
          .add(Q("button").text(_("Accept")).on(CLICK, Main.solveAccept))
          .add(Q("span").style("padding-right:5px;"))
        )
      ));
  }

  public static function mkEndMenu() {
    menu.removeAll().add(
      Q("table").att("align", "center").add(Q("tr")
        .add(Q("td").klass("menu")
          .style("white-space: nowrap;padding:10px;")
          .add(Ui.img("win" + dm.Rnd.i(5)).style("vertical-align:middle"))
          .add(Q("span").klass("menu")
            .html(I18n.format(
              _("<br>View-mkEndMenu.%0%1%2<br>"),
              Model.convertScs(Model.last.time))))
          .add(Q("button").text(_("Continue")).on(CLICK, Main.newSudoku))
          .add(Q("span").style("padding-right:5px;"))
        )
      ));
  }

  public static function mkNumberKeys() {
    function mkf(n:Int):Dynamic->Void {
      return function (ev) { Main.typeNumber(n); }
    }
    return Q("table").att("align", "center")
      .add(Q("tr")
        .addIt(It.range(1, 6).map(function (n) {
          return Q("td").add(Ui.link(mkf(n)).add(
            tracker.get("k" + (n)).klass("frame")
          ));
        })))
      .add(Q("tr")
        .addIt(It.range(6, 10).map(function (n) {
          return Q("td").add(Ui.link(mkf(n)).add(
            tracker.get("k" + (n)).klass("frame")
          ));
        }))
        .add(Q("td")
          .add(Ui.link(mkf(0)).add(tracker.get("k0").klass("frame"))))
        )
    ;

  }

  static function mkBody(o:DomObject) {
    body.removeAll().add(o);
  }

  public static function dom() {
    Dom.show(Q("div").style("text-align:center")
      .add(Q("p").klass("title").html("DmSudoku"))
      .add(menu)
      .add(Q("p"))
      .add(body)
    );
  }

  public static function mainShow() {
    Model.page = MainPage;
    board = new Big(Model.last);
    board.select(Model.last.cell[0], Model.last.cell[1]);
    mkMainMenu();
    mkBody(Q("table").att("align", "center")
      .style("border-collapse : collapse;")
      .add(Q("tr")
        .add(Q("td").att("colspan", 2)
          .add(board.element))
      )
      .add(Q("tr").add(Q("td").att("colspan", 2).html("<hr>")))
      .add(Q("tr")
        .add(Q("td").klass("lastL").html(Model.mkDate(
          Model.data.lang,
          DateDm.restore(Model.last.date)
        )))
        .add(timeCell.html(
          Model.formatScs(Model.last.time)
        ))
      )
      .add(Q("tr").add(Q("td").att("colspan", 2).html("<hr>")))
      .add(Q("tr").add(Q("td").att("colspan", 2).add(mkNumberKeys())))
    );
    Main.controlEnd();
  }

  public static function newShow() {
    mkNewMenu();
    mkBody(Q("table").att("align", "center")
      .add(Q("tr")
        .add(Q("td").klass("frame")
          .add(imgMenu("thinking", "")))
      )
    );
  }

  public static function copyShow() {
    Model.page = CopyPage;
    board = new Big(Model.copy);
    board.select(Model.copy.cell[0], Model.copy.cell[1]);
    mkCopyMenu();
    mkBody(Q("table").att("align", "center")
      .style("border-collapse : collapse;")
      .add(Q("tr").add(Q("td").add(board.element)))
      .add(Q("tr").add(Q("td").html("<hr>")))
      .add(Q("tr").add(Q("td").add(mkNumberKeys())))
    );
  }

  public static function loadShow() {
    mkLoadMenu();
    if (Model.data.memo.length == 0) {
      mkBody(Q("table").att("align", "center").add(Q("tr")
        .add(Q("td").klass("frame").html(_("Without records")))));
      return;
    }
    var ix = 0;
    mkBody(Q("table").att("align", "center")
      .addIt(It.range(3).map(function (i) {
        return Q("tr").addIt(It.range(3).map(function (i) {
          var ix2 = ix;
          var data = Model.data.memo[ix++];
          if (data != null) {
            return Q("td")
              .add(new Little(data)
              .element.on(CLICK, function (ev) { Main.loadSelect(data); }));
          } else {
            return Q("td");
          }
        }));
      }))
    );
  }

  static function showBoard() {
    mkBody(Q("table").att("align", "center")
      .style("border-collapse : collapse;")
      .add(Q("tr")
        .add(Q("td").att("colspan", 2)
          .add(board.element))
      )
      .add(Q("tr")
        .add(Q("td").att("colspan", 2).html("<hr>"))
      )
      .add(Q("tr")
        .add(Q("td").klass("lastL").html(Model.mkDate(
          Model.data.lang,
          DateDm.restore(Model.last.date)
        )))
        .add(Q("td").klass("lastR").html(
          Model.formatScs(Model.last.time)
        ))
      )
    );
  }

  public static function solveShow() {
    Model.page = SolvePage;
    board = new Big(Model.last);
    mkSolveMenu();
    showBoard();
    board.markSolved();
  }

  public static function endShow() {
    mkEndMenu();
    showBoard();
  }

}
