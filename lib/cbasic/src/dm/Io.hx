/*
 * Copyright 01-Jul-2017 ºDeme
 * GNU General Public License - V3 <http://www.gnu.org/licenses/>
 */

package dm;

import sys.FileSystem as Fs;
import sys.io.File;
import sys.io.FileInput;
import haxe.io.Bytes;
using StringTools;
import dm.It;

/// Class to manage data fluxes
class Io {
  /// Returns the parent directory of 'path'. If path is "/", it returns null.
  public static function parent(path:String):String {
    if (path == "/") {
      return null;
    } else if (path.endsWith("/")) {
      return parent(path.substring(0, path.length - 1));
    } else {
      var ix = path.lastIndexOf("/");
      return (ix == -1) ? "" : path.substring(0, ix);
    }
  }

  /// Returns the name (last element) of 'path'.If path is "/", it returns null.
  public static function name(path:String):String {
    if (path == "/") {
      return null;
    } else if (path.endsWith("/")) {
      return name(path.substring(0, path.length - 1));
    } else {
      var ix = path.lastIndexOf("/");
      return ix == -1 ? path : path.substring(ix + 1);
    }
  }

  /// Returns the extension of 'path'. Extension is returned with point.
  /// If 'path' does not have extension, it returns "". .If path is "/", it
  /// returns null.
  public static function extension(path:String):String {
    var n = name(path);
    if (n == null) {
      return null;
    }
    var ix = n.lastIndexOf(".");
    return ix == -1 ? "" : n.substring(ix);
  }

  /// Equals to 'name()', but removing extension.
  public static function onlyName(path:String):String {
    var n = name(path);
    if (n == null) {
      return null;
    }
    var ix = n.lastIndexOf(".");
    return ix == -1 ? n : n.substring(0, ix);
  }

  /// Concatenates paths
  public static function cat(paths:Array<String>):String {
    return paths.join("/");
  }

  /// Returns true if 'path' exists
  inline public static function exists(path:String):Bool {
    return Fs.exists(path);
  }

  /// Returns true if 'path' is a directory
  inline public static function isDirectory(path:String):Bool {
    return Fs.isDirectory(path);
  }

  /// Deletes file or directory named 'path' although it is a directory not
  /// empty. If 'path' does not exists it does nothing.
  public static function del(path:String) {
    if (exists(path)) {
      if (isDirectory(path)) {
        for (f in dir(path)) {
          del(cat([path, f]));
        }
        Fs.deleteDirectory(path);
      } else {
        Fs.deleteFile(path);
      }
    }
  }

  /// Creates a directory.
  ///   If parent directory does not exist it creates it.
  ///   If 'path' already exists it does nothing.
  inline public static function mkdir(path:String) {
    Fs.createDirectory(path);
  }

  /// Returns a list with names of files and directories in 'path'. It does not
  /// returns ".' nor '..'.
  inline public static function dir(path:String):Array<String> {
    return Fs.readDirectory(path);
  }

  /// Returns information about 'path'
  inline public static function info(path:String):sys.FileStat {
    return Fs.stat(path);
  }

  /// Appends 's' to 'path'
  public static function append(path:String, s:String) {
    var bs = Bytes.ofString(s);
    var out = File.append(path);
    out.writeFullBytes(bs, 0, bs.length);
    out.flush();
    out.close();
  }

  /// Writes 's' in 'path'
  inline public static function write(path:String, s:String) {
    File.saveContent(path, s);
  }

  /// Copies 'source' to 'target'
  inline public static function copy(source:String, target:String) {
    File.copy(source, target);
  }

  /// Reads 'path' completely
  inline public static function read(path:String):String {
    return File.getContent(path);
  }

  /// Opens 'path' and returns a FileInptu to use with toIt
  inline public static function open(path:String):FileInput {
    return File.read(path, true);
  }

  /// Opens 'path' and returns a FileInptu to use with toItb
  inline public static function openb(path:String):FileInput {
    return File.read(path);
  }

  /// Returns an It over a FileInput returnd by 'open'. Example
  ///   var fi = Io.open("filex");
  ///   var it = Io.toIt(fi);
  ///   it.each(function (l) { trace(l); });
  ///   fi.close();
  public static function toIt(fi:FileInput):It<String> {
    var nextLine = null;
    try {
      nextLine = fi.readLine();
    } catch (e:haxe.io.Eof) {
      nextLine = null;
    }

    return new It(
      function () { return nextLine != null; },
      function () {
        var r = nextLine;
        try {
          nextLine = fi.readLine();
        } catch (e:haxe.io.Eof) {
          nextLine = null;
        }
        return r;
      }
    );
  }

  /// Returns an It over a FileInput returnd by 'openb'. Example
  ///   var fi = Io.openb("filex");
  ///   var it = Io.toItb(fi);
  ///   it.each(function (l) { trace(l); });
  ///   fi.close();
  public static function toItb(fi:FileInput):It<Bytes> {
    var buf = Bytes.alloc(8192);
    var nextBytes = null;
    try {
      var n = fi.readBytes(buf, 0, 8192);
      if (n > 0) {
        nextBytes = Bytes.alloc(n);
        nextBytes.blit(0, buf, 0, n);
      } else {
        nextBytes = null;
      }
    } catch (e:haxe.io.Eof) {
      nextBytes = null;
    }

    return new It(
      function () { return nextBytes != null; },
      function () {
        var r = nextBytes;
        try {
          var n = fi.readBytes(buf, 0, 8192);
          if (n > 0) {
            nextBytes = Bytes.alloc(n);
            nextBytes.blit(0, buf, 0, n);
          } else {
            nextBytes = null;
          }
        } catch (e:haxe.io.Eof) {
          nextBytes = null;
        }
        return r;
      }
    );
  }

  /// Writes a It<Bytes> in 'path'
  public static function writeItb(path:String, it:It<Bytes>) {
    var out = File.write(path);
    it.each(function (bs) {
      out.writeFullBytes(bs, 0, bs.length);
    });
    out.flush();
    out.close();
  }

  /// Appends a It<Bytes> in 'path'
  public static function appendItb(path:String, it:It<Bytes>) {
    var out = File.append(path);
    it.each(function (bs) {
      out.writeFullBytes(bs, 0, bs.length);
    });
    out.flush();
    out.close();
  }

  /// Writes a It<String> in 'path'
  inline public static function writeIt(path:String, it:It<String>) {
    writeItb(path, it.map(function (s) { return Bytes.ofString(s); }));
  }

  /// Appends a It<String> in 'path'
  inline public static function appendIt(path:String, it:It<String>) {
    appendItb(path, it.map(function (s) { return Bytes.ofString(s); }));
  }

  /// Reads a url
  inline public static function http(url:String):String {
    return App.cmd(
      "curl \"" + url + "\" -L --max-redirs 10 --connect-timeout 15 --retry 3 " +
      "--user-agent " +
      "\"Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:32.0) " +
      "Gecko/20100101 Firefox/32.0\";echo \"\""
    );
  }

}
