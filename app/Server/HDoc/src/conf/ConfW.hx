/*
 * Copyright 20-May-2016 ºDeme
 *
 * This file is part of 'HxDoc'.
 *
 * 'HxDoc' is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * 'HxDoc' is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with 'HxDoc'.  If not, see <http://www.gnu.org/licenses/>.
 */

import dm.Ui;
import dm.Ui.Q;
import dm.I18n;
import dm.I18n._;
import dm.It;
import Fields;

class ConfW {
  var sources:Array<PathsData>;

  public function new (sources:Array<PathsData>) {
    this.sources = sources;
  }

  public function show () {
    Dom.body.removeAll()
      .add(Q("h2")
        .att("align", "center")
        .text(_("Libraries")))
      .add(
        Q("table")
          .att("class", "border")
          .att("border", "0")
          .att("align", "center")
          .att("style", "background-color: rgb(255, 250, 250)")
          .add(Q("tr")
            .add(Q("td")
              .add(Dom.img("new").att("style", "vertical-align:-15%")))
            .add(Q("td")
              .att("id", "newEnter")
              .att("colspan", "2")
              .att("align", "center")
              .add(Q("button")
                .att("id", "newEnterBt")
                .add(Dom.img("enter").att("style", "vertical-align:-10%"))
                .on(CLICK, function (ev) {
                    Conf.newPath(
                      sources, Q("#nameIn").getValue(), Q("#pathIn").getValue()
                    );
                  })))
            .add(Q("td").att("id", "newName")
              .add(Ui.field("pathIn").att("id", "nameIn").att("size", "20")))
            .add(Q("td").att("id", "newPath")
              .add(Ui.field("newEnterBt")
                .att("id", "pathIn").att("size", "60")))
            .add(Q("td")))
          .add(Q("tr")
            .add(Q("td").att("id", "titleInOut").att("width", "18px")
              .add(
                Ui.link(function (ev) { Conf.changeShowAll(); })
                  .add(Dom.img(Conf.getShowAll() ? "out" : "in"))
              ))
            .add(Q("td").add(Dom.img("blank")).att("width", "18px"))
            .add(Q("td").add(Dom.img("blank")).att("width", "18px"))
            .add(Q("td").html("&nbsp;&nbsp;<b>" + _("Name") + "</b>"))
            .add(Q("td").html("&nbsp;&nbsp;<b>" + _("Path") + "</b>"))
            .add(Q("td").add(Dom.img("blank")))
            )
          .addIt(
            (sources.length > 0
            ? It.from(sources).filter(function (p) {
                return p.visible || Conf.getShowAll();
              }).sort(function (p1, p2) {
                var n1 = p1.name.toUpperCase();
                var n2 = p2.name.toUpperCase();
                return n1 > n2 ? 1 : n1 < n2 ? -1 : 0;
              }).map(function (entry) {
                var name = entry.name;
                var path = entry.path;
                var sel = entry.visible;
                var error = !entry.existing;

                return Q("tr")
                  .add(Q("td").att("id", name + ":InOut")
                    .add(Ui.link(function (ev) {
                      Conf.selPath(name, sel ? false : true, !error);
                    }).add(Dom.img(sel ? "out" : "in"))))
                  .add(Q("td").att("id", name + ":Modify")
                    .add(
                      Ui.link(function (ev) {
                        Conf.modifyBegin(this, name);
                      })
                        .add(Dom.img("edit"))
                    ))
                  .add(Q("td").att("id", name + ":Delete")
                    .add(
                      Ui.link(function (ev) { Conf.deletePath(name); })
                        .add(Dom.img("delete"))
                    ))
                  .add(
                    Q("td").att("class", "border").att("id", name + ":Name")
                      .text(
                        name.length > 20 ? name.substring(0, 17) + "..." : name
                      )
                  )
                  .add(
                    Q("td").att("class", "border").att("id", name + ":Path")
                      .text(
                        path.length > 60 ? path.substring(0, 57) + "..." : path
                      )
                  )
                  .add(
                    Q("td").att("id", name + ":Error")
                      .add(error ? Dom.img("error") : Dom.img("well"))
                  );
              })
            : It.from([
                Q("tr")
                  .add(Q("td")
                    .att("colspan", "6")
                    .att("align", "center")
                    .att("class", "border")
                    .text(_("There are no libraries")))
              ])
            )
          )
        )
      .add(Q("p").att("style", "text-align:center")
        .add(Ui.link(function (ev) { Conf.changeLang(); })
          .att("class", "link")
          .html(I18n.format(_("Change Language to %0"),
            [Global.getLanguage() == "es" ? "EN" : "ES"])))
        .add(Q("span").html("&nbsp;|&nbsp;"))
        .add(Ui.link(function (ev) { Conf.changePass(); })
          .att("class", "link")
          .html(_("Change Password")))
      );

    Q("#nameIn").e.focus();
  }

  /// Modifies page for allowing to modify path entry.
  ///   control
  ///   pathName : Path to modify
 public function modifyBegin (pathName:String):Void {

    var sourceIt =  It.from(sources).filter(function (p) {
      return p.visible || Conf.getShowAll();
    });

    Q("#newEnter").removeAll().add(
      Dom.lightImg("enter").att("style", "vertical-align:-12%")
    );
    Q("#nameIn").value("").disabled(true);
    Q("#pathIn").value("").disabled(true);

    Q("#titleInOut").removeAll().add(
      Dom.lightImg(Conf.getShowAll() ? "out" : "in")
    );

    sourceIt.each(function (source) {
      var name = source.name;
      var path = source.path;
      var shown = source.visible;

      if (name == pathName) {
        Q("#" + name + ":InOut").removeAll().add(Dom.img("blank"));
        Q("#" + name + ":Modify").removeAll()
          .add(Ui.link(function (ev) {
              js.Browser.location.assign("");
            }).add(Dom.img("cancel")));
        Q("#" + name + ":Delete").removeAll()
          .add(Ui.link(function (ev) {
            Conf.modifyPath(
              sources,
              name,
              Q("#nameModify").getValue(),
              path,
              Q("#pathModify").getValue()
            );
          })
            .add(Dom.img("enter")));
        Q("#" + name + ":Name").removeAll()
          .add(Ui.field("pathModify")
            .att("id", "nameModify")
            .att("size", "20")
            .value(name));
        Q("#" + name + ":Path").removeAll()
          .add(Ui.field("nameModify")
            .att("id", "pathModify")
            .att("size", "60")
            .value(path));
        Q("#nameModify").e.focus();
      } else {
        Q("#" + name + ":InOut").removeAll().add(Dom.lightImg(
          shown ? "out" : "in"
        ));
        Q("#" + name + ":Modify").removeAll().add(Dom.lightImg("edit"));
        Q("#" + name + ":Delete").removeAll().add(Dom.lightImg("delete"));
      }
    });

  };

}
