/*
 * Copyright 04-Mar-2016 ºDeme
 * GNU General Public License - V3 <http://www.gnu.org/licenses/>
 */

import dm.Test;
import dm.DateDm;
import dm.Store;

class StoreTest {
  public static function run () {
    var t = new Test("Store");

    Store.expires ("ex1", ["k1"], 0);
    Store.expires ("ex2", ["k2"], 1);

    Store.put ("k1", "one");
    Store.put ("k2", "");
    Store.put ("", "none");
    t.eq (Store.get ("k1"), "one");
    t.eq (Store.get ("k2"), "");
    t.eq (Store.get (""), "none");
    t.eq (Store.get ("xx"), null);

    t.eq (Store.size (), 5);
    t.yess ([
      Store.keys ().contains ("k2")
    , Store.keys ().contains ("k1")
    , Store.keys ().contains ("")
    , Store.keys ().size () == 5
    ]);
    t.yess ([
      Store.values ().contains ("none")
    , Store.values ().contains ("one")
    , Store.values ().contains ("")
    , Store.values ().size () == 5
    ]);

    Store.del ("");
    Store.del ("xx");
    t.yes (Store.size () == 4);

    Store.expires ("ex1", ["k1"], 0);
    Store.expires ("ex2", ["k2"], 0);
    t.yes (!Store.keys ().contains ("k1"));
    t.yes (Store.keys ().contains ("k2"));

    Store.clear ();
    t.yes (Store.size () == 0);

    trace(t.toString ());
  }
}
