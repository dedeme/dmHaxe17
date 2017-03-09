/*
 * Copyright 04-Mar-2016 ºDeme7
 * GNU General Public License - V3 <http://www.gnu.org/licenses/>
 */

/// Contains class [It] which is an iterator that iterates over collections
package dm;

import haxe.io.Bytes;
import haxe.io.BytesBuffer;
import dm.Tuple;

/// Class
class It<T> {
  var fhasNext: Void -> Bool;
  var fnext: Void -> T;
  /**
  Constructor.
    hasNext : Function which return true if there are more elements to read.
    next    : Function which return the next elemet of collection.
  */
  public function new(hasNext: Void -> Bool, next: Void -> T) {
    fhasNext = hasNext;
    fnext = next;
  }

  /// Returns [this] with [element] added at end or at [index] if [index] is
  /// not null
  public function add(element : T, ?index : Int) : It<T> {
    var c = 0;
    return index == null
      ? new It(
        function () { return c == 0; },
        function () {
          if (hasNext()) {
            return next();
          }
          ++c;
          return element;
        }
      )
      : new It(
        function () { return c < index || hasNext(); },
        function () {
          if (c <= index) {
            if (hasNext() && c < index) {
              ++c;
              return next();
            }
            c = index + 1;
            return element;
          }
          return next();
        }
      );
  }

  /// Returns [this] with [element] added at begin
  public function add0(element : T) : It<T> {
    var isNotAdded = true;
    return new It(
      function () { return hasNext() || isNotAdded; }
    , function () {
        if (isNotAdded) {
          isNotAdded = false;
          return element;
        }
        return next();
      }
    );
  }

  /// Inserts an iterator in [this] at [index] or at end if [index] is null.
  public function addIt(it : It<T>, ?index : Int) : It<T> {
    var c = 0;
    return new It(
      function () { return hasNext() || it.hasNext();}
    , (index == null
        ? function () { return (hasNext()) ? next() : it.next(); }
        : function () {
          if (c < index) {
            if (hasNext()) {
              ++c;
              return next();
            }
            c = index;
          }
          if (it.hasNext()) {
            return it.next();
          }
          return next();
        }
      )
    );
  }

  /// Returns <b>true</b> if any element of [this] is equals (==) to [e]
  public function contains(e : T) : Bool {
    while (hasNext()) if (next() == e) return true;
    return false;
  }

  /// Returns <b>true</b> if [f] returns <b>true</b> with any element of [this]
  public function containsf(f : T -> Bool) : Bool {
    while (hasNext()) if (f(next())) return true;
    return false;
  }

  /// Returns the number of elements whish give <b>true</b> with [f]
  public function count(f : T -> Bool) : Int {
    return reduce(0, function(seed, element){
      return f(element)? ++seed: seed;
    });
  }

  /// Returns rest of [this] after call [take()]
   public function drop(n : Int) : It<T>{
    var r = take(n);
    while (r.hasNext()) r.next();
    return this;
  }

  /// Returns rest of [It] after call [takeWhile()]
  public function dropWhile(f : T -> Bool) : It<T> {
    return dropUntil(function (e) { return !f(e); });
  }

  /// Returns rest of It after call[ takeUntil()]
  public function dropUntil(f : T -> Bool) : It<T> {
    var lastValue : T = null;
    var nx = true;
    while (true) {
      if (hasNext()) {
        lastValue = next();
        if (f(lastValue)) break;
      } else {
        nx = false;
        break;
      }
    }

    return new It(
      function () { return nx; }
    , function () {
        var r = lastValue;
        if (hasNext()) lastValue = next();
        else nx = false;
        return r;
      }
    );
  }

  /// Aplies [f] to each element of [this]
  public function each(f : T -> Void) : Void {
    while (fhasNext()) f(fnext());
  }

  /**
  It work similar as each(), but can be used with callbacks.<br>
  An example of its use is:
    sources.readArray().ceach(
      function (s, f) {
        server.fileInfo(s[2], function (info) {
          if (info.type != "D") {
            s[3] = false;
            s[4] = false;
          }
          f(); // It is mandatory call 'f' at the end of callback
        });
      }, function () {
        program goes on...
      }
    );
  */
  public function ceach(
    ixf : T -> (Void -> Void) -> Void, f : Void -> Void
  ) : Void {
    if (fhasNext()) {
      ixf(fnext(), function () { ceach(ixf, f); });
    } else {
      f();
    }
  }

  /// Executes [f] with every element of [this]. [f] receives the index
  /// (0-based) each iteration
  public function eachIx(f : T -> Int -> Void) : Void {
    var count = 0;
    while (hasNext()) f(next(), count++);
  }

  /// Works similar as ceach, but passing a counter to 'ixf'
  public function ceachIx(
    ixf : T -> Int -> (Void -> Void) -> Void, f : Void -> Void
  ) : Void {
   function ceach2(ix) {
      if (fhasNext()) {
        ixf(fnext(), ix, function () { ceach2(ix + 1); });
      } else {
        f();
      }
    }
    ceach2(0);
  }

  /// Compares elements with ==
  public function eq(it : It<T>) : Bool {
    var r = true;
    each(function (e) {
      if (!it.hasNext() || e != it.next()) {
        r = false;
        return;
      }
    });
    if (it.hasNext()) return false;
    return r;
  }

  /**
   *   Filters [this], returning a subset of collection.
   *     f      : Function to select values
   */
  public function filter(f : T -> Bool) : It<T> {
    var lastValue : T;
    var nx = true;
    var nextValue = function () {
      while (true) {
        if (hasNext()) {
          lastValue = next();
          if (f(lastValue)) break;
        } else {
          nx = false;
          break;
        }
      }
    }

    nextValue();
    return new It(
      function () { return nx; }
    , function () {
        var r = lastValue;
        nextValue();
        return r;
      }
    );
  }

  /// Returns those elements that gives <b>true</b> with [f].
  public function find(f : T -> Bool) : Array<T> {
    var arr = [];
    while (hasNext()) {
      var r = next();
      if (f(r)) arr.push(r);
    }
    return arr;
  }

  /// Returns those element that gives <b>true</b> with [f], in reverse order
  public function findLast(f : T -> Bool) : Array<T> {
    var arr = [];
    while (hasNext()) {
      var r = next();
      if (f(r)) arr.unshift(r);
    }
    return arr;
  }

  /// Returns <b>true</b> if all elements give <b>true</b> with [f]
  public function all(f : T -> Bool) : Bool {
    while (hasNext()) if (!f(next())) return false;
    return true;
  }

  /// Returns <b>true</b> if some element gives <b>true</b> with [f] */
  public function any(f : T -> Bool) : Bool {
    while (hasNext()) if (f(next())) return true;
    return false;
  }

  /// Returns two copies of [this]
  ///   Creates an array!
  public function duplicate() : Tp2<It<T>, It<T>> {
    var a = this.to();
    return new Tp2(It.from(a), It.from(a));
  }

  /// Return true if there are more elements to read
  public function hasNext() : Bool {
    return fhasNext();
  }

  /// Returns the index of first element that is equals(==) to [e]
  public function index(e : T) : Int {
    var count = 0;
    while (hasNext())
      if (next() == e) return count;
      else ++count;
    return -1;
  }

  /// Returns the index of first element that gives <b>true</b> with [f]
  /// or -1 if [this] has nothing
  public function indexf(f : T -> Bool) : Int {
    var count = 0;
    while (hasNext())
      if (f(next())) return count;
      else ++count;
    return -1;
  }

  /// Returns the index of first element that is equals(==) to [e]
  public function lastIndex(e : T) : Int {
    var count = -1;
    return reduce(-1, function (seed, element) {
      ++count;
      return element == e ? count : seed;
    });
  }

  /// Returns the index of last element that gives <b>true</b> with [f]
  /// or -1 if [this] has nothing
  public function lastIndexf(f : T -> Bool) : Int {
    var count = -1;
    return reduce(-1, function (seed, element) {
      ++count;
      return f(element) ? count : seed;
    });
  }

  /// Inserts [element] when [f] returns <b>true</b>
  public function insert(element : T, f : T -> Bool) : It<T> {
    var isNotInserted = true;
    var insertedNow = true;
    var lastElement : T = null;
    return new It(
      function (){ return insertedNow || hasNext(); }
    , function (){
        if (isNotInserted){
          if (hasNext()){
            lastElement = next();
            if (f(lastElement)) {
              isNotInserted = false;
              return element;
            }
            return lastElement;
          }
          isNotInserted = false;
          insertedNow = false;
          return element;
        }
        if (insertedNow) {
          insertedNow = false;
          return lastElement;
        }
        return next();
      }
    );
  }

  /**
  Insert [element] in index [ix].
    If [ix] < 0 [element] is inserted at begin.
    If [ix] > [size()] [element] is inserted at end.
  */
  public function insertIx(ix : Int, element : T) : It<T> {
    var isNotInserted = true;
    var count = 0;
    return new It(
      function () { return isNotInserted || hasNext(); }
    , function () {
        if (isNotInserted) {
          if (count++ < ix && hasNext()) {
            return next();
          }
          isNotInserted = false;
          return element;
        }
        return next();
      }
    );
  }

  /**
   *   Insert [other] 'It' in index [ix].
   *     If [ix] < 0 [other] is inserted at begin.
   *     If [ix] > [size()] [other] is inserted at end.
   */
  public function insertIt(ix : Int, other : It<T>) : It<T> {
    var isNotInserted = true;
    var count = 0;
    return new It(
      function () { return hasNext() || other.hasNext(); }
    , function () {
        if (isNotInserted) {
          if (count < ix && hasNext()) {
            ++count;
            return next();
          }
          if (other.hasNext()){
            return other.next();
          }
          isNotInserted = false;
        }
        return next();
      }
    );
  }

  /// Returns the iterator whish results of apply 'f' to every element
  /// of 'this'
  public function map<R>(f : T -> R) : It<R> {
    return new It(
      function () { return hasNext(); }
    , function () { return f(next()); }
    );
  }

  /// Returns the iterator whish results of apply 'f1' to first element
  /// of 'this' and f2 to rest
  public function map2<R>(f1 : T -> R, f2 : T -> R) : It<R> {
    var isFirst = true;
    return new It(
      function () { return hasNext(); }
    , function () {
        if (isFirst) {
          isFirst = false;
          return f1(next());
        } else {
          return f2(next());
        }
      }
    );
  }

  /// Returns the next element of collection.
  public function next() : T {
    return fnext();
  }

  /// Returns the result of applying [f]([f]([seed], e1), e2)... over
  /// every element of [this].
  public function reduce<R>(seed : R, f :  R -> T -> R) : R {
    while (hasNext()) {
      seed = f(seed, next());
    }
    return seed;
  }

  /// Returns [this] in reverse order
  ///   Creates an array!
  public function reverse() : It<T> {
    var a = this.to();
    a.reverse();
    return It.from(a);
  }

  /// Returns the number of elements of [this].
  public function size() : Int {
    return reduce(0, function (n, e) { return ++n; });
  }

  /// Sort [this] conforming [compare] function
  ///   Creates an array!
  public function sort(compare : T -> T -> Int) : It<T> {
    var a = this.to();
    a.sort(compare);
    return It.from(a);
  }

  /// Returns an iterator over elements of [this] mixed
  ///   Creates an array!
  public function shuffle() : It<T> {
    var a = this.to();
    var lg = a.length;
    var ni : Int;
    var tmp : T;
    for (i in 0 ... lg) {
      ni = Dec.rnd(lg);
      if (i != ni) {
        tmp = a[i];
        a[i] = a[ni];
        a[ni] = tmp;
      }
    }
    return It.from(a);
  }

  /**
  Returns n first elements.<p>
  If [this] has less elements than 'n' returns all of theirs.<p>
  [this] can be used for the rest of data after consume 'take'.
  */
  public function take(n : Int) : It<T> {
    return new It(
      function () { return n > 0 && hasNext(); }
    , function () {
        --n;
        return next();
      }
    );
  }

  /// Returns the first elements of [it] whish give <b>true</b> with [f]
  public function takeWhile(f : T -> Bool) : It<T> {
    var lastValue : T = null;
    var nx = true;
    if (hasNext()) lastValue = next();
    else nx = false;

    return new It(
      function () { return nx && f(lastValue); }
    , function () {
        var r = lastValue;
        if (hasNext()) lastValue = next();
        else nx = false;
        return r;
      }
    );
  }

  /// Returns the n first elements of [it] whish give <b>false</b> with [f]
  public function takeUntil(f : T -> Bool) : It<T> {
    return takeWhile(function (e) { return !f(e); });
  }

  /// Returns an Array with elements of [this].
  public function to() : Array<T> {
    return reduce(new Array<T>(), function (r, e) {
      r.push(e);
      return r;
    });
  }

  /// Returns a list with elements of [this]
  public function toList() : List<T> {
    return reduce(new List<T>(), function (r, e) {
      r.add(e);
      return r;
    });
  }

  /// Returns a representation of [this]
  public function toString() : String {
    return "[" + It.join(map(function (e) {
      return Std.string(e);
    }), ", ") + "]";
  }

// statics
// ------------------------------------------------------------------

  /// Returns the empty iterator.
  public static function empty<T>() : It<T> {
    return new It(
      function () { return false; }
    , function () { return null; }
    );
  }

  /// Sorts an It of strings
  public static function sortStr(it : It<String>) : It<String> {
    return it.sort(Str.compare);
  };

  /// Sorts an It of strings in locale
  public static function sortStrLocale(it : It<String>) : It<String> {
    return it.sort(Str.localeCompare);
  };

  /// Returns an [It] over nested elements of [it].
  public static function flat<T>(it : It<It<T>>) : It<T> {
    var it2 : It<T> = empty();
    while (it.hasNext() && !it2.hasNext()) {
      it2 = it.next();
    }

    return new It(
      function () { return it2.hasNext(); }
    , function () {
        var r = it2.next();
        if (!it2.hasNext() && it.hasNext()) {
          it2 = it.next();
        }
        return r;
      }
    );
  }

  /// Flats an [It] over [Bytes]
  public static function flatBytes(it : It<Bytes>) : It<Int> {
    return flat(it.map(function (bs) { return fromBytes(bs); }));
  }

  /// Flats a [It] over Strings in an [It] over characters.
  public static function flatStr(it : It<String>) : It<String> {
    return flat(it.map(function (s) { return fromStr(s); }));
  }

  /// Return an [It] from an Iterable.
  public static function from<T>(it: Iterable<T>) : It<T> {
    return fromIterator(it.iterator());
  }

  /// Return an [It] over a Bytes object.
  public static function fromBytes(bs : Bytes) : It<Int> {
    var l = bs.length;
    var c = 0;
    return new It(
      function () { return c < l; }
    , function () { return bs.get(c++); }
    );
  }

  /// Returns an [It] over an Iterator.
  public static function fromIterator<T>(it: Iterator<T>) : It<T> {
    return new It(it.hasNext, it.next);
  }

  /// Returns an [It] over String characters.
  public static function fromStr(s : String) : It<String> {
    var l = s.length;
    var c = 0;
    return new It(
      function () { return c < l; }
    , function () { return s.charAt(c++); }
    );
  }

  public static function keys<T>(map:Map<T, Dynamic>) : It<T> {
    return fromIterator(map.keys());
  }

  /// Returns a string joining elements of [it] whit [separator]. If
  /// [separator] is null its value is ""
  public static function join(it : It<String>, ?separator : String) : String {
    if (separator == null) {
      separator = "";
    }
    var r = new StringBuf();
    if (it.hasNext()) {
      r.add(it.next());
      while (it.hasNext()) {
        r.add(separator);
        r.add(it.next());
      }
    }
    return r.toString();
  }

  /**
   * Integer iterator.
   *  Its values are:
   *  * If [end] = null and [step] = null => from 0 to [begin] step 1
   *  * If [step] = null => from [begin] to [end] step 1
   *  * Else => from [begin] to [end] step [step
   */
  public static function range(begin : Int, ?end : Int, ?step : Int)
  : It<Int> {
    if (end == null) {
      var count = 0;
      return new It(
        function () { return count < begin; }
      , function () { return count++; }
      );
    }

    if (step == null) {
      var count = begin;
      return new It(
        function () { return count < end; }
      , function () { return count++; }
      );
    }

    if (step == 0) return It.empty();
    var count = begin;
    return new It(
      function () { return (step > 0)? count < end : count > end; }
    , function () {
        var r = count;
        count += step;
        return r;
      }
    );
  }

  /// Converts an [It] over bytes in an object Bytes.
  public static function toBytes(it : It<Int>) : Bytes {
    var r = new BytesBuffer();
    while (it.hasNext()) r.addByte(it.next() % 256);
    return r.getBytes();
  }

  /// Converts an [It] over characters in a String.
  public static function toStr(it : It<String>) : String {
    var r = new StringBuf();
    while (it.hasNext()) {
      r.add(it.next());
    }
    return r.toString();
  }

  /// Returns two iterators from one It<Tp2>
  ///   Creates two arrays!
  public static function unzip<A, B>(it : It<Tp2<A, B>>) : Tp2<It<A>, It<B>> {
    var a1 = new Array();
    var a2 = new Array();
    it.each(function (e) {
      a1.push(e._1);
      a2.push(e._2);
    });
    return new Tp2(It.from(a1), It.from(a2));
  }

  /// Returns three iterators from one It<Tp3>
  ///   Creates three arrays!
  public static function unzip3<A, B, C>(it : It<Tp3<A, B, C>>)
  : Tp3<It<A>, It<B>, It<C>> {
    var a1 = new Array();
    var a2 = new Array();
    var a3 = new Array();
    it.each(function (e) {
      a1.push(e._1);
      a2.push(e._2);
      a3.push(e._3);
    });
    return new Tp3(It.from(a1), It.from(a2), It.from(a3));
  }

  /**
  Returns a iterator with elements of [it1] and [it2].<p>
  The number of elements of resultant iterator is the least of both ones.
  */
  public static function zip<A, B>(it1 : It<A>, it2 : It<B>) : It<Tp2<A, B>> {
    return new It(
      function () { return it1.hasNext() && it2.hasNext(); }
    , function () { return new Tp2(it1.next(), it2.next()); }
    );
  }

  /**
  Returns a iterator with elements of [it1], [it2] and [it3].<p>
  The number of elements of resultant iterator is the least of three ones.
  */
  public static function zip3<A, B, C>(it1 : It<A>, it2 : It<B>, it3 : It<C>)
  : It<Tp3<A, B, C>> {
    return new It(
      function () {
        return it1.hasNext() && it2.hasNext() && it3.hasNext();
      }
    , function () {
        return new Tp3(it1.next(), it2.next(), it3.next());
      }
    );
  }

}
