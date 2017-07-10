/*
 * Copyright 07-Jul-2017 ºDeme
 * GNU General Public License - V3 <http://www.gnu.org/licenses/>
 */

package lib;

class PyG {
  /// P y G groups
  public static var groups = [
    ["A", "RESULTADO DE EXPLOTACIÓN"],
    ["B", "RESULTADO FINANCIERO"],
    ["C", "RESULTADO ANTES DE IMPUESTOS"],
    ["D", "RESULTADO DEL EJERCICIO"]
  ];
  /// Index of field key in groups
  public static inline var GROUP_KEY = 0;

  /// Index of field name in groups
  public static inline var GROUP_NAME = 1;

  /// P y G entries
  public static var entries = [
    ["01", "Importe neto de la cifra de negocios"],
    ["02", "Variación de existencias"],
    ["03", "Trabajos realizados por la empresa para su activo"],
    ["04", "Aprovisionamientos"],
    ["05", "Otros ingresos de explotación"],
    ["06", "Gastos de personal"],
    ["07", "Otros gastos de explotación"],
    ["08", "Amortización del inmovilizado"],
    ["09", "Imputación de subvenciones "],
    ["10", "Excesos de provisiones"],
    ["11", "Deterioro y resultado por enajenaciones del inmovilizado"],
    ["12", " Otros resultados"],
    ["13", "Ingresos financieros"],
    ["14", " Gastos financieros"],
    ["15", "Variación de valor razonable en instrumentos financieros"],
    ["16", "Diferencias de cambio"],
    ["17", "Deterioro y resultado por enajenaciones de instr. financieros"],
    ["18", "Impuestos"]
  ];

  /// Index of field key in entries
  public static inline var ENTRY_KEY = 0;

  /// Index of field name in entries
  public static inline var ENTRY_NAME = 1;

  /// Key must be type "P03" to be valid
  public static function validKey(key:String):Bool {
    return
      key.length == 3 &&
      key.charAt(0) == "P" && ((
          key.charAt(2) == "0" &&
          key.charAt(3) >= "1" &&
          key.charAt(3) <= "9"
        ) || (
          key.charAt(2) == "1" &&
          key.charAt(3) >= "0" &&
          key.charAt(3) <= "8"
        ));
  }

  /// Returns group key of a entry key. Key is type "03"
  public static function groupKey(entryKey:String):String {
    return entryKey < "13" ? "A" : entryKey < "18" ? "B" : "D";
  }
}
