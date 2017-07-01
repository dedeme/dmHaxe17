/*
 * Copyright 27-May-2017 ºDeme
 * GNU General Public License - V3 <http://www.gnu.org/licenses/>
 */

import dm.Ui;
import dm.Ui.Q;
import dm.I18n._;
import dm.I18n;
import dm.Store;
import lib.Dom0;

/// Expired page.
class Expired {
  // Model -----------------------------

  var appName:String;
  var languageKey:String;

  // View ------------------------------

  function show() {
    var td = "padding:0px 10px 0px 10px;";
    var link = "<a href=''>" + _("here") + "</a>";
    var w = Q("div")
      .add(Q("p").att("style", "text-align:center")
        .html('<big><b>$appName</b></big>'))
      .add(Q("table").att("class", "main")
        .add(Q("tr")
          .add(Q("td")
            .add(Q("table")
              .att("class", "border")
              .att("width", "100%")
              .att("style",
                "background-color: #f8f8f8;" +
                "border-collapse: collapse;")
              .add(Q("tr")
                .add(Q("td")
                  .att("style", td)
                  .html("<p>" + _("Session is expired.") + "<p>" +
                    "<p><b>" +
                    I18n.format(_("Click %0 to continue."),
                      [link]) + "</b></p>")))))));
    Dom0.show(w);
  }

  // Control ---------------------------

  ///
  public function new (appName, languageKey) {
    this.appName = appName;
    this.languageKey = languageKey;

    var lang = Store.get(languageKey);
    lang = lang == null ? "en" : lang;
    var dic = lang == "en" ? I18nData.en() : I18nData.es();
    I18n.init(dic);

    show();
  }
}
