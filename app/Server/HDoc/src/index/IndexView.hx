/*
 * Copyright 10-Mar-2017 ºDeme
 * GNU General Public License - V3 <http://www.gnu.org/licenses/>
 */

import dm.Ls;
import dm.It;
import dm.Ui;
import dm.Ui.Q;
import dm.Client;
import Fields;

class IndexView {
  static function sort(ies:Array<IndexEnum>) {
    inline function compare(s1, s2) {
      return dm.Str.compare(s1.toUpperCase(), s2.toUpperCase());
    }

    ies.sort(function (e1, e2) {
      return switch(e1) {
        case IndexDir(n1, _): switch(e2) {
          case IndexDir(n2, _): compare(n1, n2);
          case _: 1;
        }
        case IndexFile(n1, _, _): switch(e2) {
          case IndexFile(n2, _, _): compare(n1, n2);
          case _: -1;
        }
      }
    });
  }

  public static function show (
    client:Client, paths:Array<PathsData>, selected:String, tree:IndexEnum
  ) {
    var table = Q("table").att("class", "frame").att("width", "100%");

    function addTrs(prefix:Ls<String>, path:Ls<String>, ies:Array<IndexEnum>) {
      sort(ies);
      It.from(ies).each(function (ie) {
        switch(ie) {
          case IndexDir(name, entries): {
            table.add(Q("tr")
              .add(Q("td")
                .att("style", "text-align:left;width:5px")
                .html(prefix.head + "<b>" + name + "</b>"))
              .add(Q("td"))
              .add(Q("td"))
            );
            addTrs(
              prefix.cons(prefix.head + "&nbsp;&nbsp;&nbsp;&nbsp;"),
              prefix.cons(path.head +
                (path.head == "" ? "" : "/") +
                name),
              entries
            );
          }
          case IndexFile(name, _, help): {
            table.add(Q("tr")
              .add(Q("td")
                .att("style", "text-align:left;font-weight:bold;width:5px")
                .html("<a href='../module/index.html?" +
                  selected + "@" + path.head +
                  (path.head == "" ? "" : "/") +
                  name +
                  "'>" +
                  prefix.head + name +
                  "</a>"))
              .add(Q("td").att("style", "width:5px").text("  "))
              .add(Q("td").html(help))
            );
          }
        }
      });
    }
    switch(tree) {
      case IndexDir(_, entries): addTrs(
        Ls.empty().cons(""), Ls.empty().cons(""), entries
      );
      case _ : throw "Root of tree is an IndexFile";
    }

    Dom.body.removeAll().add(table);

    Dom.show(client, paths, selected);
    Ui.QQ("title").next().text("HDoc : " + selected);
  }
}
