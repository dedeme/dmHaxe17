/*
 * Copyright 06-Mar-2017 ºDeme
 * GNU General Public License - V3 <http://www.gnu.org/licenses/>
 */

/// Data base with serialized objects
package dm;

import dm.Server;
import dm.Io;
import dm.It;
import dm.Json;
import dm.Cryp;

class NoDb<T> {
  public var server(default, null):Server;
  public var path(default, null):String;
  var key:String;
  var cryp:String -> String;
  var decryp:String -> String;
  var serialize:T->Dynamic;
  var restore:Dynamic->T;
  var absolutePath:String;

  /// Parameters:
  ///   server   :
  ///   path     : Data base path relative to [server.root] (e.g. data/conf.db)
  ///   serialize: Function to serialize objects
  ///   restore  : Function to restore objects
  ///   key      : Key to codify data. If its value is null, data is not
  ///              codified
  public function new(
    server:Server, path:String,
    serialize:T->Dynamic, restore:Dynamic->T,
    ?key:String
  ) {
    this.server = server;
    this.path = path;
    this.serialize = serialize;
    this.restore = restore;
    this.key = key;
    if (key == null) {
      cryp = It.f(_1);
      decryp = It.f(_1);
    } else {
      key = "with any type. As" + key;
      cryp = It.f(Cryp.encode(key, 4, _1));
      decryp = It.f(Cryp.decode(key, _1));
    }

    absolutePath = Io.cat([server.root, path]);

    if (!Io.exists(absolutePath)) {
      Io.mkdir(Io.file(absolutePath).getParent());
      Io.write(absolutePath, "");
    }
  }

  /// Reads all the elements
  public function read():It<T> {
    var s = decryp(Io.read(absolutePath));
    if (s == "") {
      return It.empty();
    }
    return It.from(s.split("\n")).map(It.f(restore(Json.to(_1))));
  }

  /// Writes it. All table will be changed.
  ///   it: It is a iterator over objects of class T
  public function write(it:It<T>) {
    Io.write(
      absolutePath,
      cryp(It.join(it.map(It.f(Json.from(serialize(_1)))), "\n"))
    );
  }

  /// Deletes data base file
  public function delFile() {
    Io.del(absolutePath);
  };

  /// Adds an element
  public function add(e:T) {
    write(read().add(e));
  }

  /// Return an array with the first element which passed to 'f' gives 'true'.
  ///   f: It is a function over a object of class T
  public function find(f:T->Bool):Null<T> {
    return read().find(f);
  };

  /// Delete every element which passed to 'f' give 'true'.
  /// If no such element exits, 'delFirst' does nothing.
  ///   f: It is a function over a object of class T
  public function del(f:T->Bool) {
    write(read().filter(function (e) { return !f(e); }));
  };

  /// Delete all the elements.
  public function clear() {
    Io.write(absolutePath, "");
  };

  /// Modifies elements with function 'f'
  ///   f: It is a function over an object of class T which
  ///      returns an object of the same class.
  public function modify(f:T->T) {
    write(read().map(f));
  };
}
