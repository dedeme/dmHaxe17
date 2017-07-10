/*
 * Copyright 04-Mar-2016 ºDeme
 * GNU General Public License - V3 <http://www.gnu.org/licenses/>
 */

/// Utilities to access to DOM
package dm;

/// Actions types to use with DomObject.on
enum ActionType {
  BLUR; CHANGE; CLICK; DBLCLICK; FOCUS; KEYDOWN; KEYPRESS; KEYUP;
  LOAD; MOUSEDOWN; MOUSEMOVE; MOUSEOUT; MOUSEOVER; MOUSEUP; MOUSEWHEEL;
  SELECT; SELECTSTART; SUBMIT;
}

/// Class for envelopping DOM objects
class DomObject {

  ///
  public var e(default, null):js.html.DOMElement;

  ///
  public function new (e:js.html.DOMElement) {
    this.e = e;
  }

  ///
  public function getHtml ():String {
    return e.innerHTML;
  }

  ///
  public function html (tx:String):DomObject {
    e.innerHTML = tx;
    return this;
  }

  ///
  public function getText ():String {
    return e.textContent;
  }

  ///
  public function text (tx:String):DomObject {
    e.textContent = tx;
    return this;
  }

  ///
  public function getClass ():String {
    return e.className;
  }

  ///
  public function klass (tx:String):DomObject {
    e.className = tx;
    return this;
  }

  ///
  public function getStyle ():String {
    return e.getAttribute("style");
  }

  ///
  public function style (tx:String):DomObject {
    e.setAttribute("style", tx);
    return this;
  }

  ///
  public function addStyle(tx:String):DomObject {
    e.setAttribute("style", getStyle() + ";" + tx);
    return this;
  }

  ///
  public function getAtt (key:String):Dynamic {
    return e.getAttribute(key);
  }

  ///
  public function att (key:String, value:Dynamic):DomObject {
    e.setAttribute(key, value);
    return this;
  }

  ///
  public function isDisabled ():Bool {
    return (cast(e)).disabled;
  }

  ///
  public function disabled (v:Bool):DomObject {
    (cast(e)).disabled = v;
    return this;
  }

  ///
  public function getValue ():Dynamic {
    return (cast(e)).value;
  }

  ///
  public function value (v:Dynamic):DomObject {
    (cast(e)).value = v;
    return this;
  }

  ///
  public function getChecked ():Dynamic {
    return (cast(e)).checked;
  }

  ///
  public function checked (v:Bool):DomObject {
    (cast(e)).checked = v;
    return this;
  }

  ///
  public function add (o:DomObject):DomObject {
    e.appendChild(o.e);
    return this;
  }

  /// Thought for &lt;tr>'s in a table.
  public function addIt (obs:dm.It<DomObject>):DomObject {
    obs.each(function (ob) {
      e.appendChild(ob.e);
    });
    return this;
  }

  ///
  public function remove (o:DomObject):DomObject {
    e.removeChild(o.e);
    return this;
  }

  ///
  public function removeAll ():DomObject {
    e.innerHTML = "";
    return this;
  }

  ///
  public function on (type:ActionType, action:Dynamic -> Void):DomObject {
    var act = switch type {
      case BLUR: "blur";
      case CHANGE: "change";
      case CLICK: "click";
      case DBLCLICK: "dblclick";
      case FOCUS: "focus";
      case KEYDOWN: "keydown";
      case KEYPRESS: "keypress";
      case KEYUP: "keyup";
      case LOAD: "load";
      case MOUSEDOWN: "mousedown";
      case MOUSEMOVE: "mousemove";
      case MOUSEOUT: "mouseout";
      case MOUSEOVER: "mouseover";
      case MOUSEUP: "mouseup";
      case MOUSEWHEEL: "mouseweel";
      case SELECT: "select";
      case SELECTSTART: "selectstart";
      case SUBMIT: "submit";
    }
    e.addEventListener(act, action, false);
    return this;
  }

}
