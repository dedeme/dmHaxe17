/*
 * Copyright 20-May-2017 ºDeme
 * GNU General Public License - V3 <http://www.gnu.org/licenses/>
 */

/// Global data for all pages
package lib;

import dm.CClient;

typedef Configuration = {
  client   : CClient,
  language : String,
  page     : String,
  subPage  : String,
}

