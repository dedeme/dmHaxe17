/*
 * Copyright 06-Mar-2017 ºDeme
 * GNU General Public License - V3 <http://www.gnu.org/licenses/>
 */

import dm.NoDb;
import dm.It;
import Global;

/// Entry of file conf.db
class ConfEntry {
  public var path(default, null):String;
  public var visible(default, null):Bool;
  public var pageId(default, null):String;
  public var lang(default, null):String;

  /**
   * Parameters:
   *    path : Page path. Format:
   *      * "@" -> Configuration page
   *      * "name" -> Index of a path name
   *      * "name@module -> Documentation of a file named module.js
   *      * "name@module:anchor -> Code of a file named module.js
   *    visible : 'true' if every path is visible and 'false' if only paths
   *      marked as 'visible' are visible.
   *    pageId : Identifier to avoid working with several configuration pages
   *             at the same time.
   *    lang : May be "en" or "es"
   */
  public function new(
    path:String, visible:Bool, lang:String
  ){
    this.path = path;
    this.visible = visible;
    this.lang = lang;
  }
  public function serialize():Array<Dynamic> {
    return [path, visible, lang];
  }
  public static function restore(s:Array<Dynamic>):ConfEntry {
    return new ConfEntry(s[0], s[1], s[2]);
  }
  public static function mkNoDb():NoDb<ConfEntry> {
    return new NoDb(
      Global.server(),
      "data/conf.db",
      function (o:ConfEntry) { return o.serialize(); },
      restore
    );
  }
}

/// Entry of file paths.db
class PathsEntry {
  public var name(default, null):String;
  public var path(default, null):String;
  public var visible(default, null):Bool;

  /**
   * Parameters:
   *    name : Path name
   *    path : Path in disk
   *    visible : 'true' if 'path' is visible.
   */
  public function new(
    name:String, path:String, visible:Bool
  ){
    this.name = name;
    this.path = path;
    this.visible = visible;
  }
  public function serialize():Array<Dynamic> {
    return [name, path, visible];
  }
  public static function restore(s:Array<Dynamic>):PathsEntry {
    return new PathsEntry(s[0], s[1], cast(s[2]));
  }
  public static function mkNoDb():NoDb<PathsEntry> {
    return new NoDb(
      Global.server(),
      "data/paths.db",
      function (o:PathsEntry) { return o.serialize(); },
      restore
    );
  }
}

/// Row of path data passed to the client, Used in 'ConfData'
class PathsData {
  public var name(default, null):String;
  public var path(default, null):String;
  public var visible(default, null):Bool;
  public var existing(default, null):Bool;

  /**
   * Parameters:
   *    name : Path name
   *    path : Path in disk
   *    visible : 'true' if 'path' is visible.
   */
  public function new(
    name:String, path:String, visible:Bool, existing:Bool
  ){
    this.name = name;
    this.path = path;
    this.visible = visible;
    this.existing = existing;
  }
  public function serialize():Array<Dynamic> {
    return [name, path, visible, existing];
  }
  public static function restore(s:Array<Dynamic>):PathsData {
    return new PathsData(s[0], s[1], s[2], s[3]);
  }
}

/// Data to 'conf' page
class ConfData {
  public var conf(default, null):ConfEntry;
  public var paths(default, null):Array<PathsData>;

  /**
   * Parameters:
   *    name : Path name
   *    path : Path in disk
   *    visible : 'true' if 'path' is visible.
   */
  public function new(conf:ConfEntry, paths:Array<PathsData>) {
    this.conf = conf;
    this.paths = paths;
  }
  public function serialize():Array<Dynamic> {
    return [
      conf.serialize(),
      It.from(paths).map(function (p) {
        return p.serialize();
      }).to()
    ];
  }
  public static function restore(s:Array<Dynamic>):ConfData {
    return new ConfData(
      ConfEntry.restore(s[0]),
      It.from(s[1]).map(function (s) {
        return PathsData.restore(s);
      }).to()
    );
  }
}

///
typedef FileRq = { path:String }

///
typedef FileRp = { error:Bool, code:String }
