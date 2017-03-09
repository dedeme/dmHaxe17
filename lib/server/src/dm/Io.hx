/*
 * Copyright 16-May-2016 ºDeme
 *
 * This file is part of 'hxlib'.
 *
 * 'hxlib' is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * 'hxlib' is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with 'hxlib'.  If not, see <http://www.gnu.org/licenses/>.
 */

/// Java extension for handling files
package dm;

import dm.It;
import dm.Java;

///
class Io {
  static var IO:Dynamic = Java.type("dmjava.Io");

  /// Returns a java File object
  public static function file(path:String):Dynamic {
    var F:Dynamic = Java.type("java.io.File");
    return Java.new1(F, path);
  }

  /// Concatenates several paths. 'ss' can be []
  public static function cat(ss:Array<String>):String {
    var F:Dynamic = Java.type("java.io.File");
    function fIt(f:Dynamic, it:It<String>):String {
      return it.reduce(f, function (seed, e) {
        return Java.new2(F, seed, e);
      }).getPath();
    }
    var it = It.from(ss);
    if (it.hasNext()) {
      var f = file(it.next());
      return fIt(f, it);
    }
    return file("").getPath();
  }

  /// Reads all text file 'f'
  public static function read(f:String, charset="UTF-8"):String {
    var IO:Dynamic = Java.type("dmjava.Io");
    return IO.slurp(file(f), charset);
  }

  /// Reads all url file 'url'
  public static function readUrl(url:String, charset="UTF-8"):String {
    var URL:Dynamic = Java.type("java.net.URL");
    var IoIn:Dynamic = Java.type("dmjava.Io.In");
    return IO.slurp(Java.new1(IoIn, Java.new1(URL, url)), charset);
  }

  /// Writes tx in file 'f'
  public static function write(f:String, tx:String, charset="UTF-8"):Void {
    IO.spit(file(f), tx, charset);
  }

  /// Append binary value in 'b41' to 'f'
  public static function append(f:String, b41:String) {
    var Fo = Java.type("java.io.FileOutputStream");
    var B41 = Java.type("cgi.B41");
    var fo:Dynamic = Java.new2(Fo, file(f), true);
    fo.write(B41.decodeBytes(b41));
    fo.close();
  }

  /// Copies a file
  public static function copy(source:String, target:String):Void {
    IO.copy(file(source), file(target));
  }

  /// Makes a symbolic link
  public static function link(lk:String, target:String) {
    var FileSystems = Java.type("java.nio.file.FileSystems");
    var Files = Java.type("java.nio.file.Files");
    Files.createSymbolicLink(
      FileSystems.getDefault().getPath(lk),
      FileSystems.getDefault().getPath(target)
    );
  }

  /// Makes a directorory and its parents if is necessary
  public static function mkdir(path:String):Void {
    file(path).mkdirs();
  }

  /// Returns 'true' if path exists in the file system and is a directory
  public static function isDirectory(path:String):Bool {
    return file(path).isDirectory();
  };

  /// Returns name of files and directories in 'd'
  public static function dirNames(d):Array<String> {
    return file(d).list();
  };

  /// Returns data from 'dir'
  public static function dir(path:String):It<DirEntry> {
    var fs:Array<Dynamic> = file(path).listFiles();
    return It.range(fs.length).map(function (ix) {
      var f = fs[ix];
      return {
        name     : f.getName(),
        isDir    : f.isDirectory(),
        isFile   : f.isFile(),
        length   : f.length(),
        modified : f.lastModified()
     }
    });
  }

  /// Returns user.dir. In web applications returns /cgi/ root
  public static function userDir():String {
    return Java.type("java.lang.System").getProperty("user.dir");
  }

  /// Creates a tmp directory and returns its path
  public static function tmp(
    prefix:String, suffix:String, dir:String
  ):String {
    return Java.type("java.io.File").createTempFile(
      prefix, suffix, file(dir)
    ).getPath();
  }

  /// Remove 'path'. If it is a directory remove all its contents
  public static function del(path:String):Void {
    IO.delete(file(path));
  }

  /// Changes a file path
  public static function rename(sourcePath:String, targetPath:String):Void {
    file(sourcePath).renameTo(file(targetPath));
  }

  /// Returns 'true' if path exists in the file system
  public static function exists(path:String):Bool {
    return file(path).exists();
  }

  /**
  Compresses source to target using a buffer of 4096 bytes and UTF-8 as
  default charset.
    source  : Can be a file or a directory.
    target  : Complete name of file .zip. (e.g. "com.zip")
    filter  : Selector of files. If its value is null it selects all files.
    bf      : Buffer size
    charset : Charset for zip data
  */
  public static function zip(
    source:String, target:String, ?filter:String->Bool,
    bf = 4096, charset="UTF-8"
  ):Void {
    var Z = Java.type("dmjava.io.Zip");
    var FF = Java.type("java.io.FileFilter");
    var f = filter == null
      ? null
      : Java.new1(FF, {
        accept: function (f:Dynamic) { return filter(f.getPath()); }
        });
    Z.zip(file(source), file(target), f, bf, charset);
  }

  /**
  Unzip source in the 'target' directory.

    source  : Zip file with complete name.
    target  : Directory to uncompress.
    buffer  : Buffer size.
    charset : Charset for zip data
    throws : java.io.FileNotFoundException
  */
  public static function unzip(
    source:String, target:String, bf = 4096, charset="UTF-8"
  ):Void {
    var Z = Java.type("dmjava.io.Zip");
    Z.unzip(file(source), file(target), bf, charset);
  }
}

/// Entry returned by function 'dir'
typedef DirEntry = {
  name     : String,
  isDir    : Bool,
  isFile   : Bool,
  length   : Int,
  modified : Int
}
