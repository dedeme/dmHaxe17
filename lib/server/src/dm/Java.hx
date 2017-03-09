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

/// Java extensions
package dm;

///
class Java {
  /// E.g.:
  ///   var F:Dynamic = Java.type("java.io.File");
  public static function type (klass:String):Dynamic {
    return untyped __js__ ("Java.type(klass)");
  }

  /// Creates a new java object whose constructor does not have paramenters.
  ///   var f = Java.new(F)
  public static function new0 (type:Dynamic):Dynamic {
    return untyped __js__ ("new type()");
  }

  /// Creates a new java object whose constructor take 1 parameter.
  ///   var f = Java.new(F, a)
  public static function new1 (type:Dynamic, p1:Dynamic):Dynamic {
    return untyped __js__ ("new type(p1)");
  }

  /// Creates a new java object whose constructor take 2 parameters.
  ///   var f = Java.new(F, a, b)
  public static function new2 (type:Dynamic, p1:Dynamic, p2:Dynamic):Dynamic {
    return untyped __js__ ("new type(p1, p2)");
  }

  /// Creates a new java object whose constructor take 3 parameters.
  ///   var f = Java.new(F, a, b, c)
  public static function new3 (
    type:Dynamic, p1:Dynamic, p2:Dynamic, p3:Dynamic
  ):Dynamic {
    return untyped __js__ ("new type(p1, p2, p3)");
  }

  /// Creates a new java object whose constructor take 4 parameters.
  ///   var f = Java.new(F, a, b, c, d)
  public static function new4 (
    type:Dynamic, p1:Dynamic, p2:Dynamic, p3:Dynamic, p4:Dynamic
  ):Dynamic {
    return untyped __js__ ("new type(p1, p2, p3, p4)");
  }

  /// Creates a new java object whose constructor take 5 parameters.
  ///   var f = Java.new(F, a, b, c, d, e)
  public static function new5 (
    type:Dynamic, p1:Dynamic, p2:Dynamic, p3:Dynamic, p4:Dynamic, p5:Dynamic
  ):Dynamic {
    return untyped __js__ ("new type(p1, p2, p3, p4, p5)");
  }

}

