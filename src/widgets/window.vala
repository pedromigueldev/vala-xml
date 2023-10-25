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
                this.destroy();
            });

        }
        private void on_click_add () {
            ValaXml.Dialog dialog = new ValaXml.Dialog (this);
            dialog.open_dialog((url) => ValaXmlSideBar.add_web_view(url, this.status_page));
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



    public class WebViewApp : Gtk.Box {
        private static WebKit.WebView _focused_webview;
        public static WebKit.WebView focused_webview {
            set {
                _focused_webview = value;
            }
        }

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

            content_view.set_child(web_view);
            this.append(content_view);

            WebViewApp.focused_webview = this.web_view;
        }

        public static void refresh () {
            WebViewApp._focused_webview.reload ();
        }
        public static bool go_back () {
            if( !WebViewApp._focused_webview.can_go_back () ) return false;
            WebViewApp._focused_webview.go_back ();
            return true;
        }
        public static bool go_forward () {
            if( !WebViewApp._focused_webview.can_go_forward ()) return false;
            WebViewApp._focused_webview.go_forward ();
            return true;
        }
        public static string uri () {
            return WebViewApp._focused_webview.uri;
        }
    }
}
