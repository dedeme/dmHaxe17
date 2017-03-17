/*
 * Copyright 09-Mar-2017 ºDeme
 * GNU General Public License - V3 <http://www.gnu.org/licenses/>
 */

import dm.Client;

typedef PageIdRp = { id:String }

typedef SelRq = { name:String, selected:Bool }

typedef AddRq = { name:String, path:String }

typedef DelRq = { name:String }

typedef ModifyRq = {
  oldName:String, newName:String, path:String
}
