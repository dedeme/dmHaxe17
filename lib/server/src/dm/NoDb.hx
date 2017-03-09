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
  var serialize:T->Dynamic;
  var restore:Dynamic->T;
  var absolutePath:String;

  /// Parameters:
  ///   server   :
  ///   path     : Data base path relative to [server.root] (e.g. data/conf.db)
  ///   serialize: Function to serialize objects
  ///   restore  : Function to restore objects
  public function new(
    server:Server, path:String,
    serialize:T->Dynamic, restore:Dynamic->T
  ) {
    this.server = server;
    this.path = path;
    this.serialize = serialize;
    this.restore = restore;

    absolutePath = Io.cat([server.root, path]);

    if (!Io.exists(absolutePath)) {
      Io.mkdir(Io.file(absolutePath).getParent());
      Io.write(absolutePath, "");
    }
  }

  /// Reads all the elements
  public function read():It<T> {
    var s = Io.read(absolutePath);
    if (s == "") {
      return It.empty();
    }
    return It.from(s.split("\n")).map(function (e) {
      return restore(Json.to(Cryp.autoDecryp(e)));
    });
  }

  /// Writes it. All table will be changed.
  ///   it: It is a iterator over objects of class T
  public function write(it:It<T>) {
    Io.write(absolutePath, It.join(it.map(function (e) {
      return Cryp.autoCryp(4, Json.from(serialize(e)));
    }), "\n"));
  }

  /// Deletes data base file
  public function delFile() {
    Io.del(absolutePath);
  };

  /// Adds an element
  public function add(e:T) {
    write(read().add(e));
  }

  /// Return an array with every element which passed to 'f' gives 'true'.
  ///   f: It is a function over a object of class T
  public function find(f:T->Bool):Array<T> {
    return read().find(f);
  };

  /// Delete every element which passed to 'f' gives 'true'.
  /// If no such element exits, 'delFirst' does nothing.
  ///   f: It is a function over a object of class T
  public function del(f:T->Bool) {
    write(read().filter(function (e) { return !f(e); }));
  };

  /// Modifies elements with function 'f'
  ///   f: It is a function over an object of class T which
  ///      returns an object of the same class.
  public function modify(f:T->T) {
    write(read().map(f));
  };
}
