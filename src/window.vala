/* window.vala
 *
 * Copyright 2023 Pedro Miguel
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

using WebKit;
using GLib;

namespace ValaXml {
    [GtkTemplate(ui = "/valaxlm/pedromigueldev/github/ui/gtk/window.ui")]
    public class Window : Adw.Window {

        [GtkChild]
        public unowned ValaXml.SideBar ValaXmlSideBar;
        [GtkChild]
        public unowned Adw.ViewStack status_page;
        [GtkChild]
        public unowned Gtk.Overlay overlay;
        [GtkChild]
        public unowned Gtk.Button close_button;

        public SimpleActionGroup actions { get; construct; }

        construct {
            ActionEntry[] ACTION_ENTRIES = {
                    { "add_tab", this.on_click_add },
            };
            actions = new SimpleActionGroup ();
            actions.add_action_entries (ACTION_ENTRIES, this);
            this.insert_action_group ("win", actions);
        }

        public Window(Gtk.Application app) {

            Object(application: app);

            close_button.clicked.connect(() => {
                this.destroy();
            });

        }

        delegate void Search_page(string response, string url);
        private void open_dialog(Search_page search_page_function){

            var dialog = new ValaXml.Dialog(this);

            dialog.response.connect ((response) => {

                if (response == "cancel") return;
                print(dialog.url);
                search_page_function(response, dialog.url);
            });

            dialog.show ();
        }

        private void on_click_add () {
            on_click_add_call();
        }
        private void on_click_add_call(bool label = false){
            open_dialog((response, url) => {
                var web_view = ValaXmlSideBar.add_web_view(url, status_page);
                this.status_page.add_named (web_view, web_view.uuid);
            });
        }
    }



    public class WebViewApp : Gtk.Box {
        public string uuid = GLib.Uuid.string_random();

        public WebKit.WebView web_view = new WebKit.WebView();
        public Gtk.ScrolledWindow content_view = new Gtk.ScrolledWindow() {
            hexpand = true,
            vexpand = true,
            overflow = Gtk.Overflow.HIDDEN,
            css_classes = { "rounded_wv", "card" }
        };

        public WebViewApp() {
            vexpand = true;
            hexpand = true;
            //margin_top = 13;
            //margin_end = 12;
            //margin_bottom = 12;
            //margin_start = 12;

            content_view.set_child(web_view);
            this.append(content_view);
        }
    }
}
