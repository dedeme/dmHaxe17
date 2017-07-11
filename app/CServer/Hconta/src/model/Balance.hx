/*
 * Copyright 07-Jul-2017 ºDeme
 * GNU General Public License - V3 <http://www.gnu.org/licenses/>
 */

package model;

import dm.It;

class Balance {
  /// Balance groups
  public static var groups = [
    ["AA", "ACTIVO NO CORRIENTE"],
    ["AB", "ACTIVO CORRIENTE"],
    ["PA", "FONDOS PROPIOS"],
    ["PB", "PASIVO NO CORRIENTE"],
    ["PC", "PASIVO CORRIENTE"]
  ];
  /// Index of field key in groups
  public static inline var GROUP_KEY = 0;

  /// Index of field name in groups
  public static inline var GROUP_NAME = 1;

  /// P y G entries
  public static var entries = [
    ["AAI", "Inmovilizado intangible"],
    ["AAII", "Inmovilizado material"],
    ["AAIII", "Inversiones inmobiliarias"],
    ["AAV", "Inversiones financieras a largo plazo"],
    ["AAVI", "Activos por impuesto diferido"],
    ["AAVII", "Deudores comerciales no corrientes"],
    ["ABI", "Existencias"],
    ["ABII", "Deudores comerciales y otras cuentas a cobrar"],
    ["ABIV", "Inversiones financieras a corto plazo"],
    ["ABV", "Periodificaciones"],
    ["ABVI", "Efectivo y otros activos liquidos equivalentes"],

    ["PAI", "Capital"],
    ["PAIII", "Reservas"],
    ["PAVII", "Resultado del ejercicio"],

    ["PBI", "Provisiones a largo plazo"],
    ["PBII", "Deudas a largo plazo"],
    ["PBIV", "Pasivos por impuesto diferido"],
    ["PBV", "Periodificaciones a largo plazo"],
    ["PBVI", "Acreedores comerciales no corrientes"],
    ["PBVII", "Deuda con características especiales a largo plazo"],

    ["PCI", "Provisiones a corto plazo"],
    ["PCII", "Deudas a corto plazo"],
    ["PCIV", "Acreedores comerciales y otras cuentas a pagar"],
    ["PCV", "Periodificaciones a corto plazo"],
    ["PCVI", "Deuda con características especiales a corto plazo"]
  ];

  /// Index of field key in entries
  public static inline var ENTRY_KEY = 0;

  /// Index of field name in entries
  public static inline var ENTRY_NAME = 1;

  /// Key must be type "BABIV" to be valid
  public static function validKey(key:String):Bool {
    return It.from(entries).any(It.f(_1[ENTRY_KEY] == key));
  }

  /// Returns group key of a entry key. Key is type "ABIV"
  public static function groupKey(entryKey:String):String {
    return entryKey.substring(0, 2);
  }
}
