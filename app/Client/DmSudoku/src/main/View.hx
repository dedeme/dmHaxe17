/*
 * Copyright 19-Mar-2017 ºDeme
 * GNU General Public License - V3 <http://www.gnu.org/licenses/>
 */

import dm.It;
import dm.DateDm;
import dm.DomObject;
import dm.Ui;
import dm.Ui.Q;
import dm.I18n._;
using dm.Str;

class View {

  public static var board(default, null):Big;
  public static var timeCell(default,null) = Q("td").klass("lastR");

  static var menu = Q("div");
  static var body = Q("div");

  static function imgMenu(img:String, tooltip:String) {
    var sty = "vertical-align:bottom;";
    if (tooltip.startsWith("Up ") && Model.data.level == 5) {
      sty += "filter: grayscale(100%)";
    }
    if (tooltip.startsWith("Down ") && Model.data.level == 1) {
      sty += "filter: grayscale(100%)";
    }
    var r = Ui.img(img).style(sty);
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
          .add(imgMenu(Model.data.lang == "en" ? "levelEn" : "levelEs", ""))
          .add(Ui.link(Main.downLevel)
            .add(imgMenu("gtk-remove", _("Down level")))
          )
          .add(imgMenu(Std.string(Model.data.level), ""))
          .add(Ui.link(Main.upLevel)
            .add(imgMenu("gtk-add", _("Up level")))
          )
        )
        .add(Q("td").klass("menu")
          .add(Ui.link(Main.clearSudoku)
            .add(imgMenu("gtk-clear", _("Restart")))
          )
          .add(Ui.link(Main.helpSudoku)
            .add(imgMenu("emblem-important", _("Search mistakes")))
          )
          .add(Ui.link(Main.solveSudoku)
            .add(imgMenu("gtk-execute", _("Solve")))
          )
        )
        .add(Ui.link(Main.changeLang)
            .add(imgMenu(Model.data.lang, _("Change language")))
          )
      )
    );
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
      .add(Q("tr")
        .add(Q("td").att("colspan", 2).html("<hr>"))
      )
      .add(Q("tr")
        .add(Q("td").klass("lastL").html(Model.mkDate(
          Model.data.lang,
          DateDm.restore(Model.last.date)
        )))
        .add(timeCell.html(
          Model.formatScs(Model.last.time)
        ))
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
      .add(Q("tr")
        .add(Q("td")
          .add(board.element))
      )
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

  public static function solveShow() {
    Model.page = SolvePage;
    board = new Big(Model.last);
    mkSolveMenu();
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
          Std.string(Model.last.time)
        ))
      )
    );
    board.markSolved();
    Main.solveNewSudoku();
  }

}
