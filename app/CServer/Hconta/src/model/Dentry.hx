/*
 * Copyright 09-Jul-2017 ºDeme
 * GNU General Public License - V3 <http://www.gnu.org/licenses/>
 */

/// Diary entry
package model;

import dm.DateDm;
import dm.Dec;
import dm.Tuple;
import dm.Json;
import dm.It;

/// There are two types of Dentry:
///   DentryNormal: It has data, description, debits and credits
///   DentryNote  : It only has date and description (Used for annotations)
class Dentry {
  public var type(default, null):DentryType;
  public var date(default, null):DateDm;
  public var description(default, null):String;
  /// Tp2 has [Account number, money ammount]
  public var debits(default, null):Array<Tp2<String, Dec>>;
  /// Tp2 has [Account number, money ammount]
  public var credits(default, null):Array<Tp2<String, Dec>>;

  /// Depending on parameters number Dentry can be:
  ///   DentryNormal: With 4 parameters
  ///   DentryNote: With 2 parameters
  public function new(
    date:DateDm, description:String,
    ?debits:Array<Tp2<String, Dec>>, ?credits:Array<Tp2<String, Dec>>
  ) {
    this.type = debits == null ? DentryNote : DentryNormal;
    this.date = date;
    this.description = description;
    this.debits = debits;
    this.credits = credits;
  }

  public function serialize():Array<Dynamic> {
    switch (type) {
      case DentryNote  : return [date.base(), description];
      case DentryNormal: {
        var ds:Array<Array<Dynamic>> = [];
        for (tp in debits) {
          ds.push([tp._1, tp._2.serialize()]);
        };
        var cs:Array<Array<Dynamic>> = [];
        for (tp in credits) {
          cs.push([tp._1, tp._2.serialize()]);
        };
        return [date.base(), description, ds, cs];
      }
    }
  }

  public static function restore(serial:Array<Dynamic>):Dentry {
    switch (serial.length) {
      case 2 :
        return new Dentry(DateDm.fromStr(serial[0]), serial[1]);
      default: {
        var ds:Array<Array<Dynamic>> = serial[2];
        var cs:Array<Array<Dynamic>> = serial[3];
        return new Dentry(
          DateDm.fromStr(serial[0]), serial[1],
          It.from(ds).map(function (e) {
            return new Tp2(e[0], Dec.restore(e[2]));
          }).to(),
          It.from(cs).map(function (e) {
            return new Tp2(e[0], Dec.restore(e[2]));
          }).to()
        );
      }
    }
  }
}

enum DentryType {
  DentryNormal;
  DentryNote;
}
