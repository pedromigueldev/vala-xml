/* sidebar.vala
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
    [GtkTemplate(ui = "/valaxlm/pedromigueldev/github/ui/sidebar.ui")]
    public class SideBar : Adw.NavigationPage {

        [GtkChild]
        private unowned Gtk.ListBox tab_buttons;
        [GtkChild]
        public unowned Gtk.ToggleButton show_sidebar_button;


        private bool _sidebar_active;
        public bool sidebar_active {
            get { return _sidebar_active; }
            set {
                _sidebar_active = value;
            }
        }

        public SideBar () {
        }

        public WebViewApp add_web_view(string uri, Adw.ViewStack web_container ) {
            WebViewApp web_box = new WebViewApp();
            web_box.web_view.load_uri(uri);

            Gtk.ListBoxRow tab = new ValaXml.Tab (web_box, web_container, tab_buttons);

            this.tab_buttons.append (tab);
            return web_box;
        }

    }
}
