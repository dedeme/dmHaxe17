/*
 * Copyright 04-Mar-2016 ºDeme
 * GNU General Public License - V3 <http://www.gnu.org/licenses/>
 */

/// Utilities to access to DOM elements.
package dm;

import dm.It;
import dm.Tuple;
import dm.DomObject;
import dm.Cryp;

/// Utilities to access to DOM elements.
class Ui {

  /// Constructor for DomObjects
  ///   If 'str' is null returns a DmObject with element 'el' (e.g. Q(myTable))
  ///   Otherwise
  ///     - If 'str' starts with '#', returns element by id (e.g. Q("#myTable"))
  ///     - If 'str' starts with '@', returns a querySelector
  ///       (e.g. Q("@myTable"))
  ///     - Otherwise creates the indicated object (e.g. Q("table"))
  public static function Q (?str:String, ?el:js.html.Element): dm.DomObject {
    if (str == null) {
      return new DomObject(el);
    }
    return switch str.charAt(0) {
      case '#': new DomObject(
        js.Browser.document.getElementById(str.substring(1)));
      case '@': new DomObject(
        js.Browser.document.querySelector(str.substring(1)));
      case _: new DomObject(js.Browser.document.createElement(str));
    }
  }

  /// Returns a DomObject It:
  ///   If 'str' is an empty string returns all elements of page.
  ///   If 'str' is of form "%xxx" returns elements with name "xxx".
  ///   If 'str' is of form ".xxx" returns elements of class 'xxx'.
  ///   If it is of form "xxx" returns elements with tag name 'xxx'.
  public static function QQ (?str:String):It<DomObject> {
    var toIt = function (list:Dynamic):It<DomObject> {
      var c = 0;
      var len = list.length;
      return new It<DomObject> (
        function () {
          return c < len;
        },
        function () {
          return new DomObject(cast(list.item(c++)));
        }
      );
    }
    if (str == "") {
      return toIt(js.Browser.document.getElementsByTagName("*"));
    }
    if (str.charAt(0) == "%") {
      return toIt(js.Browser.document.getElementsByName(str.substring(1)));
    }
    if (str.charAt(0) == ".") {
      return toIt(js.Browser.document.getElementsByClassName(str.substring(1)));
    }
    return toIt(js.Browser.document.getElementsByTagName(str));
  }

  /// Shows a modal message.
  ///   msg: Message. It will be convereted to String
  public static function alert (msg:Dynamic):Void {
    untyped __js__("alert")(Std.string(msg));
  }

  /// Shows a modal message and retuns a confirmation.
  ///   msg: Message. It will be convereted to String
  public static function confirm (msg:Dynamic):Bool {
    return untyped __js__("confirm")(Std.string(msg));
  }

  /// Shows a modal message and retuns a value.
  ///   msg: Message. It will be convereted to String
  ///   def: Default value. It will be convereted to String
  public static function prompt (msg:Dynamic, ?def:Dynamic):String {
    if (def == null) {
      return untyped __js__("prompt")(Std.string(msg));
    } else {
      return untyped __js__("prompt")(Std.string(msg), Std.string(def));
    }
  }

  /// Extracts variables of URL. Returns a map with next rules:
  ///   Expresions 'key = value' are changed in ["key" => "value"]
  ///   Expresion only with value are changes by ["its-order-number" => "value"].
  ///     (order-number is zero based)
  /// Example:
  ///   foo.com/bar?v1&k1=v2&v3 -> {"0" => v1, "k1" => v2, "2" => v3}
  /// NOTE: <i>keys and values are not trimized.</i>
  public static function url ():Map<String, String> {
    var search = js.Browser.location.search;
    if (search == "") {
      return new Map();
    }
    return It.from(search.substring(1).split("&")).reduce(
      new Tp2(new Map(), 0),
      function (s, e) {
        var ix = e.indexOf("=");
        if (ix == -1) {
          s._1.set(Std.string(s._2), Cryp.u2s(e));
        } else {
          s._1.set(
            Cryp.u2s(e.substring(0, ix)),
            Cryp.u2s(e.substring(ix + 1)));
        }
        return new Tp2(s._1, s._2 + 1);
      }
    )._1;
  }

  static var scripts = new Map<String, DomObject>();
  /// Loads dynamically a javascript or css file.
  ///   path   : Complete path, including .js or .css extension.
  ///   action : Action after loading
  public static function load (path:String, action:Void -> Void):Void {
    var element:DomObject;
    var head = js.Browser.document.getElementsByTagName("head")[0];

    if (scripts.exists(path)) {
      var obj = scripts.get(path);
      if (obj != null && obj.e != null) {
        head.removeChild(obj.e);
      }
      scripts.remove(path);
    }

    if (path.substring(path.length - 3) == ".js") {
      element = Q("script").att("type", "text/javascript").att("src", path);
    } else if (path.substring(path.length - 4) == ".css") {
      element = Q("link").att("rel", "stylesheet").att("type", "text/css")
        .att("href", path);
    } else {
      throw "'" + path + "' is not a .js or .css file";
    }
    scripts.set(path, element);
    head.appendChild(element.e);
    element.e.onload = function (e) { action(); };
  }

  /// Loads dynamically several javascript or css files. (they can go mixed).
  ///   paths  : Array with complete paths, including .js or .css extension.
  ///   action : Action after loading
  public static function loads (paths:Array<String>, action:Void -> Void):Void {
    var lload:Void -> Void = null;

    lload = function () {
      if (paths.length == 0) {
        action();
      } else {
        load(paths.shift(), lload);
      }
    }
    lload();
  }

  /// Loads a text file from the server which hosts the current page.
  ///   path   : Path of file. Must be absolute, but without protocol and name
  ///            server (e.g. http://server.com/dir/file.txt, must be written
  ///            "/dir/file.txt")
  ///   action : Callback which receives the text.
  public static function loadData(path:String, action:String->Void) {
    var url = "http://" + js.Browser.location.host + path;
    var request = js.Browser.createXMLHttpRequest();
    request.onreadystatechange = function (e) {
      if (request.readyState == 4) {
        action(request.responseText);
      }
    };
    request.open("GET", url, true);
    request.send();
  }

  /// Management of Drag and Drop of files over an object.
  ///   o      : Object over whom is going to make Drag and Drop. It has a
  ///            white background.
  ///   action : Action to make with files.
  /// NOTE: <i>For accessing to single files use <tt>fileList.item(n)</tt>. You
  /// can know the file number of files with <tt>fileList.length</tt>.</i>
  public static function ifiles (
    o:DomObject, action:js.html.FileList->Void
  ):DomObject {
    var style = o.getAtt("style");
    function handleDragOver (evt) {
      o.att("style", style + ";background-color: rgb(240, 245, 250);");
      evt.stopPropagation();
      evt.preventDefault();
      evt.dataTransfer.dropEffect = 'copy';
    }
    o.e.addEventListener("dragover", handleDragOver, false);

    o.e.addEventListener("dragleave", function (evt) {
      o.att("style", style);
    }, false);

    function handleDrop (evt) {
      o.att("style", style);
      evt.stopPropagation();
      evt.preventDefault();

      action(evt.dataTransfer.files);

    }
    o.e.addEventListener("drop", handleDrop, false);

    return o;
  }

  /// Changes key point of keyboard number block by comma.
  ///   inp : An input of text type.
  public static function changePoint (inp:DomObject):DomObject {
    var el:js.html.InputElement = cast(inp.e);
    el.onkeydown = function (e) {
      if (e.keyCode == 110) {
        var start = el.selectionStart;
        var end = el.selectionEnd;
        var text = el.value;

        el.value = text.substring(0, start) + "," + text.substring(end);
        el.selectionStart = start + 1;
        el.selectionEnd = start + 1;

        return false;
      }
      return true;
    }
    return inp;
  }

  /// Creates a image with border='0'.
  ///   name : Image name without extension ('.png' will be used).
  ///          It must be placed in a directory named 'img'.
  public static function img (name:String):DomObject {
    return Q("img").att("src", "img/" + name + ".png");
  }

  /// Creates a image with border='0' and a 'opacity:0.4'.
  ///   name : Image name without extension ('.png' will be used).
  ///          It must be placed in a directory named 'img'.
  public static function lightImg (name:String):DomObject {
    return img(name).att("style", "opacity:0.4");
  }

  /// Creates a text field which passes focus to another element.
  ///   targetId : Id of element which will receive the focus.
  public static function field (targetId:String):DomObject {
    var r = Q("input").att("type", "text");
    r.e.onkeydown = function (e) {
      if (e.keyCode == 13) {
        e.preventDefault();
        Q("#" + targetId).e.focus();
      }
    }
    return r;
  }

  /// Creates a password field which passes focus to another element.
  ///   targetId : Id of element which will receive the focus.
  public static function pass (targetId:String):DomObject {
    var r = Q("input").att("type", "password");
    r.e.onkeydown = function (e) {
      if (e.keyCode == 13) {
        e.preventDefault();
        Q("#" + targetId).e.focus();
      }
    }
    return r;
  }

  /// Creates a text field with a validation function.
  ///   targetId : Id of element which will receive the focus.
  ///   action   : Validation function.
  public static function fieldAc (
    targetId:String,
    action:js.html.EventListener -> Void
  ):DomObject {
    var r = field(targetId);
    r.e.onblur = action;
    return r;
  }

  /// Create a link to a function.
  ///  f : Function to execute.
  public static function link (f:Dynamic -> Void):DomObject {
    return Q("span").att("style", "cursor:pointer").on(CLICK, f);
  }

  /// Create a 'select' with a list if entries. Every option has an id formed
  /// with 'idPrefix' + "_" + 'its list name' and a name equals to 'idPrefix'.
  /// <p>
  /// Also the 'select' widget has then name 'idPrefix'.
  ///   idPrefix : Prefix to build the option id.
  ///   list     : Entries of select. Default selected is marked with '+'
  ///     (e.g. ["1", "+2", "3"])
  public static function select(
    idPrefix:String,
    list:Array<String>
  ):DomObject {
    var r = Q("select").att("id", idPrefix);
    It.from(list).each(function (tx) {
      var op = Q("option");
      if (tx.length > 0 && tx.charAt(0) == "+") {
        tx = tx.substring(1);
        op.att("selected", "true");
      }
      op.text(tx).att("name", idPrefix).att("id", idPrefix + "_" + tx);
      var sEl:js.html.SelectElement = cast(r.e);
      var oEl:js.html.OptionElement = cast(op.e);

      sEl.add(oEl, null);
    });
    return r;
  }

  /// Emits a beep
  public static function beep() {
    var au = new js.html.audio.AudioContext();
    var o = au.createOscillator();
    o.frequency.value = 990;
    o.connect(au.destination);
    o.start(0);
    haxe.Timer.delay(function() {o.stop(0);}, 80);
  }

  /// Returns x position of mouse in browser window
  public static function mouseX(e:js.html.MouseEvent):Int {
    return js.Browser.document.documentElement.scrollLeft +
      js.Browser.document.body.scrollLeft +
      e.clientX;
  }

  /// Returns y position of mouse in browser window
  public static function mouseY(e:js.html.MouseEvent):Int {
    return js.Browser.document.documentElement.scrollTop +
      js.Browser.document.body.scrollTop +
      e.clientY;
  }
}
