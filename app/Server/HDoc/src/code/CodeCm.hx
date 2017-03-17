/*
 * Copyright 13-Mar-2017 ºDeme
 * GNU General Public License - V3 <http://www.gnu.org/licenses/>
 */

/// Generation of source code: Communications
import dm.It;

/// Response with source code
typedef PageRp = {
  error   : Bool,           // If path does no exist
  packs   : Array<Dynamic>, // it is an Array<PathsData serialized>
  selected: String,         // Pack selected
  path    : String,         // Module path, that is its name.
  page    : String          // Source code
}
