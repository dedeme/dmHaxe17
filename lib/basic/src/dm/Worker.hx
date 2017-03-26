/*
 * Copyright 22-Mar-2017 ºDeme
 * GNU General Public License - V3 <http://www.gnu.org/licenses/>
 */

/**
 * Management of concurrency.<p>
 * Example of use:<p>
 * <i>On server</i>: Static methods are used.
 *  <b>import</b> dm.Worker;
 *  <b>class</b> SudokuMaker {
 *    <b>public static function</b> main() {
 *      Worker.onRequest(<b>function</b> (e) {
 *        Worker.sendResponse(Sudoku.mkLevel(e.data));
 *      });
 *  }
 * <i>On client</i>: Object worker is used.
 *  <b>import</b> dm.Worker;
 *  <b>static var</b> sudokuMaker: Worker;
 *  <b>public static function</b> main() {
 *    sudokuMaker = <b>new</b> Worker("sudokuMaker.js");
 *    sudokuMaker.onResponse(<b>function</b>(e) {
 *      var rp = e.data;
 *      Model.last = rp;
 *      saveLast();
 *      View.mainShow();
 *    });
 *    ...
 *  }
 *  ...
 *  <b>public static function</b> newSudoku(ev) {
 *    sudokuMaker.sendRequest(Model.data.level);
 *    View.newShow();
 *  }
 * <i>Sequence:</i>
 * <ol>
 * <li>The client program creates an object 'Worker" and sets a function to
 * process responses from server.</li>
 * <li>In some moment 'newSudoku()' is called.</li>
 * <li>'newSudoku()' sends the request to the sever through the method
 * sendRequest of 'Worker'.</li>
 * <li>The server receives the message in the function assigned with
 * Worker.onRequest().</li>
 * <li>Server sends a response using Worker.sendResponse().</li>
 * <li>Finally the client receive the response in the function indicated in
 * the first point and process it.</li>
 * </ol>
 */
package dm;

/// Class to run thread. Worker is the client part.
class Worker {
  var jsWorker:Dynamic;

  /// Executes the script 'js' in a new thread. The scripts is the server part.
  public function new(js:String) {
    jsWorker = untyped __js__("new Worker(js)");
  }

  /// Prepares funcion 'f' to be executed when the server send a response.
  public function onResponse(f:Dynamic->Void) {
    jsWorker.onmessage = f;
  }

  /// Finalizes thread from client.
  public function terminate() {
    jsWorker.terminate();
  }

  /// Sends a request to the server.
  public function sendRequest(rp:Dynamic) {
    jsWorker.postMessage(rp);
  }

  /// Prepares function 'f' to be executed when the client send a request.
  public static function onRequest(f:Dynamic->Void) {
    untyped __js__("onmessage=f");
  }

  /// Sends a response to the client.
  public static function sendResponse(rp:Dynamic) {
    untyped __js__("postMessage(rp)");
  }

  /// Finalizes thread from server.
  public static function close() {
    untyped __js__("close()");
  }
}

