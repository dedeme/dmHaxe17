/*
 * Copyright 17-Mar-2017 ºDeme
 * GNU General Public License - V3 <http://www.gnu.org/licenses/>
 */

import dm.Ui;
import dm.It;
import dm.Client;
import Fields;
import text.Model;

/// Generation of source code: View.
class CodeView {
  /**
  Shows page.
  */
  public static function show(
    client:Client, paths:Array<PathsData>, selected:String,
    modName:String, code:String, anchor:String
  ) {
    var bf = new StringBuf ();
    bf.add ("<span id='hp:'></span>"
    + "<table border='0'><tr><td class='frame'>"
    + "<a href='../module/index.html?"
    + selected + "@" + modName + "'>"
    + modName + "</td></tr></table>");

    bf.add(code);
    It.range(22).each (function (e) {
      bf.add ("<p>&nbsp;</p>");
    });

    Dom.body.removeAll().html(bf.toString());
    Dom.show(client, paths, selected);

    var ix = modName.lastIndexOf("/");
    Ui.QQ("title").next().text(
      "HDoc : " +
      (ix == -1 ? modName : modName.substring(ix + 1))
    );
    Ui.Q("#" + anchor).e.scrollIntoView(true);
  }
}

