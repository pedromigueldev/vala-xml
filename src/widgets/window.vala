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
    [GtkTemplate(ui = "/valaxlm/pedromigueldev/github/ui/window.ui")]
    public class Window : Adw.Window {

        [GtkChild]  public unowned ValaXml.SideBar ValaXmlSideBar;
        [GtkChild]  public unowned Adw.ViewStack status_page;
        [GtkChild]  public unowned Gtk.Overlay overlay;
        [GtkChild]  public unowned Gtk.Button close_button;

        public SimpleActionGroup actions { get; construct; }
        private GLib.Settings settings = new GLib.Settings ("valaxlm.pedromigueldev.github");

        construct {
            this.settings.bind ("window-width", this, "default-width", SettingsBindFlags.DEFAULT);
            this.settings.bind ("window-height", this, "default-height", SettingsBindFlags.DEFAULT);

            ValaXml.SideBar.load_favorites ((uuid, url) => this.ValaXmlSideBar.add_web_view (url, this.status_page, true, uuid));

            ActionEntry[] ACTION_ENTRIES = {
                    { "add_tab", this.on_click_add },
                    { "search_box", this.on_serach_add },
                    { "refresh", this.refresh_page },
                    { "page_back", this.back_action },
                    { "page_forward", this.forward_action }
            };
            actions = new SimpleActionGroup ();
            actions.add_action_entries (ACTION_ENTRIES, this);
            this.insert_action_group ("win", actions);
        }

        public Window(Gtk.Application app) {

            Object(application: app);

            close_button.clicked.connect(() => {
                ValaXml.SideBar.save_favorites();
                this.destroy();
            });


        }

        private void on_click_add () {
            ValaXml.Dialog dialog = new ValaXml.Dialog (this);
            dialog.open_dialog((url) => ValaXmlSideBar.add_web_view(url, this.status_page));
        }
        private void on_serach_add () {
            if(!(bool) ValaXml.WebViewApp.focused_webview) {
                var url = ValaXmlSideBar.search_bar.active_url;
                ValaXmlSideBar.add_web_view (url, this.status_page);
            }
            ValaXmlSideBar.search_bar.go_search ();
        }

        private void refresh_page () {
            WebViewApp.refresh ();
        }
        private void back_action () {
            WebViewApp.go_back ();
        }
        private void forward_action () {
            WebViewApp.go_forward ();
        }
    }
}

