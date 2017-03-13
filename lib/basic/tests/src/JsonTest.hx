/*
 * Copyright 04-Mar-2016 ºDeme7
 * GNU General Public License - V3 <http://www.gnu.org/licenses/>
 */

import dm.Test;
import dm.Json;

class JsonTest {
  public static function run () {
    var t = new Test("Json");
    t.eq("true", Json.from(true));
    t.eq("false", Json.from(false));
    t.eq("123", Json.from(123));
    t.eq("123.145", Json.from(123.145));
    t.eq("\"\"", Json.from(""));
    t.eq("\"\"", Json.from(""));
    t.eq("\"abc\\t\\nñ\"", Json.from("abc\t\nñ"));
    t.eq("null", Json.from(null));
    t.eq("[]", Json.from([]));
    t.eq("[1]", Json.from([1]));
    t.eq("[\"a\"]", Json.from(["a"]));
    t.eq("[123.56]", Json.from([123.56]));
    t.eq("[true,false]", Json.from([true, false]));
    t.eq("null", Json.from(null));

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

    t.eq (Json.to ("true"), true);
    t.eq (Json.to ("false"), false);
    t.eq (Json.to ("null"), null);
    t.eq (Json.to (Json.from (true)), true);

    t.eq (Json.to (Json.from (0)), 0.0);
    t.eq (Json.to (Json.from (0.)), 0.0);
    t.eq (Json.to (Json.from (.0)), 0.0);
    t.eq (Json.to (Json.from (-0)), 0.0);
    t.eq (Json.to (Json.from (0.)), 0.0);
    t.eq (Json.to (Json.from (-.0)), 0.0);
    t.eq (Json.to (Json.from (214)), 214.0);
    t.eq (Json.to (Json.from (-453)), -453.0);
    t.eq (Json.to (Json.from (214.)), 214.0);
    t.eq (Json.to (Json.from (-453.)), -453.0);
    t.eq (Json.to (Json.from (214.450)), 214.45);
    t.eq (Json.to (Json.from (-453.80)), -453.8);
    t.eq (Json.to (Json.from (-453.80e43)), -4.538e+45);
    t.eq (Json.to (Json.from (453.80e43)), 4.538e+45);
    t.eq (Json.to (Json.from (-453.80e-43)), -4.538e-41);
    t.eq (Json.to (Json.from (453.80e-43)), 4.538e-41);

    t.eq (Json.to ("-4.538e+45"), -4.538e+45);
    t.eq (Json.to ("-4.538e45"), -4.538e+45);
    t.eq (Json.to ("4.538e+45"), 4.538e+45);
    t.eq (Json.to ("4.538e45"), 4.538e+45);
    t.eq (Json.to ("-4.538e-41"), -4.538e-41);
    t.eq (Json.to ("4.538e-41"), 4.538e-41);

    t.eq (Json.to (Json.from ("")), "");
    t.eq (Json.to (Json.from ("a")), "a");
    t.eq (Json.to (Json.from ("abc")), "abc");
    t.eq (Json.to (Json.from ("\\\"\n\t")), "\\\"\n\t");

    t.eq (Json.to (Json.from ([])), []);
    t.eq (dm.It.from (Json.to (Json.from ([3]))).to ()
    , dm.It.from([3]).to ());
    var ar : Array<Dynamic>;
    ar = [3, "a"];
    t.eq (dm.It.from (Json.to (Json.from (ar))).to ()
    , dm.It.from (ar).to ());
    ar = [3, "a", true];
    t.eq (dm.It.from (Json.to (Json.from (ar))).to ()
    , dm.It.from (ar).to ());
    ar = [3, "a", true, null, 128.56];
    t.eq (dm.It.from (Json.to (Json.from (ar))).to ()
    , dm.It.from (ar).to ());

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
    t.eq ('{"one":1,"two":"2"}', Json.from(ob));
    t.eq (1, Json.to(Json.from(ob)).one);
    t.eq ("2", Json.to(Json.from(ob)).two);
    mp = ["one" => 1, "two" => "2"];
    t.eq (Std.string(mp), Std.string(Json.toMap(Json.from(ob))));

    t.log();
  }
}
