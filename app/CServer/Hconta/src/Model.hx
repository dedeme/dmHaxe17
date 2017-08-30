/*
 * Copyright 09-Jul-2017 ºDeme
 * GNU General Public License - V3 <http://www.gnu.org/licenses/>
 */

/// Global data for all pages
using StringTools;
import dm.It;
import dm.Tuple;
import dm.Client;
import model.Action;
import model.Dentry;

class Model {
  public var client:Client;
  public var language:String;
  /// Manu option
  public var page:String;
  public var year:String;
  public var isLastYear:Bool;

  public var groups:Array<Array<String>>;
  public var subgroups:Array<Array<String>>;
  public var accounts:Array<Array<String>>;
  public var subaccounts:Array<Array<String>>;
  public var diary:Array<Dentry>;

  /// Root (""), group (1 char), subgroup (2 chars) or account (3 chars)
  /// selected to show.
  public var planItem:String;

  // Diary index
  var diaryIx:Int;

  /// Creates a client from server reponse ('rp')
  public function new(client:Client, rp:Map<String, Dynamic>) {
    this.client = client;
    language = rp.get("language");
    page = rp.get("page");
    year = rp.get("year");
    isLastYear = rp.get("isLastYear");

    groups = [
      ["1", "Financiación básica"],
      ["2", "Inmovilizado"],
      ["3", "Existencias"],
      ["4", "Acreedores y deudores"],
      ["5", "Cuentas financieras"],
      ["6", "Compras y gastos"],
      ["7", "Ventas e ingresos"],
      ["8", "Gastos del patrimonio neto"],
      ["9", "Ingresos del patrimonio neto"]
    ];
    subgroups = [];
    accounts = [];
    subaccounts = [];
    diary = [];
    Actions.restore(rp.get("actions")).each(It.f(processAction(_1)));

    var tmp = rp.get("planItem");
    planItem = tmp == null ? "" : tmp;

    diaryIx = 1;
  }

  /// Process an action
  public function processAction(action:Action) {
    switch (action) {
      case Nop: {};
      case AddSubgroup(id, name): subgroups.push([id, name]);
      case AddAccount(id, name, summary): accounts.push([id, name, summary]);
      case AddSubaccount(id, name): subaccounts.push([id, name]);
      case ModSubgroup(id, name):
        It.from(subgroups).find(It.f(_1[0] == id))[1] = name;
      case ModAccount(id, name, summary): {
        var acc = It.from(accounts).find(It.f(_1[0] == id));
        acc[1] = name;
        acc[2] = summary;
      }
      case ModSubaccount(id, name):
        It.from(subaccounts).find(It.f(_1[0] == id))[1] = name;
      case DelSubgroup(id): {
        subgroups = It.from(subgroups).filter(It.f(_1[0] != id)).to();
        accounts = It.from(accounts).filter(It.f(!_1[0].startsWith(id))).to();
        subaccounts = It.from(subaccounts)
          .filter(It.f(!_1[0].startsWith(id))).to();
      }
      case DelAccount(id): {
        accounts = It.from(accounts).filter(It.f(_1[0] != id)).to();
        subaccounts = It.from(subaccounts)
          .filter(It.f(!_1[0].startsWith(id))).to();
      }
      case DelSubaccount(id):
        subaccounts = It.from(subaccounts).filter(It.f(_1[0] != id)).to();
      case AddDiary(entry): diary.push(entry);
    }
  }

  inline public function formatAcc(acc:String):String {
    return acc.length == 5
      ? acc.substring(0, 3) + "." + acc.substring(3)
      : acc;
  }
}


