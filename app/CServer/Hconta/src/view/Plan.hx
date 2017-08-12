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
  var isAccount:Bool;
  var isSubaccount:Bool;
  var isEditable:Bool;
  var keyModify:String;
  var data:Array<Array<String>>;

  // View ------------------------------

  var slotKey = Q("div").style("min-width:40px;");

  var enterName = Ui.field("newBt");

  var groupField = Q("input").att("type", "text").klass("frame")
    .style("width:45px;color:#000000;text-align:center;")
    .disabled(true);

  function formatAcc(acc:String):String {
    var l = acc.length;
    return l == 5 ? acc.substring(3) : acc.substring(l - 1);
  }

  function mkEmptyTd() {
    return Q("td").style("width:0px;");
  }

  function mkSubmenu() {
    function entry(id, target) {
      return Ui.link(function (ev) {
          control.planGo(target);
        }).klass("link").html(id);
    }
    function separator() {
      return Q("span").html("|");
    }
    function blank() {
      return Q("span").html(" ");
    }
    var r = Q("p").add(separator())
      .add(entry(" * ", ""));
    if (group != "") {
      r.add(separator()).add(entry(' $group ', group));
    }
    if (subgroup != "") {
      r.add(separator()).add(entry(' $subgroup ', group + subgroup));
    }
    if (account != "") {
      r.add(separator()).add(entry(' $account ', group + subgroup + account));
    }

    return r.add(separator());
  }

  function mkLeftHelp() {
    function mkBalance() {
      return It.from(Balance.groups).map(function (gr) {
        var gkey = gr[Balance.GROUP_KEY];
        var gname = gr[Balance.GROUP_NAME];
        return Q("li").html('<a href="#" onclick="return false;">$gname</a>')
          .add(Q("ul").att("id", "hlist")
            .style("list-style:none;padding-left:10px;")
            .addIt(It.from(Balance.entries).filter(function (e) {
                return Balance.groupKey(e[Balance.ENTRY_KEY]) == gkey;
              }).map(function (e) {
                var ekey = e[Balance.ENTRY_KEY];
                var ename = e[Balance.ENTRY_NAME];
                var ename2 = Dom0.textAdjust(ename, 340);
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
        return Q("li").html('<a href="#" onclick="return false;">$gname</a>')
          .add(Q("ul").att("id", "hlist")
            .style("list-style:none;padding-left:10px;")
            .addIt(It.from(PyG.entries).filter(function (e) {
                return PyG.groupKey(e[PyG.ENTRY_KEY]) == gkey;
              }).map(function (e) {
                var ekey = e[PyG.ENTRY_KEY];
                var ename = e[PyG.ENTRY_NAME];
                var ename2 =Dom0.textAdjust(ename, 337);
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
    var createdKeys = It.from(data).map(It.f(
      isSubaccount
      ? _1[0].substring(_1[0].length - 2)
      : _1[0].substring(_1[0].length - 1)
    )).to();
    var usedKeys = [];
    var left = isAccount ? mkLeftHelp() : mkEmptyTd();

    var cols = 2;
    if (isEditable) cols += 2;
    if (isAccount) ++cols;

    var selectKey = Ui.select("enterKey",
      (isSubaccount
        ? It.range(0, 26).map(function (n) {
            var r = "0" + Std.string(n);
            return r.substring(r.length - 2);
          })
        : It.range(0, 10).map(It.f(return Std.string(_1)))
      ).filter(function (n) {
        return !It.from(createdKeys).contains(n);
      }).to()).on(CHANGE, function (ev) {
        enterName.e.focus();
      });

    if (keyModify != "") {
      slotKey.removeAll().add(Ui.link(function (ev) {
        enterName.value("");
        groupField.value("");
        keyModify = "";
        showGroups();
      }).add(Ui.img("cancel")));
    } else {
      slotKey.removeAll().add(selectKey);
    }

    var tds = [];
    var rows = [];

    // Edition row
    if (isEditable) {
      tds = [];
      tds.push(Q("td").att("colspan", 2).add(Q("button")
        .att("style",
          "border:1px solid #a0a9ae;padding:0px;width:32px;")
        .att("id", "newBt")
        .add(Ui.img("enter")
          .att("style", "padding:0px;margin:0px;vertical-align:-20%"))
        .on(CLICK, function (ev) {
            var key = control.model.planItem + selectKey.getValue();
            var name = enterName.getValue();
            var group = groupField.getValue();
            if (name == "") {
              Ui.alert(_("Description is missing"));
              return;
            }
            if (group == "" && isAccount) {
              Ui.alert(_("Group is missing"));
              return;
            }
            var name = name.length > 35
              ? name.substring(0, 32) + "..."
              : name;
            if (keyModify != "") {
              control.planMod(keyModify, name, group);
            } else {
              control.planAdd(key, name, group);
            }
          })));
      tds.push(Q("td").add(slotKey));
      tds.push(Q("td").add(enterName));
      if (isAccount) {
        tds.push(Q("td").add(groupField));
      }
      rows.push(Q("tr").addIt(It.from(tds)));
      rows.push(Q("tr")
        .add(Q("td").att("colspan", cols)
          .add(Q("hr").att("height", "1px"))));
    }

    // Title row
    tds = [];
    if (isEditable) {
      tds.push(Q("td").att("colspan", 2));
    }
    tds.push(Q("td").html(_("Nº")));
    tds.push(Q("td").style("text-align:left;").html(_("Description")));
    if (isAccount) {
      tds.push(Q("td").html(_("Group")));
    }
    rows.push(Q("tr").addIt(It.from(tds)));
    rows.push(Q("tr")
      .add(Q("td").att("colspan", cols)
        .add(Q("hr").att("height", "1px"))));

    // Data row
    It.from(data).each(function (r) {
      function mkLink(text) {
        return Ui.link(It.f(control.planGo(r[0]))).klass("link").html(text);
      }

      tds = [];
      if (isEditable) {
        tds.push(Q("td")
          .add(Ui.link(function (ev) {
            enterName.value(r[1]);
            if (isAccount) {
              groupField.value(r[2]);
            }
            keyModify = r[0];
            showGroups();
          }).add(Ui.img("edit"))));
        if (It.from(usedKeys).contains(r[0])) {
          tds.push(Q("td")
            .add(Ui.lightImg("delete")));
        } else {
          tds.push(Q("td")
            .add(Ui.link(function (ev) {
              if (!Ui.confirm(
                I18n.format(_("Delete '%0'?"), ['${r[0]} - ${r[1]}'])
              )) {
                return;
              }
              control.planDel(r[0]);
            }).add(Ui.img("delete"))));
        }
      }
      tds.push(Q("td").style("text-align:right;")
        .html(formatAcc(r[0])));
      if (isSubaccount) {
        tds.push(Q("td").style("text-align:left;").html(r[1]));
      } else {
        tds.push(Q("td").style("text-align:left;").add(mkLink(r[1])));
      }
      if (isAccount) {
        var isPyG = r[2].charAt(0) == "P";
        var keyName = isPyG
          ? It.from(PyG.entries).find(It.f(
              return _1[PyG.ENTRY_KEY] == r[2].substring(1)))
          : It.from(Balance.entries).find(It.f(
              return _1[Balance.ENTRY_KEY] == r[2].substring(1)));
        var key = isPyG
          ? keyName[PyG.ENTRY_KEY]
          : keyName[Balance.ENTRY_KEY];
        var name = isPyG
          ? keyName[PyG.ENTRY_NAME]
          : keyName[Balance.ENTRY_NAME];
        var group = isPyG
          ? It.from(PyG.groups).find(It.f(
              return _1[PyG.GROUP_KEY] == PyG.groupKey(key))
            )[PyG.GROUP_NAME]
          : It.from(Balance.groups).find(It.f(
              return _1[Balance.GROUP_KEY] == Balance.groupKey(key))
            )[Balance.GROUP_NAME];

        tds.push(Q("td").style("text-align:center;")
          .add(Ui.link(It.f(Ui.alert(
              '$group\n$name'
            )))
            .att("title", name)
            .text(r[2])));
      }
      rows.push(Q("tr").addIt(It.from(tds)));
    });

    var right = Q("td").style("text-align:center;vertical-align:top;")
      .add(Q("h2").html(title))
      .add(mkSubmenu())
      .add(Q("table").att("align", "center").klass("frame")
        .addIt(It.from(rows)));

    var table = Q("table").klass("main").add(Q("tr")
      .add(left)
      .add(right));
    Dom1.show(control, "plan", table);
    enterName.e.focus();
  }

  // Control ---------------------------

  public function new(control:Control) {
    this.control = control;
    var model = control.model;
    var item = model.planItem;

    var lg = item.length;
    title = _("Groups");
    data = model.groups;
    if (lg > 0) {
      group = item.charAt(0);
      title = _("Subgroups");
      data = It.from(model.subgroups)
        .filter(It.f(_1[0].charAt(0) == item)).to();
    }
    if (lg > 1) {
      subgroup = item.charAt(1);
      title = _("Accounts");
      data = It.from(model.accounts)
        .filter(It.f(_1[0].substring(0, 2) == item)).to();
    }
    if (lg > 2) {
      account = item.charAt(2);
      title = _("Subaccounts");
      data = It.from(model.subaccounts)
        .filter(It.f(_1[0].substring(0, 3) == item)).to();
    }
    data.sort(It.f2(dm.Str.compare(_1[0], _2[0])));

    isAccount = account == "" && subgroup != "";
    isSubaccount = account != "";
    isEditable = lg != 0 && model.isLastYear;
    keyModify = "";

    showGroups();
  }

  function leftHelpSel(key:String) {
    groupField.value(key);
  }

}

