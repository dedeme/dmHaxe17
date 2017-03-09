/*
 * Copyright 04-Mar-2016 ºDeme7
 * GNU General Public License - V3 <http://www.gnu.org/licenses/>
 */

import dm.Test;
import dm.Json;

class JsonTest {
  public static function run () {
    var t = new Test("Json");
    t.eq("true", Json.fromBool(true));
    t.eq("false", Json.fromBool(false));
    t.eq("123", Json.fromInt(123));
    t.eq("123.145", Json.fromFloat(123.145));
    t.eq("\"\"", Json.fromString(""));
    t.eq("\"\"", Json.fromString(""));
    t.eq("\"abc\\t\\nñ\"", Json.fromString("abc\t\nñ"));
    t.eq("null", Json.fromString(null));
    t.eq("[]", Json.fromArray([]));
    t.eq("[1]", Json.fromArray([1]));
    t.eq("[\"a\"]", Json.fromArray(["a"]));
    t.eq("[123.56]", Json.fromArray([123.56]));
    t.eq("[true,false]", Json.fromArray([true, false]));
    t.eq("null", Json.fromArray(null));

    var mp = new Map<String, Dynamic>();
    t.eq("{}", Json.fromMap(mp));
    mp.set("A", true);
    t.eq("{\"A\":true}", Json.fromMap(mp));
    mp.set("A", 123.45);
    t.eq("{\"A\":123.45}", Json.fromMap(mp));
    mp.set("B", ["b"]);
    t.eq("{\"A\":123.45,\"B\":[\"b\"]}", Json.fromMap(mp));
    t.eq("{\"A\":1,\"B\":2}", Json.fromMap(["A" => 1, "B" => 2]));

    t.eq(1, Json.toMap("{\"A\":1,\"B\":2}").get("A"));

    t.eq (Json.toBool ("true"), true);
    t.eq (Json.toBool ("false"), false);
    t.eq (Json.toArray ("null"), null);
    t.eq (Json.toBool (Json.fromBool (true)), true);

    t.eq (Json.toFloat (Json.fromFloat (0)), 0.0);
    t.eq (Json.toFloat (Json.fromFloat (0.)), 0.0);
    t.eq (Json.toFloat (Json.fromFloat (.0)), 0.0);
    t.eq (Json.toFloat (Json.fromFloat (-0)), 0.0);
    t.eq (Json.toFloat (Json.fromFloat (0.)), 0.0);
    t.eq (Json.toFloat (Json.fromFloat (-.0)), 0.0);
    t.eq (Json.toFloat (Json.fromFloat (214)), 214.0);
    t.eq (Json.toFloat (Json.fromFloat (-453)), -453.0);
    t.eq (Json.toFloat (Json.fromFloat (214.)), 214.0);
    t.eq (Json.toFloat (Json.fromFloat (-453.)), -453.0);
    t.eq (Json.toFloat (Json.fromFloat (214.450)), 214.45);
    t.eq (Json.toFloat (Json.fromFloat (-453.80)), -453.8);
    t.eq (Json.toFloat (Json.fromFloat (-453.80e43)), -4.538e+45);
    t.eq (Json.toFloat (Json.fromFloat (453.80e43)), 4.538e+45);
    t.eq (Json.toFloat (Json.fromFloat (-453.80e-43)), -4.538e-41);
    t.eq (Json.toFloat (Json.fromFloat (453.80e-43)), 4.538e-41);

    t.eq (Json.toFloat ("-4.538e+45"), -4.538e+45);
    t.eq (Json.toFloat ("-4.538e45"), -4.538e+45);
    t.eq (Json.toFloat ("4.538e+45"), 4.538e+45);
    t.eq (Json.toFloat ("4.538e45"), 4.538e+45);
    t.eq (Json.toFloat ("-4.538e-41"), -4.538e-41);
    t.eq (Json.toFloat ("4.538e-41"), 4.538e-41);

    t.eq (Json.toString (Json.fromString ("")), "");
    t.eq (Json.toString (Json.fromString ("a")), "a");
    t.eq (Json.toString (Json.fromString ("abc")), "abc");
    t.eq (Json.toString (Json.fromString ("\\\"\n\t")), "\\\"\n\t");

    t.eq (Json.toArray (Json.fromArray ([])), []);
    t.eq (dm.It.from (Json.toArray (Json.fromArray ([3]))).toString ()
    , dm.It.from([3]).toString ());
    var ar : Array<Dynamic>;
    ar = [3, "a"];
    t.eq (dm.It.from (Json.toArray (Json.fromArray (ar))).toString ()
    , dm.It.from (ar).toString ());
    ar = [3, "a", true];
    t.eq (dm.It.from (Json.toArray (Json.fromArray (ar))).toString ()
    , dm.It.from (ar).toString ());
    ar = [3, "a", true, null, 128.56];
    t.eq (dm.It.from (Json.toArray (Json.fromArray (ar))).toString ()
    , dm.It.from (ar).toString ());

    mp = new Map<String, Dynamic> ();
    t.eq (Std.string (Json.toMap (Json.fromMap (mp)))
    , Std.string(mp));

    mp.set ("A", "");
    t.eq (Std.string (Json.toMap (Json.fromMap (mp)))
    , Std.string(mp));

    mp.set ("B", "cad");
    t.eq (Std.string (Json.toMap (Json.fromMap (mp)))
    , Std.string(mp));

    mp.set ("C", 37);
    t.eq (Std.string (Json.toMap (Json.fromMap (mp)))
    , Std.string(mp));

    mp.set ("D", null);
    t.eq (Std.string (Json.toMap (Json.fromMap (mp)))
    , Std.string(mp));

    mp.set ("D", true);
    t.eq (Std.string (Json.toMap (Json.fromMap (mp)))
    , Std.string(mp));

    mp.set ("D", ["c", "d"]);
    t.eq (Std.string (Json.toMap (Json.fromMap (mp)))
    , Std.string(mp));

    var ob = {one : 1, two : "2"};
    t.eq ('{"one":1,"two":"2"}', Json.fromObject(ob));
    t.eq (1, Json.toObject(Json.fromObject(ob)).one);
    t.eq ("2", Json.toObject(Json.fromObject(ob)).two);
    mp = ["one" => 1, "two" => "2"];
    t.eq (Std.string(mp), Std.string(Json.toMap(Json.fromObject(ob))));

    t.log();
  }
}
