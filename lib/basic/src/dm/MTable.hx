/*
 * Copyright 04-Mar-2016 ºDeme
 * GNU General Public License - V3 <http://www.gnu.org/licenses/>
 */

/// Little memory table
package dm;

/**
<p>Little memory table.</p>
<p>This table consists in rows of strings. Authomaticaly MTable supplies a id
field called "rowId" which can be accessed with the index 0. The "rowId" field
must no be modified by hand.</p>
*/
class MTable {
  ///
  public var fieldNames(default, null):Array<String>;
  /// It has the last rowId assigned plus one.
  public var nextId(default, null):Int;
  ///
  public var data(default, null):Array<Array<Dynamic>>;

  /**
  Constructor.<p>
    fieldNames: They can be accessed by its order number, having the first
                field the number 1. The field 0 matchs with the id number,
                which can be accessed by the name "rowId" too. Therefore, you
                can not use "rowId" as name for another field.
  */
  public function new (fieldNames:Array<String>) {
    this.fieldNames = fieldNames;
    nextId = 0;
    data = [];
  }

  /// Returns MTable row number
  public function size () {
    return data.length;
  }

  /**
  Adds a row to MTable.
    row: A row of values that must mach with fields. It does not include the
         field "rowId" which is generated automaticaly.
  */
  public function addArray (row:Array<Dynamic>):Void {
    if (row.length != fieldNames.length) {
      throw "Field number is not coincident";
    }
    row.unshift(nextId++);
    data.push(row);
  }

  /**
  Adds a row to MTable.
    row: A row of values that must mach with fields. It does not include the
         field "rowId" which is generated automaticaly. Fields not intialized
         will have value null.
  */
  public function add (row:Map<String, Dynamic>):Void {
    var r = [];
    It.from(fieldNames).eachIx(function (e, ix) {
      r[ix] = row[e];
    });
    this.addArray(r);
  }

  /// Returns an It with all values of MTable. "rowId" is in field 0.
  inline public function readArray ():It<Array<Dynamic>> {
    return It.from(data);
  }

  /// Returns an It with all values with fieldNames plus "rowId"
  public function read ():It<Map<String, Dynamic>> {
    return readArray().map(function (row) {
      var m = new Map<String, Dynamic>();
      m.set("rowId", row[0]);
      It.range(fieldNames.length).each(function (ix) {
        m.set(fieldNames[ix], row[ix + 1]);
      });
      return m;
    });
  }

  /// Returns the row with "rowId" or null if "rowId" does not exist.
  public function getArray (rowId:Int):Null<Array<Dynamic>> {
    return readArray().find(function (row) { return row[0] == rowId; });
  }

  /// Returns the row with "rowId" or null if "rowId" does not exist.
  public function get (rowId:Int):Null<Map<String, Dynamic>> {
    var r = readArray().find(function (row) { return row[0] == rowId; });
    return r == null ? null : {
      var m = new Map<String, Dynamic>();
      m.set("rowId", rowId);
      It.range(fieldNames.length).each(function (ix) {
        m.set(fieldNames[ix], r[ix + 1]);
      });
      return m;
    }
  }

  /// Deletes a row
  public function del (rowId:Int):Void {
    data = It.from(data).filter(function (e) {
      return e[0] != rowId;
    }).to();
  }

  /// Modify a row.
  ///   rowId: Row to modify
  ///   row  : Complete row without "rowId"
  public function modifyArray (rowId:Int, row:Array<Dynamic>):Void {
    row.unshift(rowId);
    data = It.from(data).map(function (e) {
      return (e[0] == rowId) ? row : e;
    }).to();
  }

  /// Modify a row.
  ///   rowId: Row to modify
  ///   row  : Map with fields to modify
  public function modify (rowId:Int, row:Map<String, Dynamic>):Void {
    var newRow = getArray(rowId);
    if (newRow == null) {
      return;
    }
    It.from(fieldNames).eachIx(function (e, ix) {
      if (row.exists(e)) {
        newRow[ix + 1] = row.get(e);
      }
    });
    data = It.from(data).map(function (e) {
      return (e[0] == rowId) ? newRow : e;
    }).to();
  }

  /**
  Returns a field value.
    rowId: Row to read
    field: Field to read
  */
  public function getField (rowId:Int, field:String):Dynamic {
    return get(rowId).get(field);
  }

  /**
  Returns a field value.
    rowId: Row to read
    field: Field to read
  */
  public function getFieldArray (rowId:Int, field:Int):Dynamic {
    return getArray(rowId)[field];
  }

  /**
  Sets a field value.
    rowId: Row to read
    field: Field to read
  */
  public function setField (rowId:Int, field:String, value:Dynamic):Void {
    var rc = get(rowId);
    rc.set(field, value);
    modify(rowId, rc);
  }

  /**
  Sets a field value.
    rowId: Row to read
    field: Field to read. First field is the number '1'
  */
  public function setFieldArray (rowId:Int, field:Int, value:Dynamic):Void {
    var rc = getArray(rowId);
    rc[field] = value;
    rc.shift();
    modifyArray(rowId, rc);
  }

  /// Serializes a MTable
  ///   rowSer: Optional. Convert to "Jsonizable" row, including "rowId".
  ///           Usually it will be necessary to make a copy of row.
  public function serialize (?rowSer:Array<Dynamic>->Array<Dynamic>)
  :Array<Dynamic> {
    return [
      nextId,
      fieldNames,
      It.from(data).map(function (row) {
        return rowSer == null ? row : rowSer(row);
      }).to()
    ];
  }

  /// Restores a MTable.
  ///   serial: Array created with serialize
  ///   rowSer: Optional. It is the inverse to "rowSer" of serialize()
  public static function restore (
    serial:Array<Dynamic>, ?rowSer:Array<Dynamic>->Array<Dynamic>
  ):MTable {
    var r = new MTable(serial[1]);
    r.nextId = serial[0];
    r.data = It.from(serial[2]).map(function (row) {
      return rowSer == null ? row : rowSer(row);
    }).to();
    return r;
  }
}
