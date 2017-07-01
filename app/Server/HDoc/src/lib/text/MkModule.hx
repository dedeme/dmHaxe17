/*
 * Copyright 12-Mar-2017 ºDeme
 * GNU General Public License - V3 <http://www.gnu.org/licenses/>
 */

package text;

import dm.It;
using dm.Str;
import text.Model;
import text.Util;

private enum State {
  Code(search:String);
  LongComment;
  ShortComment;
  Quote(isDouble:Bool);
}

class MkModule {
  static var module:ModuleHelp;
  static var currentHelp:ContainerHelp;
  static var state:State;
  static var level:Int;
  static var activeHelp:Bool;
  static var help:StringBuf;
  static var codeBf:StringBuf;
  static var first:Bool;

  static function addHelpElement(type:String, code:String) {
//trace("(" + type+ ") " + code);
    var code2 = code.replace(~/\s+/g, " ");
    var h = help.toString();
    help = new StringBuf();

    module.setHelp(h);

    switch(type) {
      case "package": {}
      case "import" | "using": module.imports.push(code);
      case "class": {
        var subs = ["<", " implements", " extends"];
        var left = Util.leftMin(code2, subs);
        if (Util.existsWord(left, "private")) {
          currentHelp = null;
        } else {
          var c = new ClassHelp(Util.lastWord(left), h, code);
          module.classes.push(c);
          currentHelp = c;
        }
      }
      case "interface": {
        var subs = ["<", " extends"];
        var left = Util.leftMin(code2, subs);
        if (Util.existsWord(left, "private")) {
          currentHelp = null;
        } else {
          var i = new InterfaceHelp(Util.lastWord(left), h, code);
          module.interfaces.push(i);
          currentHelp = i;
        }
      }
      case "abstract": {
        var subs = ["("];
        var left = Util.leftMin(code2, subs);
        if (Util.existsWord(left, "private")) {
          currentHelp = null;
        } else {
          var a = new AbstractHelp(Util.lastWord(left), h, code);
          module.abstracts.push(a);
          currentHelp = a;
        }
      }
      case "enum": {
        currentHelp = null;
        var subs = ["{"];
        var left = Util.leftMin(code2, subs);
        if (!Util.existsWord(left, "private")) {
          var e = new HelpFinal(Util.lastWord(left), h, code);
          module.enums.push(e);
        }
      }
      case "typedef": {
        currentHelp = null;
        var subs = ["="];
        var left = Util.leftMin(code2, subs);
        if (!Util.existsWord(left, "private")) {
          var t = new HelpFinal(Util.lastWord(left), h, code);
          module.typedefs.push(t);
        }
      }
      case "function": {
        var subs = ["(", "<"];
        var left = Util.leftMin(code2, subs);
        if (Util.existsWord(left, "public") && currentHelp != null) {
          var hf = new HelpFinal(Util.lastWord(left), h, code);
          if (Util.existsWord(left, "static")) {
            if (Util.existsWord(left, "macro")) {
              currentHelp.addMacro(hf);
            } else {
              currentHelp.addFunction(hf);
            }
          } else {
            if (Util.existsWord(left, "new")) {
              currentHelp.addConstructor(hf);
            } else {
              currentHelp.addMethod(hf);
            }
          }
        }
      }
      case "var": {
        var subs = ["=", ";", "("];
        var left = Util.leftMin(code2, subs);
        if (Util.existsWord(left, "public") && currentHelp != null) {
          var hf = new HelpFinal(Util.lastWord(left), h, code);
          if (Util.existsWord(left, "static")) {
            currentHelp.addVariable(hf);
          } else {
            currentHelp.addParameter(hf);
          }
        }
      }
      case _ : trace ("Unknow type: '" + type + "'.");
    }
  }

  static function purgeAsterisc(l:String):String {
    var l2 = l.trim();
    if (l2.startsWith("*")) {
      return l2.substring(1);
    }
    return l;
  }

  static function longComment(l:String) {
    state = LongComment;
    if (l.length > 0 && l.charAt(0)== "*") {
      help = new StringBuf();
      activeHelp = true;
      if (l.substring(1).trim().length > 0) {
        help.add(l.substring(1) + "\n");
      }
    }
  }

  static function code(l:String, search:String) {
//trace(level + "--->" + l + "(" + search + ")");
    if (l.trim().length == 0) return;


    if (search.length > 0) {
      var subs = ["{", ";", "="];
      if (search == "enum" || search == "typedef") {
        subs = ["}"];
      } else if (search == "function") {
        subs = ["{", ";"];
      }
      var ixs = It.from(subs).map(It.f(l.indexOf(_1))).to();
      var min = Util.min(ixs);
      var ix = min == -1 ? -1 : ixs[min];
      switch (Util.min(ixs)) {
        case -1: codeBf.add(l + "\n");
        case i: {
          if (subs[i] == "{") ++level;
          codeBf.add(l.substring(0, ix));
          if (subs[i] == "}") codeBf.add("}");
          addHelpElement(search, codeBf.toString());
          // add to structure
          state = Code("");
          code(l.substring(ix + 1), "");
        }
      }
      return;
    }

    codeBf = new StringBuf();
    if (level == 0) {
      var subs = [
        "class", "interface", "abstract", "enum", "typedef", "package",
        "import", "using"
      ];
      var ixs = It.from(subs).map(It.f(l.indexOf(_1))).to();
      var min = Util.min(ixs);
      var ix = min == -1 ? -1 : ixs[min];
      switch (Util.min(ixs)) {
        case -1: {}
        case i : {
          state = Code(subs[i]);
          code(l, subs[i]);
          return;
        }
      }
    } else if (level == 1) {
      var subs = ["function", "var"];
      var ixs = It.from(subs).map(It.f(l.indexOf(_1))).to();
      var min = Util.min(ixs);
      var ix = min == -1 ? -1 : ixs[min];
      switch (Util.min(ixs)) {
        case -1: {}
        case i : {
          state = Code(subs[i]);
          code(l, subs[i]);
          return;
        }
      }
    } else {
      help = new StringBuf();
    }

    var subs = ["{", "}"];
    var ixs = It.from(subs).map(It.f(l.indexOf(_1))).to();
    var min = Util.min(ixs);
    var ix = min == -1 ? -1 : ixs[min];
    switch (Util.min(ixs)) {
      case -1: return;
      case 0: ++level;
      case 1: --level;
    }
    code(l.substring(ix + 1), "");
  }

  static function processLine(l:String) {
    switch (state) {
      case LongComment : {
        var ix = l.indexOf("*/");
        if (ix != -1) {
          var h = l.substring(0, ix);
          if (h.trim() != "") {
            help.add(purgeAsterisc(h));
          }
          state = Code("");
          activeHelp = false;
          processLine(l.substring(ix + 2));
        } else {
          if (activeHelp) {
            help.add(purgeAsterisc(l) + "\n");
          }
        }
      };
      case ShortComment : {
        var l2 = l.trim();
        if (l2.startsWith("///")) {
          help.add(l2.substring(3) + "\n");
        } else {
          state = Code("");
          processLine(l);
        }
      };
      case Quote(isDouble) : {
        var subs = isDouble ? ["\\\"", "\""] : ["\\'", "'"];
        var ixs = It.from(subs).map(It.f(l.indexOf(_1))).to();
        var min = Util.min(ixs);
        var ix = min == -1 ? -1 : ixs[min];
        switch (Util.min(ixs)) {
          case 0: processLine(l.substring(ix + 2));
          case 1: {
            state = Code("");
            processLine(l.substring(ix + 1));
          }
          case _: {
            state = Code("");
          }
        }
      };
      case Code(search): {
        if (search != "") {
          code(l, search);
          return;
        }

        var subs = ["/*", "//", "\"", "'"];
        var ixs = It.from(subs).map(It.f(l.indexOf(_1))).to();
        var min = Util.min(ixs);
        var ix = min == -1 ? -1 : ixs[min];
        switch (Util.min(ixs)) {
          case 0: {
            code(l.substring(0, ix), "");
            longComment(l.substring(ix + 2));
          }
          case 1: {
            var left = l.substring(0, ix).trim();
            var right = l.substring(ix + 2);
            if (left.length == 0 && right.startsWith("/")) {
              help = new StringBuf();
              help.add(right.substring(1) + "\n");
              state = ShortComment;
            } else {
              code(left, "");
            }
          }
          case 2: {
            code(l.substring(0, ix), "");
            help = new StringBuf();
            state = Quote(true);
            processLine(l.substring(ix + 1));
          }
          case 3: {
            code(l.substring(0, ix), "");
            help = new StringBuf();
            state = Quote(false);
            processLine(l.substring(ix + 1));
          }
          case _: code(l, search);
        }
      }
    }
  }

  public static function run(name:String, tx:String):ModuleHelp {
    module = new ModuleHelp(name);
    currentHelp = null;
    level = 0;
    activeHelp = false;
    help = new StringBuf();
    first = true;
    state = Code("");

    for (l in tx.split("\n")) processLine(l);

    return module;
  }
}
