/*
 * Copyright 15-Mar-2017 ºDeme
 * GNU General Public License - V3 <http://www.gnu.org/licenses/>
 */

using StringTools;
import dm.It;
import dm.DomObject;
import dm.Ui;
import dm.Ui.Q;
import dm.I18n;
import dm.I18n._;
import dm.Client;
import text.Model;
import text.Util;
import Fields;

class ModuleView {
  static var pack = "";

  static function addTopLinks() {
    var headers = js.Browser.document.getElementsByTagName('h3');
    for (i in 0 ... headers.length) {
      var span = js.Browser.document.createElement('span');
      span.className = 'navtop';
      var link : Dynamic = js.Browser.document.createElement("a");
      span.appendChild(link);
      link.href = "#top";
      link.className ="navtop";
      var textNode = js.Browser.document.createTextNode('[Top]');
      link.appendChild(textNode);
      headers[i].appendChild(link);
    }
  }

  static function index(bf:StringBuf, mod:ModuleHelp) {
    function sort<T>(a:Array<T>):Array<T> {
      var n:Array<Named> = cast(a);
      n.sort(Named.sort);
      return cast(n);
    }

    var tab = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";

    bf.add("<p class='frame2'><b>" +   mod.name + "</b></p>");

    bf.add("<table border=0 width='100%'><tr>" +
      "<td valign='top' style='width:5px;white-space:nowrap'>");

    var count = mod.count ();
    var nCol = count < 10
      ? 10
      : count < 20
        ? Math.ceil(count / 2)
        : count < 30
          ? Math.ceil(count / 3)
          : Math.ceil(count / 4);
    var c = 0;
    function nextC() {
      if (++c >= nCol) {
        bf.add ("</td><td style='width:50px;'></td>" +
          "<td valign='top' style='width:5px;white-space:nowrap'>");
        c = 0;
      }
    }

    for (e in sort(mod.enums)) {
      bf.add("<a href='#hp:" + e.name + "'>enum " + e.name + "</a><br>");
      nextC();
    }

    for (t in sort(mod.typedefs)) {
      bf.add("<a href='#hp:" + t.name + "'>typdef " + t.name + "</a><br>");
      nextC();
    }

    for (c in sort(mod.interfaces)) {
      bf.add("<a href='#hp:" + c.name + "'>interface " + c.name + "</a><br>");
      nextC();

      for (p in sort(c.parameters)) {
        bf.add (tab + "<a href='#hp:" + c.name + "." + p.name
        + "'>" + p.name + "</a><br>"
        );
        nextC();
      }
      for (m in sort(c.methods)) {
        bf.add (tab + "<a href='#hp:" + c.name + "." + m.name
        + "'>" + m.name + "()</a><br>"
        );
        nextC();
      }

    }

    for (c in sort(mod.classes)) {
      bf.add("<a href='#hp:" + c.name + "'>class " + c.name + "</a><br>");
      nextC();

      for (p in sort(c.parameters)) {
        bf.add (tab + "<a href='#hp:" + c.name + "." + p.name
        + "'>" + p.name + "</a><br>"
        );
        nextC();
      }
      for (x in sort(c.constructors)) {
        bf.add (tab + "<a href='#hp:" + c.name + "." + x.name
        + "' style='color:#800000'>" + x.name + " ()</a><br>"
        );
        nextC();
      }
      for (m in sort(c.methods)) {
        bf.add (tab + "<a href='#hp:" + c.name + "." + m.name
        + "'>" + m.name + "()</a><br>"
        );
        nextC();
      }
      for (v in sort(c.variables)) {
        bf.add (tab + "<a href='#hp:" + c.name + "." + v.name
        + "'><i>" + v.name + "</i></a><br>"
        );
        nextC();
      }
      for (f in sort(c.functions)) {
        bf.add (tab + "<a href='#hp:" + c.name + "." + f.name
        + "'><i>" + f.name + "()</i></a><br>"
        );
        nextC();
      }
      for (m in sort(c.macros)) {
        bf.add (tab + "<a href='#hp:" + c.name + "." + m.name
        + "' style='color:#800000'><i>" + m.name + "()</i></a><br>"
        );
        nextC();
      }

    }

    for (c in sort(mod.abstracts)) {
      bf.add("<a href='#hp:" + c.name + "'>abstract " + c.name + "</a><br>");
      nextC();

      for (p in sort(c.parameters)) {
        bf.add (tab + "<a href='#hp:" + c.name + "." + p.name
        + "'>" + p.name + "</a><br>"
        );
        nextC();
      }
      for (x in sort(c.constructors)) {
        bf.add (tab + "<a href='#hp:" + c.name + "." + x.name
        + "' style='color:#800000'>" + x.name + " ()</a><br>"
        );
        nextC();
      }
      for (m in sort(c.methods)) {
        bf.add (tab + "<a href='#hp:" + c.name + "." + m.name
        + "'>" + m.name + "()</a><br>"
        );
        nextC();
      }
      for (v in sort(c.variables)) {
        bf.add (tab + "<a href='#hp:" + c.name + "." + v.name
        + "'><i>" + v.name + "</i></a><br>"
        );
        nextC();
      }
      for (f in sort(c.functions)) {
        bf.add (tab + "<a href='#hp:" + c.name + "." + f.name
        + "'><i>" + f.name + "()</i></a><br>"
        );
        nextC();
      }
      for (m in sort(c.macros)) {
        bf.add (tab + "<a href='#hp:" + c.name + "." + m.name
        + "' style='color:#800000'><i>" + m.name + "()</i></a><br>"
        );
        nextC();
      }

    }

    bf.add ("</td><td></td></tr></table><hr>");
  }

  static function overview(bf:StringBuf, mod:ModuleHelp) {
    bf.add("<p class='frame'><b>Overview</b></p>");
    bf.add(ModuleModel.mkHelp(mod.help));
    bf.add("<p><b>File</b><br><a href='../code/index.html?" +
      pack + "@" + mod.name + "&hp:'>" +
      mod.name + ".hx" + "</a>"
    );
    It.from(mod.imports).each(function(m) {
      bf.add("<br><tt>" + m.trim() + "</tt>");
    });
    bf.add("</p><hr>");
  }

  static function body(bf:StringBuf, mod:ModuleHelp) {
    function makeLink(link:String, name:String):String {
      return "<a href='../code/index.html?" + pack + "@" + mod.name +
        "&hp:" + link + "'>" + name + "</a>";
    }
    function endEntry(bf:StringBuf, e:HelpFinal) {
      var isNewLine = false;
      var bf2 = new StringBuf();
      It.fromStr(Util.html(e.code)).each(function (ch) {
        if (isNewLine) {
          if (ch == " ") {
            bf2.add("&nbsp;");
          } else {
            bf2.add(ch);
            isNewLine = false;
          }
        } else {
          if (ch == "\n") {
            bf2.add("<br>");
            isNewLine = true;
          } else {
            bf2.add(ch);
          }
        }
      });
      bf.add("<p><tt>" + bf2.toString()  + "</tt></p>");
      bf.add(ModuleModel.mkHelp(e.help));
      bf.add("<hr>");
    }

    It.from(mod.enums).each(function (e) {
      bf.add ("<h3 id='hp:" + e.name + "'>enum " +
        makeLink (e.name, e.name) + "</h3>"
      );
      endEntry(bf, e);
    });

    It.from(mod.typedefs).each(function (t) {
      bf.add ("<h3 id='hp:" + t.name + "'>typedef " +
        makeLink (t.name, t.name) + "</h3>"
      );
      endEntry(bf, t);
    });

    It.from(mod.interfaces).each(function (c) {
      bf.add ("<h3 id='hp:" + c.name + "'>interface " +
        makeLink (c.name, c.name) + "</h3>"
      );
      endEntry(bf, c);

      for (e in c.parameters) {
        var path = c.name + "." + e.name;
        bf.add ("<h3 id='hp:" + path + "'>Parameter "
        + makeLink (path, e.name) + " [" + c.name + "]</h3>"
        );
        endEntry (bf, e);
      }
      for (e in c.methods) {
        var path = c.name + "." + e.name;
        bf.add ("<h3 id='hp:" + path + "'>Method "
        + makeLink (path, e.name) + " [" + c.name + "]</h3>"
        );
        endEntry (bf, e);
      }
    });

    for (c in mod.classes) {
      bf.add ("<h3 id='hp:" + c.name + "'>class " +
        makeLink (c.name, c.name) + "</h3>"
      );
      endEntry(bf, c);

      for (e in c.parameters) {
        var path = c.name + "." + e.name;
        bf.add ("<h3 id='hp:" + path + "'>Parameter "
        + makeLink (path, e.name) + " [" + c.name + "]</h3>"
        );
        endEntry (bf, e);
      }
      for (e in c.constructors) {
        var path = c.name + "." + e.name;
        bf.add ("<h3 id='hp:" + path + "'>Constructor "
        + makeLink (path, e.name) + " [" + c.name + "]</h3>"
        );
        endEntry (bf, e);
      }
      for (e in c.methods) {
        var path = c.name + "." + e.name;
        bf.add ("<h3 id='hp:" + path + "'>Method "
        + makeLink (path, e.name) + " [" + c.name + "]</h3>"
        );
        endEntry (bf, e);
      }
      for (e in c.variables) {
        var path = c.name + "." + e.name;
        bf.add ("<h3 id='hp:" + path + "'>Variable "
        + makeLink (path, path) + "</h3>"
        );
        endEntry (bf, e);
      }
      for (e in c.functions) {
        var path = c.name + "." + e.name;
        bf.add ("<h3 id='hp:" + path + "'>Function "
        + makeLink (path, path) + "</h3>"
        );
        endEntry (bf, e);
      }
      for (e in c.macros) {
        var path = c.name + "." + e.name;
        bf.add ("<h3 id='hp:" + path + "'>Macro "
        + makeLink (path, path) + "</h3>"
        );
        endEntry (bf, e);
      }

    }

    It.from(mod.abstracts).each(function (c) {
      bf.add ("<h3 id='hp:" + c.name + "'>abstract " +
        makeLink (c.name, c.name) + "</h3>"
      );
      endEntry(bf, c);

      for (e in c.parameters) {
        var path = c.name + "." + e.name;
        bf.add ("<h3 id='hp:" + path + "'>Parameter "
        + makeLink (path, e.name) + " [" + c.name + "]</h3>"
        );
        endEntry (bf, e);
      }
      for (e in c.constructors) {
        var path = c.name + "." + e.name;
        bf.add ("<h3 id='hp:" + path + "'>Constructor "
        + makeLink (path, e.name) + " [" + c.name + "]</h3>"
        );
        endEntry (bf, e);
      }
      for (e in c.methods) {
        var path = c.name + "." + e.name;
        bf.add ("<h3 id='hp:" + path + "'>Method "
        + makeLink (path, e.name) + " [" + c.name + "]</h3>"
        );
        endEntry (bf, e);
      }
      for (e in c.variables) {
        var path = c.name + "." + e.name;
        bf.add ("<h3 id='hp:" + path + "'>Variable "
        + makeLink (path, path) + "</h3>"
        );
        endEntry (bf, e);
      }
      for (e in c.functions) {
        var path = c.name + "." + e.name;
        bf.add ("<h3 id='hp:" + path + "'>Function "
        + makeLink (path, path) + "</h3>"
        );
        endEntry (bf, e);
      }
      for (e in c.macros) {
        var path = c.name + "." + e.name;
        bf.add ("<h3 id='hp:" + path + "'>Macro "
        + makeLink (path, path) + "</h3>"
        );
        endEntry (bf, e);
      }

    });

  }

  public static function show(
    client:Client, paths:Array<PathsData>, selected:String, mod:ModuleHelp
  ){
    pack = selected;

    var bf = new StringBuf();

    index (bf, mod);
    overview (bf, mod);
    bf.add ("<hr class='frame'>");
    body (bf, mod);

    It.range(22).each(function (e) {
      bf.add ("<p>&nbsp;</p>");
    });

    Dom.body.removeAll().html(bf.toString());
    Dom.show(client, paths, selected);
    addTopLinks();

    var ix = mod.name.lastIndexOf("/");
    Ui.QQ("title").next().text(
      "HDoc : " +
      (ix == -1 ? mod.name : mod.name.substring(ix + 1))
    );

    if (js.Browser.navigator.vendor.indexOf("Google") != -1) {
      var hash = js.Browser.location.hash;
      js.Browser.location.hash = "";
      js.Browser.location.hash = hash;
    }
  }
}
