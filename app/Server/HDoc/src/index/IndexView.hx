/*
 * Copyright 10-Mar-2017 ºDeme
 * GNU General Public License - V3 <http://www.gnu.org/licenses/>
 */

import dm.Ui;
import dm.Ui.Q;
import dm.Client;
import Fields;

class IndexView {

  public static function show (
    client:Client, paths:Array<PathsData>, selected:String
  ) {
    Dom.body.removeAll().add(Q("p").html("here"));

    Dom.show(client, paths, selected);
    Ui.QQ("title").next().text("HDoc : " + selected);
  }
}
