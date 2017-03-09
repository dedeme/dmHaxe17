/*
 * Copyright 05-Mar-2017 ºDeme
 * GNU General Public License - V3 <http://www.gnu.org/licenses/>
 */

/// Basic Ajax communication
package dm;

import dm.Json;
import dm.B41;

/// Basic Ajax communication
class Ajax {
  /// Sends a client request to a server in 'url'.
  ///   url : The target url.
  ///   rq  : An object to send. It will be serialized with Json and
  ///         compress with B41.compress.
  ///   f   : Function to receive the server response. Its Dynamic object is
  ///         unserialized with B41.decompress and restored with Json
  public static function send (
    url:String, rq:Dynamic, f:Dynamic -> Void
  ):Void {
    var request = js.Browser.createXMLHttpRequest();
    request.onreadystatechange = function (e) {
      if (request.readyState == 4) {
        try {
          f(Json.to(B41.decompress(request.responseText)));
        } catch (e:Dynamic) {
          trace(e);
          trace(request.responseText);
          trace(B41.decompress(request.responseText));
        }
      }
    };
    request.open("POST", url, true);
    request.setRequestHeader(
      "Content-Type"
    , "application/x-www-form-urlencoded;charset=UTF-8"
    );
    request.send(B41.compress(Json.from(rq)));
  }

  /// Sends a client request to its server.
  ///   rq  : An object to send. It will be serialized with Json and
  ///         compress with B41.compress.
  ///   f   : Function to receive the server response. Its Dynamic object is
  ///         unserialized with B41.decompress and restored with Json
  public static function autosend (rq:Dynamic, f:Dynamic -> Void):Void {
    send("", rq, f);
  }
}
