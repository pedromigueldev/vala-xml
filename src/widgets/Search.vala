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


        private string _active_url = "";
        public string active_url {
            get { return _active_url; }
            set {
                _active_url = value;
            }
        }

        [GtkChild] public unowned Gtk.Entry entry;

        [GtkCallback] public void go_search () {
            //get the text
            // verify url
            // get current webview
            // load new content
        }

        public Search () {

        }

    }

}

