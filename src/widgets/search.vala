/* Search.vala
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

namespace ValaXml {
    [GtkTemplate(ui = "/valaxlm/pedromigueldev/github/ui/search.ui")]
    public class Search : Gtk.Box {

        [GtkChild]  public unowned Gtk.Entry entry;
        [GtkChild]  public unowned Gtk.Button search_entry_button;

        [GtkCallback]   private void enter_gest (Gtk.Entry entry) {
            this.search_entry_button.activate ();
        }

        private string _active_url = "";
        public string active_url {
            get { return _active_url; }
            set {
                _active_url = value;
            }
        }

        public void go_search () {
            this.entry.remove_css_class ("error");
            WebKit.WebView current_web_view;

            current_web_view  = ValaXml.WebViewApp.focused_webview;

            if ( !(this.active_url.has_prefix("https://") || this.active_url.has_prefix("http://")) ){
                 this.active_url = "https://" +  this.active_url;
            }

            if (!ValaXml.Utils.verify_url (this.active_url)) {
                this.entry.set_css_classes ({"error"});
                return;
            };

            current_web_view.load_uri (this.active_url);
        }

        public Search () {
        }

        construct {
            entry.set_placeholder_text (_("Search"));
            entry.notify["text"].connect ((e, p) => {
                if (!ValaXml.Utils.verify_url (entry.text) && entry.text != "" ) {
                    this.entry.set_css_classes ({"error"});
                    return;
                };
                this.entry.remove_css_class ("error");
            });
        }

    }

}

