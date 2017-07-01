/*
 * Copyright 23-Mar-2016 ºDeme7
 * GNU General Public License - V3 <http://www.gnu.org/licenses/>
 */

package dm;

import js.html.Image;
import dm.DomObject;
import dm.It;

/// Image loader.
class Tracker {
  var imgs:Array<{id:String, img:DomObject}>;

  /**
   * Load images in background. It create a dictionary
   * {id:String, img:DomObject} where 'id' is the name of the image without
   * the extension.
   * Parameters:
   *  dir  : Relative path of images. By default is "img"
   *  imgs : Array with name of files. If it is a '.png' image, it is not
   *         necessary to put the extension.
   *  Examples of call:
   *    new Tracker(["a", "b.gif", "c"]);
   *    new Tracker("main/img", ["a", "b", "c"]);
   */
  public function new(dir="img", imgs:Array<String>) {
    dir = dir + "/";
    this.imgs = It.from(imgs).map(function (name) {
      var ix = name.indexOf(".");
      return (ix == -1)
        ? {
            id  : name,
            img : new DomObject(new Image()).att("src", dir + name + ".png")
          }
        : {
            id  : name.substring(0, ix),
            img : new DomObject(new Image()).att("src", dir + name)
          };
    }).to();
  }

  /// Retrieves the image with the name 'id' or 'null' if 'id' does not exist.
  public function get(id:String):Null<DomObject> {
    var r = It.from(imgs).find(It.f(_1.id == id));
    return r == null ? null : r.img;
  }

  /// Equals to 'get()' but retrieves a bright image.
  public function light(id:String):Null<DomObject> {
    var r = It.from(imgs).find(It.f(_1.id == id));
    return r == null ? null : r.img.style("opacity:0.4");
  }

  /// Equals to 'get()' but retrieves a bright image.
  public function grey(id:String):Null<DomObject> {
    var r = It.from(imgs).find(It.f(_1.id == id));
    return r == null ? null : r.img.style("filter: grayscale(100%)");
  }

}
