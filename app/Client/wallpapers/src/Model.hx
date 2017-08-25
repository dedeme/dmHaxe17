/*
 * Copyright 06-Aug-2017 ºDeme
 * GNU General Public License - V3 <http://www.gnu.org/licenses/>
 */

using StringTools;
import dm.Store;
import dm.It;
import dm.Json;
import dm.B64;

class Model {
  static inline var StorePrefix = "dm_wallpapers_";
  static inline var MAX_FUNCTIONS = 10;
  static inline var EMPTY_INSTRUCTION = "return 0;";

  public var language(default, null):String;

  public var precodeShow:Bool;
  public var precode(default, null):Array<String>;
  public var fcs(default, null):Array<Array<String>>;
  public var fcs2(default, null):Array<String>;

  public var canvasSize(default, null) = 1; // to 12
  public var canvaspx(default, null) = 0;
  public var canvaspy(default, null) = 0;
  public var canvaspw(default, null) = 0;
  public var canvasph(default, null) = 0;
  public var canvasw(default, null) = 0;
  public var canvash(default, null) = 0;

  public var lastx(default, null) = 0.0;
  public var lasty(default, null) = 0.0;

  function new(
    language:String,
    precodeShow:Bool,
    precode:Array<String>,
    fcs:Array<Array<String>>,
    canvasSize:Int,
    lastCoor:Array<Float>
  ) {
    this.language = language;
    this.precodeShow = precodeShow;
    this.precode = precode;
    this.fcs = fcs;
    fcs2 = It.range(3).map(It.f(fcNormalize(fcs[_1][0]))).to();
    lastx = lastCoor[0];
    lasty = lastCoor[1];

    this.canvasSize = canvasSize;
    canvasSizeCalc();
  }

  function canvasSizeCalc() {
    canvaspx = canvaspy = canvasSize;
    canvaspw = 100;
    canvasph = 75;
    if (canvasSize == 6) {
      canvaspx = canvaspy = 5;
      canvaspw = 128;
      canvasph = 96;
    } else if (canvasSize == 7) {
      canvaspx = canvaspy = 8;
    } else if (canvasSize == 8) {
      canvaspx = canvaspy = 8;
      canvaspw = 128;
      canvasph = 96;
    } else if (canvasSize == 9) {
      canvaspx = canvaspy = 10;
      canvaspw = 128;
      canvasph = 80;
    } else if (canvasSize == 10) {
      canvaspx = canvaspy = 10;
      canvaspw = 128;
      canvasph = 96;
    } else if (canvasSize == 11) {
      canvaspx = 10;
      canvaspy = 8;
      canvaspw = canvasph = 128;
    } else if (canvasSize == 12) {
      canvaspx = canvaspy = 10;
      canvaspw = 140;
      canvasph = 105;
    } else if (canvasSize == 13) {
      canvaspx = canvaspy = 10;
      canvaspw = 160;
      canvasph = 120;
    }

    canvasw = canvaspx * canvaspw;
    canvash = canvaspy * canvasph;
  }

  public function setLanguage(lang:String) {
    this.language = lang;
    save();
  }

  public function setCoor(x:Float, y:Float) {
    lastx = x / canvasw;
    lasty = 1 - y / canvash;
    save();
  }

  function fcNormalize(tx:String) {
    return "(function (x, y) {\n" +
      precode[0].replace("#", "Math.").replace("·", "Math.") +
      tx.replace("#", "Math.").replace("·", "Math.") +
      "\n}(x, y));\n"
    ;
  }

  public function setPrecodeShow(value:Bool) {
    precodeShow = value;
    save();
  }

  /// Changes last precode
  public function precodeSet(tx:String) {
    precode[0] = tx;
    for (i in 0...3) {
      fcs2[i] = fcNormalize(fcs[i][0]);
    }
    save();
  }

  /// Changes the last formula for color ix (0-Red, 1-Green, 2-Blue)
  public function fcSet(ix:Int, tx:String) {
    fcs[ix][0] = tx;
    fcs2[ix] = fcNormalize(tx);
    save();
  }

  /// Adds precode and fcs to historic
  public function fcPush() {
    if (precode[0] != precode[1]) {
      for (i in 1...MAX_FUNCTIONS) {
        precode[MAX_FUNCTIONS - i] = precode[MAX_FUNCTIONS - 1 - i];
      }
    }
    for (ix in 0...3) {
      if (fcs[ix][0] != fcs[ix][1]) {
        for (i in 1...MAX_FUNCTIONS) {
          fcs[ix][MAX_FUNCTIONS - i] = fcs[ix][MAX_FUNCTIONS - 1 - i];
        }
      }
    }
    save();
  }

  /// Undo precode
  public function precodeUndo() {
    if (precode[0] == precode[1]) {
      for (i in 0...MAX_FUNCTIONS-1) {
        precode[i] = precode[i + 1];
      }
      precode[MAX_FUNCTIONS - 1] = precode[0];
    }
    precodeSet(precode[1]);
  }

  /// Undo fcs[ix]
  public function fcUndo(ix:Int) {
    if (fcs[ix][0] == fcs[ix][1]) {
      for (i in 0...MAX_FUNCTIONS-1) {
        fcs[ix][i] = fcs[ix][i + 1];
      }
      fcs[ix][MAX_FUNCTIONS - 1] = fcs[ix][0];
    }
    fcSet(ix, fcs[ix][1]);
  }

  /// Redo precode
  public function precodeRedo() {
    precode[0] = precode[MAX_FUNCTIONS - 1];
    for (i in 1...MAX_FUNCTIONS) {
      precode[MAX_FUNCTIONS - i] = precode[MAX_FUNCTIONS - 1- i];
    }
    precodeSet(precode[1]);
  }

  /// Redo fcs[ix]
  public function fcRedo(ix:Int) {
    fcs[ix][0] = fcs[ix][MAX_FUNCTIONS - 1];
    for (i in 1...MAX_FUNCTIONS) {
      fcs[ix][MAX_FUNCTIONS - i] = fcs[ix][MAX_FUNCTIONS - 1- i];
    }
    fcSet(ix, fcs[ix][1]);
  }

  public function fcChange(source:Int, target:Int) {
    var tmp = fcs[source];
    fcs[source] = fcs[target];
    fcs[target] = tmp;
    fcSet(source, fcs[source][0]);
    fcSet(target, fcs[target][0]);
  }

  ///
  public function setCanvasSize(size:Int) {
    this.canvasSize = size;
    canvasSizeCalc();
    save();
  }

  /// Returns the value of fcs[ix] for values 'x', 'y'
  public function fCalc(ix:Int, x0:Float, y0:Float):Int {
    var x:Float = x0 / canvasw;
    var y:Float = y0 / canvash;
    var fr:Float = js.Lib.eval(fcs2[ix]);
    if (fr >= 1) {
      return 255;
    }
    if (fr < 0) {
      return 0;
    }
    return Math.floor(fr * 256);
  }

  public function saveFs():String {
    return B64.encode(Json.from([
      precode[0], fcs[0][0], fcs[1][0], fcs[2][0]
    ]));
  }

  public function loadFs(fss:String) {
    var fs:Array<String> = Json.to(B64.decode(fss));
    precodeSet(fs[0]);
    fcSet(0, fs[1]);
    fcSet(1, fs[2]);
    fcSet(2, fs[3]);
  }

  public function serialize():Array<Dynamic> {
    return [language, precodeShow, precode, fcs, canvasSize, [lastx, lasty]];
  }

  function save() {
    Store.put(StorePrefix + "data", Json.from(serialize()));
  }

  public static function restore(s:Array<Dynamic>):Model {
    return new Model(s[0], s[1], s[2], s[3], s[4], s[5]);
  }

  public static function mk():Model {
//    Store.del(StorePrefix + "data");

    var data = Store.get(StorePrefix + "data");
    if (data == null) {
      var language = "es";
      var precodeShow = false;
      var precode = It.range(MAX_FUNCTIONS).map(It.f("")).to();
      var fcs = It.range(3).map(It.f(
        It.range(MAX_FUNCTIONS).map(It.f(EMPTY_INSTRUCTION)).to()
      )).to();
      var canvasSize = 1;
      var lastCoor = [0.0, 0.0];
      var model = new Model(
        language, precodeShow, precode, fcs, canvasSize, lastCoor
      );
      model.save();
      return model;
    }
    return restore(Json.to(data));
  }

}
