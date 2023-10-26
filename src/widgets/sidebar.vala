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

        [GtkChild] private unowned Gtk.ListBox tab_container;
        [GtkChild] public unowned Gtk.ToggleButton show_sidebar_button;
        [GtkChild] public unowned ValaXml.Search search_bar;

        private bool _sidebar_active;
        public bool sidebar_active {
            get { return _sidebar_active; }
            set {
                _sidebar_active = value;
            }
        }

        public SideBar () {
        }

        public void add_web_view(string uri, Adw.ViewStack web_container ) {
            ValaXml.WebViewApp web_box = new ValaXml.WebViewApp();
            ValaXml.Tab tab = new ValaXml.Tab (this, web_box, web_container, tab_container);

            web_container.add_named (web_box, web_box.uuid);
            tab_container.append (tab);

            web_box.web_view.load_uri(uri);
            tab.set_web_visible();

            tab_container.get_last_child().focus(Gtk.DirectionType.TAB_FORWARD);
        }

    }
}


