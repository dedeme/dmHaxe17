/*
 * Copyright 20-May-2017 ºDeme
 * GNU General Public License - V3 <http://www.gnu.org/licenses/>
 */

/// Plan page
package view;

import dm.Ui;
import dm.Ui.Q;
import dm.I18n;
import dm.I18n._;
import dm.It;
import model.PyG;
import model.Balance;

class Plan {

  // Model -----------------------------

  var control:Control;
  var group = "";
  var subgroup = "";
  var account = "";
  var title:String;

  function isAccount() {
    return account == "" && subgroup != "";
  }

  // View ------------------------------

  function mkEmptyTd() {
    return Q("td").style("width:0px;");
  }

  function mkSubmenu() {
    function entry(id, target) {
      return Ui.link(function (ev) {
          go(target);
        }).klass("link").html(id);
    }
    function separator() {
      return Q("span").html("|");
    }
    function blank() {
      return Q("span").html(" ");
    }
    var r = Q("p").add(separator());

    return r.add(separator());
  }

  function mkNew() {

  }

  function mkLeftHelp() {
    function mkBalance() {
      return It.from(Balance.groups).map(function (gr) {
        var gkey = gr[Balance.GROUP_KEY];
        var gname = gr[Balance.GROUP_NAME];
        return Q("li").html('<a href="#nowhere">$gname</a>')
          .add(Q("ul").att("id", "hlist")
            .style("list-style:none;padding-left:10px;")
            .addIt(It.from(Balance.entries).filter(function (e) {
                return Balance.groupKey(e[Balance.ENTRY_KEY]) == gkey;
              }).map(function (e) {
                var ekey = e[Balance.ENTRY_KEY];
                var ename = e[Balance.ENTRY_NAME];
                var ename2 = ename.length > 40
                  ? ename.substring(0, 40) + "..."
                  : ename;
                return Q("li")
                  .add(Ui.link(function (ev) {
                    leftHelpSel("B" + ekey);
                  }).klass("link").att("title", ename).html(ename2));
              }))
          );
      });
    }
    function mkPyg() {
      return It.from(PyG.groups).map(function (gr) {
        var gkey = gr[PyG.GROUP_KEY];
        var gname = gr[PyG.GROUP_NAME];
        return Q("li").html('<a href="#nowhere">$gname</a>')
          .add(Q("ul").att("id", "hlist")
            .style("list-style:none;padding-left:10px;")
            .addIt(It.from(PyG.entries).filter(function (e) {
                return PyG.groupKey(e[PyG.ENTRY_KEY]) == gkey;
              }).map(function (e) {
                var ekey = e[PyG.ENTRY_KEY];
                var ename = e[PyG.ENTRY_NAME];
                var ename2 = ename.length > 40
                  ? ename.substring(0, 40) + "..."
                  : ename;
                return Q("li")
                  .add(Ui.link(function (ev) {
                    leftHelpSel("P" + ekey);
                  }).klass("link").att("title", ename).html(ename2));
              }))
          );
      });
    }

    return  Q("td").klass("frame").style("width:350px;vertical-align:top;")
      .add(Q("p").html("<b>Balance</b>"))
      .add(Q("ul").style("list-style:none;padding-left:0px;")
        .addIt(mkBalance()))
      .add(Q("p").html("<b>PyG</b>"))
      .add(Q("ul").style("list-style:none;padding-left:0px;")
        .addIt(mkPyg()))
    ;
  }

  function showGroups() {
    var left = isAccount() ? mkLeftHelp() : mkEmptyTd();

    var right = Q("td").style("text-align:center;vertical-align:top;")
      .add(Q("h2").html(title))
      .add(mkSubmenu())
      .add(Q("table").att("align", "center").klass("frame")
        .add(Q("tr")
          .add(Q("td").html(""))
          .add(Q("td").html("Key"))
          .add(Q("td").html("Description"))
          .add(isAccount()
            ? Q("td").html("Group")
            : mkEmptyTd())
        )
      );

    var table = Q("table").klass("main").add(Q("tr")
      .add(left)
      .add(right));
    Dom1.show(control, "plan", table);
  }

  // Control ---------------------------

  public function new(control:Control) {
    this.control = control;
    var model = control.model;

    var lg = model.subpage.length;
    title = _("Groups");
    if (lg > 0) {
      group = model.subpage.charAt(0);
      title = _("Subgroups");
    }
    if (lg > 1) {
      subgroup = model.subpage.charAt(1);
      title = _("Accounts");
    }
    if (lg > 2) {
      account = model.subpage.charAt(2);
      title = _("Subaccounts");
    }

    showGroups();
  }

  function go(page:String) {
    Ui.alert("go");
//    var rq = new Map();
//    rq.set(CClient.PAGE, "menu");
//    rq.set("go", page);
//    client.request(rq, function (rp) {
//      Main.start();
//    });
  }

  function leftHelpSel(key:String) {
    Ui.alert(key);
  }

}

