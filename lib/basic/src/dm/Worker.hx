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
 *        Worker.postResponse(Sudoku.mkLevel(e.data));
 *      });
 *  }
 * <i>On client</i>: Object worker is used.
 *  <b>import</b> dm.Worker;
 *  <b>static var</b> sudokuMaker: Worker;
 *  <b>public static function</b> main() {
 *    sudokuMaker = <b>new</b> Worker("sudokuMaker.js");
 *    sudokuMaker.onmessage(<b>function</b>(e) {
 *      var rp = e.data;
 *      Model.last = rp;
 *      saveLast();
 *      View.mainShow();
 *    });
 *    ...
 *  }
 *  ...
 *  <b>public static function</b> newSudoku(ev) {
 *    sudokuMaker.postMessage(Model.data.level);
 *    View.newShow();
 *  }
 * <i>Sequence:</i>
 * <ol>
 * <li>The client program creates an object 'Worker" and sets a function to
 * process responses from server.</li>
 * <li>In same moment 'newSudoku()' is called.</li>
 * <li>'newSudoku()' sends the message 'Model.data.level' to the sever through
 * the 'Worker'.</li>
 * <li>The server receives the message in the function assigned with
 * Worker.onRequest().</li>
 * <li>Server sends a response using Worker.postResponse().</li>
 * <li>Finally the client receive the response in the function indicated in
 * the first point and process it.</li>
 */
package dm;

/// Class to run thread.
class Worker {
  var jsWorker:Dynamic;

  /// Executes the script 'js' in a new thread.
  public function new(js:String) {
    jsWorker = untyped __js__("new Worker(js)");
  }

  /// Prepares funcion 'f' to be executed when client send a "postRequest".
  public function onmessage(f:Dynamic->Void) {
    jsWorker.onmessage = f;
  }

  /// Finalizes 'this'.
  public function terminate() {
    jsWorker.terminate();
  }

  /// Sends a response to client.
  public function postMessage(rp:Dynamic) {
    jsWorker.postMessage(rp);
  }

  /// Prepares function 'f' to be executed when server send a 'postMessage()'.
  public static function onRequest(f:Dynamic->Void) {
    untyped __js__("onmessage=f");
  }

  /// Sends a request to Server.
  public static function postRequest(rp:Dynamic) {
    untyped __js__("postMessage(rp)");
  }

  /// Finalizes thread.
  public static function close() {
    untyped __js__("close()");
  }
}

