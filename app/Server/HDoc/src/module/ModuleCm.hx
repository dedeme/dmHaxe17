/*
 * Copyright 15-Mar-2017 ºDeme
 * GNU General Public License - V3 <http://www.gnu.org/licenses/>
 */

typedef PageRp = {
  error   : Bool,           // If path does no exist
  packs   : Array<Dynamic>, // it is an Array<PathsData serialized>
  selected: String,         // Pack selected
  path    : String,         // Module path, that is its name.
  page    : String          // It is an IndexEntry serialized
}
