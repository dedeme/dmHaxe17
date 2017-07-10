/*
 * Copyright 04-Mar-2016 ºDeme
 * GNU General Public License - V3 <http://www.gnu.org/licenses/>
 */

import dm.Test;
import dm.MTable;
import dm.Json;

class MTableTest {
  public static function run () {
    var t = new Test("MTable");

    var tb = new MTable(["name", "age"]);
    t.eq(0, tb.readArray().size());
    t.eq(0, tb.read().size());
    tb.addArray(["Peter", 23]);
    t.eq(1, tb.readArray().size());
    t.eq(1, tb.read().size());
    t.eq("[[0,\"Peter\",23]]", Json.from(tb.readArray().to()));
    t.eq("[{\"h\":{\"rowId\":0,\"name\":\"Peter\",\"age\":23}}]",
      Json.from(tb.read().to()));
    tb.add(["name" => "Clare", "age" => 25]);
    tb.add(["name" => "John"]);

    t.eq(0, tb.getArray(0)[0]);
    t.eq("Peter", tb.getArray(0)[1]);
    t.eq(23, tb.getArray(0)[2]);
    t.eq(1, tb.getArray(1)[0]);
    t.eq("Clare", tb.getArray(1)[1]);
    t.eq(25, tb.getArray(1)[2]);
    t.eq(null, tb.getArray(1)[33]);
    t.eq("John", tb.getArray(2)[1]);
    t.eq(null, tb.getArray(2)[2]);

    t.eq(0, tb.get(0)["rowId"]);
    t.eq("Peter", tb.get(0)["name"]);
    t.eq(23, tb.get(0)["age"]);
    t.eq(1, tb.get(1)["rowId"]);
    t.eq("Clare", tb.get(1)["name"]);
    t.eq(25, tb.get(1)["age"]);
    t.eq(null, tb.get(1)["ae"]);
    t.eq("John", tb.get(2)["name"]);
    t.eq(null, tb.get(2)["age"]);

    tb.modify(10, ["name" => "Frank"]);
    t.eq(null, tb.get(10));

    tb.modify(0, ["name" => "Frank"]);
    t.eq(0, tb.getArray(0)[0]);
    t.eq("Frank", tb.getArray(0)[1]);
    t.eq(23, tb.getArray(0)[2]);
    t.eq(1, tb.getArray(1)[0]);
    t.eq("Clare", tb.getArray(1)[1]);
    t.eq(25, tb.getArray(1)[2]);
    t.eq(2, tb.getArray(2)[0]);
    t.eq("John", tb.getArray(2)[1]);
    t.eq(null, tb.getArray(2)[2]);
    t.eq("Frank", tb.get(0)["name"]);
    t.eq(23, tb.get(0)["age"]);
    t.eq(1, tb.get(1)["rowId"]);
    t.eq("Clare", tb.get(1)["name"]);
    t.eq(25, tb.get(1)["age"]);
    t.eq(2, tb.get(2)["rowId"]);
    t.eq("John", tb.get(2)["name"]);
    t.eq(null, tb.get(2)["age"]);

    tb.del(10);
    t.eq(0, tb.getArray(0)[0]);
    t.eq("Frank", tb.getArray(0)[1]);
    t.eq(23, tb.getArray(0)[2]);
    t.eq(1, tb.getArray(1)[0]);
    t.eq("Clare", tb.getArray(1)[1]);
    t.eq(25, tb.getArray(1)[2]);
    t.eq(2, tb.getArray(2)[0]);
    t.eq("John", tb.getArray(2)[1]);
    t.eq(null, tb.getArray(2)[2]);

    tb.del(0);
    t.eq(2, tb.data.length);
    t.eq(1, tb.getArray(1)[0]);
    t.eq("Clare", tb.getArray(1)[1]);
    t.eq(25, tb.getArray(1)[2]);
    t.eq(2, tb.getArray(2)[0]);
    t.eq("John", tb.getArray(2)[1]);
    t.eq(null, tb.getArray(2)[2]);

    var tb2 = MTable.restore(tb.serialize());
    t.eq(2, tb2.data.length);
    t.eq(1, tb2.getArray(1)[0]);
    t.eq("Clare", tb2.getArray(1)[1]);
    t.eq(25, tb2.getArray(1)[2]);
    t.eq(2, tb2.getArray(2)[0]);
    t.eq("John", tb2.getArray(2)[1]);
    t.eq(null, tb2.getArray(2)[2]);

    var tb3 = new MTable(["client", "amount"]);
    tb3.addArray(["Peter", new dm.Dec(45.67, 3)]);
    var tb4 = MTable.restore(
      tb3.serialize(
        function (r) {
          return [r[0], r[1], cast(r[2], dm.Dec).serialize()];
        }
      ),
      function (r) {
        return [r[0], r[1], dm.Dec.restore(r[2])];
      }
    );
    t.eq(0, tb3.getArray(0)[0]);
    t.eq("Peter", tb3.getArray(0)[1]);
    t.eq(new dm.Dec(45.67, 3).toString(),
      cast(tb3.getArray(0)[2], dm.Dec).toString());
    t.eq(0, tb4.getArray(0)[0]);
    t.eq("Peter", tb4.getArray(0)[1]);
    t.eq(new dm.Dec(45.67, 3).toString(),
      cast(tb4.getArray(0)[2], dm.Dec).toString());

    t.log();
  }
}

