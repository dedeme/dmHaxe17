/*
 * Copyright 13-Mar-2016 ºDeme
 * GNU General Public License - V3 <http://www.gnu.org/licenses/>
 */

/// Immutable list
package dm;

import dm.It;

class Ls<T> {
  public var head(default, null):T;
  public var tail(default, null):Ls<T>;
  function new(h:T, t:Ls<T>) {
    head = h;
    tail = t;
  }

  /// Adds an element at the beginning of the list
  inline public function cons(e:T):Ls<T> {
    return new Ls(e, this);
  }

  /// If ix is null, returns (this ++ l)
  inline public function add(l:Ls<T>, ?ix:Int):Ls<T> {
    return from(to().addIt(l.to(), ix));
  }

  /// Returns true, if all the elements give true with [f]
  inline public function all(f:T -> Bool):Bool {
    return to().all(f);
  }

  /// Returns true if some element gives true with [f]
  inline public function any(f:T -> Bool):Bool {
    return to().any(f);
  }

  /// Returns true if any element of [this] is equals (==) to [e]
  inline public function contains(e:T):Bool {
    return to().contains(e);
  }

  /// Returns true if [f] returns true with any element of [this]
  inline public function containsf(f:T -> Bool):Bool {
    return to().containsf(f);
  }

  /// Returns the number of elements whish give true with [f]
  inline public function count(f:T -> Bool):Int {
    return to().count(f);
  }

  /// Returns rest of [this] after call [take ()]
  inline public function drop(n:Int):Ls<T> {
    return from(to().drop(n));
  }

  /// Aplies [f] to each element of [this]
  inline public function each(f:T -> Void):Void {
    to().each(f);
  }

  /// Executes [f] with every element of [this]. [f] receives the index
  /// (0-based) each iteration
  inline public function eachIx(f:T -> Int -> Void):Void {
    to().eachIx(f);
  }

  /// Compares elements with ==
  inline public function eq(l:Ls<T>):Bool {
    return to().eq(l.to());
  }

  /// Filters [this], returning a subset of collection.
  ///   f : Function to select values
  inline public function filter(f:T -> Bool):Ls<T> {
    return from(to().filter(f));
  }

  /// Returns the first element that gives true with [f]
  inline public function find(f:T -> Bool):Null<T> {
    return to().find(f);
  }

  /// Returns the last element that gives true with [f]
  inline public function findLast(f:T -> Bool):Null<T> {
    return to().findLast(f);
  }

  /// Returns those elements that gives true with [f]
  inline public function finds(f:T -> Bool):Array<T> {
    return to().finds(f);
  }

  /// Returns the index of first element that is equals (==) to [e]
  inline public function index(e:T):Int {
    return to().index(e);
  }

  /// Returns the index of first element that gives true with [f]
  /// or -1 if [this] has nothing
  inline public function indexf(f:T -> Bool):Int {
    return to().indexf(f);
  }

  /// Returns the iterator whish results of apply 'f' to every element of
  /// 'this'
  inline public function map<R>(f:T -> R):Ls<R> {
    return from(to().map(f));
  }

  /// Returns the result of applying [f]([f]([seed], e1), e2)... over
  /// every element of [this]
  public function reduce<R>(seed:R, f:R -> T -> R):R {
    return to().reduce(seed, f);
  }

  /// Returns [this] in reverse order
  public function reverse():Ls<T> {
    return to().reduce(empty(), function (seed, e) {
      return seed.cons(e);
    });
  }

  /// Returns the number of elements of [this].
  public function size():Int {
    return to().size();
  }

  /// Returns n first elements.<p>
  /// If [this] has less elements than 'n', returns all of theirs.
  public function take(n:Int):Ls<T> {
    return from(to().take(n));
  }

  /// Returns an iterator over the elements of 'this'
  public function to():It<T> {
    var tmp = this;
    return new It<T> (
      function () { return tmp.tail != null; },
      function () {
        var r = tmp.head;
        tmp = tmp.tail;
        return r;
      }
    );
  }

  /// Returns an array over the elements of 'this'
  public function toArray():Array<T> {
    return to().to();
  }

  /// Returns a representation of 'this'
  public function toString():String {
    return "Ls:[" + toArray().toString() + "]";
  }

  /// Returns an empty Ls
  inline public static function empty<T>():Ls<T> {
    return new Ls(null, null);
  }

  /// Returns a Ls from an iterator
  inline public static function from<T>(it:It<T>):Ls<T> {
    return it.reduce(empty(), function (seed, e) {
      return seed.cons(e);
    }).reverse();
  }

  /// Returns a Ls from an array
  inline public static function fromArray<T>(a:Array<T>):Ls<T> {
    return from(It.from(a));
  }

  /// Returns a string joining elements of [it] whit [separator].
  /// If [separator] is null its value is ""
  inline public static function join(
    l:Ls<String>, ?separator = ""
  ):String {
    return It.join(l.to(), separator);
  }

}

