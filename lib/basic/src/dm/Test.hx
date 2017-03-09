/*
 * Copyright 04-Mar-2016 ºDeme7
 * GNU General Public License - V3 <http://www.gnu.org/licenses/>
 */

package dm;

import haxe.CallStack;
import dm.Tuple;

/// Class for testing
class Test {
  var name: String;
  var testN = 0;
  var errorN = 0;

  /// Creates a test with its name.
  public function new (name: String) {
    this.name = name;
  }

  function showError (expected: Dynamic, returned: Dynamic) : Void {
    var r = "Error in test " + testN + "\n"
    + "Expected: " + Std.string (expected) + "\n"
    + "Returned: " + Std.string (returned) + "\n"
    + "Stack:\n"
    + CallStack.toString (CallStack.callStack ())
    ;
    trace (r);
  }

  /// Tests if [value] is true.
  public function yes (value: Bool) : Void {
    testN++;
    if (!value) {
      errorN++;
      showError ("true", "false");
    }
  }

  /// Tests if every value in [values] is true.
  public function yess (values: Array<Bool>) : Void {
    for (v in values) { yes (v); };
  }

  /// Tests if [param] is equal to [result].
  ///   Values are serialized and comparated with ==
  public function eq<A> (param: A, result: A) : Void {
    testN++;
    if (haxe.Serializer.run (param) != haxe.Serializer.run (result) ) {
      errorN++;
      showError (param, result);
    }
  }

  /// Tests if pairs of values in [values] all are equals.
  ///   [values] must be pairs [param, result]
  ///   Values are serialized and comparated with ==
  public function eqs<A> (values: Array<Array<A>>) : Void {
    for (v in values) { eq (v[0], v[1]); };
  }

  /// Tests if [param] is different to [result].
  ///   Values are serialized and comparated with !=
  public function neq<A> (param: A, result: A) : Void {
    testN++;
    if (haxe.Serializer.run (param) == haxe.Serializer.run (result) ) {
      errorN++;
      showError (param, "~ " + Std.string(result));
    }
  }

  /// Tests if pairs of values in [values] all are differents.
  ///   [values] must be pairs [param, result]
  ///   Values are serialized and comparated with !=
  public function neqs<A> (values: Array<Array<A>>) : Void {
    for (v in values) { neq (v[0], v[1]); };
  }

  /// Tests if [f] applied to [param] returns [result]
  ///   Values are serialized and comparated with ==
  public function test<A, R> (param: A, result: R
  , f: A -> R) {
    testN++;
    var rserial = haxe.Serializer.run (result);
    var fserial = haxe.Serializer.run (f (param));
    if (fserial != rserial) {
      errorN++;
      showError (result, f (param));
    }
  }

  /// Tests if [f] applied to first element of every tuple [values] returns
  /// its second one.
  ///   Values are serialized and comparated with ==
  public function tests<A, R> (values: Array<Tp2<A, R>>
  , f: A -> R) : Void {
    for (tp in values) { test (tp._1, tp._2, f); };
  }

  /// Similar to test, but using a function over two elements.
  public function test2<A, B, R> (param1: A, param2: B, result: R
  , f: A -> B -> R) : Void {
    testN++;
    var rserial = haxe.Serializer.run (result);
    var fserial = haxe.Serializer.run (f (param1, param2));
    if (fserial != rserial) {
      errorN++;
      showError (result, f (param1, param2));
    }
  }

  /// Similar to test, but using a function over two elements.
  public function test2s<A, B, R> (values: Array<Tp3<A, B, R>>
  , f: A -> B -> R) : Void {
    for (tp in values) { test2 (tp._1, tp._2, tp._3, f); };
  }

  /// Similar to test, but using a function over three elements.
  public function test3<A, B, C, R> (param1: A, param2: B, param3: C, result: R
  , f: A -> B -> C -> R) : Void {
    testN++;
    var rserial = haxe.Serializer.run (result);
    var fserial = haxe.Serializer.run (f (param1, param2, param3));
    if (fserial != rserial) {
      errorN++;
      showError (result, f (param1, param2, param3));
    }
  }

  /// Similar to test, but using a function over three elements.
  public function test3s<A, B, C, R> (values: Array<Tp4<A, B, C, R>>
  , f: A -> B -> C -> R) : Void {
    for (tp in values) { test3 (tp._1, tp._2, tp._3, tp._4, f); };
  }

  /// Similar to test, but using a function over four elements.
  public function test4<A, B, C, D, R> (param1: A, param2: B, param3: C
  , param4: D, result: R, f: A -> B -> C -> D -> R) : Void {
    testN++;
    var rserial = haxe.Serializer.run (result);
    var fserial = haxe.Serializer.run (f (param1, param2, param3, param4));
    if (fserial != rserial) {
      errorN++;
      showError (result, f (param1, param2, param3, param4));
    }
  }

  /// Similar to test, but using a function over four elements.
  public function test4s<A, B, C, D, R> (values: Array<Tp5<A, B, C, D, R>>
  , f: A -> B -> C -> D -> R) : Void {
    for (tp in values) { test4 (tp._1, tp._2, tp._3, tp._4, tp._5, f); };
  }

  /// Returns the result of test.
  public function toString () : String {
    return "Test " + name + " => "
    + "Total: " + Std.string (testN)
    + ". Passed: " + Std.string (testN - errorN)
    + ". Error: " + Std.string (errorN)
    ;
  }

  /// Shows result in console
  public function log () : Void {
    trace (toString());
  }
}
