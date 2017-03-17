/*
 * Copyright 09-Mar-2017 ºDeme
 * GNU General Public License - V3 <http://www.gnu.org/licenses/>
 */

import dm.Client;
import dm.Store;
import dm.I18n;
import dm.I18n._;
import dm.It;
import dm.Ui.alert;
import Fields;
import ConfCm;
import Dom;

///
class Conf {
  static var client:Client;
  static var conf;

  ///
  public static function main() {
    client = Global.client();
    client.send("lib/index.js", "getConfPaths", "", function (rp:Dynamic) {
      var cp = ConfData.restore(rp);
      conf = cp.conf;
      var table = cp.paths;

      Global.setLanguage(conf.lang);
      client.setPageId(function () {
        alert(_("Current page is expired.\nPress [Accept] to reload."));
        Dom.go("");
      });

      Dom.show(client, table, "");
      dm.Ui.QQ("title").next().text("HDoc : Conf");
      new ConfW(table).show();
    });
  }

  ///
  public static function getShowAll ():Bool {
    return conf.visible;
  }

  static function validateName (sources:Array<PathsData>, name:String):String {
    return name == ""
      ? _("Name is missing")
      : name.indexOf("=") != -1
        ? I18n.format(_("Name '%0' contains '%1'"), [name, "="])
        : name.indexOf("@") != -1
          ? I18n.format(_("Name '%0' contains '%1'"), [name, "@"])
          : name.indexOf("/") != -1
            ? I18n.format(_("Name '%0' contains '%1'"), [name, "/"])
            : name.indexOf(" ") != -1
              ? I18n.format(_("Name '%0' contains blanks"), [name])
              : It.from(sources).any(function (row) {
                  return row.name == name;
                })
                ? I18n.format(_("Name '%0' is repeated"), [name])
                : "";
  };

  static function validatePath (path:String):String {
    return path == ""
      ? _("Path is missing")
      : StringTools.endsWith(path, "/")
        ? _("Path can not end with '/'")
        : "";
  };

  /// 'name' and 'path' without trimming
  public static function newPath (
    sources:Array<PathsData>, name:String, path:String
  ) {
    if (!client.controlPageId()) return;

    name = StringTools.trim(name);
    path = StringTools.replace(StringTools.trim(path), "\\", "/");
    var vname = validateName(sources, name);
    var vpath = validatePath(path);

    if (vname != "") {
      alert(vname);
    } else if (vpath != "") {
      alert(vpath);
    } else {
      var rq:AddRq = {name:name, path:path};
      client.send("conf/index.js", "add", rq, function (x) { main(); });
    }
  }

  ///
  public static function changeShowAll () {
    if (!client.controlPageId()) return;

    var nc = new ConfEntry(conf.path, !conf.visible, conf.lang);
    client.send("lib/index.js", "setConf", nc.serialize(),
      function (x) { main(); });
  }

  ///
  public static function selPath (name:String, value:Bool, exists:Bool) {
    if (!client.controlPageId()) return;

    if (!exists) {
      alert(_("This source can not be selected, because it does not exist"));
      return;
    }
    var rq:SelRq = {name:name, selected:value};
    client.send("conf/index.js", "sel", rq, function (x) { main(); });
  }

  ///
  public static function modifyBegin (selector:ConfW, name:String) {
    if (!client.controlPageId()) return;

    selector.modifyBegin(name);
  }

  ///
  public static function deletePath (name:String) {
    if (!client.controlPageId()) return;

    if (js.Browser.window.confirm(I18n.format(_("Delete %0?"), [name]))) {
      var rq:DelRq = {name:name};
      client.send("conf/index.js", "del", rq, function (x) { main(); });
    }
  }

  /// Configuration: Action modify, first phase
  ///   oldName
  ///   newName : without trimming.
  ///   oldPath
  ///   newPath : without trimming.
  public static function modifyPath (
    sources:Array<PathsData>, oldName:String, newName:String,
    oldPath:String, newPath:String
  ) {
    if (!client.controlPageId()) return;

    newName = StringTools.trim(newName);
    newPath = StringTools.replace(StringTools.trim(newPath), "\\", "/");
    var vname = validateName(sources, newName);
    var vpath = validatePath(newPath);

    if (newName != oldName && vname != "") {
      alert(vname);
    } else if (vpath != "") {
      alert(vpath);
    } else {
      if (oldName == newName && oldPath == newPath) {
        main();
      } else {
        var rq:ModifyRq = {oldName:oldName, newName:newName, path:newPath};
        client.send("conf/index.js", "modify", rq, function (x) { main(); });
      }
    }
  }

  ///
  public static function changeLang () {
    if (!client.controlPageId()) return;

    var lang = conf.lang == "en" ? "es" : "en";
    var nc = new ConfEntry(conf.path, conf.visible, lang);
    client.send("lib/index.js", "setConf", nc.serialize(),
      function (x) { main(); });
  }

  public static function changePass () {
    Dom.go("../chpass/index.html");
  }
}
