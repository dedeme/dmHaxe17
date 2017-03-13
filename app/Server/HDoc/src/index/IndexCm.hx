/*
 * Copyright 10-Mar-2017 ºDeme
 * GNU General Public License - V3 <http://www.gnu.org/licenses/>
 */

import Fields;

typedef ListRp = {
  error : Bool,   // If path does no exist
  packs : Array<Dynamic>, // it is an Array<PathsData serialized>
  tree  : Array<Dynamic>  // It is an IndexEntry serialized
 }
