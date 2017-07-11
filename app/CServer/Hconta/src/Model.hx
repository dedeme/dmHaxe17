/*
 * Copyright 09-Jul-2017 ºDeme
 * GNU General Public License - V3 <http://www.gnu.org/licenses/>
 */

/// Global data for all pages
import dm.It;
import dm.CClient;
import model.Action;

class Model {
  public var client:CClient;
  public var language:String;
  public var page:String;
  public var subpage:String;
  public var year:String;
  public var isLastYear:Bool;

  public var groups:Array<Array<String>>;
  public var subgroups:Array<Array<String>>;
  public var accounts:Array<Array<String>>;
  public var subaccounts:Array<Array<String>>;

  public function new(client:CClient, rp:Map<String, Dynamic>) {
    this.client = client;
    language = rp.get("language");
    page = rp.get("page");
    subpage = rp.get("subpage");
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

    Actions.restore(rp.get("actions")).each(It.f(processAction(_1)));

trace(dm.Json.from(subgroups));
trace(dm.Json.from(accounts));
trace(dm.Json.from(subaccounts));
  }

  public function processAction(action:Action) {
    switch (action) {
      case Nop: {};
      case AddSubgroup(id, name): subgroups.push([id, name]);
      case AddAccount(id, name, summary): accounts.push([id, name, summary]);
      case AddSubaccount(id, name): subaccounts.push([id, name]);
    }
  }

}


