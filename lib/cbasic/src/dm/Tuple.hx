/*
 * Copyright 04-Mar-2016 ºDeme
 * GNU General Public License - V3 <http://www.gnu.org/licenses/>
 */

/// Classes to store variables of different type
package dm;

/// Tuple of one element.
class Tp1<A> {
  ///
  public var _1(default, null): A;
  ///
  inline public function new (a: A) {
    _1 = a;
  }
}

/// Tuple of two elements.
class Tp2<A, B> extends Tp1<A> {
  ///
  public var _2(default, null): B;
  ///
  public function new (a: A, b: B) {
    super(a);
    _2 = b;
  }
}

/// Tuple of three elements.
class Tp3<A, B, C> extends Tp2<A, B> {
  ///
  public var _3(default, null): C;
  ///
  public function new (a: A, b: B, c: C) {
    super(a, b);
    _3 = c;
  }
}

/// Tuple of four elements.
class Tp4<A, B, C, D> extends Tp3<A, B, C> {
  ///
  public var _4(default, null): D;
  ///
  public function new (a: A, b: B, c: C, d: D) {
    super(a, b, c);
    _4 = d;
  }
}

/// Tuple of five elements.
class Tp5<A, B, C, D, E> extends Tp4<A, B, C, D> {
  ///
  public var _5(default, null): E;
  ///
  public function new (a: A, b: B, c: C, d: D, e: E) {
    super(a, b, c, d);
    _5 = e;
  }
}
