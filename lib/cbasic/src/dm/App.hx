/*
 * Copyright 01-Jul-2017 ºDeme
 * GNU General Public License - V3 <http://www.gnu.org/licenses/>
 */

package dm;

/// System configuration and utilities.
class App {
  /// User name
  public static var user(default, null):String = null;
  /// User home
  public static var uhome(default, null):String = null;
  /// Application home
  public static var home(default, null):String = null;

  /// Initializes a normal application.<p>
  /// It requieres acces to 'whoami' and to 'echo $HOME'
  public static function init(appHome:String) {
    user = cmd("whoami");
    uhome = App.cmd("echo $HOME");
    home = Io.cat([uhome, ".dmHaxeApp", appHome]);
    sys.FileSystem.createDirectory(home);
  }

  /// Initializes a cgi application
  public static function cgi(appHome:String) {
    home = appHome;
    sys.FileSystem.createDirectory(home);
  }

  /// Runs synchronically "cmd" and returns its output.
  public static function cmd(cmd:String, ?args:Array<String>):String {
    var pr = new sys.io.Process(cmd, args);
    var out = pr.stdout;
    var r = [];
    try {
      while (true) {
        r.push(out.readLine());
      }
    } catch (e:haxe.io.Eof) {
    }
    pr.close();
    return r.join("\n");
  }
}
