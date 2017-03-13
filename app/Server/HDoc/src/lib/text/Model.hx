/*
 * Copyright 12-Mar-2017 ºDeme
 * GNU General Public License - V3 <http://www.gnu.org/licenses/>
 */

package text;

/// Clase base of all the doc elements
class Named {
  public var name(default, null):String;
  public function new(name:String) {
    this.name = name;
  }
  /// Function to use with It
  public static function sort(e1:Named, e2:Named):Int {
    return e1.name > e2.name ? 1 : e2.name > e1.name ? -1 : 0;
  }
}

/// Basic clase of doc.
class HelpElement extends Named {
  public var help(default, null):String;
  public function new(name:String, help:String) {
    super(name);
    this.help = help;
  }
}

// Index page elements -------------------------------------

/// Index page entry
class ModuleOverview extends HelpElement {
  ///
  public function new(name:String, help:String) {
    super(name, help);
  }
}

/// Index page directory
class Pack extends Named {
  ///
  public var modules(default, null):Array<ModuleOverview>;
  ///
  public function new(name:String, modules:Array<ModuleOverview>) {
    super(name);
    this.modules = modules;
  }
}

/// Index page contents
class LibraryHelp {
  /// Modules in root directory
  public var modules(default, null):Array<ModuleOverview>;
  /// Directories
  public var packs(default, null):Array<Pack>;
  ///
  public function new(modules:Array<ModuleOverview>, packs:Array<Pack>) {
    this.modules = modules;
    this.packs = packs;
  }
}

// Documentation page --------------------------------------

/// Final entry of ducumentation
class HelpFinal extends HelpElement {
  public var code:String;
  public function new (name:String, help:String, code:String) {
    super (name, help);
    this.code = code;
  }
}

/// Interface data.<p>
/// The constructor creates an empty class which will have to
/// be completed when the code file is read.
class InterfaceHelp extends HelpFinal {
  public var parameters(default, null):Array<HelpFinal>;
  public var methods(default, null):Array<HelpFinal>;

  public function new(name:String, help:String, code:String) {
    super(name, help, code);
    parameters = new Array<HelpFinal> ();
    methods = new Array<HelpFinal> ();
  }
  /// Number of elements plus one.
  public function count() {
    return 1 + parameters.length + methods.length;
  }
}

/// Class data.<p>
/// The constructor creates an empty class which will have to be
/// completed when the code file is read.
class ClassHelp extends InterfaceHelp {
  public var constructors(default, null):Array<HelpFinal>;
  public var variables(default, null):Array<HelpFinal>;
  public var functions(default, null):Array<HelpFinal>;
  public var macros(default, null):Array<HelpFinal>;

  public function new(name:String, help:String, code:String) {
    super(name, help, code);
    constructors = new Array<HelpFinal>();
    variables = new Array<HelpFinal>();
    functions = new Array<HelpFinal>();
    macros = new Array<HelpFinal>();
  }
  /// Number of elements plus one.
  override public function count() {
    return super.count() + constructors.length + variables.length +
      functions.length + macros.length;
  }
}

/// Abstract data.<p>
/// The constructor creates an empty class which will have to be
/// completed when the code file is read.
class AbstractHelp extends ClassHelp {
  public function new(name:String, help:String, code:String) {
    super(name, help, code);
  }
}

/// All the data of a module doc.<p>
/// The constructor creates an empty class which will have to be
/// completed when the code file is read.
class ModuleHelp extends HelpElement {
  public var interfaces (default, null):Array<InterfaceHelp>;
  public var classes(default, null):Array<ClassHelp>;
  public var abstracts(default, null):Array<AbstractHelp>;
  public var enums (default, null):Array<HelpFinal>;
  public var typedefs (default, null):Array<HelpFinal>;

  /// Intialy ModuleHelp is create with an empty value ("") for the help field.
  /// It can be changed with 'setHelp()'
  public function new (name:String) {
    super (name, "");
    interfaces = new Array<InterfaceHelp> ();
    classes = new Array<ClassHelp> ();
    abstracts = new Array<AbstractHelp> ();
    enums = new Array<HelpFinal> ();
    typedefs = new Array<HelpFinal> ();
  }

  /// Modifies help value
  public function setHelp (help:String) {
    this.help = help;
  }

  /// Count all the elements which appear in the initial index.
  public function count () {
    var r = enums.length + typedefs.length;
    for (i in interfaces) {
      r += i.count ();
    }
    for (c in classes) {
      r += c.count ();
    }
    return r;
  }
}

