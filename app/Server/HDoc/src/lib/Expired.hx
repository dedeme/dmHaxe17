/*
 * Copyright 09-Mar-2017 ºDeme
 * GNU General Public License - V3 <http://www.gnu.org/licenses/>
 */

import dm.Ui;
import dm.Ui.Q;
import dm.I18n._;
import dm.I18n;

/// Expired page.
class Expired {

  ///
  public static function show ():Void {
    var td = "padding:0px 10px 0px 10px;";
    var link = "<a href='../conf/index.html'>" + _("here") + "</a>";
    Ui.QQ("body").next()
      .removeAll()
      .add(Q("p").att("style", "text-align:center")
        .html("<big><b>" + Global.app + "</b></big>"))
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
                      [link]) + "</b></p>"))))))
        .add(Q("tr")
          .add(Q("td")
            .add(Q("table").att("class", "main")
              .add(Q("tr")
                .add(Q("td").att("nowrap", true).att("style", "color:#808080")
                  .add(Q("a").att("href", "../doc/about.html")
                    .att("target", "_blank")
                    .html("<small>Help & Credits</small>")))
                .add(Q("td").att("style", "text-align:right;font-size:10px;" +
                    "color:#808080;font-size:x-small;")
                  .html("- © ºDeme. HxDoc (3.0.0) -")))))));

  }
}
