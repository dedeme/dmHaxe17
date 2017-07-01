/*
 * Copyright 20-May-2017 ºDeme
 * GNU General Public License - V3 <http://www.gnu.org/licenses/>
 */

/// Plan page
import dm.Ui;
import dm.Ui.Q;
import dm.I18n;
import dm.I18n._;
import dm.CClient;
import lib.Configuration;
import lib.Dom1;

class Plan {
  var client:CClient;
  var group = "";
  var subgroup = "";
  var account = "";


  function showGroups(groups:Array<Array<String>>) {

    Dom1.show(client, "plan", Q("div").style("text-align:center")
      .add(Q("h2").html("Groups"))
      .add(Q("table").att("align", "center").klass("frame")
        .add(Q("tr")
          .add(Q("td").html("New")))
      )
      .add(Q("p").html("here"))
    );
  }

  public function new(client, conf) {
    this.client = client;

    var lg = conf.subPage.length;
    if (lg > 0) {
      group = conf.subPage.charAt(0);
    }
    if (lg > 1) {
      subgroup = conf.subPage.charAt(1);
    }
    if (lg > 2) {
      account = conf.subPage.charAt(2);
    }

    var rq = new Map();
    rq.set(CClient.PAGE, "plan");
    rq.set("group", group);
    rq.set("subgroup", subgroup);
    rq.set("account", account);
    client.request(rq, function (rp:Map<String,Dynamic>) {
      var data = rp.get("data");
      showGroups(data);
    });
  }
}

